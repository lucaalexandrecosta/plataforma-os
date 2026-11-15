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

abstract class QrTag implements _isc.SerializableModel, _isc.ProtocolSerialization {
  QrTag._({
    required this.id,
    required this.shortCode,
    required this.url,
    required this.status,
    this.batchId,
    this.assetId,
    this.assetLabel,
    required this.printCount,
    this.revokedReason,
  });

  factory QrTag({
    required _isc.UuidValue id,
    required String shortCode,
    required String url,
    required String status,
    _isc.UuidValue? batchId,
    _isc.UuidValue? assetId,
    String? assetLabel,
    required int printCount,
    String? revokedReason,
  }) = _QrTagImpl;

  factory QrTag.fromJson(Map<String, dynamic> jsonSerialization) {
    return QrTag(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      shortCode: jsonSerialization['shortCode'] as String,
      url: jsonSerialization['url'] as String,
      status: jsonSerialization['status'] as String,
      batchId: jsonSerialization['batchId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['batchId']),
      assetId: jsonSerialization['assetId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['assetId']),
      assetLabel: jsonSerialization['assetLabel'] as String?,
      printCount: jsonSerialization['printCount'] as int,
      revokedReason: jsonSerialization['revokedReason'] as String?,
    );
  }

  _isc.UuidValue id;

  String shortCode;

  String url;

  String status;

  _isc.UuidValue? batchId;

  _isc.UuidValue? assetId;

  String? assetLabel;

  int printCount;

  String? revokedReason;

  /// Returns a shallow copy of this [QrTag]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QrTag copyWith({
    _isc.UuidValue? id,
    String? shortCode,
    String? url,
    String? status,
    _isc.UuidValue? batchId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? assetId = const _isc.$UndefinedUuidValue(),
    String? assetLabel,
    int? printCount,
    String? revokedReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QrTag',
      'id': id.toJson(),
      'shortCode': shortCode,
      'url': url,
      'status': status,
      if (batchId != null) 'batchId': batchId?.toJson(),
      if (assetId != null) 'assetId': assetId?.toJson(),
      if (assetLabel != null) 'assetLabel': assetLabel,
      'printCount': printCount,
      if (revokedReason != null) 'revokedReason': revokedReason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QrTag',
      'id': id.toJson(),
      'shortCode': shortCode,
      'url': url,
      'status': status,
      if (batchId != null) 'batchId': batchId?.toJson(),
      if (assetId != null) 'assetId': assetId?.toJson(),
      if (assetLabel != null) 'assetLabel': assetLabel,
      'printCount': printCount,
      if (revokedReason != null) 'revokedReason': revokedReason,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QrTagImpl extends QrTag {
  _QrTagImpl({
    required _isc.UuidValue id,
    required String shortCode,
    required String url,
    required String status,
    _isc.UuidValue? batchId,
    _isc.UuidValue? assetId,
    String? assetLabel,
    required int printCount,
    String? revokedReason,
  }) : super._(
         id: id,
         shortCode: shortCode,
         url: url,
         status: status,
         batchId: batchId,
         assetId: assetId,
         assetLabel: assetLabel,
         printCount: printCount,
         revokedReason: revokedReason,
       );

  /// Returns a shallow copy of this [QrTag]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QrTag copyWith({
    _isc.UuidValue? id,
    String? shortCode,
    String? url,
    String? status,
    _isc.UuidValue? batchId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? assetId = const _isc.$UndefinedUuidValue(),
    Object? assetLabel = _Undefined,
    int? printCount,
    Object? revokedReason = _Undefined,
  }) {
    return QrTag(
      id: id ?? this.id,
      shortCode: shortCode ?? this.shortCode,
      url: url ?? this.url,
      status: status ?? this.status,
      batchId: batchId is _isc.UndefinedSentinel ? this.batchId : batchId,
      assetId: assetId is _isc.UndefinedSentinel ? this.assetId : assetId,
      assetLabel: assetLabel is String? ? assetLabel : this.assetLabel,
      printCount: printCount ?? this.printCount,
      revokedReason: revokedReason is String? ? revokedReason : this.revokedReason,
    );
  }
}
