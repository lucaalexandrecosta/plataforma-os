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

  /// Filtro, ordenação ou combinação não permitida (docs/08 §2.7).
  static ApiException invalidFilter(Session session, String detail) =>
      _make(session, 'INVALID_FILTER', ErrorCategory.validation, detail);

  /// Cursor adulterado, de outra listagem ou de outra combinação de filtros.
  static ApiException cursorMismatch(Session session) => _make(
    session,
    'CURSOR_MISMATCH',
    ErrorCategory.validation,
    'A listagem mudou desde a última página. Recarregue a partir do início.',
  );

  /// `id` enviado pelo cliente que não é UUID v7 aceitável (docs/08 §2.5).
  static ApiException invalidUuid(Session session, String path) => ApiException(
    code: 'INVALID_UUID',
    category: ErrorCategory.validation,
    detail: 'Identificador inválido.',
    traceId: session.sessionId.uuid,
    fieldErrors: [FieldError(path: path, code: 'invalid_uuid', message: 'Use um UUID v7 gerado pelo app.')],
  );

  /// `expectedVersion` diferente da atual (docs/08 §2.10): o app relê com `get`.
  static ApiException versionMismatch(Session session, int currentVersion) => ApiException(
    code: 'VERSION_MISMATCH',
    category: ErrorCategory.versionMismatch,
    detail: 'Este registro foi alterado por outra pessoa. Recarregue para ver a versão atual.',
    traceId: session.sessionId.uuid,
    currentVersion: currentVersion,
  );

  /// Violação de unicidade de negócio (ex.: código do cliente repetido).
  static ApiException duplicate(Session session, {required String path, required String message}) => ApiException(
    code: 'DUPLICATE',
    category: ErrorCategory.conflict,
    detail: message,
    traceId: session.sessionId.uuid,
    fieldErrors: [FieldError(path: path, code: 'duplicate', message: message)],
  );

  /// Ação que não vale no estado atual (ex.: aprovar contato já ativo).
  static ApiException invalidTransition(Session session, String detail) =>
      _make(session, 'INVALID_TRANSITION', ErrorCategory.conflict, detail);

  /// Regra de negócio (docs/08 §2.8), com o campo quando houver.
  static ApiException businessRule(Session session, String detail, {String? path}) => ApiException(
    code: 'BUSINESS_RULE_VIOLATION',
    category: ErrorCategory.businessRule,
    detail: detail,
    traceId: session.sessionId.uuid,
    fieldErrors: path == null ? null : [FieldError(path: path, code: 'business_rule', message: detail)],
  );

  /// Campo mestre de registro vindo do ERP (docs/07; trigger `trg_guard_erp_master`).
  static ApiException masterFieldReadOnly(Session session, List<String> paths) => ApiException(
    code: 'MASTER_FIELD_READ_ONLY',
    category: ErrorCategory.conflict,
    detail: 'Este cadastro vem do ERP: estes campos só mudam por lá.',
    traceId: session.sessionId.uuid,
    fieldErrors: [
      for (final p in paths) FieldError(path: p, code: 'read_only', message: 'Campo mantido pelo ERP.'),
    ],
  );
}
