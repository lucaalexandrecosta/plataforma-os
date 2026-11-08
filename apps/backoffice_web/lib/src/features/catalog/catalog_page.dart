import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/api_client.dart';
import '../../auth/auth_controller.dart';
import '../../ui/dialogs.dart';
import '../../ui/paged_table.dart';
import 'catalog_format.dart';
import 'families_tab.dart';

enum CatalogTab {
  products('produtos', 'Produtos', Icons.inventory_2_outlined),
  services('servicos', 'Serviços', Icons.handyman_outlined),
  families('familias', 'Famílias', Icons.account_tree_outlined);

  const CatalogTab(this.slug, this.label, this.icon);
  final String slug;
  final String label;
  final IconData icon;

  static CatalogTab fromSlug(String? s) => values.firstWhere((t) => t.slug == s, orElse: () => products);
}

enum _Status { active, inactive, all }

bool? _isActive(_Status s) => switch (s) {
  _Status.active => true,
  _Status.inactive => false,
  _Status.all => null,
};

/// Catálogo: produtos, serviços e famílias. Cada aba tem a própria URL
/// (`/catalogo/produtos`, `/catalogo/servicos`, `/catalogo/familias`).
class CatalogPage extends ConsumerWidget {
  const CatalogPage({required this.tab, super.key});

  final CatalogTab tab;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final canManage = auth is AuthSignedIn && auth.can('catalog.manage');
    final theme = Theme.of(context);
    return DefaultTabController(
      key: ValueKey(tab),
      length: CatalogTab.values.length,
      initialIndex: tab.index,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Text('Catálogo', style: theme.textTheme.headlineSmall),
          ),
          TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            onTap: (i) => context.go('/catalogo/${CatalogTab.values[i].slug}'),
            tabs: [for (final t in CatalogTab.values) Tab(icon: Icon(t.icon), text: t.label)],
          ),
          const Divider(height: 1),
          Expanded(
            child: switch (tab) {
              CatalogTab.products => _ProductsTab(canManage: canManage),
              CatalogTab.services => _ServicesTab(canManage: canManage),
              CatalogTab.families => FamiliesTab(canManage: canManage),
            },
          ),
        ],
      ),
    );
  }
}

/// Barra de busca com atraso (300 ms) e limpar.
class _SearchField extends StatefulWidget {
  const _SearchField({required this.hint, required this.onChanged});
  final String hint;
  final ValueChanged<String> onChanged;

  @override
  State<_SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<_SearchField> {
  final _ctl = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    _ctl.dispose();
    super.dispose();
  }

  void _emit() {
    final q = _ctl.text.trim();
    widget.onChanged(q.length >= 2 ? q : '');
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 340,
    child: TextField(
      controller: _ctl,
      onChanged: (_) {
        setState(() {});
        _debounce?.cancel();
        _debounce = Timer(const Duration(milliseconds: 300), _emit);
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.search),
        hintText: widget.hint,
        suffixIcon: _ctl.text.isEmpty
            ? null
            : IconButton(
                tooltip: 'Limpar',
                icon: const Icon(Icons.close),
                onPressed: () {
                  _ctl.clear();
                  setState(() {});
                  _emit();
                },
              ),
      ),
    ),
  );
}

Widget _statusFilter(_Status value, ValueChanged<_Status> onChanged) => SegmentedButton<_Status>(
  segments: const [
    ButtonSegment(value: _Status.active, label: Text('Ativos')),
    ButtonSegment(value: _Status.inactive, label: Text('Inativos')),
    ButtonSegment(value: _Status.all, label: Text('Todos')),
  ],
  selected: {value},
  onSelectionChanged: (s) => onChanged(s.first),
);

StatusPill _activePill(bool active, RecordSource source) => StatusPill(
  label: source == RecordSource.erp ? (active ? 'Ativo · ERP' : 'Inativo · ERP') : (active ? 'Ativo' : 'Inativo'),
  tone: active ? StatusTone.positive : StatusTone.neutral,
);

// ---------------------------------------------------------------------------
// Produtos
// ---------------------------------------------------------------------------

class _ProductsTab extends ConsumerStatefulWidget {
  const _ProductsTab({required this.canManage});
  final bool canManage;

  @override
  ConsumerState<_ProductsTab> createState() => _ProductsTabState();
}

class _ProductsTabState extends ConsumerState<_ProductsTab> {
  final _table = GlobalKey<PagedTableState<Product>>();
  String _q = '';
  _Status _status = _Status.active;
  ProductKind? _kind;
  UuidValue? _family;
  FamilyIndex _families = FamilyIndex.empty;

  @override
  void initState() {
    super.initState();
    _loadFamilies();
  }

  Future<void> _loadFamilies() async {
    try {
      final index = await FamilyIndex.load(ref.read(apiClientProvider));
      if (mounted) setState(() => _families = index);
    } on Object {
      // Sem famílias o filtro só não aparece; a lista funciona.
    }
  }

  Future<void> _open(String path) async {
    final changed = await context.push<bool>(path);
    if (changed == true) await _table.currentState?.reload();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ProductFilter(
      q: _q.isEmpty ? null : _q,
      isActive: _isActive(_status),
      productKind: _kind,
      productFamilyId: _family,
    );
    final api = ref.read(apiClientProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _SearchField(hint: 'Buscar por nome, código ou GTIN', onChanged: (q) => setState(() => _q = q)),
              SizedBox(
                width: 180,
                child: DropdownButtonFormField<ProductKind?>(
                  initialValue: _kind,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: [
                    const DropdownMenuItem(child: Text('Todos')),
                    for (final k in ProductKind.values)
                      DropdownMenuItem(value: k, child: Text(CatalogFormat.productKind(k))),
                  ],
                  onChanged: (k) => setState(() => _kind = k),
                ),
              ),
              if (_families.tree.isNotEmpty)
                SizedBox(
                  width: 260,
                  child: DropdownButtonFormField<UuidValue?>(
                    initialValue: _family,
                    isExpanded: true,
                    decoration: const InputDecoration(labelText: 'Família'),
                    items: [
                      const DropdownMenuItem(child: Text('Todas')),
                      for (final n in _families.tree)
                        DropdownMenuItem(
                          value: n.family.id,
                          child: Text('${'   ' * n.depth}${n.family.name}', overflow: TextOverflow.ellipsis),
                        ),
                    ],
                    onChanged: (f) => setState(() => _family = f),
                  ),
                ),
              _statusFilter(_status, (s) => setState(() => _status = s)),
              if (widget.canManage)
                FilledButton.icon(
                  onPressed: () => _open('/catalogo/produtos/novo'),
                  icon: const Icon(Icons.add),
                  label: const Text('Novo produto'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PagedTable<Product>(
              key: _table,
              query: filter.toJson().toString(),
              load: (page) async {
                final p = await api.products.list(filter, page);
                return PageSlice(p.items, hasMore: p.hasMore, nextCursor: p.nextCursor, total: p.total);
              },
              onTap: (p) => _open('/catalogo/produtos/${p.id.uuid}'),
              emptyIcon: Icons.inventory_2_outlined,
              emptyMessage: _q.isEmpty && _kind == null && _family == null
                  ? 'Nenhum produto cadastrado ainda.'
                  : 'Nenhum produto encontrado.',
              totalLabel: (n) => n == 1 ? '1 produto' : '$n produtos',
              columns: [
                PagedColumn('Produto', (p) => TwoLineCell(p.name, secondary: _families.path(p.productFamilyId))),
                PagedColumn('Código', (p) => Text(p.code)),
                PagedColumn('Tipo', (p) => Text(CatalogFormat.productKind(p.productKind))),
                PagedColumn('Preço de referência', (p) => Text(CatalogFormat.price(p.referencePrice)), numeric: true),
                PagedColumn('Situação', (p) => _activePill(p.isActive, p.source)),
              ],
              tile: (p) => ListTile(
                title: Text(p.name),
                subtitle: Text('${p.code} · ${CatalogFormat.productKind(p.productKind)}'),
                trailing: _activePill(p.isActive, p.source),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Serviços
// ---------------------------------------------------------------------------

class _ServicesTab extends ConsumerStatefulWidget {
  const _ServicesTab({required this.canManage});
  final bool canManage;

  @override
  ConsumerState<_ServicesTab> createState() => _ServicesTabState();
}

class _ServicesTabState extends ConsumerState<_ServicesTab> {
  final _table = GlobalKey<PagedTableState<CatalogService>>();
  String _q = '';
  _Status _status = _Status.active;
  ServiceKind? _kind;

  Future<void> _open(String path) async {
    final changed = await context.push<bool>(path);
    if (changed == true) await _table.currentState?.reload();
  }

  @override
  Widget build(BuildContext context) {
    final filter = CatalogServiceFilter(q: _q.isEmpty ? null : _q, isActive: _isActive(_status), serviceKind: _kind);
    final api = ref.read(apiClientProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _SearchField(hint: 'Buscar por nome ou código', onChanged: (q) => setState(() => _q = q)),
              SizedBox(
                width: 200,
                child: DropdownButtonFormField<ServiceKind?>(
                  initialValue: _kind,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: [
                    const DropdownMenuItem(child: Text('Todos')),
                    for (final k in ServiceKind.values)
                      DropdownMenuItem(value: k, child: Text(CatalogFormat.serviceKind(k))),
                  ],
                  onChanged: (k) => setState(() => _kind = k),
                ),
              ),
              _statusFilter(_status, (s) => setState(() => _status = s)),
              if (widget.canManage)
                FilledButton.icon(
                  onPressed: () => _open('/catalogo/servicos/novo'),
                  icon: const Icon(Icons.add),
                  label: const Text('Novo serviço'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: PagedTable<CatalogService>(
              key: _table,
              query: filter.toJson().toString(),
              load: (page) async {
                final p = await api.services.list(filter, page);
                return PageSlice(p.items, hasMore: p.hasMore, nextCursor: p.nextCursor, total: p.total);
              },
              onTap: (s) => _open('/catalogo/servicos/${s.id.uuid}'),
              emptyIcon: Icons.handyman_outlined,
              emptyMessage: _q.isEmpty && _kind == null
                  ? 'Nenhum serviço cadastrado ainda.'
                  : 'Nenhum serviço encontrado.',
              totalLabel: (n) => n == 1 ? '1 serviço' : '$n serviços',
              columns: [
                PagedColumn('Serviço', (s) => TwoLineCell(s.name, secondary: s.description)),
                PagedColumn('Código', (s) => Text(s.code)),
                PagedColumn('Tipo', (s) => Text(CatalogFormat.serviceKind(s.serviceKind))),
                PagedColumn(
                  'Preço',
                  (s) => Text('${CatalogFormat.price(s.defaultPrice)} / ${s.unitCode}'),
                  numeric: true,
                ),
                PagedColumn('Tempo estimado', (s) => Text(CatalogFormat.minutes(s.estimatedMinutes))),
                PagedColumn('Situação', (s) => _activePill(s.isActive, s.source)),
              ],
              tile: (s) => ListTile(
                title: Text(s.name),
                subtitle: Text('${s.code} · ${CatalogFormat.serviceKind(s.serviceKind)}'),
                trailing: _activePill(s.isActive, s.source),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
