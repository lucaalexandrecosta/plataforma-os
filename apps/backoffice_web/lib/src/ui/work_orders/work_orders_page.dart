import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';
import '../common/paged_table.dart';
import '../common/status_chip.dart';
import 'open_work_order_dialog.dart';

/// Lista de OS com busca (número, patrimônio, série, descrição) e filtro de
/// status; "Em aberto" é o padrão.
class WorkOrdersPage extends ConsumerStatefulWidget {
  const WorkOrdersPage({super.key});

  @override
  ConsumerState<WorkOrdersPage> createState() => _WorkOrdersPageState();
}

/// Filtro de status: em aberto, todas ou um status (os dois primeiros com
/// prefixo para não colidir com o status `open`).
const _openFilter = '*open';
const _allFilter = '*all';

class _WorkOrdersPageState extends ConsumerState<WorkOrdersPage> {
  final _search = TextEditingController();
  var _status = _openFilter;
  var _offset = 0;
  late Future<WorkOrderPage> _page;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _load() {
    _page = ref
        .read(gatewayProvider)
        .workOrders(
          search: _search.text,
          openOnly: _status == _openFilter,
          statuses: _status == _openFilter || _status == _allFilter ? null : [_status],
          limit: PagerBar.pageSize,
          offset: _offset,
        );
  }

  void _reload({bool resetPage = true}) => setState(() {
    if (resetPage) _offset = 0;
    _load();
  });

  Future<void> _open() async {
    final created = await showDialog<WorkOrderDetail>(context: context, builder: (_) => const OpenWorkOrderDialog());
    if (created != null && mounted) context.go('/os/${created.workOrder.id}');
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final canCreate = session is SignedIn && session.can('work_orders.create');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Ordens de serviço',
          filters: [
            SizedBox(
              width: 320,
              child: TextField(
                key: const Key('wo-search'),
                controller: _search,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Número, patrimônio, série ou descrição',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _reload(),
              ),
            ),
            DropdownButton<String>(
              key: const Key('wo-status'),
              value: _status,
              onChanged: (v) {
                _status = v!;
                _reload();
              },
              items: [
                const DropdownMenuItem(value: _openFilter, child: Text('Em aberto')),
                const DropdownMenuItem(value: _allFilter, child: Text('Todas')),
                for (final e in workOrderStatusLabels.entries) DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
            ),
            IconButton(
              tooltip: 'Atualizar',
              onPressed: () => _reload(resetPage: false),
              icon: const Icon(Icons.refresh),
            ),
          ],
          actions: [
            if (canCreate)
              FilledButton.icon(
                key: const Key('wo-open'),
                onPressed: _open,
                icon: const Icon(Icons.add),
                label: const Text('Abrir OS'),
              ),
          ],
        ),
        Expanded(
          child: FutureBuilder<WorkOrderPage>(
            future: _page,
            builder: (context, snap) {
              if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: () => _reload(resetPage: false));
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final page = snap.data!;
              if (page.items.isEmpty) {
                return const Center(child: Text('Nenhuma OS encontrada com esses filtros.'));
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: _WorkOrderTable(items: page.items)),
                  PagerBar(
                    offset: _offset,
                    count: page.items.length,
                    total: page.total,
                    onPage: (o) => setState(() {
                      _offset = o;
                      _load();
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _WorkOrderTable extends StatelessWidget {
  const _WorkOrderTable({required this.items});

  final List<WorkOrder> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: Text('Número')),
            DataColumn(label: Text('Status')),
            DataColumn(label: Text('Prioridade')),
            DataColumn(label: Text('Tipo')),
            DataColumn(label: Text('Bem')),
            DataColumn(label: Text('Centro de custo')),
            DataColumn(label: Text('Aberta em')),
          ],
          rows: [
            for (final wo in items)
              DataRow(
                key: ValueKey(wo.id),
                onSelectChanged: (_) => context.go('/os/${wo.id}'),
                cells: [
                  DataCell(Text(wo.number, style: const TextStyle(fontWeight: FontWeight.w600))),
                  DataCell(WorkOrderStatusChip(wo.status)),
                  DataCell(Text(label(priorityLabels, wo.priority))),
                  DataCell(Text(wo.workOrderTypeName)),
                  DataCell(Text([wo.assetLabel, wo.productName].whereType<String>().join(' · '))),
                  DataCell(Text(wo.costCenterName ?? '—')),
                  DataCell(Text(formatDateTime(wo.createdAt))),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
