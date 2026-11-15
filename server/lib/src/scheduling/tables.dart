import '../platform/ownership.dart';

const schedulingOwnership = ModuleOwnership(
  module: 'scheduling',
  owns: {'technicians', 'work_order_visits'},
);
