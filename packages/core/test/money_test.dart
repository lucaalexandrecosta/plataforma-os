import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:test/test.dart';

void main() {
  group('Money.lineAmountCents (igual a app.line_amount_cents)', () {
    // Vetores do PostgreSQL: round((q::numeric * p) / 1000)::bigint.
    test('1,5 un × R\$ 12,34 = R\$ 18,51', () => expect(Money.lineAmountCents(1500, 1234), 1851));
    test('negativo arredonda para longe do zero', () => expect(Money.lineAmountCents(-1500, 1233), -1850));
    test('0,333 × R\$ 0,05 = R\$ 0,02', () => expect(Money.lineAmountCents(333, 5), 2));
    test('meio centavo sobe', () => expect(Money.lineAmountCents(500, 1), 1));
    test('sem estouro com valores grandes (precisão do Flutter Web)', () {
      // 1 milhão de unidades × R$ 9.999.999,99
      expect(Money.lineAmountCents(1000000 * 1000, 999999999), 999999999000000);
    });
  });

  group('Money.formatBrl', () {
    test('formata pt-BR', () {
      expect(Money.formatBrl(123456), r'R$ 1.234,56');
      expect(Money.formatBrl(5), r'R$ 0,05');
      expect(Money.formatBrl(-100000000), r'-R$ 1.000.000,00');
    });
  });

  group('Money.parseToCents', () {
    test('aceita formatos de planilha', () {
      expect(Money.parseToCents('12,34'), 1234);
      expect(Money.parseToCents('1.234,56'), 123456);
      expect(Money.parseToCents(r'R$ 1.234,5'), 123450);
      expect(Money.parseToCents('1234.56'), 123456);
      expect(Money.parseToCents('-0,5'), -50);
      expect(Money.parseToCents('10'), 1000);
    });
    test('recusa ambiguidade e excesso de casas', () {
      expect(() => Money.parseToCents('1.234'), throwsFormatException);
      expect(() => Money.parseToCents('12,345'), throwsFormatException);
      expect(() => Money.parseToCents('abc'), throwsFormatException);
      expect(() => Money.parseToCents('1.23,4'), throwsFormatException);
    });
    test('ida e volta com o decimal do JSON externo', () {
      expect(Money.toDecimalString(123456), '1234.56');
      expect(Money.toDecimalString(-5), '-0.05');
      expect(Money.parseToCents(Money.toDecimalString(98765)), 98765);
    });
  });

  group('Quantity', () {
    test('milésimos', () {
      expect(Quantity.parseToMilli('1,5'), 1500);
      expect(Quantity.parseToMilli('1.234'), 1234);
      expect(Quantity.parseToMilli('2'), 2000);
      expect(Quantity.format(1500), '1,5');
      expect(Quantity.format(1000), '1');
      expect(Quantity.format(1250), '1,25');
      expect(Quantity.format(1234567), '1.234,567');
      expect(() => Quantity.parseToMilli('1,2345'), throwsFormatException);
    });
  });
}
