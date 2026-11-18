import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';
import '../common/status_chip.dart';
import '../depreciation/asset_depreciation_card.dart';
import '../qr_tags/asset_tag_actions.dart';
import '../work_orders/open_work_order_dialog.dart';
import 'asset_dialog.dart';
import 'asset_movement_dialogs.dart';

/// Ficha do bem: dados, aquisição e as OS do bem, com "Abrir OS".
class AssetDetailPage extends ConsumerStatefulWidget {
  const AssetDetailPage({super.key, required this.id});

  final UuidValue id;

  @override
  ConsumerState<AssetDetailPage> createState() => _AssetDetailPageState();
}

typedef _AssetView = ({Asset asset, Map<UuidValue, Branch> branches, Map<UuidValue, CostCenter> costCenters});

class _AssetDetailPageState extends ConsumerState<AssetDetailPage> {
  late Future<_AssetView> _view;
  late Future<WorkOrderPage> _orders;
  late Future<List<AssetAssignment>> _history;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(AssetDetailPage old) {
    super.didUpdateWidget(old);
    if (old.id != widget.id) setState(_load);
  }

  void _load() {
    final g = ref.read(gatewayProvider);
    _view = () async {
      // Future.wait trata os três erros e repassa o primeiro.
      final results = await Future.wait<Object>([g.asset(widget.id), g.branches(), g.costCenters()]);
      final asset = results[0] as Asset;
      final branches = results[1] as List<Branch>;
      final costCenters = results[2] as List<CostCenter>;
      return (
        asset: asset,
        branches: {for (final b in branches) b.id: b},
        costCenters: {for (final c in costCenters) c.id: c},
      );
    }();
    _orders = g.workOrders(assetId: widget.id, limit: 20);
    _history = g.assetAssignments(widget.id);
  }

  Future<void> _openWorkOrder(Asset asset) async {
    final created = await showDialog<WorkOrderDetail>(
      context: context,
      builder: (_) => OpenWorkOrderDialog(asset: asset),
    );
    if (created != null && mounted) context.go('/os/${created.workOrder.id}');
  }

  Future<void> _move(Widget dialog) async {
    final saved = await showDialog<Asset>(context: context, builder: (_) => dialog);
    if (saved != null && mounted) setState(_load);
  }

  Future<void> _edit(Asset asset) async {
    final saved = await showDialog<Asset>(
      context: context,
      builder: (_) => AssetDialog(asset: asset),
    );
    if (saved != null && mounted) setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final canCreate = session is SignedIn && session.can('work_orders.create');
    final canManage = session is SignedIn && session.can('assets.manage');
    return FutureBuilder<_AssetView>(
      future: _view,
      builder: (context, snap) {
        if (snap.hasError) {
          return ErrorPanel(error: snap.error!, onRetry: () => setState(_load));
        }
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final (:asset, :branches, :costCenters) = snap.data!;
        final theme = Theme.of(context);
        final branch = branches[asset.branchId];
        final costCenter = costCenters[asset.costCenterId];
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Voltar à lista',
                  onPressed: () => context.go('/bens'),
                  icon: const Icon(Icons.arrow_back),
                ),
                Text(
                  asset.assetTag ?? asset.serialNumber ?? 'Bem sem patrimônio',
                  style: theme.textTheme.headlineSmall,
                ),
                Text(asset.productName, style: theme.textTheme.titleMedium),
                if (canManage)
                  OutlinedButton.icon(
                    key: const Key('asset-edit'),
                    onPressed: () => _edit(asset),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar'),
                  ),
                if (canManage && asset.isActive && asset.status != 'retired')
                  OutlinedButton.icon(
                    key: const Key('asset-install'),
                    onPressed: () => _move(InstallAssetDialog(asset: asset)),
                    icon: const Icon(Icons.local_shipping_outlined),
                    label: Text(asset.customerSiteId == null ? 'Instalar no cliente' : 'Transferir'),
                  ),
                if (canManage && asset.customerSiteId != null)
                  OutlinedButton.icon(
                    key: const Key('asset-withdraw'),
                    onPressed: () => _move(WithdrawAssetDialog(asset: asset)),
                    icon: const Icon(Icons.undo),
                    label: const Text('Retirar'),
                  ),
                if (canCreate && asset.status != 'retired' && asset.isActive)
                  FilledButton.icon(
                    key: const Key('asset-open-wo'),
                    onPressed: () => _openWorkOrder(asset),
                    icon: const Icon(Icons.add),
                    label: const Text('Abrir OS'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FieldRow('Situação', asset.isActive ? label(assetStatusLabels, asset.status) : 'Inativo'),
                    FieldRow(
                      'Cliente',
                      asset.customerName == null ? 'No estoque' : '${asset.customerName} · ${asset.customerSiteName}',
                    ),
                    if (asset.customerId != null)
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton(
                          key: const Key('asset-open-customer'),
                          onPressed: () => context.go('/clientes/${asset.customerId}'),
                          child: const Text('Abrir ficha do cliente'),
                        ),
                      ),
                    FieldRow('Propriedade', label(ownershipLabels, asset.ownershipType)),
                    FieldRow('Número de série', asset.serialNumber),
                    FieldRow('Etiqueta QR', asset.qrShortCode),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: AssetTagActions(asset: asset, onChanged: () => setState(_load)),
                    ),
                    FieldRow(
                      'Filial',
                      branch == null ? null : '${branch.code} · ${branch.tradeName ?? branch.legalName}',
                    ),
                    FieldRow('Centro de custo', costCenter == null ? null : '${costCenter.code} · ${costCenter.name}'),
                    FieldRow('Localização', asset.locationNote),
                    FieldRow('Aquisição', formatDate(asset.acquisitionDate)),
                    FieldRow('Custo de aquisição', formatMoney(asset.acquisitionCost)),
                    FieldRow('Fornecedor', asset.supplierName),
                    FieldRow('Documento', asset.acquisitionDocument),
                    FieldRow('Garantia até', formatDate(asset.warrantyUntil)),
                    FieldRow('Observações', asset.notes),
                    if (asset.source == 'erp') const FieldRow('Origem', 'ERP (campos mestres só leitura)'),
                  ],
                ),
              ),
            ),
            if (session is SignedIn && session.can('depreciation.read')) ...[
              const SizedBox(height: 16),
              AssetDepreciationCard(asset: asset),
            ],
            const SizedBox(height: 16),
            Text('Onde o bem esteve', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            FutureBuilder<List<AssetAssignment>>(
              future: _history,
              builder: (context, snap) {
                if (snap.hasError) return Text(errorMessage(snap.error!));
                if (!snap.hasData) return const LinearProgressIndicator();
                if (snap.data!.isEmpty) return const Text('Nunca foi instalado em cliente.');
                return Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (final h in snap.data!)
                        ListTile(
                          key: ValueKey(h.id),
                          leading: Icon(h.endedAt == null ? Icons.place : Icons.history),
                          title: Text('${h.customerName} · ${h.customerSiteName}'),
                          subtitle: Text(
                            [
                              '${label(assignmentStartLabels, h.startReason)} em ${formatDateTime(h.startedAt)}',
                              if (h.endedAt != null)
                                '${label(assignmentEndLabels, h.endReason)} em ${formatDateTime(h.endedAt)}'
                              else
                                'Atual',
                              if (h.sourceDocumentNumber != null)
                                '${label(movementDocumentLabels, h.sourceDocumentType)} ${h.sourceDocumentNumber}',
                              if (h.notes != null) h.notes!,
                            ].join(' · '),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            Text('Ordens de serviço do bem', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            FutureBuilder<WorkOrderPage>(
              future: _orders,
              builder: (context, snap) {
                if (snap.hasError) return Text(errorMessage(snap.error!));
                if (!snap.hasData) return const LinearProgressIndicator();
                final page = snap.data!;
                if (page.items.isEmpty) return const Text('Nenhuma OS para este bem.');
                return Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (final wo in page.items)
                        ListTile(
                          key: ValueKey(wo.id),
                          title: Text('OS ${wo.number} · ${wo.workOrderTypeName}'),
                          subtitle: Text(formatDateTime(wo.createdAt)),
                          trailing: WorkOrderStatusChip(wo.status),
                          onTap: () => context.go('/os/${wo.id}'),
                        ),
                      if (page.total > page.items.length)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('Mostrando ${page.items.length} de ${page.total}.'),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
