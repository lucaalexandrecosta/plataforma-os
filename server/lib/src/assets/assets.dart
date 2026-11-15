/// Interface pública do módulo `assets` (camada 4, docs/02 §3.2).
library;

export '../generated/protocol.dart' show Asset, AssetInput, AssetPage, QrTag, QrTagBatch;
export 'internal/asset_registry.dart' show AssetForWorkOrder, AssetRegistry;
export 'internal/qr_tags.dart' show QrTags;
export 'tables.dart' show assetsOwnership;
