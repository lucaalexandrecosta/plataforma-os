import 'package:backoffice_web/src/config/tenant_host.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('subdomínio da empresa vira o slug', () {
    expect(tenantSlugFromHost('frio-sul.localhost'), 'frio-sul');
    expect(tenantSlugFromHost('forno-norte.platform-lac.com.br'), 'forno-norte');
    expect(tenantSlugFromHost('Frio-Sul.Platform-Lac.com.br'), 'frio-sul');
  });

  test('entrada genérica e hosts reservados não têm empresa', () {
    for (final host in [
      'localhost',
      '127.0.0.1',
      'app.platform-lac.com.br',
      'qr.platform-lac.com.br',
      'console.platform-lac.com.br',
      'api.platform-lac.com.br',
    ]) {
      expect(tenantSlugFromHost(host), isNull, reason: host);
    }
  });

  test('slug fora do formato é ignorado', () {
    expect(tenantSlugFromHost('-x.localhost'), isNull);
    expect(tenantSlugFromHost('a.localhost'), isNull, reason: 'mínimo de 3 caracteres');
  });
}
