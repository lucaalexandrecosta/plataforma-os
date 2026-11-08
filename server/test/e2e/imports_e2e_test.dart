// Importação por planilha de ponta a ponta: modelo, prévia com erros por
// linha, confirmação, idempotência (reenviar não duplica), relatório de
// erros, XLSX, permissões e isolamento.
@Tags(['e2e'])
library;

import 'dart:convert';
import 'dart:typed_data';

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:test/test.dart';

import '../support/xlsx.dart';
import 'support.dart';

ByteData csv(String text) => ByteData.sublistView(Uint8List.fromList(utf8.encode(text)));
String text(ByteData b) => utf8.decode(b.buffer.asUint8List(b.offsetInBytes, b.lengthInBytes));

void main() {
  late Client asAna;
  late Client asBruno;
  late Client asCarla;
  late pg.Connection db;
  final run = DateTime.now().toUtc().millisecondsSinceEpoch.toRadixString(36).toUpperCase();

  setUpAll(() async {
    final tokens = loadTestTokens();
    asAna = clientAs(tokens, ana);
    asBruno = clientAs(tokens, bruno);
    asCarla = clientAs(tokens, carla);
    db = await openTestDb();
  });
  tearDownAll(() => db.close());

  Matcher apiError(String code) => throwsA(isA<ApiException>().having((e) => e.code, 'code', code));

  test('modelo: colunas com ajuda e CSV que abre no Excel', () async {
    final t = await asAna.imports.template(ImportEntityType.customers);
    expect(t.columns.where((c) => c.isRequired).map((c) => c.key), ['codigo', 'razao_social']);
    final bytes = t.csv.buffer.asUint8List(t.csv.offsetInBytes, t.csv.lengthInBytes);
    expect(bytes.take(3), [0xEF, 0xBB, 0xBF], reason: 'BOM: o Excel abre em UTF-8');
    expect(text(t.csv), contains('codigo;razao_social;'));
    expect(await asAna.imports.available(), containsAll([ImportEntityType.customers, ImportEntityType.customer_sites]));
  });

  test('clientes: prévia com erros por linha, confirmação parcial e reenvio idempotente', () async {
    final file =
        '﻿Código;Razão Social;CNPJ/CPF;Telefone;Coluna extra\r\n'
        'IMP-$run-1;Sorveteria Polar Ltda;11.222.333/0001-81;(51) 3333-4444;x\r\n'
        'IMP-$run-2;Mercado Errado;11.222.333/0001-80;;\r\n'
        'IMP-$run-1;Repetido;;;\r\n'
        'IMP-$run-3;Ana Pessoa Física;529.982.247-25;;\r\n';
    final preview = await asAna.imports.preview(ImportEntityType.customers, 'clientes.csv', csv(file));
    expect(preview.recognizedColumns, containsAll(['codigo', 'razao_social', 'documento', 'telefone']));
    expect(preview.unknownColumns, ['Coluna extra']);
    expect(preview.run.status, SyncRunStatus.queued);
    expect(preview.run.stats.totalRows, 4);
    expect(preview.run.stats.toCreate, 2);
    expect(preview.run.stats.errorRows, 2);
    expect(preview.errors.map((e) => e.rowNumber), [3, 4]);
    expect(preview.errors.first.messages.single, contains('CNPJ'));
    expect(preview.run.hasErrorReport, isTrue);

    // Nada é gravado antes de confirmar.
    final before = await asAna.customers.list(CustomerFilter(q: 'IMP-$run'), null);
    expect(before.items, isEmpty);

    final report = text(await asAna.imports.errorReport(preview.run.id));
    expect(report, contains('linha;Código;Razão Social'));
    expect(report, contains('Mercado Errado'));
    expect(report, isNot(contains('Sorveteria')));

    final done = await asAna.imports.confirm(preview.run.id, preview.run.version);
    expect(done.status, SyncRunStatus.partially_succeeded);
    expect(done.stats.created, 2);
    await expectLater(asAna.imports.confirm(done.id, done.version), apiError('INVALID_TRANSITION'));

    final created = await asAna.customers.list(CustomerFilter(q: 'IMP-$run'), null);
    expect(created.items.map((c) => c.code).toSet(), {'IMP-$run-1', 'IMP-$run-3'});
    final pf = created.items.firstWhere((c) => c.code == 'IMP-$run-3');
    expect(pf.personType, PersonType.individual, reason: 'CPF → pessoa física');
    expect(pf.documentType, DocumentType.cpf);

    final events = await db.execute(
      pg.Sql.named(
        "SELECT count(*) FROM app.outbox_messages WHERE event_type = 'customer.created' "
        "AND payload->>'import_run_id' = @run AND payload->>'origin' = 'file_import'",
      ),
      parameters: {'run': done.id.uuid},
    );
    expect(events.single[0], 2);

    // Reenviar a mesma planilha não duplica: as linhas válidas ficam "sem mudança".
    final again = await asAna.imports.preview(ImportEntityType.customers, 'clientes.csv', csv(file));
    expect(again.run.stats.toCreate, 0);
    expect(again.run.stats.unchanged, 2);
    await asAna.imports.cancel(again.run.id, again.run.version);
    expect((await asAna.imports.get(again.run.id)).status, SyncRunStatus.cancelled);
  });

  test('atualização: célula vazia não apaga; valor novo atualiza', () async {
    await asAna.customers.create(
      CustomerInput(code: 'UPD-$run', name: 'Antigo Nome', documentType: DocumentType.none, notes: 'manter'),
    );
    final p = await asAna.imports.preview(
      ImportEntityType.customers,
      'u.csv',
      csv('codigo;razao_social;observacoes\nUPD-$run;Nome Novo;\n'),
    );
    expect(p.run.stats.toUpdate, 1);
    await asAna.imports.confirm(p.run.id, p.run.version);
    final c = (await asAna.customers.list(CustomerFilter(q: 'UPD-$run'), null)).items.single;
    expect(c.name, 'Nome Novo');
    expect(c.notes, 'manter');
  });

  test('XLSX: unidades e contatos ligados ao cliente pelo código', () async {
    final code = 'XLS-$run';
    await asAna.customers.create(CustomerInput(code: code, name: 'Cliente XLSX', documentType: DocumentType.none));
    final sites = buildXlsx([
      ['codigo_cliente', 'codigo_unidade', 'nome_unidade', 'cep', 'cidade', 'uf', 'latitude', 'longitude'],
      [code, 'U01', 'Loja Centro', 90020007, 'Porto Alegre', 'RS', '-30,0277', '-51,2287'],
      [code, 'U02', 'Depósito', null, 'Canoas', 'XX', null, null],
      ['NAO-EXISTE', 'U01', 'Fantasma', null, null, null, null, null],
    ]);
    final sp = await asAna.imports.preview(
      ImportEntityType.customer_sites,
      'unidades.xlsx',
      ByteData.sublistView(sites),
    );
    expect(sp.run.stats.toCreate, 1);
    expect(sp.errors.map((e) => e.rowNumber), [3, 4]);
    expect(sp.errors[0].messages.single, contains('UF'));
    expect(sp.errors[1].messages.single, contains('não encontrado'));
    await asAna.imports.confirm(sp.run.id, sp.run.version);

    final customer = (await asAna.customers.list(CustomerFilter(q: code), null)).items.single;
    final site = (await asAna.customerSites.list(CustomerSiteFilter(customerId: customer.id), null)).items.single;
    expect(site.postalCode, '90020007');
    expect(site.latitude, closeTo(-30.0277, 1e-9));

    final cp = await asAna.imports.preview(
      ImportEntityType.customer_contacts,
      'contatos.csv',
      csv(
        'codigo_cliente;nome;celular;email;codigo_unidade;administrador\n'
        '$code;Maria;(51) 98888-7777;maria@x.test;U01;sim\n'
        '$code;Sem Canal;;;;\n',
      ),
    );
    expect(cp.run.stats.toCreate, 1);
    expect(cp.errors.single.rowNumber, 3);
    await asAna.imports.confirm(cp.run.id, cp.run.version);
    final contact = (await asAna.customerContacts.list(
      CustomerContactFilter(customerId: customer.id),
      null,
    )).items.single;
    expect(contact.customerSiteId, site.id);
    expect(contact.contactRole, ContactRole.customer_admin);
    expect(contact.origin, ContactOrigin.file_import);
  });

  test('colunas obrigatórias ausentes: importação falha sem planejar', () async {
    final p = await asAna.imports.preview(ImportEntityType.customers, 'x.csv', csv('nome_fantasia\nX\n'));
    expect(p.missingColumns, ['codigo', 'razao_social']);
    expect(p.run.status, SyncRunStatus.failed);
    expect(p.run.errorMessage, contains('Código'));
  });

  test('permissão imports.run e isolamento', () async {
    await expectLater(asBruno.imports.template(ImportEntityType.customers), apiError('FORBIDDEN'));
    final p = await asAna.imports.preview(
      ImportEntityType.customers,
      'iso.csv',
      csv('codigo;razao_social\nISO-$run;X\n'),
    );
    await expectLater(asCarla.imports.get(p.run.id), apiError('NOT_FOUND'));
    await expectLater(asCarla.imports.confirm(p.run.id, p.run.version), apiError('NOT_FOUND'));
    final mine = await asCarla.imports.list(null, null);
    expect(mine.items.map((r) => r.id), isNot(contains(p.run.id)));
    await expectLater(
      asAna.imports.preview(ImportEntityType.customers, 'x.pdf', csv('a')),
      apiError('BUSINESS_RULE_VIOLATION'),
    );
  });
}
