import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_backoffice/src/api/gateway.dart';
import 'package:plataforma_os_backoffice/src/labels.dart';

import 'app_test.dart' show login, pumpApp;
import 'fake_gateway.dart';

void main() {
  testWidgets('ficha do bem: configura com taxa e residual e mostra a memória', (tester) async {
    final gateway = FakeGateway();
    await pumpApp(tester, gateway);
    await login(tester);
    await tester.tap(find.text('Bens'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PAT-001'));
    await tester.pumpAndSettle();
    expect(find.text('Este bem ainda não tem ficha de depreciação.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('dep-edit')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('dep-rate')), '10');
    await tester.enterText(find.byKey(const Key('dep-residual')), '12,3');
    await tester.tap(find.byKey(const Key('dep-save')));
    await tester.pumpAndSettle();

    final input = gateway.lastProfileInput!;
    expect(input.method, 'straight_line');
    expect(input.annualRate, '10');
    expect(input.residualValue, 1230);
    expect(input.depreciableCost, isNull);
    expect(gateway.lastProfileVersion, isNull);
    expect(find.text('10%'), findsOneWidget);
    expect(find.text(r'R$ 1.234,56'), findsWidgets);

    // A barra "Ficha salva" cobre o botão até sumir.
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    await tester.dragUntilVisible(
      find.byKey(const Key('dep-schedule')),
      find.byType(ListView).last,
      const Offset(0, -200),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('dep-schedule')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('dep-schedule')), findsNothing);
    await tester.dragUntilVisible(find.text('01/2026'), find.byType(ListView).last, const Offset(0, -200));
    expect(find.text('01/2026'), findsOneWidget);
    expect(find.text(r'R$ 1.224,27'), findsOneWidget);
  });

  testWidgets('valor inválido na base não chega ao servidor', (tester) async {
    final gateway = FakeGateway();
    await pumpApp(tester, gateway);
    await login(tester);
    await tester.tap(find.text('Bens'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PAT-001'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('dep-edit')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('dep-rate')), '10');
    await tester.enterText(find.byKey(const Key('dep-cost')), 'abc');
    await tester.tap(find.byKey(const Key('dep-save')));
    await tester.pumpAndSettle();
    expect(find.text('Valor inválido (ex.: 1.234,56).'), findsOneWidget);
    expect(gateway.lastProfileInput, isNull);
  });

  testWidgets('posição do mês: totais, visões e fechar/reabrir', (tester) async {
    final gateway = FakeGateway();
    await pumpApp(tester, gateway);
    await login(tester);
    await tester.tap(find.text('Depreciação'));
    await tester.pumpAndSettle();
    final now = DateTime.now();
    expect(find.text(competence(now.year, now.month)), findsOneWidget);
    expect(find.text('Aberta (cálculo do momento)'), findsOneWidget);
    expect(find.byKey(const Key('dep-total-month')), findsOneWidget);
    expect(find.text(r'R$ 10,29'), findsWidgets);
    expect(find.text('PAT-001'), findsOneWidget);

    await tester.tap(find.text('Por centro de custo'));
    await tester.pumpAndSettle();
    expect(find.text('1.01 · Produção'), findsOneWidget);

    await tester.tap(find.byKey(const Key('dep-close')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('dep-close-confirm')));
    await tester.pumpAndSettle();
    expect(find.text('Fechada'), findsOneWidget);
    expect(find.textContaining('fechada · 1 bens'), findsOneWidget);

    await tester.tap(find.byKey(const Key('dep-reopen')));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('note')), 'Taxa errada');
    await tester.tap(find.byKey(const Key('reason-confirm')));
    await tester.pumpAndSettle();
    expect(find.text('Aberta (cálculo do momento)'), findsOneWidget);
    expect(find.textContaining('"Taxa errada"'), findsOneWidget);
  });

  testWidgets('erro de negócio no fechamento aparece na barra', (tester) async {
    final gateway = FakeGateway()
      ..failNext['closeDepreciation'] = const GatewayException(
        'Feche as competências anteriores primeiro.',
        code: 'PERIOD_OUT_OF_ORDER',
      );
    await pumpApp(tester, gateway);
    await login(tester);
    await tester.tap(find.text('Depreciação'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('dep-close')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('dep-close-confirm')));
    await tester.pumpAndSettle();
    expect(find.text('Feche as competências anteriores primeiro.'), findsOneWidget);
  });

  testWidgets('sem depreciation.read: sem menu nem cartão no bem', (tester) async {
    final gateway = FakeGateway(permissions: const ['work_orders.read']);
    await pumpApp(tester, gateway);
    await login(tester);
    expect(find.text('Depreciação'), findsNothing);
    await tester.tap(find.text('Bens'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('PAT-001'));
    await tester.pumpAndSettle();
    expect(find.text('Depreciação gerencial'), findsNothing);
  });
}
