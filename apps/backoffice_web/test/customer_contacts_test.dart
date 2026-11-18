import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_backoffice/src/api/gateway.dart';
import 'package:plataforma_os_backoffice/src/ui/common/format.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import 'customers_test.dart' show openCustomers, tapKey;
import 'fake_gateway.dart';

Future<FakeGateway> seeded({List<String>? permissions}) async {
  final g = permissions == null ? FakeGateway() : FakeGateway(permissions: permissions);
  final c = await g.createCustomer(CustomerInput(name: 'Pão Quente Ltda', personType: 'company', isActive: true));
  await g.createCustomerSite(c.id, CustomerSiteInput(name: 'Loja Centro', isActive: true));
  return g;
}

Future<void> openDetail(WidgetTester tester, FakeGateway gateway) async {
  tester.view.physicalSize = const Size(1400, 2400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await openCustomers(tester, gateway);
  await tester.tap(find.text('Pão Quente Ltda').first);
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('cadastra contato com unidade e canal; edita e inativa', (tester) async {
    final gateway = await seeded();
    await openDetail(tester, gateway);
    expect(find.textContaining('Nenhum contato'), findsOneWidget);

    await tapKey(tester, 'contact-new');
    await tester.enterText(find.byKey(const Key('contact-name')), 'Marta');
    await tapKey(tester, 'contact-save');
    expect(find.text('Informe telefone ou e-mail.'), findsNWidgets(2));

    await tester.enterText(find.byKey(const Key('contact-phone')), '51 99999-8888');
    await tapKey(tester, 'contact-site');
    await tester.tap(find.text('Loja Centro').last);
    await tester.pumpAndSettle();
    await tapKey(tester, 'contact-channel');
    await tester.tap(find.text('WhatsApp').last);
    await tester.pumpAndSettle();
    await tapKey(tester, 'contact-save');

    final saved = gateway.contactList.single;
    expect(saved.phone, '+5551999998888');
    expect(saved.preferredChannel, 'whatsapp');
    expect(find.text('Marta'), findsOneWidget);
    expect(find.text('(51) 99999-8888 · Loja Centro · prefere WhatsApp'), findsOneWidget);

    await tester.tap(find.text('Marta'));
    await tester.pumpAndSettle();
    expect(find.text('Editar contato'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('contact-email')), 'marta@pao.test');
    await tapKey(tester, 'contact-active');
    await tapKey(tester, 'contact-save');
    expect(gateway.contactList.single.version, 2);
    expect(find.text('Marta (inativo)'), findsOneWidget);
  });

  testWidgets('erro do servidor aparece no campo', (tester) async {
    final gateway = await seeded();
    await openDetail(tester, gateway);
    gateway.failNext['createCustomerContact'] = const GatewayException(
      'Confira os campos.',
      code: 'VALIDATION_FAILED',
      fieldErrors: {'preferredChannel': 'Esse canal precisa de e-mail.'},
    );
    await tapKey(tester, 'contact-new');
    await tester.enterText(find.byKey(const Key('contact-name')), 'João');
    await tester.enterText(find.byKey(const Key('contact-phone')), '5133334444');
    await tapKey(tester, 'contact-save');
    expect(find.text('Esse canal precisa de e-mail.'), findsOneWidget);
    expect(gateway.contactList, isEmpty);
  });

  testWidgets('quem só lê não vê o botão de novo contato', (tester) async {
    final gateway = await seeded(permissions: const ['work_orders.read']);
    await openDetail(tester, gateway);
    expect(find.byKey(const Key('contact-new')), findsNothing);
  });

  test('telefone formatado', () {
    expect(formatPhone('+5551999998888'), '(51) 99999-8888');
    expect(formatPhone('+555133334444'), '(51) 3333-4444');
    expect(formatPhone('+541144445555'), '+541144445555');
  });
}
