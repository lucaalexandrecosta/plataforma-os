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
import 'package:plataforma_os_server/src/generated/assets/models/asset_input.dart' as _i58orcz5;
import 'package:plataforma_os_server/src/generated/catalog/models/product_input.dart' as _iku7g2we;
import 'package:plataforma_os_server/src/generated/patrimony/models/depreciation_profile_input.dart' as _ims07aom;
import 'package:plataforma_os_server/src/generated/scheduling/models/technician_input.dart' as _i4g4d70s;
import 'package:plataforma_os_server/src/generated/scheduling/models/visit_check_in.dart' as _in4grqdw;
import 'package:plataforma_os_server/src/generated/scheduling/models/visit_finish.dart' as _izl7q3ap;
import 'package:plataforma_os_server/src/generated/scheduling/models/visit_input.dart' as _isygpo5n;
import 'package:plataforma_os_server/src/generated/sync/models/device_registration.dart' as _ifayztnr;
import 'package:plataforma_os_server/src/generated/sync/models/sync_push_request.dart' as _is7nu1l0;
import 'package:plataforma_os_server/src/generated/tenancy/models/branch_input.dart' as _i6djw631;
import 'package:plataforma_os_server/src/generated/tenancy/models/cost_center_input.dart' as _irkypkua;
import 'package:plataforma_os_server/src/generated/work_orders/models/work_order_changes.dart' as _im8hf6je;
import 'package:plataforma_os_server/src/generated/work_orders/models/work_order_input.dart' as _is40rk4d;
import 'package:plataforma_os_server/src/generated/work_orders/models/work_order_type_input.dart' as _i56uux5g;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart' as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart' as _iais;
import '../assets/endpoints/assets_endpoint.dart' as _i8oyhoxt;
import '../assets/endpoints/qr_tags_endpoint.dart' as _ijcbp4ea;
import '../catalog/endpoints/products_endpoint.dart' as _i87w2mxb;
import '../identity_access/endpoints/auth_endpoint.dart' as _i077kp7v;
import '../identity_access/endpoints/email_idp_endpoint.dart' as _iq8d1u02;
import '../identity_access/endpoints/me_endpoint.dart' as _i2zd8mbu;
import '../identity_access/endpoints/refresh_jwt_tokens_endpoint.dart' as _inemdtdo;
import '../identity_access/endpoints/users_endpoint.dart' as _if041dc0;
import '../patrimony/endpoints/depreciation_endpoint.dart' as _ik1wssz1;
import '../scheduling/endpoints/technicians_endpoint.dart' as _i7x07tna;
import '../scheduling/endpoints/visits_endpoint.dart' as _i34c7in8;
import '../sync/endpoints/technician_sync_endpoint.dart' as _i4wczera;
import '../tenancy/endpoints/branches_endpoint.dart' as _i9d4u5j9;
import '../tenancy/endpoints/cost_centers_endpoint.dart' as _inwd0tmb;
import '../work_orders/endpoints/work_orders_endpoint.dart' as _i452a764;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'assets': _i8oyhoxt.AssetsEndpoint()
        ..initialize(
          server,
          'assets',
          null,
        ),
      'qrTags': _ijcbp4ea.QrTagsEndpoint()
        ..initialize(
          server,
          'qrTags',
          null,
        ),
      'products': _i87w2mxb.ProductsEndpoint()
        ..initialize(
          server,
          'products',
          null,
        ),
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
      'depreciation': _ik1wssz1.DepreciationEndpoint()
        ..initialize(
          server,
          'depreciation',
          null,
        ),
      'technicians': _i7x07tna.TechniciansEndpoint()
        ..initialize(
          server,
          'technicians',
          null,
        ),
      'visits': _i34c7in8.VisitsEndpoint()
        ..initialize(
          server,
          'visits',
          null,
        ),
      'technicianSync': _i4wczera.TechnicianSyncEndpoint()
        ..initialize(
          server,
          'technicianSync',
          null,
        ),
      'branches': _i9d4u5j9.BranchesEndpoint()
        ..initialize(
          server,
          'branches',
          null,
        ),
      'costCenters': _inwd0tmb.CostCentersEndpoint()
        ..initialize(
          server,
          'costCenters',
          null,
        ),
      'workOrders': _i452a764.WorkOrdersEndpoint()
        ..initialize(
          server,
          'workOrders',
          null,
        ),
    };
    connectors['assets'] = _is.EndpointConnector(
      name: 'assets',
      endpoint: endpoints['assets']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'search': _is.ParameterDescription(
              name: 'search',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'branchId': _is.ParameterDescription(
              name: 'branchId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'costCenterId': _is.ParameterDescription(
              name: 'costCenterId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'includeInactive': _is.ParameterDescription(
              name: 'includeInactive',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['assets'] as _i8oyhoxt.AssetsEndpoint).list(
                session,
                search: params['search'],
                branchId: params['branchId'],
                costCenterId: params['costCenterId'],
                includeInactive: params['includeInactive'],
                limit: params['limit'],
                offset: params['offset'],
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
              ) async => (endpoints['assets'] as _i8oyhoxt.AssetsEndpoint).get(
                session,
                params['id'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_i58orcz5.AssetInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['assets'] as _i8oyhoxt.AssetsEndpoint).create(
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
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_i58orcz5.AssetInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['assets'] as _i8oyhoxt.AssetsEndpoint).update(
                session,
                params['id'],
                params['expectedVersion'],
                params['input'],
              ),
        ),
      },
    );
    connectors['qrTags'] = _is.EndpointConnector(
      name: 'qrTags',
      endpoint: endpoints['qrTags']!,
      methodConnectors: {
        'generateBatch': _is.MethodConnector(
          name: 'generateBatch',
          params: {
            'quantity': _is.ParameterDescription(
              name: 'quantity',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'notes': _is.ParameterDescription(
              name: 'notes',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['qrTags'] as _ijcbp4ea.QrTagsEndpoint).generateBatch(
                session,
                params['quantity'],
                notes: params['notes'],
              ),
        ),
        'listBatches': _is.MethodConnector(
          name: 'listBatches',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['qrTags'] as _ijcbp4ea.QrTagsEndpoint).listBatches(session),
        ),
        'batchTags': _is.MethodConnector(
          name: 'batchTags',
          params: {
            'batchId': _is.ParameterDescription(
              name: 'batchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['qrTags'] as _ijcbp4ea.QrTagsEndpoint).batchTags(
                session,
                params['batchId'],
              ),
        ),
        'markBatchPrinted': _is.MethodConnector(
          name: 'markBatchPrinted',
          params: {
            'batchId': _is.ParameterDescription(
              name: 'batchId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['qrTags'] as _ijcbp4ea.QrTagsEndpoint).markBatchPrinted(
                session,
                params['batchId'],
              ),
        ),
        'resolve': _is.MethodConnector(
          name: 'resolve',
          params: {
            'scanned': _is.ParameterDescription(
              name: 'scanned',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['qrTags'] as _ijcbp4ea.QrTagsEndpoint).resolve(
                session,
                params['scanned'],
              ),
        ),
        'bind': _is.MethodConnector(
          name: 'bind',
          params: {
            'scanned': _is.ParameterDescription(
              name: 'scanned',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'assetId': _is.ParameterDescription(
              name: 'assetId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['qrTags'] as _ijcbp4ea.QrTagsEndpoint).bind(
                session,
                params['scanned'],
                params['assetId'],
              ),
        ),
        'unbind': _is.MethodConnector(
          name: 'unbind',
          params: {
            'tagId': _is.ParameterDescription(
              name: 'tagId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['qrTags'] as _ijcbp4ea.QrTagsEndpoint).unbind(
                session,
                params['tagId'],
              ),
        ),
        'revoke': _is.MethodConnector(
          name: 'revoke',
          params: {
            'tagId': _is.ParameterDescription(
              name: 'tagId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['qrTags'] as _ijcbp4ea.QrTagsEndpoint).revoke(
                session,
                params['tagId'],
                params['reason'],
                note: params['note'],
              ),
        ),
      },
    );
    connectors['products'] = _is.EndpointConnector(
      name: 'products',
      endpoint: endpoints['products']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'search': _is.ParameterDescription(
              name: 'search',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['products'] as _i87w2mxb.ProductsEndpoint).list(
                session,
                search: params['search'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_iku7g2we.ProductInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['products'] as _i87w2mxb.ProductsEndpoint).create(
                session,
                params['input'],
              ),
        ),
      },
    );
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
        'myTenants': _is.MethodConnector(
          name: 'myTenants',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['auth'] as _i077kp7v.AuthEndpoint).myTenants(session),
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
    connectors['depreciation'] = _is.EndpointConnector(
      name: 'depreciation',
      endpoint: endpoints['depreciation']!,
      methodConnectors: {
        'profile': _is.MethodConnector(
          name: 'profile',
          params: {
            'assetId': _is.ParameterDescription(
              name: 'assetId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['depreciation'] as _ik1wssz1.DepreciationEndpoint).profile(
                session,
                params['assetId'],
              ),
        ),
        'saveProfile': _is.MethodConnector(
          name: 'saveProfile',
          params: {
            'assetId': _is.ParameterDescription(
              name: 'assetId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_ims07aom.DepreciationProfileInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['depreciation'] as _ik1wssz1.DepreciationEndpoint).saveProfile(
                session,
                params['assetId'],
                params['expectedVersion'],
                params['input'],
              ),
        ),
        'schedule': _is.MethodConnector(
          name: 'schedule',
          params: {
            'assetId': _is.ParameterDescription(
              name: 'assetId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['depreciation'] as _ik1wssz1.DepreciationEndpoint).schedule(
                session,
                params['assetId'],
              ),
        ),
        'position': _is.MethodConnector(
          name: 'position',
          params: {
            'year': _is.ParameterDescription(
              name: 'year',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'month': _is.ParameterDescription(
              name: 'month',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'branchId': _is.ParameterDescription(
              name: 'branchId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'costCenterId': _is.ParameterDescription(
              name: 'costCenterId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['depreciation'] as _ik1wssz1.DepreciationEndpoint).position(
                session,
                params['year'],
                params['month'],
                branchId: params['branchId'],
                costCenterId: params['costCenterId'],
              ),
        ),
        'closings': _is.MethodConnector(
          name: 'closings',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['depreciation'] as _ik1wssz1.DepreciationEndpoint).closings(session),
        ),
        'close': _is.MethodConnector(
          name: 'close',
          params: {
            'year': _is.ParameterDescription(
              name: 'year',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'month': _is.ParameterDescription(
              name: 'month',
              type: _is.getType<int>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['depreciation'] as _ik1wssz1.DepreciationEndpoint).close(
                session,
                params['year'],
                params['month'],
              ),
        ),
        'reopen': _is.MethodConnector(
          name: 'reopen',
          params: {
            'year': _is.ParameterDescription(
              name: 'year',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'month': _is.ParameterDescription(
              name: 'month',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['depreciation'] as _ik1wssz1.DepreciationEndpoint).reopen(
                session,
                params['year'],
                params['month'],
                params['reason'],
              ),
        ),
      },
    );
    connectors['technicians'] = _is.EndpointConnector(
      name: 'technicians',
      endpoint: endpoints['technicians']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'includeInactive': _is.ParameterDescription(
              name: 'includeInactive',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['technicians'] as _i7x07tna.TechniciansEndpoint).list(
                session,
                includeInactive: params['includeInactive'],
              ),
        ),
        'mine': _is.MethodConnector(
          name: 'mine',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['technicians'] as _i7x07tna.TechniciansEndpoint).mine(session),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_i4g4d70s.TechnicianInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['technicians'] as _i7x07tna.TechniciansEndpoint).create(
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
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_i4g4d70s.TechnicianInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['technicians'] as _i7x07tna.TechniciansEndpoint).update(
                session,
                params['id'],
                params['expectedVersion'],
                params['input'],
              ),
        ),
      },
    );
    connectors['visits'] = _is.EndpointConnector(
      name: 'visits',
      endpoint: endpoints['visits']!,
      methodConnectors: {
        'agenda': _is.MethodConnector(
          name: 'agenda',
          params: {
            'from': _is.ParameterDescription(
              name: 'from',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'to': _is.ParameterDescription(
              name: 'to',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'technicianId': _is.ParameterDescription(
              name: 'technicianId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'includeCancelled': _is.ParameterDescription(
              name: 'includeCancelled',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['visits'] as _i34c7in8.VisitsEndpoint).agenda(
                session,
                params['from'],
                params['to'],
                technicianId: params['technicianId'],
                includeCancelled: params['includeCancelled'],
              ),
        ),
        'mine': _is.MethodConnector(
          name: 'mine',
          params: {
            'from': _is.ParameterDescription(
              name: 'from',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
            'to': _is.ParameterDescription(
              name: 'to',
              type: _is.getType<DateTime>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['visits'] as _i34c7in8.VisitsEndpoint).mine(
                session,
                params['from'],
                params['to'],
              ),
        ),
        'ofWorkOrder': _is.MethodConnector(
          name: 'ofWorkOrder',
          params: {
            'workOrderId': _is.ParameterDescription(
              name: 'workOrderId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['visits'] as _i34c7in8.VisitsEndpoint).ofWorkOrder(
                session,
                params['workOrderId'],
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
              ) async => (endpoints['visits'] as _i34c7in8.VisitsEndpoint).get(
                session,
                params['id'],
              ),
        ),
        'schedule': _is.MethodConnector(
          name: 'schedule',
          params: {
            'workOrderId': _is.ParameterDescription(
              name: 'workOrderId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_isygpo5n.VisitInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['visits'] as _i34c7in8.VisitsEndpoint).schedule(
                session,
                params['workOrderId'],
                params['input'],
              ),
        ),
        'reschedule': _is.MethodConnector(
          name: 'reschedule',
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
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_isygpo5n.VisitInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['visits'] as _i34c7in8.VisitsEndpoint).reschedule(
                session,
                params['id'],
                params['expectedVersion'],
                params['input'],
              ),
        ),
        'cancel': _is.MethodConnector(
          name: 'cancel',
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
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['visits'] as _i34c7in8.VisitsEndpoint).cancel(
                session,
                params['id'],
                params['expectedVersion'],
                params['reason'],
              ),
        ),
        'startTravel': _is.MethodConnector(
          name: 'startTravel',
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
              ) async => (endpoints['visits'] as _i34c7in8.VisitsEndpoint).startTravel(
                session,
                params['id'],
                params['expectedVersion'],
              ),
        ),
        'checkIn': _is.MethodConnector(
          name: 'checkIn',
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
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_in4grqdw.VisitCheckIn>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['visits'] as _i34c7in8.VisitsEndpoint).checkIn(
                session,
                params['id'],
                params['expectedVersion'],
                params['input'],
              ),
        ),
        'pause': _is.MethodConnector(
          name: 'pause',
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
              ) async => (endpoints['visits'] as _i34c7in8.VisitsEndpoint).pause(
                session,
                params['id'],
                params['expectedVersion'],
              ),
        ),
        'resume': _is.MethodConnector(
          name: 'resume',
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
              ) async => (endpoints['visits'] as _i34c7in8.VisitsEndpoint).resume(
                session,
                params['id'],
                params['expectedVersion'],
              ),
        ),
        'finish': _is.MethodConnector(
          name: 'finish',
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
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_izl7q3ap.VisitFinish>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['visits'] as _i34c7in8.VisitsEndpoint).finish(
                session,
                params['id'],
                params['expectedVersion'],
                params['input'],
              ),
        ),
      },
    );
    connectors['technicianSync'] = _is.EndpointConnector(
      name: 'technicianSync',
      endpoint: endpoints['technicianSync']!,
      methodConnectors: {
        'registerDevice': _is.MethodConnector(
          name: 'registerDevice',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_ifayztnr.DeviceRegistration>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['technicianSync'] as _i4wczera.TechnicianSyncEndpoint).registerDevice(
                session,
                params['input'],
              ),
        ),
        'pull': _is.MethodConnector(
          name: 'pull',
          params: {
            'deviceId': _is.ParameterDescription(
              name: 'deviceId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['technicianSync'] as _i4wczera.TechnicianSyncEndpoint).pull(
                session,
                params['deviceId'],
              ),
        ),
        'push': _is.MethodConnector(
          name: 'push',
          params: {
            'request': _is.ParameterDescription(
              name: 'request',
              type: _is.getType<_is7nu1l0.SyncPushRequest>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['technicianSync'] as _i4wczera.TechnicianSyncEndpoint).push(
                session,
                params['request'],
              ),
        ),
      },
    );
    connectors['branches'] = _is.EndpointConnector(
      name: 'branches',
      endpoint: endpoints['branches']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'includeInactive': _is.ParameterDescription(
              name: 'includeInactive',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['branches'] as _i9d4u5j9.BranchesEndpoint).list(
                session,
                includeInactive: params['includeInactive'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_i6djw631.BranchInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['branches'] as _i9d4u5j9.BranchesEndpoint).create(
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
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_i6djw631.BranchInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['branches'] as _i9d4u5j9.BranchesEndpoint).update(
                session,
                params['id'],
                params['expectedVersion'],
                params['input'],
              ),
        ),
      },
    );
    connectors['costCenters'] = _is.EndpointConnector(
      name: 'costCenters',
      endpoint: endpoints['costCenters']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'branchId': _is.ParameterDescription(
              name: 'branchId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'includeInactive': _is.ParameterDescription(
              name: 'includeInactive',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['costCenters'] as _inwd0tmb.CostCentersEndpoint).list(
                session,
                branchId: params['branchId'],
                includeInactive: params['includeInactive'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_irkypkua.CostCenterInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['costCenters'] as _inwd0tmb.CostCentersEndpoint).create(
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
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_irkypkua.CostCenterInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['costCenters'] as _inwd0tmb.CostCentersEndpoint).update(
                session,
                params['id'],
                params['expectedVersion'],
                params['input'],
              ),
        ),
      },
    );
    connectors['workOrders'] = _is.EndpointConnector(
      name: 'workOrders',
      endpoint: endpoints['workOrders']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'search': _is.ParameterDescription(
              name: 'search',
              type: _is.getType<String?>(),
              nullable: true,
            ),
            'statuses': _is.ParameterDescription(
              name: 'statuses',
              type: _is.getType<List<String>?>(),
              nullable: true,
            ),
            'openOnly': _is.ParameterDescription(
              name: 'openOnly',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
            'assetId': _is.ParameterDescription(
              name: 'assetId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'branchId': _is.ParameterDescription(
              name: 'branchId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'costCenterId': _is.ParameterDescription(
              name: 'costCenterId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'workOrderTypeId': _is.ParameterDescription(
              name: 'workOrderTypeId',
              type: _is.getType<_is.UuidValue?>(),
              nullable: true,
            ),
            'limit': _is.ParameterDescription(
              name: 'limit',
              type: _is.getType<int?>(),
              nullable: true,
            ),
            'offset': _is.ParameterDescription(
              name: 'offset',
              type: _is.getType<int?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workOrders'] as _i452a764.WorkOrdersEndpoint).list(
                session,
                search: params['search'],
                statuses: params['statuses'],
                openOnly: params['openOnly'],
                assetId: params['assetId'],
                branchId: params['branchId'],
                costCenterId: params['costCenterId'],
                workOrderTypeId: params['workOrderTypeId'],
                limit: params['limit'],
                offset: params['offset'],
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
              ) async => (endpoints['workOrders'] as _i452a764.WorkOrdersEndpoint).get(
                session,
                params['id'],
              ),
        ),
        'open': _is.MethodConnector(
          name: 'open',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_is40rk4d.WorkOrderInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workOrders'] as _i452a764.WorkOrdersEndpoint).open(
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
            'expectedVersion': _is.ParameterDescription(
              name: 'expectedVersion',
              type: _is.getType<int>(),
              nullable: false,
            ),
            'changes': _is.ParameterDescription(
              name: 'changes',
              type: _is.getType<_im8hf6je.WorkOrderChanges>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workOrders'] as _i452a764.WorkOrdersEndpoint).update(
                session,
                params['id'],
                params['expectedVersion'],
                params['changes'],
              ),
        ),
        'start': _is.MethodConnector(
          name: 'start',
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
              ) async => (endpoints['workOrders'] as _i452a764.WorkOrdersEndpoint).start(
                session,
                params['id'],
                params['expectedVersion'],
              ),
        ),
        'hold': _is.MethodConnector(
          name: 'hold',
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
            'holdReason': _is.ParameterDescription(
              name: 'holdReason',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workOrders'] as _i452a764.WorkOrdersEndpoint).hold(
                session,
                params['id'],
                params['expectedVersion'],
                params['holdReason'],
                note: params['note'],
              ),
        ),
        'complete': _is.MethodConnector(
          name: 'complete',
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
            'resolutionNotes': _is.ParameterDescription(
              name: 'resolutionNotes',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workOrders'] as _i452a764.WorkOrdersEndpoint).complete(
                session,
                params['id'],
                params['expectedVersion'],
                params['resolutionNotes'],
              ),
        ),
        'close': _is.MethodConnector(
          name: 'close',
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
              ) async => (endpoints['workOrders'] as _i452a764.WorkOrdersEndpoint).close(
                session,
                params['id'],
                params['expectedVersion'],
              ),
        ),
        'cancel': _is.MethodConnector(
          name: 'cancel',
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
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'note': _is.ParameterDescription(
              name: 'note',
              type: _is.getType<String?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workOrders'] as _i452a764.WorkOrdersEndpoint).cancel(
                session,
                params['id'],
                params['expectedVersion'],
                params['reason'],
                note: params['note'],
              ),
        ),
        'reopen': _is.MethodConnector(
          name: 'reopen',
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
            'reason': _is.ParameterDescription(
              name: 'reason',
              type: _is.getType<String>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workOrders'] as _i452a764.WorkOrdersEndpoint).reopen(
                session,
                params['id'],
                params['expectedVersion'],
                params['reason'],
              ),
        ),
        'types': _is.MethodConnector(
          name: 'types',
          params: {
            'includeInactive': _is.ParameterDescription(
              name: 'includeInactive',
              type: _is.getType<bool?>(),
              nullable: true,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workOrders'] as _i452a764.WorkOrdersEndpoint).types(
                session,
                includeInactive: params['includeInactive'],
              ),
        ),
        'createType': _is.MethodConnector(
          name: 'createType',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_i56uux5g.WorkOrderTypeInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workOrders'] as _i452a764.WorkOrdersEndpoint).createType(
                session,
                params['input'],
              ),
        ),
        'updateType': _is.MethodConnector(
          name: 'updateType',
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
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_i56uux5g.WorkOrderTypeInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['workOrders'] as _i452a764.WorkOrdersEndpoint).updateType(
                session,
                params['id'],
                params['expectedVersion'],
                params['input'],
              ),
        ),
      },
    );
    modules['serverpod_auth_idp'] = _iais.Endpoints()..initializeEndpoints(server);
    modules['serverpod_auth_core'] = _iacs.Endpoints()..initializeEndpoints(server);
  }
}
