import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/api_client.dart';
import '../../auth/auth_controller.dart';
import '../../ui/errors.dart';
import 'customer_format.dart';

enum _StatusFilter { active, inactive, all }

/// Lista de clientes (`customers.list`): busca por nome, fantasia, código ou
/// documento; filtro de situação; paginação por cursor ("Carregar mais").
class CustomersListPage extends ConsumerStatefulWidget {
  const CustomersListPage({super.key});

  @override
  ConsumerState<CustomersListPage> createState() => _CustomersListPageState();
}

class _CustomersListPageState extends ConsumerState<CustomersListPage> {
  static const _pageSize = 50;

  final _search = TextEditingController();
  Timer? _debounce;
  _StatusFilter _status = _StatusFilter.active;

  final List<Customer> _items = [];
  String? _cursor;
  bool _hasMore = false;
  int? _total;
  bool _loading = false;
  Object? _error;
  int _request = 0; // descarta respostas de buscas antigas

  @override
  void initState() {
    super.initState();
    _reload();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  CustomerFilter get _filter {
    final q = _search.text.trim();
    return CustomerFilter(
      q: q.length >= 2 ? q : null,
      isActive: switch (_status) {
        _StatusFilter.active => true,
        _StatusFilter.inactive => false,
        _StatusFilter.all => null,
      },
    );
  }

  Future<void> _reload() => _load(reset: true);

  Future<void> _load({required bool reset}) async {
    final request = ++_request;
    setState(() {
      _loading = true;
      _error = null;
      if (reset) {
        _items.clear();
        _cursor = null;
        _total = null;
      }
    });
    try {
      final page = await ref
          .read(apiClientProvider)
          .customers
          .list(_filter, PageRequest(limit: _pageSize, cursor: reset ? null : _cursor, includeTotal: reset));
      if (!mounted || request != _request) return;
      setState(() {
        _items.addAll(page.items);
        _cursor = page.nextCursor;
        _hasMore = page.hasMore;
        if (reset) _total = page.total;
        _loading = false;
      });
    } on Object catch (e) {
      if (!mounted || request != _request) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), _reload);
  }

  Future<void> _open(String path) async {
    final changed = await context.push<bool>(path);
    if (changed == true) await _reload();
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final canManage = auth is AuthSignedIn && auth.can('customers.manage');
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(child: Text('Clientes', style: theme.textTheme.headlineSmall)),
              if (canManage)
                FilledButton.icon(
                  onPressed: () => _open('/clientes/novo'),
                  icon: const Icon(Icons.add),
                  label: const Text('Novo cliente'),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              SizedBox(
                width: 360,
                child: TextField(
                  controller: _search,
                  onChanged: _onSearchChanged,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Buscar por nome, código, CNPJ ou CPF',
                    suffixIcon: _search.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Limpar',
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _search.clear();
                              _reload();
                            },
                          ),
                  ),
                ),
              ),
              SegmentedButton<_StatusFilter>(
                segments: const [
                  ButtonSegment(value: _StatusFilter.active, label: Text('Ativos')),
                  ButtonSegment(value: _StatusFilter.inactive, label: Text('Inativos')),
                  ButtonSegment(value: _StatusFilter.all, label: Text('Todos')),
                ],
                selected: {_status},
                onSelectionChanged: (s) {
                  setState(() => _status = s.first);
                  _reload();
                },
              ),
              if (_total != null)
                Text(
                  _total == 1 ? '1 cliente' : '$_total clientes',
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: _body(theme, canManage)),
        ],
      ),
    );
  }

  Widget _body(ThemeData theme, bool canManage) {
    if (_error != null && _items.isEmpty) return ErrorPanel(error: _error!, onRetry: _reload);
    if (_loading && _items.isEmpty) return const Center(child: CircularProgressIndicator());
    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront_outlined, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 8),
            Text(_filter.q == null ? 'Nenhum cliente cadastrado ainda.' : 'Nenhum cliente encontrado.'),
            if (canManage && _filter.q == null) ...[
              const SizedBox(height: 12),
              FilledButton.tonal(onPressed: () => _open('/clientes/novo'), child: const Text('Cadastrar o primeiro')),
            ],
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 720;
        return ListView(
          padding: const EdgeInsets.only(bottom: 24),
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: compact ? _compactList(theme) : _table(theme, constraints.maxWidth),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(describeError(_error!), style: TextStyle(color: theme.colorScheme.error)),
              ),
            if (_hasMore)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Center(
                  child: _loading
                      ? const CircularProgressIndicator()
                      : OutlinedButton(onPressed: () => _load(reset: false), child: const Text('Carregar mais')),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _table(ThemeData theme, double width) => ConstrainedBox(
    constraints: BoxConstraints(minWidth: width),
    child: DataTable(
      showCheckboxColumn: false,
      columns: const [
        DataColumn(label: Text('Cliente')),
        DataColumn(label: Text('Código')),
        DataColumn(label: Text('Documento')),
        DataColumn(label: Text('Telefone')),
        DataColumn(label: Text('Situação')),
      ],
      rows: [
        for (final c in _items)
          DataRow(
            onSelectChanged: (_) => _open('/clientes/${c.id.uuid}'),
            cells: [
              DataCell(
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(c.name, style: const TextStyle(fontWeight: FontWeight.w500)),
                    if (c.tradeName != null)
                      Text(
                        c.tradeName!,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                  ],
                ),
              ),
              DataCell(Text(c.code ?? '—')),
              DataCell(Text(CustomerFormat.document(c))),
              DataCell(Text(CustomerFormat.phone(c.phone))),
              DataCell(_StatusChip(active: c.isActive)),
            ],
          ),
      ],
    ),
  );

  Widget _compactList(ThemeData theme) => Column(
    children: [
      for (final (i, c) in _items.indexed) ...[
        if (i > 0) const Divider(height: 1),
        ListTile(
          title: Text(c.name),
          subtitle: Text([c.code, CustomerFormat.document(c)].whereType<String>().join(' · ')),
          trailing: _StatusChip(active: c.isActive),
          onTap: () => _open('/clientes/${c.id.uuid}'),
        ),
      ],
    ],
  );
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.active});
  final bool active;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: active ? scheme.primaryContainer : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        active ? 'Ativo' : 'Inativo',
        style: TextStyle(color: active ? scheme.onPrimaryContainer : scheme.onSurfaceVariant, fontSize: 12),
      ),
    );
  }
}
