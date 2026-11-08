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
import 'dart:typed_data' as _idt;
import 'package:plataforma_os_server/src/generated/catalog/models/product_family_filter.dart' as _i2mp8bst;
import 'package:plataforma_os_server/src/generated/catalog/models/product_family_input.dart' as _ircpj2f1;
import 'package:plataforma_os_server/src/generated/catalog/models/product_family_patch.dart' as _i1kpaeyd;
import 'package:plataforma_os_server/src/generated/catalog/models/product_filter.dart' as _is6ry2ff;
import 'package:plataforma_os_server/src/generated/catalog/models/product_input.dart' as _iku7g2we;
import 'package:plataforma_os_server/src/generated/catalog/models/product_patch.dart' as _ig5mkkf0;
import 'package:plataforma_os_server/src/generated/catalog/models/service_filter.dart' as _ifnpnbtg;
import 'package:plataforma_os_server/src/generated/catalog/models/service_input.dart' as _iemqvx2m;
import 'package:plataforma_os_server/src/generated/catalog/models/service_patch.dart' as _i6t0g57v;
import 'package:plataforma_os_server/src/generated/customers/models/customer_contact_filter.dart' as _ipdid8a4;
import 'package:plataforma_os_server/src/generated/customers/models/customer_contact_input.dart' as _i0rc22zw;
import 'package:plataforma_os_server/src/generated/customers/models/customer_contact_patch.dart' as _i8odeyb5;
import 'package:plataforma_os_server/src/generated/customers/models/customer_filter.dart' as _ipd66tax;
import 'package:plataforma_os_server/src/generated/customers/models/customer_input.dart' as _iw3fixvn;
import 'package:plataforma_os_server/src/generated/customers/models/customer_patch.dart' as _iw5xmx3u;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site_filter.dart' as _im9gx6w1;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site_input.dart' as _iv6e8owq;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site_patch.dart' as _iqxf8m4v;
import 'package:plataforma_os_server/src/generated/imports/models/import_entity_type.dart' as _ir6nxo5z;
import 'package:plataforma_os_server/src/generated/platform/paging/models/page_request.dart' as _i4pk1ojl;
import 'package:serverpod/serverpod.dart' as _is;
import '../catalog/endpoints/product_families_endpoint.dart' as _i6m7puho;
import '../catalog/endpoints/products_endpoint.dart' as _i87w2mxb;
import '../catalog/endpoints/services_endpoint.dart' as _i7qphr7o;
import '../customers/endpoints/customer_contacts_endpoint.dart' as _ihh0do94;
import '../customers/endpoints/customer_sites_endpoint.dart' as _icz6lfvl;
import '../customers/endpoints/customers_endpoint.dart' as _i2n45wl3;
import '../identity_access/endpoints/auth_endpoint.dart' as _i077kp7v;
import '../identity_access/endpoints/me_endpoint.dart' as _i2zd8mbu;
import '../imports/endpoints/imports_endpoint.dart' as _i6nlqm16;

class Endpoints extends _is.EndpointDispatch {
  @override
  void initializeEndpoints(_is.Server server) {
    var endpoints = <String, _is.Endpoint>{
      'productFamilies': _i6m7puho.ProductFamiliesEndpoint()
        ..initialize(
          server,
          'productFamilies',
          null,
        ),
      'products': _i87w2mxb.ProductsEndpoint()
        ..initialize(
          server,
          'products',
          null,
        ),
      'services': _i7qphr7o.ServicesEndpoint()
        ..initialize(
          server,
          'services',
          null,
        ),
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
      'imports': _i6nlqm16.ImportsEndpoint()
        ..initialize(
          server,
          'imports',
          null,
        ),
    };
    connectors['productFamilies'] = _is.EndpointConnector(
      name: 'productFamilies',
      endpoint: endpoints['productFamilies']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'filter': _is.ParameterDescription(
              name: 'filter',
              type: _is.getType<_i2mp8bst.ProductFamilyFilter?>(),
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
              ) async => (endpoints['productFamilies'] as _i6m7puho.ProductFamiliesEndpoint).list(
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
              ) async => (endpoints['productFamilies'] as _i6m7puho.ProductFamiliesEndpoint).get(
                session,
                params['id'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_ircpj2f1.ProductFamilyInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['productFamilies'] as _i6m7puho.ProductFamiliesEndpoint).create(
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
              type: _is.getType<_i1kpaeyd.ProductFamilyPatch>(),
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
              ) async => (endpoints['productFamilies'] as _i6m7puho.ProductFamiliesEndpoint).update(
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
              ) async => (endpoints['productFamilies'] as _i6m7puho.ProductFamiliesEndpoint).deactivate(
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
              ) async => (endpoints['productFamilies'] as _i6m7puho.ProductFamiliesEndpoint).reactivate(
                session,
                params['id'],
                params['expectedVersion'],
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
            'filter': _is.ParameterDescription(
              name: 'filter',
              type: _is.getType<_is6ry2ff.ProductFilter?>(),
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
              ) async => (endpoints['products'] as _i87w2mxb.ProductsEndpoint).list(
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
              ) async => (endpoints['products'] as _i87w2mxb.ProductsEndpoint).get(
                session,
                params['id'],
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
              type: _is.getType<_ig5mkkf0.ProductPatch>(),
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
              ) async => (endpoints['products'] as _i87w2mxb.ProductsEndpoint).update(
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
              ) async => (endpoints['products'] as _i87w2mxb.ProductsEndpoint).deactivate(
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
              ) async => (endpoints['products'] as _i87w2mxb.ProductsEndpoint).reactivate(
                session,
                params['id'],
                params['expectedVersion'],
              ),
        ),
      },
    );
    connectors['services'] = _is.EndpointConnector(
      name: 'services',
      endpoint: endpoints['services']!,
      methodConnectors: {
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'filter': _is.ParameterDescription(
              name: 'filter',
              type: _is.getType<_ifnpnbtg.CatalogServiceFilter?>(),
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
              ) async => (endpoints['services'] as _i7qphr7o.ServicesEndpoint).list(
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
              ) async => (endpoints['services'] as _i7qphr7o.ServicesEndpoint).get(
                session,
                params['id'],
              ),
        ),
        'create': _is.MethodConnector(
          name: 'create',
          params: {
            'input': _is.ParameterDescription(
              name: 'input',
              type: _is.getType<_iemqvx2m.CatalogServiceInput>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['services'] as _i7qphr7o.ServicesEndpoint).create(
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
              type: _is.getType<_i6t0g57v.CatalogServicePatch>(),
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
              ) async => (endpoints['services'] as _i7qphr7o.ServicesEndpoint).update(
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
              ) async => (endpoints['services'] as _i7qphr7o.ServicesEndpoint).deactivate(
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
              ) async => (endpoints['services'] as _i7qphr7o.ServicesEndpoint).reactivate(
                session,
                params['id'],
                params['expectedVersion'],
              ),
        ),
      },
    );
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
    connectors['imports'] = _is.EndpointConnector(
      name: 'imports',
      endpoint: endpoints['imports']!,
      methodConnectors: {
        'available': _is.MethodConnector(
          name: 'available',
          params: {},
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['imports'] as _i6nlqm16.ImportsEndpoint).available(session),
        ),
        'template': _is.MethodConnector(
          name: 'template',
          params: {
            'entityType': _is.ParameterDescription(
              name: 'entityType',
              type: _is.getType<_ir6nxo5z.ImportEntityType>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['imports'] as _i6nlqm16.ImportsEndpoint).template(
                session,
                params['entityType'],
              ),
        ),
        'preview': _is.MethodConnector(
          name: 'preview',
          params: {
            'entityType': _is.ParameterDescription(
              name: 'entityType',
              type: _is.getType<_ir6nxo5z.ImportEntityType>(),
              nullable: false,
            ),
            'fileName': _is.ParameterDescription(
              name: 'fileName',
              type: _is.getType<String>(),
              nullable: false,
            ),
            'content': _is.ParameterDescription(
              name: 'content',
              type: _is.getType<_idt.ByteData>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['imports'] as _i6nlqm16.ImportsEndpoint).preview(
                session,
                params['entityType'],
                params['fileName'],
                params['content'],
              ),
        ),
        'confirm': _is.MethodConnector(
          name: 'confirm',
          params: {
            'runId': _is.ParameterDescription(
              name: 'runId',
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
              ) async => (endpoints['imports'] as _i6nlqm16.ImportsEndpoint).confirm(
                session,
                params['runId'],
                params['expectedVersion'],
              ),
        ),
        'cancel': _is.MethodConnector(
          name: 'cancel',
          params: {
            'runId': _is.ParameterDescription(
              name: 'runId',
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
              ) async => (endpoints['imports'] as _i6nlqm16.ImportsEndpoint).cancel(
                session,
                params['runId'],
                params['expectedVersion'],
              ),
        ),
        'list': _is.MethodConnector(
          name: 'list',
          params: {
            'entityType': _is.ParameterDescription(
              name: 'entityType',
              type: _is.getType<_ir6nxo5z.ImportEntityType?>(),
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
              ) async => (endpoints['imports'] as _i6nlqm16.ImportsEndpoint).list(
                session,
                params['entityType'],
                params['page'],
              ),
        ),
        'get': _is.MethodConnector(
          name: 'get',
          params: {
            'runId': _is.ParameterDescription(
              name: 'runId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['imports'] as _i6nlqm16.ImportsEndpoint).get(
                session,
                params['runId'],
              ),
        ),
        'errorReport': _is.MethodConnector(
          name: 'errorReport',
          params: {
            'runId': _is.ParameterDescription(
              name: 'runId',
              type: _is.getType<_is.UuidValue>(),
              nullable: false,
            ),
          },
          call:
              (
                _is.Session session,
                Map<String, dynamic> params,
              ) async => (endpoints['imports'] as _i6nlqm16.ImportsEndpoint).errorReport(
                session,
                params['runId'],
              ),
        ),
      },
    );
  }
}
