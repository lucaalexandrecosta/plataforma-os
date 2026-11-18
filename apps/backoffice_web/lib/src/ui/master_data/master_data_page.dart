import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../api/gateway.dart';
import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';
import '../common/paged_table.dart';

/// Cadastros de apoio: filiais e centros de custo (`settings.manage`),
/// equipamentos (`catalog.manage` ou `assets.manage`) e tipos de OS
/// (`catalog.manage`).
class MasterDataPage extends ConsumerWidget {
  const MasterDataPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(sessionProvider);
    if (session is! SignedIn) return const SizedBox.shrink();
    final settings = session.can('settings.manage');
    final catalog = session.can('catalog.manage') || session.can('assets.manage');
    final tabs = [
      if (settings) (label: 'Filiais', body: const _BranchesTab()),
      if (settings) (label: 'Centros de custo', body: const _CostCentersTab()),
      if (catalog) (label: 'Equipamentos', body: const _ProductsTab()),
      if (session.can('catalog.manage')) (label: 'Tipos de OS', body: const _WorkOrderTypesTab()),
    ];
    if (tabs.isEmpty) return const Center(child: Text('Você não tem acesso aos cadastros.'));
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const PageHeader(title: 'Cadastros'),
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [for (final t in tabs) Tab(text: t.label)],
          ),
          Expanded(child: TabBarView(children: [for (final t in tabs) t.body])),
        ],
      ),
    );
  }
}

/// Lista carregada de um futuro, com "Novo" e linha clicável.
class _ListTab<T> extends StatelessWidget {
  const _ListTab({
    required this.future,
    required this.onRetry,
    required this.newKey,
    required this.newLabel,
    required this.onNew,
    required this.empty,
    required this.columns,
    required this.cells,
    required this.id,
    this.onTap,
  });

  final Future<List<T>> future;
  final VoidCallback onRetry;
  final String newKey;
  final String newLabel;
  final VoidCallback onNew;
  final String empty;
  final List<String> columns;
  final List<String?> Function(T item) cells;
  final Object Function(T item) id;
  final void Function(T item)? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.icon(
              key: Key(newKey),
              onPressed: onNew,
              icon: const Icon(Icons.add),
              label: Text(newLabel),
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder<List<T>>(
            future: future,
            builder: (context, snap) {
              if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: onRetry);
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final list = snap.data!;
              if (list.isEmpty) return Center(child: Text(empty));
              return SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: false,
                    columns: [for (final c in columns) DataColumn(label: Text(c))],
                    rows: [
                      for (final item in list)
                        DataRow(
                          key: ValueKey(id(item)),
                          onSelectChanged: onTap == null ? null : (_) => onTap!(item),
                          cells: [for (final c in cells(item)) DataCell(Text(c ?? '—'))],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------ filiais

class _BranchesTab extends ConsumerStatefulWidget {
  const _BranchesTab();

  @override
  ConsumerState<_BranchesTab> createState() => _BranchesTabState();
}

class _BranchesTabState extends ConsumerState<_BranchesTab> {
  late Future<List<Branch>> _list;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _list = ref.read(gatewayProvider).branches(includeInactive: true);
  }

  Future<void> _edit([Branch? branch]) async {
    final saved = await showDialog<Branch>(
      context: context,
      builder: (_) => BranchDialog(branch: branch),
    );
    if (saved != null && mounted) setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    return _ListTab<Branch>(
      future: _list,
      onRetry: () => setState(_load),
      newKey: 'branch-new',
      newLabel: 'Nova filial',
      onNew: _edit,
      empty: 'Nenhuma filial cadastrada.',
      columns: const ['Código', 'Razão social', 'Nome fantasia', 'CNPJ', 'Cidade', 'Situação'],
      cells: (b) => [
        b.isDefault ? '${b.code} (padrão)' : b.code,
        b.legalName,
        b.tradeName,
        b.documentNumber == null ? null : formatCnpj(b.documentNumber!),
        b.city == null ? null : [b.city, b.state].whereType<String>().join('/'),
        b.isActive ? 'Ativa' : 'Inativa',
      ],
      id: (b) => b.id,
      onTap: _edit,
    );
  }
}

String? _clean(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

InputDecoration _deco(String label, String field, Map<String, String> errors, {String? hint}) => InputDecoration(
  labelText: label,
  hintText: hint,
  border: const OutlineInputBorder(),
  errorText: errors[field],
);

String? _required(String? v, String message) => v == null || v.trim().isEmpty ? message : null;

/// Base dos formulários de cadastro: envia, mostra erro por campo e fecha
/// devolvendo o salvo.
mixin _SaveForm<W extends ConsumerStatefulWidget, T> on ConsumerState<W> {
  final form = GlobalKey<FormState>();
  var busy = false;
  Map<String, String> fieldErrors = const {};

  Future<void> save(Future<T> Function(Gateway g) action) async {
    if (!form.currentState!.validate()) return;
    setState(() {
      busy = true;
      fieldErrors = const {};
    });
    try {
      final saved = await action(ref.read(gatewayProvider));
      if (mounted) Navigator.of(context).pop(saved);
    } on GatewayException catch (e) {
      if (!mounted) return;
      setState(() => fieldErrors = e.fieldErrors);
      reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget dialog({required String title, required String saveKey, required List<Widget> fields, VoidCallback? onSave}) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final f in fields) ...[f, const SizedBox(height: 12)],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: busy ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(key: Key(saveKey), onPressed: busy ? null : onSave, child: const Text('Salvar')),
      ],
    );
  }
}

class BranchDialog extends ConsumerStatefulWidget {
  const BranchDialog({super.key, this.branch});

  final Branch? branch;

  @override
  ConsumerState<BranchDialog> createState() => _BranchDialogState();
}

class _BranchDialogState extends ConsumerState<BranchDialog> with _SaveForm<BranchDialog, Branch> {
  late final _code = TextEditingController(text: widget.branch?.code);
  late final _legal = TextEditingController(text: widget.branch?.legalName);
  late final _trade = TextEditingController(text: widget.branch?.tradeName);
  late final _cnpj = TextEditingController(text: widget.branch?.documentNumber);
  late final _city = TextEditingController(text: widget.branch?.city);
  late final _state = TextEditingController(text: widget.branch?.state);
  late final _erp = TextEditingController(text: widget.branch?.erpBranchCode);
  late var _default = widget.branch?.isDefault ?? false;
  late var _active = widget.branch?.isActive ?? true;

  @override
  void dispose() {
    for (final c in [_code, _legal, _trade, _cnpj, _city, _state, _erp]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final input = BranchInput(
      code: _code.text.trim(),
      legalName: _legal.text.trim(),
      tradeName: _clean(_trade),
      documentNumber: _clean(_cnpj),
      city: _clean(_city),
      state: _clean(_state)?.toUpperCase(),
      erpBranchCode: _clean(_erp),
      isDefault: _default,
      isActive: _active,
    );
    final current = widget.branch;
    save((g) => current == null ? g.createBranch(input) : g.updateBranch(current, input));
  }

  @override
  Widget build(BuildContext context) {
    return dialog(
      title: widget.branch == null ? 'Nova filial' : 'Editar filial',
      saveKey: 'branch-save',
      onSave: busy ? null : _submit,
      fields: [
        TextFormField(
          key: const Key('branch-code'),
          controller: _code,
          decoration: _deco('Código', 'code', fieldErrors, hint: '01'),
          validator: (v) => _required(v, 'Informe o código.'),
        ),
        TextFormField(
          key: const Key('branch-legal'),
          controller: _legal,
          decoration: _deco('Razão social', 'legalName', fieldErrors),
          validator: (v) => _required(v, 'Informe a razão social.'),
        ),
        TextFormField(controller: _trade, decoration: _deco('Nome fantasia', 'tradeName', fieldErrors)),
        TextFormField(
          key: const Key('branch-cnpj'),
          controller: _cnpj,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(14)],
          decoration: _deco('CNPJ (só números)', 'documentNumber', fieldErrors),
          validator: (v) => v == null || v.isEmpty || v.length == 14 ? null : 'O CNPJ tem 14 dígitos.',
        ),
        Row(
          children: [
            Expanded(
              flex: 3,
              child: TextFormField(controller: _city, decoration: _deco('Cidade', 'city', fieldErrors)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _state,
                inputFormatters: [LengthLimitingTextInputFormatter(2)],
                decoration: _deco('UF', 'state', fieldErrors),
              ),
            ),
          ],
        ),
        TextFormField(controller: _erp, decoration: _deco('Código no ERP', 'erpBranchCode', fieldErrors)),
        SwitchListTile(
          key: const Key('branch-default'),
          contentPadding: EdgeInsets.zero,
          title: const Text('Filial padrão'),
          subtitle: fieldErrors['isDefault'] == null ? null : Text(fieldErrors['isDefault']!),
          value: _default,
          onChanged: (v) => setState(() => _default = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ativa'),
          subtitle: fieldErrors['isActive'] == null ? null : Text(fieldErrors['isActive']!),
          value: _active,
          onChanged: (v) => setState(() => _active = v),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------ centros de custo

class _CostCentersTab extends ConsumerStatefulWidget {
  const _CostCentersTab();

  @override
  ConsumerState<_CostCentersTab> createState() => _CostCentersTabState();
}

class _CostCentersTabState extends ConsumerState<_CostCentersTab> {
  late Future<(List<CostCenter>, Map<UuidValue, Branch>)> _data;
  late Future<List<CostCenter>> _list;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final g = ref.read(gatewayProvider);
    _data = () async {
      final branches = g.branches(includeInactive: true);
      final list = await g.costCenters(includeInactive: true);
      return (list, {for (final b in await branches) b.id: b});
    }();
    _list = _data.then((d) => d.$1);
  }

  Future<void> _edit(List<Branch> branches, [CostCenter? costCenter]) async {
    final saved = await showDialog<CostCenter>(
      context: context,
      builder: (_) => CostCenterDialog(costCenter: costCenter, branches: branches),
    );
    if (saved != null && mounted) setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _data,
      builder: (context, snap) {
        final branches = snap.data?.$2 ?? const <UuidValue, Branch>{};
        return _ListTab<CostCenter>(
          future: _list,
          onRetry: () => setState(_load),
          newKey: 'cc-new',
          newLabel: 'Novo centro de custo',
          onNew: () => _edit(branches.values.toList()),
          empty: 'Nenhum centro de custo cadastrado.',
          columns: const ['Código', 'Nome', 'Filial', 'Código no ERP', 'Situação'],
          cells: (c) => [
            c.code,
            c.name,
            c.branchId == null ? 'Todas' : branches[c.branchId]?.code,
            c.erpCode,
            c.isActive ? 'Ativo' : 'Inativo',
          ],
          id: (c) => c.id,
          onTap: (c) => _edit(branches.values.toList(), c),
        );
      },
    );
  }
}

class CostCenterDialog extends ConsumerStatefulWidget {
  const CostCenterDialog({super.key, this.costCenter, required this.branches});

  final CostCenter? costCenter;
  final List<Branch> branches;

  @override
  ConsumerState<CostCenterDialog> createState() => _CostCenterDialogState();
}

class _CostCenterDialogState extends ConsumerState<CostCenterDialog> with _SaveForm<CostCenterDialog, CostCenter> {
  late final _code = TextEditingController(text: widget.costCenter?.code);
  late final _name = TextEditingController(text: widget.costCenter?.name);
  late final _erp = TextEditingController(text: widget.costCenter?.erpCode);
  late UuidValue? _branchId = widget.costCenter?.branchId;
  late var _active = widget.costCenter?.isActive ?? true;

  @override
  void dispose() {
    for (final c in [_code, _name, _erp]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final input = CostCenterInput(
      code: _code.text.trim(),
      name: _name.text.trim(),
      branchId: _branchId,
      erpCode: _clean(_erp),
      isActive: _active,
    );
    final current = widget.costCenter;
    save((g) => current == null ? g.createCostCenter(input) : g.updateCostCenter(current, input));
  }

  @override
  Widget build(BuildContext context) {
    return dialog(
      title: widget.costCenter == null ? 'Novo centro de custo' : 'Editar centro de custo',
      saveKey: 'cc-save',
      onSave: busy ? null : _submit,
      fields: [
        TextFormField(
          key: const Key('cc-code'),
          controller: _code,
          decoration: _deco('Código', 'code', fieldErrors, hint: '1.01'),
          validator: (v) => _required(v, 'Informe o código.'),
        ),
        TextFormField(
          key: const Key('cc-name'),
          controller: _name,
          decoration: _deco('Nome', 'name', fieldErrors),
          validator: (v) => _required(v, 'Informe o nome.'),
        ),
        DropdownButtonFormField<UuidValue?>(
          key: const Key('cc-branch'),
          initialValue: _branchId,
          decoration: _deco('Filial', 'branchId', fieldErrors),
          items: [
            const DropdownMenuItem(value: null, child: Text('Todas as filiais')),
            for (final b in widget.branches)
              DropdownMenuItem(value: b.id, child: Text('${b.code} · ${b.tradeName ?? b.legalName}')),
          ],
          onChanged: (v) => setState(() => _branchId = v),
        ),
        TextFormField(controller: _erp, decoration: _deco('Código no ERP', 'erpCode', fieldErrors)),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ativo'),
          value: _active,
          onChanged: (v) => setState(() => _active = v),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------ equipamentos

class _ProductsTab extends ConsumerStatefulWidget {
  const _ProductsTab();

  @override
  ConsumerState<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends ConsumerState<_ProductsTab> {
  late Future<List<ProductSummary>> _list;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _list = ref.read(gatewayProvider).products();
  }

  Future<void> _new() async {
    final saved = await showDialog<ProductSummary>(context: context, builder: (_) => const ProductDialog());
    if (saved != null && mounted) setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    return _ListTab<ProductSummary>(
      future: _list,
      onRetry: () => setState(_load),
      newKey: 'product-new',
      newLabel: 'Novo equipamento',
      onNew: _new,
      empty: 'Nenhum equipamento cadastrado.',
      columns: const ['Código', 'Nome'],
      cells: (p) => [p.code, p.name],
      id: (p) => p.id,
    );
  }
}

/// Modelo de equipamento (o que o bem é: "Freezer horizontal 400 L").
class ProductDialog extends ConsumerStatefulWidget {
  const ProductDialog({super.key});

  @override
  ConsumerState<ProductDialog> createState() => _ProductDialogState();
}

class _ProductDialogState extends ConsumerState<ProductDialog> with _SaveForm<ProductDialog, ProductSummary> {
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _description = TextEditingController();

  @override
  void dispose() {
    for (final c in [_code, _name, _description]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() => save(
    (g) => g.createProduct(
      ProductInput(code: _code.text.trim(), name: _name.text.trim(), description: _clean(_description)),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return dialog(
      title: 'Novo equipamento',
      saveKey: 'product-save',
      onSave: busy ? null : _submit,
      fields: [
        TextFormField(
          key: const Key('product-code'),
          controller: _code,
          decoration: _deco('Código', 'code', fieldErrors, hint: 'FRZ-400'),
          validator: (v) => _required(v, 'Informe o código.'),
        ),
        TextFormField(
          key: const Key('product-name'),
          controller: _name,
          decoration: _deco('Nome', 'name', fieldErrors, hint: 'Freezer horizontal 400 L'),
          validator: (v) => _required(v, 'Informe o nome.'),
        ),
        TextFormField(
          controller: _description,
          maxLines: 3,
          decoration: _deco('Descrição', 'description', fieldErrors),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------ tipos de OS

class _WorkOrderTypesTab extends ConsumerStatefulWidget {
  const _WorkOrderTypesTab();

  @override
  ConsumerState<_WorkOrderTypesTab> createState() => _WorkOrderTypesTabState();
}

class _WorkOrderTypesTabState extends ConsumerState<_WorkOrderTypesTab> {
  late Future<List<WorkOrderType>> _list;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _list = ref.read(gatewayProvider).workOrderTypes(includeInactive: true);
  }

  Future<void> _edit([WorkOrderType? type]) async {
    final checklists = await ref.read(gatewayProvider).checklists();
    if (!mounted) return;
    final saved = await showDialog<WorkOrderType>(
      context: context,
      builder: (_) => WorkOrderTypeDialog(
        type: type,
        checklists: [
          for (final c in checklists)
            if (c.status == 'published') c,
        ],
      ),
    );
    if (saved != null && mounted) setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    return _ListTab<WorkOrderType>(
      future: _list,
      onRetry: () => setState(_load),
      newKey: 'wot-new',
      newLabel: 'Novo tipo de OS',
      onNew: _edit,
      empty: 'Nenhum tipo de OS cadastrado.',
      columns: const ['Código', 'Nome', 'Categoria', 'Prioridade', 'Checklist', 'Situação'],
      cells: (t) => [
        t.code,
        t.name,
        workOrderCategoryLabels[t.category] ?? t.category,
        priorityLabels[t.defaultPriority] ?? t.defaultPriority,
        t.defaultChecklistName,
        t.isActive ? 'Ativo' : 'Inativo',
      ],
      id: (t) => t.id,
      onTap: _edit,
    );
  }
}

class WorkOrderTypeDialog extends ConsumerStatefulWidget {
  const WorkOrderTypeDialog({super.key, this.type, required this.checklists});

  final WorkOrderType? type;

  /// Checklists publicados.
  final List<ChecklistTemplate> checklists;

  @override
  ConsumerState<WorkOrderTypeDialog> createState() => _WorkOrderTypeDialogState();
}

class _WorkOrderTypeDialogState extends ConsumerState<WorkOrderTypeDialog>
    with _SaveForm<WorkOrderTypeDialog, WorkOrderType> {
  late final _code = TextEditingController(text: widget.type?.code);
  late final _name = TextEditingController(text: widget.type?.name);
  late var _category = widget.type?.category ?? 'corrective';
  late var _priority = widget.type?.defaultPriority ?? 'normal';
  late var _requiresAsset = widget.type?.requiresAsset ?? true;
  late var _active = widget.type?.isActive ?? true;
  late UuidValue? _checklistId = widget.type?.defaultChecklistTemplateId;
  late var _requirePhotos = widget.type?.requirePhotos ?? false;
  late var _requireSignature = widget.type?.requireSignature ?? false;

  @override
  void dispose() {
    _code.dispose();
    _name.dispose();
    super.dispose();
  }

  void _submit() {
    final input = WorkOrderTypeInput(
      code: _code.text.trim(),
      name: _name.text.trim(),
      category: _category,
      defaultPriority: _priority,
      requiresAsset: _requiresAsset,
      isActive: _active,
      defaultChecklistTemplateId: _checklistId,
      requirePhotos: _requirePhotos,
      requireSignature: _requireSignature,
    );
    final current = widget.type;
    save((g) => current == null ? g.createWorkOrderType(input) : g.updateWorkOrderType(current, input));
  }

  @override
  Widget build(BuildContext context) {
    final current = widget.type;
    // O tipo pode apontar para uma versão já arquivada: mostra pelo nome.
    final options = [
      ...widget.checklists,
      if (_checklistId != null && !widget.checklists.any((c) => c.id == _checklistId))
        ChecklistTemplate(
          id: _checklistId!,
          code: '',
          name: current?.defaultChecklistName ?? 'Checklist atual',
          templateVersion: 0,
          status: 'archived',
          items: const [],
          isActive: true,
          version: 0,
        ),
    ];
    return dialog(
      title: current == null ? 'Novo tipo de OS' : 'Editar tipo de OS',
      saveKey: 'wot-save',
      onSave: busy ? null : _submit,
      fields: [
        TextFormField(
          key: const Key('wot-code'),
          controller: _code,
          decoration: _deco('Código', 'code', fieldErrors, hint: 'PREV'),
          validator: (v) => _required(v, 'Informe o código.'),
        ),
        TextFormField(
          key: const Key('wot-name'),
          controller: _name,
          decoration: _deco('Nome', 'name', fieldErrors, hint: 'Preventiva'),
          validator: (v) => _required(v, 'Informe o nome.'),
        ),
        DropdownButtonFormField<String>(
          key: const Key('wot-category'),
          initialValue: _category,
          decoration: _deco('Categoria', 'category', fieldErrors),
          items: [
            for (final e in workOrderCategoryLabels.entries) DropdownMenuItem(value: e.key, child: Text(e.value)),
          ],
          onChanged: (v) => setState(() => _category = v!),
        ),
        DropdownButtonFormField<String>(
          key: const Key('wot-priority'),
          initialValue: _priority,
          decoration: _deco('Prioridade padrão', 'defaultPriority', fieldErrors),
          items: [for (final e in priorityLabels.entries) DropdownMenuItem(value: e.key, child: Text(e.value))],
          onChanged: (v) => setState(() => _priority = v!),
        ),
        DropdownButtonFormField<UuidValue?>(
          key: const Key('wot-checklist'),
          initialValue: _checklistId,
          isExpanded: true,
          decoration: _deco('Checklist das visitas', 'defaultChecklistTemplateId', fieldErrors),
          items: [
            const DropdownMenuItem(value: null, child: Text('Sem checklist')),
            for (final c in options)
              DropdownMenuItem(value: c.id, child: Text(c.code.isEmpty ? c.name : '${c.name} (${c.code})')),
          ],
          onChanged: (v) => setState(() => _checklistId = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Exige bem na abertura'),
          value: _requiresAsset,
          onChanged: (v) => setState(() => _requiresAsset = v),
        ),
        SwitchListTile(
          key: const Key('type-require-photos'),
          contentPadding: EdgeInsets.zero,
          title: const Text('Exige fotos de antes e depois para concluir'),
          value: _requirePhotos,
          onChanged: (v) => setState(() => _requirePhotos = v),
        ),
        SwitchListTile(
          key: const Key('type-require-signature'),
          contentPadding: EdgeInsets.zero,
          title: const Text('Exige assinatura do cliente para concluir'),
          value: _requireSignature,
          onChanged: (v) => setState(() => _requireSignature = v),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ativo'),
          value: _active,
          onChanged: (v) => setState(() => _active = v),
        ),
      ],
    );
  }
}
