import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../../../platform/errors/api_errors.dart';
import 'authorization.dart';

/// Controle de usuários do tenant (decisão de 15/11/2026): convidar, definir
/// perfis, suspender, reativar e remover. Exige a permissão `users.manage`.
///
/// Tudo roda no contexto do tenant ativo, então RLS, carimbos e auditoria
/// (trg_audit em tenant_memberships e tenant_membership_roles) valem como em
/// qualquer outra escrita. A pessoa (`app.users`) é global: o convite
/// reaproveita quem já existe em outro tenant pelo e-mail, sem ver seus dados.
///
/// Limite conhecido: o token do tenant dura 10 min. Quem for suspenso perde
/// `me.get` e a escolha de tenant na hora; os demais endpoints passam a
/// recusar quando conferirem o vínculo ou quando o token expirar.
abstract final class UserAdmin {
  static const permission = 'users.manage';

  /// Perfis atribuíveis no MVP, na ordem de exibição. `sales_rep` e
  /// `provider_admin` entram na v0.2.
  static const assignableRoleCodes = ['tenant_admin', 'dispatcher', 'backoffice_agent', 'manager', 'technician'];

  static final _email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');

  static Future<List<AssignableRole>> roles(Session session) async {
    await Authorization.require(session, permission);
    final result = await session.db.unsafeQuery(
      'SELECT code, name, description FROM app.roles WHERE code = ANY(@codes::text[])',
      parameters: QueryParameters.named({'codes': assignableRoleCodes}),
    );
    final byCode = {
      for (final r in result)
        r[0] as String: AssignableRole(code: r[0] as String, name: r[1] as String, description: r[2] as String?),
    };
    return [for (final code in assignableRoleCodes) ?byCode[code]];
  }

  static Future<List<TenantUser>> list(Session session) async {
    await Authorization.require(session, permission);
    return _select(session, null);
  }

  static Future<TenantUser> invite(
    Session session, {
    required String email,
    required String fullName,
    required List<String> roles,
  }) async {
    await Authorization.require(session, permission);
    final normalizedEmail = email.trim().toLowerCase();
    final name = fullName.trim();
    _validate(session, email: normalizedEmail, fullName: name, roles: roles);

    final membershipId = await session.db.transaction((tx) async {
      final userId = await _findOrCreateUser(session, tx, email: normalizedEmail, fullName: name);
      final existing = await session.db.unsafeQuery(
        'SELECT id, status FROM app.tenant_memberships '
        ' WHERE tenant_id = app.current_tenant_id() AND user_id = @userId::uuid FOR UPDATE',
        parameters: QueryParameters.named({'userId': userId.uuid}),
        transaction: tx,
      );
      final UuidValue membershipId;
      if (existing.isEmpty) {
        membershipId = const Uuid().v7obj();
        await session.db.unsafeExecute(
          'INSERT INTO app.tenant_memberships (id, tenant_id, user_id, status, invited_at, invited_by) '
          "VALUES (@id::uuid, app.current_tenant_id(), @userId::uuid, 'invited', now(), app.current_user_id())",
          parameters: QueryParameters.named({'id': membershipId.uuid, 'userId': userId.uuid}),
          transaction: tx,
        );
      } else {
        if (existing.first[1] != 'removed') {
          throw ApiErrors.conflict(session, 'ALREADY_MEMBER', 'Esta pessoa já tem acesso à empresa.');
        }
        membershipId = _uuid(existing.first[0]);
        await session.db.unsafeExecute(
          "UPDATE app.tenant_memberships SET status = 'invited', invited_at = now(), "
          '       invited_by = app.current_user_id(), removed_at = NULL, updated_at = now(), version = version + 1 '
          ' WHERE id = @id::uuid',
          parameters: QueryParameters.named({'id': membershipId.uuid}),
          transaction: tx,
        );
      }
      await _replaceRoles(session, tx, membershipId, roles);
      return membershipId;
    });
    return _one(session, membershipId);
  }

  static Future<TenantUser> setRoles(
    Session session, {
    required UuidValue membershipId,
    required List<String> roles,
  }) async {
    await Authorization.require(session, permission);
    _validateRoles(session, roles);
    await session.db.transaction((tx) async {
      final target = await _lock(session, tx, membershipId);
      if (target.status == 'removed') throw ApiErrors.notFound(session);
      if (!roles.contains('tenant_admin')) await _ensureAnotherAdmin(session, tx, target);
      await _replaceRoles(session, tx, membershipId, roles);
    });
    return _one(session, membershipId);
  }

  static Future<TenantUser> suspend(Session session, {required UuidValue membershipId}) =>
      _changeStatus(session, membershipId, to: 'suspended', from: const {'active', 'invited'});

  /// Volta para `active` se a pessoa já entrou alguma vez; senão, `invited`.
  static Future<TenantUser> reactivate(Session session, {required UuidValue membershipId}) =>
      _changeStatus(session, membershipId, to: 'reactivate', from: const {'suspended'});

  /// Tira o acesso (o histórico fica). Pode ser convidada de novo depois.
  static Future<TenantUser> remove(Session session, {required UuidValue membershipId}) =>
      _changeStatus(session, membershipId, to: 'removed', from: const {'active', 'invited', 'suspended'});

  // ------------------------------------------------------------------ internos

  static Future<TenantUser> _changeStatus(
    Session session,
    UuidValue membershipId, {
    required String to,
    required Set<String> from,
  }) async {
    final actor = await Authorization.require(session, permission);
    await session.db.transaction((tx) async {
      final target = await _lock(session, tx, membershipId);
      if (target.status == 'removed' && to != 'removed') throw ApiErrors.notFound(session);
      if (target.userId == actor.userId) {
        throw ApiErrors.businessRule(
          session,
          'CANNOT_CHANGE_OWN_ACCESS',
          'Você não pode suspender nem remover o seu próprio acesso.',
        );
      }
      if (!from.contains(target.status)) {
        throw ApiErrors.businessRule(session, 'INVALID_STATUS', 'Esta ação não vale para o acesso no estado atual.');
      }
      if (to != 'reactivate') await _ensureAnotherAdmin(session, tx, target);
      final sql = switch (to) {
        'reactivate' =>
          "UPDATE app.tenant_memberships SET status = CASE WHEN joined_at IS NULL THEN 'invited' ELSE 'active' END, "
              '       updated_at = now(), version = version + 1 WHERE id = @id::uuid',
        'removed' =>
          "UPDATE app.tenant_memberships SET status = 'removed', removed_at = now(), "
              '       updated_at = now(), version = version + 1 WHERE id = @id::uuid',
        _ =>
          'UPDATE app.tenant_memberships SET status = @status, '
              '       updated_at = now(), version = version + 1 WHERE id = @id::uuid',
      };
      await session.db.unsafeExecute(
        sql,
        parameters: QueryParameters.named({'id': membershipId.uuid, if (to == 'suspended') 'status': to}),
        transaction: tx,
      );
    });
    return _one(session, membershipId, includeRemoved: true);
  }

  static void _validate(
    Session session, {
    required String email,
    required String fullName,
    required List<String> roles,
  }) {
    final errors = [
      if (!_email.hasMatch(email) || email.length > 254)
        FieldError(path: 'email', code: 'INVALID', message: 'Informe um e-mail válido.'),
      if (fullName.isEmpty || fullName.length > 200)
        FieldError(path: 'fullName', code: 'REQUIRED', message: 'Informe o nome (até 200 caracteres).'),
      ..._roleErrors(roles),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
  }

  static void _validateRoles(Session session, List<String> roles) {
    final errors = _roleErrors(roles);
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
  }

  static List<FieldError> _roleErrors(List<String> roles) => [
    if (roles.isEmpty) FieldError(path: 'roles', code: 'REQUIRED', message: 'Escolha pelo menos um perfil.'),
    for (final (i, role) in roles.indexed)
      if (!assignableRoleCodes.contains(role))
        FieldError(path: 'roles/$i', code: 'INVALID', message: 'Perfil desconhecido: $role.'),
  ];

  static Future<UuidValue> _findOrCreateUser(
    Session session,
    Transaction tx, {
    required String email,
    required String fullName,
  }) async {
    Future<UuidValue?> find() async {
      final r = await session.db.unsafeQuery(
        'SELECT app.staff_user_id_by_email(@email)',
        parameters: QueryParameters.named({'email': email}),
        transaction: tx,
      );
      final id = r.first[0];
      return id == null ? null : _uuid(id);
    }

    final found = await find();
    if (found != null) return found;
    final id = const Uuid().v7obj();
    // O id vem da aplicação: a política users_insert não precisa de RETURNING.
    // Corrida com outro convite do mesmo e-mail cai no índice único e aborta a
    // transação; o cliente repete e passa a achar a pessoa.
    await session.db.unsafeExecute(
      "INSERT INTO app.users (id, user_type, full_name, email) VALUES (@id::uuid, 'staff', @name, @email)",
      parameters: QueryParameters.named({'id': id.uuid, 'name': fullName, 'email': email}),
      transaction: tx,
    );
    return id;
  }

  static Future<void> _replaceRoles(Session session, Transaction tx, UuidValue membershipId, List<String> roles) async {
    final wanted = roles.toSet();
    await session.db.unsafeExecute(
      'DELETE FROM app.tenant_membership_roles '
      ' WHERE tenant_id = app.current_tenant_id() AND membership_id = @id::uuid AND NOT (role_code = ANY(@roles::text[]))',
      parameters: QueryParameters.named({'id': membershipId.uuid, 'roles': wanted.toList()}),
      transaction: tx,
    );
    await session.db.unsafeExecute(
      'INSERT INTO app.tenant_membership_roles (tenant_id, membership_id, role_code) '
      'SELECT app.current_tenant_id(), @id::uuid, r FROM unnest(@roles::text[]) AS r '
      'ON CONFLICT (tenant_id, membership_id, role_code) DO NOTHING',
      parameters: QueryParameters.named({'id': membershipId.uuid, 'roles': wanted.toList()}),
      transaction: tx,
    );
  }

  static Future<({UuidValue userId, String status, bool isAdmin})> _lock(
    Session session,
    Transaction tx,
    UuidValue membershipId,
  ) async {
    final r = await session.db.unsafeQuery(
      'SELECT m.user_id, m.status, EXISTS (SELECT 1 FROM app.tenant_membership_roles mr '
      '         WHERE mr.tenant_id = m.tenant_id AND mr.membership_id = m.id AND mr.role_code = \'tenant_admin\') '
      '  FROM app.tenant_memberships m '
      ' WHERE m.tenant_id = app.current_tenant_id() AND m.id = @id::uuid FOR UPDATE OF m',
      parameters: QueryParameters.named({'id': membershipId.uuid}),
      transaction: tx,
    );
    if (r.isEmpty) throw ApiErrors.notFound(session);
    return (userId: _uuid(r.first[0]), status: r.first[1] as String, isAdmin: r.first[2] as bool);
  }

  /// A empresa nunca fica sem administrador ativo.
  static Future<void> _ensureAnotherAdmin(
    Session session,
    Transaction tx,
    ({UuidValue userId, String status, bool isAdmin}) target,
  ) async {
    if (!target.isAdmin || target.status != 'active') return;
    final r = await session.db.unsafeQuery(
      'SELECT count(*) FROM app.tenant_memberships m '
      '  JOIN app.tenant_membership_roles mr ON mr.tenant_id = m.tenant_id AND mr.membership_id = m.id '
      " WHERE m.tenant_id = app.current_tenant_id() AND m.status = 'active' AND mr.role_code = 'tenant_admin' "
      '   AND m.user_id <> @userId::uuid',
      parameters: QueryParameters.named({'userId': target.userId.uuid}),
      transaction: tx,
    );
    if ((r.first[0] as int) == 0) {
      throw ApiErrors.businessRule(
        session,
        'LAST_TENANT_ADMIN',
        'A empresa precisa de pelo menos um administrador ativo.',
      );
    }
  }

  static Future<TenantUser> _one(Session session, UuidValue membershipId, {bool includeRemoved = false}) async {
    final rows = await _select(session, membershipId, includeRemoved: includeRemoved);
    if (rows.isEmpty) throw ApiErrors.notFound(session);
    return rows.first;
  }

  static Future<List<TenantUser>> _select(
    Session session,
    UuidValue? membershipId, {
    bool includeRemoved = false,
  }) async {
    final result = await session.db.unsafeQuery(
      'SELECT m.id, m.user_id, u.full_name, u.email, m.status, u.idp_subject IS NOT NULL, m.last_access_at, '
      '       coalesce(array_agg(mr.role_code ORDER BY mr.role_code) FILTER (WHERE mr.role_code IS NOT NULL), \'{}\')::text[] '
      '  FROM app.tenant_memberships m '
      '  JOIN app.users u ON u.id = m.user_id '
      '  LEFT JOIN app.tenant_membership_roles mr ON mr.tenant_id = m.tenant_id AND mr.membership_id = m.id '
      ' WHERE m.tenant_id = app.current_tenant_id() '
      "   AND (@includeRemoved OR m.status <> 'removed') "
      '   AND (@id::uuid IS NULL OR m.id = @id::uuid) '
      ' GROUP BY m.id, u.id '
      ' ORDER BY lower(u.full_name), m.id',
      parameters: QueryParameters.named({'id': membershipId?.uuid, 'includeRemoved': includeRemoved}),
    );
    return [
      for (final r in result)
        TenantUser(
          membershipId: _uuid(r[0]),
          userId: _uuid(r[1]),
          fullName: r[2] as String,
          email: r[3] as String?,
          status: MembershipStatus.fromJson(r[4] as String),
          hasLogin: r[5] as bool,
          lastAccessAt: r[6] as DateTime?,
          roles: [for (final role in r[7] as List) role as String],
        ),
    ];
  }

  static UuidValue _uuid(Object? v) => v is UuidValue ? v : UuidValue.withValidation(v.toString());
}
