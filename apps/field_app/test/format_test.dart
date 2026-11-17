import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_field/src/ui/common/format.dart';

void main() {
  final today = DateTime(2026, 11, 17, 8);

  test('formatDay relativo a hoje', () {
    expect(formatDay(DateTime(2026, 11, 17, 23), today), 'Hoje');
    expect(formatDay(DateTime(2026, 11, 18), today), 'Amanhã');
    expect(formatDay(DateTime(2026, 11, 16), today), 'Ontem');
    expect(formatDay(DateTime(2026, 11, 19), today), 'qui, 19/11');
  });

  test('formatWindow mostra a data do fim quando cruza o dia', () {
    expect(formatWindow(DateTime(2026, 11, 17, 8), DateTime(2026, 11, 17, 10, 30)), '08:00–10:30');
    expect(formatWindow(DateTime(2026, 11, 17, 22), DateTime(2026, 11, 18, 2)), '22:00–18/11/2026 02:00');
  });

  test('formatDistance', () {
    expect(formatDistance(85.4), '85 m');
    expect(formatDistance(1234), '1,2 km');
  });
}
