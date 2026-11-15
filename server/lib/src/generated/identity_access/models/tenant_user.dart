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
import 'package:plataforma_os_server/src/generated/protocol.dart' as _isma42go;
import 'package:serverpod/serverpod.dart' as _is;
import '../../identity_access/models/membership_status.dart' as _it4aomi2;

abstract class TenantUser implements _is.SerializableModel, _is.ProtocolSerialization {
  TenantUser._({
    required this.membershipId,
    required this.userId,
    required this.fullName,
    this.email,
    required this.status,
    required this.roles,
    required this.hasLogin,
    this.lastAccessAt,
  });

  factory TenantUser({
    required _is.UuidValue membershipId,
    required _is.UuidValue userId,
    required String fullName,
    String? email,
    required _it4aomi2.MembershipStatus status,
    required List<String> roles,
    required bool hasLogin,
    DateTime? lastAccessAt,
  }) = _TenantUserImpl;

  factory TenantUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return TenantUser(
      membershipId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['membershipId']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      fullName: jsonSerialization['fullName'] as String,
      email: jsonSerialization['email'] as String?,
      status: _it4aomi2.MembershipStatus.fromJson((jsonSerialization['status'] as String)),
      roles: _isma42go.Protocol().deserialize<List<String>>(jsonSerialization['roles']),
      hasLogin: _is.BoolJsonExtension.fromJson(jsonSerialization['hasLogin']),
      lastAccessAt: jsonSerialization['lastAccessAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastAccessAt']),
    );
  }

  _is.UuidValue membershipId;

  _is.UuidValue userId;

  String fullName;

  String? email;

  _it4aomi2.MembershipStatus status;

  List<String> roles;

  bool hasLogin;

  DateTime? lastAccessAt;

  /// Returns a shallow copy of this [TenantUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TenantUser copyWith({
    _is.UuidValue? membershipId,
    _is.UuidValue? userId,
    String? fullName,
    String? email,
    _it4aomi2.MembershipStatus? status,
    List<String>? roles,
    bool? hasLogin,
    DateTime? lastAccessAt = const _is.$UndefinedDateTime(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TenantUser',
      'membershipId': membershipId.toJson(),
      'userId': userId.toJson(),
      'fullName': fullName,
      if (email != null) 'email': email,
      'status': status.toJson(),
      'roles': roles.toJson(),
      'hasLogin': hasLogin,
      if (lastAccessAt != null) 'lastAccessAt': lastAccessAt?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TenantUser',
      'membershipId': membershipId.toJson(),
      'userId': userId.toJson(),
      'fullName': fullName,
      if (email != null) 'email': email,
      'status': status.toJson(),
      'roles': roles.toJson(),
      'hasLogin': hasLogin,
      if (lastAccessAt != null) 'lastAccessAt': lastAccessAt?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TenantUserImpl extends TenantUser {
  _TenantUserImpl({
    required _is.UuidValue membershipId,
    required _is.UuidValue userId,
    required String fullName,
    String? email,
    required _it4aomi2.MembershipStatus status,
    required List<String> roles,
    required bool hasLogin,
    DateTime? lastAccessAt,
  }) : super._(
         membershipId: membershipId,
         userId: userId,
         fullName: fullName,
         email: email,
         status: status,
         roles: roles,
         hasLogin: hasLogin,
         lastAccessAt: lastAccessAt,
       );

  /// Returns a shallow copy of this [TenantUser]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TenantUser copyWith({
    _is.UuidValue? membershipId,
    _is.UuidValue? userId,
    String? fullName,
    Object? email = _Undefined,
    _it4aomi2.MembershipStatus? status,
    List<String>? roles,
    bool? hasLogin,
    DateTime? lastAccessAt = const _is.$UndefinedDateTime(),
  }) {
    return TenantUser(
      membershipId: membershipId ?? this.membershipId,
      userId: userId ?? this.userId,
      fullName: fullName ?? this.fullName,
      email: email is String? ? email : this.email,
      status: status ?? this.status,
      roles: roles ?? this.roles.map((e0) => e0).toList(),
      hasLogin: hasLogin ?? this.hasLogin,
      lastAccessAt: lastAccessAt is _is.UndefinedSentinel ? this.lastAccessAt : lastAccessAt,
    );
  }
}
