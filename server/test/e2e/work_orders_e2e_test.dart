// Ordens de serviço de ponta a ponta: tipos de OS, abertura pelo QR (código
// curto ou URL) e pela lista de bens herdando filial e centro de custo, aviso
// de OS aberta no mesmo bem, ciclo de status com histórico, concorrência
// otimista, permissões e isolamento entre empresas.
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
  late Client davi; // manager frio-sul (só leitura)
  late Client carla; // tenant_admin forno-norte
  late Asset asset;
  late QrTag tag;
  late QrTag looseTag;
  late WorkOrderType corrective;
  late Branch matriz;
  late CostCenter producao;

  setUpAll(() async {
    ana = await tenantClient('ana.admin@frio-sul.test', 'frio-sul');
    bruno = await tenantClient('bruno.despacho@frio-sul.test', 'frio-sul');
    davi = await tenantClient('davi.consultor@dev.test', 'frio-sul');
    carla = await tenantClient('carla.admin@forno-norte.test', 'forno-norte');

    matriz = (await ana.branches.list()).singleWhere((b) => b.code == 'MATRIZ');
    producao = (await ana.costCenters.list()).singleWhere((c) => c.code == '1.01');
    final product = (await ana.products.list()).first;
    final stamp = DateTime.now().microsecondsSinceEpoch;
    asset = await ana.assets.create(
      AssetInput(
        productId: product.id,
        assetTag: 'PAT-OS-$stamp',
        branchId: matriz.id,
        costCenterId: producao.id,
        isActive: true,
      ),
    );
    final batch = await ana.qrTags.generateBatch(2);
    final tags = await ana.qrTags.batchTags(batch.id);
    tag = await ana.qrTags.bind(tags[0].shortCode, asset.id);
    looseTag = tags[1];
    corrective = (await davi.workOrders.types()).singleWhere((t) => t.code == 'COR');
  });

  group('tipos de OS', () {
    test('cria e edita com catalog.manage; código único', () async {
      final input = WorkOrderTypeInput(
        code: 'prv',
        name: 'Preventiva',
        category: 'preventive',
        defaultPriority: 'low',
        requiresAsset: true,
        isActive: true,
      );
      await expectLater(davi.workOrders.createType(input), throwsApiError('FORBIDDEN'));
      final created = await ana.workOrders.createType(input);
      expect(created.code, 'PRV');
      await expectLater(ana.workOrders.createType(input), throwsApiError('VALIDATION_FAILED'));

      final renamed = await ana.workOrders.updateType(created.id, created.version, input..name = 'Preventiva mensal');
      expect(renamed.name, 'Preventiva mensal');
      await expectLater(
        ana.workOrders.updateType(created.id, created.version, input),
        throwsApiError('VERSION_MISMATCH'),
      );
      expect((await bruno.workOrders.types()).map((t) => t.code), contains('PRV'));
    });
  });

  group('abertura', () {
    late WorkOrderDetail first;

    test('pelo código curto do QR herda filial e centro de custo; OS interna sem cliente', () async {
      first = await bruno.workOrders.open(
        WorkOrderInput(
          workOrderTypeId: corrective.id,
          scannedCode: tag.shortCode.toLowerCase(),
          problemDescription: 'Não liga',
          requesterName: 'Produção',
        ),
      );
      final wo = first.workOrder;
      expect(wo.number, matches(RegExp(r'^\d{4}-\d{6}$')));
      expect(wo.status, 'open');
      expect(wo.priority, 'normal');
      expect(wo.origin, 'backoffice');
      expect(wo.entryMethod, 'short_code');
      expect(wo.assetId, asset.id);
      expect(wo.assetLabel, asset.assetTag);
      expect(wo.branchId, matriz.id);
      expect(wo.costCenterId, producao.id);
      expect(wo.costCenterName, contains('1.01'));
      expect(wo.customerId, isNull);
      expect(first.history.single.toStatus, 'open');
      expect(first.history.single.changedByName, 'Bruno Despacho');
      expect(first.otherOpenOnAsset, isEmpty);
    });

    test('pela URL do QR e pela lista avisam da OS aberta no mesmo bem', () async {
      final byUrl = await bruno.workOrders.open(
        WorkOrderInput(workOrderTypeId: corrective.id, scannedCode: tag.url, priority: 'high'),
      );
      expect(byUrl.workOrder.entryMethod, 'qr_token');
      expect(byUrl.workOrder.priority, 'high');
      expect(byUrl.otherOpenOnAsset.map((w) => w.id), [first.workOrder.id]);

      final byList = await bruno.workOrders.open(WorkOrderInput(workOrderTypeId: corrective.id, assetId: asset.id));
      expect(byList.workOrder.entryMethod, 'asset_list');
      expect(byList.otherOpenOnAsset, hasLength(2));
      await bruno.workOrders.cancel(byUrl.workOrder.id, byUrl.workOrder.version, 'created_in_error');
      await bruno.workOrders.cancel(byList.workOrder.id, byList.workOrder.version, 'created_in_error');
    });

    test('recusas: sem permissão, etiqueta solta ou desconhecida, tipo que exige bem', () async {
      await expectLater(
        davi.workOrders.open(WorkOrderInput(workOrderTypeId: corrective.id, assetId: asset.id)),
        throwsApiError('FORBIDDEN'),
      );
      await expectLater(
        bruno.workOrders.open(WorkOrderInput(workOrderTypeId: corrective.id, scannedCode: looseTag.shortCode)),
        throwsApiError('TAG_NOT_BOUND'),
      );
      await expectLater(
        bruno.workOrders.open(WorkOrderInput(workOrderTypeId: corrective.id, scannedCode: 'nao-e-etiqueta')),
        throwsApiError('VALIDATION_FAILED'),
      );
      await expectLater(
        bruno.workOrders.open(WorkOrderInput(workOrderTypeId: corrective.id)),
        throwsApiError('VALIDATION_FAILED'),
      );
      await expectLater(
        bruno.workOrders.open(WorkOrderInput(workOrderTypeId: corrective.id, assetId: asset.id, priority: 'x')),
        throwsApiError('VALIDATION_FAILED'),
      );
    });

    test('ciclo: iniciar, pendência, retomar, concluir, encerrar e reabrir, com histórico', () async {
      var wo = first.workOrder;
      await expectLater(bruno.workOrders.close(wo.id, wo.version), throwsApiError('INVALID_TRANSITION'));

      wo = await bruno.workOrders.start(wo.id, wo.version);
      expect(wo.status, 'in_progress');
      expect(wo.startedAt, isNotNull);
      await expectLater(bruno.workOrders.hold(wo.id, wo.version, 'other'), throwsApiError('VALIDATION_FAILED'));
      wo = await bruno.workOrders.hold(wo.id, wo.version, 'awaiting_part', note: 'Compressor');
      expect(wo.status, 'on_hold');
      expect(wo.holdReason, 'awaiting_part');
      wo = await bruno.workOrders.start(wo.id, wo.version);
      expect(wo.holdReason, isNull);

      await expectLater(bruno.workOrders.complete(wo.id, wo.version, '  '), throwsApiError('VALIDATION_FAILED'));
      wo = await bruno.workOrders.complete(wo.id, wo.version, 'Troca do compressor');
      expect(wo.status, 'completed');
      expect(wo.completedAt, isNotNull);
      expect(wo.resolutionNotes, 'Troca do compressor');
      await expectLater(
        bruno.workOrders.update(
          wo.id,
          wo.version,
          WorkOrderChanges(workOrderTypeId: corrective.id, priority: 'urgent'),
        ),
        throwsApiError('WORK_ORDER_FINISHED'),
      );

      wo = await bruno.workOrders.close(wo.id, wo.version);
      expect(wo.status, 'closed');
      expect(wo.closedAt, isNotNull);
      await expectLater(davi.workOrders.reopen(wo.id, wo.version, 'Voltou a falhar'), throwsApiError('FORBIDDEN'));
      wo = await bruno.workOrders.reopen(wo.id, wo.version, 'Voltou a falhar');
      expect(wo.status, 'open');
      expect(wo.reopenedCount, 1);
      expect(wo.closedAt, isNull);
      expect(wo.completedAt, isNull);

      final detail = await davi.workOrders.get(wo.id);
      expect(detail.history.map((h) => h.toStatus), [
        'open',
        'in_progress',
        'on_hold',
        'in_progress',
        'completed',
        'closed',
        'open',
      ]);
      expect(detail.history[2].reason, 'Compressor');
      expect(detail.history.last.reason, 'Voltou a falhar');
      first = detail;
    });

    test('edição com versão; versão velha dá VERSION_MISMATCH', () async {
      final wo = first.workOrder;
      final changes = WorkOrderChanges(
        workOrderTypeId: corrective.id,
        priority: 'urgent',
        problemDescription: 'Não liga e faz barulho',
      );
      await expectLater(davi.workOrders.update(wo.id, wo.version, changes), throwsApiError('FORBIDDEN'));
      final updated = await bruno.workOrders.update(wo.id, wo.version, changes);
      expect(updated.priority, 'urgent');
      expect(updated.version, greaterThan(wo.version));
      await expectLater(bruno.workOrders.start(wo.id, wo.version), throwsApiError('VERSION_MISMATCH'));
      await expectLater(
        bruno.workOrders.cancel(updated.id, updated.version, 'other'),
        throwsApiError('VALIDATION_FAILED'),
      );
      final cancelled = await bruno.workOrders.cancel(updated.id, updated.version, 'other', note: 'Bem substituído');
      expect(cancelled.status, 'cancelled');
      expect(cancelled.cancellationNote, 'Bem substituído');
    });

    test('lista filtra por bem, status, centro de custo e número', () async {
      final ofAsset = await davi.workOrders.list(assetId: asset.id);
      expect(ofAsset.total, 3);
      expect((await davi.workOrders.list(assetId: asset.id, openOnly: true)).total, 0);
      expect((await davi.workOrders.list(assetId: asset.id, statuses: ['cancelled'])).total, 3);
      expect(
        (await davi.workOrders.list(costCenterId: producao.id)).items.map((w) => w.id),
        contains(first.workOrder.id),
      );
      final byNumber = await davi.workOrders.list(search: first.workOrder.number);
      expect(byNumber.items.single.id, first.workOrder.id);
    });

    test('isolamento: outra empresa não vê a OS nem abre pelo bem ou pela etiqueta', () async {
      await expectLater(carla.workOrders.get(first.workOrder.id), throwsApiError('NOT_FOUND'));
      expect((await carla.workOrders.list()).items.map((w) => w.id), isNot(contains(first.workOrder.id)));
      final carlaType = (await carla.workOrders.types()).first;
      await expectLater(
        carla.workOrders.open(WorkOrderInput(workOrderTypeId: carlaType.id, assetId: asset.id)),
        throwsApiError('VALIDATION_FAILED'),
      );
      await expectLater(
        carla.workOrders.open(WorkOrderInput(workOrderTypeId: carlaType.id, scannedCode: tag.shortCode)),
        throwsApiError('VALIDATION_FAILED'),
      );
      await expectLater(
        carla.workOrders.open(WorkOrderInput(workOrderTypeId: corrective.id, assetId: asset.id)),
        throwsApiError('VALIDATION_FAILED'),
      );
    });
  });
}
