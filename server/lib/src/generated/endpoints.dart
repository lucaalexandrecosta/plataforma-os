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
import 'package:plataforma_os_server/src/generated/customers/models/customer_contact_filter.dart' as _ipdid8a4;
import 'package:plataforma_os_server/src/generated/customers/models/customer_contact_input.dart' as _i0rc22zw;
import 'package:plataforma_os_server/src/generated/customers/models/customer_contact_patch.dart' as _i8odeyb5;
import 'package:plataforma_os_server/src/generated/customers/models/customer_filter.dart' as _ipd66tax;
import 'package:plataforma_os_server/src/generated/customers/models/customer_input.dart' as _iw3fixvn;
import 'package:plataforma_os_server/src/generated/customers/models/customer_patch.dart' as _iw5xmx3u;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site_filter.dart' as _im9gx6w1;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site_input.dart' as _iv6e8owq;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site_patch.dart' as _iqxf8m4v;
import 'package:plataforma_os_server/src/generated/platform/paging/models/page_request.dart' as _i4pk1ojl;
import 'package:serverpod/serverpod.dart' as _is;
import '../customers/endpoints/customer_contacts_endpoint.dart' as _ihh0do94;
import '../customers/endpoints/customer_sites_endpoint.dart' as _icz6lfvl;
import '../customers/endpoints/customers_endpoint.dart' as _i2n45wl3;
import '../identity_access/endpoints/auth_endpoint.dart' as _i077kp7v;
import '../identity_access/endpoints/me_endpoint.dart' as _i2zd8mbu;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'customerContacts': _ihh0do94.CustomerContactsEndpoint()
        ..initialize(
          server,
          'customerContacts',
          null,
        ),
      'customerSites': _icz6lfvl.CustomerSitesEndpoint()
        ..initialize(
          server,
          'customerSites',
          null,
        ),
      'customers': _i2n45wl3.CustomersEndpoint()
        ..initialize(
          server,
          'customers',
          null,
        ),
      'auth': _i077kp7v.AuthEndpoint()
        ..initialize(
          server,
          'auth',
          null,
        ),
      'me': _i2zd8mbu.MeEndpoint()
        ..initialize(
          server,
          'me',
          null,
        ),
    };
    connectors['customerContacts'] = _is.EndpointConnector(
      name: 'customerContacts',
      endpoint: endpoints['customerContacts']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'filter': _is.ParameterDescription(
              name: 'filter',
              type: _is.getType<_ipdid8a4.CustomerContactFilter?>(),
              nullable: true,
            ),
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<_i4pk1ojl.PageRequest?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerContacts'] as _ihh0do94.CustomerContactsEndpoint).list(
                session,
                params['filter'],
                params['page'],
              ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerContacts'] as _ihh0do94.CustomerContactsEndpoint).get(
                session,
                params['id'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_i0rc22zw.CustomerContactInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerContacts'] as _ihh0do94.CustomerContactsEndpoint).create(
                session,
                params['input'],
              ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'patch': _is.ParameterDescription(
              name: 'patch',
              type: _is.getType<_i8odeyb5.CustomerContactPatch>(),
              nullable: false,
            ),
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerContacts'] as _ihh0do94.CustomerContactsEndpoint).update(
                session,
                params['id'],
                params['patch'],
                params['expectedVersion'],
              ),
        ),
        'approve': _is.MethodConnector(
          name: 'approve',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerContacts'] as _ihh0do94.CustomerContactsEndpoint).approve(
                session,
                params['id'],
                params['expectedVersion'],
              ),
        ),
        'block': _is.MethodConnector(
          name: 'block',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerContacts'] as _ihh0do94.CustomerContactsEndpoint).block(
                session,
                params['id'],
                params['reason'],
                params['expectedVersion'],
              ),
        ),
        'unblock': _is.MethodConnector(
          name: 'unblock',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerContacts'] as _ihh0do94.CustomerContactsEndpoint).unblock(
                session,
                params['id'],
                params['expectedVersion'],
              ),
        ),
        'deactivate': _is.MethodConnector(
          name: 'deactivate',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerContacts'] as _ihh0do94.CustomerContactsEndpoint).deactivate(
                session,
                params['id'],
                params['reason'],
                params['expectedVersion'],
              ),
        ),
        'reactivate': _is.MethodConnector(
          name: 'reactivate',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerContacts'] as _ihh0do94.CustomerContactsEndpoint).reactivate(
                session,
                params['id'],
                params['expectedVersion'],
              ),
        ),
      },
    );
    connectors['customerSites'] = _is.EndpointConnector(
      name: 'customerSites',
      endpoint: endpoints['customerSites']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'filter': _is.ParameterDescription(
              name: 'filter',
              type: _is.getType<_im9gx6w1.CustomerSiteFilter?>(),
              nullable: true,
            ),
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<_i4pk1ojl.PageRequest?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerSites'] as _icz6lfvl.CustomerSitesEndpoint).list(
                session,
                params['filter'],
                params['page'],
              ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerSites'] as _icz6lfvl.CustomerSitesEndpoint).get(
                session,
                params['id'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_iv6e8owq.CustomerSiteInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerSites'] as _icz6lfvl.CustomerSitesEndpoint).create(
                session,
                params['input'],
              ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'patch': _is.ParameterDescription(
              name: 'patch',
              type: _is.getType<_iqxf8m4v.CustomerSitePatch>(),
              nullable: false,
            ),
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerSites'] as _icz6lfvl.CustomerSitesEndpoint).update(
                session,
                params['id'],
                params['patch'],
                params['expectedVersion'],
              ),
        ),
        'deactivate': _is.MethodConnector(
          name: 'deactivate',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerSites'] as _icz6lfvl.CustomerSitesEndpoint).deactivate(
                session,
                params['id'],
                params['reason'],
                params['expectedVersion'],
              ),
        ),
        'reactivate': _is.MethodConnector(
          name: 'reactivate',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customerSites'] as _icz6lfvl.CustomerSitesEndpoint).reactivate(
                session,
                params['id'],
                params['expectedVersion'],
              ),
        ),
      },
    );
    connectors['customers'] = _is.EndpointConnector(
      name: 'customers',
      endpoint: endpoints['customers']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'filter': _is.ParameterDescription(
              name: 'filter',
              type: _is.getType<_ipd66tax.CustomerFilter?>(),
              nullable: true,
            ),
            'page': _is.ParameterDescription(
              name: 'page',
              type: _is.getType<_i4pk1ojl.PageRequest?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customers'] as _i2n45wl3.CustomersEndpoint).list(
                session,
                params['filter'],
                params['page'],
              ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customers'] as _i2n45wl3.CustomersEndpoint).get(
                session,
                params['id'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_iw3fixvn.CustomerInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customers'] as _i2n45wl3.CustomersEndpoint).create(
                session,
                params['input'],
              ),
        ),
        'update': _is.MethodConnector(
          name: 'update',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'patch': _is.ParameterDescription(
              name: 'patch',
              type: _is.getType<_iw5xmx3u.CustomerPatch>(),
              nullable: false,
            ),
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customers'] as _i2n45wl3.CustomersEndpoint).update(
                session,
                params['id'],
                params['patch'],
                params['expectedVersion'],
              ),
        ),
        'deactivate': _is.MethodConnector(
          name: 'deactivate',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customers'] as _i2n45wl3.CustomersEndpoint).deactivate(
                session,
                params['id'],
                params['reason'],
                params['expectedVersion'],
              ),
        ),
        'reactivate': _is.MethodConnector(
          name: 'reactivate',
          params: {
            'id': _is.ParameterDescription(
              name: 'id',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['customers'] as _i2n45wl3.CustomersEndpoint).reactivate(
                session,
                params['id'],
                params['expectedVersion'],
              ),
        ),
      },
    );
    connectors['auth'] = _is.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'exchangeIdpToken': _is.MethodConnector(
          name: 'exchangeIdpToken',
          params: {
            'idpToken': _is.ParameterDescription(
              name: 'idpToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'tenantSlug': _is.ParameterDescription(
              name: 'tenantSlug',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i077kp7v.AuthEndpoint).exchangeIdpToken(
                session,
                params['idpToken'],
                params['tenantSlug'],
              ),
        ),
      },
    );
    connectors['me'] = _is.EndpointConnector(
      name: 'me',
      endpoint: endpoints['me']!,
      methodConnectors: {
        'get': _is.MethodConnector(
          name: 'get',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['me'] as _i2zd8mbu.MeEndpoint).get(session),
        ),
        'tenants': _is.MethodConnector(
          name: 'tenants',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['me'] as _i2zd8mbu.MeEndpoint).tenants(session),
        ),
      },
    );
  }
}
