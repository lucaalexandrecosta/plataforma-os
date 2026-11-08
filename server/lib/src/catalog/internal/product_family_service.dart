import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/authz/grants.dart';
import '../../platform/context/request_context.dart';
import '../../platform/errors/api_errors.dart';
import '../../platform/paging/paging.dart';
import 'catalog_common.dart';
import 'catalog_rules.dart';

/// Famílias de produto: uma árvore de até [maxFamilyDepth] níveis.
/// Leitura: papéis internos; escrita: `catalog.manage`.
abstract final class ProductFamilyService {
  static const _sortable = {'name', 'code'};

  static Future<ProductFamilyPage> list(Session session, ProductFamilyFilter? filter, PageRequest? page) async {
    await session.requireAnyRole(internalRoles);
    final f = filter ?? ProductFamilyFilter();
    final q = f.q?.trim();
    final plan = Paging.plan(
      session,
      page,
      resource: 'product_families',
      sortable: _sortable,
      defaultSort: 'name',
      filterFingerprint: {'q': q, 'isActive': f.isActive, 'parentId': f.parentId?.uuid, 'rootsOnly': f.rootsOnly},
    );

    Expression<dynamic> filters(ProductFamilyTable t) {
      Expression<dynamic> e = Constant.bool(true);
      if (f.isActive != null) e = e & t.isActive.equals(f.isActive);
      if (f.parentId != null) e = e & t.parentId.equals(f.parentId);
      if (f.rootsOnly ?? false) e = e & t.parentId.equals(null);
      if (q != null && q.isNotEmpty) {
        if (q.length < 2) throw ApiErrors.invalidFilter(session, 'A busca precisa de pelo menos 2 caracteres.');
        final like = likeContains(q);
        e = e & (t.name.ilike(like) | t.code.ilike(like));
      }
      return e;
    }

    final byCode = plan.sort == 'code';
    final rows = await ProductFamily.db.find(
      session,
      where: (t) => filters(t) & (byCode ? plan.afterCursor(t.code, t.id, _id) : plan.afterCursor(t.name, t.id, _id)),
      orderByList: (t) => plan.orderBy(byCode ? t.code : t.name, t.id),
      limit: plan.fetchLimit,
    );
    final s = plan.slice(rows, sortValue: (r) => byCode ? r.code : r.name, id: (r) => r.id);
    final total = plan.capTotal(
      plan.includeTotal ? await ProductFamily.db.count(session, where: filters, limit: Paging.totalCap + 1) : null,
    );
    return ProductFamilyPage(
      items: s.items,
      nextCursor: s.nextCursor,
      hasMore: s.hasMore,
      total: total.total,
      totalIsEstimate: total.isEstimate,
    );
  }

  static String _id(String v) => v;

  static Future<ProductFamily> get(Session session, UuidValue id) async {
    await session.requireAnyRole(internalRoles);
    return await ProductFamily.db.findById(session, id) ?? (throw ApiErrors.notFound(session));
  }

  static Future<ProductFamily> create(Session session, ProductFamilyInput input) async {
    await session.requirePermission(CatalogCommon.managePermission);
    final id = input.id;
    CatalogCommon.checkClientId(session, id);
    final draft = _validOrThrow(session, FamilyDraft.fromInput(input));
    final now = DateTime.now().toUtc();
    return CatalogCommon.translateUnique(
      session,
      'product_families',
      'uma família',
      () => session.db.transaction((tx) async {
        if (draft.parentId != null) await _checkParent(session, tx, self: null, parentId: draft.parentId!);
        return ProductFamily.db.insertRow(
          session,
          ProductFamily(
            id: id,
            tenantId: session.context.tenantId!,
            parentId: draft.parentId,
            code: draft.code,
            name: draft.name,
            isActive: true,
            source: RecordSource.local,
            createdAt: now,
            updatedAt: now,
            version: 1,
          ),
          transaction: tx,
        );
      }),
    );
  }

  static Future<ProductFamily> update(
    Session session,
    UuidValue id,
    ProductFamilyPatch patch,
    int expectedVersion,
  ) async {
    await session.requirePermission(CatalogCommon.managePermission);
    return CatalogCommon.translateUnique(
      session,
      'product_families',
      'uma família',
      () => session.db.transaction((tx) async {
        final current = await _currentAt(session, tx, id, expectedVersion);
        final before = FamilyDraft.fromFamily(current);
        final after = _validOrThrow(session, before.apply(patch));
        final changed = CatalogCommon.changed(before.toFields(), after.toFields());
        if (changed.isEmpty) return current;
        if (current.source == RecordSource.erp) {
          final blocked = changed.keys.where(familyMasterFields.contains).toList();
          if (blocked.isNotEmpty) throw ApiErrors.masterFieldReadOnly(session, blocked);
        }
        if (changed.containsKey('parentId') && after.parentId != null) {
          await _checkParent(session, tx, self: current.id, parentId: after.parentId!);
        }
        return _updateGuarded(
          session,
          tx,
          current,
          expectedVersion,
          (t) => [
            for (final e in changed.entries)
              switch (e.key) {
                'code' => t.code(e.value! as String),
                'name' => t.name(e.value! as String),
                'parentId' => t.parentId(e.value as UuidValue?),
                _ => throw ArgumentError.value(e.key),
              },
          ],
        );
      }),
    );
  }

  /// Inativar não mexe nos produtos (continuam com a família); só impede que
  /// novos produtos e subfamílias entrem nela. Subfamílias ativas bloqueiam.
  static Future<ProductFamily> deactivate(Session session, UuidValue id, String reason, int expectedVersion) async {
    await session.requirePermission(CatalogCommon.managePermission);
    CatalogCommon.requireReason(session, reason);
    return session.db.transaction((tx) async {
      final current = await _currentAt(session, tx, id, expectedVersion);
      if (!current.isActive) return current;
      final activeChildren = await ProductFamily.db.count(
        session,
        where: (t) => t.parentId.equals(id) & t.isActive.equals(true),
        transaction: tx,
      );
      if (activeChildren > 0) {
        throw ApiErrors.businessRule(session, 'Inative antes as subfamílias ($activeChildren ativa(s)).');
      }
      return _updateGuarded(session, tx, current, expectedVersion, (t) => [t.isActive(false)]);
    });
  }

  static Future<ProductFamily> reactivate(Session session, UuidValue id, int expectedVersion) async {
    await session.requirePermission(CatalogCommon.managePermission);
    return session.db.transaction((tx) async {
      final current = await _currentAt(session, tx, id, expectedVersion);
      if (current.isActive) return current;
      final parentId = current.parentId;
      if (parentId != null) {
        final parent = await ProductFamily.db.findById(session, parentId, transaction: tx);
        if (parent != null && !parent.isActive) {
          throw ApiErrors.businessRule(session, 'Reative antes a família "${parent.name}".');
        }
      }
      return _updateGuarded(session, tx, current, expectedVersion, (t) => [t.isActive(true)]);
    });
  }

  /// A família e todas as descendentes (para filtrar produtos por família).
  static Future<Set<UuidValue>> subtreeOf(Session session, UuidValue root, {Transaction? transaction}) async {
    final all = await ProductFamily.db.find(session, transaction: transaction);
    final children = <UuidValue, List<UuidValue>>{};
    for (final f in all) {
      if (f.parentId != null) (children[f.parentId!] ??= []).add(f.id);
    }
    final out = <UuidValue>{root};
    final stack = [root];
    while (stack.isNotEmpty) {
      for (final c in children[stack.removeLast()] ?? const <UuidValue>[]) {
        if (out.add(c)) stack.add(c);
      }
    }
    return out;
  }

  // ---------------------------------------------------------------------------

  /// O pai existe, está ativo, não é a própria família nem uma descendente,
  /// e a árvore resultante não passa de [maxFamilyDepth] níveis.
  static Future<void> _checkParent(
    Session session,
    Transaction tx, {
    required UuidValue? self,
    required UuidValue parentId,
  }) async {
    FieldError fe(String code, String message) => FieldError(path: 'parentId', code: code, message: message);
    final all = {for (final f in await ProductFamily.db.find(session, transaction: tx)) f.id: f};
    final parent = all[parentId];
    if (parent == null) throw ApiErrors.validation(session, [fe('not_found', 'Família superior não encontrada.')]);
    if (!parent.isActive) throw ApiErrors.validation(session, [fe('inactive', 'A família superior está inativa.')]);

    // Profundidade do pai (raiz = 1) e verificação de ciclo.
    var depth = 0;
    for (UuidValue? cur = parentId; cur != null; cur = all[cur]?.parentId) {
      if (cur == self) {
        throw ApiErrors.validation(session, [fe('cycle', 'Uma família não pode ficar dentro dela mesma.')]);
      }
      if (++depth > maxFamilyDepth) break;
    }
    // Altura da subárvore da própria família (1 se não tiver filhas).
    var height = 1;
    if (self != null) {
      final children = <UuidValue, List<UuidValue>>{};
      for (final f in all.values) {
        if (f.parentId != null) (children[f.parentId!] ??= []).add(f.id);
      }
      int h(UuidValue id, int guard) => guard > maxFamilyDepth
          ? guard
          : 1 + (children[id] ?? const <UuidValue>[]).fold(0, (m, c) => _max(m, h(c, guard + 1)));
      height = h(self, 1);
    }
    if (depth + height > maxFamilyDepth) {
      throw ApiErrors.validation(session, [fe('too_deep', 'A árvore de famílias vai até $maxFamilyDepth níveis.')]);
    }
  }

  static int _max(int a, int b) => a > b ? a : b;

  static FamilyDraft _validOrThrow(Session session, FamilyDraft draft) {
    final result = FamilyRules.validate(draft);
    if (result.errors.isNotEmpty) throw ApiErrors.validation(session, result.errors);
    return result.draft!;
  }

  static Future<ProductFamily> _currentAt(Session session, Transaction tx, UuidValue id, int expectedVersion) async {
    final current =
        await ProductFamily.db.findById(session, id, transaction: tx, lockMode: LockMode.forNoKeyUpdate) ??
        (throw ApiErrors.notFound(session));
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    return current;
  }

  static Future<ProductFamily> _updateGuarded(
    Session session,
    Transaction tx,
    ProductFamily current,
    int expectedVersion,
    List<ColumnValue<dynamic, dynamic>> Function(ProductFamilyUpdateTable t) values,
  ) async {
    final rows = await ProductFamily.db.updateWhere(
      session,
      columnValues: values,
      where: (t) => t.id.equals(current.id) & t.version.equals(expectedVersion),
      transaction: tx,
    );
    if (rows.isEmpty) throw ApiErrors.versionMismatch(session, current.version + 1);
    return rows.single;
  }
}
