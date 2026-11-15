import 'package:serverpod/serverpod.dart';

import '../context/request_context.dart';
import 'access_token_service.dart';

/// Lista de revogação por `sid`/`did` (docs/04 §4.7). No MVP fica no Valkey;
/// esta interface permite trocar a implementação (memória em dev e testes).
abstract interface class RevocationList {
  Future<bool> isRevoked({required String sessionId, String? deviceId});
  Future<void> revokeSession(String sessionId, {required Duration ttl});
}

final class InMemoryRevocationList implements RevocationList {
  final _revoked = <String, DateTime>{};

  @override
  Future<bool> isRevoked({required String sessionId, String? deviceId}) async {
    final now = DateTime.now().toUtc();
    _revoked.removeWhere((_, until) => until.isBefore(now));
    return _revoked.containsKey('sid:$sessionId') || (deviceId != null && _revoked.containsKey('did:$deviceId'));
  }

  @override
  Future<void> revokeSession(String sessionId, {required Duration ttl}) async {
    _revoked['sid:$sessionId'] = DateTime.now().toUtc().add(ttl);
  }
}

/// Tokens próprios da plataforma configurados na inicialização (server.dart).
///
/// Não confundir com o `AuthServices` do módulo de login do Serverpod, que
/// cuida da conta de e-mail e senha e da sessão de login (JWT HS512).
final class PlatformAuth {
  PlatformAuth._(this.accessTokens, this.revocations);

  static PlatformAuth? _instance;

  static PlatformAuth get instance =>
      _instance ?? (throw StateError('PlatformAuth não configurado: chame PlatformAuth.configure() no startup.'));

  static void configure({required AccessTokenService accessTokens, RevocationList? revocations}) {
    _instance = PlatformAuth._(accessTokens, revocations ?? InMemoryRevocationList());
  }

  final AccessTokenService accessTokens;
  final RevocationList revocations;
}

/// Handler de autenticação do Serverpod (docs/04 §4.2): aceita só os tokens
/// próprios ES256, consulta a revogação e anexa o [RequestContext] à sessão,
/// que o interceptor de banco usa para aplicar o tenant.
Future<AuthenticationInfo?> tokenAuthenticationHandler(Session session, String token) async {
  final services = PlatformAuth.instance;
  final claims = services.accessTokens.verify(token);
  if (claims == null) return null;
  if (await services.revocations.isRevoked(sessionId: claims.sessionId, deviceId: claims.deviceId?.uuid)) {
    return null;
  }
  session.attachContext(claims.toRequestContext(session.correlationId));
  return AuthenticationInfo(
    claims.subject.uuid,
    {claims.kind.scope, for (final role in claims.roles) Scope('role:$role')},
    authId: claims.sessionId,
  );
}

/// Handler combinado (login próprio, 15/11/2026):
///
/// 1. token próprio ES256 do tenant → contexto do tenant (endpoints da equipe);
/// 2. senão, sessão de login do módulo de e-mail (JWT) → só identifica a conta,
///    sem contexto; serve apenas para `auth.selectTenant` e para o próprio
///    módulo. Os endpoints da equipe continuam exigindo o escopo `token:staff`,
///    que esse JWT não tem.
AuthenticationHandler platformAuthenticationHandler(AuthenticationHandler loginSessionHandler) =>
    (session, token) async =>
        await tokenAuthenticationHandler(session, token) ?? await loginSessionHandler(session, token);
