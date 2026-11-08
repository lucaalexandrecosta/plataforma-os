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
import 'package:plataforma_os_client/src/protocol/customers/models/customer.dart' as _isrde2pn;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_contact.dart' as _iicdz276;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_contact_filter.dart' as _i9rfeui9;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_contact_input.dart' as _ixru6art;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_contact_page.dart' as _is39dqw1;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_contact_patch.dart' as _iks49tp6;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_filter.dart' as _it5zcv8o;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_input.dart' as _il30a9yx;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_page.dart' as _igrzlp6q;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_patch.dart' as _iv7lbpqh;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_site.dart' as _iq0mn52n;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_site_filter.dart' as _itjpt449;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_site_input.dart' as _i10zqbaj;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_site_page.dart' as _iwv5pqpt;
import 'package:plataforma_os_client/src/protocol/customers/models/customer_site_patch.dart' as _indfb8jf;
import 'package:plataforma_os_client/src/protocol/identity_access/models/me_info.dart' as _i8cz5om6;
import 'package:plataforma_os_client/src/protocol/identity_access/models/tenant_token.dart' as _ii663qav;
import 'package:plataforma_os_client/src/protocol/platform/paging/models/page_request.dart' as _iiqqgmzw;
import 'package:plataforma_os_client/src/protocol/tenancy/models/tenant_summary.dart' as _i11upz4e;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'protocol.dart' as _il2as5qe;

/// `customerContacts` (docs/08 §3.1). Escrita: `customers.manage`; leitura:
/// papéis internos. Faltam `invite` (com as notificações) e `revokeSessions`
/// (com o login do contato por OTP).
/// {@category Endpoint}
class EndpointCustomerContacts extends EndpointStaff {
  EndpointCustomerContacts(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'customerContacts';

  _ida.Future<_is39dqw1.CustomerContactPage> list(
    _i9rfeui9.CustomerContactFilter? filter,
    _iiqqgmzw.PageRequest? page,
  ) => caller.callServerEndpoint<_is39dqw1.CustomerContactPage>(
    'customerContacts',
    'list',
    {
      'filter': filter,
      'page': page,
    },
  );

  _ida.Future<_iicdz276.CustomerContact> get(_isc.UuidValue id) => caller.callServerEndpoint<_iicdz276.CustomerContact>(
    'customerContacts',
    'get',
    {'id': id},
  );

  _ida.Future<_iicdz276.CustomerContact> create(_ixru6art.CustomerContactInput input) =>
      caller.callServerEndpoint<_iicdz276.CustomerContact>(
        'customerContacts',
        'create',
        {'input': input},
      );

  _ida.Future<_iicdz276.CustomerContact> update(
    _isc.UuidValue id,
    _iks49tp6.CustomerContactPatch patch,
    int expectedVersion,
  ) => caller.callServerEndpoint<_iicdz276.CustomerContact>(
    'customerContacts',
    'update',
    {
      'id': id,
      'patch': patch,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_iicdz276.CustomerContact> approve(
    _isc.UuidValue id,
    int expectedVersion,
  ) => caller.callServerEndpoint<_iicdz276.CustomerContact>(
    'customerContacts',
    'approve',
    {
      'id': id,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_iicdz276.CustomerContact> block(
    _isc.UuidValue id,
    String reason,
    int expectedVersion,
  ) => caller.callServerEndpoint<_iicdz276.CustomerContact>(
    'customerContacts',
    'block',
    {
      'id': id,
      'reason': reason,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_iicdz276.CustomerContact> unblock(
    _isc.UuidValue id,
    int expectedVersion,
  ) => caller.callServerEndpoint<_iicdz276.CustomerContact>(
    'customerContacts',
    'unblock',
    {
      'id': id,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_iicdz276.CustomerContact> deactivate(
    _isc.UuidValue id,
    String reason,
    int expectedVersion,
  ) => caller.callServerEndpoint<_iicdz276.CustomerContact>(
    'customerContacts',
    'deactivate',
    {
      'id': id,
      'reason': reason,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_iicdz276.CustomerContact> reactivate(
    _isc.UuidValue id,
    int expectedVersion,
  ) => caller.callServerEndpoint<_iicdz276.CustomerContact>(
    'customerContacts',
    'reactivate',
    {
      'id': id,
      'expectedVersion': expectedVersion,
    },
  );
}

/// `customerSites` (docs/08 §3.1). Escrita: `customers.manage`; leitura:
/// papéis internos. Falta `geocode` (provedor de geocodificação a escolher).
/// {@category Endpoint}
class EndpointCustomerSites extends EndpointStaff {
  EndpointCustomerSites(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'customerSites';

  _ida.Future<_iwv5pqpt.CustomerSitePage> list(
    _itjpt449.CustomerSiteFilter? filter,
    _iiqqgmzw.PageRequest? page,
  ) => caller.callServerEndpoint<_iwv5pqpt.CustomerSitePage>(
    'customerSites',
    'list',
    {
      'filter': filter,
      'page': page,
    },
  );

  _ida.Future<_iq0mn52n.CustomerSite> get(_isc.UuidValue id) => caller.callServerEndpoint<_iq0mn52n.CustomerSite>(
    'customerSites',
    'get',
    {'id': id},
  );

  _ida.Future<_iq0mn52n.CustomerSite> create(_i10zqbaj.CustomerSiteInput input) =>
      caller.callServerEndpoint<_iq0mn52n.CustomerSite>(
        'customerSites',
        'create',
        {'input': input},
      );

  _ida.Future<_iq0mn52n.CustomerSite> update(
    _isc.UuidValue id,
    _indfb8jf.CustomerSitePatch patch,
    int expectedVersion,
  ) => caller.callServerEndpoint<_iq0mn52n.CustomerSite>(
    'customerSites',
    'update',
    {
      'id': id,
      'patch': patch,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_iq0mn52n.CustomerSite> deactivate(
    _isc.UuidValue id,
    String reason,
    int expectedVersion,
  ) => caller.callServerEndpoint<_iq0mn52n.CustomerSite>(
    'customerSites',
    'deactivate',
    {
      'id': id,
      'reason': reason,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_iq0mn52n.CustomerSite> reactivate(
    _isc.UuidValue id,
    int expectedVersion,
  ) => caller.callServerEndpoint<_iq0mn52n.CustomerSite>(
    'customerSites',
    'reactivate',
    {
      'id': id,
      'expectedVersion': expectedVersion,
    },
  );
}

/// `customers` (docs/08 §3.1). Escrita: tenant_admin, dispatcher e
/// backoffice_agent (`customers.manage`); leitura: papéis internos.
/// Faltam do padrão: `audit`, `export` e os métodos próprios por cliente
/// (`listSites`, `listContacts`, `listAssets`, `listWorkOrders`).
/// {@category Endpoint}
class EndpointCustomers extends EndpointStaff {
  EndpointCustomers(_isc.EndpointCaller caller) : super(caller);

  @override
  String get name => 'customers';

  _ida.Future<_igrzlp6q.CustomerPage> list(
    _it5zcv8o.CustomerFilter? filter,
    _iiqqgmzw.PageRequest? page,
  ) => caller.callServerEndpoint<_igrzlp6q.CustomerPage>(
    'customers',
    'list',
    {
      'filter': filter,
      'page': page,
    },
  );

  _ida.Future<_isrde2pn.Customer> get(_isc.UuidValue id) => caller.callServerEndpoint<_isrde2pn.Customer>(
    'customers',
    'get',
    {'id': id},
  );

  _ida.Future<_isrde2pn.Customer> create(_il30a9yx.CustomerInput input) =>
      caller.callServerEndpoint<_isrde2pn.Customer>(
        'customers',
        'create',
        {'input': input},
      );

  _ida.Future<_isrde2pn.Customer> update(
    _isc.UuidValue id,
    _iv7lbpqh.CustomerPatch patch,
    int expectedVersion,
  ) => caller.callServerEndpoint<_isrde2pn.Customer>(
    'customers',
    'update',
    {
      'id': id,
      'patch': patch,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_isrde2pn.Customer> deactivate(
    _isc.UuidValue id,
    String reason,
    int expectedVersion,
  ) => caller.callServerEndpoint<_isrde2pn.Customer>(
    'customers',
    'deactivate',
    {
      'id': id,
      'reason': reason,
      'expectedVersion': expectedVersion,
    },
  );

  _ida.Future<_isrde2pn.Customer> reactivate(
    _isc.UuidValue id,
    int expectedVersion,
  ) => caller.callServerEndpoint<_isrde2pn.Customer>(
    'customers',
    'reactivate',
    {
      'id': id,
      'expectedVersion': expectedVersion,
    },
  );
}

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
    customerContacts = EndpointCustomerContacts(this);
    customerSites = EndpointCustomerSites(this);
    customers = EndpointCustomers(this);
    auth = EndpointAuth(this);
    me = EndpointMe(this);
  }

  late final EndpointCustomerContacts customerContacts;

  late final EndpointCustomerSites customerSites;

  late final EndpointCustomers customers;

  late final EndpointAuth auth;

  late final EndpointMe me;

  @override
  Map<String, _isc.EndpointRef> get endpointRefLookup => {
    'customerContacts': customerContacts,
    'customerSites': customerSites,
    'customers': customers,
    'auth': auth,
    'me': me,
  };

  @override
  Map<String, _isc.ModuleEndpointCaller> get moduleLookup => {};
}
