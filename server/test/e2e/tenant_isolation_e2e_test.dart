// Spike S1 de ponta a ponta (docs/12 §7; docs/02 §7.2): servidor Serverpod
// real + databaseInterceptor + RLS FORCE num PostgreSQL com a migração
// inicial e o seed de dois tenants.
//
// Pré-requisitos (ver server/README.md, "Testes de ponta a ponta"):
//   1. banco de teste com db/migrations + infra/local/postgres + migrações do
//      Serverpod + db/seeds/dev_seed.sql;
//   2. servidor rodando: dart bin/main.dart --mode test --role monolith
// Uso: dart test test/e2e   (API_URL=http://localhost:9080/ por padrão)
@Tags(['e2e'])
library;

import 'dart:io';

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_server/src/platform/auth/access_token_service.dart';
import 'package:plataforma_os_server/src/platform/auth/token_claims.dart';
import 'package:plataforma_os_server/src/platform/context/request_context.dart';
import 'package:serverpod_client/serverpod_client.dart';
import 'package:test/test.dart';
import 'package:yaml/yaml.dart';

// Ids fixos do seed (db/seeds/dev_seed.sql).
final tenantA = UuidValue.withValidation('0197f000-0001-7000-8000-000000000001'); // frio-sul
final tenantB = UuidValue.withValidation('0197f000-0002-7000-8000-000000000002'); // forno-norte
final ana = UuidValue.withValidation('0197f000-0100-7000-8000-000000000001'); // tenant_admin A
final anaMembership = UuidValue.withValidation('0197f000-0001-7200-8000-000000000001');
final carla = UuidValue.withValidation('0197f000-0100-7000-8000-000000000003'); // tenant_admin B
final carlaMembership = UuidValue.withValidation('0197f000-0002-7200-8000-000000000003');
final davi = UuidValue.withValidation('0197f000-0100-7000-8000-000000000004'); // manager em A e B
final daviMembershipA = UuidValue.withValidation('0197f000-0001-7200-8000-000000000004');

final class _Bearer implements ClientAuthKeyProvider {
  _Bearer(this.token);
  final String token;
  @override
  Future<String?> get authHeaderValue async => wrapAsBearerAuthHeaderValue(token);
}

void main() {
  final apiUrl = Platform.environment['API_URL'] ?? 'http://localhost:9080/';
  late AccessTokenService tokens;

  setUpAll(() {
    // Mesma chave e emissor que o servidor de teste carrega de passwords.yaml.
    final yaml = loadYaml(File('config/passwords.yaml').readAsStringSync()) as YamlMap;
    final shared = yaml['shared'] as YamlMap;
    final test = yaml['test'] as YamlMap;
    final kid = shared['tokenSigningKeyId'] as String;
    tokens = AccessTokenService(
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
  });

  Client clientFor(UuidValue user, UuidValue tenant, UuidValue membership, {List<String> roles = const []}) {
    final issued = tokens.issue(
      kind: TokenKind.staff,
      userId: user,
      tenantId: tenant,
      actorType: ActorType.user,
      sessionId: 'e2e-${user.uuid}',
      membershipId: membership,
      roles: roles,
    );
    return Client(apiUrl)..authKeyProvider = _Bearer(issued.token);
  }

  test('tenant A: me.get devolve o tenant do token e as permissões do banco', () async {
    final me = await clientFor(ana, tenantA, anaMembership).me.get();
    expect(me.tenant.id, tenantA);
    expect(me.tenant.slug, 'frio-sul');
    expect(me.roles, ['tenant_admin']);
    expect(me.permissions, containsAll(['users.manage', 'settings.manage', 'work_orders.close']));
  });

  test('tenant B: outro usuário, outro tenant, nenhuma linha de A', () async {
    final me = await clientFor(carla, tenantB, carlaMembership).me.get();
    expect(me.tenant.slug, 'forno-norte');
    final tenants = await clientFor(carla, tenantB, carlaMembership).me.tenants();
    expect(tenants.map((t) => t.slug), ['forno-norte']);
  });

  test('usuário em dois tenants enxerga os dois só na lista de troca', () async {
    final tenants = await clientFor(davi, tenantA, daviMembershipA).me.tenants();
    expect(tenants.map((t) => t.slug).toSet(), {'frio-sul', 'forno-norte'});
    final me = await clientFor(davi, tenantA, daviMembershipA).me.get();
    expect(me.tenant.slug, 'frio-sul');
    expect(me.roles, ['manager']);
  });

  test('token VÁLIDO com tenant sem vínculo é recusado: o servidor relê o banco', () async {
    // Assinado com a chave certa, mas Ana não tem vínculo em B. A RLS só
    // mostra vínculos de B (tenant do token) ou da própria Ana → nenhum.
    final forged = clientFor(ana, tenantB, anaMembership, roles: ['tenant_admin']);
    await expectLater(
      forged.me.get(),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'FORBIDDEN')),
    );
  });

  test('sem token: endpoint da equipe recusa', () async {
    await expectLater(Client(apiUrl).me.get(), throwsA(isA<ServerpodClientException>()));
  });

  test('token adulterado: recusado pelo handler', () async {
    final good = tokens.issue(
      kind: TokenKind.staff,
      userId: ana,
      tenantId: tenantA,
      actorType: ActorType.user,
      sessionId: 'e2e',
      membershipId: anaMembership,
    );
    final tampered = '${good.token.substring(0, good.token.length - 4)}AAAA';
    final client = Client(apiUrl)..authKeyProvider = _Bearer(tampered);
    await expectLater(client.me.get(), throwsA(isA<ServerpodClientException>()));
  });

  test('token de contato não acessa endpoint da equipe', () async {
    final customer = tokens.issue(
      kind: TokenKind.customer,
      userId: ana,
      tenantId: tenantA,
      actorType: ActorType.customerContact,
      sessionId: 'e2e-c',
    );
    final client = Client(apiUrl)..authKeyProvider = _Bearer(customer.token);
    await expectLater(client.me.get(), throwsA(isA<ServerpodClientException>()));
  });

  test('auth.exchangeIdpToken recusa token de IdP inválido sem revelar nada', () async {
    await expectLater(
      Client(apiUrl).auth.exchangeIdpToken('nao-e-um-jwt', 'frio-sul'),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'UNAUTHENTICATED')),
    );
  });
}
