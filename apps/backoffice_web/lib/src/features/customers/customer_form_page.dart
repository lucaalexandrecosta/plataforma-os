import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_core/plataforma_os_core.dart';

import '../../api/api_client.dart';
import '../../auth/auth_controller.dart';
import '../../ui/dialogs.dart';
import '../../ui/errors.dart';
import 'contacts_tab.dart';
import 'customer_format.dart';
import 'sites_tab.dart';

/// Criação (`id == null`) e edição de cliente. Regras de documento e telefone
/// iguais às do servidor (`packages/core`), para avisar antes de salvar; o
/// servidor revalida e os erros por campo voltam para o campo certo.
class CustomerFormPage extends ConsumerStatefulWidget {
  const CustomerFormPage({this.id, super.key});

  final UuidValue? id;

  @override
  ConsumerState<CustomerFormPage> createState() => _CustomerFormPageState();
}

class _CustomerFormPageState extends ConsumerState<CustomerFormPage> with SingleTickerProviderStateMixin {
  late final TabController _tabs = TabController(length: 3, vsync: this)..addListener(_onTab);
  int _contactsGeneration = 0; // recria a aba Contatos quando as unidades mudam

  void _onTab() {
    if (!_tabs.indexIsChanging) setState(() {});
  }

  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _tradeName = TextEditingController();
  final _code = TextEditingController();
  final _document = TextEditingController();
  final _stateRegistration = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _notes = TextEditingController();

  PersonType _personType = PersonType.company;
  DocumentType _documentType = DocumentType.cnpj;
  bool _skipTriage = false;

  Customer? _current;
  bool _loading = false;
  bool _saving = false;
  Object? _loadError;
  Map<String, String> _serverErrors = const {};

  bool get _isNew => widget.id == null;
  bool get _fromErp => _current?.source == RecordSource.erp;

  @override
  void initState() {
    super.initState();
    if (!_isNew) _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    for (final c in [_name, _tradeName, _code, _document, _stateRegistration, _email, _phone, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    try {
      final c = await ref.read(apiClientProvider).customers.get(widget.id!);
      if (!mounted) return;
      _fill(c);
      setState(() => _loading = false);
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e;
        _loading = false;
      });
    }
  }

  void _fill(Customer c) {
    _current = c;
    _name.text = c.name;
    _tradeName.text = c.tradeName ?? '';
    _code.text = c.code ?? '';
    _document.text = c.documentNumber == null ? '' : CustomerFormat.document(c);
    _stateRegistration.text = c.stateRegistration ?? '';
    _email.text = c.email ?? '';
    _phone.text = c.phone == null ? '' : CustomerFormat.phone(c.phone);
    _notes.text = c.notes ?? '';
    _personType = c.personType;
    _documentType = c.documentType;
    _skipTriage = c.skipTriage;
    _serverErrors = const {};
  }

  List<DocumentType> get _allowedDocuments => _personType == PersonType.company
      ? const [DocumentType.cnpj, DocumentType.foreign, DocumentType.none]
      : const [DocumentType.cpf, DocumentType.foreign, DocumentType.none];

  String? _text(TextEditingController c) {
    final t = c.text.trim();
    return t.isEmpty ? null : t;
  }

  // --- validação local (mesmas regras do servidor) --------------------------

  String? _validateDocument(String? v) {
    final value = v?.trim() ?? '';
    return switch (_documentType) {
      DocumentType.cnpj when value.isEmpty => 'Informe o CNPJ.',
      DocumentType.cnpj when !BrDocuments.isValidCnpj(value) => 'CNPJ inválido.',
      DocumentType.cpf when value.isEmpty => 'Informe o CPF.',
      DocumentType.cpf when !BrDocuments.isValidCpf(value) => 'CPF inválido.',
      DocumentType.foreign when value.isEmpty => 'Informe o documento.',
      _ => _serverErrors['documentNumber'],
    };
  }

  String? _validatePhone(String? v) {
    final value = v?.trim() ?? '';
    if (value.isNotEmpty && Phones.toE164(value) == null) return 'Telefone inválido. Use DDD + número.';
    return _serverErrors['phone'];
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isNotEmpty && !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(value)) return 'E-mail inválido.';
    return _serverErrors['email'];
  }

  // --- salvar ----------------------------------------------------------------

  Future<void> _save() async {
    setState(() => _serverErrors = const {});
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final api = ref.read(apiClientProvider).customers;
    try {
      if (_isNew) {
        final created = await api.create(
          CustomerInput(
            id: const Uuid().v7obj(),
            name: _name.text,
            tradeName: _text(_tradeName),
            code: _text(_code),
            personType: _personType,
            documentType: _documentType,
            documentNumber: _documentType == DocumentType.none ? null : _text(_document),
            stateRegistration: _text(_stateRegistration),
            email: _text(_email),
            phone: _text(_phone),
            notes: _text(_notes),
            skipTriage: _skipTriage,
          ),
        );
        if (!mounted) return;
        showInfoSnack(context, 'Cliente "${created.name}" cadastrado.');
        // Aberto pela lista: volta e recarrega. Aberto direto pela URL: vai para a ficha.
        if (context.canPop()) {
          context.pop(true);
        } else {
          context.go('/clientes/${created.id.uuid}');
        }
        return;
      }

      final patch = _patch();
      if (patch == null) {
        showInfoSnack(context, 'Nada mudou.');
        setState(() => _saving = false);
        return;
      }
      final updated = await api.update(_current!.id, patch, _current!.version);
      if (!mounted) return;
      setState(() {
        _fill(updated);
        _saving = false;
      });
      showInfoSnack(context, 'Alterações salvas.');
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      if (e.code == 'VERSION_MISMATCH') {
        await _versionConflict();
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

  /// Só o que mudou; campo opcional esvaziado vai em `clear`.
  CustomerPatch? _patch() {
    final c = _current!;
    final clear = <CustomerField>[];
    String? changed(
      TextEditingController ctl,
      String? current,
      CustomerField? field, {
      String Function(String)? normalize,
    }) {
      final value = _text(ctl);
      final comparable = value == null ? null : (normalize?.call(value) ?? value);
      if (comparable == current) return null;
      if (value == null) {
        if (field != null) clear.add(field);
        return null;
      }
      return value;
    }

    String? document;
    if (_documentType == DocumentType.none) {
      if (c.documentNumber != null) clear.add(CustomerField.documentNumber);
    } else {
      final normalize = _documentType == DocumentType.foreign ? null : BrDocuments.normalize;
      document = changed(_document, c.documentNumber, CustomerField.documentNumber, normalize: normalize);
    }
    final patch = CustomerPatch(
      name: changed(_name, c.name, null),
      tradeName: changed(_tradeName, c.tradeName, CustomerField.tradeName),
      code: changed(_code, c.code, CustomerField.code),
      personType: _personType == c.personType ? null : _personType,
      documentType: _documentType == c.documentType ? null : _documentType,
      documentNumber: document,
      stateRegistration: changed(
        _stateRegistration,
        c.stateRegistration,
        CustomerField.stateRegistration,
        normalize: (v) => v.toUpperCase(),
      ),
      email: changed(_email, c.email, CustomerField.email, normalize: (v) => v.toLowerCase()),
      phone: changed(_phone, c.phone, CustomerField.phone, normalize: (v) => Phones.toE164(v) ?? v),
      notes: changed(_notes, c.notes, CustomerField.notes),
      skipTriage: _skipTriage == c.skipTriage ? null : _skipTriage,
      clear: clear.isEmpty ? null : clear,
    );
    final empty = patch.toJson().entries.every((e) => e.value == null);
    return empty ? null : patch;
  }

  Future<void> _versionConflict() async {
    if (await askReloadAfterConflict(context, what: 'Este cliente')) await _load();
  }

  Future<void> _toggleActive() async {
    final c = _current!;
    final api = ref.read(apiClientProvider).customers;
    try {
      Customer updated;
      if (c.isActive) {
        final reason = await askReason(
          context,
          title: 'Inativar cliente',
          message: 'O cliente deixa de aparecer nas listas de ativos. Nada é apagado e dá para reativar.',
          confirmLabel: 'Inativar',
        );
        if (reason == null) return;
        updated = await api.deactivate(c.id, reason, c.version);
      } else {
        updated = await api.reactivate(c.id, c.version);
      }
      if (!mounted) return;
      setState(() => _fill(updated));
      showInfoSnack(context, updated.isActive ? 'Cliente reativado.' : 'Cliente inativado.');
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.code == 'VERSION_MISMATCH') {
        await _versionConflict();
      } else {
        showErrorSnack(context, e);
      }
    } on Object catch (e) {
      if (mounted) showErrorSnack(context, e);
    }
  }

  // --- tela ------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final canManage = auth is AuthSignedIn && auth.can('customers.manage');
    final readOnly = !canManage || _saving;
    final theme = Theme.of(context);

    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError != null) {
      final notFound = _loadError is ApiException && (_loadError! as ApiException).code == 'NOT_FOUND';
      return notFound
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Cliente não encontrado.'),
                  const SizedBox(height: 12),
                  TextButton(onPressed: () => context.go('/clientes'), child: const Text('Voltar para a lista')),
                ],
              ),
            )
          : ErrorPanel(error: _loadError!, onRetry: _load);
    }

    final current = _current;
    final masterReadOnly = readOnly || _fromErp;

    final header = <Widget>[
      Row(
        children: [
          IconButton(
            tooltip: 'Voltar',
            icon: const Icon(Icons.arrow_back),
            onPressed: () => context.canPop() ? context.pop() : context.go('/clientes'),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(_isNew ? 'Novo cliente' : current!.name, style: theme.textTheme.headlineSmall),
          ),
          if (current != null && canManage)
            OutlinedButton.icon(
              onPressed: _saving || _fromErp ? null : _toggleActive,
              icon: Icon(current.isActive ? Icons.block : Icons.restart_alt),
              label: Text(current.isActive ? 'Inativar' : 'Reativar'),
            ),
          const SizedBox(width: 12),
          if (canManage && (_isNew || _tabs.index == 0))
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: _saving
                  ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Icon(Icons.save_outlined),
              label: Text(_isNew ? 'Cadastrar' : 'Salvar'),
            ),
        ],
      ),
      if (current != null) ...[
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 56),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(label: Text(current.isActive ? 'Ativo' : 'Inativo')),
              if (_fromErp) const Chip(avatar: Icon(Icons.sync, size: 16), label: Text('Vem do ERP')),
              Chip(label: Text('Versão ${current.version}')),
              Chip(
                label: Text(
                  'Atualizado em ${DateFormat("dd/MM/yyyy 'às' HH:mm", 'pt_BR').format(current.updatedAt.toLocal())}',
                ),
              ),
            ],
          ),
        ),
      ],
      if (!canManage) ...[
        const SizedBox(height: 12),
        const _Banner(icon: Icons.visibility_outlined, text: 'Você pode consultar, mas não alterar clientes.'),
      ],
      if (_fromErp) ...[
        const SizedBox(height: 12),
        const _Banner(
          icon: Icons.sync,
          text:
              'Este cadastro vem do ERP: nome, documento e contatos só mudam por lá. Observações e triagem são editáveis.',
        ),
      ],
    ];

    final sections = <Widget>[
      _Section(
        title: 'Identificação',
        children: [
          _Field(
            width: 260,
            child: SegmentedButton<PersonType>(
              segments: [
                for (final t in PersonType.values) ButtonSegment(value: t, label: Text(CustomerFormat.personLabel(t))),
              ],
              selected: {_personType},
              onSelectionChanged: masterReadOnly
                  ? null
                  : (s) => setState(() {
                      _personType = s.first;
                      if (!_allowedDocuments.contains(_documentType)) _documentType = _allowedDocuments.first;
                    }),
            ),
          ),
          _Field(
            width: 520,
            child: TextFormField(
              controller: _name,
              readOnly: masterReadOnly,
              decoration: InputDecoration(
                labelText: _personType == PersonType.company ? 'Razão social *' : 'Nome completo *',
              ),
              maxLength: 200,
              validator: (v) => (v?.trim().isEmpty ?? true) ? 'Informe o nome.' : _serverErrors['name'],
            ),
          ),
          _Field(
            width: 360,
            child: TextFormField(
              controller: _tradeName,
              readOnly: masterReadOnly,
              decoration: const InputDecoration(labelText: 'Nome fantasia'),
              maxLength: 200,
              validator: (_) => _serverErrors['tradeName'],
            ),
          ),
          _Field(
            width: 200,
            child: TextFormField(
              controller: _code,
              readOnly: masterReadOnly,
              decoration: const InputDecoration(labelText: 'Código', helperText: 'Único na empresa'),
              maxLength: 40,
              validator: (_) => _serverErrors['code'],
            ),
          ),
        ],
      ),
      _Section(
        title: 'Documentos',
        children: [
          _Field(
            width: 240,
            child: DropdownButtonFormField<DocumentType>(
              initialValue: _documentType,
              decoration: const InputDecoration(labelText: 'Tipo de documento'),
              items: [
                for (final t in _allowedDocuments)
                  DropdownMenuItem(value: t, child: Text(CustomerFormat.documentLabel(t))),
              ],
              onChanged: masterReadOnly ? null : (t) => setState(() => _documentType = t!),
              validator: (_) => _serverErrors['documentType'],
            ),
          ),
          if (_documentType != DocumentType.none)
            _Field(
              width: 260,
              child: TextFormField(
                controller: _document,
                readOnly: masterReadOnly,
                decoration: InputDecoration(
                  labelText: '${CustomerFormat.documentLabel(_documentType)} *',
                  helperText: _documentType == DocumentType.cnpj ? 'Aceita o CNPJ alfanumérico' : null,
                ),
                validator: _validateDocument,
              ),
            ),
          _Field(
            width: 220,
            child: TextFormField(
              controller: _stateRegistration,
              readOnly: masterReadOnly,
              decoration: const InputDecoration(labelText: 'Inscrição estadual', hintText: 'ou ISENTO'),
              validator: (_) => _serverErrors['stateRegistration'],
            ),
          ),
        ],
      ),
      _Section(
        title: 'Contato geral',
        children: [
          _Field(
            width: 320,
            child: TextFormField(
              controller: _email,
              readOnly: masterReadOnly,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'E-mail', prefixIcon: Icon(Icons.mail_outline)),
              validator: _validateEmail,
            ),
          ),
          _Field(
            width: 240,
            child: TextFormField(
              controller: _phone,
              readOnly: masterReadOnly,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Telefone',
                hintText: '(51) 99999-0001',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              validator: _validatePhone,
            ),
          ),
        ],
      ),
      _Section(
        title: 'Atendimento',
        children: [
          _Field(
            width: 700,
            child: TextFormField(
              controller: _notes,
              readOnly: readOnly,
              minLines: 2,
              maxLines: 6,
              maxLength: 4000,
              decoration: const InputDecoration(
                labelText: 'Observações',
                hintText: 'Horários, acesso, pessoas de referência…',
              ),
              validator: (_) => _serverErrors['notes'],
            ),
          ),
          _Field(
            width: 700,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: _skipTriage,
              onChanged: readOnly ? null : (v) => setState(() => _skipTriage = v),
              title: const Text('Chamados vão direto para o técnico da região'),
              subtitle: const Text('Vale quando a empresa usa a triagem "direta" (configuração da empresa).'),
            ),
          ),
        ],
      ),
    ];

    if (current == null) {
      return Form(
        key: _form,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [...header, const SizedBox(height: 20), ...sections],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: header),
        ),
        TabBar(
          controller: _tabs,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(icon: Icon(Icons.badge_outlined), text: 'Dados'),
            Tab(icon: Icon(Icons.location_on_outlined), text: 'Unidades'),
            Tab(icon: Icon(Icons.people_outline), text: 'Contatos'),
          ],
        ),
        const Divider(height: 1),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: [
              Form(
                key: _form,
                child: ListView(padding: const EdgeInsets.all(24), children: sections),
              ),
              SitesTab(
                customer: current,
                canManage: canManage,
                onChanged: () => setState(() => _contactsGeneration++),
              ),
              ContactsTab(key: ValueKey(_contactsGeneration), customer: current, canManage: canManage),
            ],
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Wrap(spacing: 16, runSpacing: 8, children: children),
          ],
        ),
      ),
    ),
  );
}

class _Field extends StatelessWidget {
  const _Field({required this.width, required this.child});
  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: BoxConstraints(maxWidth: width, minWidth: width < 300 ? width : 280),
    child: SizedBox(width: width, child: child),
  );
}

class _Banner extends StatelessWidget {
  const _Banner({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: scheme.secondaryContainer, borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(icon, color: scheme.onSecondaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: TextStyle(color: scheme.onSecondaryContainer)),
          ),
        ],
      ),
    );
  }
}
