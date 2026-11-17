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

  // ----------------------------------------------------------- usuários
  /// Perfis que o administrador pode atribuir.
  Future<List<AssignableRole>> assignableRoles();

  /// Pessoas com acesso à empresa (convidadas, ativas e suspensas).
  Future<List<TenantUser>> users();
  Future<TenantUser> inviteUser(String email, String fullName, List<String> roles);
  Future<TenantUser> setUserRoles(TenantUser user, List<String> roles);
  Future<TenantUser> suspendUser(TenantUser user);
  Future<TenantUser> reactivateUser(TenantUser user);
  Future<TenantUser> removeUser(TenantUser user);

  // ----------------------------------------------------------- etiquetas QR
  Future<List<QrTagBatch>> qrBatches();

  /// Gera de 1 a 500 etiquetas num lote novo.
  Future<QrTagBatch> generateQrBatch(int quantity, {String? notes});
  Future<List<QrTag>> qrBatchTags(UuidValue batchId);
  Future<QrTagBatch> markQrBatchPrinted(UuidValue batchId);

  /// Etiqueta pelo código curto, token ou URL.
  Future<QrTag> resolveQrTag(String scanned);
  Future<QrTag> bindQrTag(String scanned, UuidValue assetId);
  Future<QrTag> unbindQrTag(QrTag tag);
  Future<QrTag> revokeQrTag(QrTag tag, String reason, {String? note});

  // ----------------------------------------------------------- cadastros
  Future<List<Branch>> branches({bool includeInactive});
  Future<Branch> createBranch(BranchInput input);
  Future<Branch> updateBranch(Branch branch, BranchInput input);
  Future<List<CostCenter>> costCenters({bool includeInactive});
  Future<CostCenter> createCostCenter(CostCenterInput input);
  Future<CostCenter> updateCostCenter(CostCenter costCenter, CostCenterInput input);

  /// Equipamentos ativos; [search] procura no código e no nome.
  Future<List<ProductSummary>> products({String? search});
  Future<ProductSummary> createProduct(ProductInput input);
  Future<AssetPage> assets({String? search, int limit, int offset});
  Future<Asset> asset(UuidValue id);
  Future<Asset> createAsset(AssetInput input);
  Future<Asset> updateAsset(Asset asset, AssetInput input);

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

  // ----------------------------------------------------------- depreciação gerencial
  Future<DepreciationProfile?> depreciationProfile(UuidValue assetId);

  /// [expectedVersion] nulo cria a ficha; com valor, altera.
  Future<DepreciationProfile> saveDepreciationProfile(
    UuidValue assetId,
    int? expectedVersion,
    DepreciationProfileInput input,
  );
  Future<AssetDepreciation> depreciationSchedule(UuidValue assetId);
  Future<DepreciationPosition> depreciationPosition(int year, int month, {UuidValue? costCenterId});
  Future<List<DepreciationClosing>> depreciationClosings();
  Future<DepreciationClosing> closeDepreciation(int year, int month);
  Future<DepreciationClosing> reopenDepreciation(int year, int month, String reason);
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
