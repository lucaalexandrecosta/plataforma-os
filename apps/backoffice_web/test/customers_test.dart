import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_backoffice/src/ui/common/format.dart';
import 'package:plataforma_os_backoffice/src/ui/customers/customer_dialogs.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import 'app_test.dart' show login, pumpApp;
import 'fake_gateway.dart';

Future<void> tapKey(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

Future<void> openCustomers(WidgetTester tester, FakeGateway gateway) async {
  await pumpApp(tester, gateway);
  await login(tester);
  await tester.tap(find.text('Clientes'));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('novo cliente (empresa) com CNPJ, abre a ficha e cadastra unidade', (tester) async {
    final gateway = FakeGateway();
    await openCustomers(tester, gateway);
    expect(find.text('Nenhum cliente encontrado.'), findsOneWidget);

    await tapKey(tester, 'customer-new');
    await tapKey(tester, 'customer-save');
    expect(find.text('Informe o nome.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('customer-name')), 'Sorveteria Gelato Ltda');
    await tester.enterText(find.byKey(const Key('customer-trade')), 'Gelato');
    await tester.enterText(find.byKey(const Key('customer-document')), '1144477700');
    await tapKey(tester, 'customer-save');
    expect(find.text('O CNPJ tem 14 dígitos.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('customer-document')), '11444777000161');
    await tapKey(tester, 'customer-save');

    expect(find.text('Gelato'), findsWidgets);
    expect(find.text('11.444.777/0001-61'), findsOneWidget);
    expect(find.textContaining('Nenhuma unidade'), findsOneWidget);

    await tapKey(tester, 'site-new');
    await tester.enterText(find.byKey(const Key('site-name')), 'Loja Centro');
    await tester.enterText(find.byKey(const Key('site-postal')), '90000000');
    await tester.enterText(find.byKey(const Key('site-street')), 'Rua A');
    await tester.enterText(find.byKey(const Key('site-city')), 'Porto Alegre');
    await tester.enterText(find.byKey(const Key('site-state')), 'rs');
    await tester.enterText(find.byKey(const Key('site-coords')), 'aqui');
    await tapKey(tester, 'site-save');
    expect(find.textContaining('Use "latitude, longitude"'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('site-coords')), '-30.0346, -51.2177');
    await tapKey(tester, 'site-save');

    final site = gateway.siteList.single;
    expect(site.state, 'RS');
    expect(site.latitude, -30.0346);
    expect(find.text('Loja Centro'), findsOneWidget);
    expect(find.text('Rua A · Porto Alegre/RS · CEP 90000-000'), findsOneWidget);

    await tester.tap(find.byTooltip('Voltar à lista'));
    await tester.pumpAndSettle();
    expect(find.text('Sorveteria Gelato Ltda'), findsOneWidget);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('pessoa física pede CPF; edição muda a versão e inativa', (tester) async {
    final gateway = FakeGateway();
    await gateway.createCustomer(CustomerInput(name: 'Joana Lima', personType: 'company', isActive: true));
    await openCustomers(tester, gateway);
    await tester.tap(find.text('Joana Lima').first);
    await tester.pumpAndSettle();

    await tapKey(tester, 'customer-edit');
    await tester.tap(find.text('Pessoa física'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('customer-document')), '12345678909');
    await tapKey(tester, 'customer-active');
    await tapKey(tester, 'customer-save');
    expect(find.text('123.456.789-09'), findsOneWidget);
    expect(find.text('Inativo'), findsOneWidget);
    expect(gateway.customerList.single.version, 2);
    expect(gateway.customerList.single.documentType, 'cpf');

    await tester.tap(find.byTooltip('Voltar à lista'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhum cliente encontrado.'), findsOneWidget);
    await tapKey(tester, 'customer-inactive');
    expect(find.text('Joana Lima'), findsWidgets);
  });

  testWidgets('quem só lê OS vê clientes sem botões de alterar', (tester) async {
    final gateway = FakeGateway(permissions: const ['work_orders.read']);
    await gateway.createCustomer(CustomerInput(name: 'Bom Preço', personType: 'company', isActive: true));
    await openCustomers(tester, gateway);
    expect(find.byKey(const Key('customer-new')), findsNothing);
    await tester.tap(find.text('Bom Preço').first);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('customer-edit')), findsNothing);
    expect(find.byKey(const Key('site-new')), findsNothing);
  });

  test('coordenadas e documentos', () {
    expect(CustomerSiteDialog.parseCoordsForTest('-30.03, -51.23'), (-30.03, -51.23));
    expect(CustomerSiteDialog.parseCoordsForTest('-30.03 -51.23'), (-30.03, -51.23));
    expect(CustomerSiteDialog.parseCoordsForTest('95, 10'), isNull);
    expect(formatDocument('12345678909'), '123.456.789-09');
    expect(formatCep('90000000'), '90000-000');
  });
}
