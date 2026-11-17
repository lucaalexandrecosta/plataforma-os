import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart' show AuthSuccess;
import 'package:serverpod_client/serverpod_client.dart';

import 'gateway.dart';

/// [Gateway] sobre o cliente gerado do Serverpod.
///
/// Tokens só em memória nesta primeira versão: a sessão de login (10 min,
/// renovada pelo refresh token de 14 dias) e o token da empresa (10 min, pedido
/// de novo a `auth.selectTenant` com `technicianApp` antes de vencer). Guardar o
/// refresh token no `flutter_secure_storage` (docs/04 §4.4) entra junto com o
/// banco local e o sync offline.
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
    final issued = await _login.auth.selectTenant(slug, technicianApp: true);
    _tenantAccess = issued.accessToken;
    _tenantExpiresAt = DateTime.now().add(Duration(seconds: issued.expiresIn));
    return issued.accessToken;
  }

  // ----------------------------------------------------------- agenda

  @override
  Future<Technician?> myTechnician() => _guard(() => _tenant.technicians.mine());

  @override
  Future<List<Visit>> myVisits(DateTime from, DateTime to) =>
      _guard(() => _tenant.visits.mine(from.toUtc(), to.toUtc()));

  @override
  Future<Visit> visit(UuidValue id) => _guard(() => _tenant.visits.get(id));

  @override
  Future<WorkOrderDetail> workOrder(UuidValue id) => _guard(() => _tenant.workOrders.get(id));

  // ----------------------------------------------------------- execução

  @override
  Future<Visit> startTravel(Visit visit) => _guard(() => _tenant.visits.startTravel(visit.id, visit.version));

  @override
  Future<Visit> checkIn(Visit visit, VisitCheckIn input) =>
      _guard(() => _tenant.visits.checkIn(visit.id, visit.version, input));

  @override
  Future<Visit> pause(Visit visit) => _guard(() => _tenant.visits.pause(visit.id, visit.version));

  @override
  Future<Visit> resume(Visit visit) => _guard(() => _tenant.visits.resume(visit.id, visit.version));

  @override
  Future<Visit> finish(Visit visit, VisitFinish input) =>
      _guard(() => _tenant.visits.finish(visit.id, visit.version, input));

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

class _Bearer implements ClientAuthKeyProvider {
  _Bearer(this._token);

  final Future<String> Function() _token;

  @override
  Future<String?> get authHeaderValue async => wrapAsBearerAuthHeaderValue(await _token());
}
