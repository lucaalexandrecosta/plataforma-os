import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:test/test.dart';

void main() {
  test('GTIN válidos (EAN-13, EAN-8, UPC-A, GTIN-14)', () {
    expect(Gtin.isValid('7891000315507'), isTrue);
    expect(Gtin.isValid('789-1000-31550-7'), isTrue);
    expect(Gtin.isValid('96385074'), isTrue);
    expect(Gtin.isValid('036000291452'), isTrue);
    expect(Gtin.isValid('17891000315504'), isTrue);
  });

  test('GTIN inválidos', () {
    expect(Gtin.isValid('7891000315508'), isFalse, reason: 'dígito verificador');
    expect(Gtin.isValid('789100031550'), isFalse, reason: '12 dígitos com verificador errado');
    expect(Gtin.isValid('78910003155'), isFalse, reason: 'tamanho');
    expect(Gtin.isValid('789100031550A'), isFalse);
    expect(Gtin.isValid(''), isFalse);
  });
}
