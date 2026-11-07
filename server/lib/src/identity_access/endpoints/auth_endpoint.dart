import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/application/exchange_idp_token.dart' as uc;

/// `auth.*` — métodos sem login (o token do Keycloak vem como parâmetro).
class AuthEndpoint extends PublicEndpoint {
  /// Troca o access token do Keycloak (realm `staff`) por um token de tenant.
  ///
  /// Erros: `UNAUTHENTICATED` (token do IdP inválido), `FORBIDDEN` (sem vínculo
  /// ativo no tenant, ou tenant inexistente), `TENANT_SUSPENDED`.
  Future<TenantToken> exchangeIdpToken(Session session, String idpToken, String tenantSlug) =>
      uc.exchangeIdpToken(session, idpToken: idpToken, tenantSlug: tenantSlug);
}
