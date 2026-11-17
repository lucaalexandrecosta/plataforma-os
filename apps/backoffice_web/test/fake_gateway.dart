import 'package:plataforma_os_backoffice/src/api/gateway.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

/// Gateway em memória para os testes de widget.
class FakeGateway implements Gateway {
  FakeGateway({List<TenantSummary>? tenants, this.permissions = allPermissions}) : tenants = tenants ?? [frioSul];

  static const allPermissions = [
    'work_orders.read',
    'work_orders.create',
    'work_orders.update',
    'work_orders.triage',
    'work_orders.close',
    'work_orders.reopen',
    'assets.manage',
    'visits.schedule',
  ];

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

  final List<TenantSummary> tenants;
  final List<String> permissions;
  final calls = <String>[];
  final workOrderList = <WorkOrder>[];

  /// Próximo erro a lançar (uma vez) na chamada com esse nome.
  final failNext = <String, GatewayException>{};

  String? enteredSlug;

  void _maybeFail(String call) {
    calls.add(call);
    final error = failNext.remove(call);
    if (error != null) throw error;
  }

  static final corrective = WorkOrderType(
    id: UuidValue.fromString('00000000-0000-4000-8000-0000000000a1'),
    code: 'COR',
    name: 'Corretiva',
    category: 'corrective',
    defaultPriority: 'normal',
    requiresAsset: true,
    isActive: true,
    version: 1,
  );

  static final asset1 = Asset(
    id: UuidValue.fromString('00000000-0000-4000-8000-0000000000b1'),
    productId: UuidValue.fromString('00000000-0000-4000-8000-0000000000c1'),
    productName: 'Freezer horizontal',
    serialNumber: 'SN-1',
    assetTag: 'PAT-001',
    status: 'installed',
    ownershipType: 'tenant_loan',
    acquisitionCost: 123456,
    qrShortCode: 'ABCD-2345',
    isActive: true,
    source: 'local',
    version: 1,
  );

  static WorkOrder sample({String status = 'open', int n = 1, int version = 1}) => WorkOrder(
    id: UuidValue.fromString('00000000-0000-4000-8000-${n.toString().padLeft(12, '0')}'),
    number: '2026-${n.toString().padLeft(6, '0')}',
    workOrderTypeId: corrective.id,
    workOrderTypeName: 'Corretiva',
    status: status,
    priority: 'normal',
    origin: 'backoffice',
    entryMethod: 'asset_list',
    assetId: asset1.id,
    assetLabel: 'PAT-001',
    productName: 'Freezer horizontal',
    costCenterName: '1.01 · Produção',
    problemDescription: 'Não liga',
    reopenedCount: 0,
    createdAt: DateTime.utc(2026, 11, 16, 13),
    statusChangedAt: DateTime.utc(2026, 11, 16, 13),
    version: version,
  );

  WorkOrder _replace(WorkOrder wo, String status) {
    final updated = wo.copyWith(status: status, version: wo.version + 1);
    final i = workOrderList.indexWhere((w) => w.id == wo.id);
    if (i >= 0) workOrderList[i] = updated;
    return updated;
  }

  // login
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
      fullName: 'Ana Admin',
      email: 'ana@frio-sul.test',
      locale: 'pt-BR',
      tenant: tenants.singleWhere((t) => t.slug == slug),
      roles: const ['tenant_admin'],
      permissions: permissions,
    );
  }

  @override
  void signOut() => calls.add('signOut');

  // cadastros
  @override
  Future<List<Branch>> branches() async => const [];

  @override
  Future<List<CostCenter>> costCenters() async => const [];

  @override
  Future<AssetPage> assets({String? search, int limit = 50, int offset = 0}) async {
    _maybeFail('assets');
    return AssetPage(items: [asset1], total: 1);
  }

  @override
  Future<Asset> asset(UuidValue id) async => asset1;

  // OS
  @override
  Future<WorkOrderPage> workOrders({
    String? search,
    List<String>? statuses,
    bool openOnly = false,
    UuidValue? assetId,
    int limit = 50,
    int offset = 0,
  }) async {
    _maybeFail('workOrders');
    final items = workOrderList
        .where((w) => statuses == null || statuses.contains(w.status))
        .where((w) => search == null || search.isEmpty || w.number.contains(search))
        .toList();
    return WorkOrderPage(items: items, total: items.length);
  }

  @override
  Future<WorkOrderDetail> workOrder(UuidValue id) async {
    _maybeFail('workOrder');
    final wo = workOrderList.singleWhere((w) => w.id == id);
    return WorkOrderDetail(
      workOrder: wo,
      history: [
        WorkOrderStatusChange(toStatus: 'open', changedAt: wo.createdAt, changedByName: 'Ana Admin'),
      ],
      otherOpenOnAsset: const [],
    );
  }

  @override
  Future<List<WorkOrderType>> workOrderTypes() async => [corrective];

  WorkOrderInput? lastInput;

  @override
  Future<WorkOrderDetail> openWorkOrder(WorkOrderInput input) async {
    _maybeFail('openWorkOrder');
    lastInput = input;
    final wo = sample(n: workOrderList.length + 1);
    workOrderList.add(wo);
    return WorkOrderDetail(workOrder: wo, history: const [], otherOpenOnAsset: const []);
  }

  @override
  Future<WorkOrder> startWorkOrder(WorkOrder wo) async {
    _maybeFail('startWorkOrder');
    return _replace(wo, 'in_progress');
  }

  @override
  Future<WorkOrder> holdWorkOrder(WorkOrder wo, String holdReason, String? note) async {
    _maybeFail('holdWorkOrder');
    return _replace(wo, 'on_hold');
  }

  @override
  Future<WorkOrder> completeWorkOrder(WorkOrder wo, String resolutionNotes) async {
    _maybeFail('completeWorkOrder');
    return _replace(wo, 'completed');
  }

  @override
  Future<WorkOrder> closeWorkOrder(WorkOrder wo) async {
    _maybeFail('closeWorkOrder');
    return _replace(wo, 'closed');
  }

  String? lastCancelReason;

  @override
  Future<WorkOrder> cancelWorkOrder(WorkOrder wo, String reason, String? note) async {
    _maybeFail('cancelWorkOrder');
    lastCancelReason = reason;
    return _replace(wo, 'cancelled');
  }

  @override
  Future<WorkOrder> reopenWorkOrder(WorkOrder wo, String reason) async {
    _maybeFail('reopenWorkOrder');
    return _replace(wo, 'open');
  }

  // agenda
  final technicianList = <Technician>[
    Technician(
      id: UuidValue.fromString('00000000-0000-4000-8000-0000000000d1'),
      code: 'T01',
      name: 'Eduardo Técnico',
      isActive: true,
      version: 1,
    ),
  ];
  final visitList = <Visit>[];
  VisitInput? lastVisitInput;
  DateTime? lastAgendaFrom;
  DateTime? lastAgendaTo;

  static Visit sampleVisit(WorkOrder wo, Technician t, DateTime start, {int number = 1, String status = 'scheduled'}) =>
      Visit(
        id: UuidValue.fromString('00000000-0000-4000-9000-${number.toString().padLeft(12, '0')}'),
        workOrderId: wo.id,
        workOrderNumber: wo.number,
        workOrderStatus: 'scheduled',
        workOrderPriority: wo.priority,
        problemDescription: wo.problemDescription,
        assetLabel: wo.assetLabel,
        productName: wo.productName,
        visitNumber: number,
        technicianId: t.id,
        technicianName: t.name,
        status: status,
        scheduledStart: start,
        scheduledEnd: start.add(const Duration(hours: 2)),
        checkInOffSite: false,
        version: 1,
      );

  @override
  Future<List<Technician>> technicians({bool includeInactive = false}) async {
    _maybeFail('technicians');
    return [
      for (final t in technicianList)
        if (includeInactive || t.isActive) t,
    ];
  }

  @override
  Future<Technician> createTechnician(TechnicianInput input) async {
    _maybeFail('createTechnician');
    final t = Technician(
      id: UuidValue.fromString('00000000-0000-4000-8000-0000000000d${technicianList.length + 1}'),
      code: input.code,
      name: input.name,
      email: input.email,
      phone: input.phone,
      isActive: input.isActive,
      version: 1,
    );
    technicianList.add(t);
    return t;
  }

  @override
  Future<Technician> updateTechnician(Technician technician, TechnicianInput input) async {
    _maybeFail('updateTechnician');
    final t = technician.copyWith(
      code: input.code,
      name: input.name,
      isActive: input.isActive,
      version: technician.version + 1,
    );
    technicianList[technicianList.indexWhere((x) => x.id == t.id)] = t;
    return t;
  }

  @override
  Future<List<Visit>> agenda(
    DateTime from,
    DateTime to, {
    UuidValue? technicianId,
    bool includeCancelled = false,
  }) async {
    _maybeFail('agenda');
    lastAgendaFrom = from;
    lastAgendaTo = to;
    return [
      for (final v in visitList)
        if (!v.scheduledStart.isBefore(from) &&
            v.scheduledStart.isBefore(to) &&
            (includeCancelled || v.status != 'cancelled'))
          v,
    ];
  }

  @override
  Future<List<Visit>> visitsOfWorkOrder(UuidValue workOrderId) async => [
    for (final v in visitList)
      if (v.workOrderId == workOrderId) v,
  ];

  @override
  Future<Visit> scheduleVisit(UuidValue workOrderId, VisitInput input) async {
    _maybeFail('scheduleVisit');
    lastVisitInput = input;
    final wo = workOrderList.singleWhere((w) => w.id == workOrderId);
    final t = technicianList.singleWhere((x) => x.id == input.technicianId);
    final v = sampleVisit(
      wo,
      t,
      input.scheduledStart,
      number: visitList.length + 1,
    ).copyWith(scheduledEnd: input.scheduledEnd);
    visitList.add(v);
    _replace(wo, 'scheduled');
    return v;
  }

  @override
  Future<Visit> rescheduleVisit(Visit visit, VisitInput input) async {
    _maybeFail('rescheduleVisit');
    lastVisitInput = input;
    final v = visit.copyWith(
      scheduledStart: input.scheduledStart,
      scheduledEnd: input.scheduledEnd,
      version: visit.version + 1,
    );
    visitList[visitList.indexWhere((x) => x.id == v.id)] = v;
    return v;
  }

  String? lastVisitCancelReason;

  @override
  Future<Visit> cancelVisit(Visit visit, String reason) async {
    _maybeFail('cancelVisit');
    lastVisitCancelReason = reason;
    final v = visit.copyWith(status: 'cancelled', cancellationReason: reason, version: visit.version + 1);
    visitList[visitList.indexWhere((x) => x.id == v.id)] = v;
    return v;
  }
}
