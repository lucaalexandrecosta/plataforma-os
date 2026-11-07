import 'package:serverpod/serverpod.dart';

import '../auth/token_claims.dart';
import '../context/request_context.dart';

/// Classes-base por tipo de token (docs/08 §2.2): um token de contato nunca
/// passa num endpoint da equipe e vice-versa. A permissão fina (papel, escopo
/// de carteira, prestador ou filial) é conferida por método.

/// Backoffice e técnico: exige token de tenant (`aud = plataforma-os:staff`).
abstract class StaffEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {TokenKind.staff.scope};
}

/// App do cliente: exige token de contato.
abstract class CustomerEndpoint extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {TokenKind.customer.scope};
}

/// Métodos públicos (QR, OTP, troca de token). Cada método chama
/// `session.useAnonymousContext()` antes de usar o banco.
///
/// Atenção: todo método público de uma classe de endpoint vira RPC no
/// Serverpod; helpers ficam em extensões ou em `internal/`, nunca aqui.
abstract class PublicEndpoint extends Endpoint {
  @override
  bool get requireLogin => false;
}

extension AnonymousContext on Session {
  /// Anexa o contexto anônimo, se ainda não houver contexto.
  void useAnonymousContext() {
    if (contextOrNull == null) {
      attachContext(RequestContext.anonymous(correlationId: correlationId));
    }
  }
}
