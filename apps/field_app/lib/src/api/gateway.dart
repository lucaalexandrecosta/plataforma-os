import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

/// Tudo o que o app do técnico pede ao servidor. A implementação real é a
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

  /// Entra na empresa como técnico (exige o papel `technician`) e devolve o
  /// usuário com papéis e permissões.
  Future<MeInfo> enterTenant(String slug);

  /// Esquece os tokens (ficam só em memória nesta versão).
  void signOut();

  // ----------------------------------------------------------- agenda
  /// Técnico ligado ao login, ou nulo se o acesso não estiver ligado a um.
  Future<Technician?> myTechnician();

  /// Visitas do técnico com início planejado entre [from] e [to].
  Future<List<Visit>> myVisits(DateTime from, DateTime to);
  Future<Visit> visit(UuidValue id);
  Future<WorkOrderDetail> workOrder(UuidValue id);

  // ----------------------------------------------------------- execução
  Future<Visit> startTravel(Visit visit);
  Future<Visit> checkIn(Visit visit, VisitCheckIn input);
  Future<Visit> pause(Visit visit);
  Future<Visit> resume(Visit visit);
  Future<Visit> finish(Visit visit, VisitFinish input);
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
