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

abstract class ProductInput implements _is.SerializableModel, _is.ProtocolSerialization {
  ProductInput._({
    this.id,
    required this.code,
    required this.name,
    this.description,
    this.productFamilyId,
    this.productKind,
    this.unitCode,
    this.gtin,
    this.isSerialized,
    this.tracksAssets,
    this.defaultWarrantyMonths,
    this.referencePrice,
    this.labelPositionInstructions,
  });

  factory ProductInput({
    _is.UuidValue? id,
    required String code,
    required String name,
    String? description,
    _is.UuidValue? productFamilyId,
    _ithievlp.ProductKind? productKind,
    String? unitCode,
    String? gtin,
    bool? isSerialized,
    bool? tracksAssets,
    int? defaultWarrantyMonths,
    int? referencePrice,
    String? labelPositionInstructions,
  }) = _ProductInputImpl;

  factory ProductInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductInput(
      id: jsonSerialization['id'] == null ? null : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      productFamilyId: jsonSerialization['productFamilyId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['productFamilyId']),
      productKind: jsonSerialization['productKind'] == null
          ? null
          : _ithievlp.ProductKind.fromJson((jsonSerialization['productKind'] as String)),
      unitCode: jsonSerialization['unitCode'] as String?,
      gtin: jsonSerialization['gtin'] as String?,
      isSerialized: jsonSerialization['isSerialized'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isSerialized']),
      tracksAssets: jsonSerialization['tracksAssets'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['tracksAssets']),
      defaultWarrantyMonths: jsonSerialization['defaultWarrantyMonths'] as int?,
      referencePrice: jsonSerialization['referencePrice'] as int?,
      labelPositionInstructions: jsonSerialization['labelPositionInstructions'] as String?,
    );
  }

  _is.UuidValue? id;

  String code;

  String name;

  String? description;

  _is.UuidValue? productFamilyId;

  _ithievlp.ProductKind? productKind;

  String? unitCode;

  String? gtin;

  bool? isSerialized;

  bool? tracksAssets;

  int? defaultWarrantyMonths;

  int? referencePrice;

  String? labelPositionInstructions;

  /// Returns a shallow copy of this [ProductInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProductInput copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    String? code,
    String? name,
    String? description,
    _is.UuidValue? productFamilyId = const _is.$UndefinedUuidValue(),
    _ithievlp.ProductKind? productKind,
    String? unitCode,
    String? gtin,
    bool? isSerialized,
    bool? tracksAssets,
    int? defaultWarrantyMonths,
    int? referencePrice,
    String? labelPositionInstructions,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductInput',
      if (id != null) 'id': id?.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      if (productFamilyId != null) 'productFamilyId': productFamilyId?.toJson(),
      if (productKind != null) 'productKind': productKind?.toJson(),
      if (unitCode != null) 'unitCode': unitCode,
      if (gtin != null) 'gtin': gtin,
      if (isSerialized != null) 'isSerialized': isSerialized,
      if (tracksAssets != null) 'tracksAssets': tracksAssets,
      if (defaultWarrantyMonths != null) 'defaultWarrantyMonths': defaultWarrantyMonths,
      if (referencePrice != null) 'referencePrice': referencePrice,
      if (labelPositionInstructions != null) 'labelPositionInstructions': labelPositionInstructions,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductInput',
      if (id != null) 'id': id?.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      if (productFamilyId != null) 'productFamilyId': productFamilyId?.toJson(),
      if (productKind != null) 'productKind': productKind?.toJson(),
      if (unitCode != null) 'unitCode': unitCode,
      if (gtin != null) 'gtin': gtin,
      if (isSerialized != null) 'isSerialized': isSerialized,
      if (tracksAssets != null) 'tracksAssets': tracksAssets,
      if (defaultWarrantyMonths != null) 'defaultWarrantyMonths': defaultWarrantyMonths,
      if (referencePrice != null) 'referencePrice': referencePrice,
      if (labelPositionInstructions != null) 'labelPositionInstructions': labelPositionInstructions,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductInputImpl extends ProductInput {
  _ProductInputImpl({
    _is.UuidValue? id,
    required String code,
    required String name,
    String? description,
    _is.UuidValue? productFamilyId,
    _ithievlp.ProductKind? productKind,
    String? unitCode,
    String? gtin,
    bool? isSerialized,
    bool? tracksAssets,
    int? defaultWarrantyMonths,
    int? referencePrice,
    String? labelPositionInstructions,
  }) : super._(
         id: id,
         code: code,
         name: name,
         description: description,
         productFamilyId: productFamilyId,
         productKind: productKind,
         unitCode: unitCode,
         gtin: gtin,
         isSerialized: isSerialized,
         tracksAssets: tracksAssets,
         defaultWarrantyMonths: defaultWarrantyMonths,
         referencePrice: referencePrice,
         labelPositionInstructions: labelPositionInstructions,
       );

  /// Returns a shallow copy of this [ProductInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProductInput copyWith({
    _is.UuidValue? id = const _is.$UndefinedUuidValue(),
    String? code,
    String? name,
    Object? description = _Undefined,
    _is.UuidValue? productFamilyId = const _is.$UndefinedUuidValue(),
    Object? productKind = _Undefined,
    Object? unitCode = _Undefined,
    Object? gtin = _Undefined,
    Object? isSerialized = _Undefined,
    Object? tracksAssets = _Undefined,
    Object? defaultWarrantyMonths = _Undefined,
    Object? referencePrice = _Undefined,
    Object? labelPositionInstructions = _Undefined,
  }) {
    return ProductInput(
      id: id is _is.UndefinedSentinel ? this.id : id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      productFamilyId: productFamilyId is _is.UndefinedSentinel ? this.productFamilyId : productFamilyId,
      productKind: productKind is _ithievlp.ProductKind? ? productKind : this.productKind,
      unitCode: unitCode is String? ? unitCode : this.unitCode,
      gtin: gtin is String? ? gtin : this.gtin,
      isSerialized: isSerialized is bool? ? isSerialized : this.isSerialized,
      tracksAssets: tracksAssets is bool? ? tracksAssets : this.tracksAssets,
      defaultWarrantyMonths: defaultWarrantyMonths is int? ? defaultWarrantyMonths : this.defaultWarrantyMonths,
      referencePrice: referencePrice is int? ? referencePrice : this.referencePrice,
      labelPositionInstructions: labelPositionInstructions is String?
          ? labelPositionInstructions
          : this.labelPositionInstructions,
    );
  }
}
