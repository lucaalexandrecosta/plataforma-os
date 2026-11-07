/// Validação de UUID v7 (RFC 9562), formato de todos os ids (D6).
///
/// O cliente pode mandar o `id` na criação (app do técnico offline); a API
/// rejeita UUID que não seja v7 ou com timestamp mais de 7 dias no futuro
/// (`INVALID_UUID`, docs/08 §2.5).
abstract final class UuidV7 {
  static final _pattern = RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');

  static const maxFutureSkew = Duration(days: 7);

  static bool isV7(String value) => _pattern.hasMatch(value.toLowerCase());

  /// Instante (UTC) embutido nos 48 primeiros bits.
  static DateTime timestampOf(String value) {
    if (!isV7(value)) throw FormatException('Não é UUID v7', value);
    final hex = value.replaceAll('-', '').substring(0, 12);
    return DateTime.fromMillisecondsSinceEpoch(int.parse(hex, radix: 16), isUtc: true);
  }

  /// Regra de aceite de id vindo do cliente.
  static bool isAcceptable(String value, {required DateTime now}) =>
      isV7(value) && !timestampOf(value).isAfter(now.toUtc().add(maxFutureSkew));
}
