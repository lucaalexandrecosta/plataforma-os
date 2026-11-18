import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_backoffice/src/config.dart';

void main() {
  test('endereço da API: absoluto fica como está, relativo segue a página', () {
    final page = Uri.parse('https://os.exemplo.com.br/os/123');
    expect(resolveApiUrl('http://localhost:8080/', page), 'http://localhost:8080/');
    expect(resolveApiUrl('/api/', page), 'https://os.exemplo.com.br/api/');
    expect(resolveApiUrl('/api', page), 'https://os.exemplo.com.br/api/');
  });
}
