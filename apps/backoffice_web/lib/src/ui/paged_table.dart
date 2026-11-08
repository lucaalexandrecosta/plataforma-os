import 'package:flutter/material.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import 'errors.dart';

/// Uma página de qualquer listagem da API (`<Recurso>Page`).
final class PageSlice<T> {
  const PageSlice(this.items, {required this.hasMore, this.nextCursor, this.total});
  final List<T> items;
  final bool hasMore;
  final String? nextCursor;
  final int? total;
}

/// Coluna da tabela larga.
final class PagedColumn<T> {
  const PagedColumn(this.label, this.cell, {this.numeric = false});
  final String label;
  final Widget Function(T item) cell;
  final bool numeric;
}

/// Lista paginada por cursor ("Carregar mais"): tabela em telas largas,
/// lista em telas estreitas. Recarrega do início quando [query] muda (o
/// pai guarda os filtros e passa um valor que os resume).
class PagedTable<T> extends StatefulWidget {
  const PagedTable({
    required this.query,
    required this.load,
    required this.columns,
    required this.tile,
    required this.emptyMessage,
    required this.totalLabel,
    this.onTap,
    this.emptyIcon = Icons.inbox_outlined,
    this.emptyAction,
    this.pageSize = 50,
    super.key,
  });

  final Object? query;
  final Future<PageSlice<T>> Function(PageRequest page) load;
  final List<PagedColumn<T>> columns;
  final ListTile Function(T item) tile;
  final void Function(T item)? onTap;
  final String emptyMessage;
  final IconData emptyIcon;
  final Widget? emptyAction;
  final String Function(int total) totalLabel;
  final int pageSize;

  @override
  State<PagedTable<T>> createState() => PagedTableState<T>();
}

class PagedTableState<T> extends State<PagedTable<T>> {
  final List<T> _items = [];
  String? _cursor;
  bool _hasMore = false;
  int? _total;
  bool _loading = false;
  Object? _error;
  int _request = 0; // descarta respostas de buscas antigas

  @override
  void initState() {
    super.initState();
    reload();
  }

  @override
  void didUpdateWidget(PagedTable<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.query != widget.query) reload();
  }

  Future<void> reload() => _load(reset: true);

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
      final page = await widget.load(
        PageRequest(limit: widget.pageSize, cursor: reset ? null : _cursor, includeTotal: reset),
      );
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (_error != null && _items.isEmpty) return ErrorPanel(error: _error!, onRetry: reload);
    if (_loading && _items.isEmpty) return const Center(child: CircularProgressIndicator());
    if (_items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(widget.emptyIcon, size: 48, color: theme.colorScheme.outline),
            const SizedBox(height: 8),
            Text(widget.emptyMessage),
            if (widget.emptyAction != null) ...[const SizedBox(height: 12), widget.emptyAction!],
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
            if (_total != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  widget.totalLabel(_total!),
                  style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ),
            Card(
              clipBehavior: Clip.antiAlias,
              child: compact ? _compactList() : _table(constraints.maxWidth),
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

  Widget _table(double width) => ConstrainedBox(
    constraints: BoxConstraints(minWidth: width),
    child: DataTable(
      showCheckboxColumn: false,
      columns: [for (final c in widget.columns) DataColumn(label: Text(c.label), numeric: c.numeric)],
      rows: [
        for (final item in _items)
          DataRow(
            onSelectChanged: widget.onTap == null ? null : (_) => widget.onTap!(item),
            cells: [for (final c in widget.columns) DataCell(c.cell(item))],
          ),
      ],
    ),
  );

  Widget _compactList() => Column(
    children: [
      for (final (i, item) in _items.indexed) ...[
        if (i > 0) const Divider(height: 1),
        _withTap(widget.tile(item), item),
      ],
    ],
  );

  Widget _withTap(ListTile tile, T item) => widget.onTap == null
      ? tile
      : ListTile(
          title: tile.title,
          subtitle: tile.subtitle,
          leading: tile.leading,
          trailing: tile.trailing,
          onTap: () => widget.onTap!(item),
        );
}

/// Duas linhas numa célula: principal e secundária (ex.: nome e descrição).
class TwoLineCell extends StatelessWidget {
  const TwoLineCell(this.primary, {this.secondary, super.key});
  final String primary;
  final String? secondary;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(primary, style: const TextStyle(fontWeight: FontWeight.w500)),
        if (secondary != null)
          Text(
            secondary!,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
      ],
    );
  }
}
