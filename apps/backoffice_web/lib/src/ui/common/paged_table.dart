import 'package:flutter/material.dart';

/// Rodapé de paginação: "1–50 de 312" com anterior e próxima.
class PagerBar extends StatelessWidget {
  const PagerBar({super.key, required this.offset, required this.count, required this.total, required this.onPage});

  final int offset;
  final int count;
  final int total;

  /// Recebe o novo deslocamento.
  final ValueChanged<int> onPage;

  static const pageSize = 50;

  @override
  Widget build(BuildContext context) {
    final from = total == 0 ? 0 : offset + 1;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text('$from–${offset + count} de $total'),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'Página anterior',
            onPressed: offset == 0 ? null : () => onPage((offset - pageSize).clamp(0, total)),
            icon: const Icon(Icons.chevron_left),
          ),
          IconButton(
            tooltip: 'Próxima página',
            onPressed: offset + count >= total ? null : () => onPage(offset + pageSize),
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}

/// Cabeçalho de página: título, filtros e ações.
class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.title, this.filters = const [], this.actions = const []});

  final String title;
  final List<Widget> filters;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(width: 12),
          ...filters,
          ...actions,
        ],
      ),
    );
  }
}
