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
import 'package:serverpod/serverpod.dart' as _is;
import '../identity_access/endpoints/auth_endpoint.dart' as _i077kp7v;
import '../identity_access/endpoints/me_endpoint.dart' as _i2zd8mbu;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
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
