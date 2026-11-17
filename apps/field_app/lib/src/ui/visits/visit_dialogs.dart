import 'package:flutter/material.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../labels.dart';

/// Como o técnico quer fazer o check-in.
enum CheckInChoice { qr, gps, manual }

/// Opções de check-in (docs/06 §5.8): QR preferido quando a OS tem bem; GPS;
/// manual com justificativa.
Future<CheckInChoice?> chooseCheckIn(BuildContext context, {required bool hasAsset}) {
  return showModalBottomSheet<CheckInChoice>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Check-in', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            if (hasAsset) ...[
              FilledButton.icon(
                key: const Key('checkin-qr'),
                style: _big,
                icon: const Icon(Icons.qr_code_scanner),
                label: const Text('Ler o QR da etiqueta'),
                onPressed: () => Navigator.pop(context, CheckInChoice.qr),
              ),
              const SizedBox(height: 8),
            ],
            OutlinedButton.icon(
              key: const Key('checkin-gps'),
              style: _big,
              icon: const Icon(Icons.my_location),
              label: const Text('Usar minha localização'),
              onPressed: () => Navigator.pop(context, CheckInChoice.gps),
            ),
            const SizedBox(height: 4),
            TextButton(
              key: const Key('checkin-manual'),
              onPressed: () => Navigator.pop(context, CheckInChoice.manual),
              child: const Text('Não consigo ler nem usar o GPS'),
            ),
          ],
        ),
      ),
    ),
  );
}

final _big = ButtonStyle(minimumSize: WidgetStateProperty.all(const Size.fromHeight(56)));

/// Pede um texto obrigatório (justificativa, motivo).
Future<String?> askText(
  BuildContext context, {
  required String title,
  String? message,
  required String fieldLabel,
  String confirm = 'Confirmar',
}) {
  return showDialog<String>(
    context: context,
    builder: (context) => _TextDialog(title: title, message: message, fieldLabel: fieldLabel, confirm: confirm),
  );
}

class _TextDialog extends StatefulWidget {
  const _TextDialog({required this.title, this.message, required this.fieldLabel, required this.confirm});

  final String title;
  final String? message;
  final String fieldLabel;
  final String confirm;

  @override
  State<_TextDialog> createState() => _TextDialogState();
}

class _TextDialogState extends State<_TextDialog> {
  final _text = TextEditingController();
  String? _error;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  void _ok() {
    final value = _text.text.trim();
    if (value.isEmpty) {
      setState(() => _error = 'Preencha este campo.');
      return;
    }
    Navigator.pop(context, value);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.message case final message?) ...[Text(message), const SizedBox(height: 12)],
          TextField(
            key: const Key('dialog-text'),
            controller: _text,
            autofocus: true,
            minLines: 2,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: widget.fieldLabel,
              errorText: _error,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Voltar')),
        FilledButton(key: const Key('dialog-ok'), onPressed: _ok, child: Text(widget.confirm)),
      ],
    );
  }
}

/// Finalização da visita (docs/06 §5.14). Sem check-in, só "cliente ausente"
/// ou "não executada" (regra do servidor).
Future<VisitFinish?> askFinish(BuildContext context, {required bool checkedIn}) {
  return showDialog<VisitFinish>(
    context: context,
    builder: (context) => _FinishDialog(checkedIn: checkedIn),
  );
}

class _FinishDialog extends StatefulWidget {
  const _FinishDialog({required this.checkedIn});

  final bool checkedIn;

  @override
  State<_FinishDialog> createState() => _FinishDialogState();
}

class _FinishDialogState extends State<_FinishDialog> {
  final _notes = TextEditingController();
  late String _outcome = widget.checkedIn ? 'resolved' : 'customer_absent';
  String _holdReason = 'awaiting_part';
  String? _error;

  List<String> get _outcomes =>
      widget.checkedIn ? outcomeLabels.keys.toList() : const ['customer_absent', 'not_executed'];

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  void _ok() {
    final notes = _notes.text.trim();
    if (_outcome == 'resolved' && notes.isEmpty) {
      setState(() => _error = 'Descreva o que foi feito.');
      return;
    }
    Navigator.pop(
      context,
      VisitFinish(
        outcome: _outcome,
        notes: notes.isEmpty ? null : notes,
        holdReason: _outcome == 'needs_return' ? _holdReason : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.checkedIn ? 'Finalizar visita' : 'Visita não atendida'),
      scrollable: true,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RadioGroup<String>(
            groupValue: _outcome,
            onChanged: (v) => setState(() => _outcome = v!),
            child: Column(
              children: [
                for (final o in _outcomes)
                  RadioListTile<String>(
                    key: Key('outcome-$o'),
                    contentPadding: EdgeInsets.zero,
                    value: o,
                    title: Text(label(outcomeLabels, o)),
                  ),
              ],
            ),
          ),
          if (_outcome == 'needs_return') ...[
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              key: const Key('hold-reason'),
              initialValue: _holdReason,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Motivo do retorno', border: OutlineInputBorder()),
              items: [
                for (final MapEntry(:key, :value) in returnHoldReasonLabels.entries)
                  DropdownMenuItem(value: key, child: Text(value)),
              ],
              onChanged: (v) => setState(() => _holdReason = v!),
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            key: const Key('finish-notes'),
            controller: _notes,
            minLines: 3,
            maxLines: 6,
            decoration: InputDecoration(
              labelText: _outcome == 'resolved' ? 'O que foi feito' : 'Observações',
              errorText: _error,
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Voltar')),
        FilledButton(key: const Key('dialog-ok'), onPressed: _ok, child: const Text('Finalizar')),
      ],
    );
  }
}
