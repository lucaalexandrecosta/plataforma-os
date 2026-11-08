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
import 'package:plataforma_os_client/src/protocol/protocol.dart' as _inlzmlpe;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../catalog/models/product_field.dart' as _ih6ivsvd;
import '../../catalog/models/product_kind.dart' as _ithievlp;

abstract class ProductPatch implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProductPatch._({
    this.code,
    this.name,
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
    this.clear,
  });

  factory ProductPatch({
    String? code,
    String? name,
    String? description,
    _isc.UuidValue? productFamilyId,
    _ithievlp.ProductKind? productKind,
    String? unitCode,
    String? gtin,
    bool? isSerialized,
    bool? tracksAssets,
    int? defaultWarrantyMonths,
    int? referencePrice,
    String? labelPositionInstructions,
    List<_ih6ivsvd.ProductField>? clear,
  }) = _ProductPatchImpl;

  factory ProductPatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductPatch(
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String?,
      description: jsonSerialization['description'] as String?,
      productFamilyId: jsonSerialization['productFamilyId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['productFamilyId']),
      productKind: jsonSerialization['productKind'] == null
          ? null
          : _ithievlp.ProductKind.fromJson((jsonSerialization['productKind'] as String)),
      unitCode: jsonSerialization['unitCode'] as String?,
      gtin: jsonSerialization['gtin'] as String?,
      isSerialized: jsonSerialization['isSerialized'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isSerialized']),
      tracksAssets: jsonSerialization['tracksAssets'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['tracksAssets']),
      defaultWarrantyMonths: jsonSerialization['defaultWarrantyMonths'] as int?,
      referencePrice: jsonSerialization['referencePrice'] as int?,
      labelPositionInstructions: jsonSerialization['labelPositionInstructions'] as String?,
      clear: jsonSerialization['clear'] == null
          ? null
          : _inlzmlpe.Protocol().deserialize<List<_ih6ivsvd.ProductField>>(jsonSerialization['clear']),
    );
  }

  String? code;

  String? name;

  String? description;

  _isc.UuidValue? productFamilyId;

  _ithievlp.ProductKind? productKind;

  String? unitCode;

  String? gtin;

  bool? isSerialized;

  bool? tracksAssets;

  int? defaultWarrantyMonths;

  int? referencePrice;

  String? labelPositionInstructions;

  List<_ih6ivsvd.ProductField>? clear;

  /// Returns a shallow copy of this [ProductPatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProductPatch copyWith({
    String? code,
    String? name,
    String? description,
    _isc.UuidValue? productFamilyId = const _isc.$UndefinedUuidValue(),
    _ithievlp.ProductKind? productKind,
    String? unitCode,
    String? gtin,
    bool? isSerialized,
    bool? tracksAssets,
    int? defaultWarrantyMonths,
    int? referencePrice,
    String? labelPositionInstructions,
    List<_ih6ivsvd.ProductField>? clear = const _isc.$UndefinedList<_ih6ivsvd.ProductField>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductPatch',
      if (code != null) 'code': code,
      if (name != null) 'name': name,
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
      if (clear != null) 'clear': clear?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductPatch',
      if (code != null) 'code': code,
      if (name != null) 'name': name,
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
      if (clear != null) 'clear': clear?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductPatchImpl extends ProductPatch {
  _ProductPatchImpl({
    String? code,
    String? name,
    String? description,
    _isc.UuidValue? productFamilyId,
    _ithievlp.ProductKind? productKind,
    String? unitCode,
    String? gtin,
    bool? isSerialized,
    bool? tracksAssets,
    int? defaultWarrantyMonths,
    int? referencePrice,
    String? labelPositionInstructions,
    List<_ih6ivsvd.ProductField>? clear,
  }) : super._(
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
         clear: clear,
       );

  /// Returns a shallow copy of this [ProductPatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProductPatch copyWith({
    Object? code = _Undefined,
    Object? name = _Undefined,
    Object? description = _Undefined,
    _isc.UuidValue? productFamilyId = const _isc.$UndefinedUuidValue(),
    Object? productKind = _Undefined,
    Object? unitCode = _Undefined,
    Object? gtin = _Undefined,
    Object? isSerialized = _Undefined,
    Object? tracksAssets = _Undefined,
    Object? defaultWarrantyMonths = _Undefined,
    Object? referencePrice = _Undefined,
    Object? labelPositionInstructions = _Undefined,
    List<_ih6ivsvd.ProductField>? clear = const _isc.$UndefinedList<_ih6ivsvd.ProductField>(),
  }) {
    return ProductPatch(
      code: code is String? ? code : this.code,
      name: name is String? ? name : this.name,
      description: description is String? ? description : this.description,
      productFamilyId: productFamilyId is _isc.UndefinedSentinel ? this.productFamilyId : productFamilyId,
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
      clear: clear is _isc.UndefinedSentinel ? this.clear?.map((e0) => e0).toList() : clear,
    );
  }
}
