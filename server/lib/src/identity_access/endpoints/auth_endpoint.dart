import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../internal/application/select_tenant.dart' as uc;

/// `auth.*` — escolha do tenant depois do login por e-mail e senha.
///
/// Exige a sessão de login do módulo (`emailIdp.login`), sem escopo: o token
/// de tenant não é aceito aqui.
class AuthEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  /// Troca a sessão de login por um token de tenant (10 min).
  ///
  /// [technicianApp] = chamada do app de campo: exige papel de técnico ou
  /// coordenador.
  ///
  /// Erros: `UNAUTHENTICATED` (sem sessão de login), `FORBIDDEN` (sem vínculo
  /// no tenant, ou tenant inexistente), `TENANT_SUSPENDED`.
  Future<TenantToken> selectTenant(Session session, String tenantSlug, {bool? technicianApp}) =>
      uc.selectTenant(session, tenantSlug: tenantSlug, technicianApp: technicianApp ?? false);

  /// Empresas em que o usuário da sessão de login pode entrar, em ordem de
  /// nome. Erros: `UNAUTHENTICATED`, `FORBIDDEN` (usuário inativo ou sem
  /// convite).
  Future<List<TenantSummary>> myTenants(Session session) => uc.myTenants(session);
}
