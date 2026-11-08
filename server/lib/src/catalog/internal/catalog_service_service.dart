import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/authz/grants.dart';
import '../../platform/context/request_context.dart';
import '../../platform/errors/api_errors.dart';
import '../../platform/paging/paging.dart';
import 'catalog_common.dart';
import 'catalog_rules.dart';

/// Serviços do catálogo (hora técnica, visita, deslocamento). Leitura: papéis
/// internos; escrita: `catalog.manage`. Com `source = erp`, código, nome,
/// descrição, unidade e preço são do ERP; tipo e tempo estimado são locais.
abstract final class CatalogServices {
  static const _sortable = {'name', 'code', 'createdAt'};

  static Future<CatalogServicePage> list(Session session, CatalogServiceFilter? filter, PageRequest? page) async {
    await session.requireAnyRole(internalRoles);
    final f = filter ?? CatalogServiceFilter();
    final q = f.q?.trim();
    final plan = Paging.plan(
      session,
      page,
      resource: 'services',
      sortable: _sortable,
      defaultSort: 'name',
      filterFingerprint: {'q': q, 'isActive': f.isActive, 'kind': f.serviceKind?.name, 'source': f.source?.name},
    );
    if (q != null && q.isNotEmpty && q.length < 2) {
      throw ApiErrors.invalidFilter(session, 'A busca precisa de pelo menos 2 caracteres.');
    }

    Expression<dynamic> filters(CatalogServiceTable t) {
      Expression<dynamic> e = Constant.bool(true);
      if (f.isActive != null) e = e & t.isActive.equals(f.isActive);
      if (f.serviceKind != null) e = e & t.serviceKind.equals(f.serviceKind);
      if (f.source != null) e = e & t.source.equals(f.source);
      if (q != null && q.isNotEmpty) {
        final like = likeContains(q);
        e = e & (t.name.ilike(like) | t.code.ilike(like));
      }
      return e;
    }

    final rows = await CatalogService.db.find(
      session,
      where: (t) =>
          filters(t) &
          switch (plan.sort) {
            'code' => plan.afterCursor(t.code, t.id, (v) => v),
            'createdAt' => plan.afterCursor(t.createdAt, t.id, DateTime.parse),
            _ => plan.afterCursor(t.name, t.id, (v) => v),
          },
      orderByList: (t) => plan.orderBy(switch (plan.sort) {
        'code' => t.code,
        'createdAt' => t.createdAt,
        _ => t.name,
      }, t.id),
      limit: plan.fetchLimit,
    );
    final s = plan.slice(
      rows,
      sortValue: (r) => switch (plan.sort) {
        'code' => r.code,
        'createdAt' => r.createdAt.toUtc().toIso8601String(),
        _ => r.name,
      },
      id: (r) => r.id,
    );
    final total = plan.capTotal(
      plan.includeTotal ? await CatalogService.db.count(session, where: filters, limit: Paging.totalCap + 1) : null,
    );
    return CatalogServicePage(
      items: s.items,
      nextCursor: s.nextCursor,
      hasMore: s.hasMore,
      total: total.total,
      totalIsEstimate: total.isEstimate,
    );
  }

  static Future<CatalogService> get(Session session, UuidValue id) async {
    await session.requireAnyRole(internalRoles);
    return await CatalogService.db.findById(session, id) ?? (throw ApiErrors.notFound(session));
  }

  static Future<CatalogService> create(Session session, CatalogServiceInput input) async {
    await session.requirePermission(CatalogCommon.managePermission);
    CatalogCommon.checkClientId(session, input.id);
    final draft = validOrThrow(session, ServiceDraft.fromInput(input));
    return CatalogCommon.translateUnique(
      session,
      'services',
      'um serviço',
      () => session.db.transaction((tx) async {
        final created = await CatalogService.db.insertRow(
          session,
          newService(session, draft, id: input.id),
          transaction: tx,
        );
        await event(session, tx, 'service.created', created);
        return created;
      }),
    );
  }

  static Future<CatalogService> update(
    Session session,
    UuidValue id,
    CatalogServicePatch patch,
    int expectedVersion,
  ) async {
    await session.requirePermission(CatalogCommon.managePermission);
    return CatalogCommon.translateUnique(
      session,
      'services',
      'um serviço',
      () => session.db.transaction((tx) async {
        final current = await _currentAt(session, tx, id, expectedVersion);
        final before = ServiceDraft.fromService(current);
        final after = validOrThrow(session, before.apply(patch));
        final changed = CatalogCommon.changed(before.toFields(), after.toFields());
        if (changed.isEmpty) return current;
        if (current.source == RecordSource.erp) {
          final blocked = changed.keys.where(serviceMasterFields.contains).toList();
          if (blocked.isNotEmpty) throw ApiErrors.masterFieldReadOnly(session, blocked);
        }
        final updated = await _updateGuarded(
          session,
          tx,
          current,
          expectedVersion,
          (t) => [for (final e in changed.entries) columnValue(t, e.key, e.value)],
        );
        await event(session, tx, 'service.updated', updated, extra: {'changed_fields': changed.keys.toList()..sort()});
        return updated;
      }),
    );
  }

  static Future<CatalogService> deactivate(Session session, UuidValue id, String reason, int expectedVersion) =>
      _setActive(session, id, expectedVersion, active: false, reason: CatalogCommon.requireReason(session, reason));

  static Future<CatalogService> reactivate(Session session, UuidValue id, int expectedVersion) =>
      _setActive(session, id, expectedVersion, active: true);

  static Future<CatalogService> _setActive(
    Session session,
    UuidValue id,
    int expectedVersion, {
    required bool active,
    String? reason,
  }) async {
    await session.requirePermission(CatalogCommon.managePermission);
    return session.db.transaction((tx) async {
      final current = await _currentAt(session, tx, id, expectedVersion);
      if (current.isActive == active) return current;
      if (current.source == RecordSource.erp) throw ApiErrors.masterFieldReadOnly(session, ['isActive']);
      final updated = await _updateGuarded(session, tx, current, expectedVersion, (t) => [t.isActive(active)]);
      await event(
        session,
        tx,
        'service.updated',
        updated,
        extra: {
          'changed_fields': ['isActive'],
          'reason': ?reason,
        },
      );
      return updated;
    });
  }

  // --- usados também pela importação ----------------------------------------

  static ServiceDraft validOrThrow(Session session, ServiceDraft draft) {
    final result = ServiceRules.validate(draft);
    if (result.errors.isNotEmpty) throw ApiErrors.validation(session, result.errors);
    return result.draft!;
  }

  static CatalogService newService(Session session, ServiceDraft d, {UuidValue? id}) {
    final now = DateTime.now().toUtc();
    return CatalogService(
      id: id,
      tenantId: session.context.tenantId!,
      code: d.code,
      name: d.name,
      description: d.description,
      unitCode: d.unitCode,
      defaultPrice: d.defaultPrice,
      estimatedMinutes: d.estimatedMinutes,
      serviceKind: d.serviceKind,
      isActive: true,
      source: RecordSource.local,
      createdAt: now,
      updatedAt: now,
      version: 1,
    );
  }

  static Future<void> event(
    Session session,
    Transaction tx,
    String type,
    CatalogService s, {
    Map<String, Object?> extra = const {},
  }) => CatalogCommon.event(
    session,
    tx,
    type: type,
    aggregateType: 'service',
    id: s.id,
    version: s.version,
    source: s.source,
    isActive: s.isActive,
    extra: extra,
  );

  static ColumnValue<dynamic, dynamic> columnValue(CatalogServiceUpdateTable t, String field, Object? value) =>
      switch (field) {
        'code' => t.code(value! as String),
        'name' => t.name(value! as String),
        'description' => t.description(value as String?),
        'unitCode' => t.unitCode(value! as String),
        'defaultPrice' => t.defaultPrice(value as int?),
        'estimatedMinutes' => t.estimatedMinutes(value as int?),
        'serviceKind' => t.serviceKind(value! as ServiceKind),
        _ => throw ArgumentError.value(field, 'field'),
      };

  static Future<CatalogService> _currentAt(Session session, Transaction tx, UuidValue id, int expectedVersion) async {
    final current =
        await CatalogService.db.findById(session, id, transaction: tx, lockMode: LockMode.forNoKeyUpdate) ??
        (throw ApiErrors.notFound(session));
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    return current;
  }

  static Future<CatalogService> _updateGuarded(
    Session session,
    Transaction tx,
    CatalogService current,
    int expectedVersion,
    List<ColumnValue<dynamic, dynamic>> Function(CatalogServiceUpdateTable t) values,
  ) async {
    final rows = await CatalogService.db.updateWhere(
      session,
      columnValues: values,
      where: (t) => t.id.equals(current.id) & t.version.equals(expectedVersion),
      transaction: tx,
    );
    if (rows.isEmpty) throw ApiErrors.versionMismatch(session, current.version + 1);
    return rows.single;
  }
}
