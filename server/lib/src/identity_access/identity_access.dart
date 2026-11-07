/// Interface pública do módulo `identity_access` (camada 2, docs/02 §3.2).
library;

export '../generated/protocol.dart' show MeInfo, TenantToken;
export 'internal/application/memberships.dart' show Memberships;
export 'tables.dart' show identityAccessOwnership;
