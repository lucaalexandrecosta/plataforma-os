import 'dart:convert';

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_field/src/api/gateway.dart';
import 'package:plataforma_os_field/src/local/checklist_rules.dart';
import 'package:plataforma_os_field/src/local/visit_rules.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

/// Servidor em memória para os testes de widget: login, registro do
/// aparelho, pull do recorte e push com as regras de visita do servidor
/// (as mesmas de [applyVisitMutation], mais a etiqueta do QR e a
/// idempotência por `mutationId`).
class FakeGateway implements Gateway {
  FakeGateway({List<TenantSummary>? tenants, this.linkedToTechnician = true}) : tenants = tenants ?? [frioSul];

  static final frioSul = TenantSummary(
    id: UuidValue.fromString('00000000-0000-4000-8000-000000000001'),
    slug: 'frio-sul',
    displayName: 'Frio Sul',
    status: TenantStatus.active,
  );
  static final fornoNorte = TenantSummary(
    id: UuidValue.fromString('00000000-0000-4000-8000-000000000002'),
    slug: 'forno-norte',
    displayName: 'Forno Norte',
    status: TenantStatus.active,
  );

  static final technicianId = UuidValue.fromString('00000000-0000-4000-8000-0000000000d1');

  /// Conteúdo do QR da etiqueta do bem das OS de exemplo.
  static const assetQr = 'https://qr.example/q/ABCD-2345';

  static const offlineError = GatewayException('Sem conexão com o servidor. Confira a internet e tente de novo.');

  final List<TenantSummary> tenants;
  final bool linkedToTechnician;
  final calls = <String>[];

  /// Estado do servidor.
  final visits = <Visit>[];
  final workOrders = <UuidValue, WorkOrder>{};

  /// Checklist de cada visita (por id da visita).
  final checklists = <UuidValue, VisitChecklist>{};

  static final checklistTemplate = ChecklistTemplate(
    id: UuidValue.fromString('00000000-0000-4000-8000-0000000000c1'),
    code: 'PREV-FZ',
    name: 'Preventiva freezer',
    templateVersion: 1,
    status: 'published',
    items: [
      ChecklistItem(key: 'temperatura', label: 'Temperatura', type: 'number', required: true, unit: '°C'),
      ChecklistItem(key: 'porta', label: 'Borracha da porta', type: 'ok_nok', required: true),
      ChecklistItem(key: 'estado', label: 'Estado geral', type: 'choice', required: false, options: ['Bom', 'Ruim']),
      ChecklistItem(key: 'obs', label: 'Observações', type: 'text', required: false),
    ],
    isActive: true,
    version: 2,
  );

  /// Dá à visita [n] o checklist de exemplo.
  void addChecklist(int n) {
    final v = visitNumber(n);
    checklists[v.id] = VisitChecklist(visitId: v.id, visitNumber: v.visitNumber, template: checklistTemplate);
  }

  /// Sem rede: sync falha, ações ficam na fila.
  var offline = false;

  /// O próximo push volta sem nenhum resultado (lote interrompido no servidor).
  var nextPushEmpty = false;

  /// O servidor aplica o próximo push, mas a resposta se perde na rede.
  var dropNextPushResponse = false;

  /// Próximo erro a lançar (uma vez) na chamada com esse nome.
  final failNext = <String, GatewayException>{};

  String? enteredSlug;
  final registeredDevices = <UuidValue>[];
  final pushed = <SyncMutation>[];
  final _results = <UuidValue, SyncMutationResult>{};

  void _maybeFail(String call) {
    calls.add(call);
    final error = failNext.remove(call);
    if (error != null) throw error;
  }

  void _network() {
    if (offline) throw offlineError;
  }

  Visit visitNumber(int n) => visits.singleWhere((v) => v.workOrderNumber.endsWith('$n'));

  /// Visita [n] da OS [n], agendada em [start] por 2 horas.
  void addVisit(
    int n,
    DateTime start, {
    String status = 'scheduled',
    String priority = 'normal',
    bool asset = true,
    bool requireQr = false,
  }) {
    final woId = UuidValue.fromString('00000000-0000-4000-8000-${n.toString().padLeft(12, '0')}');
    final number = '2026-${n.toString().padLeft(6, '0')}';
    workOrders[woId] = WorkOrder(
      id: woId,
      number: number,
      workOrderTypeId: UuidValue.fromString('00000000-0000-4000-8000-0000000000a1'),
      workOrderTypeName: 'Corretiva',
      status: status == 'scheduled' ? 'scheduled' : 'in_progress',
      priority: priority,
      origin: 'backoffice',
      entryMethod: 'asset_list',
      assetId: asset ? UuidValue.fromString('00000000-0000-4000-8000-0000000000b1') : null,
      assetLabel: asset ? 'PAT-00$n' : null,
      productName: asset ? 'Freezer horizontal' : null,
      customerName: 'Mercado Bom Preço',
      branchName: 'Loja Centro',
      problemDescription: 'Não gela',
      requesterName: 'Carlos',
      reopenedCount: 0,
      createdAt: start.subtract(const Duration(days: 1)).toUtc(),
      statusChangedAt: start.subtract(const Duration(days: 1)).toUtc(),
      version: 1,
    );
    visits.add(
      Visit(
        id: UuidValue.fromString('00000000-0000-4000-8001-${n.toString().padLeft(12, '0')}'),
        workOrderId: woId,
        workOrderNumber: number,
        workOrderStatus: workOrders[woId]!.status,
        workOrderPriority: priority,
        problemDescription: 'Não gela',
        assetLabel: asset ? 'PAT-00$n' : null,
        productName: asset ? 'Freezer horizontal' : null,
        customerName: 'Mercado Bom Preço',
        branchName: 'Loja Centro',
        visitNumber: 1,
        technicianId: technicianId,
        technicianName: 'Eduardo Técnico',
        status: status,
        scheduledStart: start.toUtc(),
        scheduledEnd: start.add(const Duration(hours: 2)).toUtc(),
        checkInOffSite: false,
        requireQrCheckIn: requireQr,
        version: 1,
      ),
    );
  }

  /// O despacho cancela a visita [n] no servidor.
  void cancelVisit(int n) {
    final i = visits.indexWhere((v) => v.workOrderNumber.endsWith('$n'));
    visits[i] = visits[i].copyWith(
      status: 'cancelled',
      cancellationReason: 'Cliente remarcou',
      version: visits[i].version + 1,
    );
  }

  // ----------------------------------------------------------- login
  @override
  Future<void> login(String email, String password) async {
    _maybeFail('login');
    if (password != 'certa123') throw const GatewayException('E-mail ou senha incorretos.');
  }

  @override
  Future<UuidValue> startRegistration(String email) async {
    _maybeFail('startRegistration');
    return UuidValue.fromString('00000000-0000-4000-8000-0000000000f1');
  }

  @override
  Future<void> finishRegistration(UuidValue requestId, String code, String password) async =>
      _maybeFail('finishRegistration');

  @override
  Future<List<TenantSummary>> myTenants() async {
    _maybeFail('myTenants');
    return tenants;
  }

  @override
  Future<MeInfo> enterTenant(String slug) async {
    _maybeFail('enterTenant');
    enteredSlug = slug;
    return MeInfo(
      userId: UuidValue.fromString('00000000-0000-4000-8000-0000000000e1'),
      fullName: 'Eduardo Técnico',
      email: 'eduardo@frio-sul.test',
      locale: 'pt-BR',
      tenant: tenants.singleWhere((t) => t.slug == slug),
      roles: const ['technician'],
      permissions: const ['visits.execute', 'work_orders.read'],
    );
  }

  @override
  void signOut() => calls.add('signOut');

  // ----------------------------------------------------------- sync
  void _technician() {
    if (!linkedToTechnician) {
      throw const GatewayException('Seu acesso não está ligado a um técnico desta empresa.', code: 'FORBIDDEN');
    }
  }

  @override
  Future<void> registerDevice(DeviceRegistration device) async {
    _maybeFail('registerDevice');
    _network();
    _technician();
    registeredDevices.add(device.deviceId);
  }

  @override
  Future<SyncPullResult> pull(UuidValue deviceId) async {
    _maybeFail('pull');
    _network();
    _technician();
    final mine = [
      for (final v in visits)
        if (v.technicianId == technicianId && v.status != 'cancelled') v,
    ];
    return SyncPullResult(
      serverTime: DateTime.now().toUtc(),
      scopeFrom: DateTime.utc(2026, 11, 15),
      scopeTo: DateTime.utc(2026, 12, 2),
      visits: mine,
      workOrders: [for (final v in mine) workOrders[v.workOrderId]!],
      checklists: [for (final v in mine) ?checklists[v.id]],
    );
  }

  @override
  Future<List<SyncMutationResult>> push(SyncPushRequest request) async {
    _maybeFail('push');
    _network();
    _technician();
    if (nextPushEmpty) {
      nextPushEmpty = false;
      return const [];
    }
    final failed = <UuidValue>{};
    final results = <SyncMutationResult>[];
    for (final m in request.mutations) {
      pushed.add(m);
      final previous = _results[m.mutationId];
      if (previous != null) {
        results.add(previous.status == 'applied' ? previous.copyWith(status: 'duplicate') : previous);
        continue;
      }
      final i = visits.indexWhere((v) => v.id == m.entityId);
      final visit = visits[i];
      SyncMutationResult result;
      if (failed.contains(m.entityId)) {
        result = SyncMutationResult(
          mutationId: m.mutationId,
          status: 'rejected',
          errorCode: 'DEPENDENCY_FAILED',
          errorMessage: 'Uma ação anterior desta visita não foi aceita.',
          visit: visit,
        );
      } else if (visit.status == 'cancelled') {
        result = SyncMutationResult(
          mutationId: m.mutationId,
          status: 'conflict',
          errorCode: 'VISIT_CANCELLED',
          errorMessage: 'Esta visita foi cancelada pelo despacho.',
          visit: visit,
        );
      } else if (m.type == checklistSubmitType) {
        result = _submitChecklist(m, visit);
      } else {
        final payload = VisitMutationPayload.fromJson(jsonDecode(m.payload) as Map<String, dynamic>);
        try {
          final checklist = checklists[visit.id];
          if (m.type == VisitMutation.finish &&
              payload.finish?.outcome == 'resolved' &&
              checklist != null &&
              checklist.response?.status != 'submitted') {
            throw const GatewayException('Envie o checklist antes de concluir a visita.', code: 'CHECKLIST_REQUIRED');
          }
          final scanned = payload.checkIn?.scannedCode;
          if (m.type == VisitMutation.checkIn && payload.checkIn?.method == 'qr' && scanned != assetQr) {
            throw const GatewayException('A etiqueta lida não é do bem desta OS.', code: 'QR_ASSET_MISMATCH');
          }
          final updated = applyVisitMutation(
            visit,
            m.type,
            payload,
            DateTime.now(),
          ).copyWith(version: visit.version + 1);
          visits[i] = updated;
          final wo = workOrders[visit.workOrderId]!;
          workOrders[wo.id] = wo.copyWith(status: updated.workOrderStatus, version: wo.version + 1);
          result = SyncMutationResult(mutationId: m.mutationId, status: 'applied', visit: updated);
        } on GatewayException catch (e) {
          result = SyncMutationResult(
            mutationId: m.mutationId,
            status: 'rejected',
            errorCode: e.code,
            errorMessage: e.message,
            visit: visit,
          );
        }
      }
      if (result.status != 'applied') failed.add(m.entityId);
      _results[m.mutationId] = result;
      results.add(result);
    }
    if (dropNextPushResponse) {
      dropNextPushResponse = false;
      throw offlineError;
    }
    return results;
  }

  SyncMutationResult _submitChecklist(SyncMutation m, Visit visit) {
    final payload = ChecklistSubmitPayload.fromJson(jsonDecode(m.payload) as Map<String, dynamic>);
    final current = checklists[visit.id];
    SyncMutationResult refuse(String code, String message) => SyncMutationResult(
      mutationId: m.mutationId,
      status: 'rejected',
      errorCode: code,
      errorMessage: message,
      visit: visit,
    );
    if (current == null || current.template.id != payload.checklistTemplateId) {
      return refuse('CHECKLIST_MISMATCH', 'Este checklist não é o desta visita.');
    }
    if (!const {'on_site', 'paused'}.contains(visit.status)) {
      return refuse('CHECK_IN_REQUIRED', 'O checklist é enviado durante a visita, após o check-in.');
    }
    final (errors, answers) = checkChecklist(current.template, {for (final a in payload.answers) a.itemKey: a});
    if (errors.isNotEmpty) return refuse('VALIDATION_FAILED', 'Confira os campos informados.');
    final saved = current.copyWith(
      response: ChecklistResponse(
        id: UuidValue.fromString('00000000-0000-4000-8002-000000000001'),
        workOrderId: visit.workOrderId,
        visitId: visit.id,
        checklistTemplateId: current.template.id,
        templateVersion: current.template.templateVersion,
        status: 'submitted',
        answers: answers,
        submittedAt: DateTime.now().toUtc(),
        submittedByName: 'Eduardo Técnico',
        version: (current.response?.version ?? 0) + 1,
      ),
    );
    checklists[visit.id] = saved;
    return SyncMutationResult(mutationId: m.mutationId, status: 'applied', visit: visit, checklist: saved);
  }
}
