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

Future<void> openUsers(WidgetTester tester, FakeGateway gateway) async {
  await pumpApp(tester, gateway);
  await login(tester);
  await tester.tap(find.text('Usuários'));
  await tester.pumpAndSettle();
}

Finder cell(String text) => find.descendant(of: find.byType(DataTable), matching: find.text(text));

void main() {
  testWidgets('lista com perfis pelo nome e convite com perfil obrigatório', (tester) async {
    final gateway = FakeGateway();
    await openUsers(tester, gateway);
    expect(cell('Ana Admin'), findsOneWidget);
    expect(find.text('Despacho'), findsOneWidget);
    expect(find.text('17/11/2026 09:30'), findsOneWidget);

    await tapKey(tester, 'user-invite');
    await tester.enterText(find.byKey(const Key('invite-name')), 'Carla Técnica');
    await tester.enterText(find.byKey(const Key('invite-email')), 'carla@frio-sul.test');
    await tapKey(tester, 'invite-save');
    expect(find.text('Escolha ao menos um perfil.'), findsOneWidget);
    expect(gateway.calls, isNot(contains('inviteUser')));

    await tapKey(tester, 'role-technician');
    await tapKey(tester, 'invite-save');
    expect(gateway.lastInviteRoles, ['technician']);
    expect(find.text('Carla Técnica'), findsOneWidget);
    expect(find.text('Convidado (falta o primeiro acesso)'), findsOneWidget);
  });

  testWidgets('convite: reenviar o e-mail; e-mail que falha deixa o convite salvo', (tester) async {
    final gateway = FakeGateway()..inviteEmailFails = true;
    await openUsers(tester, gateway);
    await tapKey(tester, 'user-invite');
    await tester.enterText(find.byKey(const Key('invite-name')), 'Carla Técnica');
    await tester.enterText(find.byKey(const Key('invite-email')), 'carla@frio-sul.test');
    await tapKey(tester, 'role-technician');
    await tapKey(tester, 'invite-save');
    expect(find.textContaining('o e-mail não saiu'), findsOneWidget);
    expect(find.byKey(const Key('invite-save')), findsNothing);
    expect(cell('Carla Técnica'), findsOneWidget);

    await tester.tap(cell('Carla Técnica'));
    await tester.pumpAndSettle();
    await tapKey(tester, 'user-resend-invite');
    expect(gateway.resentInvites, ['carla@frio-sul.test']);

    // Quem já entrou não tem convite pendente.
    await tester.tap(find.text('Bruno Despacho'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('user-resend-invite')), findsNothing);
  });

  testWidgets('trocar perfis, suspender, reativar e remover com confirmação', (tester) async {
    final gateway = FakeGateway();
    await openUsers(tester, gateway);

    await tester.tap(find.text('Bruno Despacho'));
    await tester.pumpAndSettle();
    await tapKey(tester, 'role-technician');
    await tapKey(tester, 'user-save');
    expect(gateway.userList[1].roles, ['dispatcher', 'technician']);
    expect(find.text('Despacho, Técnico'), findsOneWidget);

    await tester.tap(find.text('Bruno Despacho'));
    await tester.pumpAndSettle();
    await tapKey(tester, 'user-suspend');
    expect(find.text('Suspenso'), findsOneWidget);

    await tester.tap(find.text('Bruno Despacho'));
    await tester.pumpAndSettle();
    await tapKey(tester, 'user-reactivate');
    expect(gateway.userList[1].status, MembershipStatus.active);

    await tester.tap(find.text('Bruno Despacho'));
    await tester.pumpAndSettle();
    await tapKey(tester, 'user-remove');
    await tapKey(tester, 'confirm-remove');
    expect(find.text('Bruno Despacho'), findsNothing);
  });

  testWidgets('o próprio acesso não tem ações; erro do servidor aparece', (tester) async {
    final gateway = FakeGateway()
      ..failNext['suspendUser'] = const GatewayException(
        'A empresa precisa de ao menos um administrador ativo.',
        code: 'LAST_TENANT_ADMIN',
      );
    await openUsers(tester, gateway);

    await tester.tap(cell('Ana Admin'));
    await tester.pumpAndSettle();
    expect(find.text('Este é o seu acesso. Peça a outro administrador para alterá-lo.'), findsOneWidget);
    expect(find.byKey(const Key('user-suspend')), findsNothing);
    await tester.tap(find.text('Fechar'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bruno Despacho'));
    await tester.pumpAndSettle();
    await tapKey(tester, 'user-suspend');
    expect(find.text('A empresa precisa de ao menos um administrador ativo.'), findsOneWidget);
    expect(gateway.userList[1].status, MembershipStatus.active);
  });

  testWidgets('sem users.manage o menu não mostra Usuários', (tester) async {
    final gateway = FakeGateway(permissions: const ['work_orders.read']);
    await pumpApp(tester, gateway);
    await login(tester);
    expect(find.text('Usuários'), findsNothing);
  });
}
