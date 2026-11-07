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
import '../../identity_access/models/membership_status.dart' as _it4aomi2;

abstract class TenantMembership implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TenantMembership._({
    _isc.UuidValue? id,
    required this.tenantId,
    required this.userId,
    required this.status,
    this.lastAccessAt,
    required this.version,
  }) : id = id ?? const _isc.Uuid().v7obj();

  factory TenantMembership({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required _isc.UuidValue userId,
    required _it4aomi2.MembershipStatus status,
    DateTime? lastAccessAt,
    required int version,
  }) = _TenantMembershipImpl;

  factory TenantMembership.fromJson(Map<String, dynamic> jsonSerialization) {
    return TenantMembership(
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      userId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      status: _it4aomi2.MembershipStatus.fromJson((jsonSerialization['status'] as String)),
      lastAccessAt: jsonSerialization['lastAccessAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['lastAccessAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  /// The id of the object.
  _isc.UuidValue id;

  _isc.UuidValue tenantId;

  _isc.UuidValue userId;

  _it4aomi2.MembershipStatus status;

  DateTime? lastAccessAt;

  int version;

  /// Returns a shallow copy of this [TenantMembership]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TenantMembership copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    _isc.UuidValue? userId,
    _it4aomi2.MembershipStatus? status,
    DateTime? lastAccessAt = const _isc.$UndefinedDateTime(),
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TenantMembership',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'userId': userId.toJson(),
      'status': status.toJson(),
      if (lastAccessAt != null) 'lastAccessAt': lastAccessAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TenantMembership',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'userId': userId.toJson(),
      'status': status.toJson(),
      if (lastAccessAt != null) 'lastAccessAt': lastAccessAt?.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _TenantMembershipImpl extends TenantMembership {
  _TenantMembershipImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required _isc.UuidValue userId,
    required _it4aomi2.MembershipStatus status,
    DateTime? lastAccessAt,
    required int version,
  }) : super._(
         id: id,
         tenantId: tenantId,
         userId: userId,
         status: status,
         lastAccessAt: lastAccessAt,
         version: version,
       );

  /// Returns a shallow copy of this [TenantMembership]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TenantMembership copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    _isc.UuidValue? userId,
    _it4aomi2.MembershipStatus? status,
    DateTime? lastAccessAt = const _isc.$UndefinedDateTime(),
    int? version,
  }) {
    return TenantMembership(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      lastAccessAt: lastAccessAt is _isc.UndefinedSentinel ? this.lastAccessAt : lastAccessAt,
      version: version ?? this.version,
    );
  }
}
