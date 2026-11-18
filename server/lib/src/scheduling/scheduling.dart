/// Interface pública do módulo `scheduling` (camada 6, docs/02 §3.2). No MVP
/// também guarda a execução da visita pelo técnico (que no desenho completo é
/// do `field_execution`, camada 7, junto com o sync offline).
library;

export '../generated/protocol.dart'
    show
        Attachment,
        AttachmentUpload,
        ChecklistAnswer,
        ChecklistResponse,
        Technician,
        TechnicianInput,
        Visit,
        VisitChecklist,
        VisitCheckIn,
        VisitFinish,
        VisitInput;
export 'internal/attachments.dart' show Attachments;
export 'internal/checklist_responses.dart' show ChecklistResponses;
export 'internal/technicians.dart' show Technicians;
export 'internal/visits.dart' show Visits;
export 'tables.dart' show schedulingOwnership;
