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
import '../../scheduling/models/visit_checklist.dart' as _il8n53mf;
import '../../work_orders/models/work_order.dart' as _iolupbz8;

abstract class SyncPullResult implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SyncPullResult._({
    required this.serverTime,
    required this.scopeFrom,
    required this.scopeTo,
    required this.visits,
    required this.workOrders,
    required this.checklists,
  });

  factory SyncPullResult({
    required DateTime serverTime,
    required DateTime scopeFrom,
    required DateTime scopeTo,
    required List<_in1xgb8o.Visit> visits,
    required List<_iolupbz8.WorkOrder> workOrders,
    required List<_il8n53mf.VisitChecklist> checklists,
  }) = _SyncPullResultImpl;

  factory SyncPullResult.fromJson(Map<String, dynamic> jsonSerialization) {
    return SyncPullResult(
      serverTime: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['serverTime']),
      scopeFrom: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['scopeFrom']),
      scopeTo: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['scopeTo']),
      visits: _inlzmlpe.Protocol().deserialize<List<_in1xgb8o.Visit>>(jsonSerialization['visits']),
      workOrders: _inlzmlpe.Protocol().deserialize<List<_iolupbz8.WorkOrder>>(jsonSerialization['workOrders']),
      checklists: _inlzmlpe.Protocol().deserialize<List<_il8n53mf.VisitChecklist>>(jsonSerialization['checklists']),
    );
  }

  DateTime serverTime;

  DateTime scopeFrom;

  DateTime scopeTo;

  List<_in1xgb8o.Visit> visits;

  List<_iolupbz8.WorkOrder> workOrders;

  List<_il8n53mf.VisitChecklist> checklists;

  /// Returns a shallow copy of this [SyncPullResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SyncPullResult copyWith({
    DateTime? serverTime,
    DateTime? scopeFrom,
    DateTime? scopeTo,
    List<_in1xgb8o.Visit>? visits,
    List<_iolupbz8.WorkOrder>? workOrders,
    List<_il8n53mf.VisitChecklist>? checklists,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SyncPullResult',
      'serverTime': serverTime.toJson(),
      'scopeFrom': scopeFrom.toJson(),
      'scopeTo': scopeTo.toJson(),
      'visits': visits.toJson(valueToJson: (v) => v.toJson()),
      'workOrders': workOrders.toJson(valueToJson: (v) => v.toJson()),
      'checklists': checklists.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SyncPullResult',
      'serverTime': serverTime.toJson(),
      'scopeFrom': scopeFrom.toJson(),
      'scopeTo': scopeTo.toJson(),
      'visits': visits.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'workOrders': workOrders.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'checklists': checklists.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SyncPullResultImpl extends SyncPullResult {
  _SyncPullResultImpl({
    required DateTime serverTime,
    required DateTime scopeFrom,
    required DateTime scopeTo,
    required List<_in1xgb8o.Visit> visits,
    required List<_iolupbz8.WorkOrder> workOrders,
    required List<_il8n53mf.VisitChecklist> checklists,
  }) : super._(
         serverTime: serverTime,
         scopeFrom: scopeFrom,
         scopeTo: scopeTo,
         visits: visits,
         workOrders: workOrders,
         checklists: checklists,
       );

  /// Returns a shallow copy of this [SyncPullResult]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SyncPullResult copyWith({
    DateTime? serverTime,
    DateTime? scopeFrom,
    DateTime? scopeTo,
    List<_in1xgb8o.Visit>? visits,
    List<_iolupbz8.WorkOrder>? workOrders,
    List<_il8n53mf.VisitChecklist>? checklists,
  }) {
    return SyncPullResult(
      serverTime: serverTime ?? this.serverTime,
      scopeFrom: scopeFrom ?? this.scopeFrom,
      scopeTo: scopeTo ?? this.scopeTo,
      visits: visits ?? this.visits.map((e0) => e0.copyWith()).toList(),
      workOrders: workOrders ?? this.workOrders.map((e0) => e0.copyWith()).toList(),
      checklists: checklists ?? this.checklists.map((e0) => e0.copyWith()).toList(),
    );
  }
}
