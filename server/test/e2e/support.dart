// Apoio dos testes de ponta a ponta: ids do seed, emissão de tokens com a
// mesma chave do servidor de teste e conexão direta ao banco de teste (como
// superusuário, para conferir outbox e auditoria por fora da RLS).
import 'dart:io';

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_server/src/platform/auth/access_token_service.dart';
import 'package:plataforma_os_server/src/platform/auth/token_claims.dart';
import 'package:plataforma_os_server/src/platform/context/request_context.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:yaml/yaml.dart';

final apiUrl = Platform.environment['API_URL'] ?? 'http://localhost:9080/';

// Ids fixos do seed (db/seeds/dev_seed.sql).
final tenantA = UuidValue.withValidation('0197f000-0001-7000-8000-000000000001'); // frio-sul
final tenantB = UuidValue.withValidation('0197f000-0002-7000-8000-000000000002'); // forno-norte

final class SeedActor {
  const SeedActor(this.user, this.tenant, this.membership, this.roles);
  final UuidValue user;
  final UuidValue tenant;
  final UuidValue membership;
  final List<String> roles;
}

UuidValue _u(String v) => UuidValue.withValidation(v);

final ana = SeedActor(
  _u('0197f000-0100-7000-8000-000000000001'),
  tenantA,
  _u('0197f000-0001-7200-8000-000000000001'),
  const ['tenant_admin'],
);
final bruno = SeedActor(
  _u('0197f000-0100-7000-8000-000000000002'),
  tenantA,
  _u('0197f000-0001-7200-8000-000000000002'),
  const ['dispatcher'],
);
final carla = SeedActor(
  _u('0197f000-0100-7000-8000-000000000003'),
  tenantB,
  _u('0197f000-0002-7200-8000-000000000003'),
  const ['tenant_admin'],
);
final daviA = SeedActor(
  _u('0197f000-0100-7000-8000-000000000004'),
  tenantA,
  _u('0197f000-0001-7200-8000-000000000004'),
  const ['manager'],
);

final class _Bearer implements ClientAuthKeyProvider {
  _Bearer(this.token);
  final String token;
  @override
  Future<String?> get authHeaderValue async => wrapAsBearerAuthHeaderValue(token);
}

/// Mesma chave e emissor que o servidor de teste carrega de passwords.yaml.
AccessTokenService loadTestTokens() {
  final yaml = loadYaml(File('config/passwords.yaml').readAsStringSync()) as YamlMap;
  final shared = yaml['shared'] as YamlMap;
  final test = yaml['test'] as YamlMap;
  final kid = shared['tokenSigningKeyId'] as String;
  return AccessTokenService(
    issuer: test['tokenIssuer'] as String,
    activeKid: kid,
    keys: [
      SigningKey(
        kid: kid,
        privateKeyPem: shared['tokenSigningPrivateKey'] as String,
        publicKeyPem: shared['tokenSigningPublicKey'] as String,
      ),
    ],
  );
}

Client clientWithToken(String token) => Client(apiUrl)..authKeyProvider = _Bearer(token);

Client clientAs(AccessTokenService tokens, SeedActor a) => clientWithToken(
  tokens
      .issue(
        kind: TokenKind.staff,
        userId: a.user,
        tenantId: a.tenant,
        actorType: ActorType.user,
        sessionId: 'e2e-${a.user.uuid}',
        membershipId: a.membership,
        roles: a.roles,
      )
      .token,
);

/// Banco de teste como superusuário (TEST_DB_URL ou o padrão do compose/CI).
Future<pg.Connection> openTestDb() {
  final url = Uri.parse(
    Platform.environment['TEST_DB_URL'] ?? 'postgres://postgres:postgres@localhost:5433/plataforma_os_test',
  );
  final userInfo = url.userInfo.split(':');
  return pg.Connection.open(
    pg.Endpoint(
      host: url.host,
      port: url.port,
      database: url.pathSegments.first,
      username: userInfo.first,
      password: userInfo.length > 1 ? userInfo[1] : null,
    ),
    settings: const pg.ConnectionSettings(sslMode: pg.SslMode.disable),
  );
}
