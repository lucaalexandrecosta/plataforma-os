import 'package:flutter/material.dart';

import '../../labels.dart';

/// Status da OS com cor própria, igual na lista e no detalhe.
class WorkOrderStatusChip extends StatelessWidget {
  const WorkOrderStatusChip(this.status, {super.key});

  final String status;

  static Color colorOf(String status) => switch (status) {
    'requested' || 'open' => const Color(0xFF1565C0),
    'scheduled' => const Color(0xFF6A1B9A),
    'in_progress' => const Color(0xFFEF6C00),
    'on_hold' => const Color(0xFFC62828),
    'completed' => const Color(0xFF2E7D32),
    'closed' => const Color(0xFF455A64),
    _ => const Color(0xFF757575),
  };

  @override
  Widget build(BuildContext context) {
    final color = colorOf(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        label(workOrderStatusLabels, status),
        style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}

/// Linha "rótulo: valor" dos painéis de detalhe.
class FieldRow extends StatelessWidget {
  const FieldRow(this.label, this.value, {super.key});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 170,
            child: Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ),
          Expanded(child: SelectableText(value == null || value!.isEmpty ? '—' : value!)),
        ],
      ),
    );
  }
}
