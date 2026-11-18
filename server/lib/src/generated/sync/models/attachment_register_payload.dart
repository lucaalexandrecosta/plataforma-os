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

abstract class AttachmentRegisterPayload implements _is.SerializableModel, _is.ProtocolSerialization {
  AttachmentRegisterPayload._({
    required this.attachmentId,
    required this.kind,
    this.photoStage,
    required this.contentType,
    required this.sizeBytes,
    required this.sha256,
    required this.capturedAt,
    this.latitude,
    this.longitude,
    this.caption,
  });

  factory AttachmentRegisterPayload({
    required _is.UuidValue attachmentId,
    required String kind,
    String? photoStage,
    required String contentType,
    required int sizeBytes,
    required String sha256,
    required DateTime capturedAt,
    double? latitude,
    double? longitude,
    String? caption,
  }) = _AttachmentRegisterPayloadImpl;

  factory AttachmentRegisterPayload.fromJson(Map<String, dynamic> jsonSerialization) {
    return AttachmentRegisterPayload(
      attachmentId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['attachmentId']),
      kind: jsonSerialization['kind'] as String,
      photoStage: jsonSerialization['photoStage'] as String?,
      contentType: jsonSerialization['contentType'] as String,
      sizeBytes: jsonSerialization['sizeBytes'] as int,
      sha256: jsonSerialization['sha256'] as String,
      capturedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['capturedAt']),
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      caption: jsonSerialization['caption'] as String?,
    );
  }

  _is.UuidValue attachmentId;

  String kind;

  String? photoStage;

  String contentType;

  int sizeBytes;

  String sha256;

  DateTime capturedAt;

  double? latitude;

  double? longitude;

  String? caption;

  /// Returns a shallow copy of this [AttachmentRegisterPayload]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AttachmentRegisterPayload copyWith({
    _is.UuidValue? attachmentId,
    String? kind,
    String? photoStage,
    String? contentType,
    int? sizeBytes,
    String? sha256,
    DateTime? capturedAt,
    double? latitude,
    double? longitude,
    String? caption,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AttachmentRegisterPayload',
      'attachmentId': attachmentId.toJson(),
      'kind': kind,
      if (photoStage != null) 'photoStage': photoStage,
      'contentType': contentType,
      'sizeBytes': sizeBytes,
      'sha256': sha256,
      'capturedAt': capturedAt.toJson(),
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (caption != null) 'caption': caption,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AttachmentRegisterPayload',
      'attachmentId': attachmentId.toJson(),
      'kind': kind,
      if (photoStage != null) 'photoStage': photoStage,
      'contentType': contentType,
      'sizeBytes': sizeBytes,
      'sha256': sha256,
      'capturedAt': capturedAt.toJson(),
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (caption != null) 'caption': caption,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AttachmentRegisterPayloadImpl extends AttachmentRegisterPayload {
  _AttachmentRegisterPayloadImpl({
    required _is.UuidValue attachmentId,
    required String kind,
    String? photoStage,
    required String contentType,
    required int sizeBytes,
    required String sha256,
    required DateTime capturedAt,
    double? latitude,
    double? longitude,
    String? caption,
  }) : super._(
         attachmentId: attachmentId,
         kind: kind,
         photoStage: photoStage,
         contentType: contentType,
         sizeBytes: sizeBytes,
         sha256: sha256,
         capturedAt: capturedAt,
         latitude: latitude,
         longitude: longitude,
         caption: caption,
       );

  /// Returns a shallow copy of this [AttachmentRegisterPayload]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AttachmentRegisterPayload copyWith({
    _is.UuidValue? attachmentId,
    String? kind,
    Object? photoStage = _Undefined,
    String? contentType,
    int? sizeBytes,
    String? sha256,
    DateTime? capturedAt,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? caption = _Undefined,
  }) {
    return AttachmentRegisterPayload(
      attachmentId: attachmentId ?? this.attachmentId,
      kind: kind ?? this.kind,
      photoStage: photoStage is String? ? photoStage : this.photoStage,
      contentType: contentType ?? this.contentType,
      sizeBytes: sizeBytes ?? this.sizeBytes,
      sha256: sha256 ?? this.sha256,
      capturedAt: capturedAt ?? this.capturedAt,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      caption: caption is String? ? caption : this.caption,
    );
  }
}
