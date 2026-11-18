// Modelos de checklist de ponta a ponta: rascunho, validação dos itens,
// publicação, nova versão, checklist padrão do tipo de OS e permissões.
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart.
@Tags(['e2e'])
library;

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:test/test.dart';

import 'support/e2e_login.dart';

Matcher throwsApiError(String code) => throwsA(isA<ApiException>().having((e) => e.code, 'code', code));

void main() {
  late Client ana; // tenant_admin frio-sul (catalog.manage)
  late Client davi; // manager frio-sul (só lê)
  late Client carla; // tenant_admin forno-norte

  setUpAll(() async {
    ana = await tenantClient('ana.admin@frio-sul.test', 'frio-sul');
    davi = await tenantClient('davi.consultor@dev.test', 'frio-sul');
    carla = await tenantClient('carla.admin@forno-norte.test', 'forno-norte');
  });

  ChecklistItem item(String label, String type, {bool required = true, List<String>? options, String? unit}) =>
      ChecklistItem(label: label, type: type, required: required, options: options, unit: unit);

  ChecklistTemplateInput input(String code, List<ChecklistItem> items, {String name = 'Preventiva freezer'}) =>
      ChecklistTemplateInput(code: code, name: name, items: items);

  test('rascunho com chaves geradas, publicação e nova versão', () async {
    final draft = await ana.checklists.create(
      input('prev-fz', [
        item('Temperatura de operação', 'number', unit: '°C'),
        item('Borracha da porta íntegra?', 'ok_nok'),
        item('Condição geral', 'choice', options: [' Boa ', 'Regular', 'Ruim', '']),
        item('Temperatura de operação', 'number', required: false),
        item('Observações', 'text', required: false),
      ]),
    );
    expect(draft.code, 'PREV-FZ');
    expect(draft.status, 'draft');
    expect(draft.templateVersion, 1);
    expect(draft.items.map((i) => i.key), [
      'temperatura_de_operacao',
      'borracha_da_porta_integra',
      'condicao_geral',
      'temperatura_de_operacao_2',
      'observacoes',
    ]);
    expect(draft.items[0].unit, '°C');
    expect(draft.items[2].options, ['Boa', 'Regular', 'Ruim']);

    final edited = await ana.checklists.update(
      draft.id,
      draft.version,
      input('PREV-FZ', [...draft.items.take(3), draft.items.last]),
    );
    expect(edited.items, hasLength(4));
    expect(edited.items.first.key, 'temperatura_de_operacao');

    final published = await ana.checklists.publish(edited.id, edited.version);
    expect(published.status, 'published');
    expect(published.publishedAt, isNotNull);
    await expectLater(
      ana.checklists.update(published.id, published.version, input('PREV-FZ', published.items)),
      throwsApiError('NOT_DRAFT'),
    );

    final v2 = await ana.checklists.newVersion(published.id);
    expect((v2.templateVersion, v2.status, v2.items.length), (2, 'draft', 4));
    await expectLater(ana.checklists.newVersion(published.id), throwsApiError('DRAFT_EXISTS'));
    await expectLater(
      ana.checklists.update(v2.id, v2.version, input('OUTRO', v2.items)),
      throwsApiError('VALIDATION_FAILED'),
    );
    final v2b = await ana.checklists.update(
      v2.id,
      v2.version,
      input('PREV-FZ', [...v2.items, item('Dreno desobstruído?', 'yes_no')]),
    );
    final v2p = await ana.checklists.publish(v2b.id, v2b.version);
    expect(v2p.status, 'published');

    final all = await davi.checklists.list(includeArchived: true);
    final mine = all.where((t) => t.code == 'PREV-FZ').map((t) => (t.templateVersion, t.status));
    expect(mine, [(2, 'published'), (1, 'archived')]);
    expect((await davi.checklists.list()).where((t) => t.code == 'PREV-FZ'), hasLength(1));
  });

  test('validação dos itens e do código', () async {
    Matcher field(String path) => throwsA(
      isA<ApiException>()
          .having((e) => e.code, 'code', 'VALIDATION_FAILED')
          .having((e) => e.fieldErrors!.map((f) => f.path), 'paths', contains(path)),
    );
    await expectLater(ana.checklists.create(input('', [])), field('code'));
    await expectLater(ana.checklists.create(input('X1', [item('', 'yes_no')])), field('items.0.label'));
    await expectLater(ana.checklists.create(input('X1', [item('Foto', 'photo')])), field('items.0.type'));
    await expectLater(
      ana.checklists.create(
        input('X1', [
          item('Escolha', 'choice', options: ['A', 'A']),
        ]),
      ),
      field('items.0.options'),
    );
    final empty = await ana.checklists.create(input('VAZIO', []));
    await expectLater(ana.checklists.publish(empty.id, empty.version), throwsApiError('EMPTY_CHECKLIST'));
    await expectLater(ana.checklists.create(input('vazio', [])), throwsApiError('VALIDATION_FAILED'));
    final archived = await ana.checklists.archive(empty.id, empty.version);
    expect(archived.status, 'archived');
  });

  test('checklist padrão do tipo de OS só aceita publicado', () async {
    final draft = await ana.checklists.create(input('INST', [item('Nivelado?', 'yes_no')], name: 'Instalação'));
    final type = (await ana.workOrders.types()).first;
    WorkOrderTypeInput typeInput(ChecklistTemplate? checklist) => WorkOrderTypeInput(
      code: type.code,
      name: type.name,
      category: type.category,
      defaultPriority: type.defaultPriority,
      requiresAsset: type.requiresAsset,
      isActive: type.isActive,
      defaultChecklistTemplateId: checklist?.id,
    );
    await expectLater(
      ana.workOrders.updateType(type.id, type.version, typeInput(draft)),
      throwsApiError('VALIDATION_FAILED'),
    );
    final published = await ana.checklists.publish(draft.id, draft.version);
    final updated = await ana.workOrders.updateType(type.id, type.version, typeInput(published));
    expect(updated.defaultChecklistTemplateId, published.id);
    expect(updated.defaultChecklistName, 'Instalação');
    final cleared = await ana.workOrders.updateType(type.id, updated.version, typeInput(null));
    expect(cleared.defaultChecklistTemplateId, isNull);
  });

  test('permissões e isolamento', () async {
    final t = await ana.checklists.create(input('ISO', [item('Ok?', 'yes_no')]));
    await expectLater(davi.checklists.create(input('DAVI', [item('Ok?', 'yes_no')])), throwsApiError('FORBIDDEN'));
    await expectLater(davi.checklists.publish(t.id, t.version), throwsApiError('FORBIDDEN'));
    await expectLater(carla.checklists.get(t.id), throwsApiError('NOT_FOUND'));
    expect((await carla.checklists.list()).where((x) => x.code == 'ISO'), isEmpty);
  });
}
