/// Interface pública do módulo `catalog` (camada 3, docs/02 §3.2).
library;

export '../generated/protocol.dart' show ProductInput, ProductSummary;
export 'internal/products.dart' show Products;
export 'tables.dart' show catalogOwnership;
