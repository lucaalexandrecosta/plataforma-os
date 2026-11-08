/// CPF e CNPJ (Receita Federal), mesmas regras no servidor, nos apps e na
/// importação.
///
/// CNPJ alfanumérico (IN RFB 2.229/2024, emitido desde julho de 2026): as 12
/// primeiras posições aceitam `0-9` e `A-Z`, e os 2 dígitos verificadores
/// continuam numéricos. O cálculo é o mesmo módulo 11 de sempre, com o valor de
/// cada caractere igual ao código ASCII menos 48 (`'0'` = 0 … `'9'` = 9,
/// `'A'` = 17 … `'Z'` = 42). CNPJs só numéricos continuam válidos sem mudança.
abstract final class BrDocuments {
  static final _separators = RegExp(r'[\s./\-]');
  static final _cpfShape = RegExp(r'^\d{11}$');
  static final _cnpjShape = RegExp(r'^[0-9A-Z]{12}\d{2}$');

  /// Tira pontuação e espaços e põe em maiúsculas (`12.ABC.345/01DE-35` → `12ABC34501DE35`).
  static String normalize(String input) => input.replaceAll(_separators, '').toUpperCase();

  static bool isValidCpf(String input) {
    final cpf = normalize(input);
    if (!_cpfShape.hasMatch(cpf) || _allSame(cpf)) return false;
    final digits = [for (final c in cpf.codeUnits) c - 48];
    return _mod11Cpf(digits, 9) == digits[9] && _mod11Cpf(digits, 10) == digits[10];
  }

  static bool isValidCnpj(String input) {
    final cnpj = normalize(input);
    if (!_cnpjShape.hasMatch(cnpj) || _allSame(cnpj)) return false;
    final values = [for (final c in cnpj.codeUnits) c - 48];
    return _mod11Cnpj(values, 12) == values[12] && _mod11Cnpj(values, 13) == values[13];
  }

  /// Máscara para exibição; devolve a entrada normalizada se o tamanho não bater.
  static String format(String input) {
    final v = normalize(input);
    if (v.length == 11) return '${v.substring(0, 3)}.${v.substring(3, 6)}.${v.substring(6, 9)}-${v.substring(9)}';
    if (v.length == 14) {
      return '${v.substring(0, 2)}.${v.substring(2, 5)}.${v.substring(5, 8)}/${v.substring(8, 12)}-${v.substring(12)}';
    }
    return v;
  }

  static bool _allSame(String v) => v.split('').every((c) => c == v[0]);

  // Pesos 10..2 (1º dígito) e 11..2 (2º dígito).
  static int _mod11Cpf(List<int> digits, int length) {
    var sum = 0;
    for (var i = 0; i < length; i++) {
      sum += digits[i] * (length + 1 - i);
    }
    final rest = sum % 11;
    return rest < 2 ? 0 : 11 - rest;
  }

  // Pesos 2..9 da direita para a esquerda, recomeçando em 2.
  static int _mod11Cnpj(List<int> values, int length) {
    var sum = 0;
    var weight = 2;
    for (var i = length - 1; i >= 0; i--) {
      sum += values[i] * weight;
      weight = weight == 9 ? 2 : weight + 1;
    }
    final rest = sum % 11;
    return rest < 2 ? 0 : 11 - rest;
  }
}
