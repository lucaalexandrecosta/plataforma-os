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

abstract class TechnicianInput implements _isc.SerializableModel, _isc.ProtocolSerialization {
  TechnicianInput._({
    required this.code,
    required this.name,
    this.email,
    this.phone,
    this.userId,
    this.branchId,
    required this.isActive,
  });

  factory TechnicianInput({
    required String code,
    required String name,
    String? email,
    String? phone,
    _isc.UuidValue? userId,
    _isc.UuidValue? branchId,
    required bool isActive,
  }) = _TechnicianInputImpl;

  factory TechnicianInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return TechnicianInput(
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      userId: jsonSerialization['userId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      branchId: jsonSerialization['branchId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['branchId']),
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  String code;

  String name;

  String? email;

  String? phone;

  _isc.UuidValue? userId;

  _isc.UuidValue? branchId;

  bool isActive;

  /// Returns a shallow copy of this [TechnicianInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  TechnicianInput copyWith({
    String? code,
    String? name,
    String? email,
    String? phone,
    _isc.UuidValue? userId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? branchId = const _isc.$UndefinedUuidValue(),
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TechnicianInput',
      'code': code,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (userId != null) 'userId': userId?.toJson(),
      if (branchId != null) 'branchId': branchId?.toJson(),
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TechnicianInput',
      'code': code,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (userId != null) 'userId': userId?.toJson(),
      if (branchId != null) 'branchId': branchId?.toJson(),
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _TechnicianInputImpl extends TechnicianInput {
  _TechnicianInputImpl({
    required String code,
    required String name,
    String? email,
    String? phone,
    _isc.UuidValue? userId,
    _isc.UuidValue? branchId,
    required bool isActive,
  }) : super._(
         code: code,
         name: name,
         email: email,
         phone: phone,
         userId: userId,
         branchId: branchId,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [TechnicianInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  TechnicianInput copyWith({
    String? code,
    String? name,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    _isc.UuidValue? userId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? branchId = const _isc.$UndefinedUuidValue(),
    bool? isActive,
  }) {
    return TechnicianInput(
      code: code ?? this.code,
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      userId: userId is _isc.UndefinedSentinel ? this.userId : userId,
      branchId: branchId is _isc.UndefinedSentinel ? this.branchId : branchId,
      isActive: isActive ?? this.isActive,
    );
  }
}
