/// Interface pública do módulo `customers` (camada 2, docs/02 §3.2).
library;

export '../generated/protocol.dart' show Customer, CustomerKind, DocumentType, PersonType;
export 'internal/customer_imports.dart' show CustomerContactsImport, CustomerSitesImport, CustomersImport;
export 'tables.dart' show customersOwnership;
