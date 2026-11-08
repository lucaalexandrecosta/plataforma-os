import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/authz/grants.dart';
import '../../platform/context/request_context.dart';
import '../../platform/errors/api_errors.dart';
import '../../platform/outbox/outbox.dart';
import '../../platform/paging/paging.dart';
import 'site_and_contact_rules.dart';

/// Contatos do cliente (`customerContacts`, docs/08 §3.1). Além do padrão de
/// cadastro: `approve` (autocadastro pelo QR), `block` e `unblock`.
/// Pendências: `invite` (link por WhatsApp/e-mail, com o módulo de
/// notificações) e `revokeSessions` (com o login do contato por OTP).
abstract final class CustomerContactService {
  static const _manage = 'customers.manage';

  static Future<CustomerContactPage> list(
    Session session,
    CustomerContactFilter? filter,
    PageRequest? page,
  ) async {
    await session.requireAnyRole(internalRoles);
    final f = filter ?? CustomerContactFilter();
    final q = f.q?.trim();
    final plan = Paging.plan(
      session,
      page,
      resource: 'customer_contacts',
      sortable: const {'name', 'createdAt'},
      defaultSort: 'name',
      filterFingerprint: {
        'customerId': f.customerId?.uuid,
        'customerSiteId': f.customerSiteId?.uuid,
        'q': q,
        'status': f.status?.name,
        'isActive': f.isActive,
      },
    );

    Expression<dynamic> filters(CustomerContactTable t) {
      Expression<dynamic> e = Constant.bool(true);
      if (f.customerId != null) e = e & t.customerId.equals(f.customerId);
      if (f.customerSiteId != null) e = e & t.customerSiteId.equals(f.customerSiteId);
      if (f.status != null) e = e & t.status.equals(f.status);
      if (f.isActive != null) e = e & t.isActive.equals(f.isActive);
      if (q != null && q.isNotEmpty) {
        if (q.length < 2) throw ApiErrors.invalidFilter(session, 'A busca precisa de pelo menos 2 caracteres.');
        final like = likeContains(q);
        var search = t.name.ilike(like) | t.email.ilike(like);
        final digits = q.replaceAll(RegExp(r'\D'), '');
        if (digits.length >= 4) search = search | t.phoneE164.like(likeContains(digits));
        e = e & search;
      }
      return e;
    }

    Expression<dynamic> keyset(CustomerContactTable t) {
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

    final rows = await CustomerContact.db.find(
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
        ? await CustomerContact.db.count(session, where: filters, limit: Paging.totalCap + 1)
        : null;
    final last = hasMore ? items.last : null;
    return CustomerContactPage(
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

  static Future<CustomerContact> get(Session session, UuidValue id) async {
    await session.requireAnyRole(internalRoles);
    return await CustomerContact.db.findById(session, id) ?? (throw ApiErrors.notFound(session));
  }

  static Future<CustomerContact> create(Session session, CustomerContactInput input) async {
    await session.requirePermission(_manage);
    final id = input.id;
    if (id != null && !UuidV7.isAcceptable(id.uuid, now: DateTime.now().toUtc())) {
      throw ApiErrors.invalidUuid(session, 'id');
    }
    final draft = _validOrThrow(session, ContactDraft.fromInput(input));
    return session.db.transaction((tx) async {
      final customer =
          await Customer.db.findById(session, input.customerId, transaction: tx) ??
          (throw ApiErrors.notFound(session, 'Cliente não encontrado.'));
      if (!customer.isActive) {
        throw ApiErrors.businessRule(session, 'Cliente inativo: reative-o antes de cadastrar contatos.');
      }
      await _checkSite(session, tx, customer.id, draft.customerSiteId);
      final now = DateTime.now().toUtc();
      final created = await _translate(
        session,
        () => CustomerContact.db.insertRow(
          session,
          CustomerContact(
            id: id,
            tenantId: session.context.tenantId!,
            customerId: customer.id,
            customerSiteId: draft.customerSiteId,
            name: draft.name,
            email: draft.email,
            phoneE164: draft.phone,
            jobTitle: draft.jobTitle,
            contactRole: draft.contactRole,
            status: ContactStatus.active,
            origin: ContactOrigin.backoffice,
            canOpenRequests: draft.canOpenRequests,
            preferredChannel: draft.preferredChannel,
            isActive: true,
            source: RecordSource.local,
            createdAt: now,
            updatedAt: now,
            version: 1,
          ),
          transaction: tx,
        ),
      );
      await _event(session, tx, 'customer_contact.created', created);
      return created;
    });
  }

  static Future<CustomerContact> update(
    Session session,
    UuidValue id,
    CustomerContactPatch patch,
    int expectedVersion,
  ) async {
    await session.requirePermission(_manage);
    return session.db.transaction((tx) async {
      final current = await _currentAt(session, tx, id, expectedVersion);
      final before = ContactDraft.fromContact(current);
      final after = _validOrThrow(session, before.apply(patch));
      final beforeFields = before.toFields();
      final changed = {
        for (final e in after.toFields().entries)
          if (e.value != beforeFields[e.key]) e.key: e.value,
      };
      if (changed.isEmpty) return current;
      if (current.source == RecordSource.erp) {
        final blocked = changed.keys.where(contactMasterFields.contains).toList();
        if (blocked.isNotEmpty) throw ApiErrors.masterFieldReadOnly(session, blocked);
      }
      if (changed.containsKey('customerSiteId')) {
        await _checkSite(session, tx, current.customerId, after.customerSiteId);
      }
      final updated = await _guarded(
        session,
        tx,
        current,
        expectedVersion,
        (t) => [for (final e in changed.entries) _column(t, e.key, e.value)],
      );
      await _event(
        session,
        tx,
        'customer_contact.updated',
        updated,
        extra: {'changed_fields': changed.keys.toList()..sort()},
      );
      return updated;
    });
  }

  static Future<CustomerContact> approve(Session session, UuidValue id, int expectedVersion) async {
    await session.requirePermission(_manage);
    return session.db.transaction((tx) async {
      final current = await _currentAt(session, tx, id, expectedVersion);
      if (current.status != ContactStatus.pending_approval) {
        throw ApiErrors.invalidTransition(session, 'Só contatos pendentes de aprovação podem ser aprovados.');
      }
      final updated = await _guarded(
        session,
        tx,
        current,
        expectedVersion,
        (t) => [
          t.status(ContactStatus.active),
          t.approvedAt(DateTime.now().toUtc()),
          t.approvedBy(session.context.userId),
        ],
      );
      await _event(session, tx, 'customer_contact.approved', updated);
      return updated;
    });
  }

  static Future<CustomerContact> block(Session session, UuidValue id, String reason, int expectedVersion) async {
    await session.requirePermission(_manage);
    final why = reason.trim();
    if (why.isEmpty || why.length > 500) {
      throw ApiErrors.validation(session, [
        FieldError(path: 'reason', code: 'required', message: 'Informe o motivo do bloqueio (até 500 caracteres).'),
      ]);
    }
    return session.db.transaction((tx) async {
      final current = await _currentAt(session, tx, id, expectedVersion);
      if (current.status == ContactStatus.blocked) {
        throw ApiErrors.invalidTransition(session, 'Este contato já está bloqueado.');
      }
      final updated = await _guarded(
        session,
        tx,
        current,
        expectedVersion,
        (t) => [t.status(ContactStatus.blocked), t.blockedReason(why)],
      );
      // O módulo identity_access consome o evento e revoga as sessões do contato.
      await _event(session, tx, 'customer_contact.blocked', updated, extra: {'reason': why});
      return updated;
    });
  }

  static Future<CustomerContact> unblock(Session session, UuidValue id, int expectedVersion) async {
    await session.requirePermission(_manage);
    return session.db.transaction((tx) async {
      final current = await _currentAt(session, tx, id, expectedVersion);
      if (current.status != ContactStatus.blocked) {
        throw ApiErrors.invalidTransition(session, 'Este contato não está bloqueado.');
      }
      final updated = await _guarded(
        session,
        tx,
        current,
        expectedVersion,
        (t) => [t.status(ContactStatus.active), t.blockedReason(null)],
      );
      await _event(
        session,
        tx,
        'customer_contact.updated',
        updated,
        extra: {
          'changed_fields': ['status'],
        },
      );
      return updated;
    });
  }

  static Future<CustomerContact> deactivate(Session session, UuidValue id, String reason, int expectedVersion) async {
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
      await _event(session, tx, 'customer_contact.deactivated', updated, extra: {'reason': why});
      return updated;
    });
  }

  static Future<CustomerContact> reactivate(Session session, UuidValue id, int expectedVersion) async {
    await session.requirePermission(_manage);
    return session.db.transaction((tx) async {
      final current = await _currentAt(session, tx, id, expectedVersion);
      if (current.isActive) return current;
      if (current.source == RecordSource.erp) throw ApiErrors.masterFieldReadOnly(session, ['isActive']);
      final updated = await _guarded(session, tx, current, expectedVersion, (t) => [t.isActive(true)]);
      await _event(
        session,
        tx,
        'customer_contact.updated',
        updated,
        extra: {
          'changed_fields': ['isActive'],
        },
      );
      return updated;
    });
  }

  // ---------------------------------------------------------------------------

  static ContactDraft _validOrThrow(Session session, ContactDraft draft) {
    final r = ContactRules.validate(draft);
    if (r.errors.isNotEmpty) throw ApiErrors.validation(session, r.errors);
    return r.value!;
  }

  /// A unidade, se informada, precisa ser do mesmo cliente (a FK composta
  /// também garante; aqui vira erro de campo legível).
  static Future<void> _checkSite(Session session, Transaction tx, UuidValue customerId, UuidValue? siteId) async {
    if (siteId == null) return;
    final site = await CustomerSite.db.findFirstRow(
      session,
      where: (t) => t.id.equals(siteId) & t.customerId.equals(customerId),
      transaction: tx,
    );
    if (site == null) {
      throw ApiErrors.validation(session, [
        FieldError(path: 'customerSiteId', code: 'not_found', message: 'Unidade não encontrada neste cliente.'),
      ]);
    }
  }

  static Future<CustomerContact> _currentAt(Session session, Transaction tx, UuidValue id, int expectedVersion) async {
    final current =
        await CustomerContact.db.findById(session, id, transaction: tx, lockMode: LockMode.forNoKeyUpdate) ??
        (throw ApiErrors.notFound(session));
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    return current;
  }

  static Future<CustomerContact> _guarded(
    Session session,
    Transaction tx,
    CustomerContact current,
    int expectedVersion,
    List<ColumnValue<dynamic, dynamic>> Function(CustomerContactUpdateTable t) values,
  ) async {
    final rows = await CustomerContact.db.updateWhere(
      session,
      columnValues: values,
      where: (t) => t.id.equals(current.id) & t.version.equals(expectedVersion),
      transaction: tx,
    );
    if (rows.isEmpty) throw ApiErrors.versionMismatch(session, current.version + 1);
    return rows.single;
  }

  static ColumnValue<dynamic, dynamic> _column(CustomerContactUpdateTable t, String field, Object? v) =>
      switch (field) {
        'customerSiteId' => t.customerSiteId(v as UuidValue?),
        'name' => t.name(v! as String),
        'email' => t.email(v as String?),
        'phoneE164' => t.phoneE164(v as String?),
        'jobTitle' => t.jobTitle(v as String?),
        'contactRole' => t.contactRole(v! as ContactRole),
        'canOpenRequests' => t.canOpenRequests(v! as bool),
        'preferredChannel' => t.preferredChannel(v as NotificationChannel?),
        _ => throw ArgumentError.value(field, 'field'),
      };

  static Future<void> _event(
    Session session,
    Transaction tx,
    String type,
    CustomerContact c, {
    Map<String, Object?> extra = const {},
  }) => Outbox.record(
    session,
    tx,
    eventType: type,
    aggregateType: 'customer_contact',
    aggregateId: c.id,
    aggregateVersion: c.version,
    payload: {
      'contact_id': c.id.uuid,
      'customer_id': c.customerId.uuid,
      'origin': c.origin.name,
      'status': c.status.name,
      ...extra,
    },
  );

  static Future<T> _translate<T>(Session session, Future<T> Function() body) async {
    try {
      return await body();
    } on DatabaseUniqueViolationException catch (e) {
      if (e.constraintName == 'customer_contacts_pkey') {
        throw ApiErrors.duplicate(session, path: 'id', message: 'Já existe um contato com este identificador.');
      }
      rethrow;
    }
  }
}
