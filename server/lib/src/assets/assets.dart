/// Interface pública do módulo `assets` (camada 4, docs/02 §3.2).
library;

export '../generated/protocol.dart' show Asset, AssetInput, AssetPage;
export 'internal/asset_registry.dart' show AssetRegistry;
export 'tables.dart' show assetsOwnership;
