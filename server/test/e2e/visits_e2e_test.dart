// Visitas de ponta a ponta: cadastro de técnico, agenda do despacho, execução
// pelo técnico no app (deslocamento, check-in pelo QR do bem, pausa,
// finalização) e o efeito em cada passo no status da OS; retorno por falta de
// peça, cliente ausente, cancelamento, travas e isolamento.
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart.
@Tags(['e2e'])
library;

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:test/test.dart';

import 'support/e2e_login.dart';

void main() {
  late Client ana; // tenant_admin frio-sul
  late Client bruno; // dispatcher frio-sul
  late Client eduardo; // technician frio-sul (técnico T01), no app de campo
  late Client carla; // tenant_admin forno-norte
  late Technician t01;
  late Technician t02;
  late Asset asset;
  late QrTag tag;
  late QrTag otherTag;
  late WorkOrderType corrective;

  final day = DateTime.now().toUtc().add(const Duration(days: 1));
  final start = DateTime.utc(day.year, day.month, day.day, 13);
  final end = start.add(const Duration(hours: 2));
  final from = start.subtract(const Duration(days: 1));
  final to = start.add(const Duration(days: 1));

  Future<WorkOrder> newWorkOrder() async =>
      (await bruno.workOrders.open(WorkOrderInput(workOrderTypeId: corrective.id, assetId: asset.id))).workOrder;

  setUpAll(() async {
    ana = await tenantClient('ana.admin@frio-sul.test', 'frio-sul');
    bruno = await tenantClient('bruno.despacho@frio-sul.test', 'frio-sul');
    eduardo = await tenantClient('eduardo.tecnico@frio-sul.test', 'frio-sul', technicianApp: true);
    carla = await tenantClient('carla.admin@forno-norte.test', 'forno-norte');

    t01 = (await bruno.technicians.list()).singleWhere((t) => t.code == 'T01');
    final product = (await ana.products.list()).first;
    asset = await ana.assets.create(
      AssetInput(
        productId: product.id,
        assetTag: 'PAT-VIS-${DateTime.now().microsecondsSinceEpoch}',
        isActive: true,
      ),
    );
    final batch = await ana.qrTags.generateBatch(2);
    final tags = await ana.qrTags.batchTags(batch.id);
    tag = await ana.qrTags.bind(tags[0].shortCode, asset.id);
    otherTag = tags[1];
    corrective = (await bruno.workOrders.types()).singleWhere((t) => t.code == 'COR');
  });

  test('técnicos: cadastro, código único e o técnico do login', () async {
    final input = TechnicianInput(code: 't02', name: 'Fábio Técnico', phone: '+55 51 99999-0002', isActive: true);
    await expectLater(eduardo.technicians.create(input), throwsApiError('FORBIDDEN'));
    t02 = await bruno.technicians.create(input);
    expect(t02.code, 'T02');
    expect(t02.phone, '+5551999990002');
    await expectLater(bruno.technicians.create(input), throwsApiError('VALIDATION_FAILED'));
    await expectLater(
      bruno.technicians.create(
        input
          ..code = 'T03'
          ..phone = '123',
      ),
      throwsApiError('VALIDATION_FAILED'),
    );
    expect((await eduardo.technicians.mine())?.id, t01.id);
    expect(await bruno.technicians.mine(), isNull);
  });

  test('ciclo completo: agendar, deslocar, check-in pelo QR, pausar, finalizar resolvida, encerrar', () async {
    var wo = await newWorkOrder();
    final input = VisitInput(technicianId: t01.id, scheduledStart: start, scheduledEnd: end);
    await expectLater(eduardo.visits.schedule(wo.id, input), throwsApiError('FORBIDDEN'));
    await expectLater(
      bruno.visits.schedule(wo.id, VisitInput(technicianId: t01.id, scheduledStart: end, scheduledEnd: start)),
      throwsApiError('VALIDATION_FAILED'),
    );

    var visit = await bruno.visits.schedule(wo.id, input);
    expect(visit.visitNumber, 1);
    expect(visit.status, 'scheduled');
    expect(visit.workOrderStatus, 'scheduled');
    expect((await bruno.visits.agenda(from, to, technicianId: t01.id)).map((v) => v.id), contains(visit.id));
    expect((await eduardo.visits.mine(from, to)).map((v) => v.id), contains(visit.id));

    visit = await bruno.visits.reschedule(
      visit.id,
      visit.version,
      VisitInput(technicianId: t01.id, scheduledStart: start.add(const Duration(hours: 1)), scheduledEnd: end),
    );
    expect(visit.scheduledStart, start.add(const Duration(hours: 1)));

    visit = await eduardo.visits.startTravel(visit.id, visit.version);
    expect(visit.status, 'en_route');
    expect(visit.workOrderStatus, 'in_progress');

    // frio-sul exige QR no check-in: GPS sem justificativa não passa.
    await expectLater(
      eduardo.visits.checkIn(visit.id, visit.version, VisitCheckIn(method: 'gps', latitude: -30.03, longitude: -51.22)),
      throwsApiError('VALIDATION_FAILED'),
    );
    await expectLater(
      eduardo.visits.checkIn(visit.id, visit.version, VisitCheckIn(method: 'manual')),
      throwsApiError('VALIDATION_FAILED'),
    );
    await expectLater(
      eduardo.visits.checkIn(visit.id, visit.version, VisitCheckIn(method: 'qr', scannedCode: otherTag.shortCode)),
      throwsApiError('QR_ASSET_MISMATCH'),
    );
    visit = await eduardo.visits.checkIn(visit.id, visit.version, VisitCheckIn(method: 'qr', scannedCode: tag.url));
    expect(visit.status, 'on_site');
    expect(visit.checkInMethod, 'qr');
    expect(visit.checkedInAt, isNotNull);

    visit = await eduardo.visits.pause(visit.id, visit.version);
    expect(visit.status, 'paused');
    visit = await eduardo.visits.resume(visit.id, visit.version);
    expect(visit.status, 'on_site');

    await expectLater(
      bruno.workOrders.cancel(wo.id, (await bruno.workOrders.get(wo.id)).workOrder.version, 'created_in_error'),
      throwsApiError('VISIT_IN_PROGRESS'),
    );
    await expectLater(
      eduardo.visits.finish(visit.id, visit.version, VisitFinish(outcome: 'resolved')),
      throwsApiError('VALIDATION_FAILED'),
    );
    visit = await eduardo.visits.finish(
      visit.id,
      visit.version,
      VisitFinish(outcome: 'resolved', notes: 'Troca do termostato'),
    );
    expect(visit.status, 'finished');
    expect(visit.outcome, 'resolved');
    expect(visit.workOrderStatus, 'completed');
    await expectLater(
      eduardo.visits.finish(visit.id, visit.version, VisitFinish(outcome: 'resolved', notes: 'de novo')),
      throwsApiError('INVALID_TRANSITION'),
    );

    wo = (await bruno.workOrders.get(wo.id)).workOrder;
    expect(wo.resolutionNotes, 'Troca do termostato');
    expect(wo.startedAt, isNotNull);
    wo = await bruno.workOrders.close(wo.id, wo.version);
    expect(wo.status, 'closed');
    final history = (await bruno.workOrders.get(wo.id)).history.map((h) => h.toStatus);
    expect(history, ['open', 'scheduled', 'in_progress', 'completed', 'closed']);
  });

  test('retorno por falta de peça, segunda visita com GPS justificado e conclusão', () async {
    final wo = await newWorkOrder();
    var first = await bruno.visits.schedule(
      wo.id,
      VisitInput(technicianId: t01.id, scheduledStart: start, scheduledEnd: end),
    );
    first = await eduardo.visits.checkIn(
      first.id,
      first.version,
      VisitCheckIn(method: 'qr', scannedCode: tag.shortCode),
    );
    expect(first.workOrderStatus, 'in_progress');
    first = await eduardo.visits.finish(
      first.id,
      first.version,
      VisitFinish(outcome: 'needs_return', holdReason: 'awaiting_part', notes: 'Falta compressor'),
    );
    expect(first.workOrderStatus, 'on_hold');
    expect((await bruno.workOrders.get(wo.id)).workOrder.holdReason, 'awaiting_part');

    var second = await bruno.visits.schedule(
      wo.id,
      VisitInput(technicianId: t01.id, scheduledStart: end, scheduledEnd: end.add(const Duration(hours: 1))),
    );
    expect(second.visitNumber, 2);
    expect(second.workOrderStatus, 'scheduled');
    second = await eduardo.visits.checkIn(
      second.id,
      second.version,
      VisitCheckIn(method: 'gps', latitude: -30.03, longitude: -51.22, justification: 'Etiqueta coberta de gelo'),
    );
    expect(second.checkInMethod, 'gps');
    expect(second.checkInJustification, 'Etiqueta coberta de gelo');
    second = await eduardo.visits.finish(
      second.id,
      second.version,
      VisitFinish(outcome: 'resolved', notes: 'Compressor trocado'),
    );
    expect(second.workOrderStatus, 'completed');
    expect((await bruno.visits.ofWorkOrder(wo.id)).map((v) => v.outcome), ['needs_return', 'resolved']);
  });

  test('cliente ausente sem check-in, não executada e cancelamento devolvem a OS', () async {
    final wo = await newWorkOrder();
    var v1 = await bruno.visits.schedule(
      wo.id,
      VisitInput(technicianId: t01.id, scheduledStart: start, scheduledEnd: end),
    );
    await expectLater(
      eduardo.visits.finish(v1.id, v1.version, VisitFinish(outcome: 'resolved', notes: 'x')),
      throwsApiError('CHECK_IN_REQUIRED'),
    );
    v1 = await eduardo.visits.finish(v1.id, v1.version, VisitFinish(outcome: 'customer_absent'));
    expect(v1.workOrderStatus, 'on_hold');

    var v2 = await bruno.visits.schedule(
      wo.id,
      VisitInput(technicianId: t01.id, scheduledStart: start, scheduledEnd: end),
    );
    v2 = await eduardo.visits.startTravel(v2.id, v2.version);
    v2 = await eduardo.visits.finish(v2.id, v2.version, VisitFinish(outcome: 'not_executed', notes: 'Sem acesso'));
    expect(v2.workOrderStatus, 'open');

    var v3 = await bruno.visits.schedule(
      wo.id,
      VisitInput(technicianId: t02.id, scheduledStart: start, scheduledEnd: end),
    );
    expect(v3.technicianName, 'Fábio Técnico');
    await expectLater(eduardo.visits.startTravel(v3.id, v3.version), throwsApiError('NOT_FOUND'));
    await expectLater(bruno.visits.cancel(v3.id, v3.version, ' '), throwsApiError('VALIDATION_FAILED'));
    v3 = await bruno.visits.cancel(v3.id, v3.version, 'Técnico de férias');
    expect(v3.status, 'cancelled');
    expect(v3.workOrderStatus, 'open');
    await expectLater(
      bruno.visits.reschedule(
        v3.id,
        v3.version,
        VisitInput(technicianId: t01.id, scheduledStart: start, scheduledEnd: end),
      ),
      throwsApiError('VISIT_NOT_SCHEDULED'),
    );

    // Cancelar a OS cancela a visita ainda agendada.
    final v4 = await bruno.visits.schedule(
      wo.id,
      VisitInput(technicianId: t01.id, scheduledStart: start, scheduledEnd: end),
    );
    final current = (await bruno.workOrders.get(wo.id)).workOrder;
    final cancelled = await bruno.workOrders.cancel(current.id, current.version, 'created_in_error');
    expect(cancelled.status, 'cancelled');
    expect((await bruno.visits.get(v4.id)).status, 'cancelled');
    await expectLater(
      bruno.visits.schedule(wo.id, VisitInput(technicianId: t01.id, scheduledStart: start, scheduledEnd: end)),
      throwsApiError('WORK_ORDER_NOT_SCHEDULABLE'),
    );
  });

  test('uma visita em andamento por técnico; versão velha dá VERSION_MISMATCH', () async {
    final a = await newWorkOrder();
    final b = await newWorkOrder();
    var va = await bruno.visits.schedule(
      a.id,
      VisitInput(technicianId: t01.id, scheduledStart: start, scheduledEnd: end),
    );
    final vb = await bruno.visits.schedule(
      b.id,
      VisitInput(technicianId: t01.id, scheduledStart: end, scheduledEnd: to),
    );
    final stale = va.version;
    va = await eduardo.visits.startTravel(va.id, va.version);
    await expectLater(eduardo.visits.startTravel(vb.id, vb.version), throwsApiError('ANOTHER_VISIT_ACTIVE'));
    await expectLater(eduardo.visits.pause(va.id, stale), throwsApiError('VERSION_MISMATCH'));
    va = await eduardo.visits.finish(va.id, va.version, VisitFinish(outcome: 'not_executed'));
    await eduardo.visits.startTravel(vb.id, vb.version);
  });

  test('isolamento: outra empresa não vê nem agenda visitas', () async {
    final carlaTechs = await carla.technicians.list();
    expect(carlaTechs.map((t) => t.id), isNot(contains(t01.id)));
    expect((await carla.visits.agenda(from, to)).map((v) => v.technicianId), isNot(contains(t01.id)));
    final wo = await newWorkOrder();
    await expectLater(
      carla.visits.schedule(wo.id, VisitInput(technicianId: t01.id, scheduledStart: start, scheduledEnd: end)),
      throwsApiError('VALIDATION_FAILED'),
    );
  });
}
