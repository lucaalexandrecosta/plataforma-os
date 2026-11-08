import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/api_client.dart';
import '../../auth/auth_controller.dart';
import '../../ui/dialogs.dart';
import '../../ui/errors.dart';
import '../../ui/form_layout.dart';
import 'catalog_format.dart';

/// Criação (`id == null`) e edição de serviço do catálogo.
class ServiceFormPage extends ConsumerStatefulWidget {
  const ServiceFormPage({this.id, super.key});
  final UuidValue? id;

  @override
  ConsumerState<ServiceFormPage> createState() => _ServiceFormPageState();
}

class _ServiceFormPageState extends ConsumerState<ServiceFormPage> {
  final _form = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _unit = TextEditingController(text: 'H');
  final _price = TextEditingController();
  final _minutes = TextEditingController();
  ServiceKind _kind = ServiceKind.labour;

  CatalogService? _current;
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
    for (final c in [_code, _name, _description, _unit, _price, _minutes]) {
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
      final s = await ref.read(apiClientProvider).services.get(widget.id!);
      if (!mounted) return;
      setState(() {
        _fill(s);
        _loading = false;
      });
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _loadError = e;
        _loading = false;
      });
    }
  }

  void _fill(CatalogService s) {
    _current = s;
    _code.text = s.code;
    _name.text = s.name;
    _description.text = s.description ?? '';
    _unit.text = s.unitCode;
    _price.text = CatalogFormat.priceInput(s.defaultPrice);
    _minutes.text = s.estimatedMinutes?.toString() ?? '';
    _kind = s.serviceKind;
    _serverErrors = const {};
  }

  String? _text(TextEditingController c) {
    final t = c.text.trim();
    return t.isEmpty ? null : t;
  }

  int? get _priceCents => CatalogFormat.parsePrice(_price.text);
  int? get _estimated => _text(_minutes) == null ? null : int.parse(_minutes.text.trim());

  Future<void> _save() async {
    setState(() => _serverErrors = const {});
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final api = ref.read(apiClientProvider).services;
    try {
      if (_isNew) {
        final created = await api.create(
          CatalogServiceInput(
            id: const Uuid().v7obj(),
            code: _code.text,
            name: _name.text,
            description: _text(_description),
            unitCode: _text(_unit),
            defaultPrice: _priceCents,
            estimatedMinutes: _estimated,
            serviceKind: _kind,
          ),
        );
        if (!mounted) return;
        showInfoSnack(context, 'Serviço "${created.name}" cadastrado.');
        if (context.canPop()) {
          context.pop(true);
        } else {
          context.go('/catalogo/servicos/${created.id.uuid}');
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
        if (await askReloadAfterConflict(context, what: 'Este serviço')) await _load();
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

  CatalogServicePatch? _patch() {
    final s = _current!;
    final clear = <CatalogServiceField>[];
    T? diff<T>(T? value, T? current, CatalogServiceField? field) {
      if (value == current) return null;
      if (value == null) {
        if (field != null) clear.add(field);
        return null;
      }
      return value;
    }

    final patch = CatalogServicePatch(
      code: diff(_text(_code), s.code, null),
      name: diff(_text(_name), s.name, null),
      description: diff(_text(_description), s.description, CatalogServiceField.description),
      unitCode: diff(_text(_unit)?.toUpperCase(), s.unitCode, null),
      defaultPrice: diff(_priceCents, s.defaultPrice, CatalogServiceField.defaultPrice),
      estimatedMinutes: diff(_estimated, s.estimatedMinutes, CatalogServiceField.estimatedMinutes),
      serviceKind: _kind == s.serviceKind ? null : _kind,
      clear: clear.isEmpty ? null : clear,
    );
    return patch.toJson().entries.every((e) => e.value == null) ? null : patch;
  }

  Future<void> _toggleActive() async {
    final s = _current!;
    final api = ref.read(apiClientProvider).services;
    try {
      CatalogService updated;
      if (s.isActive) {
        final reason = await askReason(
          context,
          title: 'Inativar serviço',
          message: 'O serviço deixa de ser oferecido em novas OS. Nada é apagado.',
          confirmLabel: 'Inativar',
        );
        if (reason == null) return;
        updated = await api.deactivate(s.id, reason, s.version);
      } else {
        updated = await api.reactivate(s.id, s.version);
      }
      if (!mounted) return;
      setState(() => _fill(updated));
      showInfoSnack(context, updated.isActive ? 'Serviço reativado.' : 'Serviço inativado.');
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.code == 'VERSION_MISMATCH') {
        if (await askReloadAfterConflict(context, what: 'Este serviço')) await _load();
      } else {
        showErrorSnack(context, e);
      }
    } on Object catch (e) {
      if (mounted) showErrorSnack(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final canManage = auth is AuthSignedIn && auth.can('catalog.manage');
    final readOnly = !canManage || _saving;
    final master = readOnly || _fromErp;

    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError != null) {
      final notFound = _loadError is ApiException && (_loadError! as ApiException).code == 'NOT_FOUND';
      if (!notFound) return ErrorPanel(error: _loadError!, onRetry: _load);
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Serviço não encontrado.'),
            const SizedBox(height: 12),
            TextButton(onPressed: () => context.go('/catalogo/servicos'), child: const Text('Voltar para a lista')),
          ],
        ),
      );
    }
    final current = _current;

    return Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          RecordHeader(
            title: _isNew ? 'Novo serviço' : current!.name,
            isNew: _isNew,
            canManage: canManage,
            saving: _saving,
            backPath: '/catalogo/servicos',
            onSave: _save,
            isActive: current?.isActive,
            fromErp: _fromErp,
            version: current?.version,
            updatedAt: current?.updatedAt,
            onToggleActive: _fromErp ? null : _toggleActive,
            readOnlyMessage: 'Você pode consultar, mas não alterar o catálogo.',
            erpMessage:
                'Este serviço vem do ERP: código, nome, descrição, unidade e preço só mudam por lá. '
                'Tipo e tempo estimado são editáveis.',
          ),
          const SizedBox(height: 20),
          FormSection(
            title: 'Identificação',
            children: [
              FieldBox(
                width: 480,
                child: TextFormField(
                  controller: _name,
                  readOnly: master,
                  maxLength: 200,
                  decoration: const InputDecoration(labelText: 'Nome *', hintText: 'Hora técnica (horário comercial)'),
                  validator: (v) => (v?.trim().isEmpty ?? true) ? 'Informe o nome.' : _serverErrors['name'],
                ),
              ),
              FieldBox(
                width: 200,
                child: TextFormField(
                  controller: _code,
                  readOnly: master,
                  maxLength: 40,
                  decoration: const InputDecoration(labelText: 'Código *', helperText: 'Único na empresa'),
                  validator: (v) => (v?.trim().isEmpty ?? true) ? 'Informe o código.' : _serverErrors['code'],
                ),
              ),
              FieldBox(
                width: 240,
                child: DropdownButtonFormField<ServiceKind>(
                  initialValue: _kind,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    helperText: 'Usado para converter apontamentos em itens',
                  ),
                  items: [
                    for (final k in ServiceKind.values)
                      DropdownMenuItem(value: k, child: Text(CatalogFormat.serviceKind(k))),
                  ],
                  onChanged: readOnly ? null : (k) => setState(() => _kind = k!),
                ),
              ),
              FieldBox(
                width: 700,
                child: TextFormField(
                  controller: _description,
                  readOnly: master,
                  minLines: 2,
                  maxLines: 5,
                  maxLength: 4000,
                  decoration: const InputDecoration(labelText: 'Descrição'),
                  validator: (_) => _serverErrors['description'],
                ),
              ),
            ],
          ),
          FormSection(
            title: 'Preço e tempo',
            children: [
              FieldBox(
                width: 140,
                child: TextFormField(
                  controller: _unit,
                  readOnly: master,
                  maxLength: 6,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(labelText: 'Unidade *', helperText: 'H, VIS, KM'),
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return 'Informe a unidade.';
                    if (!RegExp(r'^[A-Za-z0-9]{1,6}$').hasMatch(t)) return 'Só letras e números.';
                    return _serverErrors['unitCode'];
                  },
                ),
              ),
              FieldBox(
                width: 220,
                child: TextFormField(
                  controller: _price,
                  readOnly: master,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    labelText: 'Preço por unidade',
                    prefixText: r'R$ ',
                    suffixText: '/ ${_unit.text.trim().toUpperCase()}',
                  ),
                  validator: (v) {
                    try {
                      final c = CatalogFormat.parsePrice(v ?? '');
                      if (c != null && c < 0) return 'Preço não pode ser negativo.';
                    } on FormatException {
                      return 'Valor inválido. Ex.: 180,00';
                    }
                    return _serverErrors['defaultPrice'];
                  },
                ),
              ),
              FieldBox(
                width: 200,
                child: TextFormField(
                  controller: _minutes,
                  readOnly: readOnly,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Tempo estimado', suffixText: 'min'),
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return _serverErrors['estimatedMinutes'];
                    final m = int.tryParse(t);
                    if (m == null || m < 1 || m > 14400) return 'De 1 a 14.400 minutos.';
                    return _serverErrors['estimatedMinutes'];
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
