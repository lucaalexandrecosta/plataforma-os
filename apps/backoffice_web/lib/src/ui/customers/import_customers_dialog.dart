import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/gateway.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/pick_file.dart';
import '../common/save_file.dart';
import 'spreadsheet.dart';

/// Importar clientes, unidades e contatos de uma planilha: baixa o modelo,
/// escolhe o arquivo, confere (sem gravar) e importa se não houver erro.
/// Fecha com `true` quando gravou.
class ImportCustomersDialog extends ConsumerStatefulWidget {
  const ImportCustomersDialog({super.key});

  @override
  ConsumerState<ImportCustomersDialog> createState() => _ImportCustomersDialogState();
}

class _ImportCustomersDialogState extends ConsumerState<ImportCustomersDialog> {
  static const _shownErrors = 100;

  String? _fileName;
  List<CustomerImportRow>? _rows;
  CustomerImportReport? _report;
  String? _readError;
  var _busy = false;

  Future<void> _template() async {
    await ref.read(saveFileProvider)('modelo-clientes.csv', 'text/csv', CustomerSpreadsheet.template());
  }

  Future<void> _choose() async {
    final file = await ref.read(pickFileProvider)('.csv,.xlsx,.txt');
    if (file == null || !mounted) return;
    setState(() {
      _fileName = file.name;
      _rows = null;
      _report = null;
      _readError = null;
    });
    try {
      final rows = CustomerSpreadsheet.read(file.name, file.bytes);
      if (rows.isEmpty) throw const FormatException('A planilha não tem linhas de dados.');
      setState(() => _rows = rows);
      await _send(dryRun: true);
    } on FormatException catch (e) {
      if (mounted) setState(() => _readError = e.message);
    }
  }

  Future<void> _send({required bool dryRun}) async {
    setState(() => _busy = true);
    try {
      final report = await ref.read(gatewayProvider).importCustomers(_rows!, dryRun: dryRun);
      if (!mounted) return;
      setState(() => _report = report);
      if (report.applied) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_summary(report, done: true))));
        Navigator.of(context).pop(true);
      }
    } on GatewayException catch (e) {
      if (mounted) reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  static String _summary(CustomerImportReport r, {required bool done}) {
    String part(int created, int existing, String singular, String plural) {
      final noun = created == 1 ? singular : plural;
      return existing == 0 ? '$created $noun' : '$created $noun ($existing já existiam)';
    }

    final verb = done ? 'Importados' : 'Serão criados';
    return '$verb: ${part(r.customersCreated, r.customersExisting, 'cliente', 'clientes')}, '
        '${part(r.sitesCreated, r.sitesExisting, 'unidade', 'unidades')} e '
        '${part(r.contactsCreated, r.contactsExisting, 'contato', 'contatos')}.';
  }

  @override
  Widget build(BuildContext context) {
    final report = _report;
    final theme = Theme.of(context);
    final ok = report != null && report.errors.isEmpty;
    return AlertDialog(
      title: const Text('Importar clientes'),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Uma linha por cliente, ou várias linhas do mesmo cliente (repetindo o código) para cadastrar '
                'mais de uma unidade ou contato. Cadastros que já existem não são alterados, então dá para '
                'importar o mesmo arquivo de novo sem duplicar.',
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    key: const Key('import-template'),
                    onPressed: _template,
                    icon: const Icon(Icons.download_outlined),
                    label: const Text('Baixar modelo (CSV)'),
                  ),
                  FilledButton.tonalIcon(
                    key: const Key('import-choose'),
                    onPressed: _busy ? null : _choose,
                    icon: const Icon(Icons.upload_file_outlined),
                    label: Text(_fileName == null ? 'Escolher arquivo (.csv ou .xlsx)' : 'Escolher outro arquivo'),
                  ),
                ],
              ),
              if (_fileName != null) ...[
                const SizedBox(height: 12),
                Text('Arquivo: $_fileName${_rows == null ? '' : ' · ${_rows!.length} linha(s)'}'),
              ],
              if (_readError != null) ...[
                const SizedBox(height: 8),
                Text(_readError!, style: TextStyle(color: theme.colorScheme.error)),
              ],
              if (_busy) const Padding(padding: EdgeInsets.only(top: 12), child: LinearProgressIndicator()),
              if (report != null && !_busy) ...[
                const SizedBox(height: 12),
                if (ok)
                  Text(_summary(report, done: false), key: const Key('import-summary'))
                else ...[
                  Text(
                    '${report.errors.length} problema(s). Corrija a planilha e escolha o arquivo de novo; '
                    'nada foi gravado.',
                    style: TextStyle(color: theme.colorScheme.error),
                  ),
                  const SizedBox(height: 8),
                  DataTable(
                    key: const Key('import-errors'),
                    headingRowHeight: 36,
                    dataRowMinHeight: 32,
                    dataRowMaxHeight: 56,
                    columns: const [
                      DataColumn(label: Text('Linha'), numeric: true),
                      DataColumn(label: Text('Coluna')),
                      DataColumn(label: Text('Problema')),
                    ],
                    rows: [
                      for (final e in report.errors.take(_shownErrors))
                        DataRow(
                          cells: [
                            DataCell(Text('${e.line}')),
                            DataCell(Text(e.column)),
                            DataCell(Text(e.message)),
                          ],
                        ),
                    ],
                  ),
                  if (report.errors.length > _shownErrors) Text('Mostrando $_shownErrors de ${report.errors.length}.'),
                ],
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(false), child: const Text('Fechar')),
        FilledButton(
          key: const Key('import-apply'),
          onPressed: ok && !_busy ? () => _send(dryRun: false) : null,
          child: const Text('Importar'),
        ),
      ],
    );
  }
}
