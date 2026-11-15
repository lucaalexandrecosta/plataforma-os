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

abstract class WorkOrderStatusChange implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WorkOrderStatusChange._({
    this.fromStatus,
    required this.toStatus,
    this.holdReason,
    this.reason,
    required this.changedAt,
    this.changedByName,
  });

  factory WorkOrderStatusChange({
    String? fromStatus,
    required String toStatus,
    String? holdReason,
    String? reason,
    required DateTime changedAt,
    String? changedByName,
  }) = _WorkOrderStatusChangeImpl;

  factory WorkOrderStatusChange.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkOrderStatusChange(
      fromStatus: jsonSerialization['fromStatus'] as String?,
      toStatus: jsonSerialization['toStatus'] as String,
      holdReason: jsonSerialization['holdReason'] as String?,
      reason: jsonSerialization['reason'] as String?,
      changedAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['changedAt']),
      changedByName: jsonSerialization['changedByName'] as String?,
    );
  }

  String? fromStatus;

  String toStatus;

  String? holdReason;

  String? reason;

  DateTime changedAt;

  String? changedByName;

  /// Returns a shallow copy of this [WorkOrderStatusChange]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WorkOrderStatusChange copyWith({
    String? fromStatus,
    String? toStatus,
    String? holdReason,
    String? reason,
    DateTime? changedAt,
    String? changedByName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkOrderStatusChange',
      if (fromStatus != null) 'fromStatus': fromStatus,
      'toStatus': toStatus,
      if (holdReason != null) 'holdReason': holdReason,
      if (reason != null) 'reason': reason,
      'changedAt': changedAt.toJson(),
      if (changedByName != null) 'changedByName': changedByName,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkOrderStatusChange',
      if (fromStatus != null) 'fromStatus': fromStatus,
      'toStatus': toStatus,
      if (holdReason != null) 'holdReason': holdReason,
      if (reason != null) 'reason': reason,
      'changedAt': changedAt.toJson(),
      if (changedByName != null) 'changedByName': changedByName,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkOrderStatusChangeImpl extends WorkOrderStatusChange {
  _WorkOrderStatusChangeImpl({
    String? fromStatus,
    required String toStatus,
    String? holdReason,
    String? reason,
    required DateTime changedAt,
    String? changedByName,
  }) : super._(
         fromStatus: fromStatus,
         toStatus: toStatus,
         holdReason: holdReason,
         reason: reason,
         changedAt: changedAt,
         changedByName: changedByName,
       );

  /// Returns a shallow copy of this [WorkOrderStatusChange]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WorkOrderStatusChange copyWith({
    Object? fromStatus = _Undefined,
    String? toStatus,
    Object? holdReason = _Undefined,
    Object? reason = _Undefined,
    DateTime? changedAt,
    Object? changedByName = _Undefined,
  }) {
    return WorkOrderStatusChange(
      fromStatus: fromStatus is String? ? fromStatus : this.fromStatus,
      toStatus: toStatus ?? this.toStatus,
      holdReason: holdReason is String? ? holdReason : this.holdReason,
      reason: reason is String? ? reason : this.reason,
      changedAt: changedAt ?? this.changedAt,
      changedByName: changedByName is String? ? changedByName : this.changedByName,
    );
  }
}
