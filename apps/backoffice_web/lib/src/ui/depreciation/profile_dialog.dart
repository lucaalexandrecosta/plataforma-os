import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/gateway.dart';
import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';

/// Ficha de depreciação gerencial do bem: método, taxa, início, base e
/// residual. Devolve a ficha salva.
class DepreciationProfileDialog extends ConsumerStatefulWidget {
  const DepreciationProfileDialog({super.key, required this.asset, this.profile});

  final Asset asset;
  final DepreciationProfile? profile;

  @override
  ConsumerState<DepreciationProfileDialog> createState() => _DepreciationProfileDialogState();
}

class _DepreciationProfileDialogState extends ConsumerState<DepreciationProfileDialog> {
  final _form = GlobalKey<FormState>();
  late var _method = widget.profile?.method ?? 'straight_line';
  late var _startRule = widget.profile?.startRule ?? 'pro_rata_days';
  late var _startDate =
      widget.profile?.startDate.toLocal() ?? widget.asset.acquisitionDate?.toLocal() ?? DateTime.now();
  late final _rate = TextEditingController(text: (widget.profile?.annualRate ?? '').replaceAll('.', ','));
  late final _cost = TextEditingController(text: moneyField(widget.profile?.depreciableCost));
  late final _residual = TextEditingController(text: moneyField(widget.profile?.residualValue));
  late final _capacity = TextEditingController(text: (widget.profile?.totalCapacity ?? '').replaceAll('.', ','));
  late final _production = TextEditingController(text: (widget.profile?.monthlyProduction ?? '').replaceAll('.', ','));
  late final _notes = TextEditingController(text: widget.profile?.notes);
  var _busy = false;
  Map<String, String> _fieldErrors = const {};

  bool get _units => _method == 'units_of_production';

  @override
  void dispose() {
    for (final c in [_rate, _cost, _residual, _capacity, _production, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _moneyValidator(String? v, {bool required = false}) {
    if (v == null || v.trim().isEmpty) return required ? 'Informe o valor.' : null;
    return parseMoney(v) == null ? 'Valor inválido (ex.: 1.234,56).' : null;
  }

  String? _clean(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(1990),
      lastDate: DateTime(DateTime.now().year + 5, 12, 31),
    );
    if (picked != null) setState(() => _startDate = picked);
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _fieldErrors = const {};
    });
    final input = DepreciationProfileInput(
      method: _method,
      annualRate: _units ? '0' : _rate.text.trim(),
      // Meio-dia UTC: a data não muda de dia em nenhum fuso do Brasil.
      startDate: DateTime.utc(_startDate.year, _startDate.month, _startDate.day, 12),
      startRule: _startRule,
      depreciableCost: _cost.text.trim().isEmpty ? null : parseMoney(_cost.text),
      residualValue: _residual.text.trim().isEmpty ? 0 : parseMoney(_residual.text),
      totalCapacity: _units ? _clean(_capacity) : null,
      monthlyProduction: _units ? _clean(_production) : null,
      notes: _clean(_notes),
    );
    try {
      final saved = await ref
          .read(gatewayProvider)
          .saveDepreciationProfile(widget.asset.id, widget.profile?.version, input);
      if (mounted) Navigator.of(context).pop(saved);
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
    InputDecoration deco(String label, String field, {String? hint, String? helper}) => InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
      border: const OutlineInputBorder(),
      errorText: _fieldErrors[field],
    );
    final acquisition = widget.asset.acquisitionCost;
    return AlertDialog(
      title: Text(widget.profile == null ? 'Configurar depreciação gerencial' : 'Editar depreciação gerencial'),
      content: SizedBox(
        width: 520,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButtonFormField<String>(
                  key: const Key('dep-method'),
                  initialValue: _method,
                  isExpanded: true,
                  decoration: deco('Método', 'method'),
                  items: [
                    for (final e in depreciationMethodLabels.entries)
                      DropdownMenuItem(value: e.key, child: Text(e.value)),
                  ],
                  onChanged: (v) => setState(() => _method = v!),
                ),
                const SizedBox(height: 12),
                if (!_units)
                  TextFormField(
                    key: const Key('dep-rate'),
                    controller: _rate,
                    decoration: deco('Taxa anual (%)', 'annualRate', hint: '10 ou 6,6667'),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Informe a taxa.' : null,
                  )
                else
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          key: const Key('dep-capacity'),
                          controller: _capacity,
                          decoration: deco('Capacidade total', 'totalCapacity', hint: '100000'),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Informe a capacidade.' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          key: const Key('dep-production'),
                          controller: _production,
                          decoration: deco('Produção por mês', 'monthlyProduction'),
                          validator: (v) => v == null || v.trim().isEmpty ? 'Informe a produção.' : null,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        key: const Key('dep-start'),
                        onPressed: _pickDate,
                        icon: const Icon(Icons.calendar_today),
                        label: Text('Início: ${formatDate(_startDate)}'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _startRule,
                        isExpanded: true,
                        decoration: deco('Primeiro mês', 'startRule'),
                        items: [
                          for (final e in depreciationStartRuleLabels.entries)
                            DropdownMenuItem(value: e.key, child: Text(e.value)),
                        ],
                        onChanged: (v) => setState(() => _startRule = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('dep-cost'),
                  controller: _cost,
                  decoration: deco(
                    'Base de cálculo (R\$)',
                    'depreciableCost',
                    helper: acquisition == null
                        ? 'O bem não tem valor de aquisição: informe a base.'
                        : 'Vazio usa o valor de aquisição (${formatMoney(acquisition)}).',
                  ),
                  validator: (v) => _moneyValidator(v, required: acquisition == null),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('dep-residual'),
                  controller: _residual,
                  decoration: deco('Valor residual (R\$)', 'residualValue', hint: '0,00'),
                  validator: _moneyValidator,
                ),
                const SizedBox(height: 12),
                TextFormField(controller: _notes, maxLines: 2, decoration: deco('Observações', 'notes')),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(key: const Key('dep-save'), onPressed: _busy ? null : _submit, child: const Text('Salvar')),
      ],
    );
  }
}
