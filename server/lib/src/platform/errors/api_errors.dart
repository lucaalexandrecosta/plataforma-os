import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Fábricas das exceções do catálogo (docs/08 §2.8). Mensagens em pt-BR.
abstract final class ApiErrors {
  static ApiException _make(Session session, String code, ErrorCategory category, String detail) =>
      ApiException(code: code, category: category, detail: detail, traceId: session.sessionId.uuid);

  static ApiException unauthenticated(Session session, [String detail = 'Credencial ausente ou inválida.']) =>
      _make(session, 'UNAUTHENTICATED', ErrorCategory.unauthenticated, detail);

  static ApiException forbidden(Session session, [String detail = 'Você não tem permissão para esta ação.']) =>
      _make(session, 'FORBIDDEN', ErrorCategory.forbidden, detail);

  static ApiException tenantSuspended(Session session) =>
      _make(session, 'TENANT_SUSPENDED', ErrorCategory.forbidden, 'A conta desta empresa está suspensa.');

  /// Inexistente **ou** de outro tenant: nunca revela que existe em outro.
  static ApiException notFound(Session session, [String detail = 'Registro não encontrado.']) =>
      _make(session, 'NOT_FOUND', ErrorCategory.notFound, detail);

  static ApiException validation(Session session, List<FieldError> fieldErrors) => ApiException(
    code: 'VALIDATION_FAILED',
    category: ErrorCategory.validation,
    detail: 'Confira os campos informados.',
    traceId: session.sessionId.uuid,
    fieldErrors: fieldErrors,
  );
}
