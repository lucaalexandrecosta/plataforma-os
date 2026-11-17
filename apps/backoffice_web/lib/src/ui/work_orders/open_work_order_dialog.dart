import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/gateway.dart';
import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';

/// Abertura de OS pelo backoffice: bem escolhido na lista (busca) ou pelo
/// código da etiqueta. Filial, centro de custo e cliente vêm do bem.
class OpenWorkOrderDialog extends ConsumerStatefulWidget {
  const OpenWorkOrderDialog({super.key, this.asset});

  /// Bem já escolhido (abertura a partir da ficha do bem).
  final Asset? asset;

  @override
  ConsumerState<OpenWorkOrderDialog> createState() => _OpenWorkOrderDialogState();
}

enum _AssetBy { list, tag }

class _OpenWorkOrderDialogState extends ConsumerState<OpenWorkOrderDialog> {
  final _form = GlobalKey<FormState>();
  final _tag = TextEditingController();
  final _problem = TextEditingController();
  final _requester = TextEditingController();
  final _phone = TextEditingController();
  late final Future<List<WorkOrderType>> _types = ref.read(gatewayProvider).workOrderTypes();
  WorkOrderType? _type;
  Asset? _asset;
  var _assetBy = _AssetBy.list;
  String? _priority;
  var _busy = false;
  Map<String, String> _fieldErrors = const {};

  @override
  void initState() {
    super.initState();
    _asset = widget.asset;
  }

  @override
  void dispose() {
    for (final c in [_tag, _problem, _requester, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _fieldErrors = const {};
    });
    try {
      final byTag = _assetBy == _AssetBy.tag && widget.asset == null;
      final created = await ref
          .read(gatewayProvider)
          .openWorkOrder(
            WorkOrderInput(
              workOrderTypeId: _type!.id,
              assetId: byTag ? null : _asset?.id,
              scannedCode: byTag && _tag.text.trim().isNotEmpty ? _tag.text.trim() : null,
              priority: _priority,
              problemDescription: _blankToNull(_problem.text),
              requesterName: _blankToNull(_requester.text),
              requesterPhone: _blankToNull(_phone.text),
            ),
          );
      if (mounted) Navigator.of(context).pop(created);
    } on GatewayException catch (e) {
      if (!mounted) return;
      setState(() => _fieldErrors = e.fieldErrors);
      reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Abrir OS'),
      content: SizedBox(
        width: 520,
        child: FutureBuilder<List<WorkOrderType>>(
          future: _types,
          builder: (context, snap) {
            if (snap.hasError) return Text(errorMessage(snap.error!));
            if (!snap.hasData) return const SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
            final types = snap.data!.where((t) => t.isActive).toList();
            return Form(
              key: _form,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<WorkOrderType>(
                      key: const Key('wo-type'),
                      initialValue: _type,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Tipo de OS', border: OutlineInputBorder()),
                      items: [for (final t in types) DropdownMenuItem(value: t, child: Text('${t.code} · ${t.name}'))],
                      onChanged: (t) => setState(() => _type = t),
                      validator: (t) => t == null ? 'Escolha o tipo.' : null,
                    ),
                    const SizedBox(height: 16),
                    if (widget.asset != null)
                      InputDecorator(
                        decoration: const InputDecoration(labelText: 'Bem', border: OutlineInputBorder()),
                        child: Text(_assetTitle(widget.asset!)),
                      )
                    else ...[
                      SegmentedButton<_AssetBy>(
                        segments: const [
                          ButtonSegment(value: _AssetBy.list, label: Text('Buscar o bem'), icon: Icon(Icons.search)),
                          ButtonSegment(
                            value: _AssetBy.tag,
                            label: Text('Código da etiqueta'),
                            icon: Icon(Icons.qr_code),
                          ),
                        ],
                        selected: {_assetBy},
                        onSelectionChanged: (s) => setState(() => _assetBy = s.single),
                      ),
                      const SizedBox(height: 12),
                      if (_assetBy == _AssetBy.list)
                        _AssetPicker(
                          selected: _asset,
                          onSelected: (a) => setState(() => _asset = a),
                          errorText: _fieldErrors['assetId'],
                          required: _type?.requiresAsset ?? false,
                        )
                      else
                        TextFormField(
                          key: const Key('wo-tag'),
                          controller: _tag,
                          decoration: InputDecoration(
                            labelText: 'Código da etiqueta ou endereço do QR',
                            hintText: 'ABCD-2345',
                            border: const OutlineInputBorder(),
                            errorText: _fieldErrors['scannedCode'],
                          ),
                          validator: (v) => (_type?.requiresAsset ?? false) && (v == null || v.trim().isEmpty)
                              ? 'Este tipo de OS exige o bem.'
                              : null,
                        ),
                    ],
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String?>(
                      key: const Key('wo-priority'),
                      initialValue: _priority,
                      isExpanded: true,
                      decoration: const InputDecoration(labelText: 'Prioridade', border: OutlineInputBorder()),
                      items: [
                        DropdownMenuItem(
                          value: null,
                          child: Text(
                            _type == null
                                ? 'Padrão do tipo'
                                : 'Padrão do tipo (${label(priorityLabels, _type!.defaultPriority)})',
                          ),
                        ),
                        for (final e in priorityLabels.entries) DropdownMenuItem(value: e.key, child: Text(e.value)),
                      ],
                      onChanged: (p) => setState(() => _priority = p),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('wo-problem'),
                      controller: _problem,
                      minLines: 2,
                      maxLines: 5,
                      decoration: InputDecoration(
                        labelText: 'Problema relatado',
                        border: const OutlineInputBorder(),
                        errorText: _fieldErrors['problemDescription'],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _requester,
                            decoration: const InputDecoration(labelText: 'Solicitante', border: OutlineInputBorder()),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _phone,
                            decoration: InputDecoration(
                              labelText: 'Telefone do solicitante',
                              border: const OutlineInputBorder(),
                              errorText: _fieldErrors['requesterPhone'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(key: const Key('wo-open-submit'), onPressed: _busy ? null : _submit, child: const Text('Abrir')),
      ],
    );
  }
}

String _assetTitle(Asset a) => [a.assetTag ?? a.serialNumber ?? 'Sem patrimônio', a.productName].join(' · ');

String? _blankToNull(String text) => text.trim().isEmpty ? null : text.trim();

/// Busca de bem por patrimônio, série ou produto.
class _AssetPicker extends ConsumerWidget {
  const _AssetPicker({required this.selected, required this.onSelected, required this.required, this.errorText});

  final Asset? selected;
  final ValueChanged<Asset?> onSelected;
  final bool required;
  final String? errorText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FormField<Asset>(
      initialValue: selected,
      validator: (_) => required && selected == null ? 'Este tipo de OS exige o bem.' : null,
      builder: (field) => Autocomplete<Asset>(
        displayStringForOption: _assetTitle,
        initialValue: selected == null ? null : TextEditingValue(text: _assetTitle(selected!)),
        optionsBuilder: (value) async {
          final text = value.text.trim();
          if (text.length < 2) return const <Asset>[];
          try {
            return (await ref.read(gatewayProvider).assets(search: text, limit: 10)).items;
          } on GatewayException {
            return const <Asset>[];
          }
        },
        onSelected: (a) {
          field.didChange(a);
          onSelected(a);
        },
        fieldViewBuilder: (context, controller, focus, onSubmit) => TextField(
          key: const Key('wo-asset'),
          controller: controller,
          focusNode: focus,
          onChanged: (_) {
            if (selected != null) onSelected(null);
          },
          decoration: InputDecoration(
            labelText: 'Bem (patrimônio, série ou produto)',
            border: const OutlineInputBorder(),
            prefixIcon: const Icon(Icons.inventory_2_outlined),
            errorText: field.errorText ?? errorText,
          ),
        ),
      ),
    );
  }
}
