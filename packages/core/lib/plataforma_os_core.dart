/// Regras compartilhadas da plataforma-os (docs/02 §6.1).
///
/// Dart puro: não importa `package:flutter`, `package:serverpod` nem `dart:io`,
/// porque roda no servidor, no app do técnico (inclusive offline), no app do
/// cliente e no backoffice (Flutter Web).
library;

export 'src/br_documents.dart' show BrDocuments;
export 'src/crockford.dart' show Crockford;
export 'src/gtin.dart' show Gtin;
export 'src/money.dart' show Money, Quantity;
export 'src/phones.dart' show Phones;
export 'src/qr_codes.dart' show QrCodes;
export 'src/uuid_v7.dart' show UuidV7;
export 'src/visit_status.dart' show VisitStatus, VisitOutcome;
export 'src/work_order_status.dart' show WorkOrderStatus, ResolutionMode;
