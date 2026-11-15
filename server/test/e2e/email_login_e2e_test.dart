// Login próprio de ponta a ponta (decisão de 15/11/2026, sem Keycloak):
// primeiro acesso por e-mail convidado (código fixo 000000 no modo test) →
// senha → sessão de login → auth.selectTenant → token ES256 do tenant →
// endpoint da equipe.
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart (banco recém-criado
// com o seed e o servidor em --mode test).
// Uso: dart test test/e2e
@Tags(['e2e'])
library;

import 'dart:io';

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_server/src/identity_access/internal/login/login_config.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

final class _Bearer implements ClientAuthKeyProvider {
  _Bearer(this.token);
  final String token;
  @override
  Future<String?> get authHeaderValue async => wrapAsBearerAuthHeaderValue(token);
}

const _password = 'Senha-e2e-123';

void main() {
  final apiUrl = Platform.environment['API_URL'] ?? 'http://localhost:9080/';
  final sessions = <String, String>{};

  Matcher apiError(String code) => throwsA(isA<ApiException>().having((e) => e.code, 'code', code));

  /// Primeiro acesso (cadastro com código) na primeira vez; depois, login.
  Future<String> loginSession(String email) async {
    final cached = sessions[email];
    if (cached != null) return cached;
    final client = Client(apiUrl);
    String token;
    try {
      token = (await client.emailIdp.login(email: email, password: _password)).token;
    } on Exception {
      final requestId = await client.emailIdp.startRegistration(email: email);
      final registrationToken = await client.emailIdp.verifyRegistrationCode(
        accountRequestId: requestId,
        verificationCode: LoginConfig.testVerificationCode,
      );
      token = (await client.emailIdp.finishRegistration(
        registrationToken: registrationToken,
        password: _password,
      )).token;
    }
    return sessions[email] = token;
  }

  Client withToken(String token) => Client(apiUrl)..authKeyProvider = _Bearer(token);

  test('Ana cria a senha no primeiro acesso, entra e recebe o token do próprio tenant', () async {
    final session = await loginSession('ana.admin@frio-sul.test');
    final selected = await withToken(session).auth.selectTenant('frio-sul');
    expect(selected.tokenType, 'Bearer');
    expect(selected.expiresIn, 600);
    expect(selected.tenant.slug, 'frio-sul');
    expect(selected.roles, ['tenant_admin']);

    final me = await withToken(selected.accessToken).me.get();
    expect(me.tenant.slug, 'frio-sul');
    expect(me.roles, ['tenant_admin']);

    // Segundo acesso: login com a senha criada.
    final again = await Client(apiUrl).emailIdp.login(email: 'ana.admin@frio-sul.test', password: _password);
    expect((await withToken(again.token).auth.selectTenant('frio-sul')).tenant.slug, 'frio-sul');
  });

  test('senha errada é recusada', () async {
    await loginSession('ana.admin@frio-sul.test');
    await expectLater(
      Client(apiUrl).emailIdp.login(email: 'ana.admin@frio-sul.test', password: 'errada-123'),
      throwsA(isA<Exception>()),
    );
  });

  test('e-mail sem convite não consegue criar senha (sem revelar que não existe)', () async {
    final client = Client(apiUrl);
    final requestId = await client.emailIdp.startRegistration(email: 'intruso@exemplo.test');
    expect(requestId.uuid, isNotEmpty);
    await expectLater(
      client.emailIdp.verifyRegistrationCode(
        accountRequestId: requestId,
        verificationCode: LoginConfig.testVerificationCode,
      ),
      throwsA(isA<Exception>()),
    );
  });

  test('Ana pedindo o tenant de outra empresa: FORBIDDEN, igual a tenant inexistente', () async {
    final session = await loginSession('ana.admin@frio-sul.test');
    await expectLater(withToken(session).auth.selectTenant('forno-norte'), apiError('FORBIDDEN'));
    await expectLater(withToken(session).auth.selectTenant('nao-existe'), apiError('FORBIDDEN'));
  });

  test('Davi troca de tenant com o mesmo login', () async {
    final session = await loginSession('davi.consultor@dev.test');
    for (final slug in ['frio-sul', 'forno-norte']) {
      final selected = await withToken(session).auth.selectTenant(slug);
      final me = await withToken(selected.accessToken).me.get();
      expect(me.tenant.slug, slug);
      expect(me.roles, ['manager']);
    }
  });

  test('app do técnico: despachante entra, administradora não', () async {
    final bruno = await loginSession('bruno.despacho@frio-sul.test');
    final selected = await withToken(bruno).auth.selectTenant('frio-sul', technicianApp: true);
    expect(selected.roles, contains('dispatcher'));

    final ana = await loginSession('ana.admin@frio-sul.test');
    await expectLater(withToken(ana).auth.selectTenant('frio-sul', technicianApp: true), apiError('FORBIDDEN'));
  });

  test('sessão de login usada direto num endpoint da equipe é recusada', () async {
    // Só o token ES256 do tenant vale nos endpoints da equipe.
    final session = await loginSession('ana.admin@frio-sul.test');
    await expectLater(withToken(session).me.get(), throwsA(isA<ServerpodClientException>()));
  });

  test('a sessão de login se renova pelo refresh token', () async {
    await loginSession('davi.consultor@dev.test');
    final auth = await Client(apiUrl).emailIdp.login(email: 'davi.consultor@dev.test', password: _password);
    final renewed = await Client(apiUrl).refreshJwtTokens.refreshAccessToken(refreshToken: auth.refreshToken);
    expect(renewed.token, isNot(auth.token));
    expect((await withToken(renewed.token).auth.selectTenant('frio-sul')).tenant.slug, 'frio-sul');
  });
}
