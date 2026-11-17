import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart' show AuthSuccess;
import 'package:serverpod_client/serverpod_client.dart';

import 'gateway.dart';

/// [Gateway] sobre o cliente gerado do Serverpod.
///
/// Tokens só em memória (docs/04 §4.3): a sessão de login (10 min, renovada
/// pelo refresh token de 14 dias) e o token da empresa (10 min, pedido de novo
/// a `auth.selectTenant` antes de vencer). Recarregar a página pede login.
class ServerGateway implements Gateway {
  ServerGateway(String apiUrl) {
    _anonymous = Client(apiUrl);
    _login = Client(apiUrl)..authKeyProvider = _Bearer(_loginToken);
    _tenant = Client(apiUrl)..authKeyProvider = _Bearer(_tenantToken);
  }

  /// Folga para renovar antes de vencer (relógio do navegador e rede).
  static const _margin = Duration(seconds: 60);

  late final Client _anonymous;
  late final Client _login;
  late final Client _tenant;

  AuthSuccess? _auth;
  String? _tenantSlug;
  String? _tenantAccess;
  DateTime? _tenantExpiresAt;
  Future<String>? _pendingLogin;
  Future<String>? _pendingTenant;

  // ----------------------------------------------------------- login

  @override
  Future<void> login(String email, String password) => _guard(() async {
    signOut();
    try {
      _auth = await _anonymous.emailIdp.login(email: email.trim(), password: password);
    } on ApiException {
      rethrow;
    } on ServerpodClientException {
      rethrow;
    } on Exception {
      // EmailAccountLoginException: não diz se o e-mail existe.
      throw const GatewayException('E-mail ou senha incorretos.');
    }
  });

  @override
  Future<UuidValue> startRegistration(String email) =>
      _guard(() => _anonymous.emailIdp.startRegistration(email: email.trim()));

  @override
  Future<void> finishRegistration(UuidValue requestId, String code, String password) => _guard(() async {
    signOut();
    final String registrationToken;
    try {
      registrationToken = await _anonymous.emailIdp.verifyRegistrationCode(
        accountRequestId: requestId,
        verificationCode: code.trim(),
      );
    } on ServerpodClientException {
      rethrow;
    } on Exception {
      throw const GatewayException('Código inválido ou vencido. Peça um novo código.');
    }
    try {
      _auth = await _anonymous.emailIdp.finishRegistration(registrationToken: registrationToken, password: password);
    } on ServerpodClientException {
      rethrow;
    } on Exception {
      throw const GatewayException('A senha não atende às regras: use pelo menos 8 caracteres, com letras e números.');
    }
  });

  @override
  Future<List<TenantSummary>> myTenants() => _guard(() => _login.auth.myTenants());

  @override
  Future<MeInfo> enterTenant(String slug) => _guard(() async {
    _tenantSlug = slug;
    _tenantAccess = null;
    _tenantExpiresAt = null;
    await _tenantToken();
    return _tenant.me.get();
  });

  @override
  void signOut() {
    _auth = null;
    _tenantSlug = null;
    _tenantAccess = null;
    _tenantExpiresAt = null;
    _pendingLogin = null;
    _pendingTenant = null;
  }

  Future<String> _loginToken() => _pendingLogin ??= _renewLogin().whenComplete(() => _pendingLogin = null);

  Future<String> _renewLogin() async {
    final auth = _auth;
    if (auth == null) throw const SessionLost();
    final expiresAt = auth.tokenExpiresAt;
    if (expiresAt == null || DateTime.now().add(_margin).isBefore(expiresAt)) return auth.token;
    final refresh = auth.refreshToken;
    if (refresh == null) throw const SessionLost();
    try {
      _auth = await _anonymous.refreshJwtTokens.refreshAccessToken(refreshToken: refresh);
    } on ServerpodClientNetworkException {
      rethrow;
    } on Exception {
      signOut();
      throw const SessionLost();
    }
    return _auth!.token;
  }

  Future<String> _tenantToken() => _pendingTenant ??= _renewTenant().whenComplete(() => _pendingTenant = null);

  Future<String> _renewTenant() async {
    final slug = _tenantSlug;
    if (slug == null) throw const SessionLost();
    final access = _tenantAccess;
    final expiresAt = _tenantExpiresAt;
    if (access != null && expiresAt != null && DateTime.now().add(_margin).isBefore(expiresAt)) return access;
    final issued = await _login.auth.selectTenant(slug);
    _tenantAccess = issued.accessToken;
    _tenantExpiresAt = DateTime.now().add(Duration(seconds: issued.expiresIn));
    return issued.accessToken;
  }

  // ----------------------------------------------------------- cadastros

  @override
  Future<List<Branch>> branches() => _guard(() => _tenant.branches.list());

  @override
  Future<List<CostCenter>> costCenters() => _guard(() => _tenant.costCenters.list());

  @override
  Future<AssetPage> assets({String? search, int limit = 50, int offset = 0}) =>
      _guard(() => _tenant.assets.list(search: _blankToNull(search), limit: limit, offset: offset));

  @override
  Future<Asset> asset(UuidValue id) => _guard(() => _tenant.assets.get(id));

  // ----------------------------------------------------------- OS

  @override
  Future<WorkOrderPage> workOrders({
    String? search,
    List<String>? statuses,
    bool openOnly = false,
    UuidValue? assetId,
    int limit = 50,
    int offset = 0,
  }) => _guard(
    () => _tenant.workOrders.list(
      search: _blankToNull(search),
      statuses: statuses == null || statuses.isEmpty ? null : statuses,
      openOnly: openOnly ? true : null,
      assetId: assetId,
      limit: limit,
      offset: offset,
    ),
  );

  @override
  Future<WorkOrderDetail> workOrder(UuidValue id) => _guard(() => _tenant.workOrders.get(id));

  @override
  Future<List<WorkOrderType>> workOrderTypes() => _guard(() => _tenant.workOrders.types());

  @override
  Future<WorkOrderDetail> openWorkOrder(WorkOrderInput input) => _guard(() => _tenant.workOrders.open(input));

  @override
  Future<WorkOrder> startWorkOrder(WorkOrder wo) => _guard(() => _tenant.workOrders.start(wo.id, wo.version));

  @override
  Future<WorkOrder> holdWorkOrder(WorkOrder wo, String holdReason, String? note) =>
      _guard(() => _tenant.workOrders.hold(wo.id, wo.version, holdReason, note: _blankToNull(note)));

  @override
  Future<WorkOrder> completeWorkOrder(WorkOrder wo, String resolutionNotes) =>
      _guard(() => _tenant.workOrders.complete(wo.id, wo.version, resolutionNotes));

  @override
  Future<WorkOrder> closeWorkOrder(WorkOrder wo) => _guard(() => _tenant.workOrders.close(wo.id, wo.version));

  @override
  Future<WorkOrder> cancelWorkOrder(WorkOrder wo, String reason, String? note) =>
      _guard(() => _tenant.workOrders.cancel(wo.id, wo.version, reason, note: _blankToNull(note)));

  @override
  Future<WorkOrder> reopenWorkOrder(WorkOrder wo, String reason) =>
      _guard(() => _tenant.workOrders.reopen(wo.id, wo.version, reason));

  // ----------------------------------------------------------- agenda

  @override
  Future<List<Technician>> technicians({bool includeInactive = false}) =>
      _guard(() => _tenant.technicians.list(includeInactive: includeInactive ? true : null));

  @override
  Future<Technician> createTechnician(TechnicianInput input) => _guard(() => _tenant.technicians.create(input));

  @override
  Future<Technician> updateTechnician(Technician technician, TechnicianInput input) =>
      _guard(() => _tenant.technicians.update(technician.id, technician.version, input));

  @override
  Future<List<Visit>> agenda(DateTime from, DateTime to, {UuidValue? technicianId, bool includeCancelled = false}) =>
      _guard(
        () => _tenant.visits.agenda(
          from.toUtc(),
          to.toUtc(),
          technicianId: technicianId,
          includeCancelled: includeCancelled ? true : null,
        ),
      );

  @override
  Future<List<Visit>> visitsOfWorkOrder(UuidValue workOrderId) => _guard(() => _tenant.visits.ofWorkOrder(workOrderId));

  @override
  Future<Visit> scheduleVisit(UuidValue workOrderId, VisitInput input) =>
      _guard(() => _tenant.visits.schedule(workOrderId, input));

  @override
  Future<Visit> rescheduleVisit(Visit visit, VisitInput input) =>
      _guard(() => _tenant.visits.reschedule(visit.id, visit.version, input));

  @override
  Future<Visit> cancelVisit(Visit visit, String reason) =>
      _guard(() => _tenant.visits.cancel(visit.id, visit.version, reason));

  // ----------------------------------------------------------- depreciação gerencial

  @override
  Future<DepreciationProfile?> depreciationProfile(UuidValue assetId) =>
      _guard(() => _tenant.depreciation.profile(assetId));

  @override
  Future<DepreciationProfile> saveDepreciationProfile(
    UuidValue assetId,
    int? expectedVersion,
    DepreciationProfileInput input,
  ) => _guard(() => _tenant.depreciation.saveProfile(assetId, expectedVersion, input));

  @override
  Future<AssetDepreciation> depreciationSchedule(UuidValue assetId) =>
      _guard(() => _tenant.depreciation.schedule(assetId));

  @override
  Future<DepreciationPosition> depreciationPosition(int year, int month, {UuidValue? costCenterId}) =>
      _guard(() => _tenant.depreciation.position(year, month, costCenterId: costCenterId));

  @override
  Future<List<DepreciationClosing>> depreciationClosings() => _guard(() => _tenant.depreciation.closings());

  @override
  Future<DepreciationClosing> closeDepreciation(int year, int month) =>
      _guard(() => _tenant.depreciation.close(year, month));

  @override
  Future<DepreciationClosing> reopenDepreciation(int year, int month, String reason) =>
      _guard(() => _tenant.depreciation.reopen(year, month, reason));

  // ----------------------------------------------------------- erros

  /// Converte os erros do cliente em [GatewayException] com mensagem para a
  /// pessoa; o detalhe técnico fica no `traceId` do servidor.
  Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on GatewayException {
      rethrow;
    } on ApiException catch (e) {
      if (e.code == 'UNAUTHENTICATED') {
        signOut();
        throw const SessionLost();
      }
      throw GatewayException(
        e.detail,
        code: e.code,
        fieldErrors: {for (final f in e.fieldErrors ?? const <FieldError>[]) f.path: f.message},
      );
    } on ServerpodClientUnauthorized {
      signOut();
      throw const SessionLost();
    } on ServerpodClientNetworkException {
      throw const GatewayException('Sem conexão com o servidor. Confira a internet e tente de novo.');
    } on ServerpodClientException {
      throw const GatewayException('O servidor não respondeu como esperado. Tente de novo.');
    }
  }
}

String? _blankToNull(String? text) {
  final trimmed = text?.trim();
  return trimmed == null || trimmed.isEmpty ? null : trimmed;
}

class _Bearer implements ClientAuthKeyProvider {
  _Bearer(this._token);

  final Future<String> Function() _token;

  @override
  Future<String?> get authHeaderValue async => wrapAsBearerAuthHeaderValue(await _token());
}
