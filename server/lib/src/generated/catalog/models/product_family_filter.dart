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

abstract class ProductFamilyFilter implements _is.SerializableModel, _is.ProtocolSerialization {
  ProductFamilyFilter._({
    this.q,
    this.isActive,
    this.parentId,
    this.rootsOnly,
  });

  factory ProductFamilyFilter({
    String? q,
    bool? isActive,
    _is.UuidValue? parentId,
    bool? rootsOnly,
  }) = _ProductFamilyFilterImpl;

  factory ProductFamilyFilter.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductFamilyFilter(
      q: jsonSerialization['q'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
      rootsOnly: jsonSerialization['rootsOnly'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['rootsOnly']),
    );
  }

  String? q;

  bool? isActive;

  _is.UuidValue? parentId;

  bool? rootsOnly;

  /// Returns a shallow copy of this [ProductFamilyFilter]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProductFamilyFilter copyWith({
    String? q,
    bool? isActive,
    _is.UuidValue? parentId = const _is.$UndefinedUuidValue(),
    bool? rootsOnly,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductFamilyFilter',
      if (q != null) 'q': q,
      if (isActive != null) 'isActive': isActive,
      if (parentId != null) 'parentId': parentId?.toJson(),
      if (rootsOnly != null) 'rootsOnly': rootsOnly,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductFamilyFilter',
      if (q != null) 'q': q,
      if (isActive != null) 'isActive': isActive,
      if (parentId != null) 'parentId': parentId?.toJson(),
      if (rootsOnly != null) 'rootsOnly': rootsOnly,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductFamilyFilterImpl extends ProductFamilyFilter {
  _ProductFamilyFilterImpl({
    String? q,
    bool? isActive,
    _is.UuidValue? parentId,
    bool? rootsOnly,
  }) : super._(
         q: q,
         isActive: isActive,
         parentId: parentId,
         rootsOnly: rootsOnly,
       );

  /// Returns a shallow copy of this [ProductFamilyFilter]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProductFamilyFilter copyWith({
    Object? q = _Undefined,
    Object? isActive = _Undefined,
    _is.UuidValue? parentId = const _is.$UndefinedUuidValue(),
    Object? rootsOnly = _Undefined,
  }) {
    return ProductFamilyFilter(
      q: q is String? ? q : this.q,
      isActive: isActive is bool? ? isActive : this.isActive,
      parentId: parentId is _is.UndefinedSentinel ? this.parentId : parentId,
      rootsOnly: rootsOnly is bool? ? rootsOnly : this.rootsOnly,
    );
  }
}
