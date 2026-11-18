import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';
import '../common/status_chip.dart';
import 'customer_dialogs.dart';

/// Ficha do cliente: dados, unidades (locais de atendimento), contatos e bens.
class CustomerDetailPage extends ConsumerStatefulWidget {
  const CustomerDetailPage({super.key, required this.id});

  final UuidValue id;

  @override
  ConsumerState<CustomerDetailPage> createState() => _CustomerDetailPageState();
}

class _CustomerDetailPageState extends ConsumerState<CustomerDetailPage> {
  late Future<(Customer, List<CustomerSite>, List<CustomerContact>)> _data;
  late Future<AssetPage> _assets;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(CustomerDetailPage old) {
    super.didUpdateWidget(old);
    if (old.id != widget.id) setState(_load);
  }

  void _load() {
    final g = ref.read(gatewayProvider);
    _data = () async {
      final sites = g.customerSites(widget.id);
      final contacts = g.customerContacts(widget.id);
      final customer = await g.customer(widget.id);
      return (customer, await sites, await contacts);
    }();
    _assets = g.assets(customerId: widget.id, limit: 100);
  }

  Future<void> _edit(Customer customer) async {
    final saved = await showDialog<Customer>(
      context: context,
      builder: (_) => CustomerDialog(customer: customer),
    );
    if (saved != null && mounted) setState(_load);
  }

  Future<void> _editSite([CustomerSite? site]) async {
    final saved = await showDialog<CustomerSite>(
      context: context,
      builder: (_) => CustomerSiteDialog(customerId: widget.id, site: site),
    );
    if (saved != null && mounted) setState(_load);
  }

  Future<void> _editContact(List<CustomerSite> sites, [CustomerContact? contact]) async {
    final saved = await showDialog<CustomerContact>(
      context: context,
      builder: (_) => CustomerContactDialog(customerId: widget.id, sites: sites, contact: contact),
    );
    if (saved != null && mounted) setState(_load);
  }

  static String _contactLine(CustomerContact c) => [
    if (c.jobTitle != null) c.jobTitle!,
    if (c.phone != null) formatPhone(c.phone!),
    if (c.email != null) c.email!,
    c.customerSiteName ?? 'Todas as unidades',
    if (c.preferredChannel != null) 'prefere ${contactChannelLabels[c.preferredChannel] ?? c.preferredChannel}',
    if (!c.canOpenRequests) 'não abre chamados',
  ].join(' · ');

  static String? _address(CustomerSite s) {
    final line1 = [s.street, s.streetNumber, s.complement].whereType<String>().join(', ');
    final line2 = [
      s.district,
      [s.city, s.state].whereType<String>().join('/'),
    ].where((p) => p != null && p.isNotEmpty);
    final parts = [
      if (line1.isNotEmpty) line1,
      ...line2.whereType<String>(),
      if (s.postalCode != null) 'CEP ${formatCep(s.postalCode!)}',
    ];
    return parts.isEmpty ? null : parts.join(' · ');
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final canManage = session is SignedIn && session.can('customers.manage');
    return FutureBuilder<(Customer, List<CustomerSite>, List<CustomerContact>)>(
      future: _data,
      builder: (context, snap) {
        if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: () => setState(_load));
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final (c, sites, contacts) = snap.data!;
        final theme = Theme.of(context);
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  tooltip: 'Voltar à lista',
                  onPressed: () => context.go('/clientes'),
                  icon: const Icon(Icons.arrow_back),
                ),
                Text(c.tradeName ?? c.name, style: theme.textTheme.headlineSmall),
                if (!c.isActive) const Chip(label: Text('Inativo')),
                if (canManage)
                  OutlinedButton.icon(
                    key: const Key('customer-edit'),
                    onPressed: () => _edit(c),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Editar'),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FieldRow(c.personType == 'individual' ? 'Nome' : 'Razão social', c.name),
                    FieldRow('Código', c.code),
                    FieldRow(c.documentType == 'cpf' ? 'CPF' : 'CNPJ', formatDocument(c.documentNumber)),
                    FieldRow('Inscrição estadual', c.stateRegistration),
                    FieldRow('E-mail', c.email),
                    FieldRow('Telefone', c.phone),
                    FieldRow('Observações', c.notes),
                    if (c.source == 'erp') const FieldRow('Origem', 'ERP (campos mestres só leitura)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Text('Unidades', style: theme.textTheme.titleMedium)),
                if (canManage)
                  FilledButton.tonalIcon(
                    key: const Key('site-new'),
                    onPressed: _editSite,
                    icon: const Icon(Icons.add_location_alt_outlined),
                    label: const Text('Nova unidade'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (sites.isEmpty)
              const Text('Nenhuma unidade. Cadastre o local onde ficam os equipamentos.')
            else
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (final s in sites)
                      ListTile(
                        key: ValueKey(s.id),
                        leading: Icon(s.latitude == null ? Icons.store_outlined : Icons.location_on_outlined),
                        title: Text(s.isActive ? s.name : '${s.name} (inativa)'),
                        subtitle: Text(
                          [_address(s), s.accessNotes].whereType<String>().join('\n').ifEmpty('Sem endereço'),
                        ),
                        isThreeLine: s.accessNotes != null && _address(s) != null,
                        onTap: canManage ? () => _editSite(s) : null,
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Text('Contatos', style: theme.textTheme.titleMedium)),
                if (canManage)
                  FilledButton.tonalIcon(
                    key: const Key('contact-new'),
                    onPressed: () => _editContact(sites),
                    icon: const Icon(Icons.person_add_alt_outlined),
                    label: const Text('Novo contato'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (contacts.isEmpty)
              const Text('Nenhum contato. Cadastre quem abre chamados e recebe os avisos.')
            else
              Card(
                margin: EdgeInsets.zero,
                child: Column(
                  children: [
                    for (final ct in contacts)
                      ListTile(
                        key: ValueKey(ct.id),
                        leading: Icon(
                          ct.contactRole == 'customer_admin'
                              ? Icons.admin_panel_settings_outlined
                              : Icons.person_outline,
                        ),
                        title: Text(
                          [
                            ct.name,
                            if (!ct.isActive) '(inativo)',
                            if (ct.isActive && ct.status != 'active')
                              '(${contactStatusLabels[ct.status] ?? ct.status})',
                          ].join(' '),
                        ),
                        subtitle: Text(_contactLine(ct)),
                        onTap: canManage ? () => _editContact(sites, ct) : null,
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 16),
            Text('Bens no cliente', style: theme.textTheme.titleMedium),
            const SizedBox(height: 8),
            FutureBuilder<AssetPage>(
              future: _assets,
              builder: (context, snap) {
                if (snap.hasError) return Text(errorMessage(snap.error!));
                if (!snap.hasData) return const LinearProgressIndicator();
                final page = snap.data!;
                if (page.items.isEmpty) {
                  return const Text('Nenhum bem instalado. Instale pela ficha do bem.');
                }
                return Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (final a in page.items)
                        ListTile(
                          key: ValueKey(a.id),
                          leading: const Icon(Icons.inventory_2_outlined),
                          title: Text('${a.assetTag ?? a.serialNumber ?? '—'} · ${a.productName}'),
                          subtitle: Text(a.customerSiteName ?? ''),
                          onTap: () => context.go('/bens/${a.id}'),
                        ),
                      if (page.total > page.items.length)
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('Mostrando ${page.items.length} de ${page.total}.'),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

extension on String {
  String ifEmpty(String fallback) => isEmpty ? fallback : this;
}
