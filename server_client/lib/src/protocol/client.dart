/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:http/http.dart' as _i85jenna;
import 'package:plataforma_os_client/src/protocol/identity_access/models/me_info.dart' as _i8cz5om6;
import 'package:plataforma_os_client/src/protocol/identity_access/models/tenant_token.dart' as _ii663qav;
import 'package:plataforma_os_client/src/protocol/tenancy/models/tenant_summary.dart' as _i11upz4e;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart' as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart' as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// `auth.*` — escolha do tenant depois do login por e-mail e senha.
///
/// Exige a sessão de login do módulo (`emailIdp.login`), sem escopo: o token
/// de tenant não é aceito aqui.
/// {@category Endpoint}
class EndpointAuth extends _isc.EndpointRef {
  EndpointAuth(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Troca a sessão de login por um token de tenant (10 min).
  ///
  /// [technicianApp] = chamada do app de campo: exige papel de técnico ou
  /// coordenador.
  ///
  /// Erros: `UNAUTHENTICATED` (sem sessão de login), `FORBIDDEN` (sem vínculo
  /// no tenant, ou tenant inexistente), `TENANT_SUSPENDED`.
  _ida.Future<_ii663qav.TenantToken> selectTenant(
    String tenantSlug, {
    bool? technicianApp,
  }) => caller.callServerEndpoint<_ii663qav.TenantToken>(
    'auth',
    'selectTenant',
    {
      'tenantSlug': tenantSlug,
      'technicianApp': technicianApp,
    },
  );
}

/// `emailIdp.*` — login por e-mail e senha (módulo do Serverpod).
///
/// Cada método anexa o contexto anônimo antes de tocar no banco (as tabelas do
/// módulo ficam em `public`, fora da RLS). O cadastro só abre para e-mails
/// convidados: para os demais responde um id aleatório, igual ao que o módulo
/// faz para e-mail já cadastrado, sem revelar se o e-mail existe.
/// {@category Endpoint}
class EndpointEmailIdp extends _iaic.EndpointEmailIdpBase {
  EndpointEmailIdp(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'emailIdp';

  @override
  _ida.Future<_iacc.AuthSuccess> login({
    required String email,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'login',
    {
      'email': email,
      'password': password,
    },
  );

  @override
  _ida.Future<_isc.UuidValue> startRegistration({required String email}) => caller.callServerEndpoint<_isc.UuidValue>(
    'emailIdp',
    'startRegistration',
    {'email': email},
  );

  @override
  _ida.Future<String> verifyRegistrationCode({
    required _isc.UuidValue accountRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyRegistrationCode',
    {
      'accountRequestId': accountRequestId,
      'verificationCode': verificationCode,
    },
  );

  @override
  _ida.Future<_iacc.AuthSuccess> finishRegistration({
    required String registrationToken,
    required String password,
  }) => caller.callServerEndpoint<_iacc.AuthSuccess>(
    'emailIdp',
    'finishRegistration',
    {
      'registrationToken': registrationToken,
      'password': password,
    },
  );

  @override
  _ida.Future<_isc.UuidValue> startPasswordReset({required String email}) => caller.callServerEndpoint<_isc.UuidValue>(
    'emailIdp',
    'startPasswordReset',
    {'email': email},
  );

  @override
  _ida.Future<String> verifyPasswordResetCode({
    required _isc.UuidValue passwordResetRequestId,
    required String verificationCode,
  }) => caller.callServerEndpoint<String>(
    'emailIdp',
    'verifyPasswordResetCode',
    {
      'passwordResetRequestId': passwordResetRequestId,
      'verificationCode': verificationCode,
    },
  );

  @override
  _ida.Future<void> finishPasswordReset({
    required String finishPasswordResetToken,
    required String newPassword,
  }) => caller.callServerEndpoint<void>(
    'emailIdp',
    'finishPasswordReset',
    {
      'finishPasswordResetToken': finishPasswordResetToken,
      'newPassword': newPassword,
    },
  );

  @override
  _ida.Future<bool> hasAccount() => caller.callServerEndpoint<bool>(
    'emailIdp',
    'hasAccount',
    {},
  );
}

/// `me.*` — usuário autenticado, tenant ativo e permissões (docs/08 §3.2).
/// {@category Endpoint}
class EndpointMe extends EndpointStaff {
  EndpointMe(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'me';

  /// Usuário, tenant ativo, papéis e permissões efetivas, relidos do banco.
  _ida.Future<_i8cz5om6.MeInfo> get() => caller.callServerEndpoint<_i8cz5om6.MeInfo>(
    'me',
    'get',
    {},
  );

  /// Tenants em que o usuário tem vínculo, para a troca de tenant.
  _ida.Future<List<_i11upz4e.TenantSummary>> tenants() => caller.callServerEndpoint<List<_i11upz4e.TenantSummary>>(
    'me',
    'tenants',
    {},
  );
}

/// `refreshJwtTokens.*` — renova a sessão de login (refresh token do módulo).
/// {@category Endpoint}
class EndpointRefreshJwtTokens extends _iacc.EndpointRefreshJwtTokens {
  EndpointRefreshJwtTokens(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'refreshJwtTokens';

  @override
  _ida.Future<_iacc.AuthSuccess> refreshAccessToken({String? refreshToken}) =>
      caller.callServerEndpoint<_iacc.AuthSuccess>(
        'refreshJwtTokens',
        'refreshAccessToken',
        {'refreshToken': refreshToken},
        authenticated: false,
      );
}

/// Classes-base por tipo de token (docs/08 §2.2): um token de contato nunca
/// passa num endpoint da equipe e vice-versa. A permissão fina (papel, escopo
/// de carteira, prestador ou filial) é conferida por método.
/// Backoffice e técnico: exige token de tenant (`aud = plataforma-os:staff`).
/// {@category Endpoint}
abstract class EndpointStaff extends _isc.EndpointRef {
  EndpointStaff(_isc.EndpointCaller caller) : super(caller);
}

/// App do cliente: exige token de contato.
/// {@category Endpoint}
abstract class EndpointCustomer extends _isc.EndpointRef {
  EndpointCustomer(_isc.EndpointCaller caller) : super(caller);
}

/// Métodos públicos (QR, OTP, troca de token). Cada método chama
/// `session.useAnonymousContext()` antes de usar o banco.
///
/// Atenção: todo método público de uma classe de endpoint vira RPC no
/// Serverpod; helpers ficam em extensões ou em `internal/`, nunca aqui.
/// {@category Endpoint}
abstract class EndpointPublic extends _isc.EndpointRef {
  EndpointPublic(_isc.EndpointCaller caller) : super(caller);
}

class Modules {
  Modules(Client client) {
    serverpod_auth_idp = _iaic.Caller(client);
    serverpod_auth_core = _iacc.Caller(client);
  }

  late final _iaic.Caller serverpod_auth_idp;

  late final _iacc.Caller serverpod_auth_core;
}

class Client extends _isc.ServerpodClientShared {
  Client(
    String host, {
    dynamic securityContext,
    Duration? streamingConnectionTimeout,
    Duration? connectionTimeout,
    Function(
      _isc.MethodCallContext,
      Object,
      StackTrace,
    )?
    onFailedCall,
    Function(_isc.MethodCallContext)? onSucceededCall,
    bool? disconnectStreamsOnLostInternetConnection,
    _i85jenna.Client? httpClientOverride,
  }) : super(
         host,
         _il2as5qe.Protocol(),
         securityContext: securityContext,
         streamingConnectionTimeout: streamingConnectionTimeout,
         connectionTimeout: connectionTimeout,
         onFailedCall: onFailedCall,
         onSucceededCall: onSucceededCall,
         disconnectStreamsOnLostInternetConnection: disconnectStreamsOnLostInternetConnection,
         httpClientOverride: httpClientOverride,
       ) {
    auth = EndpointAuth(this);
    emailIdp = EndpointEmailIdp(this);
    me = EndpointMe(this);
    refreshJwtTokens = EndpointRefreshJwtTokens(this);
    modules = Modules(this);
  }

  late final EndpointAuth auth;

  late final EndpointEmailIdp emailIdp;

  late final EndpointMe me;

  late final EndpointRefreshJwtTokens refreshJwtTokens;

  late final Modules modules;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'auth': auth,
    'emailIdp': emailIdp,
    'me': me,
    'refreshJwtTokens': refreshJwtTokens,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {
    'serverpod_auth_idp': modules.serverpod_auth_idp,
    'serverpod_auth_core': modules.serverpod_auth_core,
  };
}
