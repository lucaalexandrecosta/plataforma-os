import 'package:serverpod/serverpod.dart';

/// Conversões das colunas lidas por SQL próprio (`unsafeQuery`). O driver
/// devolve `uuid` como [UuidValue] ou texto, conforme o caminho.
UuidValue sqlUuid(Object? value) => value is UuidValue ? value : UuidValue.withValidation(value.toString());

UuidValue? sqlUuidOrNull(Object? value) => value == null ? null : sqlUuid(value);

/// `date` do PostgreSQL chega como [DateTime] UTC à meia-noite.
DateTime? sqlDateOrNull(Object? value) => value as DateTime?;

/// Data sem hora para gravar em coluna `date` (texto ISO + cast no SQL).
String? sqlDateParam(DateTime? value) => value == null
    ? null
    : '${value.year.toString().padLeft(4, '0')}-${value.month.toString().padLeft(2, '0')}-${value.day.toString().padLeft(2, '0')}';

/// Violação de unicidade (23505), opcionalmente de uma constraint/índice.
bool isUniqueViolation(Object error, [String? constraint]) =>
    error is DatabaseQueryException &&
    error.code == '23505' &&
    (constraint == null || error.constraintName == constraint);

/// Campo mestre do ERP alterado fora da integração (trg_guard_erp_master).
bool isErpMasterGuard(Object error) =>
    error is DatabaseQueryException && error.code == '42501' && (error.message.contains('mestre do ERP'));

/// Texto opcional: espaços nas pontas fora, vazio vira nulo.
String? cleanText(String? value) {
  final t = value?.trim();
  return (t == null || t.isEmpty) ? null : t;
}
