import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/gateway.dart';
import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';
import '../work_orders/reason_dialog.dart';
import 'visit_dialog.dart';

Color visitStatusColor(String status) => switch (status) {
  'scheduled' => const Color(0xFF6A1B9A),
  'en_route' => const Color(0xFF1565C0),
  'on_site' => const Color(0xFFEF6C00),
  'paused' => const Color(0xFFC62828),
  'finished' => const Color(0xFF2E7D32),
  _ => const Color(0xFF757575),
};

class VisitStatusChip extends StatelessWidget {
  const VisitStatusChip(this.status, {super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final color = visitStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label(visitStatusLabels, status),
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}

/// Uma visita, na agenda ou no detalhe da OS. Quem agenda pode reagendar
/// (visita ainda agendada) e desmarcar (agendada ou em deslocamento).
class VisitTile extends ConsumerWidget {
  const VisitTile({super.key, required this.visit, required this.onChanged, this.showWorkOrder = true});

  final Visit visit;

  /// Chamado depois de reagendar ou desmarcar, para recarregar a lista.
  final VoidCallback onChanged;

  /// Na agenda mostra a OS e o bem; no detalhe da OS, o número da visita.
  final bool showWorkOrder;

  Future<void> _reschedule(BuildContext context) async {
    final saved = await showDialog<Visit>(
      context: context,
      builder: (_) => VisitDialog(workOrderId: visit.workOrderId, workOrderNumber: visit.workOrderNumber, visit: visit),
    );
    if (saved != null) onChanged();
  }

  Future<void> _cancel(BuildContext context, WidgetRef ref) async {
    final r = await showDialog<ReasonResult>(
      context: context,
      builder: (_) => const ReasonDialog(
        title: 'Desmarcar visita',
        confirmLabel: 'Desmarcar',
        noteLabel: 'Motivo',
        destructive: true,
      ),
    );
    if (r == null) return;
    try {
      await ref.read(gatewayProvider).cancelVisit(visit, r.note);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Visita desmarcada.')));
      }
    } on GatewayException catch (e) {
      if (context.mounted) reportError(context, ref, e);
    }
    onChanged();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    final canSchedule = session is SignedIn && session.can('visits.schedule');
    final canReschedule = canSchedule && visit.status == 'scheduled';
    final canCancel = canSchedule && const {'scheduled', 'en_route'}.contains(visit.status);
    final window = '${formatTime(visit.scheduledStart)}–${formatTime(visit.scheduledEnd)}';
    final details = <String>[
      if (showWorkOrder) ...[
        'OS ${visit.workOrderNumber}',
        if (visit.assetLabel != null) [visit.assetLabel, visit.productName].whereType<String>().join(' · '),
        if (visit.customerName != null) visit.customerName!,
      ] else ...[
        formatDay(visit.scheduledStart.toLocal()),
        visit.technicianName ?? 'Sem técnico',
      ],
      if (visit.outcome != null) label(visitOutcomeLabels, visit.outcome),
      if (visit.checkInMethod != null)
        'Check-in ${label(checkInMethodLabels, visit.checkInMethod).toLowerCase()}'
            '${visit.checkInOffSite ? ' fora do local' : ''}',
      if (visit.cancellationReason != null) 'Motivo: ${visit.cancellationReason}',
    ];
    return ListTile(
      key: ValueKey(visit.id),
      leading: SizedBox(
        width: 92,
        child: Text(window, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
      title: Text(
        showWorkOrder ? (visit.problemDescription ?? 'OS ${visit.workOrderNumber}') : 'Visita ${visit.visitNumber}',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(details.join(' · ')),
      onTap: showWorkOrder ? () => context.go('/os/${visit.workOrderId}') : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          VisitStatusChip(visit.status),
          if (canReschedule || canCancel)
            PopupMenuButton<String>(
              key: Key('visit-menu-${visit.visitNumber}'),
              tooltip: 'Ações da visita',
              onSelected: (choice) => choice == 'reschedule' ? _reschedule(context) : _cancel(context, ref),
              itemBuilder: (_) => [
                if (canReschedule) const PopupMenuItem(value: 'reschedule', child: Text('Reagendar')),
                if (canCancel) const PopupMenuItem(value: 'cancel', child: Text('Desmarcar')),
              ],
            ),
        ],
      ),
    );
  }
}
