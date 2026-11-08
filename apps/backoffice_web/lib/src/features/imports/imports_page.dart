import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/api_client.dart';
import '../../ui/dialogs.dart';
import '../../ui/errors.dart';
import '../../ui/web_files.dart';

/// Assistente de importação (docs/06 §3): tipo → modelo → arquivo → prévia
/// com erros por linha → confirmar → resultado, e o histórico.
class ImportsPage extends ConsumerStatefulWidget {
  const ImportsPage({super.key});

  @override
  ConsumerState<ImportsPage> createState() => _ImportsPageState();
}

enum _Step { choose, preview, done }

class _ImportsPageState extends ConsumerState<ImportsPage> {
  static const _maxBytes = 700 * 1024;

  final Map<ImportEntityType, ImportTemplate> _templates = {};
  ImportEntityType _entity = ImportEntityType.customers;
  _Step _step = _Step.choose;
  ImportPreview? _preview;
  ImportRunInfo? _result;
  bool _busy = false;
  Object? _error;

  List<ImportRunInfo> _history = const [];

  Client get _api => ref.read(apiClientProvider);

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      final available = await _api.imports.available();
      for (final e in available) {
        _templates[e] = await _api.imports.template(e);
      }
      if (available.isNotEmpty && !available.contains(_entity)) _entity = available.first;
      await _loadHistory();
      if (mounted) setState(() {});
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _loadHistory() async {
    final page = await _api.imports.list(null, PageRequest(limit: 20));
    if (mounted) setState(() => _history = page.items);
  }

  void _downloadTemplate() {
    final t = _templates[_entity]!;
    downloadBytes(t.fileName, t.csv.buffer.asUint8List(t.csv.offsetInBytes, t.csv.lengthInBytes));
  }

  Future<void> _pickAndPreview() async {
    final file = await pickFile();
    if (file == null) return;
    if (file.bytes.length > _maxBytes) {
      if (mounted) {
        showInfoSnack(context, 'Arquivo acima de ${_maxBytes ~/ 1024} KB. Divida a planilha em partes menores.');
      }
      return;
    }
    setState(() => _busy = true);
    try {
      final preview = await _api.imports.preview(_entity, file.name, ByteData.sublistView(file.bytes));
      if (!mounted) return;
      setState(() {
        _preview = preview;
        _step = _Step.preview;
        _busy = false;
      });
      await _loadHistory();
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showErrorSnack(context, e);
    }
  }

  Future<void> _confirm() async {
    final run = _preview!.run;
    setState(() => _busy = true);
    try {
      final result = await _api.imports.confirm(run.id, run.version);
      if (!mounted) return;
      setState(() {
        _result = result;
        _step = _Step.done;
        _busy = false;
      });
      await _loadHistory();
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _busy = false);
      showErrorSnack(context, e);
    }
  }

  Future<void> _cancel() async {
    final run = _preview?.run;
    if (run != null && run.status == SyncRunStatus.queued) {
      try {
        await _api.imports.cancel(run.id, run.version);
      } on Object catch (_) {
        // Já cancelada ou aplicada em outra aba: só volta ao início.
      }
    }
    _reset();
    await _loadHistory();
  }

  void _reset() => setState(() {
    _preview = null;
    _result = null;
    _step = _Step.choose;
  });

  Future<void> _downloadReport(ImportRunInfo run) async {
    try {
      final bytes = await _api.imports.errorReport(run.id);
      final base = (run.fileName ?? 'importacao').replaceAll(RegExp(r'\.[^.]+$'), '');
      downloadBytes('${base}_erros.csv', bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes));
    } on Object catch (e) {
      if (mounted) showErrorSnack(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return ErrorPanel(
        error: _error!,
        onRetry: () {
          setState(() => _error = null);
          _bootstrap();
        },
      );
    }
    if (_templates.isEmpty) return const Center(child: CircularProgressIndicator());
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Importar planilha', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          'Excel (.xlsx) ou CSV. Reenviar a mesma planilha não duplica nada: os registros são encontrados pelo código.',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 20),
        switch (_step) {
          _Step.choose => _chooseStep(theme),
          _Step.preview => _previewStep(theme),
          _Step.done => _doneStep(theme),
        },
        const SizedBox(height: 32),
        Text('Últimas importações', style: theme.textTheme.titleMedium),
        const SizedBox(height: 8),
        _historyList(theme),
      ],
    );
  }

  // --- passo 1 ---------------------------------------------------------------

  Widget _chooseStep(ThemeData theme) {
    final t = _templates[_entity]!;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('1. O que você vai importar?', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            SegmentedButton<ImportEntityType>(
              segments: [
                for (final e in _templates.keys) ButtonSegment(value: e, label: Text(_templates[e]!.title)),
              ],
              selected: {_entity},
              onSelectionChanged: (s) => setState(() => _entity = s.first),
            ),
            const SizedBox(height: 12),
            Text(t.description),
            const SizedBox(height: 16),
            Text('2. Preencha a planilha com estas colunas', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 36,
                dataRowMinHeight: 32,
                dataRowMaxHeight: 48,
                columns: const [
                  DataColumn(label: Text('Coluna')),
                  DataColumn(label: Text('O que é')),
                  DataColumn(label: Text('Exemplo')),
                ],
                rows: [
                  for (final c in t.columns)
                    DataRow(
                      cells: [
                        DataCell(
                          Text.rich(
                            TextSpan(
                              text: c.key,
                              style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w600),
                              children: [
                                if (c.isRequired)
                                  TextSpan(
                                    text: ' *',
                                    style: TextStyle(color: theme.colorScheme.error),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(Text([c.label, if (c.help.isNotEmpty) c.help].join(' — '))),
                        DataCell(Text(c.example, style: TextStyle(color: theme.colorScheme.onSurfaceVariant))),
                      ],
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '* obrigatória. Os nomes das colunas podem ter acento e maiúsculas ("Razão Social" vale). '
              'Colunas que não estão na lista são ignoradas.',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                OutlinedButton.icon(
                  onPressed: _downloadTemplate,
                  icon: const Icon(Icons.download_outlined),
                  label: const Text('Baixar modelo'),
                ),
                FilledButton.icon(
                  onPressed: _busy ? null : _pickAndPreview,
                  icon: _busy
                      ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.upload_file),
                  label: const Text('3. Enviar planilha e conferir'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- passo 2: prévia -------------------------------------------------------

  Widget _previewStep(ThemeData theme) {
    final p = _preview!;
    final s = p.run.stats;
    final failed = p.run.status == SyncRunStatus.failed;
    final applicable = s.toCreate + s.toUpdate;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text('Conferência: ${p.run.fileName ?? ''}', style: theme.textTheme.titleMedium),
                ),
                Text(_templates[p.run.entityType]?.title ?? '', style: theme.textTheme.bodyMedium),
              ],
            ),
            const SizedBox(height: 4),
            Text('Nada foi gravado ainda.', style: theme.textTheme.bodySmall),
            const SizedBox(height: 16),
            if (failed) ...[
              _Notice(tone: StatusTone.negative, text: p.run.errorMessage ?? 'Não foi possível ler a planilha.'),
              const SizedBox(height: 12),
            ] else
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  _Stat(label: 'Linhas', value: s.totalRows),
                  _Stat(label: 'Novos', value: s.toCreate, tone: StatusTone.positive),
                  _Stat(label: 'Atualizados', value: s.toUpdate, tone: StatusTone.positive),
                  _Stat(label: 'Sem mudança', value: s.unchanged),
                  _Stat(
                    label: 'Com erro',
                    value: s.errorRows,
                    tone: s.errorRows > 0 ? StatusTone.negative : StatusTone.neutral,
                  ),
                ],
              ),
            if (p.unknownColumns.isNotEmpty) ...[
              const SizedBox(height: 12),
              _Notice(
                tone: StatusTone.warning,
                text: 'Colunas ignoradas (não reconhecidas): ${p.unknownColumns.join(', ')}',
              ),
            ],
            if (p.errors.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                s.errorRows > p.errors.length
                    ? 'Primeiros ${p.errors.length} de ${s.errorRows} erros'
                    : 'Linhas com erro (serão ignoradas)',
                style: theme.textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowHeight: 36,
                  dataRowMinHeight: 32,
                  dataRowMaxHeight: double.infinity,
                  columns: const [
                    DataColumn(label: Text('Linha'), numeric: true),
                    DataColumn(label: Text('Registro')),
                    DataColumn(label: Text('Problema')),
                  ],
                  rows: [
                    for (final e in p.errors)
                      DataRow(
                        cells: [
                          DataCell(Text('${e.rowNumber}')),
                          DataCell(Text(e.key ?? '—')),
                          DataCell(
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              child: Text(e.messages.join('\n')),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                TextButton(onPressed: _busy ? null : _cancel, child: const Text('Cancelar')),
                if (p.run.hasErrorReport)
                  OutlinedButton.icon(
                    onPressed: () => _downloadReport(p.run),
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Baixar linhas com erro'),
                  ),
                if (!failed)
                  FilledButton.icon(
                    onPressed: _busy || applicable == 0 ? null : _confirm,
                    icon: _busy
                        ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.check),
                    label: Text(
                      applicable == 0
                          ? 'Nada para importar'
                          : 'Importar $applicable ${applicable == 1 ? 'registro' : 'registros'}'
                                '${s.errorRows > 0 ? ' (ignorar ${s.errorRows} com erro)' : ''}',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- passo 3: resultado ----------------------------------------------------

  Widget _doneStep(ThemeData theme) {
    final r = _result!;
    final s = r.stats;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  r.status == SyncRunStatus.succeeded ? Icons.check_circle : Icons.info_outline,
                  color: r.status == SyncRunStatus.succeeded ? theme.colorScheme.primary : theme.colorScheme.tertiary,
                ),
                const SizedBox(width: 8),
                Text(_statusLabel(r.status), style: theme.textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _Stat(label: 'Criados', value: s.created ?? 0, tone: StatusTone.positive),
                _Stat(label: 'Atualizados', value: s.updated ?? 0, tone: StatusTone.positive),
                _Stat(label: 'Sem mudança', value: s.unchanged),
                _Stat(
                  label: 'Ignorados com erro',
                  value: s.errorRows,
                  tone: s.errorRows > 0 ? StatusTone.negative : StatusTone.neutral,
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              children: [
                if (r.hasErrorReport)
                  OutlinedButton.icon(
                    onPressed: () => _downloadReport(r),
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Baixar linhas com erro para corrigir'),
                  ),
                FilledButton(onPressed: _reset, child: const Text('Nova importação')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- histórico -------------------------------------------------------------

  Widget _historyList(ThemeData theme) {
    if (_history.isEmpty) return const Text('Nenhuma importação ainda.');
    final fmt = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');
    return Card(
      child: Column(
        children: [
          for (final (i, r) in _history.indexed) ...[
            if (i > 0) const Divider(height: 1),
            ListTile(
              dense: true,
              title: Text('${_templates[r.entityType]?.title ?? r.entityType.name} · ${r.fileName ?? ''}'),
              subtitle: Text(
                [
                  fmt.format(r.createdAt.toLocal()),
                  if (r.stats.created != null) '${r.stats.created} criados, ${r.stats.updated ?? 0} atualizados',
                  if (r.stats.errorRows > 0) '${r.stats.errorRows} com erro',
                  if (r.errorMessage != null) r.errorMessage!,
                ].join(' · '),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StatusPill(label: _statusLabel(r.status), tone: _statusTone(r.status)),
                  if (r.hasErrorReport)
                    IconButton(
                      tooltip: 'Baixar linhas com erro',
                      icon: const Icon(Icons.download_outlined),
                      onPressed: () => _downloadReport(r),
                    ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  static String _statusLabel(SyncRunStatus s) => switch (s) {
    SyncRunStatus.queued => 'Aguardando confirmação',
    SyncRunStatus.running => 'Processando',
    SyncRunStatus.succeeded => 'Importação concluída',
    SyncRunStatus.partially_succeeded => 'Concluída com linhas ignoradas',
    SyncRunStatus.failed => 'Falhou',
    SyncRunStatus.cancelled => 'Cancelada',
  };

  static StatusTone _statusTone(SyncRunStatus s) => switch (s) {
    SyncRunStatus.succeeded => StatusTone.positive,
    SyncRunStatus.partially_succeeded || SyncRunStatus.queued || SyncRunStatus.running => StatusTone.warning,
    SyncRunStatus.failed => StatusTone.negative,
    SyncRunStatus.cancelled => StatusTone.neutral,
  };
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value, this.tone = StatusTone.neutral});
  final String label;
  final int value;
  final StatusTone tone;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final color = switch (tone) {
      StatusTone.positive => s.primary,
      StatusTone.negative => s.error,
      StatusTone.warning => s.tertiary,
      StatusTone.neutral => s.onSurface,
    };
    return Container(
      width: 132,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: s.outlineVariant),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$value', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color)),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}

class _Notice extends StatelessWidget {
  const _Notice({required this.tone, required this.text});
  final StatusTone tone;
  final String text;

  @override
  Widget build(BuildContext context) {
    final s = Theme.of(context).colorScheme;
    final (bg, fg) = tone == StatusTone.negative
        ? (s.errorContainer, s.onErrorContainer)
        : (s.tertiaryContainer, s.onTertiaryContainer);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: TextStyle(color: fg)),
    );
  }
}
