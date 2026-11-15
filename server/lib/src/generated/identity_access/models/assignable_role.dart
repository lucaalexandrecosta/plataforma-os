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
import 'package:serverpod/serverpod.dart' as _is;

abstract class AssignableRole implements _is.SerializableModel, _is.ProtocolSerialization {
  AssignableRole._({
    required this.code,
    required this.name,
    this.description,
  });

  factory AssignableRole({
    required String code,
    required String name,
    String? description,
  }) = _AssignableRoleImpl;

  factory AssignableRole.fromJson(Map<String, dynamic> jsonSerialization) {
    return AssignableRole(
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
    );
  }

  String code;

  String name;

  String? description;

  /// Returns a shallow copy of this [AssignableRole]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AssignableRole copyWith({
    String? code,
    String? name,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AssignableRole',
      'code': code,
      'name': name,
      if (description != null) 'description': description,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AssignableRole',
      'code': code,
      'name': name,
      if (description != null) 'description': description,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AssignableRoleImpl extends AssignableRole {
  _AssignableRoleImpl({
    required String code,
    required String name,
    String? description,
  }) : super._(
         code: code,
         name: name,
         description: description,
       );

  /// Returns a shallow copy of this [AssignableRole]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AssignableRole copyWith({
    String? code,
    String? name,
    Object? description = _Undefined,
  }) {
    return AssignableRole(
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
    );
  }
}
