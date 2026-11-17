import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_field/src/api/gateway.dart';

import 'app_test.dart';
import 'fake_gateway.dart';

Future<void> openVisit(WidgetTester tester, FakeGateway gateway, {FakeDevice? device, int n = 1}) async {
  await pumpApp(tester, gateway, device: device);
  await login(tester);
  await tester.tap(find.text('OS 2026-00000$n'));
  await tester.pumpAndSettle();
}

Future<void> tapKey(WidgetTester tester, String key) async {
  await tester.tap(find.byKey(Key(key)));
  await tester.pumpAndSettle();
}

Future<void> back(WidgetTester tester) async {
  await tester.tap(find.byType(BackButton));
  await tester.pumpAndSettle();
}

void main() {
  testApp('ciclo completo online: cada ação vai para o servidor na ordem', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    final device = FakeDevice()..qr = FakeGateway.assetQr;
    await openVisit(tester, gateway, device: device);
    expect(find.text('Agendada'), findsOneWidget);

    await tapKey(tester, 'act-travel');
    expect(find.text('A caminho'), findsOneWidget);
    expect(find.text('Situação da OS: Em atendimento'), findsOneWidget);

    await tapKey(tester, 'act-checkin');
    await tapKey(tester, 'checkin-qr');
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
    expect(find.text('Situação da OS: Concluída'), findsOneWidget);
    expect(find.text('Troca do termostato'), findsOneWidget);
    expect(find.byKey(const Key('act-finish')), findsNothing);
    expect(find.byKey(const Key('pending-badge')), findsNothing);

    expect(gateway.pushed.map((m) => m.type), [
      'visit.start_travel',
      'visit.check_in',
      'visit.pause',
      'visit.resume',
      'visit.finish',
    ]);
    expect(gateway.visitNumber(1).status, 'finished');
    expect(gateway.visitNumber(1).outcome, 'resolved');

    await back(tester);
    expect(find.text('Finalizada'), findsOneWidget);
  });

  testApp('sem sinal: ações ficam no aparelho e vão quando a conexão volta', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    await openVisit(tester, gateway);
    gateway.offline = true;

    await tapKey(tester, 'act-travel');
    await tapKey(tester, 'act-checkin');
    await tapKey(tester, 'checkin-manual');
    await tester.enterText(find.byKey(const Key('dialog-text')), 'Sem sinal no subsolo');
    await tapKey(tester, 'dialog-ok');
    expect(find.text('No local'), findsOneWidget);
    expect(find.byKey(const Key('pending-badge')), findsOneWidget);
    expect(gateway.visitNumber(1).status, 'scheduled');

    await tapKey(tester, 'sync-button');
    expect(find.text('2 ações aguardando envio.'), findsOneWidget);
    expect(find.textContaining('Sem conexão'), findsOneWidget);

    gateway.offline = false;
    await tapKey(tester, 'sync-now');
    expect(find.text('Tudo enviado.'), findsOneWidget);
    expect(gateway.visitNumber(1).status, 'on_site');
    expect(gateway.visitNumber(1).checkInJustification, 'Sem sinal no subsolo');
  });

  testApp('resposta perdida: o reenvio não aplica de novo', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    await openVisit(tester, gateway);
    gateway.dropNextPushResponse = true;
    await tapKey(tester, 'act-travel');
    expect(gateway.visitNumber(1).status, 'en_route');
    expect(find.byKey(const Key('pending-badge')), findsOneWidget);
    final version = gateway.visitNumber(1).version;

    await tapKey(tester, 'sync-button');
    await tapKey(tester, 'sync-now');
    expect(find.text('Tudo enviado.'), findsOneWidget);
    expect(gateway.pushed, hasLength(2));
    expect(gateway.pushed[0].mutationId, gateway.pushed[1].mutationId);
    expect(gateway.visitNumber(1).version, version);
  });

  testApp('QR de outro bem: o servidor recusa, a visita volta e o aviso aparece', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    await openVisit(tester, gateway, device: FakeDevice()..qr = 'https://qr.example/q/OUTRO');
    await tapKey(tester, 'act-checkin');
    await tapKey(tester, 'checkin-qr');
    expect(find.text('Agendada'), findsOneWidget);
    expect(gateway.visitNumber(1).status, 'scheduled');

    await back(tester);
    expect(find.text('OS 2026-000001: A etiqueta lida não é do bem desta OS.'), findsOneWidget);
    await tapKey(tester, 'notices-ok');
    expect(find.byKey(const Key('notices')), findsNothing);
  });

  testApp('visita cancelada enquanto estava sem sinal: conflito e aviso', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    await openVisit(tester, gateway);
    gateway.offline = true;
    await tapKey(tester, 'act-travel');
    expect(find.text('A caminho'), findsOneWidget);
    gateway.cancelVisit(1);
    gateway.offline = false;

    await back(tester);
    await tapKey(tester, 'sync-button');
    await tapKey(tester, 'sync-now');
    await tester.tapAt(const Offset(200, 100));
    await tester.pumpAndSettle();
    expect(find.text('OS 2026-000001: Esta visita foi cancelada pelo despacho.'), findsOneWidget);
    expect(find.text('OS 2026-000001'), findsNothing);
  });

  testApp('leitor fechado sem ler não grava nada', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    await openVisit(tester, gateway);
    await tapKey(tester, 'act-checkin');
    await tapKey(tester, 'checkin-qr');
    expect(gateway.pushed, isEmpty);
    expect(find.text('Agendada'), findsOneWidget);
  });

  testApp('GPS em OS que pede QR pede justificativa já no aparelho', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9), requireQr: true);
    final device = FakeDevice();
    await openVisit(tester, gateway, device: device);
    await tapKey(tester, 'act-checkin');
    await tapKey(tester, 'checkin-gps');
    expect(device.positions, 1);
    expect(find.text('Check-in por GPS'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('dialog-text')), 'Etiqueta ilegível');
    await tapKey(tester, 'dialog-ok');
    expect(find.text('No local'), findsOneWidget);
    final sent = gateway.visitNumber(1);
    expect(sent.checkInMethod, 'gps');
    expect(sent.checkInJustification, 'Etiqueta ilegível');
  });

  testApp('sem permissão de GPS mostra a mensagem', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    final device = FakeDevice()..positionError = const GatewayException('Sem permissão de localização.');
    await openVisit(tester, gateway, device: device);
    await tapKey(tester, 'act-checkin');
    await tapKey(tester, 'checkin-gps');
    expect(find.text('Sem permissão de localização.'), findsOneWidget);
    expect(gateway.pushed, isEmpty);
  });

  testApp('check-in manual exige justificativa; OS sem bem não oferece QR', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9), asset: false);
    await openVisit(tester, gateway);
    await tapKey(tester, 'act-checkin');
    expect(find.byKey(const Key('checkin-qr')), findsNothing);
    await tapKey(tester, 'checkin-manual');
    await tapKey(tester, 'dialog-ok');
    expect(find.text('Preencha este campo.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('dialog-text')), 'Sem sinal no subsolo');
    await tapKey(tester, 'dialog-ok');
    expect(gateway.visitNumber(1).checkInMethod, 'manual');
    expect(find.text('No local'), findsOneWidget);
  });

  testApp('sem check-in, "não atendida" só oferece cliente ausente ou não executada', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9));
    await openVisit(tester, gateway);
    await tapKey(tester, 'act-not-done');
    expect(find.byKey(const Key('outcome-resolved')), findsNothing);
    expect(find.byKey(const Key('outcome-customer_absent')), findsOneWidget);
    await tapKey(tester, 'outcome-not_executed');
    await tapKey(tester, 'dialog-ok');
    expect(gateway.visitNumber(1).outcome, 'not_executed');
    expect(find.text('Finalizada'), findsOneWidget);
    expect(find.text('Situação da OS: Aberta'), findsOneWidget);
  });

  testApp('precisa de retorno envia o motivo', (tester) async {
    final gateway = FakeGateway()..addVisit(1, DateTime(2026, 11, 17, 9), status: 'on_site');
    await openVisit(tester, gateway);
    await tapKey(tester, 'act-finish');
    await tapKey(tester, 'outcome-needs_return');
    expect(find.byKey(const Key('hold-reason')), findsOneWidget);
    await tapKey(tester, 'dialog-ok');
    expect(gateway.visitNumber(1).outcome, 'needs_return');
    expect(find.text('Situação da OS: Pendente'), findsOneWidget);
  });

  testApp('outra visita em andamento: o aparelho já barra', (tester) async {
    final gateway = FakeGateway()
      ..addVisit(1, DateTime(2026, 11, 17, 9))
      ..addVisit(2, DateTime(2026, 11, 17, 8), status: 'on_site');
    await openVisit(tester, gateway);
    await tapKey(tester, 'act-travel');
    expect(find.text('Você tem outra visita em andamento; finalize ou pause antes.'), findsOneWidget);
    expect(find.text('Agendada'), findsOneWidget);
    expect(gateway.pushed, isEmpty);
  });
}
