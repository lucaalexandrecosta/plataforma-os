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
import '../../catalog/models/product_kind.dart' as _ithievlp;
import '../../platform/models/record_source.dart' as _i1c87mer;

abstract class Product implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Product._({
    _isc.UuidValue? id,
    required this.tenantId,
    required this.code,
    required this.name,
    this.description,
    this.productFamilyId,
    required this.productKind,
    required this.unitCode,
    this.gtin,
    required this.isSerialized,
    required this.tracksAssets,
    this.defaultWarrantyMonths,
    this.referencePrice,
    this.labelPositionInstructions,
    this.labelPositionAttachmentId,
    required this.isActive,
    required this.source,
    this.externalSystem,
    this.externalId,
    this.missingSince,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : id = id ?? const _isc.Uuid().v7obj();

  factory Product({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required String code,
    required String name,
    String? description,
    _isc.UuidValue? productFamilyId,
    required _ithievlp.ProductKind productKind,
    required String unitCode,
    String? gtin,
    required bool isSerialized,
    required bool tracksAssets,
    int? defaultWarrantyMonths,
    int? referencePrice,
    String? labelPositionInstructions,
    _isc.UuidValue? labelPositionAttachmentId,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    DateTime? missingSince,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      productFamilyId: jsonSerialization['productFamilyId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['productFamilyId']),
      productKind: _ithievlp.ProductKind.fromJson((jsonSerialization['productKind'] as String)),
      unitCode: jsonSerialization['unitCode'] as String,
      gtin: jsonSerialization['gtin'] as String?,
      isSerialized: _isc.BoolJsonExtension.fromJson(jsonSerialization['isSerialized']),
      tracksAssets: _isc.BoolJsonExtension.fromJson(jsonSerialization['tracksAssets']),
      defaultWarrantyMonths: jsonSerialization['defaultWarrantyMonths'] as int?,
      referencePrice: jsonSerialization['referencePrice'] as int?,
      labelPositionInstructions: jsonSerialization['labelPositionInstructions'] as String?,
      labelPositionAttachmentId: jsonSerialization['labelPositionAttachmentId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['labelPositionAttachmentId']),
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      source: _i1c87mer.RecordSource.fromJson((jsonSerialization['source'] as String)),
      externalSystem: jsonSerialization['externalSystem'] as String?,
      externalId: jsonSerialization['externalId'] as String?,
      missingSince: jsonSerialization['missingSince'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['missingSince']),
      createdAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  /// The id of the object.
  _isc.UuidValue id;

  _isc.UuidValue tenantId;

  String code;

  String name;

  String? description;

  _isc.UuidValue? productFamilyId;

  _ithievlp.ProductKind productKind;

  String unitCode;

  String? gtin;

  bool isSerialized;

  bool tracksAssets;

  int? defaultWarrantyMonths;

  int? referencePrice;

  String? labelPositionInstructions;

  _isc.UuidValue? labelPositionAttachmentId;

  bool isActive;

  _i1c87mer.RecordSource source;

  String? externalSystem;

  String? externalId;

  DateTime? missingSince;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Product copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
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
    _isc.UuidValue? labelPositionAttachmentId = const _isc.$UndefinedUuidValue(),
    bool? isActive,
    _i1c87mer.RecordSource? source,
    String? externalSystem,
    String? externalId,
    DateTime? missingSince = const _isc.$UndefinedDateTime(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Product',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      if (productFamilyId != null) 'productFamilyId': productFamilyId?.toJson(),
      'productKind': productKind.toJson(),
      'unitCode': unitCode,
      if (gtin != null) 'gtin': gtin,
      'isSerialized': isSerialized,
      'tracksAssets': tracksAssets,
      if (defaultWarrantyMonths != null) 'defaultWarrantyMonths': defaultWarrantyMonths,
      if (referencePrice != null) 'referencePrice': referencePrice,
      if (labelPositionInstructions != null) 'labelPositionInstructions': labelPositionInstructions,
      if (labelPositionAttachmentId != null) 'labelPositionAttachmentId': labelPositionAttachmentId?.toJson(),
      'isActive': isActive,
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      if (missingSince != null) 'missingSince': missingSince?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Product',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      if (productFamilyId != null) 'productFamilyId': productFamilyId?.toJson(),
      'productKind': productKind.toJson(),
      'unitCode': unitCode,
      if (gtin != null) 'gtin': gtin,
      'isSerialized': isSerialized,
      'tracksAssets': tracksAssets,
      if (defaultWarrantyMonths != null) 'defaultWarrantyMonths': defaultWarrantyMonths,
      if (referencePrice != null) 'referencePrice': referencePrice,
      if (labelPositionInstructions != null) 'labelPositionInstructions': labelPositionInstructions,
      if (labelPositionAttachmentId != null) 'labelPositionAttachmentId': labelPositionAttachmentId?.toJson(),
      'isActive': isActive,
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      if (missingSince != null) 'missingSince': missingSince?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductImpl extends Product {
  _ProductImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required String code,
    required String name,
    String? description,
    _isc.UuidValue? productFamilyId,
    required _ithievlp.ProductKind productKind,
    required String unitCode,
    String? gtin,
    required bool isSerialized,
    required bool tracksAssets,
    int? defaultWarrantyMonths,
    int? referencePrice,
    String? labelPositionInstructions,
    _isc.UuidValue? labelPositionAttachmentId,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    DateTime? missingSince,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         tenantId: tenantId,
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
         labelPositionAttachmentId: labelPositionAttachmentId,
         isActive: isActive,
         source: source,
         externalSystem: externalSystem,
         externalId: externalId,
         missingSince: missingSince,
         createdAt: createdAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Product copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    String? code,
    String? name,
    Object? description = _Undefined,
    _isc.UuidValue? productFamilyId = const _isc.$UndefinedUuidValue(),
    _ithievlp.ProductKind? productKind,
    String? unitCode,
    Object? gtin = _Undefined,
    bool? isSerialized,
    bool? tracksAssets,
    Object? defaultWarrantyMonths = _Undefined,
    Object? referencePrice = _Undefined,
    Object? labelPositionInstructions = _Undefined,
    _isc.UuidValue? labelPositionAttachmentId = const _isc.$UndefinedUuidValue(),
    bool? isActive,
    _i1c87mer.RecordSource? source,
    Object? externalSystem = _Undefined,
    Object? externalId = _Undefined,
    DateTime? missingSince = const _isc.$UndefinedDateTime(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return Product(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      productFamilyId: productFamilyId is _isc.UndefinedSentinel ? this.productFamilyId : productFamilyId,
      productKind: productKind ?? this.productKind,
      unitCode: unitCode ?? this.unitCode,
      gtin: gtin is String? ? gtin : this.gtin,
      isSerialized: isSerialized ?? this.isSerialized,
      tracksAssets: tracksAssets ?? this.tracksAssets,
      defaultWarrantyMonths: defaultWarrantyMonths is int? ? defaultWarrantyMonths : this.defaultWarrantyMonths,
      referencePrice: referencePrice is int? ? referencePrice : this.referencePrice,
      labelPositionInstructions: labelPositionInstructions is String?
          ? labelPositionInstructions
          : this.labelPositionInstructions,
      labelPositionAttachmentId: labelPositionAttachmentId is _isc.UndefinedSentinel
          ? this.labelPositionAttachmentId
          : labelPositionAttachmentId,
      isActive: isActive ?? this.isActive,
      source: source ?? this.source,
      externalSystem: externalSystem is String? ? externalSystem : this.externalSystem,
      externalId: externalId is String? ? externalId : this.externalId,
      missingSince: missingSince is _isc.UndefinedSentinel ? this.missingSince : missingSince,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}
