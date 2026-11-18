// Checklist da visita de ponta a ponta: o pacote do técnico traz o modelo,
// o envio offline (checklist_response.submit) valida tipos e obrigatórios,
// a visita só conclui como "resolvida" com o checklist enviado, o reenvio
// substitui as respostas e o backoffice lê o que foi respondido.
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
  late WorkOrderType type;
  late ChecklistTemplate template;
  final deviceId = UuidValue.fromString(const Uuid().v7());
  final suffix = DateTime.now().microsecondsSinceEpoch;

  final now = DateTime.now().toUtc();
  final start = DateTime.utc(now.year, now.month, now.day, 15).add(const Duration(days: 1));

  UuidValue newId() => UuidValue.fromString(const Uuid().v7());

  SyncMutation visitMutation(String type, Visit visit, {VisitCheckIn? checkIn, VisitFinish? finish}) => SyncMutation(
    mutationId: newId(),
    type: type,
    entityId: visit.id,
    clientTimestamp: DateTime.now().toUtc(),
    payload: jsonEncode(VisitMutationPayload(checkIn: checkIn, finish: finish).toJson()),
  );

  SyncMutation submit(Visit visit, ChecklistTemplate t, Map<String, String> answers, {UuidValue? id}) => SyncMutation(
    mutationId: id ?? newId(),
    type: 'checklist_response.submit',
    entityId: visit.id,
    clientTimestamp: DateTime.now().toUtc(),
    payload: jsonEncode(
      ChecklistSubmitPayload(
        checklistTemplateId: t.id,
        answers: [for (final e in answers.entries) ChecklistAnswer(itemKey: e.key, value: e.value)],
      ).toJson(),
    ),
  );

  Future<List<SyncMutationResult>> push(List<SyncMutation> mutations) =>
      eduardo.technicianSync.push(SyncPushRequest(deviceId: deviceId, appVersion: '0.3.0', mutations: mutations));

  final checkIn = VisitCheckIn(method: 'manual', justification: 'Etiqueta ilegível');

  Future<Visit> scheduled() async {
    final wo = (await bruno.workOrders.open(WorkOrderInput(workOrderTypeId: type.id, assetId: asset.id))).workOrder;
    return bruno.visits.schedule(
      wo.id,
      VisitInput(technicianId: t01.id, scheduledStart: start, scheduledEnd: start.add(const Duration(hours: 1))),
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
      AssetInput(productId: product.id, assetTag: 'PAT-CHK-$suffix', isActive: true),
    );
    final draft = await ana.checklists.create(
      ChecklistTemplateInput(
        code: 'CHK-$suffix',
        name: 'Preventiva balcão',
        items: [
          ChecklistItem(label: 'Temperatura', type: 'number', required: true, unit: '°C'),
          ChecklistItem(label: 'Porta veda?', type: 'ok_nok', required: true),
          ChecklistItem(label: 'Estado', type: 'choice', required: true, options: ['Bom', 'Ruim']),
          ChecklistItem(label: 'Observações', type: 'text', required: false),
        ],
      ),
    );
    template = await ana.checklists.publish(draft.id, draft.version);
    type = await ana.workOrders.createType(
      WorkOrderTypeInput(
        code: 'PCK${suffix % 100000}',
        name: 'Preventiva com checklist',
        category: 'preventive',
        defaultPriority: 'normal',
        requiresAsset: true,
        isActive: true,
        defaultChecklistTemplateId: template.id,
      ),
    );
    await eduardo.technicianSync.registerDevice(DeviceRegistration(deviceId: deviceId, platform: 'android'));

    // Outros testes podem ter deixado uma visita do T01 em andamento.
    for (final v in await eduardo.visits.mine(
      now.subtract(const Duration(days: 40)),
      now.add(const Duration(days: 20)),
    )) {
      if (const {'en_route', 'on_site', 'paused'}.contains(v.status)) {
        await eduardo.visits.finish(v.id, v.version, VisitFinish(outcome: 'not_executed'));
      }
    }
  });

  test('pacote traz o checklist; envio valida, exige ao concluir e substitui no reenvio', () async {
    final visit = await scheduled();
    final page = await eduardo.technicianSync.pull(deviceId);
    final mine = page.checklists.singleWhere((c) => c.visitId == visit.id);
    expect(mine.template.id, template.id);
    expect(mine.template.items.map((i) => i.key), ['temperatura', 'porta_veda', 'estado', 'observacoes']);
    expect(mine.response, isNull);

    // Antes do check-in não aceita.
    var results = await push([
      submit(visit, template, {'temperatura': '4'}),
    ]);
    expect(results.single.status, 'rejected');
    expect(results.single.errorCode, 'CHECK_IN_REQUIRED');

    // Check-in e envio incompleto/inválido no mesmo lote.
    results = await push([
      visitMutation('visit.check_in', visit, checkIn: checkIn),
      submit(visit, template, {'temperatura': 'quatro', 'porta_veda': 'ok', 'nao_existe': 'x'}),
    ]);
    expect(results.map((r) => r.status), ['applied', 'rejected']);
    expect(results[1].errorCode, 'VALIDATION_FAILED');

    // Concluir como resolvida sem checklist é recusado (online também).
    final onSite = results.first.visit!;
    await expectLater(
      eduardo.visits.finish(onSite.id, onSite.version, VisitFinish(outcome: 'resolved', notes: 'Feito')),
      throwsA(isA<ApiException>().having((e) => e.code, 'code', 'CHECKLIST_REQUIRED')),
    );

    // Envio válido + conclusão no mesmo lote; reenvio do mesmo id não reaplica.
    final submitId = newId();
    final first = submit(visit, template, {
      'temperatura': '3.5',
      'porta_veda': 'nok',
      'estado': 'Bom',
      'observacoes': '  ',
    }, id: submitId);
    results = await push([
      first,
      visitMutation(
        'visit.finish',
        visit,
        finish: VisitFinish(outcome: 'resolved', notes: 'Troquei a borracha'),
      ),
    ]);
    expect(results.map((r) => r.status), ['applied', 'applied']);
    final saved = results.first.checklist!.response!;
    expect(saved.status, 'submitted');
    expect(saved.templateVersion, template.templateVersion);
    expect(
      {for (final a in saved.answers) a.itemKey: a.value},
      {'temperatura': '3.5', 'porta_veda': 'nok', 'estado': 'Bom'},
    );
    expect(saved.submittedByName, t01.name);
    expect((await push([first])).single.status, 'duplicate');

    // Backoffice lê as respostas; outra empresa não vê nada.
    final listed = await bruno.visits.checklistsOfWorkOrder(visit.workOrderId);
    expect(listed.single.response!.id, saved.id);
    expect(listed.single.template.name, 'Preventiva balcão');
    expect(await carla.visits.checklistsOfWorkOrder(visit.workOrderId), isEmpty);
  });

  test('reenvio substitui as respostas; não executada dispensa o checklist', () async {
    final visit = await scheduled();
    var results = await push([
      visitMutation('visit.check_in', visit, checkIn: checkIn),
      submit(visit, template, {'temperatura': '2', 'porta_veda': 'ok', 'estado': 'Ruim'}),
      submit(visit, template, {'temperatura': '5', 'porta_veda': 'ok', 'estado': 'Bom'}),
    ]);
    expect(results.map((r) => r.status), ['applied', 'applied', 'applied']);
    final listed = await ana.visits.checklistsOfWorkOrder(visit.workOrderId);
    expect(listed, hasLength(1));
    expect({for (final a in listed.single.response!.answers) a.itemKey: a.value}['temperatura'], '5');
    expect(listed.single.response!.version, 2);

    // Mesmo com checklist enviado, outros resultados seguem sem exigência.
    final other = await scheduled();
    results = await push([
      visitMutation(
        'visit.finish',
        visit,
        finish: VisitFinish(outcome: 'resolved', notes: 'Ok'),
      ),
      visitMutation('visit.check_in', other, checkIn: checkIn),
      visitMutation('visit.finish', other, finish: VisitFinish(outcome: 'not_executed')),
    ]);
    expect(results.map((r) => r.status), ['applied', 'applied', 'applied']);
  });
}
