import 'package:flutter/material.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../labels.dart';
import '../common/format.dart';

/// Status da visita com cor por fase.
class VisitStatusChip extends StatelessWidget {
  const VisitStatusChip(this.status, {super.key});

  final String status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (bg, fg) = switch (status) {
      'en_route' || 'on_site' => (scheme.primaryContainer, scheme.onPrimaryContainer),
      'paused' => (scheme.tertiaryContainer, scheme.onTertiaryContainer),
      'finished' => (scheme.surfaceContainerHighest, scheme.onSurfaceVariant),
      'cancelled' => (scheme.errorContainer, scheme.onErrorContainer),
      _ => (scheme.secondaryContainer, scheme.onSecondaryContainer),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(
        label(visitStatusLabels, status),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(color: fg),
      ),
    );
  }
}

/// Selo de prioridade, só para alta e urgente.
class PriorityBadge extends StatelessWidget {
  const PriorityBadge(this.priority, {super.key});

  final String priority;

  @override
  Widget build(BuildContext context) {
    if (priority != 'high' && priority != 'urgent') return const SizedBox.shrink();
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.priority_high, size: 16, color: scheme.error),
        Text(
          label(priorityLabels, priority),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: scheme.error),
        ),
      ],
    );
  }
}

/// "Aguardando envio": a ação foi gravada no aparelho e ainda não chegou ao
/// servidor.
class PendingBadge extends StatelessWidget {
  const PendingBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.tertiary;
    return Row(
      key: const Key('pending-badge'),
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.cloud_upload_outlined, size: 16, color: color),
        const SizedBox(width: 4),
        Text('Aguardando envio', style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color)),
      ],
    );
  }
}

/// Cartão da visita na agenda: janela, OS, onde e o quê.
class VisitCard extends StatelessWidget {
  const VisitCard({super.key, required this.visit, required this.onTap, this.dayRelativeTo, this.pending = false});

  final Visit visit;
  final VoidCallback onTap;

  /// Há ações desta visita ainda não enviadas.
  final bool pending;

  /// Mostra o dia ("Ontem · 08:00–10:00") nas seções fora do dia a dia.
  final DateTime? dayRelativeTo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final where = [visit.customerName, visit.branchName].whereType<String>().join(' · ');
    final what = [visit.assetLabel, visit.productName].whereType<String>().join(' · ');
    final finished = visit.status == 'finished' || visit.status == 'cancelled';
    return Card(
      key: Key('visit-${visit.id}'),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: finished ? 0.6 : 1,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            [
                              if (dayRelativeTo case final today?) formatDay(visit.scheduledStart, today),
                              formatWindow(visit.scheduledStart, visit.scheduledEnd),
                            ].join(' · '),
                            style: theme.textTheme.titleMedium,
                          ),
                          PriorityBadge(visit.workOrderPriority),
                        ],
                      ),
                    ),
                    VisitStatusChip(visit.status),
                  ],
                ),
                const SizedBox(height: 6),
                Text('OS ${visit.workOrderNumber}', style: theme.textTheme.titleSmall),
                if (where.isNotEmpty) Text(where, style: theme.textTheme.bodyMedium),
                if (what.isNotEmpty)
                  Text(what, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                if (visit.problemDescription case final problem?) ...[
                  const SizedBox(height: 6),
                  Text(problem, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.bodySmall),
                ],
                if (pending) ...[
                  const SizedBox(height: 6),
                  const PendingBadge(),
                ],
                if (visit.outcome case final outcome?) ...[
                  const SizedBox(height: 6),
                  Text('Resultado: ${label(outcomeLabels, outcome)}', style: theme.textTheme.bodySmall),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
