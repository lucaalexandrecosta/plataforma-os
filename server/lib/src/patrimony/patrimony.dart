/// Interface pública do módulo `patrimony` (camada 5, ao lado de
/// `work_orders`, sem depender dele): ficha patrimonial e depreciação
/// gerencial com o motor de `packages/depreciation`.
library;

export '../generated/protocol.dart'
    show
        AssetDepreciation,
        DepreciationClosing,
        DepreciationGroupTotal,
        DepreciationLine,
        DepreciationPosition,
        DepreciationPositionItem,
        DepreciationProfile,
        DepreciationProfileInput;
export 'internal/depreciation.dart' show Depreciation;
export 'tables.dart' show patrimonyOwnership;
