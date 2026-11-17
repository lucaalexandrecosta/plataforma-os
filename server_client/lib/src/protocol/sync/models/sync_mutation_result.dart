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
import 'package:plataforma_os_client/src/protocol/protocol.dart' as _inlzmlpe;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../scheduling/models/visit.dart' as _in1xgb8o;

abstract class SyncMutationResult implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SyncMutationResult._({
    required this.mutationId,
    required this.status,
    this.errorCode,
    this.errorMessage,
    this.visit,
  });

  factory SyncMutationResult({
    required _isc.UuidValue mutationId,
    required String status,
    String? errorCode,
    String? errorMessage,
    _in1xgb8o.Visit? visit,
  }) = _SyncMutationResultImpl;

  factory SyncMutationResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SyncMutationResult(
      mutationId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['mutationId']),
      status: jsonSerialization['status'] as String,
      errorCode: jsonSerialization['errorCode'] as String?,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      visit: jsonSerialization['visit'] == null
          ? null
          : _inlzmlpe.Protocol().deserialize<_in1xgb8o.Visit>(jsonSerialization['visit']),
    );
  }

  _isc.UuidValue mutationId;

  String status;

  String? errorCode;

  String? errorMessage;

  _in1xgb8o.Visit? visit;

  /// Returns a shallow copy of this [SyncMutationResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SyncMutationResult copyWith({
    _isc.UuidValue? mutationId,
    String? status,
    String? errorCode,
    String? errorMessage,
    _in1xgb8o.Visit? visit = const _UndefinedSyncMutationResult$visit(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SyncMutationResult',
      'mutationId': mutationId.toJson(),
      'status': status,
      if (errorCode != null) 'errorCode': errorCode,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (visit != null) 'visit': visit?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SyncMutationResult',
      'mutationId': mutationId.toJson(),
      'status': status,
      if (errorCode != null) 'errorCode': errorCode,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (visit != null) 'visit': visit?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _UndefinedSyncMutationResult$visit extends _isc.UndefinedSentinel implements _in1xgb8o.Visit {
  const _UndefinedSyncMutationResult$visit();
}

class _SyncMutationResultImpl extends SyncMutationResult {
  _SyncMutationResultImpl({
    required _isc.UuidValue mutationId,
    required String status,
    String? errorCode,
    String? errorMessage,
    _in1xgb8o.Visit? visit,
  }) : super._(
         mutationId: mutationId,
         status: status,
         errorCode: errorCode,
         errorMessage: errorMessage,
         visit: visit,
       );

  /// Returns a shallow copy of this [SyncMutationResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SyncMutationResult copyWith({
    _isc.UuidValue? mutationId,
    String? status,
    Object? errorCode = _Undefined,
    Object? errorMessage = _Undefined,
    _in1xgb8o.Visit? visit = const _UndefinedSyncMutationResult$visit(),
  }) {
    return SyncMutationResult(
      mutationId: mutationId ?? this.mutationId,
      status: status ?? this.status,
      errorCode: errorCode is String? ? errorCode : this.errorCode,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      visit: visit is _isc.UndefinedSentinel ? this.visit?.copyWith() : visit,
    );
  }
}
