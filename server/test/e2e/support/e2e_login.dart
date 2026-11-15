// Apoio dos testes e2e: login próprio (primeiro acesso ou login) e cliente com
// o token do tenant. Os arquivos e2e rodam em sequência (dart_test.yaml), então
// o primeiro que usar um e-mail do seed cria a senha e os demais só entram.
import 'dart:io';

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_server/src/identity_access/internal/login/login_config.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';

const e2ePassword = 'Senha-e2e-123';

final apiUrl = Platform.environment['API_URL'] ?? 'http://localhost:9080/';

final class Bearer implements ClientAuthKeyProvider {
  Bearer(this.token);
  final String token;
  @override
  Future<String?> get authHeaderValue async => wrapAsBearerAuthHeaderValue(token);
}

Client clientWithToken(String token) => Client(apiUrl)..authKeyProvider = Bearer(token);

Matcher throwsApiError(String code) => throwsA(isA<ApiException>().having((e) => e.code, 'code', code));

/// Sessão de login: entra com a senha; se a pessoa ainda não tem senha, faz o
/// primeiro acesso (código fixo do modo test).
Future<String> loginSession(String email) async {
  final client = Client(apiUrl);
  try {
    return (await client.emailIdp.login(email: email, password: e2ePassword)).token;
  } on Exception {
    final requestId = await client.emailIdp.startRegistration(email: email);
    final registrationToken = await client.emailIdp.verifyRegistrationCode(
      accountRequestId: requestId,
      verificationCode: LoginConfig.testVerificationCode,
    );
    return (await client.emailIdp.finishRegistration(
      registrationToken: registrationToken,
      password: e2ePassword,
    )).token;
  }
}

/// Cliente com o token do tenant de [email] em [tenantSlug].
Future<Client> tenantClient(String email, String tenantSlug, {bool technicianApp = false}) async {
  final session = await loginSession(email);
  final selected = await clientWithToken(session).auth.selectTenant(tenantSlug, technicianApp: technicianApp);
  return clientWithToken(selected.accessToken);
}
