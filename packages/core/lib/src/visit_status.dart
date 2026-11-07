/// Status da visita (D9, docs/03 §6.2). Mesma tabela do trigger
/// `app.tg_visit_status_guard`. O app do técnico usa estas regras para validar
/// as mutações offline antes de enfileirá-las em `pending_mutations`.
enum VisitStatus {
  scheduled('Agendada'),
  enRoute('Em deslocamento'),
  onSite('Em execução'),
  paused('Pausada'),
  finished('Finalizada'),
  cancelled('Cancelada');

  const VisitStatus(this.label);

  final String label;

  String get dbValue => switch (this) {
    enRoute => 'en_route',
    onSite => 'on_site',
    _ => name,
  };

  static VisitStatus fromDb(String value) => values.firstWhere(
    (s) => s.dbValue == value,
    orElse: () => throw ArgumentError.value(value, 'value', 'status de visita desconhecido'),
  );

  static const Map<VisitStatus, Set<VisitStatus>> transitions = {
    scheduled: {enRoute, onSite, finished, cancelled},
    enRoute: {onSite, finished, cancelled},
    onSite: {paused, finished},
    paused: {onSite, finished},
    finished: {},
    cancelled: {},
  };

  bool canTransitionTo(VisitStatus to) => transitions[this]!.contains(to);

  /// `visit.finish`: sem check-in (scheduled/en_route) só termina como
  /// [VisitOutcome.customerAbsent] ou [VisitOutcome.notExecuted].
  bool canFinishWith(VisitOutcome outcome) {
    if (!canTransitionTo(finished)) return false;
    if (this == scheduled || this == enRoute) {
      return outcome == VisitOutcome.customerAbsent || outcome == VisitOutcome.notExecuted;
    }
    return true;
  }

  /// Visita que ainda prende a OS em atendimento.
  bool get isActive => this == scheduled || this == enRoute || this == onSite || this == paused;

  bool get isTerminal => this == finished || this == cancelled;
}

/// `work_order_visits.outcome`.
enum VisitOutcome {
  resolved('resolved'),
  needsReturn('needs_return'),
  customerAbsent('customer_absent'),
  notExecuted('not_executed');

  const VisitOutcome(this.dbValue);

  final String dbValue;

  static VisitOutcome fromDb(String value) => values.firstWhere((o) => o.dbValue == value);
}
