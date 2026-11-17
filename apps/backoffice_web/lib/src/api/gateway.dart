import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

/// Tudo o que o backoffice pede ao servidor. A implementação real é a
/// [ServerGateway]; os testes de widget usam uma falsa.
abstract interface class Gateway {
  // ----------------------------------------------------------- login
  /// Entra com e-mail e senha (sessão de login, ainda sem empresa).
  Future<void> login(String email, String password);

  /// Primeiro acesso: pede o código enviado ao e-mail convidado.
  Future<UuidValue> startRegistration(String email);

  /// Primeiro acesso: confere o código e cria a senha (já entra).
  Future<void> finishRegistration(UuidValue requestId, String code, String password);

  /// Empresas em que a sessão de login pode entrar.
  Future<List<TenantSummary>> myTenants();

  /// Entra na empresa e devolve o usuário com papéis e permissões.
  Future<MeInfo> enterTenant(String slug);

  /// Esquece os tokens (ficam só em memória).
  void signOut();

  // ----------------------------------------------------------- cadastros
  Future<List<Branch>> branches();
  Future<List<CostCenter>> costCenters();
  Future<AssetPage> assets({String? search, int limit, int offset});
  Future<Asset> asset(UuidValue id);

  // ----------------------------------------------------------- OS
  Future<WorkOrderPage> workOrders({
    String? search,
    List<String>? statuses,
    bool openOnly,
    UuidValue? assetId,
    int limit,
    int offset,
  });
  Future<WorkOrderDetail> workOrder(UuidValue id);
  Future<List<WorkOrderType>> workOrderTypes();
  Future<WorkOrderDetail> openWorkOrder(WorkOrderInput input);
  Future<WorkOrder> startWorkOrder(WorkOrder wo);
  Future<WorkOrder> holdWorkOrder(WorkOrder wo, String holdReason, String? note);
  Future<WorkOrder> completeWorkOrder(WorkOrder wo, String resolutionNotes);
  Future<WorkOrder> closeWorkOrder(WorkOrder wo);
  Future<WorkOrder> cancelWorkOrder(WorkOrder wo, String reason, String? note);
  Future<WorkOrder> reopenWorkOrder(WorkOrder wo, String reason);

  // ----------------------------------------------------------- agenda
  Future<List<Technician>> technicians({bool includeInactive});
  Future<Technician> createTechnician(TechnicianInput input);
  Future<Technician> updateTechnician(Technician technician, TechnicianInput input);

  /// Visitas que começam em [from, to) (até 62 dias).
  Future<List<Visit>> agenda(DateTime from, DateTime to, {UuidValue? technicianId, bool includeCancelled});
  Future<List<Visit>> visitsOfWorkOrder(UuidValue workOrderId);
  Future<Visit> scheduleVisit(UuidValue workOrderId, VisitInput input);
  Future<Visit> rescheduleVisit(Visit visit, VisitInput input);
  Future<Visit> cancelVisit(Visit visit, String reason);
}

/// Erro para mostrar à pessoa. [code] é o código do catálogo de erros do
/// servidor (`VERSION_MISMATCH`, `FORBIDDEN`...), quando houver.
class GatewayException implements Exception {
  const GatewayException(this.message, {this.code, this.fieldErrors = const {}});

  final String message;
  final String? code;

  /// Mensagem por campo (`field` → mensagem), para os formulários.
  final Map<String, String> fieldErrors;

  @override
  String toString() => message;
}

/// A sessão de login venceu ou foi recusada: é preciso entrar de novo.
class SessionLost extends GatewayException {
  const SessionLost() : super('Sua sessão expirou. Entre de novo.', code: 'UNAUTHENTICATED');
}
