import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/application/user_admin.dart';

/// `users.*` — controle de usuários da empresa (permissão `users.manage`,
/// que o perfil `tenant_admin` tem).
///
/// Erros: `FORBIDDEN` (sem permissão), `VALIDATION_FAILED`, `NOT_FOUND`,
/// `ALREADY_MEMBER`, `LAST_TENANT_ADMIN`, `CANNOT_CHANGE_OWN_ACCESS`,
/// `INVALID_STATUS`, `NOT_INVITED`, `INVITE_EMAIL_FAILED` (convite salvo, e-mail
/// não saiu).
class UsersEndpoint extends StaffEndpoint {
  /// Perfis que podem ser atribuídos.
  Future<List<AssignableRole>> roles(Session session) => UserAdmin.roles(session);

  /// Pessoas com acesso à empresa (convidadas, ativas e suspensas).
  Future<List<TenantUser>> list(Session session) => UserAdmin.list(session);

  /// Convida pelo e-mail. A pessoa cria a senha no primeiro acesso e, ao
  /// escolher a empresa, o convite vira acesso ativo.
  Future<TenantUser> invite(Session session, String email, String fullName, List<String> roles) =>
      UserAdmin.invite(session, email: email, fullName: fullName, roles: roles);

  /// Manda o e-mail de convite de novo (só para quem ainda não entrou).
  Future<TenantUser> resendInvite(Session session, UuidValue membershipId) =>
      UserAdmin.resendInvite(session, membershipId: membershipId);

  /// Troca os perfis (a lista substitui a anterior).
  Future<TenantUser> setRoles(Session session, UuidValue membershipId, List<String> roles) =>
      UserAdmin.setRoles(session, membershipId: membershipId, roles: roles);

  Future<TenantUser> suspend(Session session, UuidValue membershipId) =>
      UserAdmin.suspend(session, membershipId: membershipId);

  Future<TenantUser> reactivate(Session session, UuidValue membershipId) =>
      UserAdmin.reactivate(session, membershipId: membershipId);

  /// Tira o acesso; o histórico fica e a pessoa pode ser convidada de novo.
  Future<TenantUser> remove(Session session, UuidValue membershipId) =>
      UserAdmin.remove(session, membershipId: membershipId);
}
