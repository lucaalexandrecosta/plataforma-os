import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_backoffice/src/ui/master_data/master_data_page.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import 'app_test.dart' show login, pumpApp;
import 'fake_gateway.dart';

Future<void> tapKey(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

Finder cell(String text) => find.descendant(of: find.byType(DataTable), matching: find.text(text));

Future<void> openMasterData(WidgetTester tester, FakeGateway gateway) async {
  await pumpApp(tester, gateway);
  await login(tester);
  await tester.tap(find.text('Cadastros'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('filial: cria com CNPJ, código repetido marca o campo e edita', (tester) async {
    final gateway = FakeGateway();
    await openMasterData(tester, gateway);
    expect(find.text('Nenhuma filial cadastrada.'), findsOneWidget);

    await tapKey(tester, 'branch-new');
    await tapKey(tester, 'branch-save');
    expect(find.text('Informe o código.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('branch-code')), '01');
    await tester.enterText(find.byKey(const Key('branch-legal')), 'Frio Sul Refrigeração Ltda');
    await tester.enterText(find.byKey(const Key('branch-cnpj')), '1234');
    await tapKey(tester, 'branch-save');
    expect(find.text('O CNPJ tem 14 dígitos.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('branch-cnpj')), '12.345.678/0001-90');
    await tapKey(tester, 'branch-default');
    await tapKey(tester, 'branch-save');
    expect(cell('01 (padrão)'), findsOneWidget);
    expect(cell('12.345.678/0001-90'), findsOneWidget);

    await tapKey(tester, 'branch-new');
    await tester.enterText(find.byKey(const Key('branch-code')), '01');
    await tester.enterText(find.byKey(const Key('branch-legal')), 'Outra');
    await tapKey(tester, 'branch-save');
    expect(find.text('Já existe uma filial com este código.'), findsOneWidget);
    await tester.tap(find.text('Cancelar'));
    await tester.pumpAndSettle();

    await tester.tap(cell('Frio Sul Refrigeração Ltda'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('branch-legal')), 'Frio Sul Ltda');
    await tapKey(tester, 'branch-save');
    expect(cell('Frio Sul Ltda'), findsOneWidget);
    expect(gateway.branchList.single.version, 2);
  });

  testWidgets('centro de custo ligado a uma filial e equipamento novo', (tester) async {
    final gateway = FakeGateway();
    await gateway.createBranch(
      BranchInput(code: '01', legalName: 'Frio Sul Ltda', tradeName: 'Matriz', isDefault: true, isActive: true),
    );
    await openMasterData(tester, gateway);

    await tester.tap(find.text('Centros de custo'));
    await tester.pumpAndSettle();
    await tapKey(tester, 'cc-new');
    await tester.enterText(find.byKey(const Key('cc-code')), '1.01');
    await tester.enterText(find.byKey(const Key('cc-name')), 'Manutenção');
    await tapKey(tester, 'cc-branch');
    await tester.tap(find.text('01 · Matriz').last);
    await tester.pumpAndSettle();
    await tapKey(tester, 'cc-save');
    expect(cell('Manutenção'), findsOneWidget);
    expect(cell('01'), findsOneWidget);
    expect(gateway.costCenterList.single.branchId, gateway.branchList.single.id);

    await tester.tap(find.text('Equipamentos'));
    await tester.pumpAndSettle();
    await tapKey(tester, 'product-new');
    await tester.enterText(find.byKey(const Key('product-code')), 'FRZ-400');
    await tester.enterText(find.byKey(const Key('product-name')), 'Freezer horizontal 400 L');
    await tapKey(tester, 'product-save');
    expect(cell('Freezer horizontal 400 L'), findsOneWidget);
  });

  testWidgets('só assets.manage: vê só Equipamentos', (tester) async {
    final gateway = FakeGateway(permissions: const ['work_orders.read', 'assets.manage']);
    await openMasterData(tester, gateway);
    expect(find.text('Filiais'), findsNothing);
    expect(find.text('Equipamentos'), findsOneWidget);
  });

  testWidgets('sem permissão de cadastro, sem menu', (tester) async {
    await pumpApp(tester, FakeGateway(permissions: const ['work_orders.read']));
    await login(tester);
    expect(find.text('Cadastros'), findsNothing);
  });

  test('CNPJ formatado', () {
    expect(formatCnpj('12345678000190'), '12.345.678/0001-90');
    expect(formatCnpj('123'), '123');
  });
}
