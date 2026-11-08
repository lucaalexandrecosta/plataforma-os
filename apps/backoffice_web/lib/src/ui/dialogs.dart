import 'package:flutter/material.dart';

/// Pede um motivo obrigatório (inativar, bloquear). Devolve `null` se cancelar.
Future<String?> askReason(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String fieldLabel = 'Motivo',
}) {
  final reason = TextEditingController();
  final form = GlobalKey<FormState>();
  return showDialog<String>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Form(
        key: form,
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(message),
              const SizedBox(height: 16),
              TextFormField(
                controller: reason,
                autofocus: true,
                maxLength: 500,
                decoration: InputDecoration(labelText: fieldLabel),
                validator: (v) => (v?.trim().isEmpty ?? true) ? 'Informe o motivo.' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          onPressed: () {
            if (form.currentState?.validate() ?? false) Navigator.pop(context, reason.text.trim());
          },
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
}

/// Aviso de versão desatualizada (VERSION_MISMATCH). `true` = recarregar.
Future<bool> askReloadAfterConflict(BuildContext context, {String what = 'Este registro'}) async {
  final reload = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.sync_problem_outlined),
      title: const Text('Alterado por outra pessoa'),
      content: Text(
        '$what foi salvo por outra pessoa enquanto você editava. Recarregue para ver a versão atual '
        '(suas alterações não salvas serão descartadas).',
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Continuar editando')),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Recarregar')),
      ],
    ),
  );
  return reload ?? false;
}

/// Selo de situação usado nas listas.
class StatusPill extends StatelessWidget {
  const StatusPill({required this.label, required this.tone, super.key});

  final String label;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final (bg, fg) = switch (tone) {
      StatusTone.positive => (s.primaryContainer, s.onPrimaryContainer),
      StatusTone.warning => (s.tertiaryContainer, s.onTertiaryContainer),
      StatusTone.negative => (s.errorContainer, s.onErrorContainer),
      StatusTone.neutral => (s.surfaceContainerHighest, s.onSurfaceVariant),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: fg, fontSize: 12)),
    );
  }
}

enum StatusTone { positive, warning, negative, neutral }
