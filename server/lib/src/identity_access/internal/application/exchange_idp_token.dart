import 'package:serverpod/serverpod.dart';

import '../../../generated/protocol.dart';
import '../../../platform/auth/authentication_handler.dart';
import '../../../platform/auth/token_claims.dart';
import '../../../platform/context/request_context.dart';
import '../../../platform/errors/api_errors.dart';
import '../../../tenancy/tenancy.dart';
import 'memberships.dart';

/// Troca o access token do Keycloak por um token de tenant de 10 min
/// (docs/04 §4.2 e §4.3; docs/08 §2.2, `auth.exchangeIdpToken`).
///
/// Passos: valida o token do IdP pela JWKS → mapeia `sub` → `users.id` →
/// confere tenant operacional e vínculo ativo com papel → emite o token ES256
/// com `tid` assinado. Qualquer falha de vínculo responde `FORBIDDEN` sem
/// dizer se o tenant existe.
///
/// Pendências registradas para os próximos incrementos:
/// * `deviceProof` obrigatório no app do técnico (docs/04 §4.4) — entra com o
///   registro de dispositivos, na etapa 5 do guia;
/// * provisionamento JIT do usuário no primeiro login (convite aceito no IdP);
/// * conferência de host `<slug>.<dominio>` × tenant (`TENANT_MISMATCH`).
Future<TenantToken> exchangeIdpToken(Session session, {required String idpToken, required String tenantSlug}) async {
  session.attachContext(RequestContext.anonymous(correlationId: session.correlationId));
  final services = AuthServices.instance;

  final identity = await services.idpTokens.verify(idpToken);
  if (identity == null) throw ApiErrors.unauthenticated(session);

  final user = await Memberships.findUserByIdpSubject(session, identity.subject);
  if (user == null || user.status != 'active') throw ApiErrors.forbidden(session);

  // Identificado, ainda sem tenant: a RLS libera só os próprios vínculos.
  session.attachContext(RequestContext.userWithoutTenant(userId: user.userId, correlationId: session.correlationId));

  final tenant = await TenantDirectory.findBySlug(session, tenantSlug);
  if (tenant == null) throw ApiErrors.forbidden(session);
  if (!TenantDirectory.isOperational(tenant)) throw ApiErrors.tenantSuspended(session);

  final membership = await Memberships.activeFor(session, userId: user.userId, tenantId: tenant.id);
  if (membership == null) throw ApiErrors.forbidden(session);
  final roles = await Memberships.rolesOf(session, membership.id);
  if (roles.isEmpty) throw ApiErrors.forbidden(session);

  final isTechnicianApp = identity.clientId == 'technician-app';
  if (isTechnicianApp && !roles.contains('technician') && !roles.contains('dispatcher')) {
    throw ApiErrors.forbidden(session, 'Este usuário não tem acesso ao app do técnico.');
  }

  final issued = services.accessTokens.issue(
    kind: TokenKind.staff,
    userId: user.userId,
    tenantId: tenant.id,
    actorType: isTechnicianApp && roles.contains('technician') ? ActorType.technician : ActorType.user,
    sessionId: identity.sessionId,
    membershipId: membership.id,
    roles: roles,
    authMethods: identity.authMethods,
  );

  return TenantToken(
    accessToken: issued.token,
    tokenType: 'Bearer',
    expiresIn: services.accessTokens.ttl.inSeconds,
    tenant: TenantDirectory.summary(tenant),
    roles: roles,
  );
}
