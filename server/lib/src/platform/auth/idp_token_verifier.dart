import 'dart:convert';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:http/http.dart' as http;

/// Identidade validada do token do Keycloak (realm `staff`).
final class IdpIdentity {
  const IdpIdentity({
    required this.subject,
    required this.sessionId,
    required this.clientId,
    this.authMethods = const [],
  });

  /// `sub` do Keycloak = `users.idp_subject`.
  final String subject;

  /// `sid` da sessão do IdP (revogação no logout, docs/04 §4.7).
  final String sessionId;

  /// `azp`: cliente OIDC que obteve o token (backoffice-web, technician-app).
  final String clientId;
  final List<String> authMethods;
}

/// Valida o access token do Keycloak pela JWKS do realm, com cache.
///
/// O token do IdP só é aceito como parâmetro de `auth.exchangeIdpToken`, nunca
/// pelo handler de autenticação (docs/08 §2.2).
final class IdpTokenVerifier {
  IdpTokenVerifier({
    required this.issuer,
    required this.allowedClients,
    Uri? jwksUri,
    http.Client? httpClient,
    this.cacheTtl = const Duration(minutes: 10),
    this.clockSkew = const Duration(seconds: 60),
    DateTime Function()? clock,
  }) : jwksUri = jwksUri ?? Uri.parse('$issuer/protocol/openid-connect/certs'),
       _http = httpClient ?? http.Client(),
       _clock = clock ?? DateTime.now;

  /// Ex.: `http://localhost:8180/realms/staff`.
  final String issuer;
  final Uri jwksUri;
  final Set<String> allowedClients;
  final Duration cacheTtl;
  final Duration clockSkew;
  final http.Client _http;
  final DateTime Function() _clock;

  Map<String, RSAPublicKey> _keys = const {};
  DateTime _fetchedAt = DateTime.fromMillisecondsSinceEpoch(0, isUtc: true);

  Future<IdpIdentity?> verify(String token) async {
    final JWT unverified;
    try {
      unverified = JWT.decode(token);
    } on Object {
      return null;
    }
    final header = unverified.header ?? const <String, dynamic>{};
    if (header['alg'] != 'RS256') return null;
    final kid = header['kid'];
    if (kid is! String) return null;

    var key = (await _currentKeys())[kid];
    if (key == null) {
      // kid novo após rotação no Keycloak: força uma releitura da JWKS.
      key = (await _currentKeys(force: true))[kid];
      if (key == null) return null;
    }

    final JWT jwt;
    try {
      jwt = JWT.verify(token, key, checkExpiresIn: false, checkHeaderType: false, issuer: issuer);
    } on JWTException {
      return null;
    }
    final p = jwt.payload;
    if (p is! Map<String, dynamic>) return null;
    final exp = p['exp'];
    if (exp is! int ||
        DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true).add(clockSkew).isBefore(_clock().toUtc())) {
      return null;
    }
    if (p['typ'] != null && p['typ'] != 'Bearer') return null; // recusa id_token e refresh_token
    final azp = p['azp'];
    if (azp is! String || !allowedClients.contains(azp)) return null;
    final sub = p['sub'];
    if (sub is! String || sub.isEmpty) return null;
    return IdpIdentity(
      subject: sub,
      sessionId: (p['sid'] as String?) ?? (p['jti'] as String? ?? ''),
      clientId: azp,
      authMethods: [for (final m in (p['amr'] as List<dynamic>? ?? const [])) m.toString()],
    );
  }

  Future<Map<String, RSAPublicKey>> _currentKeys({bool force = false}) async {
    final now = _clock().toUtc();
    if (!force && now.difference(_fetchedAt) < cacheTtl && _keys.isNotEmpty) return _keys;
    final response = await _http.get(jwksUri);
    if (response.statusCode != 200) return _keys;
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final keys = <String, RSAPublicKey>{};
    for (final raw in (body['keys'] as List<dynamic>? ?? const [])) {
      final jwk = raw as Map<String, dynamic>;
      if (jwk['kty'] != 'RSA' || (jwk['use'] != null && jwk['use'] != 'sig')) continue;
      final x5c = jwk['x5c'] as List<dynamic>?;
      final kid = jwk['kid'] as String?;
      if (kid == null || x5c == null || x5c.isEmpty) continue;
      keys[kid] = RSAPublicKey.cert('-----BEGIN CERTIFICATE-----\n${x5c.first}\n-----END CERTIFICATE-----');
    }
    _keys = keys;
    _fetchedAt = now;
    return _keys;
  }
}
