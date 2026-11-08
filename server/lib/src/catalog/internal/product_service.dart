import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/authz/grants.dart';
import '../../platform/context/request_context.dart';
import '../../platform/errors/api_errors.dart';
import '../../platform/paging/paging.dart';
import 'catalog_common.dart';
import 'catalog_rules.dart';
import 'product_family_service.dart';

/// Produtos do catálogo (docs/08 §3.1). Leitura: papéis internos; escrita:
/// `catalog.manage`. Com `source = erp`, os campos mestres só mudam pela
/// integração (`trg_guard_erp_master`); família, tipo, ativos, garantia e
/// etiqueta são extensões locais.
abstract final class ProductService {
  static const _sortable = {'name', 'code', 'createdAt'};

  static Future<ProductPage> list(Session session, ProductFilter? filter, PageRequest? page) async {
    await session.requireAnyRole(internalRoles);
    final f = filter ?? ProductFilter();
    final q = f.q?.trim();
    final plan = Paging.plan(
      session,
      page,
      resource: 'products',
      sortable: _sortable,
      defaultSort: 'name',
      filterFingerprint: {
        'q': q,
        'isActive': f.isActive,
        'kind': f.productKind?.name,
        'family': f.productFamilyId?.uuid,
        'source': f.source?.name,
      },
    );
    if (q != null && q.isNotEmpty && q.length < 2) {
      throw ApiErrors.invalidFilter(session, 'A busca precisa de pelo menos 2 caracteres.');
    }
    final families = f.productFamilyId == null
        ? null
        : await ProductFamilyService.subtreeOf(session, f.productFamilyId!);

    Expression<dynamic> filters(ProductTable t) {
      Expression<dynamic> e = Constant.bool(true);
      if (f.isActive != null) e = e & t.isActive.equals(f.isActive);
      if (f.productKind != null) e = e & t.productKind.equals(f.productKind);
      if (f.source != null) e = e & t.source.equals(f.source);
      if (families != null) e = e & t.productFamilyId.inSet(families);
      if (q != null && q.isNotEmpty) {
        final like = likeContains(q);
        e = e & (t.name.ilike(like) | t.code.ilike(like) | t.gtin.ilike(like));
      }
      return e;
    }

    final rows = await Product.db.find(
      session,
      where: (t) => filters(t) & _after(plan, t),
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
      plan.includeTotal ? await Product.db.count(session, where: filters, limit: Paging.totalCap + 1) : null,
    );
    return ProductPage(
      items: s.items,
      nextCursor: s.nextCursor,
      hasMore: s.hasMore,
      total: total.total,
      totalIsEstimate: total.isEstimate,
    );
  }

  static Expression<dynamic> _after(PagePlan plan, ProductTable t) => switch (plan.sort) {
    'code' => plan.afterCursor(t.code, t.id, (v) => v),
    'createdAt' => plan.afterCursor(t.createdAt, t.id, DateTime.parse),
    _ => plan.afterCursor(t.name, t.id, (v) => v),
  };

  static Future<Product> get(Session session, UuidValue id) async {
    await session.requireAnyRole(internalRoles);
    return await Product.db.findById(session, id) ?? (throw ApiErrors.notFound(session));
  }

  static Future<Product> create(Session session, ProductInput input) async {
    await session.requirePermission(CatalogCommon.managePermission);
    CatalogCommon.checkClientId(session, input.id);
    final draft = validOrThrow(session, ProductDraft.fromInput(input));
    return CatalogCommon.translateUnique(
      session,
      'products',
      'um produto',
      () => session.db.transaction((tx) async {
        await checkFamily(session, tx, draft.productFamilyId);
        final created = await Product.db.insertRow(session, newProduct(session, draft, id: input.id), transaction: tx);
        await event(session, tx, 'product.created', created);
        return created;
      }),
    );
  }

  static Future<Product> update(Session session, UuidValue id, ProductPatch patch, int expectedVersion) async {
    await session.requirePermission(CatalogCommon.managePermission);
    return CatalogCommon.translateUnique(
      session,
      'products',
      'um produto',
      () => session.db.transaction((tx) async {
        final current = await _currentAt(session, tx, id, expectedVersion);
        final before = ProductDraft.fromProduct(current);
        final after = validOrThrow(session, before.apply(patch));
        final changed = CatalogCommon.changed(before.toFields(), after.toFields());
        if (changed.isEmpty) return current;
        if (current.source == RecordSource.erp) {
          final blocked = changed.keys.where(productMasterFields.contains).toList();
          if (blocked.isNotEmpty) throw ApiErrors.masterFieldReadOnly(session, blocked);
        }
        if (changed.containsKey('productFamilyId')) await checkFamily(session, tx, after.productFamilyId);
        final updated = await _updateGuarded(
          session,
          tx,
          current,
          expectedVersion,
          (t) => [for (final e in changed.entries) columnValue(t, e.key, e.value)],
        );
        await event(session, tx, 'product.updated', updated, extra: {'changed_fields': changed.keys.toList()..sort()});
        return updated;
      }),
    );
  }

  static Future<Product> deactivate(Session session, UuidValue id, String reason, int expectedVersion) =>
      _setActive(session, id, expectedVersion, active: false, reason: CatalogCommon.requireReason(session, reason));

  static Future<Product> reactivate(Session session, UuidValue id, int expectedVersion) =>
      _setActive(session, id, expectedVersion, active: true);

  static Future<Product> _setActive(
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
      // O catálogo de eventos não tem product.deactivated: é uma atualização.
      await event(
        session,
        tx,
        'product.updated',
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

  static ProductDraft validOrThrow(Session session, ProductDraft draft) {
    final result = ProductRules.validate(draft);
    if (result.errors.isNotEmpty) throw ApiErrors.validation(session, result.errors);
    return result.draft!;
  }

  /// Família informada precisa existir e estar ativa.
  static Future<void> checkFamily(Session session, Transaction tx, UuidValue? familyId) async {
    if (familyId == null) return;
    final family = await ProductFamily.db.findById(session, familyId, transaction: tx);
    final problem = family == null
        ? FieldError(path: 'productFamilyId', code: 'not_found', message: 'Família não encontrada.')
        : !family.isActive
        ? FieldError(path: 'productFamilyId', code: 'inactive', message: 'A família "${family.name}" está inativa.')
        : null;
    if (problem != null) throw ApiErrors.validation(session, [problem]);
  }

  static Product newProduct(Session session, ProductDraft d, {UuidValue? id}) {
    final now = DateTime.now().toUtc();
    return Product(
      id: id,
      tenantId: session.context.tenantId!,
      code: d.code,
      name: d.name,
      description: d.description,
      productFamilyId: d.productFamilyId,
      productKind: d.productKind,
      unitCode: d.unitCode,
      gtin: d.gtin,
      isSerialized: d.isSerialized,
      tracksAssets: d.tracksAssets,
      defaultWarrantyMonths: d.defaultWarrantyMonths,
      referencePrice: d.referencePrice,
      labelPositionInstructions: d.labelPositionInstructions,
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
    Product p, {
    Map<String, Object?> extra = const {},
  }) => CatalogCommon.event(
    session,
    tx,
    type: type,
    aggregateType: 'product',
    id: p.id,
    version: p.version,
    source: p.source,
    isActive: p.isActive,
    extra: extra,
  );

  static ColumnValue<dynamic, dynamic> columnValue(ProductUpdateTable t, String field, Object? value) =>
      switch (field) {
        'code' => t.code(value! as String),
        'name' => t.name(value! as String),
        'description' => t.description(value as String?),
        'productFamilyId' => t.productFamilyId(value as UuidValue?),
        'productKind' => t.productKind(value! as ProductKind),
        'unitCode' => t.unitCode(value! as String),
        'gtin' => t.gtin(value as String?),
        'isSerialized' => t.isSerialized(value! as bool),
        'tracksAssets' => t.tracksAssets(value! as bool),
        'defaultWarrantyMonths' => t.defaultWarrantyMonths(value as int?),
        'referencePrice' => t.referencePrice(value as int?),
        'labelPositionInstructions' => t.labelPositionInstructions(value as String?),
        _ => throw ArgumentError.value(field, 'field'),
      };

  static Future<Product> _currentAt(Session session, Transaction tx, UuidValue id, int expectedVersion) async {
    final current =
        await Product.db.findById(session, id, transaction: tx, lockMode: LockMode.forNoKeyUpdate) ??
        (throw ApiErrors.notFound(session));
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    return current;
  }

  static Future<Product> _updateGuarded(
    Session session,
    Transaction tx,
    Product current,
    int expectedVersion,
    List<ColumnValue<dynamic, dynamic>> Function(ProductUpdateTable t) values,
  ) async {
    final rows = await Product.db.updateWhere(
      session,
      columnValues: values,
      where: (t) => t.id.equals(current.id) & t.version.equals(expectedVersion),
      transaction: tx,
    );
    if (rows.isEmpty) throw ApiErrors.versionMismatch(session, current.version + 1);
    return rows.single;
  }
}
