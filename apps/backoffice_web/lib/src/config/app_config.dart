import 'package:web/web.dart' as web;

import 'tenant_host.dart';

/// Configuração do backoffice. Em dev os padrões apontam para o ambiente de
/// `infra/local`; em homologação e produção vêm de `--dart-define` no build.
///
/// Produção (docs/02 §2.3): o backoffice roda em `<slug>.platform-lac.com.br`
/// e fala com a API na mesma origem (`/api/`, encaminhado pela CDN); o login é
/// em `auth.platform-lac.com.br`.
final class AppConfig {
  const AppConfig({
    required this.apiUrl,
    required this.idpIssuer,
    required this.clientId,
    required this.origin,
    required this.tenantSlug,
  });

  factory AppConfig.fromEnvironment() {
    final location = web.window.location;
    final origin = location.origin;
    const api = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8080/');
    return AppConfig(
      apiUrl: api.endsWith('/') ? api : '$api/',
      idpIssuer: const String.fromEnvironment('IDP_ISSUER', defaultValue: 'http://localhost:8180/realms/staff'),
      clientId: const String.fromEnvironment('IDP_CLIENT_ID', defaultValue: 'backoffice-web'),
      origin: origin,
      tenantSlug: tenantSlugFromHost(location.hostname),
    );
  }

  final String apiUrl;
  final String idpIssuer;
  final String clientId;

  /// `http://frio-sul.localhost:8090`, por exemplo.
  final String origin;

  /// Do subdomínio (`frio-sul.localhost` → `frio-sul`). `null` na entrada
  /// genérica (`localhost` / `app.<dominio>`): a tela de login pede a empresa.
  final String? tenantSlug;

  String get redirectUri => '$origin/auth/callback';
}
