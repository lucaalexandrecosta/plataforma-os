import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/paged_table.dart';

/// Lista de bens com busca por patrimônio, série ou produto.
class AssetsPage extends ConsumerStatefulWidget {
  const AssetsPage({super.key});

  @override
  ConsumerState<AssetsPage> createState() => _AssetsPageState();
}

class _AssetsPageState extends ConsumerState<AssetsPage> {
  final _search = TextEditingController();
  var _offset = 0;
  late Future<AssetPage> _page;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _load() {
    _page = ref.read(gatewayProvider).assets(search: _search.text, limit: PagerBar.pageSize, offset: _offset);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Bens',
          filters: [
            SizedBox(
              width: 320,
              child: TextField(
                key: const Key('asset-search'),
                controller: _search,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Patrimônio, série ou produto',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => setState(() {
                  _offset = 0;
                  _load();
                }),
              ),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder<AssetPage>(
            future: _page,
            builder: (context, snap) {
              if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: () => setState(_load));
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final page = snap.data!;
              if (page.items.isEmpty) return const Center(child: Text('Nenhum bem encontrado.'));
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          showCheckboxColumn: false,
                          columns: const [
                            DataColumn(label: Text('Patrimônio')),
                            DataColumn(label: Text('Produto')),
                            DataColumn(label: Text('Série')),
                            DataColumn(label: Text('Situação')),
                            DataColumn(label: Text('Etiqueta')),
                          ],
                          rows: [
                            for (final a in page.items)
                              DataRow(
                                key: ValueKey(a.id),
                                onSelectChanged: (_) => context.go('/bens/${a.id}'),
                                cells: [
                                  DataCell(
                                    Text(a.assetTag ?? '—', style: const TextStyle(fontWeight: FontWeight.w600)),
                                  ),
                                  DataCell(Text(a.productName)),
                                  DataCell(Text(a.serialNumber ?? '—')),
                                  DataCell(Text(a.isActive ? label(assetStatusLabels, a.status) : 'Inativo')),
                                  DataCell(Text(a.qrShortCode ?? '—')),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  PagerBar(
                    offset: _offset,
                    count: page.items.length,
                    total: page.total,
                    onPage: (o) => setState(() {
                      _offset = o;
                      _load();
                    }),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
