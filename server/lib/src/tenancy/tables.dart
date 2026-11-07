import '../platform/ownership.dart';

const tenancyOwnership = ModuleOwnership(
  module: 'tenancy',
  owns: {'plans', 'tenants', 'tenant_settings', 'tenant_sequences', 'branches'},
);
