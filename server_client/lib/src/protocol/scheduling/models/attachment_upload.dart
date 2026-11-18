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

abstract class AttachmentUpload implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AttachmentUpload._({
    required this.attachmentId,
    required this.url,
    required this.contentType,
    required this.expiresAt,
  });

  factory AttachmentUpload({
    required _isc.UuidValue attachmentId,
    required String url,
    required String contentType,
    required DateTime expiresAt,
  }) = _AttachmentUploadImpl;

  factory AttachmentUpload.fromJson(Map<String, dynamic> jsonSerialization) {
    return AttachmentUpload(
      attachmentId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['attachmentId']),
      url: jsonSerialization['url'] as String,
      contentType: jsonSerialization['contentType'] as String,
      expiresAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
    );
  }

  _isc.UuidValue attachmentId;

  String url;

  String contentType;

  DateTime expiresAt;

  /// Returns a shallow copy of this [AttachmentUpload]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AttachmentUpload copyWith({
    _isc.UuidValue? attachmentId,
    String? url,
    String? contentType,
    DateTime? expiresAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AttachmentUpload',
      'attachmentId': attachmentId.toJson(),
      'url': url,
      'contentType': contentType,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AttachmentUpload',
      'attachmentId': attachmentId.toJson(),
      'url': url,
      'contentType': contentType,
      'expiresAt': expiresAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _AttachmentUploadImpl extends AttachmentUpload {
  _AttachmentUploadImpl({
    required _isc.UuidValue attachmentId,
    required String url,
    required String contentType,
    required DateTime expiresAt,
  }) : super._(
         attachmentId: attachmentId,
         url: url,
         contentType: contentType,
         expiresAt: expiresAt,
       );

  /// Returns a shallow copy of this [AttachmentUpload]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AttachmentUpload copyWith({
    _isc.UuidValue? attachmentId,
    String? url,
    String? contentType,
    DateTime? expiresAt,
  }) {
    return AttachmentUpload(
      attachmentId: attachmentId ?? this.attachmentId,
      url: url ?? this.url,
      contentType: contentType ?? this.contentType,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }
}
