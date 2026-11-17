import 'package:flutter/material.dart';

/// Resposta do [ReasonDialog].
typedef ReasonResult = ({String? reason, String note});

/// Pede motivo (lista opcional) e texto. O texto é obrigatório quando não há
/// lista, ou quando o motivo escolhido é "Outro".
class ReasonDialog extends StatefulWidget {
  const ReasonDialog({
    super.key,
    required this.title,
    required this.confirmLabel,
    this.reasons,
    required this.noteLabel,
    this.destructive = false,
  });

  final String title;
  final String confirmLabel;
  final Map<String, String>? reasons;
  final String noteLabel;
  final bool destructive;

  @override
  State<ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<ReasonDialog> {
  final _form = GlobalKey<FormState>();
  final _note = TextEditingController();
  String? _reason;

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  bool get _noteRequired => widget.reasons == null || _reason == 'other';

  @override
  Widget build(BuildContext context) {
    final reasons = widget.reasons;
    final colors = Theme.of(context).colorScheme;
    return AlertDialog(
      title: Text(widget.title),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (reasons != null) ...[
                DropdownButtonFormField<String>(
                  key: const Key('reason'),
                  initialValue: _reason,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Motivo', border: OutlineInputBorder()),
                  items: [for (final e in reasons.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
                  onChanged: (v) => setState(() => _reason = v),
                  validator: (v) => v == null ? 'Escolha o motivo.' : null,
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                key: const Key('note'),
                controller: _note,
                autofocus: reasons == null,
                minLines: 2,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: _noteRequired ? widget.noteLabel : '${widget.noteLabel} (opcional)',
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => _noteRequired && (v == null || v.trim().isEmpty) ? 'Preencha este campo.' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Voltar')),
        FilledButton(
          key: const Key('reason-confirm'),
          style: widget.destructive ? FilledButton.styleFrom(backgroundColor: colors.error) : null,
          onPressed: () {
            if (!_form.currentState!.validate()) return;
            Navigator.of(context).pop<ReasonResult>((reason: _reason, note: _note.text.trim()));
          },
          child: Text(widget.confirmLabel),
        ),
      ],
    );
  }
}
