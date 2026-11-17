import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_field/src/api/gateway.dart';

import 'app_test.dart';
import 'fake_gateway.dart';

Future<void> openVisit(WidgetTester tester, FakeGateway gateway, {FakeDevice? device}) async {
  await pumpApp(tester, gateway, device: device);
  await login(tester);
  await tester.tap(find.text('OS 2026-000001'));
  await tester.pumpAndSettle();
}

Future<void> tapKey(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('ciclo completo: deslocamento, QR, pausa, retomada e finalização que conclui a OS', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    final device = FakeDevice()..qr = FakeGateway.assetQr;
    await openVisit(tester, gateway, device: device);
    expect(find.text('Agendada'), findsOneWidget);

    await tapKey(tester, 'act-travel');
    expect(find.text('A caminho'), findsOneWidget);
    expect(find.text('Situação da OS: Em atendimento'), findsOneWidget);

    await tapKey(tester, 'act-checkin');
    await tapKey(tester, 'checkin-qr');
    expect(gateway.lastCheckIn?.method, 'qr');
    expect(find.text('No local'), findsOneWidget);
    expect(find.textContaining('QR da etiqueta'), findsOneWidget);

    await tapKey(tester, 'act-pause');
    expect(find.text('Pausada'), findsOneWidget);
    await tapKey(tester, 'act-resume');
    expect(find.text('No local'), findsOneWidget);

    await tapKey(tester, 'act-finish');
    await tapKey(tester, 'dialog-ok');
    expect(find.text('Descreva o que foi feito.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('finish-notes')), 'Troca do termostato');
    await tapKey(tester, 'dialog-ok');
    expect(gateway.lastFinish?.outcome, 'resolved');
    expect(gateway.lastFinish?.notes, 'Troca do termostato');

    // O servidor conclui a OS; a visita finalizada não tem mais ações.
    expect(find.text('Situação da OS: Concluída'), findsOneWidget);
    expect(find.text('Troca do termostato'), findsOneWidget);
    expect(find.byKey(const Key('act-finish')), findsNothing);

    // De volta à agenda, a visita aparece finalizada.
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();
    expect(find.text('Finalizada'), findsOneWidget);
  });

  testWidgets('QR de outro bem mostra a recusa e não muda a visita', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    await openVisit(tester, gateway, device: FakeDevice()..qr = 'https://qr.example/q/OUTRO');
    await tapKey(tester, 'act-checkin');
    await tapKey(tester, 'checkin-qr');
    expect(find.text('A etiqueta lida não é do bem desta OS.'), findsOneWidget);
    expect(find.text('Agendada'), findsOneWidget);
  });

  testWidgets('leitor fechado sem ler não chama o servidor', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    await openVisit(tester, gateway);
    await tapKey(tester, 'act-checkin');
    await tapKey(tester, 'checkin-qr');
    expect(gateway.calls, isNot(contains('checkIn')));
  });

  testWidgets('GPS em OS que pede QR pede justificativa e tenta de novo', (tester) async {
    final gateway = FakeGateway()
      ..addVisit(1, DateTime(2026, 11, 17, 9))
      ..requireQr = true;
    final device = FakeDevice();
    await openVisit(tester, gateway, device: device);
    await tapKey(tester, 'act-checkin');
    await tapKey(tester, 'checkin-gps');
    expect(device.positions, 1);
    expect(find.text('Check-in por GPS'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('dialog-text')), 'Etiqueta ilegível');
    await tapKey(tester, 'dialog-ok');
    expect(gateway.lastCheckIn?.method, 'gps');
    expect(gateway.lastCheckIn?.justification, 'Etiqueta ilegível');
    expect(gateway.lastCheckIn?.accuracyM, 12.0);
    expect(find.text('No local'), findsOneWidget);
  });

  testWidgets('sem permissão de GPS mostra a mensagem', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    final device = FakeDevice()..positionError = const GatewayException('Sem permissão de localização.');
    await openVisit(tester, gateway, device: device);
    await tapKey(tester, 'act-checkin');
    await tapKey(tester, 'checkin-gps');
    expect(find.text('Sem permissão de localização.'), findsOneWidget);
    expect(gateway.calls, isNot(contains('checkIn')));
  });

  testWidgets('check-in manual exige justificativa; OS sem bem não oferece QR', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9), asset: false);
    await openVisit(tester, gateway);
    await tapKey(tester, 'act-checkin');
    expect(find.byKey(const Key('checkin-qr')), findsNothing);
    await tapKey(tester, 'checkin-manual');
    await tapKey(tester, 'dialog-ok');
    expect(find.text('Preencha este campo.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('dialog-text')), 'Sem sinal no subsolo');
    await tapKey(tester, 'dialog-ok');
    expect(gateway.lastCheckIn?.method, 'manual');
    expect(find.text('No local'), findsOneWidget);
  });

  testWidgets('sem check-in, "não atendida" só oferece cliente ausente ou não executada', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    await openVisit(tester, gateway);
    await tapKey(tester, 'act-not-done');
    expect(find.byKey(const Key('outcome-resolved')), findsNothing);
    expect(find.byKey(const Key('outcome-customer_absent')), findsOneWidget);
    await tapKey(tester, 'outcome-not_executed');
    await tapKey(tester, 'dialog-ok');
    expect(gateway.lastFinish?.outcome, 'not_executed');
    expect(find.text('Finalizada'), findsOneWidget);
    expect(find.text('Situação da OS: Aberta'), findsOneWidget);
  });

  testWidgets('precisa de retorno envia o motivo', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9), status: 'on_site');
    await openVisit(tester, gateway);
    await tapKey(tester, 'act-finish');
    await tapKey(tester, 'outcome-needs_return');
    expect(find.byKey(const Key('hold-reason')), findsOneWidget);
    await tapKey(tester, 'dialog-ok');
    expect(gateway.lastFinish?.outcome, 'needs_return');
    expect(gateway.lastFinish?.holdReason, 'awaiting_part');
    expect(find.text('Situação da OS: Pendente'), findsOneWidget);
  });

  testWidgets('visita alterada no escritório recarrega e avisa', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    await openVisit(tester, gateway);
    gateway.failNext['startTravel'] = const GatewayException('Alterada.', code: 'VERSION_MISMATCH');
    await tapKey(tester, 'act-travel');
    expect(find.textContaining('A visita mudou no escritório'), findsOneWidget);
    expect(gateway.calls.where((c) => c == 'visit').length, 2);
  });

  testWidgets('outra visita em andamento: mostra a regra do servidor', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    await openVisit(tester, gateway);
    gateway.failNext['startTravel'] = const GatewayException(
      'Você tem outra visita em andamento; finalize ou pause antes.',
      code: 'ANOTHER_VISIT_ACTIVE',
    );
    await tapKey(tester, 'act-travel');
    expect(find.text('Você tem outra visita em andamento; finalize ou pause antes.'), findsOneWidget);
    expect(find.text('Agendada'), findsOneWidget);
  });
}
