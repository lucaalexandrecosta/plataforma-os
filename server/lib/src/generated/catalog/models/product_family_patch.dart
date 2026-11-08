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

abstract class ProductFamilyPatch implements _is.SerializableModel, _is.ProtocolSerialization {
  ProductFamilyPatch._({
    this.code,
    this.name,
    this.parentId,
    this.clearParent,
  });

  factory ProductFamilyPatch({
    String? code,
    String? name,
    _is.UuidValue? parentId,
    bool? clearParent,
  }) = _ProductFamilyPatchImpl;

  factory ProductFamilyPatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductFamilyPatch(
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String?,
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
      clearParent: jsonSerialization['clearParent'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['clearParent']),
    );
  }

  String? code;

  String? name;

  _is.UuidValue? parentId;

  bool? clearParent;

  /// Returns a shallow copy of this [ProductFamilyPatch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProductFamilyPatch copyWith({
    String? code,
    String? name,
    _is.UuidValue? parentId = const _is.$UndefinedUuidValue(),
    bool? clearParent,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductFamilyPatch',
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (parentId != null) 'parentId': parentId?.toJson(),
      if (clearParent != null) 'clearParent': clearParent,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductFamilyPatch',
      if (code != null) 'code': code,
      if (name != null) 'name': name,
      if (parentId != null) 'parentId': parentId?.toJson(),
      if (clearParent != null) 'clearParent': clearParent,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductFamilyPatchImpl extends ProductFamilyPatch {
  _ProductFamilyPatchImpl({
    String? code,
    String? name,
    _is.UuidValue? parentId,
    bool? clearParent,
  }) : super._(
         code: code,
         name: name,
         parentId: parentId,
         clearParent: clearParent,
       );

  /// Returns a shallow copy of this [ProductFamilyPatch]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProductFamilyPatch copyWith({
    Object? code = _Undefined,
    Object? name = _Undefined,
    _is.UuidValue? parentId = const _is.$UndefinedUuidValue(),
    Object? clearParent = _Undefined,
  }) {
    return ProductFamilyPatch(
      code: code is String? ? code : this.code,
      name: name is String? ? name : this.name,
      parentId: parentId is _is.UndefinedSentinel ? this.parentId : parentId,
      clearParent: clearParent is bool? ? clearParent : this.clearParent,
    );
  }
}
