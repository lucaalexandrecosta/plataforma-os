import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/authz/grants.dart';
import '../../platform/context/request_context.dart';
import '../../platform/errors/api_errors.dart';
import '../../platform/outbox/outbox.dart';
import '../../platform/paging/paging.dart';
import 'customer_rules.dart';

/// Casos de uso do cadastro de clientes (padrão de cadastro, docs/08 §3.1).
///
/// Isolamento: o `tenant_id` vem só do contexto; a RLS FORCE devolve zero
/// linhas de outro tenant, então registro de outro tenant é `NOT_FOUND`
/// (docs/08 §2.8), nunca `FORBIDDEN`.
abstract final class CustomerService {
  static const _manage = 'customers.manage';
  static const _sortable = {'name', 'createdAt'};

  static Future<CustomerPage> list(Session session, CustomerFilter? filter, PageRequest? page) async {
    await session.requireAnyRole(internalRoles);
    final f = filter ?? CustomerFilter();
    final q = f.q?.trim();
    final plan = Paging.plan(
      session,
      page,
      resource: 'customers',
      sortable: _sortable,
      defaultSort: 'name',
      filterFingerprint: {'q': q, 'isActive': f.isActive, 'kind': f.kind?.name, 'source': f.source?.name},
    );

    Expression<dynamic> filters(CustomerTable t) {
      Expression<dynamic> e = Constant.bool(true);
      if (f.isActive != null) e = e & t.isActive.equals(f.isActive);
      if (f.kind != null) e = e & t.kind.equals(f.kind);
      if (f.source != null) e = e & t.source.equals(f.source);
      if (q != null && q.isNotEmpty) {
        if (q.length < 2) throw ApiErrors.invalidFilter(session, 'A busca precisa de pelo menos 2 caracteres.');
        final like = likeContains(q);
        var search = t.name.ilike(like) | t.tradeName.ilike(like) | t.code.ilike(like);
        final doc = BrDocuments.normalize(q);
        if (RegExp(r'^[0-9A-Z]{3,}$').hasMatch(doc)) search = search | t.documentNumber.like(likeContains(doc));
        e = e & search;
      }
      return e;
    }

    Expression<dynamic> keyset(CustomerTable t) {
      final after = plan.after;
      if (after == null) return Constant.bool(true);
      final id = after.id;
      if (plan.sort == 'createdAt') {
        final v = DateTime.parse(after.sortValue);
        return plan.descending
            ? (t.createdAt < v) | (t.createdAt.equals(v) & (t.id < id))
            : (t.createdAt > v) | (t.createdAt.equals(v) & (t.id > id));
      }
      final v = after.sortValue;
      return plan.descending
          ? (t.name < v) | (t.name.equals(v) & (t.id < id))
          : (t.name > v) | (t.name.equals(v) & (t.id > id));
    }

    final rows = await Customer.db.find(
      session,
      where: (t) => filters(t) & keyset(t),
      orderByList: (t) {
        final Order first;
        if (plan.sort == 'createdAt') {
          first = plan.descending ? t.createdAt.desc() : t.createdAt.asc();
        } else {
          first = plan.descending ? t.name.desc() : t.name.asc();
        }
        return [first, if (plan.descending) t.id.desc() else t.id.asc()];
      },
      limit: plan.fetchLimit,
    );

    final hasMore = rows.length > plan.limit;
    final items = hasMore ? rows.sublist(0, plan.limit) : rows;
    int? total;
    if (plan.includeTotal) total = await Customer.db.count(session, where: filters, limit: Paging.totalCap + 1);
    String? nextCursor;
    if (hasMore) {
      final last = items.last;
      nextCursor = Paging.encode(
        plan,
        sortValue: plan.sort == 'createdAt' ? last.createdAt.toUtc().toIso8601String() : last.name,
        id: last.id,
      );
    }
    return CustomerPage(
      items: items,
      nextCursor: nextCursor,
      hasMore: hasMore,
      total: total == null ? null : (total > Paging.totalCap ? Paging.totalCap : total),
      totalIsEstimate: total == null ? null : total > Paging.totalCap,
    );
  }

  static Future<Customer> get(Session session, UuidValue id) async {
    await session.requireAnyRole(internalRoles);
    return await Customer.db.findById(session, id) ?? (throw ApiErrors.notFound(session));
  }

  static Future<Customer> create(Session session, CustomerInput input) async {
    await session.requirePermission(_manage);
    final id = input.id;
    if (id != null && !UuidV7.isAcceptable(id.uuid, now: DateTime.now().toUtc())) {
      throw ApiErrors.invalidUuid(session, 'id');
    }
    final draft = _validOrThrow(session, CustomerDraft.fromInput(input));
    final now = DateTime.now().toUtc();

    return _translateDbErrors(
      session,
      () => session.db.transaction((tx) async {
        final created = await Customer.db.insertRow(
          session,
          Customer(
            id: id,
            tenantId: session.context.tenantId!,
            code: draft.code,
            name: draft.name,
            tradeName: draft.tradeName,
            personType: draft.personType,
            documentType: draft.documentType,
            documentNumber: draft.documentNumber,
            stateRegistration: draft.stateRegistration,
            email: draft.email,
            phone: draft.phone,
            notes: draft.notes,
            kind: draft.kind,
            skipTriage: draft.skipTriage,
            isActive: true,
            source: RecordSource.local,
            createdAt: now,
            updatedAt: now,
            version: 1,
          ),
          transaction: tx,
        );
        await _event(session, tx, 'customer.created', created);
        return created;
      }),
    );
  }

  static Future<Customer> update(Session session, UuidValue id, CustomerPatch patch, int expectedVersion) async {
    await session.requirePermission(_manage);
    return _translateDbErrors(
      session,
      () => session.db.transaction((tx) async {
        final current = await _currentAt(session, tx, id, expectedVersion);
        final before = CustomerDraft.fromCustomer(current);
        final after = _validOrThrow(session, before.apply(patch));

        final beforeFields = before.toFields();
        final changed = {
          for (final e in after.toFields().entries)
            if (e.value != beforeFields[e.key]) e.key: e.value,
        };
        if (changed.isEmpty) return current;
        if (current.source == RecordSource.erp) {
          final blocked = changed.keys.where(customerMasterFields.contains).toList();
          if (blocked.isNotEmpty) throw ApiErrors.masterFieldReadOnly(session, blocked);
        }

        final updated = await _updateGuarded(
          session,
          tx,
          current,
          expectedVersion,
          (t) => [for (final e in changed.entries) _columnValue(t, e.key, e.value)],
        );
        await _event(
          session,
          tx,
          'customer.updated',
          updated,
          extra: {'changed_fields': changed.keys.toList()..sort()},
        );
        return updated;
      }),
    );
  }

  static Future<Customer> deactivate(Session session, UuidValue id, String reason, int expectedVersion) async {
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
      final updated = await _updateGuarded(
        session,
        tx,
        current,
        expectedVersion,
        (t) => [t.isActive(false), t.deactivatedAt(DateTime.now().toUtc())],
      );
      await _event(session, tx, 'customer.deactivated', updated, extra: {'reason': why});
      return updated;
    });
  }

  static Future<Customer> reactivate(Session session, UuidValue id, int expectedVersion) async {
    await session.requirePermission(_manage);
    return session.db.transaction((tx) async {
      final current = await _currentAt(session, tx, id, expectedVersion);
      if (current.isActive) return current;
      if (current.source == RecordSource.erp) throw ApiErrors.masterFieldReadOnly(session, ['isActive']);
      final updated = await _updateGuarded(
        session,
        tx,
        current,
        expectedVersion,
        (t) => [t.isActive(true), t.deactivatedAt(null)],
      );
      // O catálogo não tem customer.reactivated: reativar é uma atualização.
      await _event(
        session,
        tx,
        'customer.updated',
        updated,
        extra: {
          'changed_fields': ['isActive'],
        },
      );
      return updated;
    });
  }

  // ---------------------------------------------------------------------------

  static CustomerDraft _validOrThrow(Session session, CustomerDraft draft) {
    final result = CustomerRules.validate(draft);
    if (result.errors.isNotEmpty) throw ApiErrors.validation(session, result.errors);
    return result.draft!;
  }

  /// Lê com bloqueio e confere a versão esperada.
  static Future<Customer> _currentAt(Session session, Transaction tx, UuidValue id, int expectedVersion) async {
    final current =
        await Customer.db.findById(session, id, transaction: tx, lockMode: LockMode.forNoKeyUpdate) ??
        (throw ApiErrors.notFound(session));
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    return current;
  }

  /// `UPDATE ... WHERE id = $1 AND version = $2` (docs/08 §2.10). O trigger
  /// incrementa a versão e grava a auditoria campo a campo.
  static Future<Customer> _updateGuarded(
    Session session,
    Transaction tx,
    Customer current,
    int expectedVersion,
    List<ColumnValue<dynamic, dynamic>> Function(CustomerUpdateTable t) values,
  ) async {
    final rows = await Customer.db.updateWhere(
      session,
      columnValues: values,
      where: (t) => t.id.equals(current.id) & t.version.equals(expectedVersion),
      transaction: tx,
    );
    if (rows.isEmpty) throw ApiErrors.versionMismatch(session, current.version + 1);
    return rows.single;
  }

  static ColumnValue<dynamic, dynamic> _columnValue(CustomerUpdateTable t, String field, Object? value) =>
      switch (field) {
        'code' => t.code(value as String?),
        'name' => t.name(value! as String),
        'tradeName' => t.tradeName(value as String?),
        'personType' => t.personType(value! as PersonType),
        'documentType' => t.documentType(value! as DocumentType),
        'documentNumber' => t.documentNumber(value as String?),
        'stateRegistration' => t.stateRegistration(value as String?),
        'email' => t.email(value as String?),
        'phone' => t.phone(value as String?),
        'notes' => t.notes(value as String?),
        'kind' => t.kind(value! as CustomerKind),
        'skipTriage' => t.skipTriage(value! as bool),
        _ => throw ArgumentError.value(field, 'field'),
      };

  static Future<void> _event(
    Session session,
    Transaction tx,
    String type,
    Customer c, {
    Map<String, Object?> extra = const {},
  }) => Outbox.record(
    session,
    tx,
    eventType: type,
    aggregateType: 'customer',
    aggregateId: c.id,
    aggregateVersion: c.version,
    payload: {'customer_id': c.id.uuid, 'source': c.source.name, ...extra},
  );

  /// Unicidade do banco → `DUPLICATE` com o campo certo.
  static Future<T> _translateDbErrors<T>(Session session, Future<T> Function() body) async {
    try {
      return await body();
    } on DatabaseUniqueViolationException catch (e) {
      switch (e.constraintName) {
        case 'customers_code_key':
          throw ApiErrors.duplicate(session, path: 'code', message: 'Já existe um cliente com este código.');
        case 'customers_pkey':
          throw ApiErrors.duplicate(session, path: 'id', message: 'Já existe um cliente com este identificador.');
        default:
          rethrow;
      }
    }
  }
}
