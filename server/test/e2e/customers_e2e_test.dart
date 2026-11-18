// Clientes e unidades de ponta a ponta: permissões, validação, busca,
// concorrência otimista e isolamento entre empresas.
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart.
@Tags(['e2e'])
library;

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:test/test.dart';

import 'support/e2e_login.dart';

void main() {
  late Client ana; // tenant_admin frio-sul
  late Client davi; // manager frio-sul (lê OS, não mexe em clientes)
  late Client carla; // tenant_admin forno-norte

  setUpAll(() async {
    ana = await tenantClient('ana.admin@frio-sul.test', 'frio-sul');
    davi = await tenantClient('davi.consultor@dev.test', 'frio-sul');
    carla = await tenantClient('carla.admin@forno-norte.test', 'forno-norte');
  });

  CustomerInput input(String name, {String? document, String personType = 'company', bool isActive = true}) =>
      CustomerInput(name: name, personType: personType, documentNumber: document, isActive: isActive);

  CustomerSiteInput siteInput(String name, {String? state, String? postalCode, double? lat, double? lng}) =>
      CustomerSiteInput(
        name: name,
        state: state,
        postalCode: postalCode,
        latitude: lat,
        longitude: lng,
        isActive: true,
      );

  test('lista do seed com unidades e busca por nome e documento', () async {
    final page = await ana.customers.list();
    expect(page.items.map((c) => c.tradeName), containsAll(['Pão Quente', 'Bom Preço']));
    expect(page.items.firstWhere((c) => c.code == 'C001').siteCount, greaterThanOrEqualTo(1));
    expect((await ana.customers.list(search: 'quente')).items.single.code, 'C001');
    expect((await ana.customers.list(search: '98.765.432')).items.single.code, 'C002');
    // Quem lê OS também lê clientes (filtros e abertura).
    expect((await davi.customers.list()).total, page.total);
  });

  test('cria empresa e pessoa física, valida documento e código repetido', () async {
    final company = await ana.customers.create(
      CustomerInput(
        code: 'C900',
        name: 'Sorveteria Gelato Ltda',
        tradeName: 'Gelato',
        personType: 'company',
        documentNumber: '11.444.777/0001-61',
        email: 'Compras@Gelato.test',
        isActive: true,
      ),
    );
    expect(company.documentType, 'cnpj');
    expect(company.documentNumber, '11444777000161');
    expect(company.email, 'compras@gelato.test');
    expect(company.siteCount, 0);

    final person = await ana.customers.create(
      input('Joana Lima', document: '123.456.789-09', personType: 'individual'),
    );
    expect(person.documentType, 'cpf');
    final none = await ana.customers.create(input('Sem documento'));
    expect(none.documentType, 'none');

    await expectLater(
      ana.customers.create(input('CPF errado', document: '123', personType: 'individual')),
      throwsA(
        isA<ApiException>()
            .having((e) => e.code, 'code', 'VALIDATION_FAILED')
            .having((e) => e.fieldErrors!.single.message, 'msg', 'O CPF tem 11 dígitos.'),
      ),
    );
    await expectLater(
      ana.customers.create(CustomerInput(code: 'C900', name: 'Outro', personType: 'company', isActive: true)),
      throwsA(isA<ApiException>().having((e) => e.fieldErrors!.single.path, 'path', 'code')),
    );
  });

  test('altera com versão, inativa e some da lista padrão', () async {
    final c = await ana.customers.create(input('Bar do Zé'));
    final updated = await ana.customers.update(
      c.id,
      c.version,
      CustomerInput(name: 'Bar do Zé Ltda', tradeName: 'Bar do Zé', personType: 'company', isActive: false),
    );
    expect(updated.version, c.version + 1);
    expect(updated.isActive, isFalse);
    await expectLater(
      ana.customers.update(c.id, c.version, input('Velha')),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'VERSION_MISMATCH')),
    );
    expect((await ana.customers.list(search: 'Bar do Zé')).items, isEmpty);
    expect((await ana.customers.list(search: 'Bar do Zé', includeInactive: true)).items.single.id, c.id);
  });

  test('unidades: cria, valida CEP, UF e coordenadas, altera', () async {
    final c = await ana.customers.create(input('Rede Frios'));
    final site = await ana.customers.createSite(
      c.id,
      CustomerSiteInput(
        name: 'Loja Bairro',
        street: 'Rua A',
        streetNumber: '100',
        city: 'Porto Alegre',
        state: 'rs',
        postalCode: '90.000-000',
        latitude: -30.03,
        longitude: -51.23,
        accessNotes: 'Entrada pelos fundos',
        isActive: true,
      ),
    );
    expect(site.state, 'RS');
    expect(site.postalCode, '90000000');
    expect(site.latitude, closeTo(-30.03, 1e-9));
    expect((await ana.customers.get(c.id)).siteCount, 1);

    await expectLater(
      ana.customers.createSite(c.id, siteInput('X', state: 'Rio Grande', postalCode: '123', lat: 10)),
      throwsA(
        isA<ApiException>().having(
          (e) => e.fieldErrors!.map((f) => f.path).toSet(),
          'paths',
          {'state', 'postalCode', 'latitude'},
        ),
      ),
    );

    final moved = await ana.customers.updateSite(site.id, site.version, siteInput('Loja Bairro Novo'));
    expect(moved.name, 'Loja Bairro Novo');
    expect(moved.latitude, isNull);
    expect((await ana.customers.sites(c.id)).single.version, site.version + 1);
  });

  test('sem customers.manage não altera; outra empresa não enxerga', () async {
    final c = (await ana.customers.list(search: 'quente')).items.single;
    await expectLater(
      davi.customers.create(input('Proibido')),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'FORBIDDEN')),
    );
    expect((await carla.customers.list(search: 'quente')).items, isEmpty);
    await expectLater(
      carla.customers.get(c.id),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'NOT_FOUND')),
    );
    await expectLater(
      carla.customers.createSite(c.id, siteInput('Invasão')),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'NOT_FOUND')),
    );
  });
}
