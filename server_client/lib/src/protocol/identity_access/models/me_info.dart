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
import 'package:plataforma_os_client/src/protocol/protocol.dart' as _inlzmlpe;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../tenancy/models/tenant_summary.dart' as _ia3vjv2o;

abstract class MeInfo implements _isc.SerializableModel, _isc.ProtocolSerialization {
  MeInfo._({
    required this.userId,
    required this.fullName,
    this.email,
    required this.locale,
    required this.tenant,
    required this.roles,
    required this.permissions,
  });

  factory MeInfo({
    required _isc.UuidValue userId,
    required String fullName,
    String? email,
    required String locale,
    required _ia3vjv2o.TenantSummary tenant,
    required List<String> roles,
    required List<String> permissions,
  }) = _MeInfoImpl;

  factory MeInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return MeInfo(
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      fullName: jsonSerialization['fullName'] as String,
      email: jsonSerialization['email'] as String?,
      locale: jsonSerialization['locale'] as String,
      tenant: _inlzmlpe.Protocol().deserialize<_ia3vjv2o.TenantSummary>(jsonSerialization['tenant']),
      roles: _inlzmlpe.Protocol().deserialize<List<String>>(jsonSerialization['roles']),
      permissions: _inlzmlpe.Protocol().deserialize<List<String>>(jsonSerialization['permissions']),
    );
  }

  _isc.UuidValue userId;

  String fullName;

  String? email;

  String locale;

  _ia3vjv2o.TenantSummary tenant;

  List<String> roles;

  List<String> permissions;

  /// Returns a shallow copy of this [MeInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  MeInfo copyWith({
    _isc.UuidValue? userId,
    String? fullName,
    String? email,
    String? locale,
    _ia3vjv2o.TenantSummary? tenant,
    List<String>? roles,
    List<String>? permissions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'MeInfo',
      'userId': userId.toJson(),
      'fullName': fullName,
      if (email != null) 'email': email,
      'locale': locale,
      'tenant': tenant.toJson(),
      'roles': roles.toJson(),
      'permissions': permissions.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'MeInfo',
      'userId': userId.toJson(),
      'fullName': fullName,
      if (email != null) 'email': email,
      'locale': locale,
      'tenant': tenant.toJsonForProtocol(),
      'roles': roles.toJson(),
      'permissions': permissions.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _MeInfoImpl extends MeInfo {
  _MeInfoImpl({
    required _isc.UuidValue userId,
    required String fullName,
    String? email,
    required String locale,
    required _ia3vjv2o.TenantSummary tenant,
    required List<String> roles,
    required List<String> permissions,
  }) : super._(
         userId: userId,
         fullName: fullName,
         email: email,
         locale: locale,
         tenant: tenant,
         roles: roles,
         permissions: permissions,
       );

  /// Returns a shallow copy of this [MeInfo]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  MeInfo copyWith({
    _isc.UuidValue? userId,
    String? fullName,
    Object? email = _Undefined,
    String? locale,
    _ia3vjv2o.TenantSummary? tenant,
    List<String>? roles,
    List<String>? permissions,
  }) {
    return MeInfo(
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email is String? ? email : this.email,
      locale: locale ?? this.locale,
      tenant: tenant ?? this.tenant.copyWith(),
      roles: roles ?? this.roles.map((e0) => e0).toList(),
      permissions: permissions ?? this.permissions.map((e0) => e0).toList(),
    );
  }
}
