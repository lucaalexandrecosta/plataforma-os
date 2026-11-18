import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/paged_table.dart';

/// Modelos de checklist: rascunhos, publicados e, se pedido, arquivados.
class ChecklistsPage extends ConsumerStatefulWidget {
  const ChecklistsPage({super.key});

  @override
  ConsumerState<ChecklistsPage> createState() => _ChecklistsPageState();
}

class _ChecklistsPageState extends ConsumerState<ChecklistsPage> {
  var _archived = false;
  late Future<List<ChecklistTemplate>> _list;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _list = ref.read(gatewayProvider).checklists(includeArchived: _archived);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final canManage = session is SignedIn && session.can('catalog.manage');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Checklists',
          filters: [
            FilterChip(
              key: const Key('checklist-archived'),
              label: const Text('Mostrar arquivados'),
              selected: _archived,
              onSelected: (v) => setState(() {
                _archived = v;
                _load();
              }),
            ),
          ],
          actions: [
            if (canManage)
              FilledButton.icon(
                key: const Key('checklist-new'),
                onPressed: () => context.go('/checklists/novo'),
                icon: const Icon(Icons.add),
                label: const Text('Novo checklist'),
              ),
          ],
        ),
        Expanded(
          child: FutureBuilder<List<ChecklistTemplate>>(
            future: _list,
            builder: (context, snap) {
              if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: () => setState(_load));
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final list = snap.data!;
              if (list.isEmpty) {
                return const Center(
                  child: Text('Nenhum checklist. Crie um e ligue ao tipo de OS em Cadastros › Tipos de OS.'),
                );
              }
              return SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(label: Text('Nome')),
                      DataColumn(label: Text('Código')),
                      DataColumn(label: Text('Versão'), numeric: true),
                      DataColumn(label: Text('Itens'), numeric: true),
                      DataColumn(label: Text('Situação')),
                    ],
                    rows: [
                      for (final t in list)
                        DataRow(
                          key: ValueKey(t.id),
                          onSelectChanged: (_) => context.go('/checklists/${t.id}'),
                          cells: [
                            DataCell(Text(t.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text(t.code)),
                            DataCell(Text('${t.templateVersion}')),
                            DataCell(Text('${t.items.length}')),
                            DataCell(Text(checklistStatusLabels[t.status] ?? t.status)),
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
