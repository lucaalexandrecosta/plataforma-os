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

Future<FakeGateway> seeded() async {
  final g = FakeGateway();
  final pao = await g.createCustomer(
    CustomerInput(name: 'Padaria Pão Quente Ltda', tradeName: 'Pão Quente', personType: 'company', isActive: true),
  );
  await g.createCustomerSite(pao.id, CustomerSiteInput(name: 'Loja Centro', city: 'Porto Alegre', isActive: true));
  await g.createCustomerSite(pao.id, CustomerSiteInput(name: 'Loja Praia', isActive: true));
  await g.createCustomer(CustomerInput(name: 'Mercado Bom Preço', personType: 'company', isActive: true));
  g.currentAsset = Asset.fromJson(FakeGateway.asset1.toJson()..['status'] = 'in_stock');
  return g;
}

/// Tela alta: a ficha do bem é longa e a lista só monta o que aparece.
Future<void> pumpTall(WidgetTester tester, FakeGateway gateway) async {
  await pumpApp(tester, gateway);
  tester.view.physicalSize = const Size(1400, 2400);
  await tester.pumpAndSettle();
}

Future<void> openAsset(WidgetTester tester, FakeGateway gateway) async {
  await pumpTall(tester, gateway);
  await login(tester);
  await tester.tap(find.text('Bens'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('PAT-001'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('instalar no cliente, transferir de unidade e retirar', (tester) async {
    final gateway = await seeded();
    await openAsset(tester, gateway);
    expect(find.text('No estoque'), findsOneWidget);
    expect(find.text('Nunca foi instalado em cliente.'), findsOneWidget);
    expect(find.byKey(const Key('asset-withdraw')), findsNothing);

    await tapKey(tester, 'asset-install');
    expect(find.text('Mercado Bom Preço'), findsOneWidget);
    await tester.tap(find.text('Pão Quente'));
    await tester.pumpAndSettle();
    await tapKey(tester, 'install-save');
    expect(find.text('Escolha a unidade.'), findsOneWidget);
    await tester.tap(find.byKey(const Key('install-site')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Loja Centro · Porto Alegre').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('install-doc-type')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('NF de remessa').last);
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('install-doc-number')), '1234');
    await tapKey(tester, 'install-save');

    expect(gateway.lastInstall!.sourceDocumentType, 'shipment_invoice');
    expect(find.text('Pão Quente · Loja Centro'), findsWidgets);
    expect(find.textContaining('Instalação em'), findsOneWidget);
    expect(find.textContaining('NF de remessa 1234'), findsOneWidget);

    await tapKey(tester, 'asset-install');
    expect(find.textContaining('Hoje em: Pão Quente · Loja Centro'), findsOneWidget);
    await tester.tap(find.text('Pão Quente'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('install-site')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Loja Praia').last);
    await tester.pumpAndSettle();
    await tapKey(tester, 'install-save');
    expect(find.textContaining('Transferência em'), findsOneWidget);
    expect(find.textContaining('Transferido em'), findsOneWidget);

    await tapKey(tester, 'asset-withdraw');
    await tapKey(tester, 'withdraw-return_to_stock');
    await tester.enterText(find.byKey(const Key('withdraw-notes')), 'Fim do contrato');
    await tapKey(tester, 'withdraw-save');
    expect(find.text('No estoque'), findsOneWidget);
    expect(find.textContaining('Devolvido ao estoque em'), findsOneWidget);
    expect(gateway.assignmentList.first.endReason, 'return_to_stock');
  });

  testWidgets('cliente sem unidade não deixa instalar; erro do servidor aparece', (tester) async {
    final gateway = await seeded()
      ..failNext['installAsset'] = const GatewayException(
        'Bem inativo não pode ser instalado.',
        code: 'ASSET_INACTIVE',
      );
    await openAsset(tester, gateway);
    await tapKey(tester, 'asset-install');
    await tester.tap(find.text('Mercado Bom Preço'));
    await tester.pumpAndSettle();
    expect(find.textContaining('não tem unidade ativa'), findsOneWidget);
    await tapKey(tester, 'install-change-customer');
    await tester.tap(find.text('Pão Quente'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('install-site')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Loja Praia').last);
    await tester.pumpAndSettle();
    await tapKey(tester, 'install-save');
    expect(find.text('Bem inativo não pode ser instalado.'), findsOneWidget);
  });

  testWidgets('ficha do cliente lista os bens instalados', (tester) async {
    final gateway = await seeded();
    final site = gateway.siteList.first;
    await gateway.installAsset(gateway.currentAsset, AssetInstallInput(customerSiteId: site.id));
    await pumpTall(tester, gateway);
    await login(tester);
    await tester.tap(find.text('Clientes'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pão Quente'));
    await tester.pumpAndSettle();
    expect(find.text('PAT-001 · Freezer horizontal'), findsOneWidget);
    await tester.tap(find.text('PAT-001 · Freezer horizontal'));
    await tester.pumpAndSettle();
    expect(find.text('Pão Quente · Loja Centro'), findsWidgets);
  });
}
