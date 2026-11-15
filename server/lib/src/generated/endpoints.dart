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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart' as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart' as _iais;
import '../identity_access/endpoints/auth_endpoint.dart' as _i077kp7v;
import '../identity_access/endpoints/email_idp_endpoint.dart' as _iq8d1u02;
import '../identity_access/endpoints/me_endpoint.dart' as _i2zd8mbu;
import '../identity_access/endpoints/refresh_jwt_tokens_endpoint.dart' as _inemdtdo;
import '../identity_access/endpoints/users_endpoint.dart' as _if041dc0;

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
      'emailIdp': _iq8d1u02.EmailIdpEndpoint()
        ..initialize(
          server,
          'emailIdp',
          null,
        ),
      'me': _i2zd8mbu.MeEndpoint()
        ..initialize(
          server,
          'me',
          null,
        ),
      'refreshJwtTokens': _inemdtdo.RefreshJwtTokensEndpoint()
        ..initialize(
          server,
          'refreshJwtTokens',
          null,
        ),
      'users': _if041dc0.UsersEndpoint()
        ..initialize(
          server,
          'users',
          null,
        ),
    };
    connectors['auth'] = _is.EndpointConnector(
      name: 'auth',
      endpoint: endpoints['auth']!,
      methodConnectors: {
        'selectTenant': _is.MethodConnector(
          name: 'selectTenant',
          params: {
            'tenantSlug': _is.ParameterDescription(
              name: 'tenantSlug',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'technicianApp': _is.ParameterDescription(
              name: 'technicianApp',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i077kp7v.AuthEndpoint).selectTenant(
                session,
                params['tenantSlug'],
                technicianApp: params['technicianApp'],
              ),
        ),
      },
    );
    connectors['emailIdp'] = _is.EndpointConnector(
      name: 'emailIdp',
      endpoint: endpoints['emailIdp']!,
      methodConnectors: {
        'login': _is.MethodConnector(
          name: 'login',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iq8d1u02.EmailIdpEndpoint).login(
                session,
                email: params['email'],
                password: params['password'],
              ),
        ),
        'startRegistration': _is.MethodConnector(
          name: 'startRegistration',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iq8d1u02.EmailIdpEndpoint).startRegistration(
                session,
                email: params['email'],
              ),
        ),
        'verifyRegistrationCode': _is.MethodConnector(
          name: 'verifyRegistrationCode',
          params: {
            'accountRequestId': _is.ParameterDescription(
              name: 'accountRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iq8d1u02.EmailIdpEndpoint).verifyRegistrationCode(
                session,
                accountRequestId: params['accountRequestId'],
                verificationCode: params['verificationCode'],
              ),
        ),
        'finishRegistration': _is.MethodConnector(
          name: 'finishRegistration',
          params: {
            'registrationToken': _is.ParameterDescription(
              name: 'registrationToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'password': _is.ParameterDescription(
              name: 'password',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iq8d1u02.EmailIdpEndpoint).finishRegistration(
                session,
                registrationToken: params['registrationToken'],
                password: params['password'],
              ),
        ),
        'startPasswordReset': _is.MethodConnector(
          name: 'startPasswordReset',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iq8d1u02.EmailIdpEndpoint).startPasswordReset(
                session,
                email: params['email'],
              ),
        ),
        'verifyPasswordResetCode': _is.MethodConnector(
          name: 'verifyPasswordResetCode',
          params: {
            'passwordResetRequestId': _is.ParameterDescription(
              name: 'passwordResetRequestId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'verificationCode': _is.ParameterDescription(
              name: 'verificationCode',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iq8d1u02.EmailIdpEndpoint).verifyPasswordResetCode(
                session,
                passwordResetRequestId: params['passwordResetRequestId'],
                verificationCode: params['verificationCode'],
              ),
        ),
        'finishPasswordReset': _is.MethodConnector(
          name: 'finishPasswordReset',
          params: {
            'finishPasswordResetToken': _is.ParameterDescription(
              name: 'finishPasswordResetToken',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'newPassword': _is.ParameterDescription(
              name: 'newPassword',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iq8d1u02.EmailIdpEndpoint).finishPasswordReset(
                session,
                finishPasswordResetToken: params['finishPasswordResetToken'],
                newPassword: params['newPassword'],
              ),
        ),
        'hasAccount': _is.MethodConnector(
          name: 'hasAccount',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['emailIdp'] as _iq8d1u02.EmailIdpEndpoint).hasAccount(session),
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
    connectors['refreshJwtTokens'] = _is.EndpointConnector(
      name: 'refreshJwtTokens',
      endpoint: endpoints['refreshJwtTokens']!,
      methodConnectors: {
        'refreshAccessToken': _is.MethodConnector(
          name: 'refreshAccessToken',
          params: {
            'refreshToken': _is.ParameterDescription(
              name: 'refreshToken',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['refreshJwtTokens'] as _inemdtdo.RefreshJwtTokensEndpoint).refreshAccessToken(
                session,
                refreshToken: params['refreshToken'],
              ),
        ),
      },
    );
    connectors['users'] = _is.EndpointConnector(
      name: 'users',
      endpoint: endpoints['users']!,
      methodConnectors: {
        'roles': _is.MethodConnector(
          name: 'roles',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['users'] as _if041dc0.UsersEndpoint).roles(session),
        ),
        'list': _is.MethodConnector(
          name: 'list',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['users'] as _if041dc0.UsersEndpoint).list(session),
        ),
        'invite': _is.MethodConnector(
          name: 'invite',
          params: {
            'email': _is.ParameterDescription(
              name: 'email',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'fullName': _is.ParameterDescription(
              name: 'fullName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'roles': _is.ParameterDescription(
              name: 'roles',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['users'] as _if041dc0.UsersEndpoint).invite(
                session,
                params['email'],
                params['fullName'],
                params['roles'],
              ),
        ),
        'setRoles': _is.MethodConnector(
          name: 'setRoles',
          params: {
            'membershipId': _is.ParameterDescription(
              name: 'membershipId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'roles': _is.ParameterDescription(
              name: 'roles',
              type: _is.getType<List<String>>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['users'] as _if041dc0.UsersEndpoint).setRoles(
                session,
                params['membershipId'],
                params['roles'],
              ),
        ),
        'suspend': _is.MethodConnector(
          name: 'suspend',
          params: {
            'membershipId': _is.ParameterDescription(
              name: 'membershipId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['users'] as _if041dc0.UsersEndpoint).suspend(
                session,
                params['membershipId'],
              ),
        ),
        'reactivate': _is.MethodConnector(
          name: 'reactivate',
          params: {
            'membershipId': _is.ParameterDescription(
              name: 'membershipId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['users'] as _if041dc0.UsersEndpoint).reactivate(
                session,
                params['membershipId'],
              ),
        ),
        'remove': _is.MethodConnector(
          name: 'remove',
          params: {
            'membershipId': _is.ParameterDescription(
              name: 'membershipId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['users'] as _if041dc0.UsersEndpoint).remove(
                session,
                params['membershipId'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()..initializeEndpoints(server);
  }
}
