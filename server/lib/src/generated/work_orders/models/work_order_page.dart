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
import 'package:plataforma_os_server/src/generated/protocol.dart' as _isma42go;
import 'package:serverpod/serverpod.dart' as _is;
import '../../work_orders/models/work_order.dart' as _iolupbz8;

abstract class WorkOrderPage implements _is.SerializableModel, _is.ProtocolSerialization {
  WorkOrderPage._({
    required this.items,
    required this.total,
  });

  factory WorkOrderPage({
    required List<_iolupbz8.WorkOrder> items,
    required int total,
  }) = _WorkOrderPageImpl;

  factory WorkOrderPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkOrderPage(
      items: _isma42go.Protocol().deserialize<List<_iolupbz8.WorkOrder>>(jsonSerialization['items']),
      total: jsonSerialization['total'] as int,
    );
  }

  List<_iolupbz8.WorkOrder> items;

  int total;

  /// Returns a shallow copy of this [WorkOrderPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WorkOrderPage copyWith({
    List<_iolupbz8.WorkOrder>? items,
    int? total,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkOrderPage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'total': total,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkOrderPage',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'total': total,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _WorkOrderPageImpl extends WorkOrderPage {
  _WorkOrderPageImpl({
    required List<_iolupbz8.WorkOrder> items,
    required int total,
  }) : super._(
         items: items,
         total: total,
       );

  /// Returns a shallow copy of this [WorkOrderPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WorkOrderPage copyWith({
    List<_iolupbz8.WorkOrder>? items,
    int? total,
  }) {
    return WorkOrderPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total,
    );
  }
}
