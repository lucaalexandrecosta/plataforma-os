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

abstract class AssetAssignment implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AssetAssignment._({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerSiteId,
    required this.customerSiteName,
    required this.ownershipType,
    required this.startedAt,
    this.endedAt,
    required this.startReason,
    this.endReason,
    this.sourceDocumentType,
    this.sourceDocumentNumber,
    this.notes,
  });

  factory AssetAssignment({
    required _isc.UuidValue id,
    required _isc.UuidValue customerId,
    required String customerName,
    required _isc.UuidValue customerSiteId,
    required String customerSiteName,
    required String ownershipType,
    required DateTime startedAt,
    DateTime? endedAt,
    required String startReason,
    String? endReason,
    String? sourceDocumentType,
    String? sourceDocumentNumber,
    String? notes,
  }) = _AssetAssignmentImpl;

  factory AssetAssignment.fromJson(Map<String, dynamic> jsonSerialization) {
    return AssetAssignment(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      customerId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['customerId']),
      customerName: jsonSerialization['customerName'] as String,
      customerSiteId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['customerSiteId']),
      customerSiteName: jsonSerialization['customerSiteName'] as String,
      ownershipType: jsonSerialization['ownershipType'] as String,
      startedAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      startReason: jsonSerialization['startReason'] as String,
      endReason: jsonSerialization['endReason'] as String?,
      sourceDocumentType: jsonSerialization['sourceDocumentType'] as String?,
      sourceDocumentNumber: jsonSerialization['sourceDocumentNumber'] as String?,
      notes: jsonSerialization['notes'] as String?,
    );
  }

  _isc.UuidValue id;

  _isc.UuidValue customerId;

  String customerName;

  _isc.UuidValue customerSiteId;

  String customerSiteName;

  String ownershipType;

  DateTime startedAt;

  DateTime? endedAt;

  String startReason;

  String? endReason;

  String? sourceDocumentType;

  String? sourceDocumentNumber;

  String? notes;

  /// Returns a shallow copy of this [AssetAssignment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AssetAssignment copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? customerId,
    String? customerName,
    _isc.UuidValue? customerSiteId,
    String? customerSiteName,
    String? ownershipType,
    DateTime? startedAt,
    DateTime? endedAt = const _isc.$UndefinedDateTime(),
    String? startReason,
    String? endReason,
    String? sourceDocumentType,
    String? sourceDocumentNumber,
    String? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AssetAssignment',
      'id': id.toJson(),
      'customerId': customerId.toJson(),
      'customerName': customerName,
      'customerSiteId': customerSiteId.toJson(),
      'customerSiteName': customerSiteName,
      'ownershipType': ownershipType,
      'startedAt': startedAt.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'startReason': startReason,
      if (endReason != null) 'endReason': endReason,
      if (sourceDocumentType != null) 'sourceDocumentType': sourceDocumentType,
      if (sourceDocumentNumber != null) 'sourceDocumentNumber': sourceDocumentNumber,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AssetAssignment',
      'id': id.toJson(),
      'customerId': customerId.toJson(),
      'customerName': customerName,
      'customerSiteId': customerSiteId.toJson(),
      'customerSiteName': customerSiteName,
      'ownershipType': ownershipType,
      'startedAt': startedAt.toJson(),
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      'startReason': startReason,
      if (endReason != null) 'endReason': endReason,
      if (sourceDocumentType != null) 'sourceDocumentType': sourceDocumentType,
      if (sourceDocumentNumber != null) 'sourceDocumentNumber': sourceDocumentNumber,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AssetAssignmentImpl extends AssetAssignment {
  _AssetAssignmentImpl({
    required _isc.UuidValue id,
    required _isc.UuidValue customerId,
    required String customerName,
    required _isc.UuidValue customerSiteId,
    required String customerSiteName,
    required String ownershipType,
    required DateTime startedAt,
    DateTime? endedAt,
    required String startReason,
    String? endReason,
    String? sourceDocumentType,
    String? sourceDocumentNumber,
    String? notes,
  }) : super._(
         id: id,
         customerId: customerId,
         customerName: customerName,
         customerSiteId: customerSiteId,
         customerSiteName: customerSiteName,
         ownershipType: ownershipType,
         startedAt: startedAt,
         endedAt: endedAt,
         startReason: startReason,
         endReason: endReason,
         sourceDocumentType: sourceDocumentType,
         sourceDocumentNumber: sourceDocumentNumber,
         notes: notes,
       );

  /// Returns a shallow copy of this [AssetAssignment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AssetAssignment copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? customerId,
    String? customerName,
    _isc.UuidValue? customerSiteId,
    String? customerSiteName,
    String? ownershipType,
    DateTime? startedAt,
    DateTime? endedAt = const _isc.$UndefinedDateTime(),
    String? startReason,
    Object? endReason = _Undefined,
    Object? sourceDocumentType = _Undefined,
    Object? sourceDocumentNumber = _Undefined,
    Object? notes = _Undefined,
  }) {
    return AssetAssignment(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerSiteId: customerSiteId ?? this.customerSiteId,
      customerSiteName: customerSiteName ?? this.customerSiteName,
      ownershipType: ownershipType ?? this.ownershipType,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt is _isc.UndefinedSentinel ? this.endedAt : endedAt,
      startReason: startReason ?? this.startReason,
      endReason: endReason is String? ? endReason : this.endReason,
      sourceDocumentType: sourceDocumentType is String? ? sourceDocumentType : this.sourceDocumentType,
      sourceDocumentNumber: sourceDocumentNumber is String? ? sourceDocumentNumber : this.sourceDocumentNumber,
      notes: notes is String? ? notes : this.notes,
    );
  }
}
