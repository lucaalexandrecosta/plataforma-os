import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_idp_server/core.dart' as login;

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/identity_access/internal/login/login_config.dart';
import 'src/platform/auth/access_token_service.dart';
import 'src/platform/auth/authentication_handler.dart';
import 'src/platform/db/tenant_scoped_database.dart';
import 'src/platform/email/email.dart';

/// Inicia o servidor. O mesmo executável sobe em dois papéis (docs/02 §3.1):
///
/// * `--role serverless` → `api`: endpoints, streaming e servidor web; não
///   executa future calls nem os laços do worker;
/// * `--role monolith` → `worker` (ou tudo num processo só, em dev): future
///   calls com os horários e laços de processamento das tabelas de jobs.
Future<void> run(List<String> args) async {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    databaseInterceptor: tenantScopedDatabaseInterceptor,
  );

  Email.configure(pod);
  configureAuth(pod);

  await pod.start();
}

/// Configura emissão/validação de tokens a partir de `config/passwords.yaml`
/// (dev) ou das variáveis do cofre (homologação e produção). Nunca do
/// repositório (docs/13 §5, segredos).
void configureAuth(Serverpod pod) {
  String required(String key) =>
      pod.getPassword(key) ?? (throw StateError('Segredo "$key" ausente (config/passwords.yaml ou cofre).'));

  // Login próprio (e-mail e senha + sessão de login em JWT). O módulo instala
  // o próprio handler; ele vira o segundo passo do handler da plataforma.
  pod.initializeAuthServices(
    tokenManagerBuilders: LoginConfig.tokenManagers(),
    identityProviderBuilders: LoginConfig.identityProviders(pod),
  );
  pod.authenticationHandler = platformAuthenticationHandler(login.AuthServices.instance.authenticationHandler);

  final kid = required('tokenSigningKeyId');
  PlatformAuth.configure(
    accessTokens: AccessTokenService(
      issuer: required('tokenIssuer'),
      activeKid: kid,
      keys: [
        SigningKey(
          kid: kid,
          privateKeyPem: required('tokenSigningPrivateKey'),
          publicKeyPem: required('tokenSigningPublicKey'),
        ),
      ],
    ),
  );
}
