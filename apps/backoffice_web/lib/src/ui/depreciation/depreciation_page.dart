import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/gateway.dart';
import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';
import '../common/paged_table.dart';
import '../work_orders/reason_dialog.dart';

/// Posição mensal da depreciação gerencial: por bem, centro de custo e
/// filial; fechamento em ordem e reabertura da última competência fechada.
class DepreciationPage extends ConsumerStatefulWidget {
  const DepreciationPage({super.key});

  @override
  ConsumerState<DepreciationPage> createState() => _DepreciationPageState();
}

enum _View { assets, costCenters, branches }

class _DepreciationPageState extends ConsumerState<DepreciationPage> {
  late int _year;
  late int _month;
  var _view = _View.assets;
  late Future<DepreciationPosition> _position;
  late Future<List<DepreciationClosing>> _closings;
  var _busy = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _year = now.year;
    _month = now.month;
    _load();
  }

  void _load() {
    final g = ref.read(gatewayProvider);
    _position = g.depreciationPosition(_year, _month);
    _closings = g.depreciationClosings();
  }

  void _move(int delta) => setState(() {
    final d = DateTime(_year, _month + delta);
    _year = d.year;
    _month = d.month;
    _load();
  });

  Future<void> _run(Future<void> Function(Gateway g) action, String done) async {
    setState(() => _busy = true);
    try {
      await action(ref.read(gatewayProvider));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
      setState(_load);
    } on GatewayException catch (e) {
      if (mounted) reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _close() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Fechar ${competence(_year, _month)}?'),
        content: const Text(
          'O fechamento guarda a posição de cada bem nesta competência. Mudanças posteriores na ficha não alteram '
          'meses fechados. Só a última competência fechada pode ser reaberta.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Voltar')),
          FilledButton(
            key: const Key('dep-close-confirm'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Fechar mês'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await _run((g) => g.closeDepreciation(_year, _month), 'Competência ${competence(_year, _month)} fechada.');
    }
  }

  Future<void> _reopen() async {
    final r = await showDialog<ReasonResult>(
      context: context,
      builder: (_) => ReasonDialog(
        title: 'Reabrir ${competence(_year, _month)}',
        confirmLabel: 'Reabrir',
        noteLabel: 'Motivo da reabertura',
        destructive: true,
      ),
    );
    if (r != null) {
      await _run((g) => g.reopenDepreciation(_year, _month, r.note), 'Competência reaberta.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final canClose = session is SignedIn && session.can('depreciation.close');
    return FutureBuilder<DepreciationPosition>(
      future: _position,
      builder: (context, snap) {
        final position = snap.data;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(
              title: 'Depreciação gerencial',
              filters: [
                IconButton(tooltip: 'Mês anterior', onPressed: () => _move(-1), icon: const Icon(Icons.chevron_left)),
                Text(competence(_year, _month), key: const Key('dep-period')),
                IconButton(tooltip: 'Próximo mês', onPressed: () => _move(1), icon: const Icon(Icons.chevron_right)),
                if (position != null)
                  Chip(
                    key: const Key('dep-status'),
                    avatar: Icon(position.closed ? Icons.lock : Icons.lock_open, size: 16),
                    label: Text(position.closed ? 'Fechada' : 'Aberta (cálculo do momento)'),
                  ),
              ],
              actions: [
                if (canClose && position != null && !position.closed)
                  FilledButton.icon(
                    key: const Key('dep-close'),
                    onPressed: _busy ? null : _close,
                    icon: const Icon(Icons.lock),
                    label: const Text('Fechar mês'),
                  ),
                if (canClose && position != null && position.closed)
                  OutlinedButton.icon(
                    key: const Key('dep-reopen'),
                    onPressed: _busy ? null : _reopen,
                    icon: const Icon(Icons.lock_open),
                    label: const Text('Reabrir'),
                  ),
              ],
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: () => setState(_load));
                  if (position == null) return const Center(child: CircularProgressIndicator());
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      _Totals(total: position.total),
                      const SizedBox(height: 16),
                      SegmentedButton<_View>(
                        segments: const [
                          ButtonSegment(value: _View.assets, label: Text('Por bem')),
                          ButtonSegment(value: _View.costCenters, label: Text('Por centro de custo')),
                          ButtonSegment(value: _View.branches, label: Text('Por filial')),
                        ],
                        selected: {_view},
                        onSelectionChanged: (s) => setState(() => _view = s.single),
                      ),
                      const SizedBox(height: 8),
                      if (position.items.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(24),
                          child: Text('Nenhum bem com ficha de depreciação nesta competência.'),
                        )
                      else
                        switch (_view) {
                          _View.assets => _AssetTable(items: position.items),
                          _View.costCenters => _GroupTable(groups: position.byCostCenter, title: 'Centro de custo'),
                          _View.branches => _GroupTable(groups: position.byBranch, title: 'Filial'),
                        },
                      const SizedBox(height: 24),
                      Text('Fechamentos', style: Theme.of(context).textTheme.titleMedium),
                      _ClosingList(future: _closings),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

class _Totals extends StatelessWidget {
  const _Totals({required this.total});

  final DepreciationGroupTotal total;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Widget tile(String label, String value, String key) => Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: theme.textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(value, key: Key(key), style: theme.textTheme.titleLarge),
          ],
        ),
      ),
    );
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        tile('Bens', '${total.assetCount}', 'dep-total-count'),
        tile('Custo', formatMoney(total.cost), 'dep-total-cost'),
        tile('Depreciação do mês', formatMoney(total.monthlyAmount), 'dep-total-month'),
        tile('Acumulada', formatMoney(total.accumulated), 'dep-total-accumulated'),
        tile('Valor contábil', formatMoney(total.netBookValue), 'dep-total-nbv'),
      ],
    );
  }
}

const _moneyColumns = [
  DataColumn(label: Text('Custo'), numeric: true),
  DataColumn(label: Text('Do mês'), numeric: true),
  DataColumn(label: Text('Acumulada'), numeric: true),
  DataColumn(label: Text('Valor contábil'), numeric: true),
];

class _AssetTable extends StatelessWidget {
  const _AssetTable({required this.items});

  final List<DepreciationPositionItem> items;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        columns: const [
          DataColumn(label: Text('Bem')),
          DataColumn(label: Text('Produto')),
          DataColumn(label: Text('Centro de custo')),
          ..._moneyColumns,
        ],
        rows: [
          for (final i in items)
            DataRow(
              key: ValueKey(i.assetId),
              onSelectChanged: (_) => context.go('/bens/${i.assetId}'),
              cells: [
                DataCell(Text(i.assetLabel, style: const TextStyle(fontWeight: FontWeight.w600))),
                DataCell(Text(i.productName)),
                DataCell(Text(i.costCenterName ?? '—')),
                DataCell(Text(formatMoney(i.cost))),
                DataCell(Text(formatMoney(i.monthlyAmount))),
                DataCell(Text(formatMoney(i.accumulated))),
                DataCell(Text(formatMoney(i.netBookValue))),
              ],
            ),
        ],
      ),
    );
  }
}

class _GroupTable extends StatelessWidget {
  const _GroupTable({required this.groups, required this.title});

  final List<DepreciationGroupTotal> groups;
  final String title;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columns: [
          DataColumn(label: Text(title)),
          const DataColumn(label: Text('Bens'), numeric: true),
          ..._moneyColumns,
        ],
        rows: [
          for (final g in groups)
            DataRow(
              cells: [
                DataCell(Text(g.name ?? 'Sem ${title.toLowerCase()}')),
                DataCell(Text('${g.assetCount}')),
                DataCell(Text(formatMoney(g.cost))),
                DataCell(Text(formatMoney(g.monthlyAmount))),
                DataCell(Text(formatMoney(g.accumulated))),
                DataCell(Text(formatMoney(g.netBookValue))),
              ],
            ),
        ],
      ),
    );
  }
}

class _ClosingList extends StatelessWidget {
  const _ClosingList({required this.future});

  final Future<List<DepreciationClosing>> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DepreciationClosing>>(
      future: future,
      builder: (context, snap) {
        if (snap.hasError) return Text(errorMessage(snap.error!));
        if (!snap.hasData) return const LinearProgressIndicator();
        if (snap.data!.isEmpty) return const Text('Nenhuma competência fechada ainda.');
        return Column(
          children: [
            for (final c in snap.data!)
              ListTile(
                key: ValueKey(c.id),
                dense: true,
                leading: Icon(c.status == 'closed' ? Icons.lock : Icons.lock_open),
                title: Text(
                  '${competence(c.year, c.month)} · ${c.status == 'closed' ? 'fechada' : 'reaberta'} · '
                  '${c.assetCount} bens · ${formatMoney(c.totalAmount)}',
                ),
                subtitle: Text(
                  [
                    'Fechada em ${formatDateTime(c.closedAt)}${c.closedByName == null ? '' : ' por ${c.closedByName}'}',
                    if (c.reopenedAt != null) 'reaberta em ${formatDateTime(c.reopenedAt)}: "${c.reopenReason}"',
                  ].join(' · '),
                ),
              ),
          ],
        );
      },
    );
  }
}
