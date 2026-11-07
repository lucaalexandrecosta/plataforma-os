import 'package:serverpod/serverpod.dart';

import '../context/request_context.dart';
import 'access_token_service.dart';
import 'idp_token_verifier.dart';

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

/// Serviços de autenticação configurados na inicialização (server.dart).
final class AuthServices {
  AuthServices._(this.accessTokens, this.idpTokens, this.revocations);

  static AuthServices? _instance;

  static AuthServices get instance =>
      _instance ?? (throw StateError('AuthServices não configurado: chame AuthServices.configure() no startup.'));

  static void configure({
    required AccessTokenService accessTokens,
    required IdpTokenVerifier idpTokens,
    RevocationList? revocations,
  }) {
    _instance = AuthServices._(accessTokens, idpTokens, revocations ?? InMemoryRevocationList());
  }

  final AccessTokenService accessTokens;
  final IdpTokenVerifier idpTokens;
  final RevocationList revocations;
}

/// Handler de autenticação do Serverpod (docs/04 §4.2): aceita só os tokens
/// próprios ES256, consulta a revogação e anexa o [RequestContext] à sessão,
/// que o interceptor de banco usa para aplicar o tenant.
Future<AuthenticationInfo?> tokenAuthenticationHandler(Session session, String token) async {
  final services = AuthServices.instance;
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
