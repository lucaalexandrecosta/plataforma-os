import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/authz/grants.dart';
import '../../platform/context/request_context.dart';
import '../../platform/errors/api_errors.dart';
import '../../platform/outbox/outbox.dart';
import '../../platform/paging/paging.dart';
import 'site_and_contact_rules.dart';

/// Unidades do cliente (`customerSites`, docs/08 §3.1). Mesmo padrão do
/// cadastro de clientes; a unidade nunca troca de cliente.
abstract final class CustomerSiteService {
  static const _manage = 'customers.manage';

  static Future<CustomerSitePage> list(Session session, CustomerSiteFilter? filter, PageRequest? page) async {
    await session.requireAnyRole(internalRoles);
    final f = filter ?? CustomerSiteFilter();
    final q = f.q?.trim();
    final plan = Paging.plan(
      session,
      page,
      resource: 'customer_sites',
      sortable: const {'name', 'createdAt'},
      defaultSort: 'name',
      filterFingerprint: {'customerId': f.customerId?.uuid, 'q': q, 'isActive': f.isActive},
    );

    Expression<dynamic> filters(CustomerSiteTable t) {
      Expression<dynamic> e = Constant.bool(true);
      if (f.customerId != null) e = e & t.customerId.equals(f.customerId);
      if (f.isActive != null) e = e & t.isActive.equals(f.isActive);
      if (q != null && q.isNotEmpty) {
        if (q.length < 2) throw ApiErrors.invalidFilter(session, 'A busca precisa de pelo menos 2 caracteres.');
        final like = likeContains(q);
        e = e & (t.name.ilike(like) | t.code.ilike(like) | t.city.ilike(like) | t.district.ilike(like));
      }
      return e;
    }

    Expression<dynamic> keyset(CustomerSiteTable t) {
      final after = plan.after;
      if (after == null) return Constant.bool(true);
      if (plan.sort == 'createdAt') {
        final v = DateTime.parse(after.sortValue);
        return plan.descending
            ? (t.createdAt < v) | (t.createdAt.equals(v) & (t.id < after.id))
            : (t.createdAt > v) | (t.createdAt.equals(v) & (t.id > after.id));
      }
      final v = after.sortValue;
      return plan.descending
          ? (t.name < v) | (t.name.equals(v) & (t.id < after.id))
          : (t.name > v) | (t.name.equals(v) & (t.id > after.id));
    }

    final rows = await CustomerSite.db.find(
      session,
      where: (t) => filters(t) & keyset(t),
      orderByList: (t) {
        final first = plan.sort == 'createdAt'
            ? (plan.descending ? t.createdAt.desc() : t.createdAt.asc())
            : (plan.descending ? t.name.desc() : t.name.asc());
        return [first, if (plan.descending) t.id.desc() else t.id.asc()];
      },
      limit: plan.fetchLimit,
    );
    final hasMore = rows.length > plan.limit;
    final items = hasMore ? rows.sublist(0, plan.limit) : rows;
    final total = plan.includeTotal
        ? await CustomerSite.db.count(session, where: filters, limit: Paging.totalCap + 1)
        : null;
    final last = hasMore ? items.last : null;
    return CustomerSitePage(
      items: items,
      hasMore: hasMore,
      nextCursor: last == null
          ? null
          : Paging.encode(
              plan,
              sortValue: plan.sort == 'createdAt' ? last.createdAt.toUtc().toIso8601String() : last.name,
              id: last.id,
            ),
      total: total == null ? null : (total > Paging.totalCap ? Paging.totalCap : total),
      totalIsEstimate: total == null ? null : total > Paging.totalCap,
    );
  }

  static Future<CustomerSite> get(Session session, UuidValue id) async {
    await session.requireAnyRole(internalRoles);
    return await CustomerSite.db.findById(session, id) ?? (throw ApiErrors.notFound(session));
  }

  static Future<CustomerSite> create(Session session, CustomerSiteInput input) async {
    await session.requirePermission(_manage);
    final id = input.id;
    if (id != null && !UuidV7.isAcceptable(id.uuid, now: DateTime.now().toUtc())) {
      throw ApiErrors.invalidUuid(session, 'id');
    }
    final draft = _validOrThrow(session, SiteDraft.fromInput(input));
    return session.db.transaction((tx) async {
      final customer =
          await Customer.db.findById(session, input.customerId, transaction: tx) ??
          (throw ApiErrors.notFound(session, 'Cliente não encontrado.'));
      if (!customer.isActive) {
        throw ApiErrors.businessRule(session, 'Cliente inativo: reative-o antes de cadastrar unidades.');
      }
      final now = DateTime.now().toUtc();
      final created = await _translate(
        session,
        () => CustomerSite.db.insertRow(
          session,
          CustomerSite(
            id: id,
            tenantId: session.context.tenantId!,
            customerId: customer.id,
            code: draft.code,
            name: draft.name,
            street: draft.street,
            streetNumber: draft.streetNumber,
            complement: draft.complement,
            district: draft.district,
            city: draft.city,
            state: draft.state,
            postalCode: draft.postalCode,
            countryCode: draft.countryCode,
            latitude: draft.latitude,
            longitude: draft.longitude,
            phone: draft.phone,
            accessNotes: draft.accessNotes,
            isActive: true,
            source: RecordSource.local,
            createdAt: now,
            updatedAt: now,
            version: 1,
          ),
          transaction: tx,
        ),
      );
      await _event(session, tx, 'customer_site.created', created);
      return created;
    });
  }

  static Future<CustomerSite> update(
    Session session,
    UuidValue id,
    CustomerSitePatch patch,
    int expectedVersion,
  ) async {
    await session.requirePermission(_manage);
    return session.db.transaction((tx) async {
      final current = await _currentAt(session, tx, id, expectedVersion);
      final before = SiteDraft.fromSite(current);
      final after = _validOrThrow(session, before.apply(patch));
      final beforeFields = before.toFields();
      final changed = {
        for (final e in after.toFields().entries)
          if (e.value != beforeFields[e.key]) e.key: e.value,
      };
      if (changed.isEmpty) return current;
      if (current.source == RecordSource.erp) {
        final blocked = changed.keys.where(siteMasterFields.contains).toList();
        if (blocked.isNotEmpty) throw ApiErrors.masterFieldReadOnly(session, blocked);
      }
      final updated = await _guarded(
        session,
        tx,
        current,
        expectedVersion,
        (t) => [for (final e in changed.entries) columnValue(t, e.key, e.value)],
      );
      await _event(
        session,
        tx,
        'customer_site.updated',
        updated,
        extra: {'changed_fields': changed.keys.toList()..sort()},
      );
      return updated;
    });
  }

  static Future<CustomerSite> deactivate(Session session, UuidValue id, String reason, int expectedVersion) async {
    await session.requirePermission(_manage);
    final why = reason.trim();
    if (why.isEmpty || why.length > 500) {
      throw ApiErrors.validation(session, [
        FieldError(path: 'reason', code: 'required', message: 'Informe o motivo (até 500 caracteres).'),
      ]);
    }
    return session.db.transaction((tx) async {
      final current = await _currentAt(session, tx, id, expectedVersion);
      if (!current.isActive) return current;
      if (current.source == RecordSource.erp) throw ApiErrors.masterFieldReadOnly(session, ['isActive']);
      final updated = await _guarded(session, tx, current, expectedVersion, (t) => [t.isActive(false)]);
      await _event(session, tx, 'customer_site.deactivated', updated, extra: {'reason': why});
      return updated;
    });
  }

  static Future<CustomerSite> reactivate(Session session, UuidValue id, int expectedVersion) async {
    await session.requirePermission(_manage);
    return session.db.transaction((tx) async {
      final current = await _currentAt(session, tx, id, expectedVersion);
      if (current.isActive) return current;
      if (current.source == RecordSource.erp) throw ApiErrors.masterFieldReadOnly(session, ['isActive']);
      final updated = await _guarded(session, tx, current, expectedVersion, (t) => [t.isActive(true)]);
      await _event(
        session,
        tx,
        'customer_site.updated',
        updated,
        extra: {
          'changed_fields': ['isActive'],
        },
      );
      return updated;
    });
  }

  // ---------------------------------------------------------------------------

  static SiteDraft _validOrThrow(Session session, SiteDraft draft) {
    final r = SiteRules.validate(draft);
    if (r.errors.isNotEmpty) throw ApiErrors.validation(session, r.errors);
    return r.value!;
  }

  static Future<CustomerSite> _currentAt(Session session, Transaction tx, UuidValue id, int expectedVersion) async {
    final current =
        await CustomerSite.db.findById(session, id, transaction: tx, lockMode: LockMode.forNoKeyUpdate) ??
        (throw ApiErrors.notFound(session));
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    return current;
  }

  static Future<CustomerSite> _guarded(
    Session session,
    Transaction tx,
    CustomerSite current,
    int expectedVersion,
    List<ColumnValue<dynamic, dynamic>> Function(CustomerSiteUpdateTable t) values,
  ) async {
    final rows = await CustomerSite.db.updateWhere(
      session,
      columnValues: values,
      where: (t) => t.id.equals(current.id) & t.version.equals(expectedVersion),
      transaction: tx,
    );
    if (rows.isEmpty) throw ApiErrors.versionMismatch(session, current.version + 1);
    return rows.single;
  }

  static ColumnValue<dynamic, dynamic> columnValue(CustomerSiteUpdateTable t, String field, Object? v) =>
      switch (field) {
        'code' => t.code(v as String?),
        'name' => t.name(v! as String),
        'street' => t.street(v as String?),
        'streetNumber' => t.streetNumber(v as String?),
        'complement' => t.complement(v as String?),
        'district' => t.district(v as String?),
        'city' => t.city(v as String?),
        'state' => t.state(v as String?),
        'postalCode' => t.postalCode(v as String?),
        'countryCode' => t.countryCode(v! as String),
        'latitude' => t.latitude(v as double?),
        'longitude' => t.longitude(v as double?),
        'phone' => t.phone(v as String?),
        'accessNotes' => t.accessNotes(v as String?),
        _ => throw ArgumentError.value(field, 'field'),
      };

  static Future<void> _event(
    Session session,
    Transaction tx,
    String type,
    CustomerSite s, {
    Map<String, Object?> extra = const {},
  }) => Outbox.record(
    session,
    tx,
    eventType: type,
    aggregateType: 'customer_site',
    aggregateId: s.id,
    aggregateVersion: s.version,
    payload: {'customer_site_id': s.id.uuid, 'customer_id': s.customerId.uuid, 'source': s.source.name, ...extra},
  );

  static Future<T> _translate<T>(Session session, Future<T> Function() body) async {
    try {
      return await body();
    } on DatabaseUniqueViolationException catch (e) {
      if (e.constraintName == 'customer_sites_pkey') {
        throw ApiErrors.duplicate(session, path: 'id', message: 'Já existe uma unidade com este identificador.');
      }
      rethrow;
    }
  }
}
