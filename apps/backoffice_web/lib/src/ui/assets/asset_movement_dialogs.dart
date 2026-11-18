import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../api/gateway.dart';
import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';

/// Instalar o bem num cliente (ou transferir, se já estiver em outro):
/// cliente, unidade, documento de origem e observação.
class InstallAssetDialog extends ConsumerStatefulWidget {
  const InstallAssetDialog({super.key, required this.asset});

  final Asset asset;

  @override
  ConsumerState<InstallAssetDialog> createState() => _InstallAssetDialogState();
}

class _InstallAssetDialogState extends ConsumerState<InstallAssetDialog> {
  final _form = GlobalKey<FormState>();
  final _search = TextEditingController();
  final _docNumber = TextEditingController();
  final _notes = TextEditingController();
  Timer? _debounce;
  List<Customer> _found = const [];
  Customer? _customer;
  List<CustomerSite>? _sites;
  UuidValue? _siteId;
  String? _docType;
  var _busy = false;
  Map<String, String> _fieldErrors = const {};

  bool get _transfer => widget.asset.customerSiteId != null;

  @override
  void initState() {
    super.initState();
    _find('');
  }

  @override
  void dispose() {
    _debounce?.cancel();
    for (final c in [_search, _docNumber, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _find(String text) async {
    try {
      final page = await ref.read(gatewayProvider).customers(search: text, limit: 8);
      if (mounted) setState(() => _found = page.items);
    } on GatewayException catch (e) {
      if (mounted) reportError(context, ref, e);
    }
  }

  void _onSearch(String text) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () => _find(text));
  }

  Future<void> _pick(Customer c) async {
    setState(() {
      _customer = c;
      _sites = null;
      _siteId = null;
    });
    try {
      final sites = [
        for (final s in await ref.read(gatewayProvider).customerSites(c.id))
          if (s.isActive) s,
      ];
      if (!mounted) return;
      setState(() {
        _sites = sites;
        _siteId = sites.length == 1 ? sites.single.id : null;
      });
    } on GatewayException catch (e) {
      if (mounted) reportError(context, ref, e);
    }
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _fieldErrors = const {};
    });
    final input = AssetInstallInput(
      customerSiteId: _siteId!,
      sourceDocumentType: _docType,
      sourceDocumentNumber: _docNumber.text.trim().isEmpty ? null : _docNumber.text.trim(),
      notes: _notes.text.trim().isEmpty ? null : _notes.text.trim(),
    );
    try {
      final saved = await ref.read(gatewayProvider).installAsset(widget.asset, input);
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
    final customer = _customer;
    return AlertDialog(
      title: Text(_transfer ? 'Transferir para outro cliente ou unidade' : 'Instalar no cliente'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_transfer)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Hoje em: ${widget.asset.customerName} · ${widget.asset.customerSiteName}. '
                      'A alocação atual é encerrada como transferência.',
                    ),
                  ),
                if (customer == null) ...[
                  TextField(
                    key: const Key('install-search'),
                    controller: _search,
                    autofocus: true,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      labelText: 'Cliente',
                      hintText: 'Nome, código ou CNPJ/CPF',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _onSearch,
                  ),
                  const SizedBox(height: 8),
                  if (_found.isEmpty) const Text('Nenhum cliente encontrado.'),
                  for (final c in _found)
                    ListTile(
                      key: Key('install-customer-${c.id}'),
                      dense: true,
                      title: Text(c.tradeName ?? c.name),
                      subtitle: Text('${c.name} · ${c.siteCount} unidade(s)'),
                      onTap: () => _pick(c),
                    ),
                ] else ...[
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.storefront),
                    title: Text(customer.tradeName ?? customer.name),
                    trailing: TextButton(
                      key: const Key('install-change-customer'),
                      onPressed: () => setState(() => _customer = null),
                      child: const Text('Trocar'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (_sites == null)
                    const LinearProgressIndicator()
                  else if (_sites!.isEmpty)
                    const Text('Este cliente não tem unidade ativa. Cadastre uma na ficha do cliente.')
                  else
                    DropdownButtonFormField<UuidValue>(
                      key: const Key('install-site'),
                      initialValue: _siteId,
                      isExpanded: true,
                      decoration: InputDecoration(
                        labelText: 'Unidade',
                        border: const OutlineInputBorder(),
                        errorText: _fieldErrors['customerSiteId'],
                      ),
                      items: [
                        for (final s in _sites!)
                          DropdownMenuItem(
                            value: s.id,
                            child: Text(s.city == null ? s.name : '${s.name} · ${s.city}'),
                          ),
                      ],
                      onChanged: (v) => setState(() => _siteId = v),
                      validator: (v) => v == null ? 'Escolha a unidade.' : null,
                    ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String?>(
                          key: const Key('install-doc-type'),
                          initialValue: _docType,
                          isExpanded: true,
                          decoration: const InputDecoration(labelText: 'Documento', border: OutlineInputBorder()),
                          items: [
                            const DropdownMenuItem(value: null, child: Text('—')),
                            for (final e in movementDocumentLabels.entries)
                              DropdownMenuItem(value: e.key, child: Text(e.value)),
                          ],
                          onChanged: (v) => setState(() => _docType = v),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextFormField(
                          key: const Key('install-doc-number'),
                          controller: _docNumber,
                          decoration: const InputDecoration(labelText: 'Número', border: OutlineInputBorder()),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _notes,
                    maxLines: 2,
                    decoration: const InputDecoration(labelText: 'Observação', border: OutlineInputBorder()),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(
          key: const Key('install-save'),
          onPressed: _busy || customer == null || (_sites?.isEmpty ?? true) ? null : _submit,
          child: Text(_transfer ? 'Transferir' : 'Instalar'),
        ),
      ],
    );
  }
}

/// Retirar o bem do cliente: motivo e observação. O bem volta ao estoque.
class WithdrawAssetDialog extends ConsumerStatefulWidget {
  const WithdrawAssetDialog({super.key, required this.asset});

  final Asset asset;

  @override
  ConsumerState<WithdrawAssetDialog> createState() => _WithdrawAssetDialogState();
}

class _WithdrawAssetDialogState extends ConsumerState<WithdrawAssetDialog> {
  final _notes = TextEditingController();
  var _reason = 'withdrawal';
  var _busy = false;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _busy = true);
    try {
      final saved = await ref
          .read(gatewayProvider)
          .withdrawAsset(
            widget.asset,
            AssetWithdrawInput(reason: _reason, notes: _notes.text.trim().isEmpty ? null : _notes.text.trim()),
          );
      if (mounted) Navigator.of(context).pop(saved);
    } on GatewayException catch (e) {
      if (mounted) reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Retirar do cliente'),
      content: SizedBox(
        width: 460,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('${widget.asset.customerName} · ${widget.asset.customerSiteName}'),
            const SizedBox(height: 8),
            RadioGroup<String>(
              groupValue: _reason,
              onChanged: (v) => setState(() => _reason = v!),
              child: const Column(
                children: [
                  RadioListTile(
                    key: Key('withdraw-withdrawal'),
                    value: 'withdrawal',
                    title: Text('Retirada do cliente'),
                    subtitle: Text('Recolhido para manutenção, troca ou fim de uso.'),
                  ),
                  RadioListTile(
                    key: Key('withdraw-return_to_stock'),
                    value: 'return_to_stock',
                    title: Text('Devolução ao estoque'),
                    subtitle: Text('Fim do contrato; o bem fica disponível.'),
                  ),
                ],
              ),
            ),
            TextField(
              key: const Key('withdraw-notes'),
              controller: _notes,
              maxLines: 2,
              decoration: const InputDecoration(labelText: 'Observação', border: OutlineInputBorder()),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(key: const Key('withdraw-save'), onPressed: _busy ? null : _submit, child: const Text('Retirar')),
      ],
    );
  }
}
