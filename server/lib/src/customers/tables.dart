import '../platform/ownership.dart';

const customersOwnership = ModuleOwnership(
  module: 'customers',
  owns: {'customers', 'customer_sites', 'customer_contacts'},
);
