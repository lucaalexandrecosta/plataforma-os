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
import 'package:plataforma_os_client/src/protocol/tenancy/models/tenant_summary.dart' as _i11upz4e;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'identity_access/models/app_user.dart' as _i5wnkftg;
import 'identity_access/models/me_info.dart' as _ip4w8f8l;
import 'identity_access/models/membership_status.dart' as _i2vwv4gx;
import 'identity_access/models/tenant_membership.dart' as _i1iyeyn1;
import 'identity_access/models/tenant_membership_role.dart' as _iutn78jy;
import 'identity_access/models/tenant_token.dart' as _izyppcov;
import 'platform/errors/models/api_exception.dart' as _i147o0qx;
import 'platform/errors/models/error_category.dart' as _i0p9y4c3;
import 'platform/errors/models/field_error.dart' as _i3z3bgdl;
import 'tenancy/models/tenant.dart' as _i2jhpzjh;
import 'tenancy/models/tenant_status.dart' as _i2bjgc9x;
import 'tenancy/models/tenant_summary.dart' as _i9uizrsf;
export 'identity_access/models/app_user.dart';
export 'identity_access/models/me_info.dart';
export 'identity_access/models/membership_status.dart';
export 'identity_access/models/tenant_membership.dart';
export 'identity_access/models/tenant_membership_role.dart';
export 'identity_access/models/tenant_token.dart';
export 'platform/errors/models/api_exception.dart';
export 'platform/errors/models/error_category.dart';
export 'platform/errors/models/field_error.dart';
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
      _isc.getType<_i5wnkftg.AppUser>,
      _isc.getType<_ip4w8f8l.MeInfo>,
      _isc.getType<_i2vwv4gx.MembershipStatus>,
      _isc.getType<_i1iyeyn1.TenantMembership>,
      _isc.getType<_iutn78jy.TenantMembershipRole>,
      _isc.getType<_izyppcov.TenantToken>,
      _isc.getType<_i147o0qx.ApiException>,
      _isc.getType<_i0p9y4c3.ErrorCategory>,
      _isc.getType<_i3z3bgdl.FieldError>,
      _isc.getType<_i2jhpzjh.Tenant>,
      _isc.getType<_i2bjgc9x.TenantStatus>,
      _isc.getType<_i9uizrsf.TenantSummary>,
      _isc.getType<_i5wnkftg.AppUser?>,
      _isc.getType<_ip4w8f8l.MeInfo?>,
      _isc.getType<_i2vwv4gx.MembershipStatus?>,
      _isc.getType<_i1iyeyn1.TenantMembership?>,
      _isc.getType<_iutn78jy.TenantMembershipRole?>,
      _isc.getType<_izyppcov.TenantToken?>,
      _isc.getType<_i147o0qx.ApiException?>,
      _isc.getType<_i0p9y4c3.ErrorCategory?>,
      _isc.getType<_i3z3bgdl.FieldError?>,
      _isc.getType<_i2jhpzjh.Tenant?>,
      _isc.getType<_i2bjgc9x.TenantStatus?>,
      _isc.getType<_i9uizrsf.TenantSummary?>,
      _isc.getType<List<String>>,
      _isc.getType<List<_i3z3bgdl.FieldError>>,
      _isc.getType<List<_i3z3bgdl.FieldError>?>,
      _isc.getType<Map<String, String>>,
      _isc.getType<Map<String, String>?>,
      _isc.getType<List<_i11upz4e.TenantSummary>>,
    ],
    modules: const [],
    classNames: const [
      'AppUser',
      'MeInfo',
      'MembershipStatus',
      'TenantMembership',
      'TenantMembershipRole',
      'TenantToken',
      'ApiException',
      'ErrorCategory',
      'FieldError',
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
    if (t == _i2jhpzjh.Tenant) {
      return _i2jhpzjh.Tenant.fromJson(data) as T;
    }
    if (t == _i2bjgc9x.TenantStatus) {
      return _i2bjgc9x.TenantStatus.fromJson(data) as T;
    }
    if (t == _i9uizrsf.TenantSummary) {
      return _i9uizrsf.TenantSummary.fromJson(data) as T;
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
    if (t == _isc.getType<_i147o0qx.ApiException?>()) {
      return (data != null ? _i147o0qx.ApiException.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i0p9y4c3.ErrorCategory?>()) {
      return (data != null ? _i0p9y4c3.ErrorCategory.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3z3bgdl.FieldError?>()) {
      return (data != null ? _i3z3bgdl.FieldError.fromJson(data) : null) as T;
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
    if (t == List<_i11upz4e.TenantSummary>) {
      return (data as List).map((e) => deserialize<_i11upz4e.TenantSummary>(e)).toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5wnkftg.AppUser => 'AppUser',
      _ip4w8f8l.MeInfo => 'MeInfo',
      _i2vwv4gx.MembershipStatus => 'MembershipStatus',
      _i1iyeyn1.TenantMembership => 'TenantMembership',
      _iutn78jy.TenantMembershipRole => 'TenantMembershipRole',
      _izyppcov.TenantToken => 'TenantToken',
      _i147o0qx.ApiException => 'ApiException',
      _i0p9y4c3.ErrorCategory => 'ErrorCategory',
      _i3z3bgdl.FieldError => 'FieldError',
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
