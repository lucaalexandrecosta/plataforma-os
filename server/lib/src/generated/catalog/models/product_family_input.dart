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

abstract class ProductFamilyInput implements _is.SerializableModel, _is.ProtocolSerialization {
  ProductFamilyInput._({
    this.id,
    required this.code,
    required this.name,
    this.parentId,
  });

  factory ProductFamilyInput({
    _is.UuidValue? id,
    required String code,
    required String name,
    _is.UuidValue? parentId,
  }) = _ProductFamilyInputImpl;

  factory ProductFamilyInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductFamilyInput(
      id: jsonSerialization['id'] == null ? null : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
    );
  }

  _is.UuidValue? id;

  String code;

  String name;

  _is.UuidValue? parentId;

  /// Returns a shallow copy of this [ProductFamilyInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProductFamilyInput copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    String? code,
    String? name,
    _is.UuidValue? parentId = const _is.$UndefinedUuidValue(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductFamilyInput',
      if (id != null) 'id': id?.toJson(),
      'code': code,
      'name': name,
      if (parentId != null) 'parentId': parentId?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductFamilyInput',
      if (id != null) 'id': id?.toJson(),
      'code': code,
      'name': name,
      if (parentId != null) 'parentId': parentId?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ProductFamilyInputImpl extends ProductFamilyInput {
  _ProductFamilyInputImpl({
    _is.UuidValue? id,
    required String code,
    required String name,
    _is.UuidValue? parentId,
  }) : super._(
         id: id,
         code: code,
         name: name,
         parentId: parentId,
       );

  /// Returns a shallow copy of this [ProductFamilyInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProductFamilyInput copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    String? code,
    String? name,
    _is.UuidValue? parentId = const _is.$UndefinedUuidValue(),
  }) {
    return ProductFamilyInput(
      id: id is _is.UndefinedSentinel ? this.id : id,
      code: code ?? this.code,
      name: name ?? this.name,
      parentId: parentId is _is.UndefinedSentinel ? this.parentId : parentId,
    );
  }
}
