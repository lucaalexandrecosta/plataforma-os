import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_field/src/api/gateway.dart';
import 'package:plataforma_os_field/src/local/database.dart';
import 'package:plataforma_os_field/src/local/field_store.dart';
import 'package:plataforma_os_field/src/local/visit_rules.dart';

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
}
