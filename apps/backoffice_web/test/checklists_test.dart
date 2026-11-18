import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import 'app_test.dart' show login, pumpApp;
import 'customers_test.dart' show tapKey;
import 'fake_gateway.dart';

Future<void> openChecklists(WidgetTester tester, FakeGateway gateway) async {
  await pumpApp(tester, gateway);
  tester.view.physicalSize = const Size(1400, 2000);
  await login(tester);
  await tester.tap(find.text('Checklists'));
  await tester.pumpAndSettle();
}

Future<void> pick(WidgetTester tester, String key, String option) async {
  await tapKey(tester, key);
  await tester.tap(find.text(option).last);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('cria checklist com itens, publica e cria nova versão', (tester) async {
    final gateway = FakeGateway();
    await openChecklists(tester, gateway);
    expect(find.textContaining('Nenhum checklist'), findsOneWidget);

    await tapKey(tester, 'checklist-new');
    await tapKey(tester, 'checklist-save');
    expect(find.text('Informe o código.'), findsOneWidget);
    expect(find.text('Informe a pergunta.'), findsOneWidget);

    await tester.enterText(find.byKey(const Key('checklist-code')), 'prev-fz');
    await tester.enterText(find.byKey(const Key('checklist-name')), 'Preventiva freezer');
    await tester.enterText(find.byKey(const Key('item-label-0')), 'Borracha da porta íntegra?');

    await tapKey(tester, 'checklist-add-item');
    await tester.enterText(find.byKey(const Key('item-label-1')), 'Temperatura');
    await pick(tester, 'item-type-1', 'Número');

    await tapKey(tester, 'checklist-add-item');
    await tester.enterText(find.byKey(const Key('item-label-2')), 'Condição geral');
    await pick(tester, 'item-type-2', 'Escolha');
    await tester.enterText(find.byKey(const Key('item-options-2')), 'Boa');
    await tapKey(tester, 'checklist-save');
    expect(find.text('Informe ao menos duas opções.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('item-options-2')), 'Boa\nRuim\n');
    await tapKey(tester, 'item-required-2');
    await tapKey(tester, 'checklist-save');

    final draft = gateway.checklistList.single;
    expect(draft.status, 'draft');
    expect(draft.items.map((i) => (i.type, i.required)), [('ok_nok', true), ('number', true), ('choice', false)]);
    expect(draft.items[2].options, ['Boa', 'Ruim']);
    expect(find.text('v1 · Rascunho'), findsOneWidget);

    await tapKey(tester, 'checklist-publish');
    expect(gateway.checklistList.single.status, 'published');
    expect(find.text('v1 · Publicado'), findsOneWidget);
    expect(find.byKey(const Key('checklist-save')), findsNothing);

    await tapKey(tester, 'checklist-new-version');
    expect(gateway.checklistList.map((c) => (c.templateVersion, c.status)), [(1, 'published'), (2, 'draft')]);
    expect(find.text('v2 · Rascunho'), findsOneWidget);
    await tapKey(tester, 'item-remove-1');
    await tapKey(tester, 'checklist-publish');
    expect(gateway.checklistList.map((c) => (c.templateVersion, c.status, c.items.length)), [
      (1, 'archived', 3),
      (2, 'published', 2),
    ]);

    await tester.tap(find.byTooltip('Voltar à lista'));
    await tester.pumpAndSettle();
    expect(find.text('Preventiva freezer'), findsOneWidget);
    expect(find.text('Publicado'), findsOneWidget);
  });

  testWidgets('tipo de OS recebe o checklist publicado', (tester) async {
    final gateway = FakeGateway();
    final draft = await gateway.createChecklist(
      ChecklistTemplateInput(
        code: 'INST',
        name: 'Instalação',
        items: [ChecklistItem(label: 'Nivelado?', type: 'yes_no', required: true)],
      ),
    );
    await gateway.createChecklist(ChecklistTemplateInput(code: 'RASC', name: 'Só rascunho', items: const []));
    await gateway.publishChecklist(draft);

    await pumpApp(tester, gateway);
    await login(tester);
    await tester.tap(find.text('Cadastros'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tipos de OS'));
    await tester.pumpAndSettle();
    expect(find.text('Corretiva'), findsWidgets);

    await tester.tap(find.text('COR'));
    await tester.pumpAndSettle();
    await tapKey(tester, 'wot-checklist');
    expect(find.text('Só rascunho (RASC)'), findsNothing);
    await tester.tap(find.text('Instalação (INST)').last);
    await tester.pumpAndSettle();
    await tapKey(tester, 'wot-save');

    expect(gateway.typeList.single.defaultChecklistTemplateId, draft.id);
    expect(find.text('Instalação'), findsOneWidget);
  });

  testWidgets('sem catalog.manage não há menu de checklists', (tester) async {
    final gateway = FakeGateway(permissions: const ['work_orders.read']);
    await pumpApp(tester, gateway);
    await login(tester);
    expect(find.text('Checklists'), findsNothing);
  });
}
