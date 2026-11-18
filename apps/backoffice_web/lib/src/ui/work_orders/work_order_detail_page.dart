import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../api/gateway.dart';
import '../../labels.dart';
import '../../session/session.dart';
import '../agenda/visit_dialog.dart';
import '../agenda/visit_tile.dart';
import '../common/errors.dart';
import '../common/format.dart';
import '../common/status_chip.dart';
import 'reason_dialog.dart';

/// Detalhe da OS: dados, ações do ciclo de status conforme as permissões,
/// linha do tempo e outras OS em aberto no mesmo bem.
class WorkOrderDetailPage extends ConsumerStatefulWidget {
  const WorkOrderDetailPage({super.key, required this.id});

  final UuidValue id;

  @override
  ConsumerState<WorkOrderDetailPage> createState() => _WorkOrderDetailPageState();
}

class _WorkOrderDetailPageState extends ConsumerState<WorkOrderDetailPage> {
  late Future<WorkOrderDetail> _detail;
  late Future<List<Visit>> _visits;
  late Future<List<VisitChecklist>> _checklists;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final g = ref.read(gatewayProvider);
    _detail = g.workOrder(widget.id);
    _visits = g.visitsOfWorkOrder(widget.id);
    _checklists = g.checklistsOfWorkOrder(widget.id);
  }

  @override
  void didUpdateWidget(WorkOrderDetailPage old) {
    super.didUpdateWidget(old);
    if (old.id != widget.id) _reload();
  }

  void _reload() => setState(_load);

  Future<void> _scheduleVisit(WorkOrder wo) async {
    final saved = await showDialog<Visit>(
      context: context,
      builder: (_) => VisitDialog(workOrderId: wo.id, workOrderNumber: wo.number),
    );
    if (saved == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visita agendada.')));
    _reload();
  }

  /// Roda a ação e recarrega (o histórico vem do servidor). Se outra pessoa
  /// mexeu antes, avisa e mostra a versão nova.
  Future<void> _run(Future<void> Function(Gateway g) action, String done) async {
    setState(() => _busy = true);
    try {
      await action(ref.read(gatewayProvider));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
      _reload();
    } on GatewayException catch (e) {
      if (!mounted) return;
      if (e.code == 'VERSION_MISMATCH') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('A OS foi alterada por outra pessoa. Os dados foram atualizados; confira e repita.'),
          ),
        );
        _reload();
      } else {
        reportError(context, ref, e);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<ReasonResult?> _ask(ReasonDialog dialog) => showDialog<ReasonResult>(context: context, builder: (_) => dialog);

  List<Widget> _actions(WorkOrder wo, SignedIn session) {
    final execute = session.can('work_orders.update') || session.can('visits.execute');
    final s = wo.status;
    return [
      if (session.can('visits.schedule') && schedulableWorkOrderStatuses.contains(s))
        FilledButton.tonalIcon(
          key: const Key('act-schedule'),
          icon: const Icon(Icons.event),
          label: const Text('Agendar visita'),
          onPressed: () => _scheduleVisit(wo),
        ),
      if (execute && const {'open', 'scheduled', 'on_hold'}.contains(s))
        FilledButton.icon(
          key: const Key('act-start'),
          icon: const Icon(Icons.play_arrow),
          label: Text(s == 'on_hold' ? 'Retomar atendimento' : 'Iniciar atendimento'),
          onPressed: () => _run((g) => g.startWorkOrder(wo), 'Atendimento iniciado.'),
        ),
      if (execute && const {'in_progress', 'scheduled'}.contains(s))
        OutlinedButton.icon(
          key: const Key('act-hold'),
          icon: const Icon(Icons.pause),
          label: const Text('Registrar pendência'),
          onPressed: () async {
            final r = await _ask(
              const ReasonDialog(
                title: 'Registrar pendência',
                confirmLabel: 'Registrar',
                reasons: holdReasonLabels,
                noteLabel: 'Observação',
              ),
            );
            if (r != null) await _run((g) => g.holdWorkOrder(wo, r.reason!, r.note), 'Pendência registrada.');
          },
        ),
      if (execute && s == 'in_progress')
        FilledButton.icon(
          key: const Key('act-complete'),
          icon: const Icon(Icons.check),
          label: const Text('Concluir'),
          onPressed: () async {
            final r = await _ask(
              const ReasonDialog(title: 'Concluir OS', confirmLabel: 'Concluir', noteLabel: 'O que foi feito'),
            );
            if (r != null) await _run((g) => g.completeWorkOrder(wo, r.note), 'OS concluída.');
          },
        ),
      if (session.can('work_orders.close') && s == 'completed')
        FilledButton.icon(
          key: const Key('act-close'),
          icon: const Icon(Icons.done_all),
          label: const Text('Encerrar'),
          onPressed: () => _run((g) => g.closeWorkOrder(wo), 'OS encerrada.'),
        ),
      if (session.can('work_orders.triage') && const {'requested', 'open', 'scheduled', 'on_hold'}.contains(s))
        OutlinedButton.icon(
          key: const Key('act-cancel'),
          icon: const Icon(Icons.block),
          label: const Text('Cancelar OS'),
          onPressed: () async {
            final r = await _ask(
              const ReasonDialog(
                title: 'Cancelar OS',
                confirmLabel: 'Cancelar OS',
                reasons: cancellationReasonLabels,
                noteLabel: 'Observação',
                destructive: true,
              ),
            );
            if (r != null) await _run((g) => g.cancelWorkOrder(wo, r.reason!, r.note), 'OS cancelada.');
          },
        ),
      if (session.can('work_orders.reopen') && const {'completed', 'closed', 'cancelled'}.contains(s))
        OutlinedButton.icon(
          key: const Key('act-reopen'),
          icon: const Icon(Icons.replay),
          label: const Text('Reabrir'),
          onPressed: () async {
            final r = await _ask(
              const ReasonDialog(title: 'Reabrir OS', confirmLabel: 'Reabrir', noteLabel: 'Motivo da reabertura'),
            );
            if (r != null) await _run((g) => g.reopenWorkOrder(wo, r.note), 'OS reaberta.');
          },
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    return FutureBuilder<WorkOrderDetail>(
      future: _detail,
      builder: (context, snap) {
        if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: _reload);
        if (!snap.hasData || session is! SignedIn) return const Center(child: CircularProgressIndicator());
        final detail = snap.data!;
        final wo = detail.workOrder;
        final theme = Theme.of(context);
        final actions = _actions(wo, session);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Voltar à lista',
                  onPressed: () => context.go('/os'),
                  icon: const Icon(Icons.arrow_back),
                ),
                Text('OS ${wo.number}', style: theme.textTheme.headlineSmall),
                WorkOrderStatusChip(wo.status),
                Text('Prioridade ${label(priorityLabels, wo.priority).toLowerCase()}'),
                if (_busy) const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2)),
              ],
            ),
            if (actions.isNotEmpty) ...[
              const SizedBox(height: 12),
              AbsorbPointer(
                absorbing: _busy,
                child: Wrap(spacing: 8, runSpacing: 8, children: actions),
              ),
            ],
            if (detail.otherOpenOnAsset.isNotEmpty) ...[
              const SizedBox(height: 16),
              Card(
                color: theme.colorScheme.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Este bem tem outras OS em aberto',
                        style: theme.textTheme.titleSmall,
                        key: const Key('other-open'),
                      ),
                      for (final other in detail.otherOpenOnAsset)
                        TextButton(
                          onPressed: () => context.go('/os/${other.id}'),
                          child: Text(
                            'OS ${other.number} · ${label(workOrderStatusLabels, other.status)} · ${other.workOrderTypeName}',
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, box) {
                final data = Column(
                  children: [
                    _Section(title: 'Dados', children: _fields(context, wo)),
                    const SizedBox(height: 16),
                    _Section(title: 'Visitas', children: [_visitList()]),
                    _checklistList(),
                  ],
                );
                final history = _Section(title: 'Histórico', children: _history(context, detail.history));
                if (box.maxWidth < 900) return Column(children: [data, const SizedBox(height: 16), history]);
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: data),
                    const SizedBox(width: 16),
                    Expanded(flex: 2, child: history),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _visitList() => FutureBuilder<List<Visit>>(
    future: _visits,
    builder: (context, snap) {
      if (snap.hasError) return Text(errorMessage(snap.error!));
      if (!snap.hasData) return const LinearProgressIndicator();
      if (snap.data!.isEmpty) return const Text('Nenhuma visita agendada.');
      return Column(
        children: [
          for (final v in snap.data!) VisitTile(visit: v, showWorkOrder: false, onChanged: _reload),
        ],
      );
    },
  );

  /// Respostas dos checklists das visitas (some quando não há nenhuma).
  Widget _checklistList() => FutureBuilder<List<VisitChecklist>>(
    future: _checklists,
    builder: (context, snap) {
      if (snap.hasError) {
        return Padding(padding: const EdgeInsets.only(top: 16), child: Text(errorMessage(snap.error!)));
      }
      final list = snap.data;
      if (list == null || list.isEmpty) return const SizedBox.shrink();
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: _Section(
          title: 'Checklist',
          children: [
            for (final (i, c) in list.indexed) ...[
              if (i > 0) const Divider(height: 24),
              ChecklistAnswers(checklist: c),
            ],
          ],
        ),
      );
    },
  );

  List<Widget> _fields(BuildContext context, WorkOrder wo) => [
    FieldRow('Tipo', wo.workOrderTypeName),
    if (wo.assetId != null)
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 170,
              child: Text('Bem', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
            ),
            Flexible(
              child: InkWell(
                onTap: () => context.go('/bens/${wo.assetId}'),
                child: Text(
                  [wo.assetLabel, wo.productName].whereType<String>().join(' · '),
                  style: TextStyle(color: Theme.of(context).colorScheme.primary, decoration: TextDecoration.underline),
                ),
              ),
            ),
          ],
        ),
      )
    else
      const FieldRow('Bem', null),
    FieldRow('Filial', wo.branchName),
    FieldRow('Centro de custo', wo.costCenterName),
    FieldRow('Cliente', wo.customerName ?? 'OS interna'),
    FieldRow('Problema relatado', wo.problemDescription),
    FieldRow('Solicitante', [wo.requesterName, wo.requesterPhone].whereType<String>().join(' · ')),
    FieldRow('Aberta por', '${label(originLabels, wo.origin)} · ${label(entryMethodLabels, wo.entryMethod)}'),
    FieldRow('Aberta em', formatDateTime(wo.createdAt)),
    if (wo.status == 'on_hold') FieldRow('Pendência', label(holdReasonLabels, wo.holdReason)),
    if (wo.startedAt != null) FieldRow('Início do atendimento', formatDateTime(wo.startedAt)),
    if (wo.completedAt != null) FieldRow('Concluída em', formatDateTime(wo.completedAt)),
    if (wo.resolutionNotes != null) FieldRow('O que foi feito', wo.resolutionNotes),
    if (wo.closedAt != null) FieldRow('Encerrada em', formatDateTime(wo.closedAt)),
    if (wo.cancelledAt != null) ...[
      FieldRow('Cancelada em', formatDateTime(wo.cancelledAt)),
      FieldRow('Motivo do cancelamento', label(cancellationReasonLabels, wo.cancellationReason)),
      if (wo.cancellationNote != null) FieldRow('Observação', wo.cancellationNote),
    ],
    if (wo.reopenedCount > 0) FieldRow('Reaberturas', '${wo.reopenedCount}'),
  ];

  List<Widget> _history(BuildContext context, List<WorkOrderStatusChange> history) => [
    for (final h in history.reversed)
      ListTile(
        dense: true,
        contentPadding: EdgeInsets.zero,
        leading: Icon(Icons.circle, size: 12, color: WorkOrderStatusChip.colorOf(h.toStatus)),
        title: Text(
          [
            label(workOrderStatusLabels, h.toStatus),
            if (h.holdReason != null) label(holdReasonLabels, h.holdReason),
          ].join(' · '),
        ),
        subtitle: Text(
          [
            formatDateTime(h.changedAt),
            if (h.changedByName != null) h.changedByName!,
            if (h.reason != null) '"${h.reason}"',
          ].join(' · '),
        ),
      ),
  ];
}

/// Respostas de um checklist de visita, na ordem dos itens do modelo.
class ChecklistAnswers extends StatelessWidget {
  const ChecklistAnswers({super.key, required this.checklist});

  final VisitChecklist checklist;

  static const _values = {'yes': 'Sim', 'no': 'Não', 'na': 'Não se aplica', 'ok': 'OK', 'nok': 'Não OK'};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = checklist.response;
    final answers = {for (final a in r?.answers ?? const <ChecklistAnswer>[]) a.itemKey: a};
    return Column(
      key: Key('checklist-${checklist.visitId}'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          '${checklist.template.name} (v${checklist.template.templateVersion}) · visita ${checklist.visitNumber}',
          style: theme.textTheme.titleSmall,
        ),
        Text(
          [
            label(checklistResponseStatusLabels, r?.status),
            if (r?.submittedAt != null) formatDateTime(r!.submittedAt),
            if (r?.submittedByName != null) r!.submittedByName!,
          ].join(' · '),
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 4),
        for (final item in checklist.template.items)
          FieldRow(item.label, switch (answers[item.key]) {
            null => null,
            final a => [
              switch (item.type) {
                'number' => [a.value, ?item.unit].join(' '),
                _ => _values[a.value] ?? a.value,
              },
              ?a.note,
            ].join(' · '),
          }),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...children,
          ],
        ),
      ),
    );
  }
}
