/// Motor de depreciação da plataforma-os.
///
/// Dart puro (sem Flutter, Serverpod nem `dart:io`): o backoffice usa para
/// recalcular na tela e o servidor usa para fechar a competência, com o mesmo
/// resultado. Portado do Painel de Depreciação e conferido com a memória F670
/// do ERP Senior.
library;

export 'src/engine.dart'
    show
        CalendarDate,
        DepreciableAsset,
        DepreciationMonth,
        DepreciationSchedule,
        ManagerialMethod,
        Period,
        StartRule,
        calculateDepreciation,
        roundTo;
export 'src/f670.dart' show F670Record, parseBrDate, parsePtBrDecimal;
