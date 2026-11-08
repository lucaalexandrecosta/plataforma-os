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
import 'package:plataforma_os_client/src/protocol/imports/models/import_entity_type.dart' as _iielyi2l;
import 'package:plataforma_os_client/src/protocol/tenancy/models/tenant_summary.dart' as _i11upz4e;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'catalog/models/product.dart' as _i6qsbw6s;
import 'catalog/models/product_family.dart' as _is31bq1v;
import 'catalog/models/product_family_filter.dart' as _ifcfic11;
import 'catalog/models/product_family_input.dart' as _iroevrq4;
import 'catalog/models/product_family_page.dart' as _iaslsjiy;
import 'catalog/models/product_family_patch.dart' as _iw5gfrqk;
import 'catalog/models/product_field.dart' as _ix63vfv9;
import 'catalog/models/product_filter.dart' as _isilke9y;
import 'catalog/models/product_input.dart' as _iuumnsch;
import 'catalog/models/product_kind.dart' as _iobp0yx9;
import 'catalog/models/product_page.dart' as _isfcb5kd;
import 'catalog/models/product_patch.dart' as _ipm6h84l;
import 'catalog/models/service.dart' as _izvigl9t;
import 'catalog/models/service_field.dart' as _igf61u0d;
import 'catalog/models/service_filter.dart' as _ikr943tt;
import 'catalog/models/service_input.dart' as _igake8jw;
import 'catalog/models/service_kind.dart' as _imdz65g6;
import 'catalog/models/service_page.dart' as _i9t71zax;
import 'catalog/models/service_patch.dart' as _izp6dh5z;
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
import 'imports/models/import_column_info.dart' as _icg69u6o;
import 'imports/models/import_entity_type.dart' as _iwgsqujn;
import 'imports/models/import_preview.dart' as _iif57p8v;
import 'imports/models/import_row_error.dart' as _ir725yxh;
import 'imports/models/import_run.dart' as _ifdy2oae;
import 'imports/models/import_run_info.dart' as _i03h52ft;
import 'imports/models/import_run_page.dart' as _ibothc5b;
import 'imports/models/import_stats.dart' as _izpdvybk;
import 'imports/models/import_template.dart' as _i7o6x8tv;
import 'imports/models/sync_run_mode.dart' as _itk81loi;
import 'imports/models/sync_run_status.dart' as _ilybb2c3;
import 'imports/models/sync_run_trigger.dart' as _ivfbxo2c;
import 'platform/errors/models/api_exception.dart' as _i147o0qx;
import 'platform/errors/models/error_category.dart' as _i0p9y4c3;
import 'platform/errors/models/field_error.dart' as _i3z3bgdl;
import 'platform/models/record_source.dart' as _i43haw30;
import 'platform/paging/models/page_request.dart' as _i18yzlaa;
import 'tenancy/models/tenant.dart' as _i2jhpzjh;
import 'tenancy/models/tenant_status.dart' as _i2bjgc9x;
import 'tenancy/models/tenant_summary.dart' as _i9uizrsf;
export 'catalog/models/product.dart';
export 'catalog/models/product_family.dart';
export 'catalog/models/product_family_filter.dart';
export 'catalog/models/product_family_input.dart';
export 'catalog/models/product_family_page.dart';
export 'catalog/models/product_family_patch.dart';
export 'catalog/models/product_field.dart';
export 'catalog/models/product_filter.dart';
export 'catalog/models/product_input.dart';
export 'catalog/models/product_kind.dart';
export 'catalog/models/product_page.dart';
export 'catalog/models/product_patch.dart';
export 'catalog/models/service.dart';
export 'catalog/models/service_field.dart';
export 'catalog/models/service_filter.dart';
export 'catalog/models/service_input.dart';
export 'catalog/models/service_kind.dart';
export 'catalog/models/service_page.dart';
export 'catalog/models/service_patch.dart';
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
export 'imports/models/import_column_info.dart';
export 'imports/models/import_entity_type.dart';
export 'imports/models/import_preview.dart';
export 'imports/models/import_row_error.dart';
export 'imports/models/import_run.dart';
export 'imports/models/import_run_info.dart';
export 'imports/models/import_run_page.dart';
export 'imports/models/import_stats.dart';
export 'imports/models/import_template.dart';
export 'imports/models/sync_run_mode.dart';
export 'imports/models/sync_run_status.dart';
export 'imports/models/sync_run_trigger.dart';
export 'platform/errors/models/api_exception.dart';
export 'platform/errors/models/error_category.dart';
export 'platform/errors/models/field_error.dart';
export 'platform/models/record_source.dart';
export 'platform/paging/models/page_request.dart';
export 'tenancy/models/tenant.dart';
export 'tenancy/models/tenant_status.dart';
export 'tenancy/models/tenant_summary.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager implements _isc.ProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  @override
  _isc.ProtocolDeserialization get deserializationMetadata => _isc.ProtocolDeserialization.cached(
    this,
    types: const [
      _isc.getType<_i6qsbw6s.Product>,
      _isc.getType<_is31bq1v.ProductFamily>,
      _isc.getType<_ifcfic11.ProductFamilyFilter>,
      _isc.getType<_iroevrq4.ProductFamilyInput>,
      _isc.getType<_iaslsjiy.ProductFamilyPage>,
      _isc.getType<_iw5gfrqk.ProductFamilyPatch>,
      _isc.getType<_ix63vfv9.ProductField>,
      _isc.getType<_isilke9y.ProductFilter>,
      _isc.getType<_iuumnsch.ProductInput>,
      _isc.getType<_iobp0yx9.ProductKind>,
      _isc.getType<_isfcb5kd.ProductPage>,
      _isc.getType<_ipm6h84l.ProductPatch>,
      _isc.getType<_izvigl9t.CatalogService>,
      _isc.getType<_igf61u0d.CatalogServiceField>,
      _isc.getType<_ikr943tt.CatalogServiceFilter>,
      _isc.getType<_igake8jw.CatalogServiceInput>,
      _isc.getType<_imdz65g6.ServiceKind>,
      _isc.getType<_i9t71zax.CatalogServicePage>,
      _isc.getType<_izp6dh5z.CatalogServicePatch>,
      _isc.getType<_iqp78482.ContactOrigin>,
      _isc.getType<_iplumur6.ContactRole>,
      _isc.getType<_izqw5q67.ContactStatus>,
      _isc.getType<_in2ysqih.Customer>,
      _isc.getType<_iyonel9d.CustomerContact>,
      _isc.getType<_ial9yste.CustomerContactField>,
      _isc.getType<_izv3bdkd.CustomerContactFilter>,
      _isc.getType<_i8ppoe04.CustomerContactInput>,
      _isc.getType<_ifqwfvr5.CustomerContactPage>,
      _isc.getType<_i8xalfaz.CustomerContactPatch>,
      _isc.getType<_i3eh97aw.CustomerField>,
      _isc.getType<_i4w7b2hn.CustomerFilter>,
      _isc.getType<_i54pcl9h.CustomerInput>,
      _isc.getType<_i71gi8vd.CustomerKind>,
      _isc.getType<_iu4jficl.CustomerPage>,
      _isc.getType<_ib2ck4oj.CustomerPatch>,
      _isc.getType<_ihhtee09.CustomerSite>,
      _isc.getType<_iyqdtrh1.CustomerSiteField>,
      _isc.getType<_ifq4omy3.CustomerSiteFilter>,
      _isc.getType<_ii01wxyo.CustomerSiteInput>,
      _isc.getType<_ibmnlo2x.CustomerSitePage>,
      _isc.getType<_i7pxbyck.CustomerSitePatch>,
      _isc.getType<_ioxz8xmy.DocumentType>,
      _isc.getType<_ipthj0tj.NotificationChannel>,
      _isc.getType<_ibxir450.PersonType>,
      _isc.getType<_i5wnkftg.AppUser>,
      _isc.getType<_ip4w8f8l.MeInfo>,
      _isc.getType<_i2vwv4gx.MembershipStatus>,
      _isc.getType<_i1iyeyn1.TenantMembership>,
      _isc.getType<_iutn78jy.TenantMembershipRole>,
      _isc.getType<_izyppcov.TenantToken>,
      _isc.getType<_icg69u6o.ImportColumnInfo>,
      _isc.getType<_iwgsqujn.ImportEntityType>,
      _isc.getType<_iif57p8v.ImportPreview>,
      _isc.getType<_ir725yxh.ImportRowError>,
      _isc.getType<_ifdy2oae.ImportRun>,
      _isc.getType<_i03h52ft.ImportRunInfo>,
      _isc.getType<_ibothc5b.ImportRunPage>,
      _isc.getType<_izpdvybk.ImportStats>,
      _isc.getType<_i7o6x8tv.ImportTemplate>,
      _isc.getType<_itk81loi.SyncRunMode>,
      _isc.getType<_ilybb2c3.SyncRunStatus>,
      _isc.getType<_ivfbxo2c.SyncRunTrigger>,
      _isc.getType<_i147o0qx.ApiException>,
      _isc.getType<_i0p9y4c3.ErrorCategory>,
      _isc.getType<_i3z3bgdl.FieldError>,
      _isc.getType<_i43haw30.RecordSource>,
      _isc.getType<_i18yzlaa.PageRequest>,
      _isc.getType<_i2jhpzjh.Tenant>,
      _isc.getType<_i2bjgc9x.TenantStatus>,
      _isc.getType<_i9uizrsf.TenantSummary>,
      _isc.getType<_i6qsbw6s.Product?>,
      _isc.getType<_is31bq1v.ProductFamily?>,
      _isc.getType<_ifcfic11.ProductFamilyFilter?>,
      _isc.getType<_iroevrq4.ProductFamilyInput?>,
      _isc.getType<_iaslsjiy.ProductFamilyPage?>,
      _isc.getType<_iw5gfrqk.ProductFamilyPatch?>,
      _isc.getType<_ix63vfv9.ProductField?>,
      _isc.getType<_isilke9y.ProductFilter?>,
      _isc.getType<_iuumnsch.ProductInput?>,
      _isc.getType<_iobp0yx9.ProductKind?>,
      _isc.getType<_isfcb5kd.ProductPage?>,
      _isc.getType<_ipm6h84l.ProductPatch?>,
      _isc.getType<_izvigl9t.CatalogService?>,
      _isc.getType<_igf61u0d.CatalogServiceField?>,
      _isc.getType<_ikr943tt.CatalogServiceFilter?>,
      _isc.getType<_igake8jw.CatalogServiceInput?>,
      _isc.getType<_imdz65g6.ServiceKind?>,
      _isc.getType<_i9t71zax.CatalogServicePage?>,
      _isc.getType<_izp6dh5z.CatalogServicePatch?>,
      _isc.getType<_iqp78482.ContactOrigin?>,
      _isc.getType<_iplumur6.ContactRole?>,
      _isc.getType<_izqw5q67.ContactStatus?>,
      _isc.getType<_in2ysqih.Customer?>,
      _isc.getType<_iyonel9d.CustomerContact?>,
      _isc.getType<_ial9yste.CustomerContactField?>,
      _isc.getType<_izv3bdkd.CustomerContactFilter?>,
      _isc.getType<_i8ppoe04.CustomerContactInput?>,
      _isc.getType<_ifqwfvr5.CustomerContactPage?>,
      _isc.getType<_i8xalfaz.CustomerContactPatch?>,
      _isc.getType<_i3eh97aw.CustomerField?>,
      _isc.getType<_i4w7b2hn.CustomerFilter?>,
      _isc.getType<_i54pcl9h.CustomerInput?>,
      _isc.getType<_i71gi8vd.CustomerKind?>,
      _isc.getType<_iu4jficl.CustomerPage?>,
      _isc.getType<_ib2ck4oj.CustomerPatch?>,
      _isc.getType<_ihhtee09.CustomerSite?>,
      _isc.getType<_iyqdtrh1.CustomerSiteField?>,
      _isc.getType<_ifq4omy3.CustomerSiteFilter?>,
      _isc.getType<_ii01wxyo.CustomerSiteInput?>,
      _isc.getType<_ibmnlo2x.CustomerSitePage?>,
      _isc.getType<_i7pxbyck.CustomerSitePatch?>,
      _isc.getType<_ioxz8xmy.DocumentType?>,
      _isc.getType<_ipthj0tj.NotificationChannel?>,
      _isc.getType<_ibxir450.PersonType?>,
      _isc.getType<_i5wnkftg.AppUser?>,
      _isc.getType<_ip4w8f8l.MeInfo?>,
      _isc.getType<_i2vwv4gx.MembershipStatus?>,
      _isc.getType<_i1iyeyn1.TenantMembership?>,
      _isc.getType<_iutn78jy.TenantMembershipRole?>,
      _isc.getType<_izyppcov.TenantToken?>,
      _isc.getType<_icg69u6o.ImportColumnInfo?>,
      _isc.getType<_iwgsqujn.ImportEntityType?>,
      _isc.getType<_iif57p8v.ImportPreview?>,
      _isc.getType<_ir725yxh.ImportRowError?>,
      _isc.getType<_ifdy2oae.ImportRun?>,
      _isc.getType<_i03h52ft.ImportRunInfo?>,
      _isc.getType<_ibothc5b.ImportRunPage?>,
      _isc.getType<_izpdvybk.ImportStats?>,
      _isc.getType<_i7o6x8tv.ImportTemplate?>,
      _isc.getType<_itk81loi.SyncRunMode?>,
      _isc.getType<_ilybb2c3.SyncRunStatus?>,
      _isc.getType<_ivfbxo2c.SyncRunTrigger?>,
      _isc.getType<_i147o0qx.ApiException?>,
      _isc.getType<_i0p9y4c3.ErrorCategory?>,
      _isc.getType<_i3z3bgdl.FieldError?>,
      _isc.getType<_i43haw30.RecordSource?>,
      _isc.getType<_i18yzlaa.PageRequest?>,
      _isc.getType<_i2jhpzjh.Tenant?>,
      _isc.getType<_i2bjgc9x.TenantStatus?>,
      _isc.getType<_i9uizrsf.TenantSummary?>,
      _isc.getType<List<_is31bq1v.ProductFamily>>,
      _isc.getType<List<_i6qsbw6s.Product>>,
      _isc.getType<List<_ix63vfv9.ProductField>>,
      _isc.getType<List<_ix63vfv9.ProductField>?>,
      _isc.getType<List<_izvigl9t.CatalogService>>,
      _isc.getType<List<_igf61u0d.CatalogServiceField>>,
      _isc.getType<List<_igf61u0d.CatalogServiceField>?>,
      _isc.getType<List<_iyonel9d.CustomerContact>>,
      _isc.getType<List<_ial9yste.CustomerContactField>>,
      _isc.getType<List<_ial9yste.CustomerContactField>?>,
      _isc.getType<List<_in2ysqih.Customer>>,
      _isc.getType<List<_i3eh97aw.CustomerField>>,
      _isc.getType<List<_i3eh97aw.CustomerField>?>,
      _isc.getType<List<_ihhtee09.CustomerSite>>,
      _isc.getType<List<_iyqdtrh1.CustomerSiteField>>,
      _isc.getType<List<_iyqdtrh1.CustomerSiteField>?>,
      _isc.getType<List<String>>,
      _isc.getType<List<_ir725yxh.ImportRowError>>,
      _isc.getType<List<_i03h52ft.ImportRunInfo>>,
      _isc.getType<List<_icg69u6o.ImportColumnInfo>>,
      _isc.getType<List<_i3z3bgdl.FieldError>>,
      _isc.getType<List<_i3z3bgdl.FieldError>?>,
      _isc.getType<Map<String, String>>,
      _isc.getType<Map<String, String>?>,
      _isc.getType<List<_i11upz4e.TenantSummary>>,
      _isc.getType<List<_iielyi2l.ImportEntityType>>,
    ],
    modules: const [],
    classNames: const [
      'Product',
      'ProductFamily',
      'ProductFamilyFilter',
      'ProductFamilyInput',
      'ProductFamilyPage',
      'ProductFamilyPatch',
      'ProductField',
      'ProductFilter',
      'ProductInput',
      'ProductKind',
      'ProductPage',
      'ProductPatch',
      'CatalogService',
      'CatalogServiceField',
      'CatalogServiceFilter',
      'CatalogServiceInput',
      'ServiceKind',
      'CatalogServicePage',
      'CatalogServicePatch',
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
      'ImportColumnInfo',
      'ImportEntityType',
      'ImportPreview',
      'ImportRowError',
      'ImportRun',
      'ImportRunInfo',
      'ImportRunPage',
      'ImportStats',
      'ImportTemplate',
      'SyncRunMode',
      'SyncRunStatus',
      'SyncRunTrigger',
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

  static String? getClassNameFromObjectJson(dynamic data) => _isc.ProtocolDeserialization.readClassName(data);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    final rawDataClassName = _isc.ProtocolDeserialization.readClassName(data);
    final dataClassName = rawDataClassName;
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on _isc.DeserializationClassNameNotFoundException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    if (t == _i6qsbw6s.Product) {
      return _i6qsbw6s.Product.fromJson(data) as T;
    }
    if (t == _is31bq1v.ProductFamily) {
      return _is31bq1v.ProductFamily.fromJson(data) as T;
    }
    if (t == _ifcfic11.ProductFamilyFilter) {
      return _ifcfic11.ProductFamilyFilter.fromJson(data) as T;
    }
    if (t == _iroevrq4.ProductFamilyInput) {
      return _iroevrq4.ProductFamilyInput.fromJson(data) as T;
    }
    if (t == _iaslsjiy.ProductFamilyPage) {
      return _iaslsjiy.ProductFamilyPage.fromJson(data) as T;
    }
    if (t == _iw5gfrqk.ProductFamilyPatch) {
      return _iw5gfrqk.ProductFamilyPatch.fromJson(data) as T;
    }
    if (t == _ix63vfv9.ProductField) {
      return _ix63vfv9.ProductField.fromJson(data) as T;
    }
    if (t == _isilke9y.ProductFilter) {
      return _isilke9y.ProductFilter.fromJson(data) as T;
    }
    if (t == _iuumnsch.ProductInput) {
      return _iuumnsch.ProductInput.fromJson(data) as T;
    }
    if (t == _iobp0yx9.ProductKind) {
      return _iobp0yx9.ProductKind.fromJson(data) as T;
    }
    if (t == _isfcb5kd.ProductPage) {
      return _isfcb5kd.ProductPage.fromJson(data) as T;
    }
    if (t == _ipm6h84l.ProductPatch) {
      return _ipm6h84l.ProductPatch.fromJson(data) as T;
    }
    if (t == _izvigl9t.CatalogService) {
      return _izvigl9t.CatalogService.fromJson(data) as T;
    }
    if (t == _igf61u0d.CatalogServiceField) {
      return _igf61u0d.CatalogServiceField.fromJson(data) as T;
    }
    if (t == _ikr943tt.CatalogServiceFilter) {
      return _ikr943tt.CatalogServiceFilter.fromJson(data) as T;
    }
    if (t == _igake8jw.CatalogServiceInput) {
      return _igake8jw.CatalogServiceInput.fromJson(data) as T;
    }
    if (t == _imdz65g6.ServiceKind) {
      return _imdz65g6.ServiceKind.fromJson(data) as T;
    }
    if (t == _i9t71zax.CatalogServicePage) {
      return _i9t71zax.CatalogServicePage.fromJson(data) as T;
    }
    if (t == _izp6dh5z.CatalogServicePatch) {
      return _izp6dh5z.CatalogServicePatch.fromJson(data) as T;
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
    if (t == _icg69u6o.ImportColumnInfo) {
      return _icg69u6o.ImportColumnInfo.fromJson(data) as T;
    }
    if (t == _iwgsqujn.ImportEntityType) {
      return _iwgsqujn.ImportEntityType.fromJson(data) as T;
    }
    if (t == _iif57p8v.ImportPreview) {
      return _iif57p8v.ImportPreview.fromJson(data) as T;
    }
    if (t == _ir725yxh.ImportRowError) {
      return _ir725yxh.ImportRowError.fromJson(data) as T;
    }
    if (t == _ifdy2oae.ImportRun) {
      return _ifdy2oae.ImportRun.fromJson(data) as T;
    }
    if (t == _i03h52ft.ImportRunInfo) {
      return _i03h52ft.ImportRunInfo.fromJson(data) as T;
    }
    if (t == _ibothc5b.ImportRunPage) {
      return _ibothc5b.ImportRunPage.fromJson(data) as T;
    }
    if (t == _izpdvybk.ImportStats) {
      return _izpdvybk.ImportStats.fromJson(data) as T;
    }
    if (t == _i7o6x8tv.ImportTemplate) {
      return _i7o6x8tv.ImportTemplate.fromJson(data) as T;
    }
    if (t == _itk81loi.SyncRunMode) {
      return _itk81loi.SyncRunMode.fromJson(data) as T;
    }
    if (t == _ilybb2c3.SyncRunStatus) {
      return _ilybb2c3.SyncRunStatus.fromJson(data) as T;
    }
    if (t == _ivfbxo2c.SyncRunTrigger) {
      return _ivfbxo2c.SyncRunTrigger.fromJson(data) as T;
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
    if (t == _isc.getType<_i6qsbw6s.Product?>()) {
      return (data != null ? _i6qsbw6s.Product.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_is31bq1v.ProductFamily?>()) {
      return (data != null ? _is31bq1v.ProductFamily.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifcfic11.ProductFamilyFilter?>()) {
      return (data != null ? _ifcfic11.ProductFamilyFilter.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iroevrq4.ProductFamilyInput?>()) {
      return (data != null ? _iroevrq4.ProductFamilyInput.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iaslsjiy.ProductFamilyPage?>()) {
      return (data != null ? _iaslsjiy.ProductFamilyPage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iw5gfrqk.ProductFamilyPatch?>()) {
      return (data != null ? _iw5gfrqk.ProductFamilyPatch.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ix63vfv9.ProductField?>()) {
      return (data != null ? _ix63vfv9.ProductField.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_isilke9y.ProductFilter?>()) {
      return (data != null ? _isilke9y.ProductFilter.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iuumnsch.ProductInput?>()) {
      return (data != null ? _iuumnsch.ProductInput.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iobp0yx9.ProductKind?>()) {
      return (data != null ? _iobp0yx9.ProductKind.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_isfcb5kd.ProductPage?>()) {
      return (data != null ? _isfcb5kd.ProductPage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ipm6h84l.ProductPatch?>()) {
      return (data != null ? _ipm6h84l.ProductPatch.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izvigl9t.CatalogService?>()) {
      return (data != null ? _izvigl9t.CatalogService.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igf61u0d.CatalogServiceField?>()) {
      return (data != null ? _igf61u0d.CatalogServiceField.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikr943tt.CatalogServiceFilter?>()) {
      return (data != null ? _ikr943tt.CatalogServiceFilter.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igake8jw.CatalogServiceInput?>()) {
      return (data != null ? _igake8jw.CatalogServiceInput.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_imdz65g6.ServiceKind?>()) {
      return (data != null ? _imdz65g6.ServiceKind.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i9t71zax.CatalogServicePage?>()) {
      return (data != null ? _i9t71zax.CatalogServicePage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izp6dh5z.CatalogServicePatch?>()) {
      return (data != null ? _izp6dh5z.CatalogServicePatch.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iqp78482.ContactOrigin?>()) {
      return (data != null ? _iqp78482.ContactOrigin.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iplumur6.ContactRole?>()) {
      return (data != null ? _iplumur6.ContactRole.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izqw5q67.ContactStatus?>()) {
      return (data != null ? _izqw5q67.ContactStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_in2ysqih.Customer?>()) {
      return (data != null ? _in2ysqih.Customer.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iyonel9d.CustomerContact?>()) {
      return (data != null ? _iyonel9d.CustomerContact.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ial9yste.CustomerContactField?>()) {
      return (data != null ? _ial9yste.CustomerContactField.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izv3bdkd.CustomerContactFilter?>()) {
      return (data != null ? _izv3bdkd.CustomerContactFilter.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8ppoe04.CustomerContactInput?>()) {
      return (data != null ? _i8ppoe04.CustomerContactInput.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifqwfvr5.CustomerContactPage?>()) {
      return (data != null ? _ifqwfvr5.CustomerContactPage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8xalfaz.CustomerContactPatch?>()) {
      return (data != null ? _i8xalfaz.CustomerContactPatch.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3eh97aw.CustomerField?>()) {
      return (data != null ? _i3eh97aw.CustomerField.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i4w7b2hn.CustomerFilter?>()) {
      return (data != null ? _i4w7b2hn.CustomerFilter.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i54pcl9h.CustomerInput?>()) {
      return (data != null ? _i54pcl9h.CustomerInput.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i71gi8vd.CustomerKind?>()) {
      return (data != null ? _i71gi8vd.CustomerKind.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iu4jficl.CustomerPage?>()) {
      return (data != null ? _iu4jficl.CustomerPage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ib2ck4oj.CustomerPatch?>()) {
      return (data != null ? _ib2ck4oj.CustomerPatch.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihhtee09.CustomerSite?>()) {
      return (data != null ? _ihhtee09.CustomerSite.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iyqdtrh1.CustomerSiteField?>()) {
      return (data != null ? _iyqdtrh1.CustomerSiteField.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifq4omy3.CustomerSiteFilter?>()) {
      return (data != null ? _ifq4omy3.CustomerSiteFilter.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ii01wxyo.CustomerSiteInput?>()) {
      return (data != null ? _ii01wxyo.CustomerSiteInput.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibmnlo2x.CustomerSitePage?>()) {
      return (data != null ? _ibmnlo2x.CustomerSitePage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i7pxbyck.CustomerSitePatch?>()) {
      return (data != null ? _i7pxbyck.CustomerSitePatch.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ioxz8xmy.DocumentType?>()) {
      return (data != null ? _ioxz8xmy.DocumentType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ipthj0tj.NotificationChannel?>()) {
      return (data != null ? _ipthj0tj.NotificationChannel.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibxir450.PersonType?>()) {
      return (data != null ? _ibxir450.PersonType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5wnkftg.AppUser?>()) {
      return (data != null ? _i5wnkftg.AppUser.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ip4w8f8l.MeInfo?>()) {
      return (data != null ? _ip4w8f8l.MeInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i2vwv4gx.MembershipStatus?>()) {
      return (data != null ? _i2vwv4gx.MembershipStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1iyeyn1.TenantMembership?>()) {
      return (data != null ? _i1iyeyn1.TenantMembership.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iutn78jy.TenantMembershipRole?>()) {
      return (data != null ? _iutn78jy.TenantMembershipRole.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izyppcov.TenantToken?>()) {
      return (data != null ? _izyppcov.TenantToken.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_icg69u6o.ImportColumnInfo?>()) {
      return (data != null ? _icg69u6o.ImportColumnInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iwgsqujn.ImportEntityType?>()) {
      return (data != null ? _iwgsqujn.ImportEntityType.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iif57p8v.ImportPreview?>()) {
      return (data != null ? _iif57p8v.ImportPreview.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ir725yxh.ImportRowError?>()) {
      return (data != null ? _ir725yxh.ImportRowError.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifdy2oae.ImportRun?>()) {
      return (data != null ? _ifdy2oae.ImportRun.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i03h52ft.ImportRunInfo?>()) {
      return (data != null ? _i03h52ft.ImportRunInfo.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ibothc5b.ImportRunPage?>()) {
      return (data != null ? _ibothc5b.ImportRunPage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_izpdvybk.ImportStats?>()) {
      return (data != null ? _izpdvybk.ImportStats.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i7o6x8tv.ImportTemplate?>()) {
      return (data != null ? _i7o6x8tv.ImportTemplate.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_itk81loi.SyncRunMode?>()) {
      return (data != null ? _itk81loi.SyncRunMode.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ilybb2c3.SyncRunStatus?>()) {
      return (data != null ? _ilybb2c3.SyncRunStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivfbxo2c.SyncRunTrigger?>()) {
      return (data != null ? _ivfbxo2c.SyncRunTrigger.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i147o0qx.ApiException?>()) {
      return (data != null ? _i147o0qx.ApiException.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i0p9y4c3.ErrorCategory?>()) {
      return (data != null ? _i0p9y4c3.ErrorCategory.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3z3bgdl.FieldError?>()) {
      return (data != null ? _i3z3bgdl.FieldError.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i43haw30.RecordSource?>()) {
      return (data != null ? _i43haw30.RecordSource.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i18yzlaa.PageRequest?>()) {
      return (data != null ? _i18yzlaa.PageRequest.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i2jhpzjh.Tenant?>()) {
      return (data != null ? _i2jhpzjh.Tenant.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i2bjgc9x.TenantStatus?>()) {
      return (data != null ? _i2bjgc9x.TenantStatus.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i9uizrsf.TenantSummary?>()) {
      return (data != null ? _i9uizrsf.TenantSummary.fromJson(data) : null) as T;
    }
    if (t == List<_is31bq1v.ProductFamily>) {
      return (data as List).map((e) => deserialize<_is31bq1v.ProductFamily>(e)).toList() as T;
    }
    if (t == List<_i6qsbw6s.Product>) {
      return (data as List).map((e) => deserialize<_i6qsbw6s.Product>(e)).toList() as T;
    }
    if (t == List<_ix63vfv9.ProductField>) {
      return (data as List).map((e) => deserialize<_ix63vfv9.ProductField>(e)).toList() as T;
    }
    if (t == _isc.getType<List<_ix63vfv9.ProductField>?>()) {
      return (data != null ? (data as List).map((e) => deserialize<_ix63vfv9.ProductField>(e)).toList() : null) as T;
    }
    if (t == List<_izvigl9t.CatalogService>) {
      return (data as List).map((e) => deserialize<_izvigl9t.CatalogService>(e)).toList() as T;
    }
    if (t == List<_igf61u0d.CatalogServiceField>) {
      return (data as List).map((e) => deserialize<_igf61u0d.CatalogServiceField>(e)).toList() as T;
    }
    if (t == _isc.getType<List<_igf61u0d.CatalogServiceField>?>()) {
      return (data != null ? (data as List).map((e) => deserialize<_igf61u0d.CatalogServiceField>(e)).toList() : null)
          as T;
    }
    if (t == List<_iyonel9d.CustomerContact>) {
      return (data as List).map((e) => deserialize<_iyonel9d.CustomerContact>(e)).toList() as T;
    }
    if (t == List<_ial9yste.CustomerContactField>) {
      return (data as List).map((e) => deserialize<_ial9yste.CustomerContactField>(e)).toList() as T;
    }
    if (t == _isc.getType<List<_ial9yste.CustomerContactField>?>()) {
      return (data != null ? (data as List).map((e) => deserialize<_ial9yste.CustomerContactField>(e)).toList() : null)
          as T;
    }
    if (t == List<_in2ysqih.Customer>) {
      return (data as List).map((e) => deserialize<_in2ysqih.Customer>(e)).toList() as T;
    }
    if (t == List<_i3eh97aw.CustomerField>) {
      return (data as List).map((e) => deserialize<_i3eh97aw.CustomerField>(e)).toList() as T;
    }
    if (t == _isc.getType<List<_i3eh97aw.CustomerField>?>()) {
      return (data != null ? (data as List).map((e) => deserialize<_i3eh97aw.CustomerField>(e)).toList() : null) as T;
    }
    if (t == List<_ihhtee09.CustomerSite>) {
      return (data as List).map((e) => deserialize<_ihhtee09.CustomerSite>(e)).toList() as T;
    }
    if (t == List<_iyqdtrh1.CustomerSiteField>) {
      return (data as List).map((e) => deserialize<_iyqdtrh1.CustomerSiteField>(e)).toList() as T;
    }
    if (t == _isc.getType<List<_iyqdtrh1.CustomerSiteField>?>()) {
      return (data != null ? (data as List).map((e) => deserialize<_iyqdtrh1.CustomerSiteField>(e)).toList() : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_ir725yxh.ImportRowError>) {
      return (data as List).map((e) => deserialize<_ir725yxh.ImportRowError>(e)).toList() as T;
    }
    if (t == List<_i03h52ft.ImportRunInfo>) {
      return (data as List).map((e) => deserialize<_i03h52ft.ImportRunInfo>(e)).toList() as T;
    }
    if (t == List<_icg69u6o.ImportColumnInfo>) {
      return (data as List).map((e) => deserialize<_icg69u6o.ImportColumnInfo>(e)).toList() as T;
    }
    if (t == List<_i3z3bgdl.FieldError>) {
      return (data as List).map((e) => deserialize<_i3z3bgdl.FieldError>(e)).toList() as T;
    }
    if (t == _isc.getType<List<_i3z3bgdl.FieldError>?>()) {
      return (data != null ? (data as List).map((e) => deserialize<_i3z3bgdl.FieldError>(e)).toList() : null) as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v))) as T;
    }
    if (t == _isc.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)))
              : null)
          as T;
    }
    if (t == List<_i11upz4e.TenantSummary>) {
      return (data as List).map((e) => deserialize<_i11upz4e.TenantSummary>(e)).toList() as T;
    }
    if (t == List<_iielyi2l.ImportEntityType>) {
      return (data as List).map((e) => deserialize<_iielyi2l.ImportEntityType>(e)).toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i6qsbw6s.Product => 'Product',
      _is31bq1v.ProductFamily => 'ProductFamily',
      _ifcfic11.ProductFamilyFilter => 'ProductFamilyFilter',
      _iroevrq4.ProductFamilyInput => 'ProductFamilyInput',
      _iaslsjiy.ProductFamilyPage => 'ProductFamilyPage',
      _iw5gfrqk.ProductFamilyPatch => 'ProductFamilyPatch',
      _ix63vfv9.ProductField => 'ProductField',
      _isilke9y.ProductFilter => 'ProductFilter',
      _iuumnsch.ProductInput => 'ProductInput',
      _iobp0yx9.ProductKind => 'ProductKind',
      _isfcb5kd.ProductPage => 'ProductPage',
      _ipm6h84l.ProductPatch => 'ProductPatch',
      _izvigl9t.CatalogService => 'CatalogService',
      _igf61u0d.CatalogServiceField => 'CatalogServiceField',
      _ikr943tt.CatalogServiceFilter => 'CatalogServiceFilter',
      _igake8jw.CatalogServiceInput => 'CatalogServiceInput',
      _imdz65g6.ServiceKind => 'ServiceKind',
      _i9t71zax.CatalogServicePage => 'CatalogServicePage',
      _izp6dh5z.CatalogServicePatch => 'CatalogServicePatch',
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
      _icg69u6o.ImportColumnInfo => 'ImportColumnInfo',
      _iwgsqujn.ImportEntityType => 'ImportEntityType',
      _iif57p8v.ImportPreview => 'ImportPreview',
      _ir725yxh.ImportRowError => 'ImportRowError',
      _ifdy2oae.ImportRun => 'ImportRun',
      _i03h52ft.ImportRunInfo => 'ImportRunInfo',
      _ibothc5b.ImportRunPage => 'ImportRunPage',
      _izpdvybk.ImportStats => 'ImportStats',
      _i7o6x8tv.ImportTemplate => 'ImportTemplate',
      _itk81loi.SyncRunMode => 'SyncRunMode',
      _ilybb2c3.SyncRunStatus => 'SyncRunStatus',
      _ivfbxo2c.SyncRunTrigger => 'SyncRunTrigger',
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
      case _i6qsbw6s.Product():
        return 'Product';
      case _is31bq1v.ProductFamily():
        return 'ProductFamily';
      case _ifcfic11.ProductFamilyFilter():
        return 'ProductFamilyFilter';
      case _iroevrq4.ProductFamilyInput():
        return 'ProductFamilyInput';
      case _iaslsjiy.ProductFamilyPage():
        return 'ProductFamilyPage';
      case _iw5gfrqk.ProductFamilyPatch():
        return 'ProductFamilyPatch';
      case _ix63vfv9.ProductField():
        return 'ProductField';
      case _isilke9y.ProductFilter():
        return 'ProductFilter';
      case _iuumnsch.ProductInput():
        return 'ProductInput';
      case _iobp0yx9.ProductKind():
        return 'ProductKind';
      case _isfcb5kd.ProductPage():
        return 'ProductPage';
      case _ipm6h84l.ProductPatch():
        return 'ProductPatch';
      case _izvigl9t.CatalogService():
        return 'CatalogService';
      case _igf61u0d.CatalogServiceField():
        return 'CatalogServiceField';
      case _ikr943tt.CatalogServiceFilter():
        return 'CatalogServiceFilter';
      case _igake8jw.CatalogServiceInput():
        return 'CatalogServiceInput';
      case _imdz65g6.ServiceKind():
        return 'ServiceKind';
      case _i9t71zax.CatalogServicePage():
        return 'CatalogServicePage';
      case _izp6dh5z.CatalogServicePatch():
        return 'CatalogServicePatch';
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
      case _icg69u6o.ImportColumnInfo():
        return 'ImportColumnInfo';
      case _iwgsqujn.ImportEntityType():
        return 'ImportEntityType';
      case _iif57p8v.ImportPreview():
        return 'ImportPreview';
      case _ir725yxh.ImportRowError():
        return 'ImportRowError';
      case _ifdy2oae.ImportRun():
        return 'ImportRun';
      case _i03h52ft.ImportRunInfo():
        return 'ImportRunInfo';
      case _ibothc5b.ImportRunPage():
        return 'ImportRunPage';
      case _izpdvybk.ImportStats():
        return 'ImportStats';
      case _i7o6x8tv.ImportTemplate():
        return 'ImportTemplate';
      case _itk81loi.SyncRunMode():
        return 'SyncRunMode';
      case _ilybb2c3.SyncRunStatus():
        return 'SyncRunStatus';
      case _ivfbxo2c.SyncRunTrigger():
        return 'SyncRunTrigger';
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
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'Product') {
      return deserialize<_i6qsbw6s.Product>(data['data']);
    }
    if (dataClassName == 'ProductFamily') {
      return deserialize<_is31bq1v.ProductFamily>(data['data']);
    }
    if (dataClassName == 'ProductFamilyFilter') {
      return deserialize<_ifcfic11.ProductFamilyFilter>(data['data']);
    }
    if (dataClassName == 'ProductFamilyInput') {
      return deserialize<_iroevrq4.ProductFamilyInput>(data['data']);
    }
    if (dataClassName == 'ProductFamilyPage') {
      return deserialize<_iaslsjiy.ProductFamilyPage>(data['data']);
    }
    if (dataClassName == 'ProductFamilyPatch') {
      return deserialize<_iw5gfrqk.ProductFamilyPatch>(data['data']);
    }
    if (dataClassName == 'ProductField') {
      return deserialize<_ix63vfv9.ProductField>(data['data']);
    }
    if (dataClassName == 'ProductFilter') {
      return deserialize<_isilke9y.ProductFilter>(data['data']);
    }
    if (dataClassName == 'ProductInput') {
      return deserialize<_iuumnsch.ProductInput>(data['data']);
    }
    if (dataClassName == 'ProductKind') {
      return deserialize<_iobp0yx9.ProductKind>(data['data']);
    }
    if (dataClassName == 'ProductPage') {
      return deserialize<_isfcb5kd.ProductPage>(data['data']);
    }
    if (dataClassName == 'ProductPatch') {
      return deserialize<_ipm6h84l.ProductPatch>(data['data']);
    }
    if (dataClassName == 'CatalogService') {
      return deserialize<_izvigl9t.CatalogService>(data['data']);
    }
    if (dataClassName == 'CatalogServiceField') {
      return deserialize<_igf61u0d.CatalogServiceField>(data['data']);
    }
    if (dataClassName == 'CatalogServiceFilter') {
      return deserialize<_ikr943tt.CatalogServiceFilter>(data['data']);
    }
    if (dataClassName == 'CatalogServiceInput') {
      return deserialize<_igake8jw.CatalogServiceInput>(data['data']);
    }
    if (dataClassName == 'ServiceKind') {
      return deserialize<_imdz65g6.ServiceKind>(data['data']);
    }
    if (dataClassName == 'CatalogServicePage') {
      return deserialize<_i9t71zax.CatalogServicePage>(data['data']);
    }
    if (dataClassName == 'CatalogServicePatch') {
      return deserialize<_izp6dh5z.CatalogServicePatch>(data['data']);
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
    if (dataClassName == 'ImportColumnInfo') {
      return deserialize<_icg69u6o.ImportColumnInfo>(data['data']);
    }
    if (dataClassName == 'ImportEntityType') {
      return deserialize<_iwgsqujn.ImportEntityType>(data['data']);
    }
    if (dataClassName == 'ImportPreview') {
      return deserialize<_iif57p8v.ImportPreview>(data['data']);
    }
    if (dataClassName == 'ImportRowError') {
      return deserialize<_ir725yxh.ImportRowError>(data['data']);
    }
    if (dataClassName == 'ImportRun') {
      return deserialize<_ifdy2oae.ImportRun>(data['data']);
    }
    if (dataClassName == 'ImportRunInfo') {
      return deserialize<_i03h52ft.ImportRunInfo>(data['data']);
    }
    if (dataClassName == 'ImportRunPage') {
      return deserialize<_ibothc5b.ImportRunPage>(data['data']);
    }
    if (dataClassName == 'ImportStats') {
      return deserialize<_izpdvybk.ImportStats>(data['data']);
    }
    if (dataClassName == 'ImportTemplate') {
      return deserialize<_i7o6x8tv.ImportTemplate>(data['data']);
    }
    if (dataClassName == 'SyncRunMode') {
      return deserialize<_itk81loi.SyncRunMode>(data['data']);
    }
    if (dataClassName == 'SyncRunStatus') {
      return deserialize<_ilybb2c3.SyncRunStatus>(data['data']);
    }
    if (dataClassName == 'SyncRunTrigger') {
      return deserialize<_ivfbxo2c.SyncRunTrigger>(data['data']);
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
    return super.deserializeByClassName(data);
  }

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
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
