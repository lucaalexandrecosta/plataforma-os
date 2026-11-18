// Contatos dos clientes de ponta a ponta: validação, normalização do
// telefone, unidade do mesmo cliente, concorrência otimista e isolamento.
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart.
@Tags(['e2e'])
library;

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:test/test.dart';

import 'support/e2e_login.dart';

void main() {
  late Client ana; // tenant_admin frio-sul
  late Client davi; // manager frio-sul (lê, não mexe em clientes)
  late Client carla; // tenant_admin forno-norte

  setUpAll(() async {
    ana = await tenantClient('ana.admin@frio-sul.test', 'frio-sul');
    davi = await tenantClient('davi.consultor@dev.test', 'frio-sul');
    carla = await tenantClient('carla.admin@forno-norte.test', 'forno-norte');
  });

  CustomerContactInput input(
    String name, {
    String? email,
    String? phone,
    String? channel,
    CustomerSite? site,
    String role = 'customer_contact',
    bool isActive = true,
  }) => CustomerContactInput(
    name: name,
    email: email,
    phone: phone,
    preferredChannel: channel,
    customerSiteId: site?.id,
    contactRole: role,
    canOpenRequests: true,
    isActive: isActive,
  );

  Matcher validation(String path, String code) => throwsA(
    isA<ApiException>()
        .having((e) => e.code, 'code', 'VALIDATION_FAILED')
        .having((e) => e.fieldErrors!.map((f) => '${f.path}:${f.code}'), 'fields', contains('$path:$code')),
  );

  test('cria com telefone normalizado, unidade e canal; lista do cliente', () async {
    final customer = await ana.customers.create(
      CustomerInput(name: 'Padaria Contatos', personType: 'company', isActive: true),
    );
    final site = await ana.customers.createSite(customer.id, CustomerSiteInput(name: 'Loja 1', isActive: true));

    final gerente = await ana.customers.createContact(
      customer.id,
      input(
        'Marta Gerente',
        email: 'Marta@Padaria.test',
        phone: '(51) 99999-8888',
        channel: 'whatsapp',
        site: site,
        role: 'customer_admin',
      ),
    );
    expect(gerente.phone, '+5551999998888');
    expect(gerente.email, 'marta@padaria.test');
    expect(gerente.customerSiteName, 'Loja 1');
    expect(gerente.status, 'active');
    expect(gerente.source, 'local');

    final caixa = await ana.customers.createContact(customer.id, input('Caixa', phone: '+54 11 4444-5555'));
    expect(caixa.phone, '+541144445555');

    final list = await davi.customers.contacts(customer.id);
    expect(list.map((c) => c.name), ['Caixa', 'Marta Gerente']);
  });

  test('valida contato, telefone, canal e unidade de outro cliente', () async {
    final a = await ana.customers.create(CustomerInput(name: 'Cliente A', personType: 'company', isActive: true));
    final b = await ana.customers.create(CustomerInput(name: 'Cliente B', personType: 'company', isActive: true));
    final siteB = await ana.customers.createSite(b.id, CustomerSiteInput(name: 'Unidade B', isActive: true));

    await expectLater(ana.customers.createContact(a.id, input('Sem meio')), validation('phone', 'REQUIRED'));
    await expectLater(ana.customers.createContact(a.id, input('Curto', phone: '1234')), validation('phone', 'INVALID'));
    await expectLater(
      ana.customers.createContact(a.id, input('Mail', email: 'x@y.test', channel: 'whatsapp')),
      validation('preferredChannel', 'NEEDS_PHONE'),
    );
    await expectLater(
      ana.customers.createContact(a.id, input('Fone', phone: '51999998888', channel: 'email')),
      validation('preferredChannel', 'NEEDS_EMAIL'),
    );
    await expectLater(
      ana.customers.createContact(a.id, input('Outra unidade', email: 'x@y.test', site: siteB)),
      validation('customerSiteId', 'NOT_FOUND'),
    );
    await expectLater(
      ana.customers.createContact(a.id, input('Papel', email: 'x@y.test', role: 'tenant_admin')),
      validation('contactRole', 'INVALID'),
    );
  });

  test('altera com versão e inativa', () async {
    final c = await ana.customers.create(CustomerInput(name: 'Cliente V', personType: 'company', isActive: true));
    final contact = await ana.customers.createContact(c.id, input('João', email: 'joao@v.test'));
    final updated = await ana.customers.updateContact(
      contact.id,
      contact.version,
      input('João Silva', email: 'joao@v.test', phone: '5133334444', isActive: false),
    );
    expect(updated.name, 'João Silva');
    expect(updated.phone, '+555133334444');
    expect(updated.isActive, isFalse);
    expect(updated.version, contact.version + 1);
    await expectLater(
      ana.customers.updateContact(contact.id, contact.version, input('Velho', email: 'joao@v.test')),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'VERSION_MISMATCH')),
    );
  });

  test('sem customers.manage não cria; outra empresa não enxerga', () async {
    final c = await ana.customers.create(CustomerInput(name: 'Cliente P', personType: 'company', isActive: true));
    final contact = await ana.customers.createContact(c.id, input('Pedro', email: 'pedro@p.test'));
    await expectLater(
      davi.customers.createContact(c.id, input('Intruso', email: 'i@p.test')),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'FORBIDDEN')),
    );
    await expectLater(
      carla.customers.contacts(c.id),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'NOT_FOUND')),
    );
    await expectLater(
      carla.customers.updateContact(contact.id, contact.version, input('Invasão', email: 'i@p.test')),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'NOT_FOUND')),
    );
  });
}
