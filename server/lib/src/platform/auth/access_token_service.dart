import 'dart:math';

import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:serverpod/serverpod.dart';

import '../context/request_context.dart';
import 'token_claims.dart';

/// Par de chaves ES256 com `kid`. Em produção a privada vem do cofre e é
/// rotacionada a cada 90 dias, com duas chaves válidas na transição (docs/04 §4.2).
final class SigningKey {
  SigningKey({required this.kid, required String publicKeyPem, String? privateKeyPem})
    : publicKey = ECPublicKey(publicKeyPem),
      privateKey = privateKeyPem == null ? null : ECPrivateKey(privateKeyPem);

  final String kid;
  final ECPublicKey publicKey;

  /// `null` para chaves antigas que só validam.
  final ECPrivateKey? privateKey;
}

/// Emite e valida os tokens próprios da `api` (JWT ES256).
///
/// Na validação (docs/04 §4.2, item 1): só `alg = ES256`, `kid` conhecido,
/// `typ` e `aud` do tipo esperado, `iss` da plataforma, `exp` com 60 s de
/// tolerância. A biblioteca JOSE é escolha provisória do spike S1.
final class AccessTokenService {
  AccessTokenService({
    required this.issuer,
    required List<SigningKey> keys,
    required this.activeKid,
    this.ttl = const Duration(minutes: 10),
    this.clockSkew = const Duration(seconds: 60),
    DateTime Function()? clock,
  }) : _keys = {for (final k in keys) k.kid: k},
       _clock = clock ?? DateTime.now {
    final active = _keys[activeKid];
    if (active == null || active.privateKey == null) {
      throw ArgumentError('A chave ativa "$activeKid" precisa existir e ter a chave privada.');
    }
  }

  final String issuer;
  final String activeKid;
  final Duration ttl;
  final Duration clockSkew;
  final Map<String, SigningKey> _keys;
  final DateTime Function() _clock;
  final _random = Random.secure();

  /// Emite um token de [kind] para o contexto informado.
  ({String token, TokenClaims claims}) issue({
    required TokenKind kind,
    required UuidValue userId,
    required UuidValue tenantId,
    required ActorType actorType,
    required String sessionId,
    UuidValue? membershipId,
    UuidValue? deviceId,
    List<String> roles = const [],
    List<String> authMethods = const [],
  }) {
    final now = _clock().toUtc();
    final issuedAt = DateTime.fromMillisecondsSinceEpoch(now.millisecondsSinceEpoch ~/ 1000 * 1000, isUtc: true);
    final claims = TokenClaims(
      kind: kind,
      subject: userId,
      tenantId: tenantId,
      actorType: actorType,
      membershipId: membershipId,
      sessionId: sessionId,
      deviceId: deviceId,
      roles: roles,
      authMethods: authMethods,
      tokenId: _newTokenId(),
      issuedAt: issuedAt,
      expiresAt: issuedAt.add(ttl),
    );
    final payload = {
      ...claims.toPayload(),
      'iss': issuer,
      'aud': kind.audience,
      'iat': issuedAt.millisecondsSinceEpoch ~/ 1000,
      'exp': claims.expiresAt.millisecondsSinceEpoch ~/ 1000,
    };
    final jwt = JWT(payload, header: {'kid': activeKid, 'typ': kind.type});
    final token = jwt.sign(_keys[activeKid]!.privateKey!, algorithm: JWTAlgorithm.ES256, noIssueAt: true);
    return (token: token, claims: claims);
  }

  /// Valida o token e devolve as claims, ou `null` se for inválido por
  /// qualquer motivo (sem distinguir o motivo para quem chamou).
  TokenClaims? verify(String token) {
    final JWT unverified;
    try {
      unverified = JWT.decode(token);
    } on Object {
      return null;
    }
    final header = unverified.header ?? const <String, dynamic>{};
    if (header['alg'] != 'ES256') return null; // impede troca de algoritmo e "none"
    final key = _keys[header['kid']];
    if (key == null) return null;
    final payload = unverified.payload;
    if (payload is! Map<String, dynamic>) return null;
    final kind = TokenKind.fromAudience(payload['aud'] as String?);
    if (kind == null || header['typ'] != kind.type) return null;

    try {
      JWT.verify(token, key.publicKey, checkHeaderType: false, checkExpiresIn: false, issuer: issuer);
    } on JWTException {
      return null;
    }

    final exp = payload['exp'];
    if (exp is! int) return null;
    final now = _clock().toUtc();
    if (DateTime.fromMillisecondsSinceEpoch(exp * 1000, isUtc: true).add(clockSkew).isBefore(now)) return null;

    try {
      return TokenClaims.fromPayload(kind, payload);
    } on Object {
      return null;
    }
  }

  String _newTokenId() {
    const hex = '0123456789abcdef';
    return List.generate(32, (_) => hex[_random.nextInt(16)]).join();
  }
}
