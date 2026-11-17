// Sync do app do técnico de ponta a ponta: registro do aparelho, pull do
// recorte, push em lote com horário do aparelho, reenvio idempotente,
// recusa com dependência, conflito de visita cancelada e isolamento.
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart.
@Tags(['e2e'])
library;

import 'dart:convert';

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

import 'support/e2e_login.dart';

void main() {
  late Client ana; // tenant_admin frio-sul
  late Client bruno; // dispatcher frio-sul
  late Client eduardo; // technician frio-sul (técnico T01), no app de campo
  late Client carla; // tenant_admin forno-norte
  late Technician t01;
  late Asset asset;
  late WorkOrderType corrective;
  final deviceId = UuidValue.fromString(const Uuid().v7());

  final now = DateTime.now().toUtc();
  final start = DateTime.utc(now.year, now.month, now.day, 12).add(const Duration(days: 2));

  UuidValue newId() => UuidValue.fromString(const Uuid().v7());

  SyncMutation mutation(
    String type,
    Visit visit, {
    DateTime? occurredAt,
    VisitCheckIn? checkIn,
    VisitFinish? finish,
    UuidValue? id,
  }) => SyncMutation(
    mutationId: id ?? newId(),
    type: type,
    entityId: visit.id,
    clientTimestamp: DateTime.now().toUtc(),
    payload: jsonEncode(VisitMutationPayload(occurredAt: occurredAt, checkIn: checkIn, finish: finish).toJson()),
  );

  Future<List<SyncMutationResult>> push(List<SyncMutation> mutations) =>
      eduardo.technicianSync.push(SyncPushRequest(deviceId: deviceId, appVersion: '0.1.0', mutations: mutations));

  Future<Visit> scheduled({int hour = 0}) async {
    final wo = (await bruno.workOrders.open(
      WorkOrderInput(workOrderTypeId: corrective.id, assetId: asset.id),
    )).workOrder;
    final s = start.add(Duration(hours: hour));
    return bruno.visits.schedule(
      wo.id,
      VisitInput(technicianId: t01.id, scheduledStart: s, scheduledEnd: s.add(const Duration(hours: 1))),
    );
  }

  setUpAll(() async {
    ana = await tenantClient('ana.admin@frio-sul.test', 'frio-sul');
    bruno = await tenantClient('bruno.despacho@frio-sul.test', 'frio-sul');
    eduardo = await tenantClient('eduardo.tecnico@frio-sul.test', 'frio-sul', technicianApp: true);
    carla = await tenantClient('carla.admin@forno-norte.test', 'forno-norte');
    t01 = (await bruno.technicians.list()).singleWhere((t) => t.code == 'T01');
    final product = (await ana.products.list()).first;
    asset = await ana.assets.create(
      AssetInput(productId: product.id, assetTag: 'PAT-SYNC-${DateTime.now().microsecondsSinceEpoch}', isActive: true),
    );
    corrective = (await bruno.workOrders.types()).singleWhere((t) => t.code == 'COR');

    // Outros testes podem ter deixado uma visita do T01 em andamento.
    for (final v in await eduardo.visits.mine(now.subtract(const Duration(days: 60)), now)) {
      if (const {'en_route', 'on_site', 'paused'}.contains(v.status)) {
        await eduardo.visits.finish(v.id, v.version, VisitFinish(outcome: 'not_executed'));
      }
    }
  });

  test('aparelho: precisa registrar antes do sync; despacho não registra', () async {
    await expectLater(eduardo.technicianSync.pull(deviceId), throwsApiError('DEVICE_NOT_REGISTERED'));
    await expectLater(
      bruno.technicianSync.registerDevice(DeviceRegistration(deviceId: newId(), platform: 'android')),
      throwsApiError('FORBIDDEN'),
    );
    await expectLater(
      eduardo.technicianSync.registerDevice(DeviceRegistration(deviceId: deviceId, platform: 'symbian')),
      throwsApiError('VALIDATION_FAILED'),
    );
    await eduardo.technicianSync.registerDevice(
      DeviceRegistration(deviceId: deviceId, platform: 'android', appVersion: '0.1.0', deviceModel: 'Pixel 8'),
    );
    // Registrar de novo atualiza.
    await eduardo.technicianSync.registerDevice(
      DeviceRegistration(deviceId: deviceId, platform: 'android', appVersion: '0.1.1'),
    );
  });

  test('pull traz as visitas do recorte com as OS', () async {
    final visit = await scheduled();
    final page = await eduardo.technicianSync.pull(deviceId);
    expect(page.visits.map((v) => v.id), contains(visit.id));
    expect(page.workOrders.map((w) => w.id), contains(visit.workOrderId));
    expect(page.scopeFrom.isBefore(page.serverTime), isTrue);
    expect(page.visits.every((v) => v.technicianId == t01.id), isTrue);
  });

  test('push em lote aplica na ordem, grava o horário do aparelho e reenvio é duplicate', () async {
    final visit = await scheduled(hour: 1);
    final travelAt = DateTime.now().toUtc().subtract(const Duration(minutes: 40));
    final checkInAt = travelAt.add(const Duration(minutes: 25));
    final batch = [
      mutation('visit.start_travel', visit, occurredAt: travelAt),
      mutation(
        'visit.check_in',
        visit,
        occurredAt: checkInAt,
        checkIn: VisitCheckIn(method: 'manual', justification: 'Sem sinal no subsolo'),
      ),
      mutation('visit.pause', visit),
      mutation('visit.resume', visit),
      mutation(
        'visit.finish',
        visit,
        finish: VisitFinish(outcome: 'resolved', notes: 'Troca do termostato'),
      ),
    ];
    final results = await push(batch);
    expect(results.map((r) => r.status), everyElement('applied'), reason: '${results.map((r) => r.errorCode)}');
    expect(results.map((r) => r.mutationId), batch.map((m) => m.mutationId));
    final last = results.last.visit!;
    expect(last.status, 'finished');
    expect(last.outcome, 'resolved');
    expect(last.travelStartedAt!.difference(travelAt).inSeconds.abs(), lessThan(2));
    expect(last.checkedInAt!.difference(checkInAt).inSeconds.abs(), lessThan(2));
    final wo = (await bruno.workOrders.get(visit.workOrderId)).workOrder;
    expect(const {'completed', 'closed'}, contains(wo.status));

    // Reenvio do mesmo lote (resposta perdida): nada é reaplicado.
    final again = await push(batch);
    expect(again.map((r) => r.status), everyElement('duplicate'));
    expect((await bruno.visits.get(visit.id)).version, last.version);
  });

  test('recusa derruba as seguintes da mesma visita; outra visita do lote segue', () async {
    final a = await scheduled(hour: 2);
    final b = await scheduled(hour: 3);
    final results = await push([
      mutation('visit.check_in', a, checkIn: VisitCheckIn(method: 'manual')), // sem justificativa
      mutation('visit.pause', a),
      mutation('visit.start_travel', b),
      mutation('visit.finish', b, finish: VisitFinish(outcome: 'customer_absent')),
      mutation('visit.unknown', a),
    ]);
    expect(results.map((r) => r.status), ['rejected', 'rejected', 'applied', 'applied', 'rejected']);
    expect(results[0].errorCode, 'VALIDATION_FAILED');
    expect(results[0].errorMessage, 'Justifique o check-in manual.');
    expect(results[0].visit?.status, 'scheduled');
    expect(results[1].errorCode, 'DEPENDENCY_FAILED');
    expect(results[3].visit?.status, 'finished');

    // Recusada reenviada volta como estava (não vira duplicate).
    final first = mutation('visit.start_travel', a);
    final once = await push([first]);
    expect(once.single.status, 'applied');
    expect((await push([first])).single.status, 'duplicate');
    // Não deixa visita em andamento para os outros testes.
    final done = await push([mutation('visit.finish', a, finish: VisitFinish(outcome: 'not_executed'))]);
    expect(done.single.status, 'applied');
  });

  test('visita cancelada pelo despacho enquanto offline: conflito com o estado atual', () async {
    final visit = await scheduled(hour: 4);
    await bruno.visits.cancel(visit.id, visit.version, 'Cliente remarcou');
    final results = await push([mutation('visit.start_travel', visit)]);
    expect(results.single.status, 'conflict');
    expect(results.single.errorCode, 'VISIT_CANCELLED');
    expect(results.single.visit?.status, 'cancelled');
  });

  test('isolamento: aparelho de outra empresa e lote grande', () async {
    await expectLater(carla.technicianSync.pull(deviceId), throwsApiError('FORBIDDEN'));
    final visit = await scheduled(hour: 5);
    await expectLater(
      push([for (var i = 0; i < 101; i++) mutation('visit.pause', visit)]),
      throwsApiError('VALIDATION_FAILED'),
    );
  });
}
