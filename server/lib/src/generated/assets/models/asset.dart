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

abstract class Asset implements _is.SerializableModel, _is.ProtocolSerialization {
  Asset._({
    required this.id,
    required this.productId,
    required this.productName,
    this.serialNumber,
    this.assetTag,
    required this.status,
    required this.ownershipType,
    this.branchId,
    this.costCenterId,
    this.locationNote,
    this.warrantyUntil,
    this.acquisitionDate,
    this.acquisitionCost,
    this.supplierName,
    this.acquisitionDocument,
    this.notes,
    required this.isActive,
    required this.source,
    required this.version,
  });

  factory Asset({
    required _is.UuidValue id,
    required _is.UuidValue productId,
    required String productName,
    String? serialNumber,
    String? assetTag,
    required String status,
    required String ownershipType,
    _is.UuidValue? branchId,
    _is.UuidValue? costCenterId,
    String? locationNote,
    DateTime? warrantyUntil,
    DateTime? acquisitionDate,
    int? acquisitionCost,
    String? supplierName,
    String? acquisitionDocument,
    String? notes,
    required bool isActive,
    required String source,
    required int version,
  }) = _AssetImpl;

  factory Asset.fromJson(Map<String, dynamic> jsonSerialization) {
    return Asset(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      productId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['productId']),
      productName: jsonSerialization['productName'] as String,
      serialNumber: jsonSerialization['serialNumber'] as String?,
      assetTag: jsonSerialization['assetTag'] as String?,
      status: jsonSerialization['status'] as String,
      ownershipType: jsonSerialization['ownershipType'] as String,
      branchId: jsonSerialization['branchId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['branchId']),
      costCenterId: jsonSerialization['costCenterId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['costCenterId']),
      locationNote: jsonSerialization['locationNote'] as String?,
      warrantyUntil: jsonSerialization['warrantyUntil'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['warrantyUntil']),
      acquisitionDate: jsonSerialization['acquisitionDate'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['acquisitionDate']),
      acquisitionCost: jsonSerialization['acquisitionCost'] as int?,
      supplierName: jsonSerialization['supplierName'] as String?,
      acquisitionDocument: jsonSerialization['acquisitionDocument'] as String?,
      notes: jsonSerialization['notes'] as String?,
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      source: jsonSerialization['source'] as String,
      version: jsonSerialization['version'] as int,
    );
  }

  _is.UuidValue id;

  _is.UuidValue productId;

  String productName;

  String? serialNumber;

  String? assetTag;

  String status;

  String ownershipType;

  _is.UuidValue? branchId;

  _is.UuidValue? costCenterId;

  String? locationNote;

  DateTime? warrantyUntil;

  DateTime? acquisitionDate;

  int? acquisitionCost;

  String? supplierName;

  String? acquisitionDocument;

  String? notes;

  bool isActive;

  String source;

  int version;

  /// Returns a shallow copy of this [Asset]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Asset copyWith({
    _is.UuidValue? id,
    _is.UuidValue? productId,
    String? productName,
    String? serialNumber,
    String? assetTag,
    String? status,
    String? ownershipType,
    _is.UuidValue? branchId = const _is.$UndefinedUuidValue(),
    _is.UuidValue? costCenterId = const _is.$UndefinedUuidValue(),
    String? locationNote,
    DateTime? warrantyUntil = const _is.$UndefinedDateTime(),
    DateTime? acquisitionDate = const _is.$UndefinedDateTime(),
    int? acquisitionCost,
    String? supplierName,
    String? acquisitionDocument,
    String? notes,
    bool? isActive,
    String? source,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Asset',
      'id': id.toJson(),
      'productId': productId.toJson(),
      'productName': productName,
      if (serialNumber != null) 'serialNumber': serialNumber,
      if (assetTag != null) 'assetTag': assetTag,
      'status': status,
      'ownershipType': ownershipType,
      if (branchId != null) 'branchId': branchId?.toJson(),
      if (costCenterId != null) 'costCenterId': costCenterId?.toJson(),
      if (locationNote != null) 'locationNote': locationNote,
      if (warrantyUntil != null) 'warrantyUntil': warrantyUntil?.toJson(),
      if (acquisitionDate != null) 'acquisitionDate': acquisitionDate?.toJson(),
      if (acquisitionCost != null) 'acquisitionCost': acquisitionCost,
      if (supplierName != null) 'supplierName': supplierName,
      if (acquisitionDocument != null) 'acquisitionDocument': acquisitionDocument,
      if (notes != null) 'notes': notes,
      'isActive': isActive,
      'source': source,
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Asset',
      'id': id.toJson(),
      'productId': productId.toJson(),
      'productName': productName,
      if (serialNumber != null) 'serialNumber': serialNumber,
      if (assetTag != null) 'assetTag': assetTag,
      'status': status,
      'ownershipType': ownershipType,
      if (branchId != null) 'branchId': branchId?.toJson(),
      if (costCenterId != null) 'costCenterId': costCenterId?.toJson(),
      if (locationNote != null) 'locationNote': locationNote,
      if (warrantyUntil != null) 'warrantyUntil': warrantyUntil?.toJson(),
      if (acquisitionDate != null) 'acquisitionDate': acquisitionDate?.toJson(),
      if (acquisitionCost != null) 'acquisitionCost': acquisitionCost,
      if (supplierName != null) 'supplierName': supplierName,
      if (acquisitionDocument != null) 'acquisitionDocument': acquisitionDocument,
      if (notes != null) 'notes': notes,
      'isActive': isActive,
      'source': source,
      'version': version,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AssetImpl extends Asset {
  _AssetImpl({
    required _is.UuidValue id,
    required _is.UuidValue productId,
    required String productName,
    String? serialNumber,
    String? assetTag,
    required String status,
    required String ownershipType,
    _is.UuidValue? branchId,
    _is.UuidValue? costCenterId,
    String? locationNote,
    DateTime? warrantyUntil,
    DateTime? acquisitionDate,
    int? acquisitionCost,
    String? supplierName,
    String? acquisitionDocument,
    String? notes,
    required bool isActive,
    required String source,
    required int version,
  }) : super._(
         id: id,
         productId: productId,
         productName: productName,
         serialNumber: serialNumber,
         assetTag: assetTag,
         status: status,
         ownershipType: ownershipType,
         branchId: branchId,
         costCenterId: costCenterId,
         locationNote: locationNote,
         warrantyUntil: warrantyUntil,
         acquisitionDate: acquisitionDate,
         acquisitionCost: acquisitionCost,
         supplierName: supplierName,
         acquisitionDocument: acquisitionDocument,
         notes: notes,
         isActive: isActive,
         source: source,
         version: version,
       );

  /// Returns a shallow copy of this [Asset]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Asset copyWith({
    _is.UuidValue? id,
    _is.UuidValue? productId,
    String? productName,
    Object? serialNumber = _Undefined,
    Object? assetTag = _Undefined,
    String? status,
    String? ownershipType,
    _is.UuidValue? branchId = const _is.$UndefinedUuidValue(),
    _is.UuidValue? costCenterId = const _is.$UndefinedUuidValue(),
    Object? locationNote = _Undefined,
    DateTime? warrantyUntil = const _is.$UndefinedDateTime(),
    DateTime? acquisitionDate = const _is.$UndefinedDateTime(),
    Object? acquisitionCost = _Undefined,
    Object? supplierName = _Undefined,
    Object? acquisitionDocument = _Undefined,
    Object? notes = _Undefined,
    bool? isActive,
    String? source,
    int? version,
  }) {
    return Asset(
      id: id ?? this.id,
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      serialNumber: serialNumber is String? ? serialNumber : this.serialNumber,
      assetTag: assetTag is String? ? assetTag : this.assetTag,
      status: status ?? this.status,
      ownershipType: ownershipType ?? this.ownershipType,
      branchId: branchId is _is.UndefinedSentinel ? this.branchId : branchId,
      costCenterId: costCenterId is _is.UndefinedSentinel ? this.costCenterId : costCenterId,
      locationNote: locationNote is String? ? locationNote : this.locationNote,
      warrantyUntil: warrantyUntil is _is.UndefinedSentinel ? this.warrantyUntil : warrantyUntil,
      acquisitionDate: acquisitionDate is _is.UndefinedSentinel ? this.acquisitionDate : acquisitionDate,
      acquisitionCost: acquisitionCost is int? ? acquisitionCost : this.acquisitionCost,
      supplierName: supplierName is String? ? supplierName : this.supplierName,
      acquisitionDocument: acquisitionDocument is String? ? acquisitionDocument : this.acquisitionDocument,
      notes: notes is String? ? notes : this.notes,
      isActive: isActive ?? this.isActive,
      source: source ?? this.source,
      version: version ?? this.version,
    );
  }
}
