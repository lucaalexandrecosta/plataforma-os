import 'dart:math';

import 'crockford.dart';

/// Token opaco da URL `/q/<token>` e short code impresso na etiqueta (ADR-006,
/// docs/05, docs/02 §4.2.6).
///
/// * token: 16 bytes de CSPRNG em base32 Crockford, 26 caracteres; o primeiro
///   fica entre `0` e `7` (128 bits não preenchem 130). CHECK do banco:
///   `^[0-7][0-9A-HJKMNP-TV-Z]{25}$`.
/// * short code: 7 caracteres aleatórios + 1 verificador Luhn mod 32,
///   exibido como `XXXX-XXXX`.
abstract final class QrCodes {
  static const tokenLength = 26;
  static const shortCodeLength = 8;

  static final _token = RegExp(r'^[0-7][0-9A-HJKMNP-TV-Z]{25}$');

  /// Gera um token novo. [random] só deve ser trocado em testes.
  static String generateToken([Random? random]) {
    final rnd = random ?? Random.secure();
    var value = BigInt.zero;
    for (var i = 0; i < 16; i++) {
      value = (value << 8) | BigInt.from(rnd.nextInt(256));
    }
    final chars = List<String>.filled(tokenLength, '0');
    final mask = BigInt.from(31);
    for (var i = tokenLength - 1; i >= 0; i--) {
      chars[i] = Crockford.alphabet[(value & mask).toInt()];
      value >>= 5;
    }
    return chars.join();
  }

  static bool isValidToken(String token) => _token.hasMatch(token);

  /// Gera um short code novo (8 caracteres, sem hífen). A unicidade é
  /// garantida pelo banco (UNIQUE); em colisão, o gerador tenta de novo.
  static String generateShortCode([Random? random]) {
    final rnd = random ?? Random.secure();
    final payload = List.generate(
      shortCodeLength - 1,
      (_) => Crockford.alphabet[rnd.nextInt(32)],
    ).join();
    return payload + Crockford.luhnCheckChar(payload);
  }

  /// Normaliza o que a pessoa digitou (hífen, minúsculas, I/L/O) e confere o
  /// verificador. Devolve `null` se for inválido — sem consultar o servidor.
  static String? parseShortCode(String input) {
    final code = Crockford.normalize(input);
    if (code.length != shortCodeLength) return null;
    return Crockford.luhnIsValid(code) ? code : null;
  }

  /// `ABCD1234` → `ABCD-1234`.
  static String formatShortCode(String code) =>
      code.length == shortCodeLength ? '${code.substring(0, 4)}-${code.substring(4)}' : code;
}
