/// Interface pública do módulo `sync` (sincronização do app do técnico,
/// docs/06 §6). No desenho completo fica com o `field_execution` (camada 7).
library;

export 'internal/technician_sync.dart' show TechnicianSync;
export 'tables.dart' show syncOwnership;
