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

  /// Já existe (ex.: pessoa já tem acesso à empresa).
  static ApiException conflict(Session session, String code, String detail) =>
      _make(session, code, ErrorCategory.conflict, detail);

  /// Regra de negócio impede a ação (ex.: tirar o último administrador).
  static ApiException businessRule(Session session, String code, String detail) =>
      _make(session, code, ErrorCategory.businessRule, detail);

  /// Concorrência otimista (docs/02 §5.5): o registro mudou desde a leitura.
  static ApiException versionMismatch(Session session, int currentVersion) => ApiException(
    code: 'VERSION_MISMATCH',
    category: ErrorCategory.versionMismatch,
    detail: 'Este registro foi alterado por outra pessoa. Recarregue e tente de novo.',
    traceId: session.sessionId.uuid,
    currentVersion: currentVersion,
  );

  static ApiException fieldError(Session session, String path, String code, String message) =>
      validation(session, [FieldError(path: path, code: code, message: message)]);
}
