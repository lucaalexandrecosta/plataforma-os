import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_backoffice/src/api/gateway.dart';
import 'package:plataforma_os_backoffice/src/app.dart';
import 'package:plataforma_os_backoffice/src/session/session.dart';

import 'fake_gateway.dart';

Future<void> pumpApp(WidgetTester tester, FakeGateway gateway, {List<Override> overrides = const []}) async {
  tester.view.physicalSize = const Size(1400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [gatewayProvider.overrideWithValue(gateway), ...overrides],
      child: const BackofficeApp(),
    ),
  );
  await tester.pumpAndSettle();
}

Future<void> login(WidgetTester tester, {String password = 'certa123'}) async {
  await tester.enterText(find.byKey(const Key('email')), 'ana@frio-sul.test');
  await tester.enterText(find.byKey(const Key('password')), password);
  await tester.tap(find.byKey(const Key('submit')));
  await tester.pumpAndSettle();
}

void main() {
  group('login', () {
    testWidgets('senha errada mostra a mensagem e fica no login', (tester) async {
      final gateway = FakeGateway();
      await pumpApp(tester, gateway);
      await login(tester, password: 'errada');
      expect(find.text('E-mail ou senha incorretos.'), findsOneWidget);
      expect(find.text('Ordens de serviço'), findsNothing);
    });

    testWidgets('com uma empresa só, entra direto na lista de OS', (tester) async {
      final gateway = FakeGateway()..workOrderList.add(FakeGateway.sample());
      await pumpApp(tester, gateway);
      await login(tester);
      expect(gateway.enteredSlug, 'frio-sul');
      expect(find.text('Frio Sul'), findsOneWidget);
      expect(find.text('2026-000001'), findsOneWidget);
      expect(find.text('Aberta'), findsOneWidget);
    });

    testWidgets('com duas empresas, escolhe e depois troca pelo menu', (tester) async {
      final gateway = FakeGateway(tenants: [FakeGateway.fornoNorte, FakeGateway.frioSul]);
      await pumpApp(tester, gateway);
      await login(tester);
      expect(find.text('Escolha a empresa'), findsOneWidget);
      await tester.tap(find.byKey(const Key('tenant-forno-norte')));
      await tester.pumpAndSettle();
      expect(gateway.enteredSlug, 'forno-norte');
      expect(find.text('Forno Norte'), findsOneWidget);

      await tester.tap(find.byKey(const Key('user-menu')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Trocar de empresa'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('tenant-frio-sul')));
      await tester.pumpAndSettle();
      expect(find.text('Frio Sul'), findsOneWidget);
    });

    testWidgets('primeiro acesso: código e senha nova, com a regra de senha', (tester) async {
      final gateway = FakeGateway();
      await pumpApp(tester, gateway);
      await tester.tap(find.text('Primeiro acesso'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('email')), 'ana@frio-sul.test');
      await tester.tap(find.byKey(const Key('submit')));
      await tester.pumpAndSettle();
      expect(gateway.calls, contains('startRegistration'));

      await tester.enterText(find.byKey(const Key('code')), '123456');
      await tester.enterText(find.byKey(const Key('password')), 'curta');
      await tester.enterText(find.byKey(const Key('confirm')), 'curta');
      await tester.tap(find.byKey(const Key('submit')));
      await tester.pumpAndSettle();
      expect(find.text('Use pelo menos 8 caracteres, com letras e números.'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('password')), 'Senha-nova-1');
      await tester.enterText(find.byKey(const Key('confirm')), 'Senha-nova-1');
      await tester.tap(find.byKey(const Key('submit')));
      await tester.pumpAndSettle();
      expect(gateway.calls, contains('finishRegistration'));
      expect(find.text('Ordens de serviço'), findsWidgets);
    });

    testWidgets('sessão vencida volta ao login com o aviso', (tester) async {
      final gateway = FakeGateway()..failNext['workOrders'] = const SessionLost();
      await pumpApp(tester, gateway);
      await login(tester);
      expect(find.byKey(const Key('login-notice')), findsOneWidget);
      expect(find.text('Sua sessão expirou. Entre de novo.'), findsOneWidget);
    });
  });

  group('OS', () {
    testWidgets('abre pela etiqueta e vai para o detalhe', (tester) async {
      final gateway = FakeGateway();
      await pumpApp(tester, gateway);
      await login(tester);
      await tester.tap(find.byKey(const Key('wo-open')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('wo-type')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('COR · Corretiva').last);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Código da etiqueta'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('wo-open-submit')));
      await tester.pumpAndSettle();
      expect(find.text('Este tipo de OS exige o bem.'), findsOneWidget);

      await tester.enterText(find.byKey(const Key('wo-tag')), 'abcd-2345');
      await tester.enterText(find.byKey(const Key('wo-problem')), 'Não gela');
      await tester.tap(find.byKey(const Key('wo-open-submit')));
      await tester.pumpAndSettle();
      expect(gateway.lastInput!.scannedCode, 'abcd-2345');
      expect(gateway.lastInput!.problemDescription, 'Não gela');
      expect(find.text('OS 2026-000001'), findsOneWidget);
    });

    testWidgets('ciclo no detalhe: iniciar, concluir, encerrar', (tester) async {
      final gateway = FakeGateway()..workOrderList.add(FakeGateway.sample());
      await pumpApp(tester, gateway);
      await login(tester);
      await tester.tap(find.text('2026-000001'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('act-cancel')), findsOneWidget);

      await tester.tap(find.byKey(const Key('act-start')));
      await tester.pumpAndSettle();
      expect(gateway.calls, contains('startWorkOrder'));
      expect(find.text('Em atendimento'), findsOneWidget);

      await tester.tap(find.byKey(const Key('act-complete')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('reason-confirm')));
      await tester.pumpAndSettle();
      expect(find.text('Preencha este campo.'), findsOneWidget);
      await tester.enterText(find.byKey(const Key('note')), 'Troca do relé');
      await tester.tap(find.byKey(const Key('reason-confirm')));
      await tester.pumpAndSettle();
      expect(find.text('Concluída'), findsOneWidget);

      await tester.tap(find.byKey(const Key('act-close')));
      await tester.pumpAndSettle();
      expect(find.text('Encerrada'), findsOneWidget);
      expect(find.byKey(const Key('act-reopen')), findsOneWidget);
    });

    testWidgets('cancelar pede motivo; versão velha avisa e recarrega', (tester) async {
      final gateway = FakeGateway()..workOrderList.add(FakeGateway.sample());
      await pumpApp(tester, gateway);
      await login(tester);
      await tester.tap(find.text('2026-000001'));
      await tester.pumpAndSettle();

      gateway.failNext['startWorkOrder'] = const GatewayException('Versão velha', code: 'VERSION_MISMATCH');
      await tester.tap(find.byKey(const Key('act-start')));
      await tester.pumpAndSettle();
      expect(find.textContaining('alterada por outra pessoa'), findsOneWidget);

      await tester.tap(find.byKey(const Key('act-cancel')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('reason')));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Aberta por engano').last);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('reason-confirm')));
      await tester.pumpAndSettle();
      expect(gateway.lastCancelReason, 'created_in_error');
      expect(find.text('Cancelada'), findsOneWidget);
    });

    testWidgets('só leitura: sem botão de abrir nem ações', (tester) async {
      final gateway = FakeGateway(permissions: const ['work_orders.read'])..workOrderList.add(FakeGateway.sample());
      await pumpApp(tester, gateway);
      await login(tester);
      expect(find.byKey(const Key('wo-open')), findsNothing);
      await tester.tap(find.text('2026-000001'));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('act-start')), findsNothing);
      expect(find.byKey(const Key('act-cancel')), findsNothing);
    });
  });

  testWidgets('bens: lista, ficha e OS do bem', (tester) async {
    final gateway = FakeGateway()..workOrderList.add(FakeGateway.sample());
    await pumpApp(tester, gateway);
    await login(tester);
    await tester.tap(find.text('Bens'));
    await tester.pumpAndSettle();
    expect(find.text('PAT-001'), findsOneWidget);
    await tester.tap(find.text('PAT-001'));
    await tester.pumpAndSettle();
    expect(find.text('R\$ 1.234,56'), findsOneWidget);
    expect(find.text('Próprio (comodato)'), findsOneWidget);
    expect(find.byKey(const Key('asset-open-wo')), findsOneWidget);
    // A ficha cresceu (histórico de alocação): a lista de OS fica mais abaixo.
    await tester.scrollUntilVisible(
      find.text('OS 2026-000001 · Corretiva'),
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(find.text('OS 2026-000001 · Corretiva'), findsOneWidget);
  });
}
