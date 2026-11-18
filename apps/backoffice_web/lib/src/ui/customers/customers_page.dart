import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';
import '../common/paged_table.dart';
import 'customer_dialogs.dart';

/// Lista de clientes com busca por nome, código ou documento.
class CustomersPage extends ConsumerStatefulWidget {
  const CustomersPage({super.key});

  @override
  ConsumerState<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends ConsumerState<CustomersPage> {
  final _search = TextEditingController();
  var _offset = 0;
  var _inactive = false;
  late Future<CustomerPage> _page;

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
    _page = ref
        .read(gatewayProvider)
        .customers(search: _search.text, includeInactive: _inactive, limit: PagerBar.pageSize, offset: _offset);
  }

  void _reload() => setState(() {
    _offset = 0;
    _load();
  });

  Future<void> _new() async {
    final saved = await showDialog<Customer>(context: context, builder: (_) => const CustomerDialog());
    if (saved != null && mounted) context.go('/clientes/${saved.id}');
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final canManage = session is SignedIn && session.can('customers.manage');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Clientes',
          filters: [
            SizedBox(
              width: 320,
              child: TextField(
                key: const Key('customer-search'),
                controller: _search,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Nome, código ou CNPJ/CPF',
                  isDense: true,
                  border: OutlineInputBorder(),
                ),
                onSubmitted: (_) => _reload(),
              ),
            ),
            FilterChip(
              key: const Key('customer-inactive'),
              label: const Text('Mostrar inativos'),
              selected: _inactive,
              onSelected: (v) {
                _inactive = v;
                _reload();
              },
            ),
          ],
          actions: [
            if (canManage)
              FilledButton.icon(
                key: const Key('customer-new'),
                onPressed: _new,
                icon: const Icon(Icons.add),
                label: const Text('Novo cliente'),
              ),
          ],
        ),
        Expanded(
          child: FutureBuilder<CustomerPage>(
            future: _page,
            builder: (context, snap) {
              if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: () => setState(_load));
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final page = snap.data!;
              if (page.items.isEmpty) return const Center(child: Text('Nenhum cliente encontrado.'));
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
                            DataColumn(label: Text('Cliente')),
                            DataColumn(label: Text('Razão social / nome')),
                            DataColumn(label: Text('Código')),
                            DataColumn(label: Text('CNPJ/CPF')),
                            DataColumn(label: Text('Unidades'), numeric: true),
                            DataColumn(label: Text('Situação')),
                          ],
                          rows: [
                            for (final c in page.items)
                              DataRow(
                                key: ValueKey(c.id),
                                onSelectChanged: (_) => context.go('/clientes/${c.id}'),
                                cells: [
                                  DataCell(
                                    Text(
                                      c.tradeName ?? c.name,
                                      style: const TextStyle(fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  DataCell(Text(c.name)),
                                  DataCell(Text(c.code ?? '—')),
                                  DataCell(Text(formatDocument(c.documentNumber) ?? '—')),
                                  DataCell(Text('${c.siteCount}')),
                                  DataCell(Text(c.isActive ? 'Ativo' : 'Inativo')),
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
