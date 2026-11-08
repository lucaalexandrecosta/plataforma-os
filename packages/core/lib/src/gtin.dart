/// Código de barras GTIN (EAN-8, UPC-A/GTIN-12, EAN-13, GTIN-14) com dígito
/// verificador GS1 (módulo 10, pesos 3 e 1 a partir da direita).
abstract final class Gtin {
  static const lengths = {8, 12, 13, 14};

  /// Só os dígitos (tira espaços e hífens).
  static String normalize(String input) => input.replaceAll(RegExp(r'[\s\-.]'), '');

  static bool isValid(String input) {
    final digits = normalize(input);
    if (!lengths.contains(digits.length) || !RegExp(r'^\d+$').hasMatch(digits)) return false;
    var sum = 0;
    for (var i = digits.length - 2, weight = 3; i >= 0; i--, weight = 4 - weight) {
      sum += (digits.codeUnitAt(i) - 48) * weight;
    }
    return (10 - sum % 10) % 10 == digits.codeUnitAt(digits.length - 1) - 48;
  }
}
