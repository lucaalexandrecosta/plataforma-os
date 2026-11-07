/// Status da ordem de serviço (máquina de estados D9, docs/03 §6.1).
///
/// A tabela de transições é a mesma do trigger `app.tg_work_order_status_guard`
/// (segunda barreira no banco). As pré-condições de ator e de negócio ficam no
/// módulo `work_orders` do servidor; aqui está só o que app e servidor
/// precisam concordar. Os nomes dos valores são os do banco (snake_case).
enum WorkOrderStatus {
  requested('Solicitada'),
  open('Aberta'),
  scheduled('Agendada'),
  inProgress('Em atendimento'),
  onHold('Pendente'),
  completed('Concluída pelo técnico'),
  closed('Encerrada'),
  cancelled('Cancelada');

  const WorkOrderStatus(this.label);

  /// Rótulo pt-BR para telas e PDFs.
  final String label;

  /// Valor gravado no banco e trafegado nos modelos.
  String get dbValue => switch (this) {
    inProgress => 'in_progress',
    onHold => 'on_hold',
    _ => name,
  };

  static WorkOrderStatus fromDb(String value) => values.firstWhere(
    (s) => s.dbValue == value,
    orElse: () => throw ArgumentError.value(value, 'value', 'status de OS desconhecido'),
  );

  static const Map<WorkOrderStatus, Set<WorkOrderStatus>> transitions = {
    requested: {open, completed, cancelled},
    open: {scheduled, inProgress, completed, cancelled},
    scheduled: {open, inProgress, onHold, cancelled},
    inProgress: {onHold, completed, open, scheduled},
    onHold: {scheduled, inProgress, open, cancelled},
    completed: {closed, open},
    closed: {open},
    cancelled: {open},
  };

  /// Transição permitida pela tabela, sem considerar o modo de resolução.
  bool canTransitionTo(WorkOrderStatus to) => transitions[this]!.contains(to);

  /// Regra completa do trigger, incluindo a resolução remota (v0.2):
  /// `requested|open → completed` só com [ResolutionMode.remote] e sem visita
  /// ativa; `remote` não vale a partir de `in_progress` (já houve visita).
  bool canTransitionWith(
    WorkOrderStatus to, {
    ResolutionMode mode = ResolutionMode.field,
    bool hasActiveVisit = false,
  }) {
    if (!canTransitionTo(to)) return false;
    if (to == completed && (this == requested || this == open)) {
      return mode == ResolutionMode.remote && !hasActiveVisit;
    }
    if (to == completed && mode == ResolutionMode.remote) return false;
    return true;
  }

  /// Status em que a OS ainda está "aberta" para o cliente e para o SLA.
  bool get isActive => this != closed && this != cancelled;

  /// Volta de um estado final ou concluído para `open` conta como reabertura.
  bool isReopeningTo(WorkOrderStatus to) => to == open && (this == completed || this == closed || this == cancelled);
}

/// `work_orders.resolution_mode`.
enum ResolutionMode {
  field,
  remote,
  workshop;

  static ResolutionMode fromDb(String value) => values.byName(value);
}
