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
import '../../catalog/models/product_kind.dart' as _ithievlp;
import '../../platform/models/record_source.dart' as _i1c87mer;

abstract class ProductFilter implements _is.SerializableModel, _is.ProtocolSerialization {
  ProductFilter._({
    this.q,
    this.isActive,
    this.productKind,
    this.productFamilyId,
    this.source,
  });

  factory ProductFilter({
    String? q,
    bool? isActive,
    _ithievlp.ProductKind? productKind,
    _is.UuidValue? productFamilyId,
    _i1c87mer.RecordSource? source,
  }) = _ProductFilterImpl;

  factory ProductFilter.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductFilter(
      q: jsonSerialization['q'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      productKind: jsonSerialization['productKind'] == null
          ? null
          : _ithievlp.ProductKind.fromJson((jsonSerialization['productKind'] as String)),
      productFamilyId: jsonSerialization['productFamilyId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['productFamilyId']),
      source: jsonSerialization['source'] == null
          ? null
          : _i1c87mer.RecordSource.fromJson((jsonSerialization['source'] as String)),
    );
  }

  String? q;

  bool? isActive;

  _ithievlp.ProductKind? productKind;

  _is.UuidValue? productFamilyId;

  _i1c87mer.RecordSource? source;

  /// Returns a shallow copy of this [ProductFilter]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProductFilter copyWith({
    String? q,
    bool? isActive,
    _ithievlp.ProductKind? productKind,
    _is.UuidValue? productFamilyId = const _is.$UndefinedUuidValue(),
    _i1c87mer.RecordSource? source,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductFilter',
      if (q != null) 'q': q,
      if (isActive != null) 'isActive': isActive,
      if (productKind != null) 'productKind': productKind?.toJson(),
      if (productFamilyId != null) 'productFamilyId': productFamilyId?.toJson(),
      if (source != null) 'source': source?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductFilter',
      if (q != null) 'q': q,
      if (isActive != null) 'isActive': isActive,
      if (productKind != null) 'productKind': productKind?.toJson(),
      if (productFamilyId != null) 'productFamilyId': productFamilyId?.toJson(),
      if (source != null) 'source': source?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductFilterImpl extends ProductFilter {
  _ProductFilterImpl({
    String? q,
    bool? isActive,
    _ithievlp.ProductKind? productKind,
    _is.UuidValue? productFamilyId,
    _i1c87mer.RecordSource? source,
  }) : super._(
         q: q,
         isActive: isActive,
         productKind: productKind,
         productFamilyId: productFamilyId,
         source: source,
       );

  /// Returns a shallow copy of this [ProductFilter]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProductFilter copyWith({
    Object? q = _Undefined,
    Object? isActive = _Undefined,
    Object? productKind = _Undefined,
    _is.UuidValue? productFamilyId = const _is.$UndefinedUuidValue(),
    Object? source = _Undefined,
  }) {
    return ProductFilter(
      q: q is String? ? q : this.q,
      isActive: isActive is bool? ? isActive : this.isActive,
      productKind: productKind is _ithievlp.ProductKind? ? productKind : this.productKind,
      productFamilyId: productFamilyId is _is.UndefinedSentinel ? this.productFamilyId : productFamilyId,
      source: source is _i1c87mer.RecordSource? ? source : this.source,
    );
  }
}
