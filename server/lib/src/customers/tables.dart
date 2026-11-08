import '../platform/ownership.dart';

const customersOwnership = ModuleOwnership(
  module: 'customers',
  owns: {'customers', 'customer_sites', 'customer_contacts', 'sales_reps', 'customer_sales_summaries'},
);
