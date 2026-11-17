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
}
