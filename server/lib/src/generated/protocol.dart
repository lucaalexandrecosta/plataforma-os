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
import 'package:plataforma_os_server/src/generated/assets/models/asset_assignment.dart' as _iqmm5djm;
import 'package:plataforma_os_server/src/generated/assets/models/qr_tag.dart' as _idzaz83i;
import 'package:plataforma_os_server/src/generated/assets/models/qr_tag_batch.dart' as _i07n19u6;
import 'package:plataforma_os_server/src/generated/catalog/models/product_summary.dart' as _ico54ik3;
import 'package:plataforma_os_server/src/generated/customers/models/customer_site.dart' as _ing115qe;
import 'package:plataforma_os_server/src/generated/identity_access/models/assignable_role.dart' as _iur1xixc;
import 'package:plataforma_os_server/src/generated/identity_access/models/tenant_user.dart' as _iqhozu6i;
import 'package:plataforma_os_server/src/generated/patrimony/models/depreciation_closing.dart' as _ip56mlnh;
import 'package:plataforma_os_server/src/generated/scheduling/models/technician.dart' as _ixvhwnkq;
import 'package:plataforma_os_server/src/generated/scheduling/models/visit.dart' as _iezjjcq0;
import 'package:plataforma_os_server/src/generated/sync/models/sync_mutation_result.dart' as _ilt9w9x8;
import 'package:plataforma_os_server/src/generated/tenancy/models/branch.dart' as _i7vupwwc;
import 'package:plataforma_os_server/src/generated/tenancy/models/cost_center.dart' as _islkyssd;
import 'package:plataforma_os_server/src/generated/tenancy/models/tenant_summary.dart' as _inphvrgt;
import 'package:plataforma_os_server/src/generated/work_orders/models/work_order_type.dart' as _ith5np2m;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart' as _iacs;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart' as _iais;
import 'assets/models/asset.dart' as _ib3mptol;
import 'assets/models/asset_assignment.dart' as _i9j61cby;
import 'assets/models/asset_input.dart' as _i6icgsi8;
import 'assets/models/asset_install_input.dart' as _iqytokqf;
import 'assets/models/asset_page.dart' as _is3mug9m;
import 'assets/models/asset_withdraw_input.dart' as _i7jdajp7;
import 'assets/models/qr_tag.dart' as _i760nubs;
import 'assets/models/qr_tag_batch.dart' as _ikikcay0;
import 'catalog/models/product_input.dart' as _iuumnsch;
import 'catalog/models/product_summary.dart' as _i4geouqi;
import 'customers/models/customer.dart' as _in2ysqih;
import 'customers/models/customer_input.dart' as _i54pcl9h;
import 'customers/models/customer_page.dart' as _iu4jficl;
import 'customers/models/customer_site.dart' as _ihhtee09;
import 'customers/models/customer_site_input.dart' as _ii01wxyo;
import 'identity_access/models/app_user.dart' as _i5wnkftg;
import 'identity_access/models/assignable_role.dart' as _ilvk5aly;
import 'identity_access/models/me_info.dart' as _ip4w8f8l;
import 'identity_access/models/membership_status.dart' as _i2vwv4gx;
import 'identity_access/models/tenant_membership.dart' as _i1iyeyn1;
import 'identity_access/models/tenant_membership_role.dart' as _iutn78jy;
import 'identity_access/models/tenant_token.dart' as _izyppcov;
import 'identity_access/models/tenant_user.dart' as _i6x1gv4d;
import 'patrimony/models/asset_depreciation.dart' as _iiflf4a7;
import 'patrimony/models/depreciation_closing.dart' as _ione1mk7;
import 'patrimony/models/depreciation_group_total.dart' as _iajvmd8d;
import 'patrimony/models/depreciation_line.dart' as _irfplgys;
import 'patrimony/models/depreciation_position.dart' as _ikhzxai3;
import 'patrimony/models/depreciation_position_item.dart' as _ikti05ap;
import 'patrimony/models/depreciation_profile.dart' as _i4zu82sf;
import 'patrimony/models/depreciation_profile_input.dart' as _icy94czf;
import 'platform/errors/models/api_exception.dart' as _i147o0qx;
import 'platform/errors/models/error_category.dart' as _i0p9y4c3;
import 'platform/errors/models/field_error.dart' as _i3z3bgdl;
import 'scheduling/models/technician.dart' as _isgl9bus;
import 'scheduling/models/technician_input.dart' as _inntwrv0;
import 'scheduling/models/visit.dart' as _i3v1yqab;
import 'scheduling/models/visit_check_in.dart' as _iz6dmpx4;
import 'scheduling/models/visit_finish.dart' as _iemqddjv;
import 'scheduling/models/visit_input.dart' as _iqwjilz9;
import 'sync/models/device_registration.dart' as _iqd8b9b2;
import 'sync/models/sync_mutation.dart' as _i8kxdcd0;
import 'sync/models/sync_mutation_result.dart' as _ihyj8e8a;
import 'sync/models/sync_pull_result.dart' as _iweo9dks;
import 'sync/models/sync_push_request.dart' as _iwotyfoq;
import 'sync/models/visit_mutation_payload.dart' as _ijam3dib;
import 'tenancy/models/branch.dart' as _iou7eiap;
import 'tenancy/models/branch_input.dart' as _iptw6tnd;
import 'tenancy/models/cost_center.dart' as _iehhesp7;
import 'tenancy/models/cost_center_input.dart' as _iofwzavf;
import 'tenancy/models/tenant.dart' as _i2jhpzjh;
import 'tenancy/models/tenant_status.dart' as _i2bjgc9x;
import 'tenancy/models/tenant_summary.dart' as _i9uizrsf;
import 'work_orders/models/work_order.dart' as _i5zaa4b8;
import 'work_orders/models/work_order_changes.dart' as _ijhvbn0n;
import 'work_orders/models/work_order_detail.dart' as _idkm2e3p;
import 'work_orders/models/work_order_input.dart' as _i5u8gc5f;
import 'work_orders/models/work_order_page.dart' as _ixqx063h;
import 'work_orders/models/work_order_status_change.dart' as _i00stvlt;
import 'work_orders/models/work_order_type.dart' as _iduxn53h;
import 'work_orders/models/work_order_type_input.dart' as _iolj0kda;
export 'assets/models/asset.dart';
export 'assets/models/asset_assignment.dart';
export 'assets/models/asset_input.dart';
export 'assets/models/asset_install_input.dart';
export 'assets/models/asset_page.dart';
export 'assets/models/asset_withdraw_input.dart';
export 'assets/models/qr_tag.dart';
export 'assets/models/qr_tag_batch.dart';
export 'catalog/models/product_input.dart';
export 'catalog/models/product_summary.dart';
export 'customers/models/customer.dart';
export 'customers/models/customer_input.dart';
export 'customers/models/customer_page.dart';
export 'customers/models/customer_site.dart';
export 'customers/models/customer_site_input.dart';
export 'identity_access/models/app_user.dart';
export 'identity_access/models/assignable_role.dart';
export 'identity_access/models/me_info.dart';
export 'identity_access/models/membership_status.dart';
export 'identity_access/models/tenant_membership.dart';
export 'identity_access/models/tenant_membership_role.dart';
export 'identity_access/models/tenant_token.dart';
export 'identity_access/models/tenant_user.dart';
export 'patrimony/models/asset_depreciation.dart';
export 'patrimony/models/depreciation_closing.dart';
export 'patrimony/models/depreciation_group_total.dart';
export 'patrimony/models/depreciation_line.dart';
export 'patrimony/models/depreciation_position.dart';
export 'patrimony/models/depreciation_position_item.dart';
export 'patrimony/models/depreciation_profile.dart';
export 'patrimony/models/depreciation_profile_input.dart';
export 'platform/errors/models/api_exception.dart';
export 'platform/errors/models/error_category.dart';
export 'platform/errors/models/field_error.dart';
export 'scheduling/models/technician.dart';
export 'scheduling/models/technician_input.dart';
export 'scheduling/models/visit.dart';
export 'scheduling/models/visit_check_in.dart';
export 'scheduling/models/visit_finish.dart';
export 'scheduling/models/visit_input.dart';
export 'sync/models/device_registration.dart';
export 'sync/models/sync_mutation.dart';
export 'sync/models/sync_mutation_result.dart';
export 'sync/models/sync_pull_result.dart';
export 'sync/models/sync_push_request.dart';
export 'sync/models/visit_mutation_payload.dart';
export 'tenancy/models/branch.dart';
export 'tenancy/models/branch_input.dart';
export 'tenancy/models/cost_center.dart';
export 'tenancy/models/cost_center_input.dart';
export 'tenancy/models/tenant.dart';
export 'tenancy/models/tenant_status.dart';
export 'tenancy/models/tenant_summary.dart';
export 'work_orders/models/work_order.dart';
export 'work_orders/models/work_order_changes.dart';
export 'work_orders/models/work_order_detail.dart';
export 'work_orders/models/work_order_input.dart';
export 'work_orders/models/work_order_page.dart';
export 'work_orders/models/work_order_status_change.dart';
export 'work_orders/models/work_order_type.dart';
export 'work_orders/models/work_order_type_input.dart';

class Protocol extends _is.DatabaseSerializationManager implements _is.DatabaseProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  @override
  _is.ProtocolDeserialization get deserializationMetadata => _is.ProtocolDeserialization.cached(
    this,
    types: const [
      _is.getType<_ib3mptol.Asset>,
      _is.getType<_i9j61cby.AssetAssignment>,
      _is.getType<_i6icgsi8.AssetInput>,
      _is.getType<_iqytokqf.AssetInstallInput>,
      _is.getType<_is3mug9m.AssetPage>,
      _is.getType<_i7jdajp7.AssetWithdrawInput>,
      _is.getType<_i760nubs.QrTag>,
      _is.getType<_ikikcay0.QrTagBatch>,
      _is.getType<_iuumnsch.ProductInput>,
      _is.getType<_i4geouqi.ProductSummary>,
      _is.getType<_in2ysqih.Customer>,
      _is.getType<_i54pcl9h.CustomerInput>,
      _is.getType<_iu4jficl.CustomerPage>,
      _is.getType<_ihhtee09.CustomerSite>,
      _is.getType<_ii01wxyo.CustomerSiteInput>,
      _is.getType<_i5wnkftg.AppUser>,
      _is.getType<_ilvk5aly.AssignableRole>,
      _is.getType<_ip4w8f8l.MeInfo>,
      _is.getType<_i2vwv4gx.MembershipStatus>,
      _is.getType<_i1iyeyn1.TenantMembership>,
      _is.getType<_iutn78jy.TenantMembershipRole>,
      _is.getType<_izyppcov.TenantToken>,
      _is.getType<_i6x1gv4d.TenantUser>,
      _is.getType<_iiflf4a7.AssetDepreciation>,
      _is.getType<_ione1mk7.DepreciationClosing>,
      _is.getType<_iajvmd8d.DepreciationGroupTotal>,
      _is.getType<_irfplgys.DepreciationLine>,
      _is.getType<_ikhzxai3.DepreciationPosition>,
      _is.getType<_ikti05ap.DepreciationPositionItem>,
      _is.getType<_i4zu82sf.DepreciationProfile>,
      _is.getType<_icy94czf.DepreciationProfileInput>,
      _is.getType<_i147o0qx.ApiException>,
      _is.getType<_i0p9y4c3.ErrorCategory>,
      _is.getType<_i3z3bgdl.FieldError>,
      _is.getType<_isgl9bus.Technician>,
      _is.getType<_inntwrv0.TechnicianInput>,
      _is.getType<_i3v1yqab.Visit>,
      _is.getType<_iz6dmpx4.VisitCheckIn>,
      _is.getType<_iemqddjv.VisitFinish>,
      _is.getType<_iqwjilz9.VisitInput>,
      _is.getType<_iqd8b9b2.DeviceRegistration>,
      _is.getType<_i8kxdcd0.SyncMutation>,
      _is.getType<_ihyj8e8a.SyncMutationResult>,
      _is.getType<_iweo9dks.SyncPullResult>,
      _is.getType<_iwotyfoq.SyncPushRequest>,
      _is.getType<_ijam3dib.VisitMutationPayload>,
      _is.getType<_iou7eiap.Branch>,
      _is.getType<_iptw6tnd.BranchInput>,
      _is.getType<_iehhesp7.CostCenter>,
      _is.getType<_iofwzavf.CostCenterInput>,
      _is.getType<_i2jhpzjh.Tenant>,
      _is.getType<_i2bjgc9x.TenantStatus>,
      _is.getType<_i9uizrsf.TenantSummary>,
      _is.getType<_i5zaa4b8.WorkOrder>,
      _is.getType<_ijhvbn0n.WorkOrderChanges>,
      _is.getType<_idkm2e3p.WorkOrderDetail>,
      _is.getType<_i5u8gc5f.WorkOrderInput>,
      _is.getType<_ixqx063h.WorkOrderPage>,
      _is.getType<_i00stvlt.WorkOrderStatusChange>,
      _is.getType<_iduxn53h.WorkOrderType>,
      _is.getType<_iolj0kda.WorkOrderTypeInput>,
      _is.getType<_ib3mptol.Asset?>,
      _is.getType<_i9j61cby.AssetAssignment?>,
      _is.getType<_i6icgsi8.AssetInput?>,
      _is.getType<_iqytokqf.AssetInstallInput?>,
      _is.getType<_is3mug9m.AssetPage?>,
      _is.getType<_i7jdajp7.AssetWithdrawInput?>,
      _is.getType<_i760nubs.QrTag?>,
      _is.getType<_ikikcay0.QrTagBatch?>,
      _is.getType<_iuumnsch.ProductInput?>,
      _is.getType<_i4geouqi.ProductSummary?>,
      _is.getType<_in2ysqih.Customer?>,
      _is.getType<_i54pcl9h.CustomerInput?>,
      _is.getType<_iu4jficl.CustomerPage?>,
      _is.getType<_ihhtee09.CustomerSite?>,
      _is.getType<_ii01wxyo.CustomerSiteInput?>,
      _is.getType<_i5wnkftg.AppUser?>,
      _is.getType<_ilvk5aly.AssignableRole?>,
      _is.getType<_ip4w8f8l.MeInfo?>,
      _is.getType<_i2vwv4gx.MembershipStatus?>,
      _is.getType<_i1iyeyn1.TenantMembership?>,
      _is.getType<_iutn78jy.TenantMembershipRole?>,
      _is.getType<_izyppcov.TenantToken?>,
      _is.getType<_i6x1gv4d.TenantUser?>,
      _is.getType<_iiflf4a7.AssetDepreciation?>,
      _is.getType<_ione1mk7.DepreciationClosing?>,
      _is.getType<_iajvmd8d.DepreciationGroupTotal?>,
      _is.getType<_irfplgys.DepreciationLine?>,
      _is.getType<_ikhzxai3.DepreciationPosition?>,
      _is.getType<_ikti05ap.DepreciationPositionItem?>,
      _is.getType<_i4zu82sf.DepreciationProfile?>,
      _is.getType<_icy94czf.DepreciationProfileInput?>,
      _is.getType<_i147o0qx.ApiException?>,
      _is.getType<_i0p9y4c3.ErrorCategory?>,
      _is.getType<_i3z3bgdl.FieldError?>,
      _is.getType<_isgl9bus.Technician?>,
      _is.getType<_inntwrv0.TechnicianInput?>,
      _is.getType<_i3v1yqab.Visit?>,
      _is.getType<_iz6dmpx4.VisitCheckIn?>,
      _is.getType<_iemqddjv.VisitFinish?>,
      _is.getType<_iqwjilz9.VisitInput?>,
      _is.getType<_iqd8b9b2.DeviceRegistration?>,
      _is.getType<_i8kxdcd0.SyncMutation?>,
      _is.getType<_ihyj8e8a.SyncMutationResult?>,
      _is.getType<_iweo9dks.SyncPullResult?>,
      _is.getType<_iwotyfoq.SyncPushRequest?>,
      _is.getType<_ijam3dib.VisitMutationPayload?>,
      _is.getType<_iou7eiap.Branch?>,
      _is.getType<_iptw6tnd.BranchInput?>,
      _is.getType<_iehhesp7.CostCenter?>,
      _is.getType<_iofwzavf.CostCenterInput?>,
      _is.getType<_i2jhpzjh.Tenant?>,
      _is.getType<_i2bjgc9x.TenantStatus?>,
      _is.getType<_i9uizrsf.TenantSummary?>,
      _is.getType<_i5zaa4b8.WorkOrder?>,
      _is.getType<_ijhvbn0n.WorkOrderChanges?>,
      _is.getType<_idkm2e3p.WorkOrderDetail?>,
      _is.getType<_i5u8gc5f.WorkOrderInput?>,
      _is.getType<_ixqx063h.WorkOrderPage?>,
      _is.getType<_i00stvlt.WorkOrderStatusChange?>,
      _is.getType<_iduxn53h.WorkOrderType?>,
      _is.getType<_iolj0kda.WorkOrderTypeInput?>,
      _is.getType<List<_ib3mptol.Asset>>,
      _is.getType<List<_in2ysqih.Customer>>,
      _is.getType<List<String>>,
      _is.getType<List<_irfplgys.DepreciationLine>>,
      _is.getType<List<_ikti05ap.DepreciationPositionItem>>,
      _is.getType<List<_iajvmd8d.DepreciationGroupTotal>>,
      _is.getType<List<_i3z3bgdl.FieldError>>,
      _is.getType<List<_i3z3bgdl.FieldError>?>,
      _is.getType<Map<String, String>>,
      _is.getType<Map<String, String>?>,
      _is.getType<List<_i3v1yqab.Visit>>,
      _is.getType<List<_i5zaa4b8.WorkOrder>>,
      _is.getType<List<_i8kxdcd0.SyncMutation>>,
      _is.getType<List<_i00stvlt.WorkOrderStatusChange>>,
      _is.getType<List<_iqmm5djm.AssetAssignment>>,
      _is.getType<List<_i07n19u6.QrTagBatch>>,
      _is.getType<List<_idzaz83i.QrTag>>,
      _is.getType<List<_ico54ik3.ProductSummary>>,
      _is.getType<List<_ing115qe.CustomerSite>>,
      _is.getType<List<_inphvrgt.TenantSummary>>,
      _is.getType<List<_iur1xixc.AssignableRole>>,
      _is.getType<List<_iqhozu6i.TenantUser>>,
      _is.getType<List<String>>,
      _is.getType<List<_ip56mlnh.DepreciationClosing>>,
      _is.getType<List<_ixvhwnkq.Technician>>,
      _is.getType<List<_iezjjcq0.Visit>>,
      _is.getType<List<_ilt9w9x8.SyncMutationResult>>,
      _is.getType<List<_i7vupwwc.Branch>>,
      _is.getType<List<_islkyssd.CostCenter>>,
      _is.getType<List<String>?>,
      _is.getType<List<_ith5np2m.WorkOrderType>>,
    ],
    modules: const [
      _iais.Protocol.new,
      _iacs.Protocol.new,
      _isp.Protocol.new,
    ],
    classNames: const [
      'Asset',
      'AssetAssignment',
      'AssetInput',
      'AssetInstallInput',
      'AssetPage',
      'AssetWithdrawInput',
      'QrTag',
      'QrTagBatch',
      'ProductInput',
      'ProductSummary',
      'Customer',
      'CustomerInput',
      'CustomerPage',
      'CustomerSite',
      'CustomerSiteInput',
      'AppUser',
      'AssignableRole',
      'MeInfo',
      'MembershipStatus',
      'TenantMembership',
      'TenantMembershipRole',
      'TenantToken',
      'TenantUser',
      'AssetDepreciation',
      'DepreciationClosing',
      'DepreciationGroupTotal',
      'DepreciationLine',
      'DepreciationPosition',
      'DepreciationPositionItem',
      'DepreciationProfile',
      'DepreciationProfileInput',
      'ApiException',
      'ErrorCategory',
      'FieldError',
      'Technician',
      'TechnicianInput',
      'Visit',
      'VisitCheckIn',
      'VisitFinish',
      'VisitInput',
      'DeviceRegistration',
      'SyncMutation',
      'SyncMutationResult',
      'SyncPullResult',
      'SyncPushRequest',
      'VisitMutationPayload',
      'Branch',
      'BranchInput',
      'CostCenter',
      'CostCenterInput',
      'Tenant',
      'TenantStatus',
      'TenantSummary',
      'WorkOrder',
      'WorkOrderChanges',
      'WorkOrderDetail',
      'WorkOrderInput',
      'WorkOrderPage',
      'WorkOrderStatusChange',
      'WorkOrderType',
      'WorkOrderTypeInput',
    ],
  );

  static List<_isp.TableDefinition> get targetTableDefinitions => [
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
    ..._iais.Protocol.targetTableDefinitions,
    ..._iacs.Protocol.targetTableDefinitions,
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

    if (t == _ib3mptol.Asset) {
      return _ib3mptol.Asset.fromJson(data) as T;
    }
    if (t == _i9j61cby.AssetAssignment) {
      return _i9j61cby.AssetAssignment.fromJson(data) as T;
    }
    if (t == _i6icgsi8.AssetInput) {
      return _i6icgsi8.AssetInput.fromJson(data) as T;
    }
    if (t == _iqytokqf.AssetInstallInput) {
      return _iqytokqf.AssetInstallInput.fromJson(data) as T;
    }
    if (t == _is3mug9m.AssetPage) {
      return _is3mug9m.AssetPage.fromJson(data) as T;
    }
    if (t == _i7jdajp7.AssetWithdrawInput) {
      return _i7jdajp7.AssetWithdrawInput.fromJson(data) as T;
    }
    if (t == _i760nubs.QrTag) {
      return _i760nubs.QrTag.fromJson(data) as T;
    }
    if (t == _ikikcay0.QrTagBatch) {
      return _ikikcay0.QrTagBatch.fromJson(data) as T;
    }
    if (t == _iuumnsch.ProductInput) {
      return _iuumnsch.ProductInput.fromJson(data) as T;
    }
    if (t == _i4geouqi.ProductSummary) {
      return _i4geouqi.ProductSummary.fromJson(data) as T;
    }
    if (t == _in2ysqih.Customer) {
      return _in2ysqih.Customer.fromJson(data) as T;
    }
    if (t == _i54pcl9h.CustomerInput) {
      return _i54pcl9h.CustomerInput.fromJson(data) as T;
    }
    if (t == _iu4jficl.CustomerPage) {
      return _iu4jficl.CustomerPage.fromJson(data) as T;
    }
    if (t == _ihhtee09.CustomerSite) {
      return _ihhtee09.CustomerSite.fromJson(data) as T;
    }
    if (t == _ii01wxyo.CustomerSiteInput) {
      return _ii01wxyo.CustomerSiteInput.fromJson(data) as T;
    }
    if (t == _i5wnkftg.AppUser) {
      return _i5wnkftg.AppUser.fromJson(data) as T;
    }
    if (t == _ilvk5aly.AssignableRole) {
      return _ilvk5aly.AssignableRole.fromJson(data) as T;
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
    if (t == _i6x1gv4d.TenantUser) {
      return _i6x1gv4d.TenantUser.fromJson(data) as T;
    }
    if (t == _iiflf4a7.AssetDepreciation) {
      return _iiflf4a7.AssetDepreciation.fromJson(data) as T;
    }
    if (t == _ione1mk7.DepreciationClosing) {
      return _ione1mk7.DepreciationClosing.fromJson(data) as T;
    }
    if (t == _iajvmd8d.DepreciationGroupTotal) {
      return _iajvmd8d.DepreciationGroupTotal.fromJson(data) as T;
    }
    if (t == _irfplgys.DepreciationLine) {
      return _irfplgys.DepreciationLine.fromJson(data) as T;
    }
    if (t == _ikhzxai3.DepreciationPosition) {
      return _ikhzxai3.DepreciationPosition.fromJson(data) as T;
    }
    if (t == _ikti05ap.DepreciationPositionItem) {
      return _ikti05ap.DepreciationPositionItem.fromJson(data) as T;
    }
    if (t == _i4zu82sf.DepreciationProfile) {
      return _i4zu82sf.DepreciationProfile.fromJson(data) as T;
    }
    if (t == _icy94czf.DepreciationProfileInput) {
      return _icy94czf.DepreciationProfileInput.fromJson(data) as T;
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
    if (t == _isgl9bus.Technician) {
      return _isgl9bus.Technician.fromJson(data) as T;
    }
    if (t == _inntwrv0.TechnicianInput) {
      return _inntwrv0.TechnicianInput.fromJson(data) as T;
    }
    if (t == _i3v1yqab.Visit) {
      return _i3v1yqab.Visit.fromJson(data) as T;
    }
    if (t == _iz6dmpx4.VisitCheckIn) {
      return _iz6dmpx4.VisitCheckIn.fromJson(data) as T;
    }
    if (t == _iemqddjv.VisitFinish) {
      return _iemqddjv.VisitFinish.fromJson(data) as T;
    }
    if (t == _iqwjilz9.VisitInput) {
      return _iqwjilz9.VisitInput.fromJson(data) as T;
    }
    if (t == _iqd8b9b2.DeviceRegistration) {
      return _iqd8b9b2.DeviceRegistration.fromJson(data) as T;
    }
    if (t == _i8kxdcd0.SyncMutation) {
      return _i8kxdcd0.SyncMutation.fromJson(data) as T;
    }
    if (t == _ihyj8e8a.SyncMutationResult) {
      return _ihyj8e8a.SyncMutationResult.fromJson(data) as T;
    }
    if (t == _iweo9dks.SyncPullResult) {
      return _iweo9dks.SyncPullResult.fromJson(data) as T;
    }
    if (t == _iwotyfoq.SyncPushRequest) {
      return _iwotyfoq.SyncPushRequest.fromJson(data) as T;
    }
    if (t == _ijam3dib.VisitMutationPayload) {
      return _ijam3dib.VisitMutationPayload.fromJson(data) as T;
    }
    if (t == _iou7eiap.Branch) {
      return _iou7eiap.Branch.fromJson(data) as T;
    }
    if (t == _iptw6tnd.BranchInput) {
      return _iptw6tnd.BranchInput.fromJson(data) as T;
    }
    if (t == _iehhesp7.CostCenter) {
      return _iehhesp7.CostCenter.fromJson(data) as T;
    }
    if (t == _iofwzavf.CostCenterInput) {
      return _iofwzavf.CostCenterInput.fromJson(data) as T;
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
    if (t == _i5zaa4b8.WorkOrder) {
      return _i5zaa4b8.WorkOrder.fromJson(data) as T;
    }
    if (t == _ijhvbn0n.WorkOrderChanges) {
      return _ijhvbn0n.WorkOrderChanges.fromJson(data) as T;
    }
    if (t == _idkm2e3p.WorkOrderDetail) {
      return _idkm2e3p.WorkOrderDetail.fromJson(data) as T;
    }
    if (t == _i5u8gc5f.WorkOrderInput) {
      return _i5u8gc5f.WorkOrderInput.fromJson(data) as T;
    }
    if (t == _ixqx063h.WorkOrderPage) {
      return _ixqx063h.WorkOrderPage.fromJson(data) as T;
    }
    if (t == _i00stvlt.WorkOrderStatusChange) {
      return _i00stvlt.WorkOrderStatusChange.fromJson(data) as T;
    }
    if (t == _iduxn53h.WorkOrderType) {
      return _iduxn53h.WorkOrderType.fromJson(data) as T;
    }
    if (t == _iolj0kda.WorkOrderTypeInput) {
      return _iolj0kda.WorkOrderTypeInput.fromJson(data) as T;
    }
    if (t == _is.getType<_ib3mptol.Asset?>()) {
      return (data != null ? _ib3mptol.Asset.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i9j61cby.AssetAssignment?>()) {
      return (data != null ? _i9j61cby.AssetAssignment.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6icgsi8.AssetInput?>()) {
      return (data != null ? _i6icgsi8.AssetInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iqytokqf.AssetInstallInput?>()) {
      return (data != null ? _iqytokqf.AssetInstallInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_is3mug9m.AssetPage?>()) {
      return (data != null ? _is3mug9m.AssetPage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i7jdajp7.AssetWithdrawInput?>()) {
      return (data != null ? _i7jdajp7.AssetWithdrawInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i760nubs.QrTag?>()) {
      return (data != null ? _i760nubs.QrTag.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikikcay0.QrTagBatch?>()) {
      return (data != null ? _ikikcay0.QrTagBatch.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iuumnsch.ProductInput?>()) {
      return (data != null ? _iuumnsch.ProductInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4geouqi.ProductSummary?>()) {
      return (data != null ? _i4geouqi.ProductSummary.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_in2ysqih.Customer?>()) {
      return (data != null ? _in2ysqih.Customer.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i54pcl9h.CustomerInput?>()) {
      return (data != null ? _i54pcl9h.CustomerInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iu4jficl.CustomerPage?>()) {
      return (data != null ? _iu4jficl.CustomerPage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihhtee09.CustomerSite?>()) {
      return (data != null ? _ihhtee09.CustomerSite.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ii01wxyo.CustomerSiteInput?>()) {
      return (data != null ? _ii01wxyo.CustomerSiteInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5wnkftg.AppUser?>()) {
      return (data != null ? _i5wnkftg.AppUser.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ilvk5aly.AssignableRole?>()) {
      return (data != null ? _ilvk5aly.AssignableRole.fromJson(data) : null) as T;
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
    if (t == _is.getType<_i6x1gv4d.TenantUser?>()) {
      return (data != null ? _i6x1gv4d.TenantUser.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iiflf4a7.AssetDepreciation?>()) {
      return (data != null ? _iiflf4a7.AssetDepreciation.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ione1mk7.DepreciationClosing?>()) {
      return (data != null ? _ione1mk7.DepreciationClosing.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iajvmd8d.DepreciationGroupTotal?>()) {
      return (data != null ? _iajvmd8d.DepreciationGroupTotal.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_irfplgys.DepreciationLine?>()) {
      return (data != null ? _irfplgys.DepreciationLine.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikhzxai3.DepreciationPosition?>()) {
      return (data != null ? _ikhzxai3.DepreciationPosition.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikti05ap.DepreciationPositionItem?>()) {
      return (data != null ? _ikti05ap.DepreciationPositionItem.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i4zu82sf.DepreciationProfile?>()) {
      return (data != null ? _i4zu82sf.DepreciationProfile.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_icy94czf.DepreciationProfileInput?>()) {
      return (data != null ? _icy94czf.DepreciationProfileInput.fromJson(data) : null) as T;
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
    if (t == _is.getType<_isgl9bus.Technician?>()) {
      return (data != null ? _isgl9bus.Technician.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_inntwrv0.TechnicianInput?>()) {
      return (data != null ? _inntwrv0.TechnicianInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3v1yqab.Visit?>()) {
      return (data != null ? _i3v1yqab.Visit.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iz6dmpx4.VisitCheckIn?>()) {
      return (data != null ? _iz6dmpx4.VisitCheckIn.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iemqddjv.VisitFinish?>()) {
      return (data != null ? _iemqddjv.VisitFinish.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iqwjilz9.VisitInput?>()) {
      return (data != null ? _iqwjilz9.VisitInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iqd8b9b2.DeviceRegistration?>()) {
      return (data != null ? _iqd8b9b2.DeviceRegistration.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8kxdcd0.SyncMutation?>()) {
      return (data != null ? _i8kxdcd0.SyncMutation.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihyj8e8a.SyncMutationResult?>()) {
      return (data != null ? _ihyj8e8a.SyncMutationResult.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iweo9dks.SyncPullResult?>()) {
      return (data != null ? _iweo9dks.SyncPullResult.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iwotyfoq.SyncPushRequest?>()) {
      return (data != null ? _iwotyfoq.SyncPushRequest.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijam3dib.VisitMutationPayload?>()) {
      return (data != null ? _ijam3dib.VisitMutationPayload.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iou7eiap.Branch?>()) {
      return (data != null ? _iou7eiap.Branch.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iptw6tnd.BranchInput?>()) {
      return (data != null ? _iptw6tnd.BranchInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iehhesp7.CostCenter?>()) {
      return (data != null ? _iehhesp7.CostCenter.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iofwzavf.CostCenterInput?>()) {
      return (data != null ? _iofwzavf.CostCenterInput.fromJson(data) : null) as T;
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
    if (t == _is.getType<_i5zaa4b8.WorkOrder?>()) {
      return (data != null ? _i5zaa4b8.WorkOrder.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijhvbn0n.WorkOrderChanges?>()) {
      return (data != null ? _ijhvbn0n.WorkOrderChanges.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idkm2e3p.WorkOrderDetail?>()) {
      return (data != null ? _idkm2e3p.WorkOrderDetail.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5u8gc5f.WorkOrderInput?>()) {
      return (data != null ? _i5u8gc5f.WorkOrderInput.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ixqx063h.WorkOrderPage?>()) {
      return (data != null ? _ixqx063h.WorkOrderPage.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i00stvlt.WorkOrderStatusChange?>()) {
      return (data != null ? _i00stvlt.WorkOrderStatusChange.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iduxn53h.WorkOrderType?>()) {
      return (data != null ? _iduxn53h.WorkOrderType.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iolj0kda.WorkOrderTypeInput?>()) {
      return (data != null ? _iolj0kda.WorkOrderTypeInput.fromJson(data) : null) as T;
    }
    if (t == List<_ib3mptol.Asset>) {
      return (data as List).map((e) => deserialize<_ib3mptol.Asset>(e)).toList() as T;
    }
    if (t == List<_in2ysqih.Customer>) {
      return (data as List).map((e) => deserialize<_in2ysqih.Customer>(e)).toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_irfplgys.DepreciationLine>) {
      return (data as List).map((e) => deserialize<_irfplgys.DepreciationLine>(e)).toList() as T;
    }
    if (t == List<_ikti05ap.DepreciationPositionItem>) {
      return (data as List).map((e) => deserialize<_ikti05ap.DepreciationPositionItem>(e)).toList() as T;
    }
    if (t == List<_iajvmd8d.DepreciationGroupTotal>) {
      return (data as List).map((e) => deserialize<_iajvmd8d.DepreciationGroupTotal>(e)).toList() as T;
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
    if (t == List<_i3v1yqab.Visit>) {
      return (data as List).map((e) => deserialize<_i3v1yqab.Visit>(e)).toList() as T;
    }
    if (t == List<_i5zaa4b8.WorkOrder>) {
      return (data as List).map((e) => deserialize<_i5zaa4b8.WorkOrder>(e)).toList() as T;
    }
    if (t == List<_i8kxdcd0.SyncMutation>) {
      return (data as List).map((e) => deserialize<_i8kxdcd0.SyncMutation>(e)).toList() as T;
    }
    if (t == List<_i00stvlt.WorkOrderStatusChange>) {
      return (data as List).map((e) => deserialize<_i00stvlt.WorkOrderStatusChange>(e)).toList() as T;
    }
    if (t == List<_iqmm5djm.AssetAssignment>) {
      return (data as List).map((e) => deserialize<_iqmm5djm.AssetAssignment>(e)).toList() as T;
    }
    if (t == List<_i07n19u6.QrTagBatch>) {
      return (data as List).map((e) => deserialize<_i07n19u6.QrTagBatch>(e)).toList() as T;
    }
    if (t == List<_idzaz83i.QrTag>) {
      return (data as List).map((e) => deserialize<_idzaz83i.QrTag>(e)).toList() as T;
    }
    if (t == List<_ico54ik3.ProductSummary>) {
      return (data as List).map((e) => deserialize<_ico54ik3.ProductSummary>(e)).toList() as T;
    }
    if (t == List<_ing115qe.CustomerSite>) {
      return (data as List).map((e) => deserialize<_ing115qe.CustomerSite>(e)).toList() as T;
    }
    if (t == List<_inphvrgt.TenantSummary>) {
      return (data as List).map((e) => deserialize<_inphvrgt.TenantSummary>(e)).toList() as T;
    }
    if (t == List<_iur1xixc.AssignableRole>) {
      return (data as List).map((e) => deserialize<_iur1xixc.AssignableRole>(e)).toList() as T;
    }
    if (t == List<_iqhozu6i.TenantUser>) {
      return (data as List).map((e) => deserialize<_iqhozu6i.TenantUser>(e)).toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_ip56mlnh.DepreciationClosing>) {
      return (data as List).map((e) => deserialize<_ip56mlnh.DepreciationClosing>(e)).toList() as T;
    }
    if (t == List<_ixvhwnkq.Technician>) {
      return (data as List).map((e) => deserialize<_ixvhwnkq.Technician>(e)).toList() as T;
    }
    if (t == List<_iezjjcq0.Visit>) {
      return (data as List).map((e) => deserialize<_iezjjcq0.Visit>(e)).toList() as T;
    }
    if (t == List<_ilt9w9x8.SyncMutationResult>) {
      return (data as List).map((e) => deserialize<_ilt9w9x8.SyncMutationResult>(e)).toList() as T;
    }
    if (t == List<_i7vupwwc.Branch>) {
      return (data as List).map((e) => deserialize<_i7vupwwc.Branch>(e)).toList() as T;
    }
    if (t == List<_islkyssd.CostCenter>) {
      return (data as List).map((e) => deserialize<_islkyssd.CostCenter>(e)).toList() as T;
    }
    if (t == _is.getType<List<String>?>()) {
      return (data != null ? (data as List).map((e) => deserialize<String>(e)).toList() : null) as T;
    }
    if (t == List<_ith5np2m.WorkOrderType>) {
      return (data as List).map((e) => deserialize<_ith5np2m.WorkOrderType>(e)).toList() as T;
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
      _ib3mptol.Asset => 'Asset',
      _i9j61cby.AssetAssignment => 'AssetAssignment',
      _i6icgsi8.AssetInput => 'AssetInput',
      _iqytokqf.AssetInstallInput => 'AssetInstallInput',
      _is3mug9m.AssetPage => 'AssetPage',
      _i7jdajp7.AssetWithdrawInput => 'AssetWithdrawInput',
      _i760nubs.QrTag => 'QrTag',
      _ikikcay0.QrTagBatch => 'QrTagBatch',
      _iuumnsch.ProductInput => 'ProductInput',
      _i4geouqi.ProductSummary => 'ProductSummary',
      _in2ysqih.Customer => 'Customer',
      _i54pcl9h.CustomerInput => 'CustomerInput',
      _iu4jficl.CustomerPage => 'CustomerPage',
      _ihhtee09.CustomerSite => 'CustomerSite',
      _ii01wxyo.CustomerSiteInput => 'CustomerSiteInput',
      _i5wnkftg.AppUser => 'AppUser',
      _ilvk5aly.AssignableRole => 'AssignableRole',
      _ip4w8f8l.MeInfo => 'MeInfo',
      _i2vwv4gx.MembershipStatus => 'MembershipStatus',
      _i1iyeyn1.TenantMembership => 'TenantMembership',
      _iutn78jy.TenantMembershipRole => 'TenantMembershipRole',
      _izyppcov.TenantToken => 'TenantToken',
      _i6x1gv4d.TenantUser => 'TenantUser',
      _iiflf4a7.AssetDepreciation => 'AssetDepreciation',
      _ione1mk7.DepreciationClosing => 'DepreciationClosing',
      _iajvmd8d.DepreciationGroupTotal => 'DepreciationGroupTotal',
      _irfplgys.DepreciationLine => 'DepreciationLine',
      _ikhzxai3.DepreciationPosition => 'DepreciationPosition',
      _ikti05ap.DepreciationPositionItem => 'DepreciationPositionItem',
      _i4zu82sf.DepreciationProfile => 'DepreciationProfile',
      _icy94czf.DepreciationProfileInput => 'DepreciationProfileInput',
      _i147o0qx.ApiException => 'ApiException',
      _i0p9y4c3.ErrorCategory => 'ErrorCategory',
      _i3z3bgdl.FieldError => 'FieldError',
      _isgl9bus.Technician => 'Technician',
      _inntwrv0.TechnicianInput => 'TechnicianInput',
      _i3v1yqab.Visit => 'Visit',
      _iz6dmpx4.VisitCheckIn => 'VisitCheckIn',
      _iemqddjv.VisitFinish => 'VisitFinish',
      _iqwjilz9.VisitInput => 'VisitInput',
      _iqd8b9b2.DeviceRegistration => 'DeviceRegistration',
      _i8kxdcd0.SyncMutation => 'SyncMutation',
      _ihyj8e8a.SyncMutationResult => 'SyncMutationResult',
      _iweo9dks.SyncPullResult => 'SyncPullResult',
      _iwotyfoq.SyncPushRequest => 'SyncPushRequest',
      _ijam3dib.VisitMutationPayload => 'VisitMutationPayload',
      _iou7eiap.Branch => 'Branch',
      _iptw6tnd.BranchInput => 'BranchInput',
      _iehhesp7.CostCenter => 'CostCenter',
      _iofwzavf.CostCenterInput => 'CostCenterInput',
      _i2jhpzjh.Tenant => 'Tenant',
      _i2bjgc9x.TenantStatus => 'TenantStatus',
      _i9uizrsf.TenantSummary => 'TenantSummary',
      _i5zaa4b8.WorkOrder => 'WorkOrder',
      _ijhvbn0n.WorkOrderChanges => 'WorkOrderChanges',
      _idkm2e3p.WorkOrderDetail => 'WorkOrderDetail',
      _i5u8gc5f.WorkOrderInput => 'WorkOrderInput',
      _ixqx063h.WorkOrderPage => 'WorkOrderPage',
      _i00stvlt.WorkOrderStatusChange => 'WorkOrderStatusChange',
      _iduxn53h.WorkOrderType => 'WorkOrderType',
      _iolj0kda.WorkOrderTypeInput => 'WorkOrderTypeInput',
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
      case _ib3mptol.Asset():
        return 'Asset';
      case _i9j61cby.AssetAssignment():
        return 'AssetAssignment';
      case _i6icgsi8.AssetInput():
        return 'AssetInput';
      case _iqytokqf.AssetInstallInput():
        return 'AssetInstallInput';
      case _is3mug9m.AssetPage():
        return 'AssetPage';
      case _i7jdajp7.AssetWithdrawInput():
        return 'AssetWithdrawInput';
      case _i760nubs.QrTag():
        return 'QrTag';
      case _ikikcay0.QrTagBatch():
        return 'QrTagBatch';
      case _iuumnsch.ProductInput():
        return 'ProductInput';
      case _i4geouqi.ProductSummary():
        return 'ProductSummary';
      case _in2ysqih.Customer():
        return 'Customer';
      case _i54pcl9h.CustomerInput():
        return 'CustomerInput';
      case _iu4jficl.CustomerPage():
        return 'CustomerPage';
      case _ihhtee09.CustomerSite():
        return 'CustomerSite';
      case _ii01wxyo.CustomerSiteInput():
        return 'CustomerSiteInput';
      case _i5wnkftg.AppUser():
        return 'AppUser';
      case _ilvk5aly.AssignableRole():
        return 'AssignableRole';
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
      case _i6x1gv4d.TenantUser():
        return 'TenantUser';
      case _iiflf4a7.AssetDepreciation():
        return 'AssetDepreciation';
      case _ione1mk7.DepreciationClosing():
        return 'DepreciationClosing';
      case _iajvmd8d.DepreciationGroupTotal():
        return 'DepreciationGroupTotal';
      case _irfplgys.DepreciationLine():
        return 'DepreciationLine';
      case _ikhzxai3.DepreciationPosition():
        return 'DepreciationPosition';
      case _ikti05ap.DepreciationPositionItem():
        return 'DepreciationPositionItem';
      case _i4zu82sf.DepreciationProfile():
        return 'DepreciationProfile';
      case _icy94czf.DepreciationProfileInput():
        return 'DepreciationProfileInput';
      case _i147o0qx.ApiException():
        return 'ApiException';
      case _i0p9y4c3.ErrorCategory():
        return 'ErrorCategory';
      case _i3z3bgdl.FieldError():
        return 'FieldError';
      case _isgl9bus.Technician():
        return 'Technician';
      case _inntwrv0.TechnicianInput():
        return 'TechnicianInput';
      case _i3v1yqab.Visit():
        return 'Visit';
      case _iz6dmpx4.VisitCheckIn():
        return 'VisitCheckIn';
      case _iemqddjv.VisitFinish():
        return 'VisitFinish';
      case _iqwjilz9.VisitInput():
        return 'VisitInput';
      case _iqd8b9b2.DeviceRegistration():
        return 'DeviceRegistration';
      case _i8kxdcd0.SyncMutation():
        return 'SyncMutation';
      case _ihyj8e8a.SyncMutationResult():
        return 'SyncMutationResult';
      case _iweo9dks.SyncPullResult():
        return 'SyncPullResult';
      case _iwotyfoq.SyncPushRequest():
        return 'SyncPushRequest';
      case _ijam3dib.VisitMutationPayload():
        return 'VisitMutationPayload';
      case _iou7eiap.Branch():
        return 'Branch';
      case _iptw6tnd.BranchInput():
        return 'BranchInput';
      case _iehhesp7.CostCenter():
        return 'CostCenter';
      case _iofwzavf.CostCenterInput():
        return 'CostCenterInput';
      case _i2jhpzjh.Tenant():
        return 'Tenant';
      case _i2bjgc9x.TenantStatus():
        return 'TenantStatus';
      case _i9uizrsf.TenantSummary():
        return 'TenantSummary';
      case _i5zaa4b8.WorkOrder():
        return 'WorkOrder';
      case _ijhvbn0n.WorkOrderChanges():
        return 'WorkOrderChanges';
      case _idkm2e3p.WorkOrderDetail():
        return 'WorkOrderDetail';
      case _i5u8gc5f.WorkOrderInput():
        return 'WorkOrderInput';
      case _ixqx063h.WorkOrderPage():
        return 'WorkOrderPage';
      case _i00stvlt.WorkOrderStatusChange():
        return 'WorkOrderStatusChange';
      case _iduxn53h.WorkOrderType():
        return 'WorkOrderType';
      case _iolj0kda.WorkOrderTypeInput():
        return 'WorkOrderTypeInput';
    }
    className = _iais.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod_auth_idp.$className';
    }
    className = _iacs.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod_auth_core.$className';
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
    if (dataClassName == 'Asset') {
      return deserialize<_ib3mptol.Asset>(data['data']);
    }
    if (dataClassName == 'AssetAssignment') {
      return deserialize<_i9j61cby.AssetAssignment>(data['data']);
    }
    if (dataClassName == 'AssetInput') {
      return deserialize<_i6icgsi8.AssetInput>(data['data']);
    }
    if (dataClassName == 'AssetInstallInput') {
      return deserialize<_iqytokqf.AssetInstallInput>(data['data']);
    }
    if (dataClassName == 'AssetPage') {
      return deserialize<_is3mug9m.AssetPage>(data['data']);
    }
    if (dataClassName == 'AssetWithdrawInput') {
      return deserialize<_i7jdajp7.AssetWithdrawInput>(data['data']);
    }
    if (dataClassName == 'QrTag') {
      return deserialize<_i760nubs.QrTag>(data['data']);
    }
    if (dataClassName == 'QrTagBatch') {
      return deserialize<_ikikcay0.QrTagBatch>(data['data']);
    }
    if (dataClassName == 'ProductInput') {
      return deserialize<_iuumnsch.ProductInput>(data['data']);
    }
    if (dataClassName == 'ProductSummary') {
      return deserialize<_i4geouqi.ProductSummary>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_in2ysqih.Customer>(data['data']);
    }
    if (dataClassName == 'CustomerInput') {
      return deserialize<_i54pcl9h.CustomerInput>(data['data']);
    }
    if (dataClassName == 'CustomerPage') {
      return deserialize<_iu4jficl.CustomerPage>(data['data']);
    }
    if (dataClassName == 'CustomerSite') {
      return deserialize<_ihhtee09.CustomerSite>(data['data']);
    }
    if (dataClassName == 'CustomerSiteInput') {
      return deserialize<_ii01wxyo.CustomerSiteInput>(data['data']);
    }
    if (dataClassName == 'AppUser') {
      return deserialize<_i5wnkftg.AppUser>(data['data']);
    }
    if (dataClassName == 'AssignableRole') {
      return deserialize<_ilvk5aly.AssignableRole>(data['data']);
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
    if (dataClassName == 'TenantUser') {
      return deserialize<_i6x1gv4d.TenantUser>(data['data']);
    }
    if (dataClassName == 'AssetDepreciation') {
      return deserialize<_iiflf4a7.AssetDepreciation>(data['data']);
    }
    if (dataClassName == 'DepreciationClosing') {
      return deserialize<_ione1mk7.DepreciationClosing>(data['data']);
    }
    if (dataClassName == 'DepreciationGroupTotal') {
      return deserialize<_iajvmd8d.DepreciationGroupTotal>(data['data']);
    }
    if (dataClassName == 'DepreciationLine') {
      return deserialize<_irfplgys.DepreciationLine>(data['data']);
    }
    if (dataClassName == 'DepreciationPosition') {
      return deserialize<_ikhzxai3.DepreciationPosition>(data['data']);
    }
    if (dataClassName == 'DepreciationPositionItem') {
      return deserialize<_ikti05ap.DepreciationPositionItem>(data['data']);
    }
    if (dataClassName == 'DepreciationProfile') {
      return deserialize<_i4zu82sf.DepreciationProfile>(data['data']);
    }
    if (dataClassName == 'DepreciationProfileInput') {
      return deserialize<_icy94czf.DepreciationProfileInput>(data['data']);
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
    if (dataClassName == 'Technician') {
      return deserialize<_isgl9bus.Technician>(data['data']);
    }
    if (dataClassName == 'TechnicianInput') {
      return deserialize<_inntwrv0.TechnicianInput>(data['data']);
    }
    if (dataClassName == 'Visit') {
      return deserialize<_i3v1yqab.Visit>(data['data']);
    }
    if (dataClassName == 'VisitCheckIn') {
      return deserialize<_iz6dmpx4.VisitCheckIn>(data['data']);
    }
    if (dataClassName == 'VisitFinish') {
      return deserialize<_iemqddjv.VisitFinish>(data['data']);
    }
    if (dataClassName == 'VisitInput') {
      return deserialize<_iqwjilz9.VisitInput>(data['data']);
    }
    if (dataClassName == 'DeviceRegistration') {
      return deserialize<_iqd8b9b2.DeviceRegistration>(data['data']);
    }
    if (dataClassName == 'SyncMutation') {
      return deserialize<_i8kxdcd0.SyncMutation>(data['data']);
    }
    if (dataClassName == 'SyncMutationResult') {
      return deserialize<_ihyj8e8a.SyncMutationResult>(data['data']);
    }
    if (dataClassName == 'SyncPullResult') {
      return deserialize<_iweo9dks.SyncPullResult>(data['data']);
    }
    if (dataClassName == 'SyncPushRequest') {
      return deserialize<_iwotyfoq.SyncPushRequest>(data['data']);
    }
    if (dataClassName == 'VisitMutationPayload') {
      return deserialize<_ijam3dib.VisitMutationPayload>(data['data']);
    }
    if (dataClassName == 'Branch') {
      return deserialize<_iou7eiap.Branch>(data['data']);
    }
    if (dataClassName == 'BranchInput') {
      return deserialize<_iptw6tnd.BranchInput>(data['data']);
    }
    if (dataClassName == 'CostCenter') {
      return deserialize<_iehhesp7.CostCenter>(data['data']);
    }
    if (dataClassName == 'CostCenterInput') {
      return deserialize<_iofwzavf.CostCenterInput>(data['data']);
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
    if (dataClassName == 'WorkOrder') {
      return deserialize<_i5zaa4b8.WorkOrder>(data['data']);
    }
    if (dataClassName == 'WorkOrderChanges') {
      return deserialize<_ijhvbn0n.WorkOrderChanges>(data['data']);
    }
    if (dataClassName == 'WorkOrderDetail') {
      return deserialize<_idkm2e3p.WorkOrderDetail>(data['data']);
    }
    if (dataClassName == 'WorkOrderInput') {
      return deserialize<_i5u8gc5f.WorkOrderInput>(data['data']);
    }
    if (dataClassName == 'WorkOrderPage') {
      return deserialize<_ixqx063h.WorkOrderPage>(data['data']);
    }
    if (dataClassName == 'WorkOrderStatusChange') {
      return deserialize<_i00stvlt.WorkOrderStatusChange>(data['data']);
    }
    if (dataClassName == 'WorkOrderType') {
      return deserialize<_iduxn53h.WorkOrderType>(data['data']);
    }
    if (dataClassName == 'WorkOrderTypeInput') {
      return deserialize<_iolj0kda.WorkOrderTypeInput>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      return _iais.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(19),
      });
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      return _iacs.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(20),
      });
    }
    if (dataClassName.startsWith('serverpod.')) {
      return _isp.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(10),
      });
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iais.Protocol().registerHostProtocol('plataforma_os', this);
    _iacs.Protocol().registerHostProtocol('plataforma_os', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iais.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
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
      return _iais.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacs.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
