// Etiquetas QR de ponta a ponta: lote, impressão, leitura por código curto,
// token ou URL, vínculo ao bem, travas, desfazer vínculo, revogação e
// isolamento entre empresas.
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart.
@Tags(['e2e'])
library;

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:test/test.dart';

import 'support/e2e_login.dart';

void main() {
  late Client ana; // tenant_admin frio-sul (manage + unbind)
  late Client bruno; // dispatcher frio-sul (manage, sem unbind)
  late Client davi; // manager frio-sul (só leitura)
  late Client carla; // tenant_admin forno-norte
  late List<QrTag> tags;
  late Asset freezer;
  late Asset expositor;

  setUpAll(() async {
    ana = await tenantClient('ana.admin@frio-sul.test', 'frio-sul');
    bruno = await tenantClient('bruno.despacho@frio-sul.test', 'frio-sul');
    davi = await tenantClient('davi.consultor@dev.test', 'frio-sul');
    carla = await tenantClient('carla.admin@forno-norte.test', 'forno-norte');
    freezer = (await ana.assets.list(search: 'FS-FRZ-0001')).items.single;
    expositor = (await ana.assets.list(search: 'FS-EXP-0001')).items.single;
  });

  test('gera o lote, lista as etiquetas e marca como impresso', () async {
    await expectLater(ana.qrTags.generateBatch(0), throwsApiError('VALIDATION_FAILED'));
    await expectLater(davi.qrTags.generateBatch(3), throwsApiError('FORBIDDEN'));

    final batch = await ana.qrTags.generateBatch(3, notes: 'Teste e2e');
    expect(batch.quantity, 3);
    expect(batch.code, startsWith('LOTE-'));
    tags = await ana.qrTags.batchTags(batch.id);
    expect(tags, hasLength(3));
    expect(tags.every((t) => t.status == 'generated'), isTrue);
    expect(tags.first.shortCode, matches(RegExp(r'^[0-9A-Z]{4}-[0-9A-Z]{4}$')));
    expect(tags.first.url, contains('/q/'));

    final printed = await ana.qrTags.markBatchPrinted(batch.id);
    expect(printed.printedAt, isNotNull);
    tags = await ana.qrTags.batchTags(batch.id);
    expect(tags.every((t) => t.status == 'printed' && t.printCount == 1), isTrue);
  });

  test('leitura aceita código curto (com ou sem hífen, minúsculas), token e URL', () async {
    final tag = tags.first;
    final compact = tag.shortCode.replaceAll('-', '').toLowerCase();
    expect((await davi.qrTags.resolve(tag.shortCode)).id, tag.id);
    expect((await davi.qrTags.resolve(compact)).id, tag.id);
    expect((await davi.qrTags.resolve(tag.url)).id, tag.id);
    expect((await davi.qrTags.resolve(tag.url.split('/q/').last)).id, tag.id);
    await expectLater(davi.qrTags.resolve('nao-e-etiqueta'), throwsApiError('NOT_FOUND'));
  });

  test('vincula ao bem; travas de etiqueta usada e de bem já etiquetado', () async {
    final bound = await bruno.qrTags.bind(tags[0].shortCode, freezer.id);
    expect(bound.status, 'bound');
    expect(bound.assetId, freezer.id);
    expect(bound.assetLabel, 'FS-FRZ-0001');
    expect((await ana.assets.get(freezer.id)).qrShortCode, tags[0].shortCode);
    expect((await ana.assets.list(search: tags[0].shortCode)).items.single.id, freezer.id);

    await expectLater(bruno.qrTags.bind(tags[0].shortCode, freezer.id), throwsApiError('TAG_ALREADY_ON_ASSET'));
    await expectLater(bruno.qrTags.bind(tags[0].shortCode, expositor.id), throwsApiError('TAG_ALREADY_BOUND'));
    await expectLater(bruno.qrTags.bind(tags[1].shortCode, freezer.id), throwsApiError('ASSET_ALREADY_TAGGED'));
  });

  test('desfazer vínculo só com a permissão de exceção', () async {
    await expectLater(bruno.qrTags.unbind(tags[0].id), throwsApiError('FORBIDDEN'));
    final unbound = await ana.qrTags.unbind(tags[0].id);
    expect(unbound.status, 'printed');
    expect(unbound.assetId, isNull);
    expect((await ana.assets.get(freezer.id)).qrShortCode, isNull);
    await expectLater(ana.qrTags.unbind(tags[0].id), throwsApiError('TAG_NOT_BOUND'));
    // Volta para o mesmo bem.
    expect((await bruno.qrTags.bind(tags[0].shortCode, freezer.id)).assetId, freezer.id);
  });

  test('revogação: troca de etiqueta do bem e etiqueta revogada não volta', () async {
    await expectLater(ana.qrTags.revoke(tags[0].id, 'qualquer'), throwsApiError('VALIDATION_FAILED'));
    final revoked = await ana.qrTags.revoke(tags[0].id, 'replaced', note: 'etiqueta rasgada');
    expect(revoked.status, 'revoked');
    expect(revoked.revokedReason, 'replaced');
    expect((await bruno.qrTags.bind(tags[1].shortCode, freezer.id)).assetId, freezer.id);
    await expectLater(bruno.qrTags.bind(tags[0].shortCode, expositor.id), throwsApiError('TAG_REVOKED'));
    await expectLater(ana.qrTags.revoke(tags[0].id, 'lost'), throwsApiError('TAG_REVOKED'));
  });

  test('outra empresa não lê, não vincula e não vê os lotes', () async {
    await expectLater(carla.qrTags.resolve(tags[2].shortCode), throwsApiError('NOT_FOUND'));
    final fornoAsset = (await carla.assets.list()).items.first;
    await expectLater(carla.qrTags.bind(tags[2].shortCode, fornoAsset.id), throwsApiError('NOT_FOUND'));
    await expectLater(ana.qrTags.bind(tags[2].shortCode, fornoAsset.id), throwsApiError('VALIDATION_FAILED'));
    expect((await carla.qrTags.listBatches()).map((b) => b.id), isNot(contains(tags[2].batchId)));
    await expectLater(carla.qrTags.batchTags(tags[2].batchId!), throwsApiError('NOT_FOUND'));
  });
}
