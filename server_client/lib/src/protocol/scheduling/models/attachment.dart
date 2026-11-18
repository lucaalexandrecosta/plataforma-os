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

abstract class Attachment implements _isc.SerializableModel, _isc.ProtocolSerialization {
  Attachment._({
    required this.id,
    this.workOrderId,
    this.visitId,
    required this.kind,
    this.photoStage,
    required this.contentType,
    this.sizeBytes,
    required this.uploadStatus,
    this.caption,
    this.capturedAt,
    this.capturedByName,
    this.latitude,
    this.longitude,
    required this.createdAt,
  });

  factory Attachment({
    required _isc.UuidValue id,
    _isc.UuidValue? workOrderId,
    _isc.UuidValue? visitId,
    required String kind,
    String? photoStage,
    required String contentType,
    int? sizeBytes,
    required String uploadStatus,
    String? caption,
    DateTime? capturedAt,
    String? capturedByName,
    double? latitude,
    double? longitude,
    required DateTime createdAt,
  }) = _AttachmentImpl;

  factory Attachment.fromJson(Map<String, dynamic> jsonSerialization) {
    return Attachment(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      workOrderId: jsonSerialization['workOrderId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['workOrderId']),
      visitId: jsonSerialization['visitId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['visitId']),
      kind: jsonSerialization['kind'] as String,
      photoStage: jsonSerialization['photoStage'] as String?,
      contentType: jsonSerialization['contentType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int?,
      uploadStatus: jsonSerialization['uploadStatus'] as String,
      caption: jsonSerialization['caption'] as String?,
      capturedAt: jsonSerialization['capturedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['capturedAt']),
      capturedByName: jsonSerialization['capturedByName'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      createdAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  _isc.UuidValue id;

  _isc.UuidValue? workOrderId;

  _isc.UuidValue? visitId;

  String kind;

  String? photoStage;

  String contentType;

  int? sizeBytes;

  String uploadStatus;

  String? caption;

  DateTime? capturedAt;

  String? capturedByName;

  double? latitude;

  double? longitude;

  DateTime createdAt;

  /// Returns a shallow copy of this [Attachment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Attachment copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workOrderId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? visitId = const _isc.$UndefinedUuidValue(),
    String? kind,
    String? photoStage,
    String? contentType,
    int? sizeBytes,
    String? uploadStatus,
    String? caption,
    DateTime? capturedAt = const _isc.$UndefinedDateTime(),
    String? capturedByName,
    double? latitude,
    double? longitude,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Attachment',
      'id': id.toJson(),
      if (workOrderId != null) 'workOrderId': workOrderId?.toJson(),
      if (visitId != null) 'visitId': visitId?.toJson(),
      'kind': kind,
      if (photoStage != null) 'photoStage': photoStage,
      'contentType': contentType,
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      'uploadStatus': uploadStatus,
      if (caption != null) 'caption': caption,
      if (capturedAt != null) 'capturedAt': capturedAt?.toJson(),
      if (capturedByName != null) 'capturedByName': capturedByName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Attachment',
      'id': id.toJson(),
      if (workOrderId != null) 'workOrderId': workOrderId?.toJson(),
      if (visitId != null) 'visitId': visitId?.toJson(),
      'kind': kind,
      if (photoStage != null) 'photoStage': photoStage,
      'contentType': contentType,
      if (sizeBytes != null) 'sizeBytes': sizeBytes,
      'uploadStatus': uploadStatus,
      if (caption != null) 'caption': caption,
      if (capturedAt != null) 'capturedAt': capturedAt?.toJson(),
      if (capturedByName != null) 'capturedByName': capturedByName,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttachmentImpl extends Attachment {
  _AttachmentImpl({
    required _isc.UuidValue id,
    _isc.UuidValue? workOrderId,
    _isc.UuidValue? visitId,
    required String kind,
    String? photoStage,
    required String contentType,
    int? sizeBytes,
    required String uploadStatus,
    String? caption,
    DateTime? capturedAt,
    String? capturedByName,
    double? latitude,
    double? longitude,
    required DateTime createdAt,
  }) : super._(
         id: id,
         workOrderId: workOrderId,
         visitId: visitId,
         kind: kind,
         photoStage: photoStage,
         contentType: contentType,
         sizeBytes: sizeBytes,
         uploadStatus: uploadStatus,
         caption: caption,
         capturedAt: capturedAt,
         capturedByName: capturedByName,
         latitude: latitude,
         longitude: longitude,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Attachment]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  Attachment copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? workOrderId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? visitId = const _isc.$UndefinedUuidValue(),
    String? kind,
    Object? photoStage = _Undefined,
    String? contentType,
    Object? sizeBytes = _Undefined,
    String? uploadStatus,
    Object? caption = _Undefined,
    DateTime? capturedAt = const _isc.$UndefinedDateTime(),
    Object? capturedByName = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    DateTime? createdAt,
  }) {
    return Attachment(
      id: id ?? this.id,
      workOrderId: workOrderId is _isc.UndefinedSentinel ? this.workOrderId : workOrderId,
      visitId: visitId is _isc.UndefinedSentinel ? this.visitId : visitId,
      kind: kind ?? this.kind,
      photoStage: photoStage is String? ? photoStage : this.photoStage,
      contentType: contentType ?? this.contentType,
      sizeBytes: sizeBytes is int? ? sizeBytes : this.sizeBytes,
      uploadStatus: uploadStatus ?? this.uploadStatus,
      caption: caption is String? ? caption : this.caption,
      capturedAt: capturedAt is _isc.UndefinedSentinel ? this.capturedAt : capturedAt,
      capturedByName: capturedByName is String? ? capturedByName : this.capturedByName,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
