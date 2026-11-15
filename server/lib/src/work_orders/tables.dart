import '../platform/ownership.dart';

const workOrdersOwnership = ModuleOwnership(
  module: 'work_orders',
  owns: {'work_orders', 'work_order_types', 'work_order_status_history'},
);
