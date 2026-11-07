import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';

/// Vínculos usuário × tenant, papéis e permissões efetivas.
///
/// Os papéis do token servem só para a UI; toda autorização relê daqui
/// (docs/04 §5). As consultas rodam com o contexto da sessão, e a RLS deixa o
/// usuário ler os próprios vínculos mesmo antes de escolher o tenant
/// (políticas own_memberships_read e own_membership_roles_read).
abstract final class Memberships {
  /// Vínculo ativo do usuário no tenant, ou `null`.
  static Future<TenantMembership?> activeFor(
    Session session, {
    required UuidValue userId,
    required UuidValue tenantId,
  }) => TenantMembership.db.findFirstRow(
    session,
    where: (m) => m.userId.equals(userId) & m.tenantId.equals(tenantId) & m.status.equals(MembershipStatus.active),
  );

  /// Todos os vínculos ativos ou convidados do usuário (troca de tenant).
  static Future<List<TenantMembership>> ofUser(Session session, UuidValue userId) => TenantMembership.db.find(
    session,
    where: (m) => m.userId.equals(userId) & m.status.inSet({MembershipStatus.active, MembershipStatus.invited}),
  );

  static Future<List<String>> rolesOf(Session session, UuidValue membershipId) async {
    final rows = await TenantMembershipRole.db.find(
      session,
      where: (r) => r.membershipId.equals(membershipId),
      orderBy: (r) => r.roleCode,
    );
    return [for (final r in rows) r.roleCode];
  }

  /// Permissões efetivas (`<recurso>.<ação>`) dos papéis do vínculo.
  static Future<List<String>> permissionsOf(Session session, UuidValue membershipId) async {
    final result = await session.db.unsafeQuery(
      'SELECT DISTINCT p.code '
      '  FROM app.tenant_membership_roles mr '
      '  JOIN app.roles r ON r.code = mr.role_code '
      '  JOIN app.role_permissions rp ON rp.role_id = r.id '
      '  JOIN app.permissions p ON p.id = rp.permission_id '
      ' WHERE mr.membership_id = @membershipId::uuid '
      ' ORDER BY 1',
      // O driver não infere o tipo de UuidValue em SQL próprio: texto + cast
      // explícito (achado do spike S2, docs/spikes/S1-S2-serverpod-rls.md).
      parameters: QueryParameters.named({'membershipId': membershipId.uuid}),
    );
    return [for (final row in result) row[0] as String];
  }

  /// Mapeia o `sub` do Keycloak para `users.id` antes de existir `app.user_id`
  /// (função SECURITY DEFINER `app.find_user_by_idp_subject`).
  static Future<({UuidValue userId, String status})?> findUserByIdpSubject(Session session, String subject) async {
    final result = await session.db.unsafeQuery(
      'SELECT user_id, status FROM app.find_user_by_idp_subject(@subject)',
      parameters: QueryParameters.named({'subject': subject}),
    );
    if (result.isEmpty) return null;
    final row = result.first;
    final id = row[0];
    return (userId: id is UuidValue ? id : UuidValue.withValidation(id.toString()), status: row[1] as String);
  }
}
