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

abstract class SyncMutation implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SyncMutation._({
    required this.mutationId,
    required this.type,
    required this.entityId,
    required this.clientTimestamp,
    required this.payload,
  });

  factory SyncMutation({
    required _isc.UuidValue mutationId,
    required String type,
    required _isc.UuidValue entityId,
    required DateTime clientTimestamp,
    required String payload,
  }) = _SyncMutationImpl;

  factory SyncMutation.fromJson(Map<String, dynamic> jsonSerialization) {
    return SyncMutation(
      mutationId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['mutationId']),
      type: jsonSerialization['type'] as String,
      entityId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['entityId']),
      clientTimestamp: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['clientTimestamp']),
      payload: jsonSerialization['payload'] as String,
    );
  }

  _isc.UuidValue mutationId;

  String type;

  _isc.UuidValue entityId;

  DateTime clientTimestamp;

  String payload;

  /// Returns a shallow copy of this [SyncMutation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SyncMutation copyWith({
    _isc.UuidValue? mutationId,
    String? type,
    _isc.UuidValue? entityId,
    DateTime? clientTimestamp,
    String? payload,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SyncMutation',
      'mutationId': mutationId.toJson(),
      'type': type,
      'entityId': entityId.toJson(),
      'clientTimestamp': clientTimestamp.toJson(),
      'payload': payload,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SyncMutation',
      'mutationId': mutationId.toJson(),
      'type': type,
      'entityId': entityId.toJson(),
      'clientTimestamp': clientTimestamp.toJson(),
      'payload': payload,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SyncMutationImpl extends SyncMutation {
  _SyncMutationImpl({
    required _isc.UuidValue mutationId,
    required String type,
    required _isc.UuidValue entityId,
    required DateTime clientTimestamp,
    required String payload,
  }) : super._(
         mutationId: mutationId,
         type: type,
         entityId: entityId,
         clientTimestamp: clientTimestamp,
         payload: payload,
       );

  /// Returns a shallow copy of this [SyncMutation]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SyncMutation copyWith({
    _isc.UuidValue? mutationId,
    String? type,
    _isc.UuidValue? entityId,
    DateTime? clientTimestamp,
    String? payload,
  }) {
    return SyncMutation(
      mutationId: mutationId ?? this.mutationId,
      type: type ?? this.type,
      entityId: entityId ?? this.entityId,
      clientTimestamp: clientTimestamp ?? this.clientTimestamp,
      payload: payload ?? this.payload,
    );
  }
}
