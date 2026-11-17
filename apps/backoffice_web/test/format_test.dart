import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_backoffice/src/ui/common/format.dart';

void main() {
  test('dinheiro em centavos no padrão brasileiro', () {
    expect(formatMoney(0), r'R$ 0,00');
    expect(formatMoney(5), r'R$ 0,05');
    expect(formatMoney(123456), r'R$ 1.234,56');
    expect(formatMoney(100000000), r'R$ 1.000.000,00');
    expect(formatMoney(-150), r'-R$ 1,50');
    expect(formatMoney(null), '—');
  });

  test('datas em dd/mm/aaaa', () {
    expect(formatDate(DateTime(2026, 1, 5)), '05/01/2026');
    expect(formatDateTime(DateTime(2026, 1, 5, 9, 7)), '05/01/2026 09:07');
    expect(formatDate(null), '—');
  });

  test('valor digitado em reais vira centavos', () {
    expect(parseMoney('1.234,56'), 123456);
    expect(parseMoney('R\$ 10,5'), 1050);
    expect(parseMoney('1234.5'), 123450);
    expect(parseMoney('200'), 20000);
    expect(parseMoney(''), isNull);
    expect(parseMoney('abc'), isNull);
    expect(parseMoney('1,234'), isNull);
    expect(moneyField(123456), '1.234,56');
  });
}
