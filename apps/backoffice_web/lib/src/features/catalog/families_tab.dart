import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/api_client.dart';
import '../../ui/dialogs.dart';
import '../../ui/errors.dart';
import 'catalog_format.dart';

/// Famílias de produto em árvore (até 5 níveis). Filtram sintomas, causas,
/// checklists e habilidades dos técnicos nas próximas etapas.
class FamiliesTab extends ConsumerStatefulWidget {
  const FamiliesTab({required this.canManage, super.key});
  final bool canManage;

  @override
  ConsumerState<FamiliesTab> createState() => _FamiliesTabState();
}

class _FamiliesTabState extends ConsumerState<FamiliesTab> {
  FamilyIndex? _index;
  Object? _error;
  bool _showInactive = false;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  Future<void> _reload() async {
    setState(() => _error = null);
    try {
      final index = await FamilyIndex.load(ref.read(apiClientProvider));
      if (mounted) setState(() => _index = index);
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _edit({ProductFamily? family, UuidValue? parentId}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _FamilyDialog(index: _index!, family: family, initialParentId: parentId),
    );
    if (saved == true) await _reload();
  }

  Future<void> _toggle(ProductFamily f) async {
    final api = ref.read(apiClientProvider).productFamilies;
    try {
      if (f.isActive) {
        final reason = await askReason(
          context,
          title: 'Inativar família',
          message:
              'Produtos já cadastrados continuam nela, mas novos produtos e subfamílias não poderão usá-la. '
              'Dá para reativar.',
          confirmLabel: 'Inativar',
        );
        if (reason == null) return;
        await api.deactivate(f.id, reason, f.version);
      } else {
        await api.reactivate(f.id, f.version);
      }
      if (!mounted) return;
      showInfoSnack(context, f.isActive ? 'Família inativada.' : 'Família reativada.');
      await _reload();
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.code == 'VERSION_MISMATCH') {
        await _reload();
        if (mounted) showInfoSnack(context, 'A família foi alterada por outra pessoa. A lista foi atualizada.');
      } else {
        showErrorSnack(context, e);
      }
    } on Object catch (e) {
      if (mounted) showErrorSnack(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final index = _index;
    if (_error != null) return ErrorPanel(error: _error!, onRetry: _reload);
    if (index == null) return const Center(child: CircularProgressIndicator());

    final nodes = [
      for (final n in index.tree)
        if (_showInactive || n.family.isActive) n,
    ];
    return ListView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      children: [
        Wrap(
          spacing: 12,
          runSpacing: 12,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            FilterChip(
              label: const Text('Mostrar inativas'),
              selected: _showInactive,
              onSelected: (v) => setState(() => _showInactive = v),
            ),
            if (widget.canManage)
              FilledButton.icon(
                onPressed: () => _edit(),
                icon: const Icon(Icons.add),
                label: const Text('Nova família'),
              ),
          ],
        ),
        const SizedBox(height: 16),
        if (nodes.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 48),
            child: Column(
              children: [
                Icon(Icons.account_tree_outlined, size: 48, color: theme.colorScheme.outline),
                const SizedBox(height: 8),
                const Text('Nenhuma família cadastrada.'),
                const SizedBox(height: 4),
                Text(
                  'Exemplo: Refrigeração › Freezers horizontais.',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          )
        else
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                for (final (i, n) in nodes.indexed) ...[
                  if (i > 0) const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.only(left: 16 + 28.0 * n.depth, right: 8),
                    leading: Icon(
                      index.childCount(n.family.id) > 0 ? Icons.folder_outlined : Icons.label_outline,
                      color: n.family.isActive ? null : theme.colorScheme.outline,
                    ),
                    title: Text(
                      n.family.name,
                      style: n.family.isActive ? null : TextStyle(color: theme.colorScheme.outline),
                    ),
                    subtitle: Text(n.family.code),
                    trailing: Wrap(
                      spacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        if (!n.family.isActive) const StatusPill(label: 'Inativa', tone: StatusTone.neutral),
                        if (n.family.source == RecordSource.erp)
                          const StatusPill(label: 'ERP', tone: StatusTone.neutral),
                        if (widget.canManage) ...[
                          if (n.family.isActive && n.depth < 4)
                            IconButton(
                              tooltip: 'Nova subfamília',
                              icon: const Icon(Icons.create_new_folder_outlined),
                              onPressed: () => _edit(parentId: n.family.id),
                            ),
                          IconButton(
                            tooltip: 'Editar',
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => _edit(family: n.family),
                          ),
                          IconButton(
                            tooltip: n.family.isActive ? 'Inativar' : 'Reativar',
                            icon: Icon(n.family.isActive ? Icons.block : Icons.restart_alt),
                            onPressed: () => _toggle(n.family),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _FamilyDialog extends ConsumerStatefulWidget {
  const _FamilyDialog({required this.index, this.family, this.initialParentId});
  final FamilyIndex index;
  final ProductFamily? family;
  final UuidValue? initialParentId;

  @override
  ConsumerState<_FamilyDialog> createState() => _FamilyDialogState();
}

class _FamilyDialogState extends ConsumerState<_FamilyDialog> {
  final _form = GlobalKey<FormState>();
  late final _code = TextEditingController(text: widget.family?.code ?? '');
  late final _name = TextEditingController(text: widget.family?.name ?? '');
  late UuidValue? _parentId = widget.family?.parentId ?? widget.initialParentId;
  Map<String, String> _serverErrors = const {};
  bool _saving = false;

  bool get _fromErp => widget.family?.source == RecordSource.erp;

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _serverErrors = const {});
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final api = ref.read(apiClientProvider).productFamilies;
    final f = widget.family;
    try {
      if (f == null) {
        await api.create(
          ProductFamilyInput(id: const Uuid().v7obj(), code: _code.text, name: _name.text, parentId: _parentId),
        );
      } else {
        final code = _code.text.trim();
        final name = _name.text.trim();
        await api.update(
          f.id,
          ProductFamilyPatch(
            code: code == f.code ? null : code,
            name: name == f.name ? null : name,
            parentId: _parentId == f.parentId ? null : _parentId,
            clearParent: _parentId == null && f.parentId != null ? true : null,
          ),
          f.version,
        );
      }
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() {
        _saving = false;
        _serverErrors = fieldErrorsOf(e);
      });
      _form.currentState?.validate();
      if (_serverErrors.isEmpty) showErrorSnack(context, e);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      showErrorSnack(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.family;
    // Não oferece como superior a própria família, as descendentes nem inativas.
    final blocked = f == null ? const <UuidValue>{} : widget.index.subtree(f.id);
    final parents = [
      for (final n in widget.index.tree)
        if (!blocked.contains(n.family.id) && (n.family.isActive || n.family.id == _parentId) && n.depth < 4) n,
    ];
    return AlertDialog(
      title: Text(f == null ? 'Nova família' : 'Editar família'),
      content: Form(
        key: _form,
        child: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_fromErp)
                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Text('Esta família vem do ERP: os dados só mudam por lá.'),
                ),
              TextFormField(
                controller: _name,
                autofocus: true,
                readOnly: _fromErp,
                maxLength: 200,
                decoration: const InputDecoration(labelText: 'Nome *'),
                validator: (v) => (v?.trim().isEmpty ?? true) ? 'Informe o nome.' : _serverErrors['name'],
              ),
              TextFormField(
                controller: _code,
                readOnly: _fromErp,
                maxLength: 40,
                decoration: const InputDecoration(labelText: 'Código *', helperText: 'Usado na importação de produtos'),
                validator: (v) => (v?.trim().isEmpty ?? true) ? 'Informe o código.' : _serverErrors['code'],
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<UuidValue?>(
                initialValue: _parentId,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Família superior'),
                items: [
                  const DropdownMenuItem(child: Text('Nenhuma (família principal)')),
                  for (final n in parents)
                    DropdownMenuItem(
                      value: n.family.id,
                      child: Text('${'   ' * n.depth}${n.family.name}', overflow: TextOverflow.ellipsis),
                    ),
                ],
                onChanged: _fromErp ? null : (v) => setState(() => _parentId = v),
                validator: (_) => _serverErrors['parentId'],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _saving ? null : () => Navigator.pop(context), child: const Text('Cancelar')),
        FilledButton(
          onPressed: _saving || _fromErp ? null : _save,
          child: Text(f == null ? 'Cadastrar' : 'Salvar'),
        ),
      ],
    );
  }
}
