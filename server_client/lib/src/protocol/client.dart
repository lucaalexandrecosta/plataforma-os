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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// `auth.*` — métodos sem login (o token do Keycloak vem como parâmetro).
/// {@category Endpoint}
class EndpointAuth extends EndpointPublic {
  EndpointAuth(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'auth';

  /// Troca o access token do Keycloak (realm `staff`) por um token de tenant.
  ///
  /// Erros: `UNAUTHENTICATED` (token do IdP inválido), `FORBIDDEN` (sem vínculo
  /// ativo no tenant, ou tenant inexistente), `TENANT_SUSPENDED`.
  _ida.Future<_ii663qav.TenantToken> exchangeIdpToken(
    String idpToken,
    String tenantSlug,
  ) => caller.callServerEndpoint<_ii663qav.TenantToken>(
    'auth',
    'exchangeIdpToken',
    {
      'idpToken': idpToken,
      'tenantSlug': tenantSlug,
    },
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
    me = EndpointMe(this);
  }

  late final EndpointAuth auth;

  late final EndpointMe me;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'auth': auth,
    'me': me,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {};
}
