import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_field/src/api/gateway.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

/// Gateway em memória para os testes de widget. Imita as regras do servidor
/// que a tela precisa respeitar (transições da visita e efeito na OS).
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

  static final technician = Technician(
    id: UuidValue.fromString('00000000-0000-4000-8000-0000000000d1'),
    code: 'T01',
    name: 'Eduardo Técnico',
    isActive: true,
    version: 1,
  );

  /// Conteúdo do QR da etiqueta do bem das OS de exemplo.
  static const assetQr = 'https://qr.example/q/ABCD-2345';

  final List<TenantSummary> tenants;
  final bool linkedToTechnician;
  final calls = <String>[];
  final visits = <Visit>[];
  final workOrders = <UuidValue, WorkOrder>{};

  /// Exige justificativa no GPS, como numa OS que pede o QR.
  var requireQr = false;

  /// Próximo erro a lançar (uma vez) na chamada com esse nome.
  final failNext = <String, GatewayException>{};

  String? enteredSlug;
  VisitCheckIn? lastCheckIn;
  VisitFinish? lastFinish;
  (DateTime, DateTime)? lastRange;

  void _maybeFail(String call) {
    calls.add(call);
    final error = failNext.remove(call);
    if (error != null) throw error;
  }

  /// Visita [n] da OS [n], agendada em [start] por 2 horas.
  void addVisit(int n, DateTime start, {String status = 'scheduled', String priority = 'normal', bool asset = true}) {
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
        technicianId: technician.id,
        technicianName: technician.name,
        status: status,
        scheduledStart: start.toUtc(),
        scheduledEnd: start.add(const Duration(hours: 2)).toUtc(),
        checkInOffSite: false,
        version: 1,
      ),
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

  // ----------------------------------------------------------- agenda
  @override
  Future<Technician?> myTechnician() async {
    _maybeFail('myTechnician');
    return linkedToTechnician ? technician : null;
  }

  @override
  Future<List<Visit>> myVisits(DateTime from, DateTime to) async {
    _maybeFail('myVisits');
    lastRange = (from, to);
    return [
      for (final v in visits)
        if (!v.scheduledStart.isBefore(from.toUtc()) && v.scheduledStart.isBefore(to.toUtc())) v,
    ];
  }

  @override
  Future<Visit> visit(UuidValue id) async {
    _maybeFail('visit');
    return visits.singleWhere((v) => v.id == id);
  }

  @override
  Future<WorkOrderDetail> workOrder(UuidValue id) async {
    _maybeFail('workOrder');
    return WorkOrderDetail(workOrder: workOrders[id]!, history: const [], otherOpenOnAsset: const []);
  }

  // ----------------------------------------------------------- execução
  Visit _move(Visit visit, String status, {String? woStatus, Visit Function(Visit)? also}) {
    final i = visits.indexWhere((v) => v.id == visit.id);
    final current = visits[i];
    if (current.version != visit.version) {
      throw GatewayException('A visita foi alterada.', code: 'VERSION_MISMATCH');
    }
    if (woStatus != null) {
      final wo = workOrders[current.workOrderId]!;
      workOrders[wo.id] = wo.copyWith(status: woStatus, version: wo.version + 1);
    }
    var updated = current.copyWith(
      status: status,
      version: current.version + 1,
      workOrderStatus: workOrders[current.workOrderId]!.status,
    );
    if (also != null) updated = also(updated);
    visits[i] = updated;
    return updated;
  }

  void _require(Visit visit, Set<String> allowed) {
    final current = visits.singleWhere((v) => v.id == visit.id);
    if (!allowed.contains(current.status)) {
      throw const GatewayException('Ação não permitida neste status.', code: 'INVALID_TRANSITION');
    }
  }

  @override
  Future<Visit> startTravel(Visit visit) async {
    _maybeFail('startTravel');
    _require(visit, {'scheduled'});
    return _move(
      visit,
      'en_route',
      woStatus: 'in_progress',
      also: (v) => v.copyWith(travelStartedAt: DateTime.utc(2026, 11, 17, 11)),
    );
  }

  @override
  Future<Visit> checkIn(Visit visit, VisitCheckIn input) async {
    _maybeFail('checkIn');
    _require(visit, {'scheduled', 'en_route'});
    lastCheckIn = input;
    switch (input.method) {
      case 'qr':
        if (input.scannedCode != assetQr) {
          throw const GatewayException('A etiqueta lida não é do bem desta OS.', code: 'QR_ASSET_MISMATCH');
        }
      case 'gps':
        if (requireQr && (input.justification ?? '').isEmpty) {
          throw const GatewayException(
            'Esta OS pede a leitura do QR; justifique o check-in por GPS.',
            code: 'VALIDATION_FAILED',
            fieldErrors: {'justification': 'Esta OS pede a leitura do QR; justifique o check-in por GPS.'},
          );
        }
      case 'manual':
        if ((input.justification ?? '').isEmpty) {
          throw const GatewayException('Justifique o check-in manual.', code: 'VALIDATION_FAILED');
        }
    }
    return _move(
      visit,
      'on_site',
      woStatus: 'in_progress',
      also: (v) => v.copyWith(
        checkedInAt: DateTime.utc(2026, 11, 17, 11, 30),
        checkInMethod: input.method,
        checkInJustification: input.justification,
      ),
    );
  }

  @override
  Future<Visit> pause(Visit visit) async {
    _maybeFail('pause');
    _require(visit, {'on_site'});
    return _move(visit, 'paused');
  }

  @override
  Future<Visit> resume(Visit visit) async {
    _maybeFail('resume');
    _require(visit, {'paused'});
    return _move(visit, 'on_site');
  }

  @override
  Future<Visit> finish(Visit visit, VisitFinish input) async {
    _maybeFail('finish');
    _require(visit, {'scheduled', 'en_route', 'on_site', 'paused'});
    lastFinish = input;
    final woStatus = switch (input.outcome) {
      'resolved' => 'completed',
      'not_executed' => 'open',
      _ => 'on_hold',
    };
    return _move(
      visit,
      'finished',
      woStatus: woStatus,
      also: (v) => v.copyWith(
        outcome: input.outcome,
        outcomeNotes: input.notes,
        finishedAt: DateTime.utc(2026, 11, 17, 13),
      ),
    );
  }
}
