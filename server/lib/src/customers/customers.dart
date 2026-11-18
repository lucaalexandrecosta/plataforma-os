/// Interface pública do módulo `customers` (camada 3, docs/02 §3.2).
library;

export '../generated/protocol.dart'
    show
        Customer,
        CustomerContact,
        CustomerContactInput,
        CustomerImportError,
        CustomerImportReport,
        CustomerImportRow,
        CustomerInput,
        CustomerPage,
        CustomerSite,
        CustomerSiteInput;
export 'internal/customer_contacts.dart' show CustomerContacts;
export 'internal/customer_import.dart' show CustomerImport;
export 'internal/customers.dart' show Customers;
export 'tables.dart' show customersOwnership;
