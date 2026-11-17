import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';
import '../common/status_chip.dart';
import 'profile_dialog.dart';

/// Depreciação gerencial na ficha do bem: a ficha e a memória de cálculo mês
/// a mês (a mesma conta da posição mensal).
class AssetDepreciationCard extends ConsumerStatefulWidget {
  const AssetDepreciationCard({super.key, required this.asset});

  final Asset asset;

  @override
  ConsumerState<AssetDepreciationCard> createState() => _AssetDepreciationCardState();
}

class _AssetDepreciationCardState extends ConsumerState<AssetDepreciationCard> {
  late Future<DepreciationProfile?> _profile;
  Future<AssetDepreciation>? _schedule;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _profile = ref.read(gatewayProvider).depreciationProfile(widget.asset.id);
    _schedule = null;
  }

  Future<void> _edit(DepreciationProfile? profile) async {
    final saved = await showDialog<DepreciationProfile>(
      context: context,
      builder: (_) => DepreciationProfileDialog(asset: widget.asset, profile: profile),
    );
    if (saved == null || !mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Ficha de depreciação salva.')));
    setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final canManage = session is SignedIn && session.can('depreciation.manage');
    final theme = Theme.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<DepreciationProfile?>(
          future: _profile,
          builder: (context, snap) {
            if (snap.hasError) return Text(errorMessage(snap.error!));
            if (snap.connectionState != ConnectionState.done) return const LinearProgressIndicator();
            final profile = snap.data;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(child: Text('Depreciação gerencial', style: theme.textTheme.titleMedium)),
                    if (canManage)
                      TextButton.icon(
                        key: const Key('dep-edit'),
                        onPressed: () => _edit(profile),
                        icon: Icon(profile == null ? Icons.add : Icons.edit),
                        label: Text(profile == null ? 'Configurar' : 'Editar'),
                      ),
                  ],
                ),
                if (profile == null)
                  const Text('Este bem ainda não tem ficha de depreciação.')
                else ...[
                  FieldRow('Método', label(depreciationMethodLabels, profile.method)),
                  if (profile.method == 'units_of_production')
                    FieldRow(
                      'Capacidade / produção',
                      '${profile.totalCapacity?.replaceAll('.', ',')} / ${profile.monthlyProduction?.replaceAll('.', ',')} por mês',
                    )
                  else
                    FieldRow('Taxa anual', '${profile.annualRate.replaceAll('.', ',')}%'),
                  FieldRow(
                    'Início',
                    '${formatDate(profile.startDate)} · ${label(depreciationStartRuleLabels, profile.startRule)}',
                  ),
                  FieldRow('Base de cálculo', formatMoney(profile.effectiveCost)),
                  FieldRow('Valor residual', formatMoney(profile.residualValue)),
                  if (profile.notes != null) FieldRow('Observações', profile.notes),
                  const SizedBox(height: 8),
                  if (_schedule == null)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: OutlinedButton.icon(
                        key: const Key('dep-schedule'),
                        onPressed: () => setState(() {
                          _schedule = ref.read(gatewayProvider).depreciationSchedule(widget.asset.id);
                        }),
                        icon: const Icon(Icons.table_rows_outlined),
                        label: const Text('Ver memória de cálculo'),
                      ),
                    )
                  else
                    _ScheduleTable(future: _schedule!),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ScheduleTable extends StatelessWidget {
  const _ScheduleTable({required this.future});

  final Future<AssetDepreciation> future;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AssetDepreciation>(
      future: future,
      builder: (context, snap) {
        if (snap.hasError) return Text(errorMessage(snap.error!));
        if (!snap.hasData) return const LinearProgressIndicator();
        final lines = snap.data!.lines;
        final now = DateTime.now();
        return ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 420),
          child: SingleChildScrollView(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowHeight: 40,
                dataRowMinHeight: 32,
                dataRowMaxHeight: 36,
                columns: const [
                  DataColumn(label: Text('Competência')),
                  DataColumn(label: Text('Cota'), numeric: true),
                  DataColumn(label: Text('Acumulada'), numeric: true),
                  DataColumn(label: Text('Valor contábil'), numeric: true),
                  DataColumn(label: Text('Regra')),
                ],
                rows: [
                  for (final l in lines)
                    DataRow(
                      selected: l.year == now.year && l.month == now.month,
                      cells: [
                        DataCell(
                          Text('${l.month.toString().padLeft(2, '0')}/${l.year}${l.disposed ? ' (baixa)' : ''}'),
                        ),
                        DataCell(Text(formatMoney(l.amount))),
                        DataCell(Text(formatMoney(l.accumulated))),
                        DataCell(Text(formatMoney(l.netBookValue))),
                        DataCell(Text(l.rule)),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
