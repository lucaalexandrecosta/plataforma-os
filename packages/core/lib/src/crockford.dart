/// Base32 Crockford e dígito verificador Luhn mod 32.
///
/// Mesmo algoritmo das funções do banco `app.normalize_crockford_base32`,
/// `app.crockford_luhn32_check_char` e `app.crockford_luhn32_is_valid`
/// (db/schema.sql §4-5; docs/05). Os testes conferem vetores gerados pelo
/// PostgreSQL, para que app, servidor e banco nunca divirjam.
abstract final class Crockford {
  static const alphabet = '0123456789ABCDEFGHJKMNPQRSTVWXYZ';

  static final _valid = RegExp(r'^[0-9A-HJKMNP-TV-Z]+$');

  /// Maiúsculas, `I`/`L` → `1`, `O` → `0`, sem hífens nem espaços.
  /// Equivale a `translate(upper(v), 'ILO- ', '110')` do banco.
  static String normalize(String value) {
    final buffer = StringBuffer();
    for (final rune in value.toUpperCase().runes) {
      final ch = String.fromCharCode(rune);
      switch (ch) {
        case 'I' || 'L':
          buffer.write('1');
        case 'O':
          buffer.write('0');
        case '-' || ' ':
          break;
        default:
          buffer.write(ch);
      }
    }
    return buffer.toString();
  }

  static bool isAlphabet(String value) => _valid.hasMatch(value);

  /// Caractere verificador Luhn mod 32 para [payload] (já normalizado).
  static String luhnCheckChar(String payload) {
    if (!isAlphabet(payload)) {
      throw ArgumentError.value(payload, 'payload', 'fora do alfabeto Crockford');
    }
    var factor = 2;
    var sum = 0;
    for (var i = payload.length - 1; i >= 0; i--) {
      final addend = factor * alphabet.indexOf(payload[i]);
      factor = factor == 2 ? 1 : 2;
      sum += addend ~/ 32 + addend % 32;
    }
    return alphabet[(32 - sum % 32) % 32];
  }

  /// `true` se [code] (já normalizado, com o verificador no fim) é válido.
  static bool luhnIsValid(String code) {
    if (code.length < 2 || !isAlphabet(code)) return false;
    var factor = 1;
    var sum = 0;
    for (var i = code.length - 1; i >= 0; i--) {
      final addend = factor * alphabet.indexOf(code[i]);
      factor = factor == 2 ? 1 : 2;
      sum += addend ~/ 32 + addend % 32;
    }
    return sum % 32 == 0;
  }
}
