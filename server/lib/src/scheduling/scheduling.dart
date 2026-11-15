/// Interface pública do módulo `scheduling` (camada 6, docs/02 §3.2). No MVP
/// também guarda a execução da visita pelo técnico (que no desenho completo é
/// do `field_execution`, camada 7, junto com o sync offline).
library;

export '../generated/protocol.dart' show Technician, TechnicianInput, Visit, VisitCheckIn, VisitFinish, VisitInput;
export 'internal/technicians.dart' show Technicians;
export 'internal/visits.dart' show Visits;
export 'tables.dart' show schedulingOwnership;
