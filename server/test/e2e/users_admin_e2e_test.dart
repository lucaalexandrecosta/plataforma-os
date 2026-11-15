// Controle de usuários de ponta a ponta: convite, primeiro acesso do
// convidado, perfis, suspensão, reativação, remoção e as travas (último
// administrador, o próprio acesso, outro tenant, sem permissão).
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart.
@Tags(['e2e'])
library;

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:test/test.dart';

import 'support/e2e_login.dart';

void main() {
  const nova = 'nova.tecnica@frio-sul.test';
  late Client ana;
  late Client carla;

  setUpAll(() async {
    ana = await tenantClient('ana.admin@frio-sul.test', 'frio-sul');
    carla = await tenantClient('carla.admin@forno-norte.test', 'forno-norte');
  });

  Future<TenantUser> member(Client admin, String email) async =>
      (await admin.users.list()).singleWhere((u) => u.email == email);

  test('administradora lista a equipe e os perfis atribuíveis', () async {
    final emails = [for (final u in await ana.users.list()) u.email];
    expect(emails, containsAll(['ana.admin@frio-sul.test', 'bruno.despacho@frio-sul.test', 'davi.consultor@dev.test']));
    expect(emails, isNot(contains('carla.admin@forno-norte.test')));
    expect(
      [for (final r in await ana.users.roles()) r.code],
      [
        'tenant_admin',
        'dispatcher',
        'backoffice_agent',
        'manager',
        'technician',
      ],
    );
  });

  test('sem users.manage não lista nem convida', () async {
    final bruno = await tenantClient('bruno.despacho@frio-sul.test', 'frio-sul');
    await expectLater(bruno.users.list(), throwsApiError('FORBIDDEN'));
    await expectLater(bruno.users.invite('x@frio-sul.test', 'X', ['manager']), throwsApiError('FORBIDDEN'));
  });

  test('convite: validação, primeiro acesso do convidado e acesso ativo', () async {
    await expectLater(ana.users.invite('nao-e-email', 'Nome', ['technician']), throwsApiError('VALIDATION_FAILED'));
    await expectLater(ana.users.invite(nova, 'Nova', []), throwsApiError('VALIDATION_FAILED'));
    await expectLater(ana.users.invite(nova, 'Nova', ['platform_admin']), throwsApiError('VALIDATION_FAILED'));

    final invited = await ana.users.invite('  Nova.Tecnica@frio-sul.test ', 'Nova Técnica', ['technician']);
    expect(invited.email, nova);
    expect(invited.status, MembershipStatus.invited);
    expect(invited.roles, ['technician']);
    expect(invited.hasLogin, isFalse);
    await expectLater(ana.users.invite(nova, 'Outra', ['manager']), throwsApiError('ALREADY_MEMBER'));

    // A convidada cria a senha e entra pelo app do técnico.
    final novaClient = await tenantClient(nova, 'frio-sul', technicianApp: true);
    expect((await novaClient.me.get()).roles, ['technician']);
    final active = await member(ana, nova);
    expect(active.status, MembershipStatus.active);
    expect(active.hasLogin, isTrue);
  });

  test('a mesma pessoa é convidada por outra empresa sem duplicar o cadastro', () async {
    final inFrioSul = await member(ana, nova);
    final inFornoNorte = await carla.users.invite(nova, 'Nome dado pela Forno Norte', ['manager']);
    expect(inFornoNorte.userId, inFrioSul.userId);
    expect(inFornoNorte.fullName, 'Nova Técnica', reason: 'o nome é da pessoa, não do convite');
    expect(inFornoNorte.hasLogin, isTrue);

    // Remover numa empresa não mexe na outra; depois pode convidar de novo.
    final removed = await carla.users.remove(inFornoNorte.membershipId);
    expect(removed.status, MembershipStatus.removed);
    expect([for (final u in await carla.users.list()) u.email], isNot(contains(nova)));
    expect((await member(ana, nova)).status, MembershipStatus.active);
    final again = await carla.users.invite(nova, 'Nova', ['manager']);
    expect(again.membershipId, inFornoNorte.membershipId);
    expect(again.status, MembershipStatus.invited);
  });

  test('perfis: troca a lista inteira', () async {
    final target = await member(ana, nova);
    final updated = await ana.users.setRoles(target.membershipId, ['technician', 'dispatcher']);
    expect(updated.roles, ['dispatcher', 'technician']);
    expect((await ana.users.setRoles(target.membershipId, ['technician'])).roles, ['technician']);
  });

  test('suspensão bloqueia a entrada na empresa; reativação devolve', () async {
    final bruno = await member(ana, 'bruno.despacho@frio-sul.test');
    expect((await ana.users.suspend(bruno.membershipId)).status, MembershipStatus.suspended);
    final brunoLogin = await loginSession('bruno.despacho@frio-sul.test');
    await expectLater(clientWithToken(brunoLogin).auth.selectTenant('frio-sul'), throwsApiError('FORBIDDEN'));
    await expectLater(ana.users.suspend(bruno.membershipId), throwsApiError('INVALID_STATUS'));

    expect((await ana.users.reactivate(bruno.membershipId)).status, MembershipStatus.active);
    final selected = await clientWithToken(brunoLogin).auth.selectTenant('frio-sul');
    expect(selected.roles, ['dispatcher']);
  });

  test('travas: o próprio acesso e o último administrador', () async {
    final self = await member(ana, 'ana.admin@frio-sul.test');
    await expectLater(ana.users.suspend(self.membershipId), throwsApiError('CANNOT_CHANGE_OWN_ACCESS'));
    await expectLater(ana.users.remove(self.membershipId), throwsApiError('CANNOT_CHANGE_OWN_ACCESS'));
    await expectLater(ana.users.setRoles(self.membershipId, ['manager']), throwsApiError('LAST_TENANT_ADMIN'));

    // Com outra administradora ativa, a troca passa (e volta).
    final novaMember = await member(ana, nova);
    await ana.users.setRoles(novaMember.membershipId, ['tenant_admin']);
    expect((await ana.users.setRoles(self.membershipId, ['tenant_admin', 'manager'])).roles, [
      'manager',
      'tenant_admin',
    ]);
    await ana.users.setRoles(self.membershipId, ['tenant_admin']);
    await ana.users.setRoles(novaMember.membershipId, ['technician']);
  });

  test('vínculo de outra empresa: NOT_FOUND, sem revelar que existe', () async {
    final anaInFrioSul = await member(ana, 'ana.admin@frio-sul.test');
    await expectLater(carla.users.setRoles(anaInFrioSul.membershipId, ['manager']), throwsApiError('NOT_FOUND'));
    await expectLater(carla.users.suspend(anaInFrioSul.membershipId), throwsApiError('NOT_FOUND'));
  });
}
