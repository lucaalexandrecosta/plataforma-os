import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_backoffice/src/ui/common/format.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import 'app_test.dart' show login, pumpApp;
import 'fake_gateway.dart';

void main() {
  testWidgets('agendar visita pelo detalhe da OS; aparece na OS e na agenda do dia', (tester) async {
    final gateway = FakeGateway()..workOrderList.add(FakeGateway.sample());
    await pumpApp(tester, gateway);
    await login(tester);
    await tester.tap(find.text('2026-000001'));
    await tester.pumpAndSettle();
    expect(find.text('Nenhuma visita agendada.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('act-schedule')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('visit-save')));
    await tester.pumpAndSettle();
    expect(find.text('Escolha o técnico.'), findsOneWidget);

    await tester.tap(find.byKey(const Key('visit-technician')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('T01 · Eduardo Técnico').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('visit-save')));
    await tester.pumpAndSettle();

    final input = gateway.lastVisitInput!;
    final tomorrow = startOfDay(DateTime.now()).add(const Duration(days: 1));
    expect(input.scheduledStart, DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 8));
    expect(input.scheduledEnd, DateTime(tomorrow.year, tomorrow.month, tomorrow.day, 10));
    expect(find.text('Visita 1'), findsOneWidget);
    expect(find.text('Agendada'), findsWidgets);

    await tester.tap(find.text('Agenda'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Nenhuma visita no período'), findsOneWidget);
    await tester.tap(find.byTooltip('Próximo'));
    await tester.pumpAndSettle();
    expect(find.text('08:00–10:00'), findsOneWidget);
    expect(find.text('Eduardo Técnico · 1 visita(s)'), findsOneWidget);
  });

  testWidgets('agenda: semana, reagendar e desmarcar pelo menu da visita', (tester) async {
    final gateway = FakeGateway()..workOrderList.add(FakeGateway.sample(status: 'scheduled'));
    final today = startOfDay(DateTime.now());
    gateway.visitList.add(
      FakeGateway.sampleVisit(
        gateway.workOrderList.single,
        gateway.technicianList.single,
        today.add(const Duration(hours: 14)),
      ),
    );
    await pumpApp(tester, gateway);
    await login(tester);
    await tester.tap(find.text('Agenda'));
    await tester.pumpAndSettle();
    expect(find.text('14:00–16:00'), findsOneWidget);

    await tester.tap(find.text('Semana'));
    await tester.pumpAndSettle();
    expect(gateway.lastAgendaTo!.difference(gateway.lastAgendaFrom!).inDays, 7);
    expect(gateway.lastAgendaFrom!.weekday, DateTime.monday);
    expect(find.text(formatDay(today)), findsOneWidget);

    await tester.tap(find.byKey(const Key('visit-menu-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Reagendar'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('visit-save')));
    await tester.pumpAndSettle();
    expect(gateway.calls, contains('rescheduleVisit'));

    await tester.tap(find.byKey(const Key('visit-menu-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Desmarcar'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byKey(const Key('note')), 'Cliente pediu outra data');
    await tester.tap(find.byKey(const Key('reason-confirm')));
    await tester.pumpAndSettle();
    expect(gateway.lastVisitCancelReason, 'Cliente pediu outra data');
    expect(find.text('14:00–16:00'), findsNothing);
  });

  testWidgets('técnicos: cadastra um novo', (tester) async {
    final gateway = FakeGateway();
    await pumpApp(tester, gateway);
    await login(tester);
    await tester.tap(find.text('Técnicos'));
    await tester.pumpAndSettle();
    expect(find.text('Eduardo Técnico'), findsOneWidget);
    await tester.tap(find.byKey(const Key('tech-new')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('tech-save')));
    await tester.pumpAndSettle();
    expect(find.text('Informe o código.'), findsOneWidget);
    await tester.enterText(find.byKey(const Key('tech-code')), 'T02');
    await tester.enterText(find.byKey(const Key('tech-name')), 'Fabiana Campo');
    await tester.tap(find.byKey(const Key('tech-save')));
    await tester.pumpAndSettle();
    expect(find.text('Fabiana Campo'), findsOneWidget);
  });

  testWidgets('sem visits.schedule: sem menu Técnicos nem botão de agendar', (tester) async {
    final gateway = FakeGateway(permissions: const ['work_orders.read'])..workOrderList.add(FakeGateway.sample());
    await pumpApp(tester, gateway);
    await login(tester);
    expect(find.text('Técnicos'), findsNothing);
    await tester.tap(find.text('2026-000001'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('act-schedule')), findsNothing);
  });

  testWidgets('detalhe da OS mostra as respostas do checklist da visita', (tester) async {
    final wo = FakeGateway.sample();
    final visitId = UuidValue.fromString('00000000-0000-4000-8001-000000000001');
    final gateway = FakeGateway()
      ..workOrderList.add(wo)
      ..visitChecklistList.add(
        VisitChecklist(
          visitId: visitId,
          visitNumber: 1,
          template: ChecklistTemplate(
            id: UuidValue.fromString('00000000-0000-4000-8000-0000000000c1'),
            code: 'PREV-FZ',
            name: 'Preventiva freezer',
            templateVersion: 2,
            status: 'published',
            items: [
              ChecklistItem(key: 'temperatura', label: 'Temperatura', type: 'number', required: true, unit: '°C'),
              ChecklistItem(key: 'porta', label: 'Borracha da porta', type: 'ok_nok', required: true),
              ChecklistItem(key: 'obs', label: 'Observações', type: 'text', required: false),
            ],
            isActive: true,
            version: 3,
          ),
          response: ChecklistResponse(
            id: UuidValue.fromString('00000000-0000-4000-8002-000000000001'),
            workOrderId: wo.id,
            visitId: visitId,
            checklistTemplateId: UuidValue.fromString('00000000-0000-4000-8000-0000000000c1'),
            templateVersion: 2,
            status: 'submitted',
            answers: [
              ChecklistAnswer(itemKey: 'temperatura', value: '-18'),
              ChecklistAnswer(itemKey: 'porta', value: 'nok', note: 'Rasgada'),
            ],
            submittedAt: DateTime.utc(2026, 11, 17, 13),
            submittedByName: 'Eduardo Técnico',
            version: 1,
          ),
        ),
      );
    await pumpApp(tester, gateway);
    await login(tester);
    await tester.tap(find.text('2026-000001'));
    await tester.pumpAndSettle();

    expect(find.text('Checklist'), findsOneWidget);
    expect(find.text('Preventiva freezer (v2) · visita 1'), findsOneWidget);
    expect(find.textContaining('Enviado · '), findsOneWidget);
    expect(find.text('-18 °C'), findsOneWidget);
    expect(find.text('Não OK · Rasgada'), findsOneWidget);
    expect(find.text('Observações'), findsOneWidget);
  });
}
