import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../api/gateway.dart';
import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';

/// Editor do checklist. Rascunho: edita, salva e publica. Publicado: só
/// leitura, com "Nova versão" e "Arquivar". [id] nulo = novo.
class ChecklistEditorPage extends ConsumerStatefulWidget {
  const ChecklistEditorPage({super.key, this.id});

  final UuidValue? id;

  @override
  ConsumerState<ChecklistEditorPage> createState() => _ChecklistEditorPageState();
}

class _ItemDraft {
  _ItemDraft([ChecklistItem? item])
    : key = item?.key,
      label = TextEditingController(text: item?.label),
      options = TextEditingController(text: item?.options?.join('\n')),
      unit = TextEditingController(text: item?.unit),
      type = item?.type ?? 'ok_nok',
      required = item?.required ?? true;

  final String? key;
  final TextEditingController label;
  final TextEditingController options;
  final TextEditingController unit;
  String type;
  bool required;
  final id = UniqueKey();

  ChecklistItem toItem() => ChecklistItem(
    key: key,
    label: label.text.trim(),
    type: type,
    required: required,
    options: type == 'choice'
        ? [
            for (final o in options.text.split('\n'))
              if (o.trim().isNotEmpty) o.trim(),
          ]
        : null,
    unit: type == 'number' && unit.text.trim().isNotEmpty ? unit.text.trim() : null,
  );

  void dispose() {
    label.dispose();
    options.dispose();
    unit.dispose();
  }
}

class _ChecklistEditorPageState extends ConsumerState<ChecklistEditorPage> {
  final _form = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _items = <_ItemDraft>[];
  ChecklistTemplate? _template;
  Future<void>? _loading;
  var _busy = false;
  Map<String, String> _fieldErrors = const {};

  @override
  void initState() {
    super.initState();
    final id = widget.id;
    if (id == null) {
      _items.add(_ItemDraft());
    } else {
      _loading = _load(id);
    }
  }

  Future<void> _load(UuidValue id) async {
    final t = await ref.read(gatewayProvider).checklist(id);
    if (!mounted) return;
    _fill(t);
  }

  void _fill(ChecklistTemplate t) {
    setState(() {
      _template = t;
      _code.text = t.code;
      _name.text = t.name;
      _description.text = t.description ?? '';
      for (final i in _items) {
        i.dispose();
      }
      _items
        ..clear()
        ..addAll(t.items.map(_ItemDraft.new));
    });
  }

  @override
  void dispose() {
    for (final c in [_code, _name, _description]) {
      c.dispose();
    }
    for (final i in _items) {
      i.dispose();
    }
    super.dispose();
  }

  bool get _editable => _template == null || _template!.status == 'draft';

  ChecklistTemplateInput _input() => ChecklistTemplateInput(
    code: _code.text.trim(),
    name: _name.text.trim(),
    description: _description.text.trim().isEmpty ? null : _description.text.trim(),
    items: [for (final i in _items) i.toItem()],
  );

  Future<void> _run(Future<ChecklistTemplate> Function(Gateway g) action, String done) async {
    setState(() {
      _busy = true;
      _fieldErrors = const {};
    });
    try {
      final saved = await action(ref.read(gatewayProvider));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
      if (widget.id != saved.id) {
        context.go('/checklists/${saved.id}');
      } else {
        _fill(saved);
      }
    } on GatewayException catch (e) {
      if (!mounted) return;
      setState(() => _fieldErrors = e.fieldErrors);
      reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    final current = _template;
    await _run(
      (g) => current == null ? g.createChecklist(_input()) : g.updateChecklist(current, _input()),
      'Rascunho salvo.',
    );
  }

  Future<void> _publish() async {
    if (!_form.currentState!.validate()) return;
    // Salva o que está na tela e publica em seguida.
    await _run((g) async {
      final current = _template;
      final saved = current == null ? await g.createChecklist(_input()) : await g.updateChecklist(current, _input());
      return g.publishChecklist(saved);
    }, 'Checklist publicado. As próximas visitas já usam esta versão.');
  }

  String? _error(String path) => _fieldErrors[path];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loading,
      builder: (context, snap) {
        if (snap.hasError) {
          return ErrorPanel(error: snap.error!, onRetry: () => setState(() => _loading = _load(widget.id!)));
        }
        if (_loading != null && _template == null) return const Center(child: CircularProgressIndicator());
        return _body(context);
      },
    );
  }

  Widget _body(BuildContext context) {
    final theme = Theme.of(context);
    final t = _template;
    final session = ref.watch(sessionProvider);
    final canManage = session is SignedIn && session.can('catalog.manage');
    final editable = _editable && canManage;
    return Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              IconButton(
                tooltip: 'Voltar à lista',
                onPressed: () => context.go('/checklists'),
                icon: const Icon(Icons.arrow_back),
              ),
              Text(t == null ? 'Novo checklist' : t.name, style: theme.textTheme.headlineSmall),
              if (t != null)
                Chip(label: Text('v${t.templateVersion} · ${checklistStatusLabels[t.status] ?? t.status}')),
              if (canManage && editable) ...[
                OutlinedButton(
                  key: const Key('checklist-save'),
                  onPressed: _busy ? null : _save,
                  child: const Text('Salvar rascunho'),
                ),
                FilledButton(
                  key: const Key('checklist-publish'),
                  onPressed: _busy ? null : _publish,
                  child: const Text('Publicar'),
                ),
              ],
              if (canManage && t != null && t.status == 'published')
                FilledButton.tonal(
                  key: const Key('checklist-new-version'),
                  onPressed: _busy ? null : () => _run((g) => g.newChecklistVersion(t), 'Nova versão em rascunho.'),
                  child: const Text('Nova versão'),
                ),
              if (canManage && t != null && t.status != 'archived')
                TextButton(
                  key: const Key('checklist-archive'),
                  onPressed: _busy ? null : () => _run((g) => g.archiveChecklist(t), 'Checklist arquivado.'),
                  child: const Text('Arquivar'),
                ),
            ],
          ),
          if (t != null && t.status == 'published')
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text('Versão publicada não muda. Para alterar, crie uma nova versão.'),
            ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 180,
                child: TextFormField(
                  key: const Key('checklist-code'),
                  controller: _code,
                  enabled: editable && (t == null || t.templateVersion == 1),
                  decoration: InputDecoration(
                    labelText: 'Código',
                    hintText: 'PREV-FREEZER',
                    border: const OutlineInputBorder(),
                    errorText: _error('code'),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Informe o código.' : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  key: const Key('checklist-name'),
                  controller: _name,
                  enabled: editable,
                  decoration: InputDecoration(
                    labelText: 'Nome',
                    border: const OutlineInputBorder(),
                    errorText: _error('name'),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Informe o nome.' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _description,
            enabled: editable,
            maxLines: 2,
            decoration: const InputDecoration(labelText: 'Orientação ao técnico', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          Text('Itens', style: theme.textTheme.titleMedium),
          if (_error('items') != null) Text(_error('items')!, style: TextStyle(color: theme.colorScheme.error)),
          const SizedBox(height: 8),
          for (final (index, item) in _items.indexed) _itemCard(index, item, editable),
          if (editable)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                key: const Key('checklist-add-item'),
                onPressed: () => setState(() => _items.add(_ItemDraft())),
                icon: const Icon(Icons.add),
                label: const Text('Adicionar item'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _itemCard(int index, _ItemDraft item, bool editable) {
    final path = 'items.$index';
    return Card(
      key: item.id,
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(padding: const EdgeInsets.only(top: 14, right: 8), child: Text('${index + 1}.')),
                Expanded(
                  flex: 3,
                  child: TextFormField(
                    key: Key('item-label-$index'),
                    controller: item.label,
                    enabled: editable,
                    decoration: InputDecoration(
                      labelText: 'Pergunta',
                      border: const OutlineInputBorder(),
                      errorText: _fieldErrors['$path.label'],
                    ),
                    validator: (v) => v == null || v.trim().isEmpty ? 'Informe a pergunta.' : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: DropdownButtonFormField<String>(
                    key: Key('item-type-$index'),
                    initialValue: item.type,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: 'Resposta',
                      border: const OutlineInputBorder(),
                      errorText: _fieldErrors['$path.type'],
                    ),
                    items: [
                      for (final e in checklistItemTypeLabels.entries)
                        DropdownMenuItem(value: e.key, child: Text(e.value)),
                    ],
                    onChanged: editable ? (v) => setState(() => item.type = v!) : null,
                  ),
                ),
                if (editable) ...[
                  IconButton(
                    tooltip: 'Subir',
                    onPressed: index == 0
                        ? null
                        : () => setState(() => _items.insert(index - 1, _items.removeAt(index))),
                    icon: const Icon(Icons.arrow_upward),
                  ),
                  IconButton(
                    tooltip: 'Descer',
                    onPressed: index == _items.length - 1
                        ? null
                        : () => setState(() => _items.insert(index + 1, _items.removeAt(index))),
                    icon: const Icon(Icons.arrow_downward),
                  ),
                  IconButton(
                    key: Key('item-remove-$index'),
                    tooltip: 'Remover',
                    onPressed: () => setState(() => _items.removeAt(index).dispose()),
                    icon: const Icon(Icons.delete_outline),
                  ),
                ],
              ],
            ),
            if (item.type == 'choice') ...[
              const SizedBox(height: 8),
              TextFormField(
                key: Key('item-options-$index'),
                controller: item.options,
                enabled: editable,
                minLines: 2,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: 'Opções (uma por linha)',
                  border: const OutlineInputBorder(),
                  errorText: _fieldErrors['$path.options'],
                ),
                validator: (v) => (v ?? '').split('\n').where((o) => o.trim().isNotEmpty).length < 2
                    ? 'Informe ao menos duas opções.'
                    : null,
              ),
            ],
            if (item.type == 'number') ...[
              const SizedBox(height: 8),
              SizedBox(
                width: 180,
                child: TextFormField(
                  controller: item.unit,
                  enabled: editable,
                  decoration: const InputDecoration(
                    labelText: 'Unidade',
                    hintText: '°C, bar, A',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
            CheckboxListTile(
              key: Key('item-required-$index'),
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              title: const Text('Obrigatório'),
              value: item.required,
              onChanged: editable ? (v) => setState(() => item.required = v ?? false) : null,
            ),
          ],
        ),
      ),
    );
  }
}
