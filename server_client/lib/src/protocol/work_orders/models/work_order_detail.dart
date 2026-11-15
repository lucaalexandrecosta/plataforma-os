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
import '../../work_orders/models/work_order.dart' as _iolupbz8;
import '../../work_orders/models/work_order_status_change.dart' as _isjrcrf9;

abstract class WorkOrderDetail implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WorkOrderDetail._({
    required this.workOrder,
    required this.history,
    required this.otherOpenOnAsset,
  });

  factory WorkOrderDetail({
    required _iolupbz8.WorkOrder workOrder,
    required List<_isjrcrf9.WorkOrderStatusChange> history,
    required List<_iolupbz8.WorkOrder> otherOpenOnAsset,
  }) = _WorkOrderDetailImpl;

  factory WorkOrderDetail.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkOrderDetail(
      workOrder: _inlzmlpe.Protocol().deserialize<_iolupbz8.WorkOrder>(jsonSerialization['workOrder']),
      history: _inlzmlpe.Protocol().deserialize<List<_isjrcrf9.WorkOrderStatusChange>>(jsonSerialization['history']),
      otherOpenOnAsset: _inlzmlpe.Protocol().deserialize<List<_iolupbz8.WorkOrder>>(
        jsonSerialization['otherOpenOnAsset'],
      ),
    );
  }

  _iolupbz8.WorkOrder workOrder;

  List<_isjrcrf9.WorkOrderStatusChange> history;

  List<_iolupbz8.WorkOrder> otherOpenOnAsset;

  /// Returns a shallow copy of this [WorkOrderDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WorkOrderDetail copyWith({
    _iolupbz8.WorkOrder? workOrder,
    List<_isjrcrf9.WorkOrderStatusChange>? history,
    List<_iolupbz8.WorkOrder>? otherOpenOnAsset,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkOrderDetail',
      'workOrder': workOrder.toJson(),
      'history': history.toJson(valueToJson: (v) => v.toJson()),
      'otherOpenOnAsset': otherOpenOnAsset.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkOrderDetail',
      'workOrder': workOrder.toJsonForProtocol(),
      'history': history.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'otherOpenOnAsset': otherOpenOnAsset.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _WorkOrderDetailImpl extends WorkOrderDetail {
  _WorkOrderDetailImpl({
    required _iolupbz8.WorkOrder workOrder,
    required List<_isjrcrf9.WorkOrderStatusChange> history,
    required List<_iolupbz8.WorkOrder> otherOpenOnAsset,
  }) : super._(
         workOrder: workOrder,
         history: history,
         otherOpenOnAsset: otherOpenOnAsset,
       );

  /// Returns a shallow copy of this [WorkOrderDetail]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WorkOrderDetail copyWith({
    _iolupbz8.WorkOrder? workOrder,
    List<_isjrcrf9.WorkOrderStatusChange>? history,
    List<_iolupbz8.WorkOrder>? otherOpenOnAsset,
  }) {
    return WorkOrderDetail(
      workOrder: workOrder ?? this.workOrder.copyWith(),
      history: history ?? this.history.map((e0) => e0.copyWith()).toList(),
      otherOpenOnAsset: otherOpenOnAsset ?? this.otherOpenOnAsset.map((e0) => e0.copyWith()).toList(),
    );
  }
}
