import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:web/web.dart' as web;

import '../config/app_config.dart';

/// Fluxo OIDC Authorization Code + PKCE (S256) no navegador, contra o Keycloak
/// (docs/04 §4.3 e §6.3).
///
/// Tokens só em memória. `state`, `nonce`, `code_verifier` e o slug pedido
/// atravessam o redirecionamento no `sessionStorage` (aba atual) e são
/// apagados na volta.
final class OidcClient {
  OidcClient(this.config, {http.Client? httpClient}) : _http = httpClient ?? http.Client();

  final AppConfig config;
  final http.Client _http;

  static const _pendingKey = 'po.oidc.pending';
  static const _signedInKey = 'po.oidc.signedIn';

  /// Vai para a tela de login do Keycloak. Com [silent], `prompt=none`: se a
  /// sessão SSO ainda existir, volta sem pedir senha (recarga da página).
  void redirectToLogin({required String tenantSlug, bool silent = false}) {
    final verifier = _random(48);
    final state = _random(24);
    final nonce = _random(24);
    web.window.sessionStorage.setItem(
      _pendingKey,
      jsonEncode({'state': state, 'nonce': nonce, 'verifier': verifier, 'slug': tenantSlug, 'silent': silent}),
    );
    final challenge = base64Url.encode(sha256.convert(utf8.encode(verifier)).bytes).replaceAll('=', '');
    final url = Uri.parse('${config.idpIssuer}/protocol/openid-connect/auth').replace(
      queryParameters: {
        'client_id': config.clientId,
        'redirect_uri': config.redirectUri,
        'response_type': 'code',
        'scope': 'openid profile email',
        'state': state,
        'nonce': nonce,
        'code_challenge': challenge,
        'code_challenge_method': 'S256',
        if (silent) 'prompt': 'none',
      },
    );
    web.window.location.assign(url.toString());
  }

  /// Já houve login nesta aba? (decide se a recarga tenta o login silencioso)
  bool get wasSignedIn => web.window.sessionStorage.getItem(_signedInKey) == '1';

  void markSignedIn() => web.window.sessionStorage.setItem(_signedInKey, '1');

  /// Volta do Keycloak (`/auth/callback?code=...&state=...`). Devolve `null`
  /// se a URL não for um retorno de login.
  Future<OidcCallbackResult?> handleCallback(Uri uri) async {
    final params = uri.queryParameters;
    if (!params.containsKey('code') && !params.containsKey('error')) return null;
    final raw = web.window.sessionStorage.getItem(_pendingKey);
    web.window.sessionStorage.removeItem(_pendingKey);
    if (raw == null) return const OidcCallbackResult.failure('Sessão de login expirada. Entre de novo.');
    final pending = jsonDecode(raw) as Map<String, Object?>;
    final slug = pending['slug'] as String?;
    final silent = pending['silent'] == true;

    if (params['state'] != pending['state']) {
      return OidcCallbackResult.failure('Resposta de login inválida. Entre de novo.', tenantSlug: slug);
    }
    final error = params['error'];
    if (error != null) {
      // login_required no modo silencioso = a sessão SSO acabou: mostra o login.
      return OidcCallbackResult.failure(
        silent ? null : 'O login não foi concluído ($error).',
        tenantSlug: slug,
        loginRequired: error == 'login_required' || error == 'interaction_required',
      );
    }

    final response = await _http.post(
      Uri.parse('${config.idpIssuer}/protocol/openid-connect/token'),
      body: {
        'grant_type': 'authorization_code',
        'client_id': config.clientId,
        'code': params['code']!,
        'redirect_uri': config.redirectUri,
        'code_verifier': pending['verifier']! as String,
      },
    );
    if (response.statusCode != 200) {
      return OidcCallbackResult.failure('Não foi possível concluir o login.', tenantSlug: slug);
    }
    final tokens = OidcTokens.fromJson(jsonDecode(response.body) as Map<String, Object?>);
    if (_nonceOf(tokens.idToken) != pending['nonce']) {
      return OidcCallbackResult.failure('Resposta de login inválida. Entre de novo.', tenantSlug: slug);
    }
    return OidcCallbackResult.success(tokens, tenantSlug: slug);
  }

  /// Renova o token do IdP pelo refresh token (em memória).
  Future<OidcTokens?> refresh(OidcTokens current) async {
    final refreshToken = current.refreshToken;
    if (refreshToken == null) return null;
    final response = await _http.post(
      Uri.parse('${config.idpIssuer}/protocol/openid-connect/token'),
      body: {'grant_type': 'refresh_token', 'client_id': config.clientId, 'refresh_token': refreshToken},
    );
    if (response.statusCode != 200) return null;
    return OidcTokens.fromJson(jsonDecode(response.body) as Map<String, Object?>);
  }

  /// Sai do Keycloak também (encerra a sessão SSO) e volta para a origem.
  void logout(OidcTokens? tokens) {
    web.window.sessionStorage.removeItem(_signedInKey);
    final url = Uri.parse('${config.idpIssuer}/protocol/openid-connect/logout').replace(
      queryParameters: {
        'client_id': config.clientId,
        'post_logout_redirect_uri': '${config.origin}/',
        if (tokens?.idToken != null) 'id_token_hint': tokens!.idToken!,
      },
    );
    web.window.location.assign(url.toString());
  }

  static String? _nonceOf(String? idToken) {
    if (idToken == null) return null;
    final parts = idToken.split('.');
    if (parts.length != 3) return null;
    try {
      final payload = jsonDecode(utf8.decode(base64Url.decode(base64Url.normalize(parts[1])))) as Map<String, Object?>;
      return payload['nonce'] as String?;
    } on FormatException {
      return null;
    }
  }

  static String _random(int bytes) {
    final r = Random.secure();
    return base64Url.encode(List<int>.generate(bytes, (_) => r.nextInt(256))).replaceAll('=', '');
  }
}

final class OidcTokens {
  const OidcTokens({required this.accessToken, required this.expiresAt, this.refreshToken, this.idToken});

  factory OidcTokens.fromJson(Map<String, Object?> json) => OidcTokens(
    accessToken: json['access_token']! as String,
    refreshToken: json['refresh_token'] as String?,
    idToken: json['id_token'] as String?,
    expiresAt: DateTime.now().add(Duration(seconds: (json['expires_in'] as num?)?.toInt() ?? 300)),
  );

  final String accessToken;
  final String? refreshToken;
  final String? idToken;
  final DateTime expiresAt;
}

final class OidcCallbackResult {
  const OidcCallbackResult.success(OidcTokens this.tokens, {this.tenantSlug}) : error = null, loginRequired = false;

  const OidcCallbackResult.failure(this.error, {this.tenantSlug, this.loginRequired = false}) : tokens = null;

  final OidcTokens? tokens;
  final String? tenantSlug;

  /// Mensagem para a tela de login (`null` = só mostrar o login, sem erro).
  final String? error;
  final bool loginRequired;
}
