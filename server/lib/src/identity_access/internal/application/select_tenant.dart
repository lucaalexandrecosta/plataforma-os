import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/providers/email.dart';

import '../../../generated/protocol.dart';
import '../../../platform/auth/authentication_handler.dart';
import '../../../platform/auth/token_claims.dart';
import '../../../platform/context/request_context.dart';
import '../../../platform/errors/api_errors.dart';
import '../../../tenancy/tenancy.dart';
import 'memberships.dart';

/// Troca a sessão de login (e-mail e senha) por um token de tenant de 10 min
/// (docs/04 §4.2 e §4.3; docs/08 §2.2, `auth.selectTenant`).
///
/// Passos: conta de login → usuário da equipe (`idp_subject`; no primeiro
/// acesso, liga pelo e-mail verificado) → tenant operacional → vínculo ativo
/// ou convidado (o convite é aceito aqui) com papel → token ES256 com `tid`
/// assinado. Qualquer falha de vínculo responde `FORBIDDEN` sem dizer se o
/// tenant existe.
///
/// Pendências para os próximos incrementos:
/// * `deviceProof` obrigatório no app do técnico (docs/04 §4.4), com o
///   registro de dispositivos;
/// * conferência de host `<slug>.<dominio>` × tenant (`TENANT_MISMATCH`).
Future<TenantToken> selectTenant(Session session, {required String tenantSlug, required bool technicianApp}) async {
  final login = session.authenticated;
  // Token de tenant (com contexto) não serve aqui: só a sessão de login.
  if (login == null || session.contextOrNull != null) throw ApiErrors.unauthenticated(session);
  session.attachContext(RequestContext.anonymous(correlationId: session.correlationId));

  final subject = login.userIdentifier;
  final user = await Memberships.findUserByIdpSubject(session, subject) ?? await _linkByEmail(session, subject);
  if (user == null || user.status != 'active') throw ApiErrors.forbidden(session);

  // Identificado, ainda sem tenant: a RLS libera só os próprios vínculos.
  session.attachContext(RequestContext.userWithoutTenant(userId: user.userId, correlationId: session.correlationId));

  final tenant = await TenantDirectory.findBySlug(session, tenantSlug);
  if (tenant == null) throw ApiErrors.forbidden(session);
  if (!TenantDirectory.isOperational(tenant)) throw ApiErrors.tenantSuspended(session);

  final membership = (await Memberships.ofUser(session, user.userId)).where((m) => m.tenantId == tenant.id).firstOrNull;
  if (membership == null) throw ApiErrors.forbidden(session);
  final roles = await Memberships.rolesOf(session, membership.id);
  if (roles.isEmpty) throw ApiErrors.forbidden(session);

  if (technicianApp && !roles.contains('technician') && !roles.contains('dispatcher')) {
    throw ApiErrors.forbidden(session, 'Este usuário não tem acesso ao app do técnico.');
  }
  final actorType = technicianApp && roles.contains('technician') ? ActorType.technician : ActorType.user;

  // Daqui em diante, no contexto do tenant: aceite do convite e último acesso
  // passam pela RLS e pela auditoria.
  session.attachContext(
    RequestContext.tenant(
      tenantId: tenant.id,
      userId: user.userId,
      actorType: actorType,
      membershipId: membership.id,
      correlationId: session.correlationId,
    ),
  );
  await Memberships.recordAccess(session, membership);

  final services = PlatformAuth.instance;
  final issued = services.accessTokens.issue(
    kind: TokenKind.staff,
    userId: user.userId,
    tenantId: tenant.id,
    actorType: actorType,
    sessionId: login.authId,
    membershipId: membership.id,
    roles: roles,
    authMethods: const ['pwd'],
  );

  return TenantToken(
    accessToken: issued.token,
    tokenType: 'Bearer',
    expiresIn: services.accessTokens.ttl.inSeconds,
    tenant: TenantDirectory.summary(tenant),
    roles: roles,
  );
}

/// Primeiro acesso: liga a conta de e-mail (já verificada pelo código) ao
/// usuário da equipe convidado com o mesmo e-mail.
Future<({UuidValue userId, String status})?> _linkByEmail(Session session, String subject) async {
  final authUserId = UuidValue.withValidation(subject);
  final account = await EmailAccount.db.findFirstRow(session, where: (a) => a.authUserId.equals(authUserId));
  if (account == null) return null;
  return Memberships.linkStaffUserByEmail(session, subject: subject, email: account.email);
}
