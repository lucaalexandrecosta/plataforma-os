/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:plataforma_os_server/src/generated/tenancy/models/tenant_summary.dart' as _inphvrgt;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'customers/models/contact_origin.dart' as _iqp78482;
import 'customers/models/contact_role.dart' as _iplumur6;
import 'customers/models/contact_status.dart' as _izqw5q67;
import 'customers/models/customer.dart' as _in2ysqih;
import 'customers/models/customer_contact.dart' as _iyonel9d;
import 'customers/models/customer_contact_field.dart' as _ial9yste;
import 'customers/models/customer_contact_filter.dart' as _izv3bdkd;
import 'customers/models/customer_contact_input.dart' as _i8ppoe04;
import 'customers/models/customer_contact_page.dart' as _ifqwfvr5;
import 'customers/models/customer_contact_patch.dart' as _i8xalfaz;
import 'customers/models/customer_field.dart' as _i3eh97aw;
import 'customers/models/customer_filter.dart' as _i4w7b2hn;
import 'customers/models/customer_input.dart' as _i54pcl9h;
import 'customers/models/customer_kind.dart' as _i71gi8vd;
import 'customers/models/customer_page.dart' as _iu4jficl;
import 'customers/models/customer_patch.dart' as _ib2ck4oj;
import 'customers/models/customer_site.dart' as _ihhtee09;
import 'customers/models/customer_site_field.dart' as _iyqdtrh1;
import 'customers/models/customer_site_filter.dart' as _ifq4omy3;
import 'customers/models/customer_site_input.dart' as _ii01wxyo;
import 'customers/models/customer_site_page.dart' as _ibmnlo2x;
import 'customers/models/customer_site_patch.dart' as _i7pxbyck;
import 'customers/models/document_type.dart' as _ioxz8xmy;
import 'customers/models/notification_channel.dart' as _ipthj0tj;
import 'customers/models/person_type.dart' as _ibxir450;
import 'identity_access/models/app_user.dart' as _i5wnkftg;
import 'identity_access/models/me_info.dart' as _ip4w8f8l;
import 'identity_access/models/membership_status.dart' as _i2vwv4gx;
import 'identity_access/models/tenant_membership.dart' as _i1iyeyn1;
import 'identity_access/models/tenant_membership_role.dart' as _iutn78jy;
import 'identity_access/models/tenant_token.dart' as _izyppcov;
import 'platform/errors/models/api_exception.dart' as _i147o0qx;
import 'platform/errors/models/error_category.dart' as _i0p9y4c3;
import 'platform/errors/models/field_error.dart' as _i3z3bgdl;
import 'platform/models/record_source.dart' as _i43haw30;
import 'platform/paging/models/page_request.dart' as _i18yzlaa;
import 'tenancy/models/tenant.dart' as _i2jhpzjh;
import 'tenancy/models/tenant_status.dart' as _i2bjgc9x;
import 'tenancy/models/tenant_summary.dart' as _i9uizrsf;
export 'customers/models/contact_origin.dart';
export 'customers/models/contact_role.dart';
export 'customers/models/contact_status.dart';
export 'customers/models/customer.dart';
export 'customers/models/customer_contact.dart';
export 'customers/models/customer_contact_field.dart';
export 'customers/models/customer_contact_filter.dart';
export 'customers/models/customer_contact_input.dart';
export 'customers/models/customer_contact_page.dart';
export 'customers/models/customer_contact_patch.dart';
export 'customers/models/customer_field.dart';
export 'customers/models/customer_filter.dart';
export 'customers/models/customer_input.dart';
export 'customers/models/customer_kind.dart';
export 'customers/models/customer_page.dart';
export 'customers/models/customer_patch.dart';
export 'customers/models/customer_site.dart';
export 'customers/models/customer_site_field.dart';
export 'customers/models/customer_site_filter.dart';
export 'customers/models/customer_site_input.dart';
export 'customers/models/customer_site_page.dart';
export 'customers/models/customer_site_patch.dart';
export 'customers/models/document_type.dart';
export 'customers/models/notification_channel.dart';
export 'customers/models/person_type.dart';
export 'identity_access/models/app_user.dart';
export 'identity_access/models/me_info.dart';
export 'identity_access/models/membership_status.dart';
export 'identity_access/models/tenant_membership.dart';
export 'identity_access/models/tenant_membership_role.dart';
export 'identity_access/models/tenant_token.dart';
export 'platform/errors/models/api_exception.dart';
export 'platform/errors/models/error_category.dart';
export 'platform/errors/models/field_error.dart';
export 'platform/models/record_source.dart';
export 'platform/paging/models/page_request.dart';
export 'tenancy/models/tenant.dart';
export 'tenancy/models/tenant_status.dart';
export 'tenancy/models/tenant_summary.dart';

class Protocol extends _is.DatabaseSerializationManager implements _is.DatabaseProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  _is.ProtocolDeserialization get deserializationMetadata => _is.ProtocolDeserialization.cached(
    this,
    types: const [
      _is.getType<_iqp78482.ContactOrigin>,
      _is.getType<_iplumur6.ContactRole>,
      _is.getType<_izqw5q67.ContactStatus>,
      _is.getType<_in2ysqih.Customer>,
      _is.getType<_iyonel9d.CustomerContact>,
      _is.getType<_ial9yste.CustomerContactField>,
      _is.getType<_izv3bdkd.CustomerContactFilter>,
      _is.getType<_i8ppoe04.CustomerContactInput>,
      _is.getType<_ifqwfvr5.CustomerContactPage>,
      _is.getType<_i8xalfaz.CustomerContactPatch>,
      _is.getType<_i3eh97aw.CustomerField>,
      _is.getType<_i4w7b2hn.CustomerFilter>,
      _is.getType<_i54pcl9h.CustomerInput>,
      _is.getType<_i71gi8vd.CustomerKind>,
      _is.getType<_iu4jficl.CustomerPage>,
      _is.getType<_ib2ck4oj.CustomerPatch>,
      _is.getType<_ihhtee09.CustomerSite>,
      _is.getType<_iyqdtrh1.CustomerSiteField>,
      _is.getType<_ifq4omy3.CustomerSiteFilter>,
      _is.getType<_ii01wxyo.CustomerSiteInput>,
      _is.getType<_ibmnlo2x.CustomerSitePage>,
      _is.getType<_i7pxbyck.CustomerSitePatch>,
      _is.getType<_ioxz8xmy.DocumentType>,
      _is.getType<_ipthj0tj.NotificationChannel>,
      _is.getType<_ibxir450.PersonType>,
      _is.getType<_i5wnkftg.AppUser>,
      _is.getType<_ip4w8f8l.MeInfo>,
      _is.getType<_i2vwv4gx.MembershipStatus>,
      _is.getType<_i1iyeyn1.TenantMembership>,
      _is.getType<_iutn78jy.TenantMembershipRole>,
      _is.getType<_izyppcov.TenantToken>,
      _is.getType<_i147o0qx.ApiException>,
      _is.getType<_i0p9y4c3.ErrorCategory>,
      _is.getType<_i3z3bgdl.FieldError>,
      _is.getType<_i43haw30.RecordSource>,
      _is.getType<_i18yzlaa.PageRequest>,
      _is.getType<_i2jhpzjh.Tenant>,
      _is.getType<_i2bjgc9x.TenantStatus>,
      _is.getType<_i9uizrsf.TenantSummary>,
      _is.getType<_iqp78482.ContactOrigin?>,
      _is.getType<_iplumur6.ContactRole?>,
      _is.getType<_izqw5q67.ContactStatus?>,
      _is.getType<_in2ysqih.Customer?>,
      _is.getType<_iyonel9d.CustomerContact?>,
      _is.getType<_ial9yste.CustomerContactField?>,
      _is.getType<_izv3bdkd.CustomerContactFilter?>,
      _is.getType<_i8ppoe04.CustomerContactInput?>,
      _is.getType<_ifqwfvr5.CustomerContactPage?>,
      _is.getType<_i8xalfaz.CustomerContactPatch?>,
      _is.getType<_i3eh97aw.CustomerField?>,
      _is.getType<_i4w7b2hn.CustomerFilter?>,
      _is.getType<_i54pcl9h.CustomerInput?>,
      _is.getType<_i71gi8vd.CustomerKind?>,
      _is.getType<_iu4jficl.CustomerPage?>,
      _is.getType<_ib2ck4oj.CustomerPatch?>,
      _is.getType<_ihhtee09.CustomerSite?>,
      _is.getType<_iyqdtrh1.CustomerSiteField?>,
      _is.getType<_ifq4omy3.CustomerSiteFilter?>,
      _is.getType<_ii01wxyo.CustomerSiteInput?>,
      _is.getType<_ibmnlo2x.CustomerSitePage?>,
      _is.getType<_i7pxbyck.CustomerSitePatch?>,
      _is.getType<_ioxz8xmy.DocumentType?>,
      _is.getType<_ipthj0tj.NotificationChannel?>,
      _is.getType<_ibxir450.PersonType?>,
      _is.getType<_i5wnkftg.AppUser?>,
      _is.getType<_ip4w8f8l.MeInfo?>,
      _is.getType<_i2vwv4gx.MembershipStatus?>,
      _is.getType<_i1iyeyn1.TenantMembership?>,
      _is.getType<_iutn78jy.TenantMembershipRole?>,
      _is.getType<_izyppcov.TenantToken?>,
      _is.getType<_i147o0qx.ApiException?>,
      _is.getType<_i0p9y4c3.ErrorCategory?>,
      _is.getType<_i3z3bgdl.FieldError?>,
      _is.getType<_i43haw30.RecordSource?>,
      _is.getType<_i18yzlaa.PageRequest?>,
      _is.getType<_i2jhpzjh.Tenant?>,
      _is.getType<_i2bjgc9x.TenantStatus?>,
      _is.getType<_i9uizrsf.TenantSummary?>,
      _is.getType<List<_iyonel9d.CustomerContact>>,
      _is.getType<List<_ial9yste.CustomerContactField>>,
      _is.getType<List<_ial9yste.CustomerContactField>?>,
      _is.getType<List<_in2ysqih.Customer>>,
      _is.getType<List<_i3eh97aw.CustomerField>>,
      _is.getType<List<_i3eh97aw.CustomerField>?>,
      _is.getType<List<_ihhtee09.CustomerSite>>,
      _is.getType<List<_iyqdtrh1.CustomerSiteField>>,
      _is.getType<List<_iyqdtrh1.CustomerSiteField>?>,
      _is.getType<List<String>>,
      _is.getType<List<_i3z3bgdl.FieldError>>,
      _is.getType<List<_i3z3bgdl.FieldError>?>,
      _is.getType<Map<String, String>>,
      _is.getType<Map<String, String>?>,
      _is.getType<List<_inphvrgt.TenantSummary>>,
    ],
    modules: const [_isp.Protocol.new],
    classNames: const [
      'ContactOrigin',
      'ContactRole',
      'ContactStatus',
      'Customer',
      'CustomerContact',
      'CustomerContactField',
      'CustomerContactFilter',
      'CustomerContactInput',
      'CustomerContactPage',
      'CustomerContactPatch',
      'CustomerField',
      'CustomerFilter',
      'CustomerInput',
      'CustomerKind',
      'CustomerPage',
      'CustomerPatch',
      'CustomerSite',
      'CustomerSiteField',
      'CustomerSiteFilter',
      'CustomerSiteInput',
      'CustomerSitePage',
      'CustomerSitePatch',
      'DocumentType',
      'NotificationChannel',
      'PersonType',
      'AppUser',
      'MeInfo',
      'MembershipStatus',
      'TenantMembership',
      'TenantMembershipRole',
      'TenantToken',
      'ApiException',
      'ErrorCategory',
      'FieldError',
      'RecordSource',
      'PageRequest',
      'Tenant',
      'TenantStatus',
      'TenantSummary',
    ],
  );

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'customer_contacts',
      dartName: 'CustomerContact',
      schema: 'public',
      module: 'plataforma_os',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'tenant_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'customer_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'customer_site_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'user_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'phone_e164',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'job_title',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'contact_role',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ContactRole',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ContactStatus',
        ),
        _isp.ColumnDefinition(
          name: 'origin',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ContactOrigin',
        ),
        _isp.ColumnDefinition(
          name: 'can_open_requests',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'preferred_channel',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:NotificationChannel?',
        ),
        _isp.ColumnDefinition(
          name: 'whatsapp_opt_in_at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'approved_at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'approved_by',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'blocked_reason',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'last_login_at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'is_active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'source',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RecordSource',
        ),
        _isp.ColumnDefinition(
          name: 'external_system',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'external_id',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'created_at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updated_at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'version',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: false,
    ),
    _isp.TableDefinition(
      name: 'customer_sites',
      dartName: 'CustomerSite',
      schema: 'public',
      module: 'plataforma_os',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'tenant_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'customer_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'street',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'street_number',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'complement',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'district',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'city',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'state',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'postal_code',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'country_code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'latitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'longitude',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'phone',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'access_notes',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'service_area_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'is_active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'source',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RecordSource',
        ),
        _isp.ColumnDefinition(
          name: 'external_system',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'external_id',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'created_at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updated_at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'version',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: false,
    ),
    _isp.TableDefinition(
      name: 'customers',
      dartName: 'Customer',
      schema: 'public',
      module: 'plataforma_os',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'tenant_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'trade_name',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'person_type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:PersonType',
        ),
        _isp.ColumnDefinition(
          name: 'document_type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:DocumentType',
        ),
        _isp.ColumnDefinition(
          name: 'document_number',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'state_registration',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'phone',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'notes',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'kind',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:CustomerKind',
        ),
        _isp.ColumnDefinition(
          name: 'primary_sales_rep_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'skip_triage',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'is_active',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'deactivated_at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'source',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:RecordSource',
        ),
        _isp.ColumnDefinition(
          name: 'external_system',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'external_id',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'created_at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'updated_at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'version',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: false,
    ),
    _isp.TableDefinition(
      name: 'tenant_membership_roles',
      dartName: 'TenantMembershipRole',
      schema: 'public',
      module: 'plataforma_os',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'tenant_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'membership_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'role_code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: false,
    ),
    _isp.TableDefinition(
      name: 'tenant_memberships',
      dartName: 'TenantMembership',
      schema: 'public',
      module: 'plataforma_os',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'tenant_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'user_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:MembershipStatus',
        ),
        _isp.ColumnDefinition(
          name: 'last_access_at',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'version',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: false,
    ),
    _isp.TableDefinition(
      name: 'tenants',
      dartName: 'Tenant',
      schema: 'public',
      module: 'plataforma_os',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'slug',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'legal_name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'display_name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'document_number',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TenantStatus',
        ),
        _isp.ColumnDefinition(
          name: 'plan_id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'version',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: false,
    ),
    _isp.TableDefinition(
      name: 'users',
      dartName: 'AppUser',
      schema: 'public',
      module: 'plataforma_os',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'user_type',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'full_name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'status',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'locale',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'version',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: false,
    ),
    ..._isp.Protocol.targetTableDefinitions,
  ];

  static String? getClassNameFromObjectJson(dynamic data) => _is.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _is.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _is.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _iqp78482.ContactOrigin) {
      return _iqp78482.ContactOrigin.fromJson(data) as T;
    }
    if (t == _iplumur6.ContactRole) {
      return _iplumur6.ContactRole.fromJson(data) as T;
    }
    if (t == _izqw5q67.ContactStatus) {
      return _izqw5q67.ContactStatus.fromJson(data) as T;
    }
    if (t == _in2ysqih.Customer) {
      return _in2ysqih.Customer.fromJson(data) as T;
    }
    if (t == _iyonel9d.CustomerContact) {
      return _iyonel9d.CustomerContact.fromJson(data) as T;
    }
    if (t == _ial9yste.CustomerContactField) {
      return _ial9yste.CustomerContactField.fromJson(data) as T;
    }
    if (t == _izv3bdkd.CustomerContactFilter) {
      return _izv3bdkd.CustomerContactFilter.fromJson(data) as T;
    }
    if (t == _i8ppoe04.CustomerContactInput) {
      return _i8ppoe04.CustomerContactInput.fromJson(data) as T;
    }
    if (t == _ifqwfvr5.CustomerContactPage) {
      return _ifqwfvr5.CustomerContactPage.fromJson(data) as T;
    }
    if (t == _i8xalfaz.CustomerContactPatch) {
      return _i8xalfaz.CustomerContactPatch.fromJson(data) as T;
    }
    if (t == _i3eh97aw.CustomerField) {
      return _i3eh97aw.CustomerField.fromJson(data) as T;
    }
    if (t == _i4w7b2hn.CustomerFilter) {
      return _i4w7b2hn.CustomerFilter.fromJson(data) as T;
    }
    if (t == _i54pcl9h.CustomerInput) {
      return _i54pcl9h.CustomerInput.fromJson(data) as T;
    }
    if (t == _i71gi8vd.CustomerKind) {
      return _i71gi8vd.CustomerKind.fromJson(data) as T;
    }
    if (t == _iu4jficl.CustomerPage) {
      return _iu4jficl.CustomerPage.fromJson(data) as T;
    }
    if (t == _ib2ck4oj.CustomerPatch) {
      return _ib2ck4oj.CustomerPatch.fromJson(data) as T;
    }
    if (t == _ihhtee09.CustomerSite) {
      return _ihhtee09.CustomerSite.fromJson(data) as T;
    }
    if (t == _iyqdtrh1.CustomerSiteField) {
      return _iyqdtrh1.CustomerSiteField.fromJson(data) as T;
    }
    if (t == _ifq4omy3.CustomerSiteFilter) {
      return _ifq4omy3.CustomerSiteFilter.fromJson(data) as T;
    }
    if (t == _ii01wxyo.CustomerSiteInput) {
      return _ii01wxyo.CustomerSiteInput.fromJson(data) as T;
    }
    if (t == _ibmnlo2x.CustomerSitePage) {
      return _ibmnlo2x.CustomerSitePage.fromJson(data) as T;
    }
    if (t == _i7pxbyck.CustomerSitePatch) {
      return _i7pxbyck.CustomerSitePatch.fromJson(data) as T;
    }
    if (t == _ioxz8xmy.DocumentType) {
      return _ioxz8xmy.DocumentType.fromJson(data) as T;
    }
    if (t == _ipthj0tj.NotificationChannel) {
      return _ipthj0tj.NotificationChannel.fromJson(data) as T;
    }
    if (t == _ibxir450.PersonType) {
      return _ibxir450.PersonType.fromJson(data) as T;
    }
    if (t == _i5wnkftg.AppUser) {
      return _i5wnkftg.AppUser.fromJson(data) as T;
    }
    if (t == _ip4w8f8l.MeInfo) {
      return _ip4w8f8l.MeInfo.fromJson(data) as T;
    }
    if (t == _i2vwv4gx.MembershipStatus) {
      return _i2vwv4gx.MembershipStatus.fromJson(data) as T;
    }
    if (t == _i1iyeyn1.TenantMembership) {
      return _i1iyeyn1.TenantMembership.fromJson(data) as T;
    }
    if (t == _iutn78jy.TenantMembershipRole) {
      return _iutn78jy.TenantMembershipRole.fromJson(data) as T;
    }
    if (t == _izyppcov.TenantToken) {
      return _izyppcov.TenantToken.fromJson(data) as T;
    }
    if (t == _i147o0qx.ApiException) {
      return _i147o0qx.ApiException.fromJson(data) as T;
    }
    if (t == _i0p9y4c3.ErrorCategory) {
      return _i0p9y4c3.ErrorCategory.fromJson(data) as T;
    }
    if (t == _i3z3bgdl.FieldError) {
      return _i3z3bgdl.FieldError.fromJson(data) as T;
    }
    if (t == _i43haw30.RecordSource) {
      return _i43haw30.RecordSource.fromJson(data) as T;
    }
    if (t == _i18yzlaa.PageRequest) {
      return _i18yzlaa.PageRequest.fromJson(data) as T;
    }
    if (t == _i2jhpzjh.Tenant) {
      return _i2jhpzjh.Tenant.fromJson(data) as T;
    }
    if (t == _i2bjgc9x.TenantStatus) {
      return _i2bjgc9x.TenantStatus.fromJson(data) as T;
    }
    if (t == _i9uizrsf.TenantSummary) {
      return _i9uizrsf.TenantSummary.fromJson(data) as T;
    }
    if (t == _is.getType<_iqp78482.ContactOrigin?>()) {
      return (data != null ? _iqp78482.ContactOrigin.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iplumur6.ContactRole?>()) {
      return (data != null ? _iplumur6.ContactRole.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izqw5q67.ContactStatus?>()) {
      return (data != null ? _izqw5q67.ContactStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_in2ysqih.Customer?>()) {
      return (data != null ? _in2ysqih.Customer.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyonel9d.CustomerContact?>()) {
      return (data != null ? _iyonel9d.CustomerContact.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ial9yste.CustomerContactField?>()) {
      return (data != null ? _ial9yste.CustomerContactField.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izv3bdkd.CustomerContactFilter?>()) {
      return (data != null ? _izv3bdkd.CustomerContactFilter.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8ppoe04.CustomerContactInput?>()) {
      return (data != null ? _i8ppoe04.CustomerContactInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifqwfvr5.CustomerContactPage?>()) {
      return (data != null ? _ifqwfvr5.CustomerContactPage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8xalfaz.CustomerContactPatch?>()) {
      return (data != null ? _i8xalfaz.CustomerContactPatch.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3eh97aw.CustomerField?>()) {
      return (data != null ? _i3eh97aw.CustomerField.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4w7b2hn.CustomerFilter?>()) {
      return (data != null ? _i4w7b2hn.CustomerFilter.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i54pcl9h.CustomerInput?>()) {
      return (data != null ? _i54pcl9h.CustomerInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i71gi8vd.CustomerKind?>()) {
      return (data != null ? _i71gi8vd.CustomerKind.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iu4jficl.CustomerPage?>()) {
      return (data != null ? _iu4jficl.CustomerPage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ib2ck4oj.CustomerPatch?>()) {
      return (data != null ? _ib2ck4oj.CustomerPatch.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihhtee09.CustomerSite?>()) {
      return (data != null ? _ihhtee09.CustomerSite.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyqdtrh1.CustomerSiteField?>()) {
      return (data != null ? _iyqdtrh1.CustomerSiteField.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifq4omy3.CustomerSiteFilter?>()) {
      return (data != null ? _ifq4omy3.CustomerSiteFilter.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ii01wxyo.CustomerSiteInput?>()) {
      return (data != null ? _ii01wxyo.CustomerSiteInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ibmnlo2x.CustomerSitePage?>()) {
      return (data != null ? _ibmnlo2x.CustomerSitePage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i7pxbyck.CustomerSitePatch?>()) {
      return (data != null ? _i7pxbyck.CustomerSitePatch.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ioxz8xmy.DocumentType?>()) {
      return (data != null ? _ioxz8xmy.DocumentType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ipthj0tj.NotificationChannel?>()) {
      return (data != null ? _ipthj0tj.NotificationChannel.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ibxir450.PersonType?>()) {
      return (data != null ? _ibxir450.PersonType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5wnkftg.AppUser?>()) {
      return (data != null ? _i5wnkftg.AppUser.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ip4w8f8l.MeInfo?>()) {
      return (data != null ? _ip4w8f8l.MeInfo.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2vwv4gx.MembershipStatus?>()) {
      return (data != null ? _i2vwv4gx.MembershipStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1iyeyn1.TenantMembership?>()) {
      return (data != null ? _i1iyeyn1.TenantMembership.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iutn78jy.TenantMembershipRole?>()) {
      return (data != null ? _iutn78jy.TenantMembershipRole.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_izyppcov.TenantToken?>()) {
      return (data != null ? _izyppcov.TenantToken.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i147o0qx.ApiException?>()) {
      return (data != null ? _i147o0qx.ApiException.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0p9y4c3.ErrorCategory?>()) {
      return (data != null ? _i0p9y4c3.ErrorCategory.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3z3bgdl.FieldError?>()) {
      return (data != null ? _i3z3bgdl.FieldError.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i43haw30.RecordSource?>()) {
      return (data != null ? _i43haw30.RecordSource.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i18yzlaa.PageRequest?>()) {
      return (data != null ? _i18yzlaa.PageRequest.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2jhpzjh.Tenant?>()) {
      return (data != null ? _i2jhpzjh.Tenant.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2bjgc9x.TenantStatus?>()) {
      return (data != null ? _i2bjgc9x.TenantStatus.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i9uizrsf.TenantSummary?>()) {
      return (data != null ? _i9uizrsf.TenantSummary.fromJson(data) : null) as T;
    }
    if (t == List<_iyonel9d.CustomerContact>) {
      return (data as List).map((e) => deserialize<_iyonel9d.CustomerContact>(e)).toList() as T;
    }
    if (t == List<_ial9yste.CustomerContactField>) {
      return (data as List).map((e) => deserialize<_ial9yste.CustomerContactField>(e)).toList() as T;
    }
    if (t == _is.getType<List<_ial9yste.CustomerContactField>?>()) {
      return (data != null ? (data as List).map((e) => deserialize<_ial9yste.CustomerContactField>(e)).toList() : null)
          as T;
    }
    if (t == List<_in2ysqih.Customer>) {
      return (data as List).map((e) => deserialize<_in2ysqih.Customer>(e)).toList() as T;
    }
    if (t == List<_i3eh97aw.CustomerField>) {
      return (data as List).map((e) => deserialize<_i3eh97aw.CustomerField>(e)).toList() as T;
    }
    if (t == _is.getType<List<_i3eh97aw.CustomerField>?>()) {
      return (data != null ? (data as List).map((e) => deserialize<_i3eh97aw.CustomerField>(e)).toList() : null) as T;
    }
    if (t == List<_ihhtee09.CustomerSite>) {
      return (data as List).map((e) => deserialize<_ihhtee09.CustomerSite>(e)).toList() as T;
    }
    if (t == List<_iyqdtrh1.CustomerSiteField>) {
      return (data as List).map((e) => deserialize<_iyqdtrh1.CustomerSiteField>(e)).toList() as T;
    }
    if (t == _is.getType<List<_iyqdtrh1.CustomerSiteField>?>()) {
      return (data != null ? (data as List).map((e) => deserialize<_iyqdtrh1.CustomerSiteField>(e)).toList() : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i3z3bgdl.FieldError>) {
      return (data as List).map((e) => deserialize<_i3z3bgdl.FieldError>(e)).toList() as T;
    }
    if (t == _is.getType<List<_i3z3bgdl.FieldError>?>()) {
      return (data != null ? (data as List).map((e) => deserialize<_i3z3bgdl.FieldError>(e)).toList() : null) as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v))) as T;
    }
    if (t == _is.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)))
              : null)
          as T;
    }
    if (t == List<_inphvrgt.TenantSummary>) {
      return (data as List).map((e) => deserialize<_inphvrgt.TenantSummary>(e)).toList() as T;
    }
    final modules = deserializationMetadata.modulesForDeserialization(
      t,
      className: rawDataClassName,
    );
    for (final module in modules) {
      try {
        return module.deserialize<T>(data, t);
      } on _is.DeserializationTypeNotFoundException catch (_) {}
    }

    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iqp78482.ContactOrigin => 'ContactOrigin',
      _iplumur6.ContactRole => 'ContactRole',
      _izqw5q67.ContactStatus => 'ContactStatus',
      _in2ysqih.Customer => 'Customer',
      _iyonel9d.CustomerContact => 'CustomerContact',
      _ial9yste.CustomerContactField => 'CustomerContactField',
      _izv3bdkd.CustomerContactFilter => 'CustomerContactFilter',
      _i8ppoe04.CustomerContactInput => 'CustomerContactInput',
      _ifqwfvr5.CustomerContactPage => 'CustomerContactPage',
      _i8xalfaz.CustomerContactPatch => 'CustomerContactPatch',
      _i3eh97aw.CustomerField => 'CustomerField',
      _i4w7b2hn.CustomerFilter => 'CustomerFilter',
      _i54pcl9h.CustomerInput => 'CustomerInput',
      _i71gi8vd.CustomerKind => 'CustomerKind',
      _iu4jficl.CustomerPage => 'CustomerPage',
      _ib2ck4oj.CustomerPatch => 'CustomerPatch',
      _ihhtee09.CustomerSite => 'CustomerSite',
      _iyqdtrh1.CustomerSiteField => 'CustomerSiteField',
      _ifq4omy3.CustomerSiteFilter => 'CustomerSiteFilter',
      _ii01wxyo.CustomerSiteInput => 'CustomerSiteInput',
      _ibmnlo2x.CustomerSitePage => 'CustomerSitePage',
      _i7pxbyck.CustomerSitePatch => 'CustomerSitePatch',
      _ioxz8xmy.DocumentType => 'DocumentType',
      _ipthj0tj.NotificationChannel => 'NotificationChannel',
      _ibxir450.PersonType => 'PersonType',
      _i5wnkftg.AppUser => 'AppUser',
      _ip4w8f8l.MeInfo => 'MeInfo',
      _i2vwv4gx.MembershipStatus => 'MembershipStatus',
      _i1iyeyn1.TenantMembership => 'TenantMembership',
      _iutn78jy.TenantMembershipRole => 'TenantMembershipRole',
      _izyppcov.TenantToken => 'TenantToken',
      _i147o0qx.ApiException => 'ApiException',
      _i0p9y4c3.ErrorCategory => 'ErrorCategory',
      _i3z3bgdl.FieldError => 'FieldError',
      _i43haw30.RecordSource => 'RecordSource',
      _i18yzlaa.PageRequest => 'PageRequest',
      _i2jhpzjh.Tenant => 'Tenant',
      _i2bjgc9x.TenantStatus => 'TenantStatus',
      _i9uizrsf.TenantSummary => 'TenantSummary',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('plataforma_os.', '');
    }

    switch (data) {
      case _iqp78482.ContactOrigin():
        return 'ContactOrigin';
      case _iplumur6.ContactRole():
        return 'ContactRole';
      case _izqw5q67.ContactStatus():
        return 'ContactStatus';
      case _in2ysqih.Customer():
        return 'Customer';
      case _iyonel9d.CustomerContact():
        return 'CustomerContact';
      case _ial9yste.CustomerContactField():
        return 'CustomerContactField';
      case _izv3bdkd.CustomerContactFilter():
        return 'CustomerContactFilter';
      case _i8ppoe04.CustomerContactInput():
        return 'CustomerContactInput';
      case _ifqwfvr5.CustomerContactPage():
        return 'CustomerContactPage';
      case _i8xalfaz.CustomerContactPatch():
        return 'CustomerContactPatch';
      case _i3eh97aw.CustomerField():
        return 'CustomerField';
      case _i4w7b2hn.CustomerFilter():
        return 'CustomerFilter';
      case _i54pcl9h.CustomerInput():
        return 'CustomerInput';
      case _i71gi8vd.CustomerKind():
        return 'CustomerKind';
      case _iu4jficl.CustomerPage():
        return 'CustomerPage';
      case _ib2ck4oj.CustomerPatch():
        return 'CustomerPatch';
      case _ihhtee09.CustomerSite():
        return 'CustomerSite';
      case _iyqdtrh1.CustomerSiteField():
        return 'CustomerSiteField';
      case _ifq4omy3.CustomerSiteFilter():
        return 'CustomerSiteFilter';
      case _ii01wxyo.CustomerSiteInput():
        return 'CustomerSiteInput';
      case _ibmnlo2x.CustomerSitePage():
        return 'CustomerSitePage';
      case _i7pxbyck.CustomerSitePatch():
        return 'CustomerSitePatch';
      case _ioxz8xmy.DocumentType():
        return 'DocumentType';
      case _ipthj0tj.NotificationChannel():
        return 'NotificationChannel';
      case _ibxir450.PersonType():
        return 'PersonType';
      case _i5wnkftg.AppUser():
        return 'AppUser';
      case _ip4w8f8l.MeInfo():
        return 'MeInfo';
      case _i2vwv4gx.MembershipStatus():
        return 'MembershipStatus';
      case _i1iyeyn1.TenantMembership():
        return 'TenantMembership';
      case _iutn78jy.TenantMembershipRole():
        return 'TenantMembershipRole';
      case _izyppcov.TenantToken():
        return 'TenantToken';
      case _i147o0qx.ApiException():
        return 'ApiException';
      case _i0p9y4c3.ErrorCategory():
        return 'ErrorCategory';
      case _i3z3bgdl.FieldError():
        return 'FieldError';
      case _i43haw30.RecordSource():
        return 'RecordSource';
      case _i18yzlaa.PageRequest():
        return 'PageRequest';
      case _i2jhpzjh.Tenant():
        return 'Tenant';
      case _i2bjgc9x.TenantStatus():
        return 'TenantStatus';
      case _i9uizrsf.TenantSummary():
        return 'TenantSummary';
    }
    className = _isp.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'ContactOrigin') {
      return deserialize<_iqp78482.ContactOrigin>(data['data']);
    }
    if (dataClassName == 'ContactRole') {
      return deserialize<_iplumur6.ContactRole>(data['data']);
    }
    if (dataClassName == 'ContactStatus') {
      return deserialize<_izqw5q67.ContactStatus>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_in2ysqih.Customer>(data['data']);
    }
    if (dataClassName == 'CustomerContact') {
      return deserialize<_iyonel9d.CustomerContact>(data['data']);
    }
    if (dataClassName == 'CustomerContactField') {
      return deserialize<_ial9yste.CustomerContactField>(data['data']);
    }
    if (dataClassName == 'CustomerContactFilter') {
      return deserialize<_izv3bdkd.CustomerContactFilter>(data['data']);
    }
    if (dataClassName == 'CustomerContactInput') {
      return deserialize<_i8ppoe04.CustomerContactInput>(data['data']);
    }
    if (dataClassName == 'CustomerContactPage') {
      return deserialize<_ifqwfvr5.CustomerContactPage>(data['data']);
    }
    if (dataClassName == 'CustomerContactPatch') {
      return deserialize<_i8xalfaz.CustomerContactPatch>(data['data']);
    }
    if (dataClassName == 'CustomerField') {
      return deserialize<_i3eh97aw.CustomerField>(data['data']);
    }
    if (dataClassName == 'CustomerFilter') {
      return deserialize<_i4w7b2hn.CustomerFilter>(data['data']);
    }
    if (dataClassName == 'CustomerInput') {
      return deserialize<_i54pcl9h.CustomerInput>(data['data']);
    }
    if (dataClassName == 'CustomerKind') {
      return deserialize<_i71gi8vd.CustomerKind>(data['data']);
    }
    if (dataClassName == 'CustomerPage') {
      return deserialize<_iu4jficl.CustomerPage>(data['data']);
    }
    if (dataClassName == 'CustomerPatch') {
      return deserialize<_ib2ck4oj.CustomerPatch>(data['data']);
    }
    if (dataClassName == 'CustomerSite') {
      return deserialize<_ihhtee09.CustomerSite>(data['data']);
    }
    if (dataClassName == 'CustomerSiteField') {
      return deserialize<_iyqdtrh1.CustomerSiteField>(data['data']);
    }
    if (dataClassName == 'CustomerSiteFilter') {
      return deserialize<_ifq4omy3.CustomerSiteFilter>(data['data']);
    }
    if (dataClassName == 'CustomerSiteInput') {
      return deserialize<_ii01wxyo.CustomerSiteInput>(data['data']);
    }
    if (dataClassName == 'CustomerSitePage') {
      return deserialize<_ibmnlo2x.CustomerSitePage>(data['data']);
    }
    if (dataClassName == 'CustomerSitePatch') {
      return deserialize<_i7pxbyck.CustomerSitePatch>(data['data']);
    }
    if (dataClassName == 'DocumentType') {
      return deserialize<_ioxz8xmy.DocumentType>(data['data']);
    }
    if (dataClassName == 'NotificationChannel') {
      return deserialize<_ipthj0tj.NotificationChannel>(data['data']);
    }
    if (dataClassName == 'PersonType') {
      return deserialize<_ibxir450.PersonType>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i5wnkftg.AppUser>(data['data']);
    }
    if (dataClassName == 'MeInfo') {
      return deserialize<_ip4w8f8l.MeInfo>(data['data']);
    }
    if (dataClassName == 'MembershipStatus') {
      return deserialize<_i2vwv4gx.MembershipStatus>(data['data']);
    }
    if (dataClassName == 'TenantMembership') {
      return deserialize<_i1iyeyn1.TenantMembership>(data['data']);
    }
    if (dataClassName == 'TenantMembershipRole') {
      return deserialize<_iutn78jy.TenantMembershipRole>(data['data']);
    }
    if (dataClassName == 'TenantToken') {
      return deserialize<_izyppcov.TenantToken>(data['data']);
    }
    if (dataClassName == 'ApiException') {
      return deserialize<_i147o0qx.ApiException>(data['data']);
    }
    if (dataClassName == 'ErrorCategory') {
      return deserialize<_i0p9y4c3.ErrorCategory>(data['data']);
    }
    if (dataClassName == 'FieldError') {
      return deserialize<_i3z3bgdl.FieldError>(data['data']);
    }
    if (dataClassName == 'RecordSource') {
      return deserialize<_i43haw30.RecordSource>(data['data']);
    }
    if (dataClassName == 'PageRequest') {
      return deserialize<_i18yzlaa.PageRequest>(data['data']);
    }
    if (dataClassName == 'Tenant') {
      return deserialize<_i2jhpzjh.Tenant>(data['data']);
    }
    if (dataClassName == 'TenantStatus') {
      return deserialize<_i2bjgc9x.TenantStatus>(data['data']);
    }
    if (dataClassName == 'TenantSummary') {
      return deserialize<_i9uizrsf.TenantSummary>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      return _isp.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(10),
      });
    }
    return super.deserializeByClassName(data);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _in2ysqih.Customer:
        return _in2ysqih.Customer.t;
      case _iyonel9d.CustomerContact:
        return _iyonel9d.CustomerContact.t;
      case _ihhtee09.CustomerSite:
        return _ihhtee09.CustomerSite.t;
      case _i5wnkftg.AppUser:
        return _i5wnkftg.AppUser.t;
      case _i1iyeyn1.TenantMembership:
        return _i1iyeyn1.TenantMembership.t;
      case _iutn78jy.TenantMembershipRole:
        return _iutn78jy.TenantMembershipRole.t;
      case _i2jhpzjh.Tenant:
        return _i2jhpzjh.Tenant.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() => targetTableDefinitions;

  @override
  String getModuleName() => 'plataforma_os';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    try {
      return _isp.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
