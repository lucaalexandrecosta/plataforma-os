import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_core/plataforma_os_core.dart';

import '../../api/api_client.dart';
import '../../ui/dialogs.dart';
import '../../ui/errors.dart';
import 'customer_format.dart';

/// Aba Contatos da ficha do cliente: quem abre chamados pelo app do cliente
/// ou pela página do QR. Aprovar pendentes (autocadastro), bloquear e
/// desbloquear. O convite por WhatsApp/e-mail entra com as notificações.
class ContactsTab extends ConsumerStatefulWidget {
  const ContactsTab({required this.customer, required this.canManage, super.key});

  final Customer customer;
  final bool canManage;

  @override
  ConsumerState<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends ConsumerState<ContactsTab> {
  List<CustomerContact>? _contacts;
  Map<UuidValue, CustomerSite> _sites = const {};
  Object? _error;
  bool _showInactive = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    final client = ref.read(apiClientProvider);
    try {
      final contacts = <CustomerContact>[];
      String? cursor;
      do {
        final page = await client.customerContacts.list(
          CustomerContactFilter(customerId: widget.customer.id),
          PageRequest(limit: 200, cursor: cursor),
        );
        contacts.addAll(page.items);
        cursor = page.nextCursor;
      } while (cursor != null);
      final sites = await client.customerSites.list(
        CustomerSiteFilter(customerId: widget.customer.id),
        PageRequest(limit: 200),
      );
      if (mounted) {
        setState(() {
          _contacts = contacts;
          _sites = {for (final s in sites.items) s.id: s};
        });
      }
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _edit([CustomerContact? contact]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _ContactDialog(
        customer: widget.customer,
        contact: contact,
        sites: _sites.values.where((s) => s.isActive || s.id == contact?.customerSiteId).toList(),
        canManage: widget.canManage,
      ),
    );
    if (saved == true) await _load();
  }

  Future<void> _act(CustomerContact c, String action) async {
    final api = ref.read(apiClientProvider).customerContacts;
    try {
      switch (action) {
        case 'approve':
          await api.approve(c.id, c.version);
          if (mounted) showInfoSnack(context, '${c.name} aprovado.');
        case 'block':
          final reason = await askReason(
            context,
            title: 'Bloquear ${c.name}',
            message: 'O contato não consegue mais entrar nem abrir chamados. As sessões abertas são encerradas.',
            confirmLabel: 'Bloquear',
          );
          if (reason == null) return;
          await api.block(c.id, reason, c.version);
        case 'unblock':
          await api.unblock(c.id, c.version);
        case 'deactivate':
          final reason = await askReason(
            context,
            title: 'Inativar ${c.name}',
            message: 'Use quando a pessoa saiu do cliente. O histórico de chamados continua.',
            confirmLabel: 'Inativar',
          );
          if (reason == null) return;
          await api.deactivate(c.id, reason, c.version);
        case 'reactivate':
          await api.reactivate(c.id, c.version);
      }
      await _load();
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.code == 'VERSION_MISMATCH') {
        showInfoSnack(context, 'O contato foi alterado por outra pessoa; a lista foi recarregada.');
        await _load();
      } else {
        showErrorSnack(context, e);
      }
    } on Object catch (e) {
      if (mounted) showErrorSnack(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return ErrorPanel(error: _error!, onRetry: _load);
    final contacts = _contacts;
    if (contacts == null) return const Center(child: CircularProgressIndicator());
    final visible = _showInactive ? contacts : contacts.where((c) => c.isActive).toList();
    final pending = contacts.where((c) => c.isActive && c.status == ContactStatus.pending_approval).length;
    final inactive = contacts.length - contacts.where((c) => c.isActive).length;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            Expanded(child: Text('${visible.length} contato(s)', style: theme.textTheme.titleMedium)),
            if (inactive > 0)
              FilterChip(
                label: Text('Mostrar inativos ($inactive)'),
                selected: _showInactive,
                onSelected: (v) => setState(() => _showInactive = v),
              ),
            const SizedBox(width: 12),
            if (widget.canManage && widget.customer.isActive)
              FilledButton.icon(
                onPressed: _edit,
                icon: const Icon(Icons.person_add_alt),
                label: const Text('Novo contato'),
              ),
          ],
        ),
        if (pending > 0) ...[
          const SizedBox(height: 12),
          Card(
            color: theme.colorScheme.tertiaryContainer,
            child: ListTile(
              leading: Icon(Icons.how_to_reg_outlined, color: theme.colorScheme.onTertiaryContainer),
              title: Text(
                pending == 1 ? '1 contato aguardando aprovação' : '$pending contatos aguardando aprovação',
                style: TextStyle(color: theme.colorScheme.onTertiaryContainer),
              ),
              subtitle: Text(
                'Cadastraram-se pela leitura do QR. Confira se são mesmo deste cliente antes de aprovar.',
                style: TextStyle(color: theme.colorScheme.onTertiaryContainer),
              ),
            ),
          ),
        ],
        const SizedBox(height: 16),
        if (visible.isEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: Text('Nenhum contato. Contatos abrem chamados pelo app do cliente ou pelo QR.')),
          ),
        for (final c in visible)
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(c.name.isEmpty ? '?' : c.name[0].toUpperCase())),
              title: Wrap(
                spacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(c.name),
                  if (c.contactRole == ContactRole.customer_admin)
                    const StatusPill(label: 'Administrador', tone: StatusTone.neutral),
                  _statusPill(c),
                ],
              ),
              subtitle: Text(
                [
                  [
                    c.jobTitle,
                    c.customerSiteId == null ? 'Todas as unidades' : _sites[c.customerSiteId]?.name,
                  ].whereType<String>().join(' · '),
                  [if (c.phoneE164 != null) CustomerFormat.phone(c.phoneE164), c.email].whereType<String>().join(' · '),
                  if (c.status == ContactStatus.blocked && c.blockedReason != null) 'Bloqueado: ${c.blockedReason}',
                ].where((x) => x.isNotEmpty).join('\n'),
              ),
              isThreeLine: c.status == ContactStatus.blocked,
              onTap: () => _edit(c),
              trailing: widget.canManage
                  ? PopupMenuButton<String>(
                      tooltip: 'Ações',
                      onSelected: (a) => _act(c, a),
                      itemBuilder: (_) => [
                        if (c.isActive && c.status == ContactStatus.pending_approval)
                          const PopupMenuItem(value: 'approve', child: Text('Aprovar')),
                        if (c.isActive && c.status != ContactStatus.blocked)
                          const PopupMenuItem(value: 'block', child: Text('Bloquear')),
                        if (c.status == ContactStatus.blocked)
                          const PopupMenuItem(value: 'unblock', child: Text('Desbloquear')),
                        if (c.isActive) const PopupMenuItem(value: 'deactivate', child: Text('Inativar')),
                        if (!c.isActive) const PopupMenuItem(value: 'reactivate', child: Text('Reativar')),
                      ],
                    )
                  : null,
            ),
          ),
      ],
    );
  }

  Widget _statusPill(CustomerContact c) {
    if (!c.isActive) return const StatusPill(label: 'Inativo', tone: StatusTone.neutral);
    return switch (c.status) {
      ContactStatus.active => const StatusPill(label: 'Ativo', tone: StatusTone.positive),
      ContactStatus.pending_approval => const StatusPill(label: 'Pendente', tone: StatusTone.warning),
      ContactStatus.blocked => const StatusPill(label: 'Bloqueado', tone: StatusTone.negative),
    };
  }
}

class _ContactDialog extends ConsumerStatefulWidget {
  const _ContactDialog({required this.customer, required this.sites, required this.canManage, this.contact});

  final Customer customer;
  final CustomerContact? contact;
  final List<CustomerSite> sites;
  final bool canManage;

  @override
  ConsumerState<_ContactDialog> createState() => _ContactDialogState();
}

class _ContactDialogState extends ConsumerState<_ContactDialog> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.contact?.name);
  late final _phone = TextEditingController(
    text: widget.contact?.phoneE164 == null ? '' : CustomerFormat.phone(widget.contact!.phoneE164),
  );
  late final _email = TextEditingController(text: widget.contact?.email);
  late final _job = TextEditingController(text: widget.contact?.jobTitle);
  late UuidValue? _siteId = widget.contact?.customerSiteId;
  late ContactRole _role = widget.contact?.contactRole ?? ContactRole.customer_contact;
  late bool _canOpen = widget.contact?.canOpenRequests ?? true;
  late NotificationChannel? _channel = widget.contact?.preferredChannel;
  bool _saving = false;
  Map<String, String> _serverErrors = const {};

  bool get _isNew => widget.contact == null;
  bool get _fromErp => widget.contact?.source == RecordSource.erp;
  bool get _readOnly => !widget.canManage || _saving;

  @override
  void dispose() {
    for (final c in [_name, _phone, _email, _job]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _t(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  Future<void> _save() async {
    setState(() => _serverErrors = const {});
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final api = ref.read(apiClientProvider).customerContacts;
    try {
      if (_isNew) {
        await api.create(
          CustomerContactInput(
            id: const Uuid().v7obj(),
            customerId: widget.customer.id,
            customerSiteId: _siteId,
            name: _name.text,
            phone: _t(_phone),
            email: _t(_email),
            jobTitle: _t(_job),
            contactRole: _role,
            canOpenRequests: _canOpen,
            preferredChannel: _channel,
          ),
        );
      } else {
        final c = widget.contact!;
        final clear = <CustomerContactField>[];
        String? diff(
          TextEditingController ctl,
          String? current,
          CustomerContactField field, {
          String Function(String)? norm,
        }) {
          final v = _t(ctl);
          if (v == null) {
            if (current != null) clear.add(field);
            return null;
          }
          return (norm?.call(v) ?? v) == current ? null : v;
        }

        if (_siteId == null && c.customerSiteId != null) clear.add(CustomerContactField.customerSiteId);
        if (_channel == null && c.preferredChannel != null) clear.add(CustomerContactField.preferredChannel);
        final patch = CustomerContactPatch(
          name: _name.text.trim() == c.name ? null : _name.text,
          phone: diff(_phone, c.phoneE164, CustomerContactField.phone, norm: (v) => Phones.toE164(v) ?? v),
          email: diff(_email, c.email, CustomerContactField.email, norm: (v) => v.toLowerCase()),
          jobTitle: diff(_job, c.jobTitle, CustomerContactField.jobTitle),
          customerSiteId: _siteId == c.customerSiteId ? null : _siteId,
          contactRole: _role == c.contactRole ? null : _role,
          canOpenRequests: _canOpen == c.canOpenRequests ? null : _canOpen,
          preferredChannel: _channel == c.preferredChannel ? null : _channel,
          clear: clear.isEmpty ? null : clear,
        );
        if (patch.toJson().values.every((v) => v == null)) {
          if (mounted) Navigator.pop(context, false);
          return;
        }
        await api.update(c.id, patch, c.version);
      }
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      if (e.code == 'VERSION_MISMATCH') {
        if (await askReloadAfterConflict(context, what: 'Este contato') && mounted) Navigator.pop(context, true);
        return;
      }
      setState(() => _serverErrors = fieldErrorsOf(e));
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
    final contact = widget.contact;
    final master = _readOnly || _fromErp;
    return AlertDialog(
      title: Text(_isNew ? 'Novo contato' : contact!.name),
      content: SizedBox(
        width: 640,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: 400,
                  child: TextFormField(
                    controller: _name,
                    readOnly: master,
                    decoration: const InputDecoration(labelText: 'Nome *'),
                    validator: (v) => (v?.trim().isEmpty ?? true) ? 'Informe o nome.' : _serverErrors['name'],
                  ),
                ),
                SizedBox(
                  width: 228,
                  child: TextFormField(
                    controller: _job,
                    readOnly: master,
                    decoration: const InputDecoration(labelText: 'Cargo'),
                    validator: (_) => _serverErrors['jobTitle'],
                  ),
                ),
                SizedBox(
                  width: 260,
                  child: TextFormField(
                    controller: _phone,
                    readOnly: master,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Celular (WhatsApp)',
                      hintText: '(51) 99999-0001',
                      prefixIcon: Icon(Icons.smartphone),
                    ),
                    validator: (v) {
                      final t = v?.trim() ?? '';
                      if (t.isNotEmpty && Phones.toE164(t) == null) return 'Celular inválido.';
                      if (t.isEmpty && _email.text.trim().isEmpty) return 'Informe o celular ou o e-mail.';
                      return _serverErrors['phone'];
                    },
                  ),
                ),
                SizedBox(
                  width: 368,
                  child: TextFormField(
                    controller: _email,
                    readOnly: master,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.mail_outline)),
                    validator: (v) {
                      final t = v?.trim() ?? '';
                      if (t.isNotEmpty && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(t)) return 'E-mail inválido.';
                      return _serverErrors['email'];
                    },
                  ),
                ),
                SizedBox(
                  width: 314,
                  child: DropdownButtonFormField<UuidValue?>(
                    initialValue: _siteId,
                    decoration: const InputDecoration(labelText: 'Unidade'),
                    items: [
                      const DropdownMenuItem<UuidValue?>(child: Text('Todas as unidades')),
                      for (final s in widget.sites) DropdownMenuItem<UuidValue?>(value: s.id, child: Text(s.name)),
                    ],
                    onChanged: _readOnly ? null : (v) => setState(() => _siteId = v),
                    validator: (_) => _serverErrors['customerSiteId'],
                  ),
                ),
                SizedBox(
                  width: 314,
                  child: DropdownButtonFormField<NotificationChannel?>(
                    initialValue: _channel,
                    decoration: const InputDecoration(labelText: 'Canal preferido de aviso'),
                    items: const [
                      DropdownMenuItem<NotificationChannel?>(child: Text('Padrão da empresa')),
                      DropdownMenuItem(value: NotificationChannel.whatsapp, child: Text('WhatsApp')),
                      DropdownMenuItem(value: NotificationChannel.sms, child: Text('SMS')),
                      DropdownMenuItem(value: NotificationChannel.email, child: Text('E-mail')),
                    ],
                    onChanged: _readOnly ? null : (v) => setState(() => _channel = v),
                    validator: (_) => _serverErrors['preferredChannel'],
                  ),
                ),
                SizedBox(
                  width: 640,
                  child: SegmentedButton<ContactRole>(
                    segments: const [
                      ButtonSegment(value: ContactRole.customer_contact, label: Text('Contato')),
                      ButtonSegment(value: ContactRole.customer_admin, label: Text('Administrador do cliente')),
                    ],
                    selected: {_role},
                    onSelectionChanged: _readOnly ? null : (s) => setState(() => _role = s.first),
                  ),
                ),
                SizedBox(
                  width: 640,
                  child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    value: _canOpen,
                    onChanged: _readOnly ? null : (v) => setState(() => _canOpen = v),
                    title: const Text('Pode abrir chamados'),
                    subtitle: const Text('Administrador do cliente também gerencia os outros contatos pelo app.'),
                  ),
                ),
                if (contact != null)
                  SizedBox(
                    width: 640,
                    child: Text(
                      contact.whatsappOptInAt == null
                          ? 'WhatsApp: sem consentimento registrado (o contato aceita no primeiro acesso).'
                          : 'WhatsApp: consentimento registrado.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(widget.canManage ? 'Cancelar' : 'Fechar'),
        ),
        if (widget.canManage)
          FilledButton(onPressed: _saving ? null : _save, child: Text(_isNew ? 'Cadastrar' : 'Salvar')),
      ],
    );
  }
}
