import 'package:serverpod/serverpod.dart';

import '../context/request_context.dart';

/// Tipo do token próprio (docs/04 §4.2). Define o `aud` e o escopo do
/// Serverpod que separa os grupos de endpoints (docs/08 §2.2).
enum TokenKind {
  staff('plataforma-os:staff', 'tenant-access+jwt'),
  customer('plataforma-os:customer', 'customer-access+jwt');

  const TokenKind(this.audience, this.type);

  final String audience;

  /// Cabeçalho `typ`: impede usar um tipo de token no lugar de outro.
  final String type;

  /// Escopo do Serverpod exigido pelas classes-base de endpoint.
  Scope get scope => Scope('token:$name');

  static TokenKind? fromAudience(String? aud) {
    for (final kind in values) {
      if (kind.audience == aud) return kind;
    }
    return null;
  }
}

/// Claims dos tokens emitidos pela `api` (docs/04 §4.2). Sem dados pessoais.
final class TokenClaims {
  const TokenClaims({
    required this.kind,
    required this.subject,
    required this.tenantId,
    required this.actorType,
    required this.sessionId,
    required this.tokenId,
    required this.issuedAt,
    required this.expiresAt,
    this.membershipId,
    this.deviceId,
    this.roles = const [],
    this.authMethods = const [],
  });

  final TokenKind kind;

  /// `sub` = `users.id`.
  final UuidValue subject;

  /// `tid` = tenant ativo.
  final UuidValue tenantId;

  /// `act`.
  final ActorType actorType;

  /// `mid` = `tenant_memberships.id` (equipe).
  final UuidValue? membershipId;

  /// `sid`: sessão do IdP (equipe) ou `auth_sessions.id` (contato).
  final String sessionId;

  /// `did` = `devices.id` (apps móveis).
  final UuidValue? deviceId;

  /// Só para a UI: o servidor reavalia papéis e permissões pelo banco.
  final List<String> roles;

  /// `amr`.
  final List<String> authMethods;

  /// `jti`.
  final String tokenId;
  final DateTime issuedAt;
  final DateTime expiresAt;

  Map<String, Object?> toPayload() => {
    'sub': subject.uuid,
    'tid': tenantId.uuid,
    'act': actorType.dbValue,
    if (membershipId != null) 'mid': membershipId!.uuid,
    'sid': sessionId,
    if (deviceId != null) 'did': deviceId!.uuid,
    'roles': roles,
    if (authMethods.isNotEmpty) 'amr': authMethods,
    'jti': tokenId,
  };

  static TokenClaims fromPayload(TokenKind kind, Map<String, dynamic> p) {
    UuidValue uuid(String key) => UuidValue.withValidation(p[key] as String);
    UuidValue? optUuid(String key) => p[key] == null ? null : uuid(key);
    final act = p['act'] as String;
    return TokenClaims(
      kind: kind,
      subject: uuid('sub'),
      tenantId: uuid('tid'),
      actorType: ActorType.values.firstWhere((a) => a.dbValue == act),
      membershipId: optUuid('mid'),
      sessionId: p['sid'] as String,
      deviceId: optUuid('did'),
      roles: [for (final r in (p['roles'] as List<dynamic>? ?? const [])) r as String],
      authMethods: [for (final m in (p['amr'] as List<dynamic>? ?? const [])) m as String],
      tokenId: p['jti'] as String,
      issuedAt: DateTime.fromMillisecondsSinceEpoch((p['iat'] as int) * 1000, isUtc: true),
      expiresAt: DateTime.fromMillisecondsSinceEpoch((p['exp'] as int) * 1000, isUtc: true),
    );
  }

  RequestContext toRequestContext(String correlationId) => RequestContext.tenant(
    tenantId: tenantId,
    userId: subject,
    actorType: actorType,
    correlationId: correlationId,
    membershipId: membershipId,
    sessionId: sessionId,
    deviceId: deviceId,
    roles: roles.toSet(),
  );
}
