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
import 'package:plataforma_os_client/src/protocol/catalog/models/product_summary.dart' as _ihgw7zuo;
import 'package:plataforma_os_client/src/protocol/identity_access/models/assignable_role.dart' as _i2g1699a;
import 'package:plataforma_os_client/src/protocol/identity_access/models/tenant_user.dart' as _i8ihd43z;
import 'package:plataforma_os_client/src/protocol/tenancy/models/branch.dart' as _ied3wtyg;
import 'package:plataforma_os_client/src/protocol/tenancy/models/cost_center.dart' as _itoq0gfy;
import 'package:plataforma_os_client/src/protocol/tenancy/models/tenant_summary.dart' as _i11upz4e;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart' as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart' as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'assets/models/asset.dart' as _ib3mptol;
import 'assets/models/asset_input.dart' as _i6icgsi8;
import 'assets/models/asset_page.dart' as _is3mug9m;
import 'catalog/models/product_input.dart' as _iuumnsch;
import 'catalog/models/product_summary.dart' as _i4geouqi;
import 'identity_access/models/app_user.dart' as _i5wnkftg;
import 'identity_access/models/assignable_role.dart' as _ilvk5aly;
import 'identity_access/models/me_info.dart' as _ip4w8f8l;
import 'identity_access/models/membership_status.dart' as _i2vwv4gx;
import 'identity_access/models/tenant_membership.dart' as _i1iyeyn1;
import 'identity_access/models/tenant_membership_role.dart' as _iutn78jy;
import 'identity_access/models/tenant_token.dart' as _izyppcov;
import 'identity_access/models/tenant_user.dart' as _i6x1gv4d;
import 'platform/errors/models/api_exception.dart' as _i147o0qx;
import 'platform/errors/models/error_category.dart' as _i0p9y4c3;
import 'platform/errors/models/field_error.dart' as _i3z3bgdl;
import 'tenancy/models/branch.dart' as _iou7eiap;
import 'tenancy/models/branch_input.dart' as _iptw6tnd;
import 'tenancy/models/cost_center.dart' as _iehhesp7;
import 'tenancy/models/cost_center_input.dart' as _iofwzavf;
import 'tenancy/models/tenant.dart' as _i2jhpzjh;
import 'tenancy/models/tenant_status.dart' as _i2bjgc9x;
import 'tenancy/models/tenant_summary.dart' as _i9uizrsf;
export 'assets/models/asset.dart';
export 'assets/models/asset_input.dart';
export 'assets/models/asset_page.dart';
export 'catalog/models/product_input.dart';
export 'catalog/models/product_summary.dart';
export 'identity_access/models/app_user.dart';
export 'identity_access/models/assignable_role.dart';
export 'identity_access/models/me_info.dart';
export 'identity_access/models/membership_status.dart';
export 'identity_access/models/tenant_membership.dart';
export 'identity_access/models/tenant_membership_role.dart';
export 'identity_access/models/tenant_token.dart';
export 'identity_access/models/tenant_user.dart';
export 'platform/errors/models/api_exception.dart';
export 'platform/errors/models/error_category.dart';
export 'platform/errors/models/field_error.dart';
export 'tenancy/models/branch.dart';
export 'tenancy/models/branch_input.dart';
export 'tenancy/models/cost_center.dart';
export 'tenancy/models/cost_center_input.dart';
export 'tenancy/models/tenant.dart';
export 'tenancy/models/tenant_status.dart';
export 'tenancy/models/tenant_summary.dart';
export 'client.dart';

class Protocol extends _isc.SerializationManager implements _isc.ProtocolDeserializationProvider {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  @override
  _isc.ProtocolDeserialization get deserializationMetadata => _isc.ProtocolDeserialization.cached(
    this,
    types: const [
      _isc.getType<_ib3mptol.Asset>,
      _isc.getType<_i6icgsi8.AssetInput>,
      _isc.getType<_is3mug9m.AssetPage>,
      _isc.getType<_iuumnsch.ProductInput>,
      _isc.getType<_i4geouqi.ProductSummary>,
      _isc.getType<_i5wnkftg.AppUser>,
      _isc.getType<_ilvk5aly.AssignableRole>,
      _isc.getType<_ip4w8f8l.MeInfo>,
      _isc.getType<_i2vwv4gx.MembershipStatus>,
      _isc.getType<_i1iyeyn1.TenantMembership>,
      _isc.getType<_iutn78jy.TenantMembershipRole>,
      _isc.getType<_izyppcov.TenantToken>,
      _isc.getType<_i6x1gv4d.TenantUser>,
      _isc.getType<_i147o0qx.ApiException>,
      _isc.getType<_i0p9y4c3.ErrorCategory>,
      _isc.getType<_i3z3bgdl.FieldError>,
      _isc.getType<_iou7eiap.Branch>,
      _isc.getType<_iptw6tnd.BranchInput>,
      _isc.getType<_iehhesp7.CostCenter>,
      _isc.getType<_iofwzavf.CostCenterInput>,
      _isc.getType<_i2jhpzjh.Tenant>,
      _isc.getType<_i2bjgc9x.TenantStatus>,
      _isc.getType<_i9uizrsf.TenantSummary>,
      _isc.getType<_ib3mptol.Asset?>,
      _isc.getType<_i6icgsi8.AssetInput?>,
      _isc.getType<_is3mug9m.AssetPage?>,
      _isc.getType<_iuumnsch.ProductInput?>,
      _isc.getType<_i4geouqi.ProductSummary?>,
      _isc.getType<_i5wnkftg.AppUser?>,
      _isc.getType<_ilvk5aly.AssignableRole?>,
      _isc.getType<_ip4w8f8l.MeInfo?>,
      _isc.getType<_i2vwv4gx.MembershipStatus?>,
      _isc.getType<_i1iyeyn1.TenantMembership?>,
      _isc.getType<_iutn78jy.TenantMembershipRole?>,
      _isc.getType<_izyppcov.TenantToken?>,
      _isc.getType<_i6x1gv4d.TenantUser?>,
      _isc.getType<_i147o0qx.ApiException?>,
      _isc.getType<_i0p9y4c3.ErrorCategory?>,
      _isc.getType<_i3z3bgdl.FieldError?>,
      _isc.getType<_iou7eiap.Branch?>,
      _isc.getType<_iptw6tnd.BranchInput?>,
      _isc.getType<_iehhesp7.CostCenter?>,
      _isc.getType<_iofwzavf.CostCenterInput?>,
      _isc.getType<_i2jhpzjh.Tenant?>,
      _isc.getType<_i2bjgc9x.TenantStatus?>,
      _isc.getType<_i9uizrsf.TenantSummary?>,
      _isc.getType<List<_ib3mptol.Asset>>,
      _isc.getType<List<String>>,
      _isc.getType<List<_i3z3bgdl.FieldError>>,
      _isc.getType<List<_i3z3bgdl.FieldError>?>,
      _isc.getType<Map<String, String>>,
      _isc.getType<Map<String, String>?>,
      _isc.getType<List<_ihgw7zuo.ProductSummary>>,
      _isc.getType<List<_i11upz4e.TenantSummary>>,
      _isc.getType<List<_i2g1699a.AssignableRole>>,
      _isc.getType<List<_i8ihd43z.TenantUser>>,
      _isc.getType<List<String>>,
      _isc.getType<List<_ied3wtyg.Branch>>,
      _isc.getType<List<_itoq0gfy.CostCenter>>,
    ],
    modules: const [
      _iaic.Protocol.new,
      _iacc.Protocol.new,
    ],
    classNames: const [
      'Asset',
      'AssetInput',
      'AssetPage',
      'ProductInput',
      'ProductSummary',
      'AppUser',
      'AssignableRole',
      'MeInfo',
      'MembershipStatus',
      'TenantMembership',
      'TenantMembershipRole',
      'TenantToken',
      'TenantUser',
      'ApiException',
      'ErrorCategory',
      'FieldError',
      'Branch',
      'BranchInput',
      'CostCenter',
      'CostCenterInput',
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

    if (t == _ib3mptol.Asset) {
      return _ib3mptol.Asset.fromJson(data) as T;
    }
    if (t == _i6icgsi8.AssetInput) {
      return _i6icgsi8.AssetInput.fromJson(data) as T;
    }
    if (t == _is3mug9m.AssetPage) {
      return _is3mug9m.AssetPage.fromJson(data) as T;
    }
    if (t == _iuumnsch.ProductInput) {
      return _iuumnsch.ProductInput.fromJson(data) as T;
    }
    if (t == _i4geouqi.ProductSummary) {
      return _i4geouqi.ProductSummary.fromJson(data) as T;
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
    if (t == _i147o0qx.ApiException) {
      return _i147o0qx.ApiException.fromJson(data) as T;
    }
    if (t == _i0p9y4c3.ErrorCategory) {
      return _i0p9y4c3.ErrorCategory.fromJson(data) as T;
    }
    if (t == _i3z3bgdl.FieldError) {
      return _i3z3bgdl.FieldError.fromJson(data) as T;
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
    if (t == _isc.getType<_ib3mptol.Asset?>()) {
      return (data != null ? _ib3mptol.Asset.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i6icgsi8.AssetInput?>()) {
      return (data != null ? _i6icgsi8.AssetInput.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_is3mug9m.AssetPage?>()) {
      return (data != null ? _is3mug9m.AssetPage.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iuumnsch.ProductInput?>()) {
      return (data != null ? _iuumnsch.ProductInput.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i4geouqi.ProductSummary?>()) {
      return (data != null ? _i4geouqi.ProductSummary.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5wnkftg.AppUser?>()) {
      return (data != null ? _i5wnkftg.AppUser.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ilvk5aly.AssignableRole?>()) {
      return (data != null ? _ilvk5aly.AssignableRole.fromJson(data) : null) as T;
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
    if (t == _isc.getType<_i6x1gv4d.TenantUser?>()) {
      return (data != null ? _i6x1gv4d.TenantUser.fromJson(data) : null) as T;
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
    if (t == _isc.getType<_iou7eiap.Branch?>()) {
      return (data != null ? _iou7eiap.Branch.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iptw6tnd.BranchInput?>()) {
      return (data != null ? _iptw6tnd.BranchInput.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iehhesp7.CostCenter?>()) {
      return (data != null ? _iehhesp7.CostCenter.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iofwzavf.CostCenterInput?>()) {
      return (data != null ? _iofwzavf.CostCenterInput.fromJson(data) : null) as T;
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
    if (t == List<_ib3mptol.Asset>) {
      return (data as List).map((e) => deserialize<_ib3mptol.Asset>(e)).toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
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
    if (t == List<_ihgw7zuo.ProductSummary>) {
      return (data as List).map((e) => deserialize<_ihgw7zuo.ProductSummary>(e)).toList() as T;
    }
    if (t == List<_i11upz4e.TenantSummary>) {
      return (data as List).map((e) => deserialize<_i11upz4e.TenantSummary>(e)).toList() as T;
    }
    if (t == List<_i2g1699a.AssignableRole>) {
      return (data as List).map((e) => deserialize<_i2g1699a.AssignableRole>(e)).toList() as T;
    }
    if (t == List<_i8ihd43z.TenantUser>) {
      return (data as List).map((e) => deserialize<_i8ihd43z.TenantUser>(e)).toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_ied3wtyg.Branch>) {
      return (data as List).map((e) => deserialize<_ied3wtyg.Branch>(e)).toList() as T;
    }
    if (t == List<_itoq0gfy.CostCenter>) {
      return (data as List).map((e) => deserialize<_itoq0gfy.CostCenter>(e)).toList() as T;
    }
    final modules = deserializationMetadata.modulesForDeserialization(
      t,
      className: rawDataClassName,
    );
    for (final module in modules) {
      try {
        return module.deserialize<T>(data, t);
      } on _isc.DeserializationTypeNotFoundException catch (_) {}
    }

    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ib3mptol.Asset => 'Asset',
      _i6icgsi8.AssetInput => 'AssetInput',
      _is3mug9m.AssetPage => 'AssetPage',
      _iuumnsch.ProductInput => 'ProductInput',
      _i4geouqi.ProductSummary => 'ProductSummary',
      _i5wnkftg.AppUser => 'AppUser',
      _ilvk5aly.AssignableRole => 'AssignableRole',
      _ip4w8f8l.MeInfo => 'MeInfo',
      _i2vwv4gx.MembershipStatus => 'MembershipStatus',
      _i1iyeyn1.TenantMembership => 'TenantMembership',
      _iutn78jy.TenantMembershipRole => 'TenantMembershipRole',
      _izyppcov.TenantToken => 'TenantToken',
      _i6x1gv4d.TenantUser => 'TenantUser',
      _i147o0qx.ApiException => 'ApiException',
      _i0p9y4c3.ErrorCategory => 'ErrorCategory',
      _i3z3bgdl.FieldError => 'FieldError',
      _iou7eiap.Branch => 'Branch',
      _iptw6tnd.BranchInput => 'BranchInput',
      _iehhesp7.CostCenter => 'CostCenter',
      _iofwzavf.CostCenterInput => 'CostCenterInput',
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
      case _ib3mptol.Asset():
        return 'Asset';
      case _i6icgsi8.AssetInput():
        return 'AssetInput';
      case _is3mug9m.AssetPage():
        return 'AssetPage';
      case _iuumnsch.ProductInput():
        return 'ProductInput';
      case _i4geouqi.ProductSummary():
        return 'ProductSummary';
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
      case _i147o0qx.ApiException():
        return 'ApiException';
      case _i0p9y4c3.ErrorCategory():
        return 'ErrorCategory';
      case _i3z3bgdl.FieldError():
        return 'FieldError';
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
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod_auth_idp.$className';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod_auth_core.$className';
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
    if (dataClassName == 'AssetInput') {
      return deserialize<_i6icgsi8.AssetInput>(data['data']);
    }
    if (dataClassName == 'AssetPage') {
      return deserialize<_is3mug9m.AssetPage>(data['data']);
    }
    if (dataClassName == 'ProductInput') {
      return deserialize<_iuumnsch.ProductInput>(data['data']);
    }
    if (dataClassName == 'ProductSummary') {
      return deserialize<_i4geouqi.ProductSummary>(data['data']);
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
    if (dataClassName == 'ApiException') {
      return deserialize<_i147o0qx.ApiException>(data['data']);
    }
    if (dataClassName == 'ErrorCategory') {
      return deserialize<_i0p9y4c3.ErrorCategory>(data['data']);
    }
    if (dataClassName == 'FieldError') {
      return deserialize<_i3z3bgdl.FieldError>(data['data']);
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
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      return _iaic.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(19),
      });
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      return _iacc.Protocol().deserializeByClassName({
        ...data,
        'className': dataClassName.substring(20),
      });
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iaic.Protocol().registerHostProtocol('plataforma_os', this);
    _iacc.Protocol().registerHostProtocol('plataforma_os', this);
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
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
