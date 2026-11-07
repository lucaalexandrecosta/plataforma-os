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
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class TenantMembershipRole implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TenantMembershipRole._({
    _isc.UuidValue? id,
    required this.tenantId,
    required this.membershipId,
    required this.roleCode,
  }) : id = id ?? const _isc.Uuid().v7obj();

  factory TenantMembershipRole({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required _isc.UuidValue membershipId,
    required String roleCode,
  }) = _TenantMembershipRoleImpl;

  factory TenantMembershipRole.fromJson(Map<String, dynamic> jsonSerialization) {
    return TenantMembershipRole(
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      membershipId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['membershipId']),
      roleCode: jsonSerialization['roleCode'] as String,
    );
  }

  /// The id of the object.
  _isc.UuidValue id;

  _isc.UuidValue tenantId;

  _isc.UuidValue membershipId;

  String roleCode;

  /// Returns a shallow copy of this [TenantMembershipRole]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TenantMembershipRole copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    _isc.UuidValue? membershipId,
    String? roleCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TenantMembershipRole',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'membershipId': membershipId.toJson(),
      'roleCode': roleCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TenantMembershipRole',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'membershipId': membershipId.toJson(),
      'roleCode': roleCode,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TenantMembershipRoleImpl extends TenantMembershipRole {
  _TenantMembershipRoleImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required _isc.UuidValue membershipId,
    required String roleCode,
  }) : super._(
         id: id,
         tenantId: tenantId,
         membershipId: membershipId,
         roleCode: roleCode,
       );

  /// Returns a shallow copy of this [TenantMembershipRole]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TenantMembershipRole copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    _isc.UuidValue? membershipId,
    String? roleCode,
  }) {
    return TenantMembershipRole(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      membershipId: membershipId ?? this.membershipId,
      roleCode: roleCode ?? this.roleCode,
    );
  }
}
