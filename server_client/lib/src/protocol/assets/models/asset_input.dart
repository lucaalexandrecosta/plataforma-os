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

abstract class AssetInput implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AssetInput._({
    required this.productId,
    this.serialNumber,
    this.assetTag,
    this.ownershipType,
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
  });

  factory AssetInput({
    required _isc.UuidValue productId,
    String? serialNumber,
    String? assetTag,
    String? ownershipType,
    _isc.UuidValue? branchId,
    _isc.UuidValue? costCenterId,
    String? locationNote,
    DateTime? warrantyUntil,
    DateTime? acquisitionDate,
    int? acquisitionCost,
    String? supplierName,
    String? acquisitionDocument,
    String? notes,
    required bool isActive,
  }) = _AssetInputImpl;

  factory AssetInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return AssetInput(
      productId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['productId']),
      serialNumber: jsonSerialization['serialNumber'] as String?,
      assetTag: jsonSerialization['assetTag'] as String?,
      ownershipType: jsonSerialization['ownershipType'] as String?,
      branchId: jsonSerialization['branchId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['branchId']),
      costCenterId: jsonSerialization['costCenterId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['costCenterId']),
      locationNote: jsonSerialization['locationNote'] as String?,
      warrantyUntil: jsonSerialization['warrantyUntil'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['warrantyUntil']),
      acquisitionDate: jsonSerialization['acquisitionDate'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['acquisitionDate']),
      acquisitionCost: jsonSerialization['acquisitionCost'] as int?,
      supplierName: jsonSerialization['supplierName'] as String?,
      acquisitionDocument: jsonSerialization['acquisitionDocument'] as String?,
      notes: jsonSerialization['notes'] as String?,
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  _isc.UuidValue productId;

  String? serialNumber;

  String? assetTag;

  String? ownershipType;

  _isc.UuidValue? branchId;

  _isc.UuidValue? costCenterId;

  String? locationNote;

  DateTime? warrantyUntil;

  DateTime? acquisitionDate;

  int? acquisitionCost;

  String? supplierName;

  String? acquisitionDocument;

  String? notes;

  bool isActive;

  /// Returns a shallow copy of this [AssetInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AssetInput copyWith({
    _isc.UuidValue? productId,
    String? serialNumber,
    String? assetTag,
    String? ownershipType,
    _isc.UuidValue? branchId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? costCenterId = const _isc.$UndefinedUuidValue(),
    String? locationNote,
    DateTime? warrantyUntil = const _isc.$UndefinedDateTime(),
    DateTime? acquisitionDate = const _isc.$UndefinedDateTime(),
    int? acquisitionCost,
    String? supplierName,
    String? acquisitionDocument,
    String? notes,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AssetInput',
      'productId': productId.toJson(),
      if (serialNumber != null) 'serialNumber': serialNumber,
      if (assetTag != null) 'assetTag': assetTag,
      if (ownershipType != null) 'ownershipType': ownershipType,
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
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AssetInput',
      'productId': productId.toJson(),
      if (serialNumber != null) 'serialNumber': serialNumber,
      if (assetTag != null) 'assetTag': assetTag,
      if (ownershipType != null) 'ownershipType': ownershipType,
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
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AssetInputImpl extends AssetInput {
  _AssetInputImpl({
    required _isc.UuidValue productId,
    String? serialNumber,
    String? assetTag,
    String? ownershipType,
    _isc.UuidValue? branchId,
    _isc.UuidValue? costCenterId,
    String? locationNote,
    DateTime? warrantyUntil,
    DateTime? acquisitionDate,
    int? acquisitionCost,
    String? supplierName,
    String? acquisitionDocument,
    String? notes,
    required bool isActive,
  }) : super._(
         productId: productId,
         serialNumber: serialNumber,
         assetTag: assetTag,
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
       );

  /// Returns a shallow copy of this [AssetInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AssetInput copyWith({
    _isc.UuidValue? productId,
    Object? serialNumber = _Undefined,
    Object? assetTag = _Undefined,
    Object? ownershipType = _Undefined,
    _isc.UuidValue? branchId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? costCenterId = const _isc.$UndefinedUuidValue(),
    Object? locationNote = _Undefined,
    DateTime? warrantyUntil = const _isc.$UndefinedDateTime(),
    DateTime? acquisitionDate = const _isc.$UndefinedDateTime(),
    Object? acquisitionCost = _Undefined,
    Object? supplierName = _Undefined,
    Object? acquisitionDocument = _Undefined,
    Object? notes = _Undefined,
    bool? isActive,
  }) {
    return AssetInput(
      productId: productId ?? this.productId,
      serialNumber: serialNumber is String? ? serialNumber : this.serialNumber,
      assetTag: assetTag is String? ? assetTag : this.assetTag,
      ownershipType: ownershipType is String? ? ownershipType : this.ownershipType,
      branchId: branchId is _isc.UndefinedSentinel ? this.branchId : branchId,
      costCenterId: costCenterId is _isc.UndefinedSentinel ? this.costCenterId : costCenterId,
      locationNote: locationNote is String? ? locationNote : this.locationNote,
      warrantyUntil: warrantyUntil is _isc.UndefinedSentinel ? this.warrantyUntil : warrantyUntil,
      acquisitionDate: acquisitionDate is _isc.UndefinedSentinel ? this.acquisitionDate : acquisitionDate,
      acquisitionCost: acquisitionCost is int? ? acquisitionCost : this.acquisitionCost,
      supplierName: supplierName is String? ? supplierName : this.supplierName,
      acquisitionDocument: acquisitionDocument is String? ? acquisitionDocument : this.acquisitionDocument,
      notes: notes is String? ? notes : this.notes,
      isActive: isActive ?? this.isActive,
    );
  }
}
