import 'package:serverpod/serverpod.dart';

/// Tipo do ator, gravado em `app.actor_type` (auditoria e guardas do banco).
enum ActorType {
  user('user'),
  technician('technician'),
  customerContact('customer_contact'),
  platformSupport('platform_support'),
  system('system'),
  integration('integration'),

  /// Chamada pública sem login (QR, OTP, troca de token). Sem tenant: a RLS
  /// devolve zero linhas de tenant, e só as funções SECURITY DEFINER previstas
  /// enxergam entre tenants.
  anonymous('anonymous');

  const ActorType(this.dbValue);

  final String dbValue;
}

/// Contexto imutável de uma chamada, job ou mensagem (docs/02 §5.1).
///
/// Regra 1: o `tenantId` nunca vem de parâmetro, corpo ou caminho — só do
/// token validado ou do resultado das funções SECURITY DEFINER do QR.
final class RequestContext {
  const RequestContext._({
    required this.actorType,
    required this.correlationId,
    this.tenantId,
    this.userId,
    this.membershipId,
    this.sessionId,
    this.deviceId,
    this.roles = const {},
  });

  /// Ator autenticado com tenant ativo (token de tenant ou de contato).
  factory RequestContext.tenant({
    required UuidValue tenantId,
    required UuidValue userId,
    required ActorType actorType,
    required String correlationId,
    UuidValue? membershipId,
    String? sessionId,
    UuidValue? deviceId,
    Set<String> roles = const {},
  }) => RequestContext._(
    actorType: actorType,
    correlationId: correlationId,
    tenantId: tenantId,
    userId: userId,
    membershipId: membershipId,
    sessionId: sessionId,
    deviceId: deviceId,
    roles: roles,
  );

  /// Usuário identificado que ainda não escolheu o tenant (troca de token,
  /// `me.tenants`): a RLS libera só os próprios vínculos (own_memberships_read).
  factory RequestContext.userWithoutTenant({
    required UuidValue userId,
    required String correlationId,
  }) => RequestContext._(actorType: ActorType.user, correlationId: correlationId, userId: userId);

  /// Chamada pública, sem login.
  factory RequestContext.anonymous({required String correlationId}) =>
      RequestContext._(actorType: ActorType.anonymous, correlationId: correlationId);

  /// Job do worker. [tenantId] nulo só para jobs de plataforma (lista explícita).
  factory RequestContext.system({
    required String correlationId,
    UuidValue? tenantId,
    ActorType actorType = ActorType.system,
  }) => RequestContext._(actorType: actorType, correlationId: correlationId, tenantId: tenantId);

  final ActorType actorType;
  final UuidValue? tenantId;
  final UuidValue? userId;
  final UuidValue? membershipId;

  /// `sid` do token (sessão do IdP ou `auth_sessions.id`), para revogação.
  final String? sessionId;
  final UuidValue? deviceId;

  /// Papéis do vínculo. A autorização reavalia pelo banco (docs/04 §5).
  final Set<String> roles;
  final String correlationId;

  bool get hasTenant => tenantId != null;

  /// Pode ser substituído por um contexto mais específico na mesma sessão
  /// (ex.: a troca de token começa anônima e identifica o usuário).
  bool get isRefinable => actorType == ActorType.anonymous || (tenantId == null && actorType == ActorType.user);

  /// Valores de `set_config(..., true)` aplicados no início de toda transação.
  Map<String, String> get sessionVariables => {
    'app.tenant_id': tenantId?.uuid ?? '',
    'app.user_id': userId?.uuid ?? '',
    'app.actor_type': actorType.dbValue,
    'app.correlation_id': correlationId,
  };

  @override
  String toString() =>
      'RequestContext(${actorType.dbValue}, tenant: ${tenantId?.uuid ?? '-'}, '
      'user: ${userId?.uuid ?? '-'}, correlation: $correlationId)';
}

/// Erro de programação: operação de banco sem contexto. Nunca chega ao cliente
/// como detalhe (vira erro 500 genérico) e deve quebrar os testes.
final class MissingRequestContextError extends StateError {
  MissingRequestContextError(String operation)
    : super(
        'Operação de banco "$operation" sem RequestContext. Todo endpoint, rota e job '
        'precisa anexar o contexto (session.attachContext) antes de acessar o banco.',
      );
}

final _contexts = Expando<RequestContext>('RequestContext');

extension RequestContextSession on Session {
  /// Contexto anexado pelo handler de autenticação, pela rota pública ou pelo
  /// laço do worker; `null` se ninguém anexou.
  RequestContext? get contextOrNull => _contexts[this];

  RequestContext get context => _contexts[this] ?? (throw MissingRequestContextError('context'));

  /// Anexa o contexto. Um contexto com tenant é definitivo; só um contexto
  /// anônimo ou de usuário sem tenant pode ser refinado depois.
  void attachContext(RequestContext context) {
    final current = _contexts[this];
    if (current != null && !current.isRefinable) {
      throw StateError('RequestContext já definido nesta sessão ($current); não pode ser trocado.');
    }
    _contexts[this] = context;
  }

  /// `X-Request-Id`/`traceparent` serão lidos aqui quando a observabilidade
  /// entrar (docs/02 §5.10); por enquanto, o id da sessão do Serverpod.
  String get correlationId => sessionId.uuid;
}
