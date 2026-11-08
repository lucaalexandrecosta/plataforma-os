import 'package:serverpod/serverpod.dart';

import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';
import 'src/platform/auth/access_token_service.dart';
import 'src/platform/auth/authentication_handler.dart';
import 'src/platform/auth/idp_token_verifier.dart';
import 'src/platform/db/tenant_scoped_database.dart';
import 'src/platform/paging/paging.dart';

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
    authenticationHandler: tokenAuthenticationHandler,
    databaseInterceptor: tenantScopedDatabaseInterceptor,
  );

  configureAuth(pod);

  await pod.start();
}

/// Configura tokens e cursores de paginação a partir de `config/passwords.yaml`
/// (dev) ou das variáveis do cofre (homologação e produção). Nunca do
/// repositório (docs/13 §5, segredos).
void configureAuth(Serverpod pod) {
  String required(String key) =>
      pod.getPassword(key) ?? (throw StateError('Segredo "$key" ausente (config/passwords.yaml ou cofre).'));

  Paging.configure(required('cursorSigningKey'));

  final kid = required('tokenSigningKeyId');
  AuthServices.configure(
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
    idpTokens: IdpTokenVerifier(
      issuer: required('keycloakStaffIssuer'),
      allowedClients: {'backoffice-web', 'technician-app'},
    ),
  );
}
