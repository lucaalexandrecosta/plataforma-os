import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../api/gateway.dart';
import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';

/// Cadastro e edição do bem (`assets.manage`). Bem que veio do ERP só muda
/// os campos locais: produto, série, patrimônio, filial e aquisição ficam
/// travados (o servidor também recusa).
class AssetDialog extends ConsumerStatefulWidget {
  const AssetDialog({super.key, this.asset});

  final Asset? asset;

  @override
  ConsumerState<AssetDialog> createState() => _AssetDialogState();
}

typedef _Options = ({List<ProductSummary> products, List<Branch> branches, List<CostCenter> costCenters});

class _AssetDialogState extends ConsumerState<AssetDialog> {
  final _form = GlobalKey<FormState>();
  late final Future<_Options> _options;
  late final _serial = TextEditingController(text: widget.asset?.serialNumber);
  late final _tag = TextEditingController(text: widget.asset?.assetTag);
  late final _location = TextEditingController(text: widget.asset?.locationNote);
  late final _cost = TextEditingController(text: moneyField(widget.asset?.acquisitionCost));
  late final _supplier = TextEditingController(text: widget.asset?.supplierName);
  late final _document = TextEditingController(text: widget.asset?.acquisitionDocument);
  late final _notes = TextEditingController(text: widget.asset?.notes);
  late UuidValue? _productId = widget.asset?.productId;
  late UuidValue? _branchId = widget.asset?.branchId;
  late UuidValue? _costCenterId = widget.asset?.costCenterId;
  late var _ownership = widget.asset?.ownershipType ?? 'tenant_loan';
  late DateTime? _acquisitionDate = widget.asset?.acquisitionDate?.toLocal();
  late DateTime? _warrantyUntil = widget.asset?.warrantyUntil?.toLocal();
  late var _active = widget.asset?.isActive ?? true;
  var _busy = false;
  Map<String, String> _fieldErrors = const {};

  bool get _erp => widget.asset?.source == 'erp';

  @override
  void initState() {
    super.initState();
    final g = ref.read(gatewayProvider);
    _options = () async {
      final products = g.products();
      final branches = g.branches();
      final costCenters = await g.costCenters();
      return (products: await products, branches: await branches, costCenters: costCenters);
    }();
  }

  @override
  void dispose() {
    for (final c in [_serial, _tag, _location, _cost, _supplier, _document, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _clean(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  /// Meio-dia UTC: a data não muda de dia em nenhum fuso do Brasil.
  static DateTime? _date(DateTime? d) => d == null ? null : DateTime.utc(d.year, d.month, d.day, 12);

  Future<void> _submit() async {
    final ok = _form.currentState!.validate();
    if (!ok) return;
    setState(() {
      _busy = true;
      _fieldErrors = const {};
    });
    final input = AssetInput(
      productId: _productId!,
      serialNumber: _clean(_serial),
      assetTag: _clean(_tag),
      ownershipType: _ownership,
      branchId: _branchId,
      costCenterId: _costCenterId,
      locationNote: _clean(_location),
      warrantyUntil: _date(_warrantyUntil),
      acquisitionDate: _date(_acquisitionDate),
      acquisitionCost: _cost.text.trim().isEmpty ? null : parseMoney(_cost.text),
      supplierName: _clean(_supplier),
      acquisitionDocument: _clean(_document),
      notes: _clean(_notes),
      isActive: _active,
    );
    final g = ref.read(gatewayProvider);
    final current = widget.asset;
    try {
      final saved = current == null ? await g.createAsset(input) : await g.updateAsset(current, input);
      if (mounted) Navigator.of(context).pop(saved);
    } on GatewayException catch (e) {
      if (!mounted) return;
      setState(() => _fieldErrors = e.fieldErrors);
      reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  InputDecoration _deco(String label, String field, {String? hint, String? helper}) => InputDecoration(
    labelText: label,
    hintText: hint,
    helperText: helper,
    border: const OutlineInputBorder(),
    errorText: _fieldErrors[field],
  );

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.asset == null ? 'Novo bem' : 'Editar bem'),
      content: SizedBox(
        width: 640,
        child: FutureBuilder<_Options>(
          future: _options,
          builder: (context, snap) {
            if (snap.hasError) return Text(errorMessage(snap.error!));
            if (!snap.hasData) return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
            return SingleChildScrollView(child: _fields(snap.data!));
          },
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(key: const Key('asset-save'), onPressed: _busy ? null : _submit, child: const Text('Salvar')),
      ],
    );
  }

  Widget _fields(_Options o) {
    final erp = _erp;
    // Centros da filial escolhida e os que valem para todas.
    final costCenters = [
      for (final c in o.costCenters)
        if (c.branchId == null || _branchId == null || c.branchId == _branchId) c,
    ];
    Widget pair(Widget a, Widget b) => Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: a),
        const SizedBox(width: 12),
        Expanded(child: b),
      ],
    );
    return Form(
      key: _form,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (erp)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text('Bem do ERP: produto, série, patrimônio, filial e aquisição só mudam lá.'),
            ),
          DropdownButtonFormField<UuidValue>(
            key: const Key('asset-product'),
            initialValue: _productId,
            isExpanded: true,
            decoration: _deco('Equipamento', 'productId'),
            items: [
              for (final p in o.products) DropdownMenuItem(value: p.id, child: Text('${p.code} · ${p.name}')),
              // Produto inativo do bem em edição continua aparecendo.
              if (widget.asset != null && !o.products.any((p) => p.id == widget.asset!.productId))
                DropdownMenuItem(value: widget.asset!.productId, child: Text(widget.asset!.productName)),
            ],
            onChanged: erp ? null : (v) => setState(() => _productId = v),
            validator: (v) => v == null ? 'Escolha o equipamento.' : null,
          ),
          const SizedBox(height: 12),
          pair(
            TextFormField(
              key: const Key('asset-tag'),
              controller: _tag,
              enabled: !erp,
              decoration: _deco('Número de patrimônio', 'assetTag', hint: 'PAT-001'),
              validator: (v) =>
                  (v ?? '').trim().isEmpty && _serial.text.trim().isEmpty ? 'Informe o patrimônio ou a série.' : null,
            ),
            TextFormField(
              key: const Key('asset-serial'),
              controller: _serial,
              enabled: !erp,
              decoration: _deco('Número de série', 'serialNumber'),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            key: const Key('asset-ownership'),
            initialValue: _ownership,
            decoration: _deco('Posse', 'ownershipType'),
            items: [
              for (final e in ownershipLabels.entries) DropdownMenuItem(value: e.key, child: Text(e.value)),
            ],
            onChanged: (v) => setState(() => _ownership = v!),
          ),
          const SizedBox(height: 12),
          pair(
            DropdownButtonFormField<UuidValue?>(
              key: const Key('asset-branch'),
              initialValue: _branchId,
              isExpanded: true,
              decoration: _deco('Filial', 'branchId'),
              items: [
                const DropdownMenuItem(value: null, child: Text('—')),
                for (final b in o.branches)
                  DropdownMenuItem(value: b.id, child: Text('${b.code} · ${b.tradeName ?? b.legalName}')),
              ],
              onChanged: erp
                  ? null
                  : (v) => setState(() {
                      _branchId = v;
                      final cc = o.costCenters.where((c) => c.id == _costCenterId).firstOrNull;
                      if (cc?.branchId != null && v != null && cc!.branchId != v) _costCenterId = null;
                    }),
            ),
            DropdownButtonFormField<UuidValue?>(
              key: ValueKey('asset-cost-center-$_branchId'),
              initialValue: costCenters.any((c) => c.id == _costCenterId) ? _costCenterId : null,
              isExpanded: true,
              decoration: _deco('Centro de custo', 'costCenterId'),
              items: [
                const DropdownMenuItem(value: null, child: Text('—')),
                for (final c in costCenters) DropdownMenuItem(value: c.id, child: Text('${c.code} · ${c.name}')),
              ],
              onChanged: (v) => setState(() => _costCenterId = v),
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _location,
            decoration: _deco('Localização', 'locationNote', hint: 'Depósito, corredor 3'),
          ),
          const SizedBox(height: 16),
          Text('Aquisição', style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          pair(
            _DateField(
              fieldKey: 'asset-acquired',
              label: 'Data de aquisição',
              value: _acquisitionDate,
              enabled: !erp,
              error: _fieldErrors['acquisitionDate'],
              onChanged: (v) => setState(() => _acquisitionDate = v),
            ),
            TextFormField(
              key: const Key('asset-cost'),
              controller: _cost,
              enabled: !erp,
              decoration: _deco('Valor (R\$)', 'acquisitionCost', hint: '1.234,56'),
              validator: (v) =>
                  (v ?? '').trim().isEmpty || parseMoney(v!) != null ? null : 'Valor inválido (ex.: 1.234,56).',
            ),
          ),
          const SizedBox(height: 12),
          pair(
            TextFormField(
              controller: _supplier,
              enabled: !erp,
              decoration: _deco('Fornecedor', 'supplierName'),
            ),
            TextFormField(
              controller: _document,
              enabled: !erp,
              decoration: _deco('Documento (NF)', 'acquisitionDocument'),
            ),
          ),
          const SizedBox(height: 12),
          _DateField(
            fieldKey: 'asset-warranty',
            label: 'Garantia até',
            value: _warrantyUntil,
            error: _fieldErrors['warrantyUntil'],
            onChanged: (v) => setState(() => _warrantyUntil = v),
          ),
          const SizedBox(height: 12),
          TextFormField(controller: _notes, maxLines: 3, decoration: _deco('Observações', 'notes')),
          SwitchListTile(
            key: const Key('asset-active'),
            contentPadding: EdgeInsets.zero,
            title: const Text('Ativo'),
            value: _active,
            onChanged: (v) => setState(() => _active = v),
          ),
        ],
      ),
    );
  }
}

/// Data opcional: toque abre o calendário; o "x" limpa.
class _DateField extends StatelessWidget {
  const _DateField({
    required this.fieldKey,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
    this.error,
  });

  final String fieldKey;
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;
  final bool enabled;
  final String? error;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      key: Key(fieldKey),
      onTap: !enabled
          ? null
          : () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: value ?? DateTime.now(),
                firstDate: DateTime(1980),
                lastDate: DateTime(DateTime.now().year + 15, 12, 31),
              );
              if (picked != null) onChanged(picked);
            },
      child: InputDecorator(
        isEmpty: value == null,
        decoration: InputDecoration(
          labelText: label,
          enabled: enabled,
          errorText: error,
          border: const OutlineInputBorder(),
          suffixIcon: value == null || !enabled
              ? const Icon(Icons.calendar_today, size: 18)
              : IconButton(
                  key: Key('$fieldKey-clear'),
                  tooltip: 'Limpar',
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () => onChanged(null),
                ),
        ),
        child: Text(value == null ? '' : formatDate(value)),
      ),
    );
  }
}
