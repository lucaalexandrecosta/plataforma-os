import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/gateway.dart';
import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';
import '../common/paged_table.dart';
import '../common/save_file.dart';
import '../work_orders/reason_dialog.dart';
import 'label_sheet.dart';

/// Lotes de etiquetas QR (permissão `qr_tags.manage`): gerar, baixar o PDF
/// para imprimir e revogar etiquetas. O vínculo com o bem é feito na ficha
/// do bem ou pelo app.
class QrTagsPage extends ConsumerStatefulWidget {
  const QrTagsPage({super.key});

  @override
  ConsumerState<QrTagsPage> createState() => _QrTagsPageState();
}

class _QrTagsPageState extends ConsumerState<QrTagsPage> {
  late Future<List<QrTagBatch>> _batches;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _batches = ref.read(gatewayProvider).qrBatches();
  }

  Future<void> _generate() async {
    final batch = await showDialog<QrTagBatch>(context: context, builder: (_) => const GenerateBatchDialog());
    if (batch == null || !mounted) return;
    setState(_load);
    await _openBatch(batch);
  }

  Future<void> _openBatch(QrTagBatch batch) async {
    await showDialog<void>(
      context: context,
      builder: (_) => BatchDialog(batch: batch),
    );
    if (mounted) setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Etiquetas QR',
          actions: [
            FilledButton.icon(
              key: const Key('qr-generate'),
              onPressed: _generate,
              icon: const Icon(Icons.qr_code_2),
              label: const Text('Gerar lote'),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder<List<QrTagBatch>>(
            future: _batches,
            builder: (context, snap) {
              if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: () => setState(_load));
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final list = snap.data!;
              if (list.isEmpty) {
                return const Center(child: Text('Nenhum lote ainda. Gere um lote para imprimir as etiquetas.'));
              }
              return SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(label: Text('Lote')),
                      DataColumn(label: Text('Etiquetas'), numeric: true),
                      DataColumn(label: Text('Vinculadas'), numeric: true),
                      DataColumn(label: Text('Gerado em')),
                      DataColumn(label: Text('Impresso em')),
                      DataColumn(label: Text('Observações')),
                    ],
                    rows: [
                      for (final b in list)
                        DataRow(
                          key: ValueKey(b.id),
                          onSelectChanged: (_) => _openBatch(b),
                          cells: [
                            DataCell(Text(b.code, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text('${b.quantity}')),
                            DataCell(Text('${b.boundCount}')),
                            DataCell(Text(formatDateTime(b.createdAt))),
                            DataCell(Text(b.printedAt == null ? 'Não impresso' : formatDateTime(b.printedAt))),
                            DataCell(Text(b.notes ?? '—')),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class GenerateBatchDialog extends ConsumerStatefulWidget {
  const GenerateBatchDialog({super.key});

  @override
  ConsumerState<GenerateBatchDialog> createState() => _GenerateBatchDialogState();
}

class _GenerateBatchDialogState extends ConsumerState<GenerateBatchDialog> {
  final _form = GlobalKey<FormState>();
  final _quantity = TextEditingController(text: '24');
  final _notes = TextEditingController();
  var _busy = false;

  @override
  void dispose() {
    _quantity.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _busy = true);
    try {
      final batch = await ref
          .read(gatewayProvider)
          .generateQrBatch(int.parse(_quantity.text.trim()), notes: _notes.text);
      if (mounted) Navigator.of(context).pop(batch);
    } on GatewayException catch (e) {
      if (mounted) reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Gerar lote de etiquetas'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('qr-quantity'),
                controller: _quantity,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: const InputDecoration(
                  labelText: 'Quantidade',
                  helperText: 'De 1 a 500. A folha A4 tem 24 etiquetas.',
                  border: OutlineInputBorder(),
                ),
                validator: (v) {
                  final n = int.tryParse(v?.trim() ?? '');
                  return n == null || n < 1 || n > 500 ? 'Informe de 1 a 500.' : null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notes,
                decoration: const InputDecoration(labelText: 'Observações', border: OutlineInputBorder()),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(key: const Key('qr-generate-ok'), onPressed: _busy ? null : _submit, child: const Text('Gerar')),
      ],
    );
  }
}

/// Etiquetas de um lote: baixar o PDF para imprimir (marca o lote como
/// impresso) e revogar uma etiqueta perdida ou danificada.
class BatchDialog extends ConsumerStatefulWidget {
  const BatchDialog({super.key, required this.batch});

  final QrTagBatch batch;

  @override
  ConsumerState<BatchDialog> createState() => _BatchDialogState();
}

class _BatchDialogState extends ConsumerState<BatchDialog> {
  late Future<List<QrTag>> _tags;
  late var _batch = widget.batch;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _tags = ref.read(gatewayProvider).qrBatchTags(widget.batch.id);
  }

  Future<void> _print(List<QrTag> tags) async {
    final printable = [
      for (final t in tags)
        if (t.status != 'revoked') t,
    ];
    setState(() => _busy = true);
    try {
      final bytes = await buildLabelSheet(widget.batch, printable);
      await ref.read(saveFileProvider)('etiquetas-${widget.batch.code}.pdf', 'application/pdf', bytes);
      final batch = await ref.read(gatewayProvider).markQrBatchPrinted(widget.batch.id);
      if (!mounted) return;
      _batch = batch;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PDF com ${printable.length} etiquetas baixado. Imprima em tamanho real (100%).')),
      );
      setState(_load);
    } on GatewayException catch (e) {
      if (mounted) reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _revoke(QrTag tag) async {
    final result = await showDialog<ReasonResult>(
      context: context,
      builder: (_) => ReasonDialog(
        title: 'Revogar a etiqueta ${tag.shortCode}?',
        confirmLabel: 'Revogar',
        reasons: qrRevokeReasonLabels,
        noteLabel: 'Observação',
        destructive: true,
      ),
    );
    if (result == null || !mounted) return;
    try {
      await ref.read(gatewayProvider).revokeQrTag(tag, result.reason!, note: result.note);
      if (mounted) setState(_load);
    } on GatewayException catch (e) {
      if (mounted) reportError(context, ref, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final b = _batch;
    return AlertDialog(
      title: Text('Lote ${b.code}'),
      content: SizedBox(
        width: 560,
        height: 480,
        child: FutureBuilder<List<QrTag>>(
          future: _tags,
          builder: (context, snap) {
            if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: () => setState(_load));
            if (!snap.hasData) return const Center(child: CircularProgressIndicator());
            final tags = snap.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  b.printedAt == null
                      ? '${tags.length} etiquetas, ainda não impressas.'
                      : '${tags.length} etiquetas. Impresso em ${formatDateTime(b.printedAt)}.',
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: FilledButton.icon(
                    key: const Key('qr-print'),
                    onPressed: _busy ? null : () => _print(tags),
                    icon: const Icon(Icons.picture_as_pdf),
                    label: const Text('Baixar PDF para imprimir'),
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView(
                    children: [
                      for (final t in tags)
                        ListTile(
                          key: ValueKey(t.id),
                          dense: true,
                          title: Text(t.shortCode, style: const TextStyle(fontFamily: 'monospace')),
                          subtitle: Text(
                            [
                              label(qrTagStatusLabels, t.status),
                              if (t.assetLabel != null) 'bem ${t.assetLabel}',
                              if (t.revokedReason != null) label(qrRevokeReasonLabels, t.revokedReason),
                            ].join(' · '),
                          ),
                          trailing: t.status == 'revoked'
                              ? null
                              : IconButton(
                                  key: Key('qr-revoke-${t.shortCode}'),
                                  tooltip: 'Revogar',
                                  onPressed: () => _revoke(t),
                                  icon: const Icon(Icons.block),
                                ),
                        ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
      actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Fechar'))],
    );
  }
}
