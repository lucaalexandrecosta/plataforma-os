import 'dart:math';

import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:test/test.dart';

void main() {
  group('Crockford.luhnCheckChar', () {
    // Vetores gerados por app.crockford_luhn32_check_char no PostgreSQL 18.
    const fromPostgres = {
      'FSAAAA1': 'B',
      'FNBBBB1': '9',
      '0000000': '0',
      'ZZZZZZZ': '7',
      '7K3M9QX': '1',
      'ABCDEFG': 'G',
      '1234567': 'M',
    };
    fromPostgres.forEach((payload, check) {
      test('$payload → $check (igual ao banco)', () {
        expect(Crockford.luhnCheckChar(payload), check);
        expect(Crockford.luhnIsValid('$payload$check'), isTrue);
      });
    });

    test('detecta troca de um caractere e transposição adjacente', () {
      final rnd = Random(42);
      for (var i = 0; i < 500; i++) {
        final code = QrCodes.generateShortCode(rnd);
        final pos = rnd.nextInt(7);
        final other = Crockford.alphabet[(Crockford.alphabet.indexOf(code[pos]) + 1 + rnd.nextInt(31)) % 32];
        final typo = code.replaceRange(pos, pos + 1, other);
        expect(Crockford.luhnIsValid(typo), isFalse, reason: '$code → $typo');
        // Limite conhecido do Luhn mod N: a transposição de 0 e N-1 ("0Z" ↔
        // "Z0") não é detectada, como "09" ↔ "90" no Luhn decimal.
        final pair = {code[pos], code[pos + 1]};
        final undetectable = pair.length == 2 && pair.containsAll({'0', 'Z'});
        if (code[pos] != code[pos + 1] && !undetectable) {
          final swapped = code.replaceRange(pos, pos + 2, '${code[pos + 1]}${code[pos]}');
          expect(Crockford.luhnIsValid(swapped), isFalse, reason: '$code → $swapped');
        }
      }
    });

    test('recusa payload fora do alfabeto', () {
      expect(() => Crockford.luhnCheckChar('ABCU'), throwsArgumentError);
    });
  });

  group('Crockford.normalize', () {
    test('igual a translate(upper(v), \'ILO- \', \'110\')', () {
      expect(Crockford.normalize('fsaa-aa1b'), 'FSAAAA1B');
      expect(Crockford.normalize('iLo 0'), '1100');
    });
  });

  group('QrCodes', () {
    test('token tem 26 caracteres e passa no CHECK do banco', () {
      for (var i = 0; i < 200; i++) {
        final token = QrCodes.generateToken();
        expect(token, hasLength(26));
        expect(QrCodes.isValidToken(token), isTrue, reason: token);
      }
    });

    test('tokens não se repetem', () {
      final tokens = {for (var i = 0; i < 2000; i++) QrCodes.generateToken()};
      expect(tokens, hasLength(2000));
    });

    test('short code aceita o que a pessoa digita', () {
      expect(QrCodes.parseShortCode('fsaa-aa1b'), 'FSAAAA1B');
      expect(QrCodes.parseShortCode('FSAA AA1B'), 'FSAAAA1B');
      expect(QrCodes.parseShortCode('FSAA-AA1C'), isNull, reason: 'verificador errado');
      expect(QrCodes.parseShortCode('FSAA-AA1'), isNull, reason: 'curto');
      expect(QrCodes.formatShortCode('FSAAAA1B'), 'FSAA-AA1B');
    });
  });
}
