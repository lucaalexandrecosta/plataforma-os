/// Interface pública do módulo `tenancy` (camada 1, docs/02 §3.2).
library;

export '../generated/protocol.dart' show Tenant, TenantStatus, TenantSummary;
export 'internal/branches.dart' show Branches;
export 'internal/cost_centers.dart' show CostCenters;
export 'internal/tenant_directory.dart' show TenantDirectory;
export 'tables.dart' show tenancyOwnership;
