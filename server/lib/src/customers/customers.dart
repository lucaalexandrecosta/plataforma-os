/// Interface pública do módulo `customers` (camada 3, docs/02 §3.2).
library;

export '../generated/protocol.dart' show Customer, CustomerInput, CustomerPage, CustomerSite, CustomerSiteInput;
export 'internal/customers.dart' show Customers;
export 'tables.dart' show customersOwnership;
