import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_field/src/api/gateway.dart';
import 'package:plataforma_os_field/src/local/checklist_rules.dart';
import 'package:plataforma_os_field/src/local/database.dart';
import 'package:plataforma_os_field/src/local/field_store.dart';
import 'package:plataforma_os_field/src/local/visit_rules.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import 'fake_gateway.dart';

void main() {
  late FakeGateway gateway;
  late FieldStore store;

  setUp(() {
    gateway = FakeGateway()
      ..addVisit(1, DateTime(2026, 11, 17, 9))
      ..addVisit(2, DateTime(2026, 11, 18, 9));
    store = FieldStore(FieldDatabase(NativeDatabase.memory()), gateway, platform: 'android');
  });

  tearDown(() => store.close());

  test('primeiro sync registra o aparelho uma vez e baixa o recorte', () async {
    await store.sync();
    await store.sync();
    expect(gateway.registeredDevices, hasLength(1));
    expect((await store.watchVisits().first).map((v) => v.workOrderNumber), ['2026-000001', '2026-000002']);
    expect((await store.watchWorkOrder(gateway.visitNumber(1).workOrderId).first)?.requesterName, 'Carlos');
    expect(store.summary.lastSyncAt, isNotNull);
  });

  test('visita transferida pelo despacho sai da agenda com aviso', () async {
    await store.sync();
    final i = gateway.visits.indexWhere((v) => v.workOrderNumber == '2026-000002');
    gateway.visits[i] = gateway.visits[i].copyWith(technicianId: FakeGateway.fornoNorte.id);
    await store.sync();
    expect((await store.watchVisits().first).map((v) => v.workOrderNumber), ['2026-000001']);
    expect(store.summary.notices.single.message, 'A visita da OS 2026-000002 saiu da sua agenda pelo despacho.');
    await store.markNoticesRead();
    expect(store.summary.notices, isEmpty);
  });

  test('pull com ação pendente mantém o estado local por cima do servidor', () async {
    await store.sync();
    gateway.offline = true;
    final visit = (await store.watchVisits().first).first;
    await store.act(visit, VisitMutation.startTravel, VisitMutationPayload());
    await store.sync();
    expect(store.summary.pending, 1);
    expect(store.summary.error?.message, FakeGateway.offlineError.message);

    // Lote interrompido: o pull vem antes da confirmação e não pode desfazer
    // o "a caminho" que ainda não chegou ao servidor.
    gateway.offline = false;
    gateway.nextPushEmpty = true;
    await store.sync();
    expect(gateway.calls.last, 'pull');
    expect(store.summary.pending, 1);
    expect((await store.watchVisit(visit.id).first)?.status, 'en_route');
    expect(gateway.visitNumber(1).status, 'scheduled');

    await store.sync();
    expect(store.summary.pending, 0);
    expect(store.summary.error, isNull);
    expect(gateway.visitNumber(1).status, 'en_route');
  });

  test('ação inválida não entra na fila', () async {
    await store.sync();
    final visit = (await store.watchVisits().first).first;
    await expectLater(
      store.act(visit, VisitMutation.pause, VisitMutationPayload()),
      throwsA(isA<GatewayException>().having((e) => e.code, 'code', 'INVALID_TRANSITION')),
    );
    expect(store.summary.pending, 0);
  });

  group('checklist', () {
    final checkIn = VisitMutationPayload(
      checkIn: VisitCheckIn(method: 'manual', justification: 'Sem etiqueta'),
    );
    final resolved = VisitMutationPayload(
      finish: VisitFinish(outcome: 'resolved', notes: 'Feito'),
    );

    Future<Visit> onSite() async {
      gateway.addChecklist(1);
      await store.sync();
      final visit = (await store.watchVisits().first).first;
      return store.act(visit, VisitMutation.checkIn, checkIn);
    }

    Future<void> answer(UuidValue visitId, String key, String value) =>
        store.saveChecklistAnswer(visitId, ChecklistAnswer(itemKey: key, value: value));

    test('sem sinal: respostas e envio ficam no aparelho e concluem a visita', () async {
      final visit = await onSite();
      expect((await store.checklist(visit.id))!.missing.map((i) => i.key), ['temperatura', 'porta']);
      gateway.offline = true;

      await answer(visit.id, 'temperatura', '3,5');
      await expectLater(
        store.submitChecklist(visit),
        throwsA(isA<GatewayException>().having((e) => e.fieldErrors, 'fieldErrors', {'porta': 'Obrigatório.'})),
      );
      await expectLater(
        store.act(visit, VisitMutation.finish, resolved),
        throwsA(isA<GatewayException>().having((e) => e.code, 'code', 'CHECKLIST_REQUIRED')),
      );

      await answer(visit.id, 'porta', 'nok');
      await store.submitChecklist(visit);
      var state = (await store.checklist(visit.id))!;
      expect((state.submitted, state.pending), (true, true));
      expect(state.answers['temperatura']!.value, '3.5');
      final shown = await store.act(visit, VisitMutation.finish, resolved);
      expect(shown.status, 'finished');

      gateway.offline = false;
      await store.sync();
      expect(store.summary.pending, 0);
      expect(gateway.pushed.map((m) => m.type), ['visit.check_in', checklistSubmitType, 'visit.finish']);
      expect(gateway.visitNumber(1).status, 'finished');
      state = (await store.checklist(visit.id))!;
      expect((state.submitted, state.pending), (true, false));
      expect(await store.db.select(store.db.checklistDrafts).get(), isEmpty);
      expect({for (final a in state.answers.values) a.itemKey: a.value}, {'temperatura': '3.5', 'porta': 'nok'});
    });

    test('mexer depois do envio volta a rascunho; recusa do servidor reabre o checklist', () async {
      final visit = await onSite();
      await answer(visit.id, 'temperatura', '4');
      await answer(visit.id, 'porta', 'ok');
      await store.submitChecklist(visit);
      await store.sync();
      expect((await store.checklist(visit.id))!.submitted, isTrue);

      await answer(visit.id, 'obs', 'Limpeza feita');
      expect((await store.checklist(visit.id))!.submitted, isFalse);

      // O despacho troca o modelo da visita: o envio é recusado e vira aviso.
      gateway.checklists[visit.id] = gateway.checklists[visit.id]!.copyWith(
        template: FakeGateway.checklistTemplate.copyWith(
          id: UuidValue.fromString('00000000-0000-4000-8000-0000000000c2'),
        ),
      );
      await store.submitChecklist(visit);
      await store.sync();
      final state = (await store.checklist(visit.id))!;
      expect(store.summary.notices.single.message, 'OS 2026-000001: Este checklist não é o desta visita.');
      expect((state.submitted, state.pending), (false, false));
      expect(state.answers['obs']!.value, 'Limpeza feita');
    });

    test('antes do check-in o envio não entra na fila', () async {
      gateway.addChecklist(1);
      await store.sync();
      final visit = (await store.watchVisits().first).first;
      await answer(visit.id, 'temperatura', '4');
      await expectLater(
        store.submitChecklist(visit),
        throwsA(isA<GatewayException>().having((e) => e.code, 'code', 'CHECK_IN_REQUIRED')),
      );
      expect(store.summary.pending, 0);
      expect(await store.checklist((await store.watchVisits().first).last.id), isNull);
    });
  });
}
