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

abstract class SignatureCapturePayload implements _is.SerializableModel, _is.ProtocolSerialization {
  SignatureCapturePayload._({
    required this.attachmentId,
    required this.signerName,
    this.signerDocument,
    required this.signerRole,
    required this.signedAt,
  });

  factory SignatureCapturePayload({
    required _is.UuidValue attachmentId,
    required String signerName,
    String? signerDocument,
    required String signerRole,
    required DateTime signedAt,
  }) = _SignatureCapturePayloadImpl;

  factory SignatureCapturePayload.fromJson(Map<String, dynamic> jsonSerialization) {
    return SignatureCapturePayload(
      attachmentId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['attachmentId']),
      signerName: jsonSerialization['signerName'] as String,
      signerDocument: jsonSerialization['signerDocument'] as String?,
      signerRole: jsonSerialization['signerRole'] as String,
      signedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['signedAt']),
    );
  }

  _is.UuidValue attachmentId;

  String signerName;

  String? signerDocument;

  String signerRole;

  DateTime signedAt;

  /// Returns a shallow copy of this [SignatureCapturePayload]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SignatureCapturePayload copyWith({
    _is.UuidValue? attachmentId,
    String? signerName,
    String? signerDocument,
    String? signerRole,
    DateTime? signedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SignatureCapturePayload',
      'attachmentId': attachmentId.toJson(),
      'signerName': signerName,
      if (signerDocument != null) 'signerDocument': signerDocument,
      'signerRole': signerRole,
      'signedAt': signedAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SignatureCapturePayload',
      'attachmentId': attachmentId.toJson(),
      'signerName': signerName,
      if (signerDocument != null) 'signerDocument': signerDocument,
      'signerRole': signerRole,
      'signedAt': signedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SignatureCapturePayloadImpl extends SignatureCapturePayload {
  _SignatureCapturePayloadImpl({
    required _is.UuidValue attachmentId,
    required String signerName,
    String? signerDocument,
    required String signerRole,
    required DateTime signedAt,
  }) : super._(
         attachmentId: attachmentId,
         signerName: signerName,
         signerDocument: signerDocument,
         signerRole: signerRole,
         signedAt: signedAt,
       );

  /// Returns a shallow copy of this [SignatureCapturePayload]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  SignatureCapturePayload copyWith({
    _is.UuidValue? attachmentId,
    String? signerName,
    Object? signerDocument = _Undefined,
    String? signerRole,
    DateTime? signedAt,
  }) {
    return SignatureCapturePayload(
      attachmentId: attachmentId ?? this.attachmentId,
      signerName: signerName ?? this.signerName,
      signerDocument: signerDocument is String? ? signerDocument : this.signerDocument,
      signerRole: signerRole ?? this.signerRole,
      signedAt: signedAt ?? this.signedAt,
    );
  }
}
