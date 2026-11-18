import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../api/gateway.dart';
import '../../local/checklist_rules.dart';
import '../../local/field_store.dart';
import '../../local/providers.dart';
import '../common/errors.dart';
import 'sync_widgets.dart';

/// Preenchimento do checklist da visita (docs/06 §5.9). Cada resposta é
/// salva no aparelho na hora, sem rede; "Enviar checklist" confere os
/// obrigatórios e põe o envio na fila do sync.
class ChecklistPage extends ConsumerStatefulWidget {
  const ChecklistPage({super.key, required this.visitId});

  final UuidValue visitId;

  @override
  ConsumerState<ChecklistPage> createState() => _ChecklistPageState();
}

class _ChecklistPageState extends ConsumerState<ChecklistPage> {
  final _controllers = <String, TextEditingController>{};
  var _errors = <String, String>{};
  var _busy = false;

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _controller(String key, String? initial) =>
      _controllers.putIfAbsent(key, () => TextEditingController(text: initial ?? ''));

  Future<void> _save(FieldStore store, ChecklistItem item, String value) async {
    final key = item.key!;
    if (_errors.containsKey(key)) setState(() => _errors = Map.of(_errors)..remove(key));
    try {
      await store.saveChecklistAnswer(widget.visitId, ChecklistAnswer(itemKey: key, value: value));
    } on GatewayException catch (e) {
      if (mounted) reportError(context, ref, e);
    }
  }

  Future<void> _submit(FieldStore store, Visit visit) async {
    setState(() => _busy = true);
    try {
      await store.submitChecklist(visit);
      if (!mounted) return;
      setState(() => _errors = {});
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('Checklist enviado.')));
    } on GatewayException catch (e) {
      if (!mounted) return;
      setState(() => _errors = e.fieldErrors);
      reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = ref.watch(storeProvider);
    if (store == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    return StreamBuilder<Visit?>(
      stream: store.watchVisit(widget.visitId),
      builder: (context, visitSnap) => StreamBuilder<VisitChecklistState?>(
        stream: store.watchChecklist(widget.visitId),
        builder: (context, snap) {
          final visit = visitSnap.data;
          final checklist = snap.data;
          final editable = visit != null && const {'on_site', 'paused'}.contains(visit.status);
          return Scaffold(
            appBar: AppBar(
              title: Text(checklist?.template.name ?? 'Checklist'),
              actions: [SyncButton(store: store)],
            ),
            body: checklist == null
                ? Center(
                    child: snap.connectionState == ConnectionState.waiting
                        ? const CircularProgressIndicator()
                        : const Text('Esta visita não tem checklist.'),
                  )
                : ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    children: [
                      _Status(checklist: checklist, editable: editable),
                      const SizedBox(height: 8),
                      for (final item in checklist.template.items)
                        _ItemCard(
                          key: Key('item-${item.key}'),
                          item: item,
                          answer: checklist.answers[item.key],
                          error: _errors[item.key],
                          enabled: editable && !_busy,
                          controller: const {'number', 'text'}.contains(item.type)
                              ? _controller(item.key!, checklist.answers[item.key]?.value)
                              : null,
                          onChanged: (value) => _save(store, item, value),
                        ),
                    ],
                  ),
            bottomNavigationBar: checklist == null || !editable
                ? null
                : SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                      child: FilledButton.icon(
                        key: const Key('checklist-submit'),
                        style: ButtonStyle(minimumSize: WidgetStateProperty.all(const Size.fromHeight(52))),
                        icon: const Icon(Icons.send),
                        label: Text(checklist.submitted ? 'Enviar de novo' : 'Enviar checklist'),
                        onPressed: _busy ? null : () => _submit(store, visit),
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }
}

class _Status extends StatelessWidget {
  const _Status({required this.checklist, required this.editable});

  final VisitChecklistState checklist;
  final bool editable;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (icon, text) = switch (checklist) {
      VisitChecklistState(submitted: true, pending: true) => (
        Icons.cloud_upload_outlined,
        'Enviado no aparelho; vai para o servidor quando houver sinal.',
      ),
      VisitChecklistState(submitted: true) => (Icons.cloud_done_outlined, 'Checklist enviado.'),
      _ when !editable => (Icons.lock_outline, 'O checklist é preenchido depois do check-in.'),
      _ => (Icons.edit_note, 'Respostas salvas no aparelho. Envie ao terminar.'),
    };
    return Card(
      child: ListTile(
        key: const Key('checklist-status'),
        leading: Icon(icon),
        title: Text('${checklist.answered} de ${checklist.total} respondidos'),
        subtitle: Text(text, style: theme.textTheme.bodySmall),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  const _ItemCard({
    super.key,
    required this.item,
    required this.answer,
    required this.error,
    required this.enabled,
    required this.controller,
    required this.onChanged,
  });

  final ChecklistItem item;
  final ChecklistAnswer? answer;
  final String? error;
  final bool enabled;
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;

  static const _yesNo = {'yes': 'Sim', 'no': 'Não', 'na': 'N/A'};
  static const _okNok = {'ok': 'OK', 'nok': 'Não OK', 'na': 'N/A'};

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = answer?.value;
    Widget options(Map<String, String> choices) => Wrap(
      spacing: 8,
      runSpacing: 4,
      children: [
        for (final MapEntry(:key, value: text) in choices.entries)
          ChoiceChip(
            key: Key('opt-${item.key}-$key'),
            label: Text(text),
            selected: value == key,
            onSelected: enabled ? (on) => onChanged(on ? key : '') : null,
          ),
      ],
    );
    final input = switch (item.type) {
      'yes_no' => options(_yesNo),
      'ok_nok' => options(_okNok),
      'choice' => options({for (final o in item.options ?? const <String>[]) o: o}),
      'number' => TextField(
        key: Key('input-${item.key}'),
        controller: controller,
        enabled: enabled,
        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
        decoration: InputDecoration(suffixText: item.unit, border: const OutlineInputBorder(), isDense: true),
        onChanged: onChanged,
      ),
      _ => TextField(
        key: Key('input-${item.key}'),
        controller: controller,
        enabled: enabled,
        minLines: 1,
        maxLines: 4,
        decoration: const InputDecoration(border: OutlineInputBorder(), isDense: true),
        onChanged: onChanged,
      ),
    };
    return Card(
      shape: error == null
          ? null
          : RoundedRectangleBorder(
              side: BorderSide(color: theme.colorScheme.error),
              borderRadius: BorderRadius.circular(12),
            ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                text: item.label,
                children: [
                  if (item.required)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(color: theme.colorScheme.error),
                    ),
                ],
              ),
              style: theme.textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            input,
            if (error case final e?) ...[
              const SizedBox(height: 4),
              Text(e, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error)),
            ],
          ],
        ),
      ),
    );
  }
}
