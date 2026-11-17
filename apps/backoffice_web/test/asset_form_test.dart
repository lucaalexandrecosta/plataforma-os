import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_backoffice/src/api/gateway.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import 'app_test.dart' show login, pumpApp;
import 'fake_gateway.dart';

Future<void> tapKey(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

Future<void> pick(WidgetTester tester, String key, String option) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
  await tester.tap(find.text(option).last);
  await tester.pumpAndSettle();
}

Future<FakeGateway> seeded() async {
  final g = FakeGateway();
  await g.createProduct(ProductInput(code: 'FRZ-400', name: 'Freezer horizontal 400 L'));
  await g.createBranch(
    BranchInput(code: '01', legalName: 'Matriz Ltda', tradeName: 'Matriz', isDefault: true, isActive: true),
  );
  await g.createBranch(
    BranchInput(code: '02', legalName: 'Filial Ltda', tradeName: 'Norte', isDefault: false, isActive: true),
  );
  await g.createCostCenter(
    CostCenterInput(code: '1.01', name: 'Manutenção', branchId: g.branchList[0].id, isActive: true),
  );
  await g.createCostCenter(CostCenterInput(code: '9.99', name: 'Geral', isActive: true));
  g.calls.clear();
  return g;
}

void main() {
  testWidgets('novo bem: validação, filial filtra centro de custo e abre a ficha', (tester) async {
    final gateway = await seeded();
    await pumpApp(tester, gateway);
    await login(tester);
    await tester.tap(find.text('Bens'));
    await tester.pumpAndSettle();

    await tapKey(tester, 'asset-new');
    await tapKey(tester, 'asset-save');
    expect(find.text('Escolha o equipamento.'), findsOneWidget);
    expect(find.text('Informe o patrimônio ou a série.'), findsOneWidget);

    await pick(tester, 'asset-product', 'FRZ-400 · Freezer horizontal 400 L');
    await tester.enterText(find.byKey(const Key('asset-tag')), 'PAT-900');
    await tester.enterText(find.byKey(const Key('asset-cost')), 'abc');
    await tapKey(tester, 'asset-save');
    expect(find.text('Valor inválido (ex.: 1.234,56).'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('asset-cost')), '5.000,00');

    await pick(tester, 'asset-branch', '02 · Norte');
    await tester.tap(find.byKey(ValueKey('asset-cost-center-${gateway.branchList[1].id}')));
    await tester.pumpAndSettle();
    expect(find.text('1.01 · Manutenção'), findsNothing);
    await tester.tap(find.text('9.99 · Geral').last);
    await tester.pumpAndSettle();

    await tapKey(tester, 'asset-acquired');
    await tester.tap(find.text('15'));
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    await tapKey(tester, 'asset-save');
    final input = gateway.lastAssetInput!;
    expect(input.assetTag, 'PAT-900');
    expect(input.acquisitionCost, 500000);
    expect(input.branchId, gateway.branchList[1].id);
    expect(input.costCenterId, gateway.costCenterList[1].id);
    expect(input.acquisitionDate!.day, 15);
    expect(input.acquisitionDate!.isUtc, isTrue);
    expect(find.text('PAT-900'), findsOneWidget);
    expect(find.text('Freezer horizontal 400 L'), findsWidgets);
  });

  testWidgets('editar bem do ERP: campos mestres travados, local muda', (tester) async {
    final gateway = await seeded();
    gateway.currentAsset = FakeGateway.asset1.copyWith(
      source: 'erp',
      productId: gateway.productList.single.id,
      branchId: gateway.branchList[0].id,
    );
    await pumpApp(tester, gateway);
    await login(tester);
    await tester.tap(find.text('Bens'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PAT-001'));
    await tester.pumpAndSettle();

    await tapKey(tester, 'asset-edit');
    expect(find.text('Bem do ERP: produto, série, patrimônio, filial e aquisição só mudam lá.'), findsOneWidget);
    expect(
      tester
          .widget<TextField>(find.descendant(of: find.byKey(const Key('asset-tag')), matching: find.byType(TextField)))
          .enabled,
      isFalse,
    );
    await pick(tester, 'asset-ownership', 'Do cliente');
    await tapKey(tester, 'asset-save');
    expect(gateway.lastAssetInput!.ownershipType, 'customer_owned');
    expect(gateway.lastAssetInput!.assetTag, 'PAT-001');
    expect(find.text('Do cliente'), findsOneWidget);
  });

  testWidgets('patrimônio repetido aparece no campo', (tester) async {
    final gateway = await seeded();
    gateway.failNext['createAsset'] = const GatewayException(
      'Revise os campos destacados.',
      code: 'VALIDATION_FAILED',
      fieldErrors: {'assetTag': 'Já existe um bem com este número de patrimônio.'},
    );
    await pumpApp(tester, gateway);
    await login(tester);
    await tester.tap(find.text('Bens'));
    await tester.pumpAndSettle();
    await tapKey(tester, 'asset-new');
    await pick(tester, 'asset-product', 'FRZ-400 · Freezer horizontal 400 L');
    await tester.enterText(find.byKey(const Key('asset-tag')), 'PAT-001');
    await tapKey(tester, 'asset-save');
    expect(find.text('Já existe um bem com este número de patrimônio.'), findsOneWidget);
  });

  testWidgets('sem assets.manage: sem Novo bem nem Editar', (tester) async {
    await pumpApp(tester, FakeGateway(permissions: const ['work_orders.read']));
    await login(tester);
    await tester.tap(find.text('Bens'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('asset-new')), findsNothing);
    await tester.tap(find.text('PAT-001'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('asset-edit')), findsNothing);
  });
}
