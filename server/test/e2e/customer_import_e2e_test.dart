// Importação de clientes por planilha de ponta a ponta: tudo ou nada,
// relatório por linha e coluna, reimportação sem duplicar e permissões.
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart.
@Tags(['e2e'])
library;

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:test/test.dart';

import 'support/e2e_login.dart';

void main() {
  late Client ana; // tenant_admin frio-sul
  late Client davi; // manager frio-sul (não mexe em clientes)

  setUpAll(() async {
    ana = await tenantClient('ana.admin@frio-sul.test', 'frio-sul');
    davi = await tenantClient('davi.consultor@dev.test', 'frio-sul');
  });

  final rows = [
    CustomerImportRow(
      line: 2,
      code: 'IMP1',
      name: 'Mercado Importado Ltda',
      tradeName: 'Importado',
      documentNumber: '11.222.333/0001-81',
      siteName: 'Loja Centro',
      postalCode: '90000-000',
      city: 'Porto Alegre',
      state: 'rs',
      contactName: 'Rita',
      contactPhone: '51 98888-7777',
    ),
    CustomerImportRow(
      line: 3,
      code: 'IMP1',
      siteName: 'Loja Bairro',
      contactName: 'Paulo',
      contactEmail: 'paulo@importado.test',
    ),
    CustomerImportRow(line: 4, name: 'Joana Importada', personType: 'PF', documentNumber: '529.982.247-25'),
  ];

  test('valida, grava tudo e reimportar não duplica', () async {
    final dry = await ana.customers.importRows(rows, true);
    expect(dry.errors, isEmpty);
    expect(dry.applied, isFalse);
    expect((dry.customersCreated, dry.sitesCreated, dry.contactsCreated), (2, 2, 2));
    expect((await ana.customers.list(search: 'importad')).total, 0);

    final done = await ana.customers.importRows(rows, false);
    expect(done.applied, isTrue);
    final page = await ana.customers.list(search: 'importad');
    expect(page.items.map((c) => c.name), containsAll(['Mercado Importado Ltda', 'Joana Importada']));
    final mercado = page.items.firstWhere((c) => c.code == 'IMP1');
    expect(mercado.siteCount, 2);
    expect(page.items.firstWhere((c) => c.code == null).personType, 'individual');
    final contacts = await ana.customers.contacts(mercado.id);
    expect(contacts.map((c) => (c.name, c.phone, c.customerSiteName)), [
      ('Paulo', null, 'Loja Bairro'),
      ('Rita', '+5551988887777', 'Loja Centro'),
    ]);

    final again = await ana.customers.importRows(rows, false);
    expect((again.customersCreated, again.sitesCreated, again.contactsCreated), (0, 0, 0));
    expect((again.customersExisting, again.sitesExisting, again.contactsExisting), (2, 2, 2));
    expect((await ana.customers.list(search: 'importad')).total, 2);
  });

  test('com erro em uma linha, nada é gravado e o relatório aponta linha e coluna', () async {
    final report = await ana.customers.importRows([
      CustomerImportRow(line: 2, code: 'ERR1', name: 'Cliente Bom'),
      CustomerImportRow(line: 3, code: 'ERR2', name: 'CNPJ Curto', documentNumber: '123'),
      CustomerImportRow(line: 4, code: 'ERR3', name: 'UF Ruim', siteName: 'Loja', state: 'Rio Grande'),
      CustomerImportRow(line: 5, code: 'ERR4', name: 'Sem Meio', contactName: 'Fulano'),
      CustomerImportRow(line: 6, code: 'ERR5', name: 'Tipo Ruim', personType: 'ONG'),
      CustomerImportRow(line: 7),
    ], false);
    expect(report.applied, isFalse);
    expect(report.errors.map((e) => '${e.line}:${e.column}'), [
      '3:documento',
      '4:uf',
      '5:contato_telefone',
      '6:tipo',
      '7:nome',
    ]);
    expect((await ana.customers.list(search: 'Cliente Bom')).total, 0);
  });

  test('sem customers.manage não importa; limite de linhas', () async {
    await expectLater(
      davi.customers.importRows(rows, true),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'FORBIDDEN')),
    );
    await expectLater(
      ana.customers.importRows([], true),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'VALIDATION_FAILED')),
    );
  });
}
