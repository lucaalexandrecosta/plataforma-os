// Login completo pela equipe (docs/04 §4.2 e §4.3): token RS256 do Keycloak
// (realm "staff" de dev) → auth.exchangeIdpToken → token ES256 do tenant →
// endpoint da equipe. Fecha a pendência do spike S1 "caminho feliz com o IdP".
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart e o Keycloak de
// infra/local rodando com o realm importado (porta 8180).
// Uso: dart test test/e2e   (KEYCLOAK_URL=http://localhost:8180 por padrão)
@Tags(['e2e', 'keycloak'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

final class _Bearer implements ClientAuthKeyProvider {
  _Bearer(this.token);
  final String token;
  @override
  Future<String?> get authHeaderValue async => wrapAsBearerAuthHeaderValue(token);
}

void main() {
  final apiUrl = Platform.environment['API_URL'] ?? 'http://localhost:9080/';
  final keycloakUrl = Platform.environment['KEYCLOAK_URL'] ?? 'http://localhost:8180';

  /// Grant de senha: só existe no realm de dev (infra/local/keycloak).
  Future<String> idpToken(String username, {String clientId = 'backoffice-web'}) async {
    final response = await http.post(
      Uri.parse('$keycloakUrl/realms/staff/protocol/openid-connect/token'),
      body: {'grant_type': 'password', 'client_id': clientId, 'username': username, 'password': 'dev'},
    );
    expect(response.statusCode, 200, reason: 'Keycloak recusou $username em $clientId: ${response.body}');
    return (jsonDecode(response.body) as Map<String, Object?>)['access_token']! as String;
  }

  Matcher apiError(String code) => throwsA(isA<ApiException>().having((e) => e.code, 'code', code));

  test('Ana entra pelo Keycloak e recebe o token do próprio tenant', () async {
    final exchanged = await Client(apiUrl).auth.exchangeIdpToken(await idpToken('ana.admin@frio-sul.test'), 'frio-sul');
    expect(exchanged.tokenType, 'Bearer');
    expect(exchanged.expiresIn, 600);
    expect(exchanged.tenant.slug, 'frio-sul');
    expect(exchanged.roles, ['tenant_admin']);

    // O token emitido funciona num endpoint da equipe e carrega o tenant certo.
    final me = await (Client(apiUrl)..authKeyProvider = _Bearer(exchanged.accessToken)).me.get();
    expect(me.tenant.slug, 'frio-sul');
    expect(me.roles, ['tenant_admin']);
  });

  test('Ana pedindo o tenant de outra empresa: FORBIDDEN, igual a tenant inexistente', () async {
    final token = await idpToken('ana.admin@frio-sul.test');
    await expectLater(Client(apiUrl).auth.exchangeIdpToken(token, 'forno-norte'), apiError('FORBIDDEN'));
    await expectLater(Client(apiUrl).auth.exchangeIdpToken(token, 'nao-existe'), apiError('FORBIDDEN'));
  });

  test('Davi troca de tenant com o mesmo login do IdP', () async {
    final token = await idpToken('davi.consultor@dev.test');
    for (final slug in ['frio-sul', 'forno-norte']) {
      final exchanged = await Client(apiUrl).auth.exchangeIdpToken(token, slug);
      final me = await (Client(apiUrl)..authKeyProvider = _Bearer(exchanged.accessToken)).me.get();
      expect(me.tenant.slug, slug);
      expect(me.roles, ['manager']);
    }
  });

  test('app do técnico: despachante entra, administradora não', () async {
    final bruno = await idpToken('bruno.despacho@frio-sul.test', clientId: 'technician-app');
    final exchanged = await Client(apiUrl).auth.exchangeIdpToken(bruno, 'frio-sul');
    expect(exchanged.roles, contains('dispatcher'));

    final ana = await idpToken('ana.admin@frio-sul.test', clientId: 'technician-app');
    await expectLater(Client(apiUrl).auth.exchangeIdpToken(ana, 'frio-sul'), apiError('FORBIDDEN'));
  });

  test('token do Keycloak usado direto num endpoint da equipe é recusado', () async {
    // Só o token ES256 emitido pela plataforma vale nos endpoints; o do IdP não.
    final client = Client(apiUrl)..authKeyProvider = _Bearer(await idpToken('ana.admin@frio-sul.test'));
    await expectLater(client.me.get(), throwsA(isA<ServerpodClientException>()));
  });
}
