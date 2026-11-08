/// Interface pública do módulo `catalog` (camada 2, docs/02 §3.2).
library;

export '../generated/protocol.dart' show CatalogService, Product, ProductFamily, ProductKind, ServiceKind;
export 'internal/catalog_imports.dart' show ProductsImport, ServicesImport;
export 'tables.dart' show catalogOwnership;
