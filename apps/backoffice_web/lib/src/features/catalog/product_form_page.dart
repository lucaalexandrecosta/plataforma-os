import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_core/plataforma_os_core.dart';

import '../../api/api_client.dart';
import '../../auth/auth_controller.dart';
import '../../ui/dialogs.dart';
import '../../ui/errors.dart';
import '../../ui/form_layout.dart';
import 'catalog_format.dart';

/// Criação (`id == null`) e edição de produto. GTIN e preço validados com as
/// mesmas regras do servidor (`packages/core`).
class ProductFormPage extends ConsumerStatefulWidget {
  const ProductFormPage({this.id, super.key});
  final UuidValue? id;

  @override
  ConsumerState<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends ConsumerState<ProductFormPage> {
  final _form = GlobalKey<FormState>();
  final _code = TextEditingController();
  final _name = TextEditingController();
  final _description = TextEditingController();
  final _unit = TextEditingController(text: 'UN');
  final _gtin = TextEditingController();
  final _warranty = TextEditingController();
  final _price = TextEditingController();
  final _label = TextEditingController();

  ProductKind _kind = ProductKind.equipment;
  UuidValue? _familyId;
  bool _tracksAssets = true;
  bool _serialized = true;
  FamilyIndex _families = FamilyIndex.empty;

  Product? _current;
  bool _loading = false;
  bool _saving = false;
  Object? _loadError;
  Map<String, String> _serverErrors = const {};

  bool get _isNew => widget.id == null;
  bool get _fromErp => _current?.source == RecordSource.erp;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    for (final c in [_code, _name, _description, _unit, _gtin, _warranty, _price, _label]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _loadError = null;
    });
    final api = ref.read(apiClientProvider);
    try {
      final families = await FamilyIndex.load(api);
      final p = _isNew ? null : await api.products.get(widget.id!);
      if (!mounted) return;
      setState(() {
        _families = families;
        if (p != null) _fill(p);
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

  void _fill(Product p) {
    _current = p;
    _code.text = p.code;
    _name.text = p.name;
    _description.text = p.description ?? '';
    _unit.text = p.unitCode;
    _gtin.text = p.gtin ?? '';
    _warranty.text = p.defaultWarrantyMonths?.toString() ?? '';
    _price.text = CatalogFormat.priceInput(p.referencePrice);
    _label.text = p.labelPositionInstructions ?? '';
    _kind = p.productKind;
    _familyId = p.productFamilyId;
    _tracksAssets = p.tracksAssets;
    _serialized = p.isSerialized;
    _serverErrors = const {};
  }

  String? _text(TextEditingController c) {
    final t = c.text.trim();
    return t.isEmpty ? null : t;
  }

  int? get _priceCents => CatalogFormat.parsePrice(_price.text);
  int? get _warrantyMonths => _text(_warranty) == null ? null : int.parse(_warranty.text.trim());

  // --- salvar ----------------------------------------------------------------

  Future<void> _save() async {
    setState(() => _serverErrors = const {});
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final api = ref.read(apiClientProvider).products;
    try {
      if (_isNew) {
        final created = await api.create(
          ProductInput(
            id: const Uuid().v7obj(),
            code: _code.text,
            name: _name.text,
            description: _text(_description),
            productFamilyId: _familyId,
            productKind: _kind,
            unitCode: _text(_unit),
            gtin: _text(_gtin),
            tracksAssets: _tracksAssets,
            isSerialized: _serialized,
            defaultWarrantyMonths: _warrantyMonths,
            referencePrice: _priceCents,
            labelPositionInstructions: _text(_label),
          ),
        );
        if (!mounted) return;
        showInfoSnack(context, 'Produto "${created.name}" cadastrado.');
        if (context.canPop()) {
          context.pop(true);
        } else {
          context.go('/catalogo/produtos/${created.id.uuid}');
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
        if (await askReloadAfterConflict(context, what: 'Este produto')) await _load();
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

  ProductPatch? _patch() {
    final p = _current!;
    final clear = <ProductField>[];
    T? diff<T>(T? value, T? current, ProductField? field) {
      if (value == current) return null;
      if (value == null) {
        if (field != null) clear.add(field);
        return null;
      }
      return value;
    }

    final gtin = _text(_gtin);
    final patch = ProductPatch(
      code: diff(_text(_code), p.code, null),
      name: diff(_text(_name), p.name, null),
      description: diff(_text(_description), p.description, ProductField.description),
      productFamilyId: diff(_familyId, p.productFamilyId, ProductField.productFamilyId),
      productKind: _kind == p.productKind ? null : _kind,
      unitCode: diff(_text(_unit)?.toUpperCase(), p.unitCode, null),
      gtin: diff(gtin == null ? null : Gtin.normalize(gtin), p.gtin, ProductField.gtin),
      tracksAssets: _tracksAssets == p.tracksAssets ? null : _tracksAssets,
      isSerialized: _serialized == p.isSerialized ? null : _serialized,
      defaultWarrantyMonths: diff(_warrantyMonths, p.defaultWarrantyMonths, ProductField.defaultWarrantyMonths),
      referencePrice: diff(_priceCents, p.referencePrice, ProductField.referencePrice),
      labelPositionInstructions: diff(
        _text(_label),
        p.labelPositionInstructions,
        ProductField.labelPositionInstructions,
      ),
      clear: clear.isEmpty ? null : clear,
    );
    return patch.toJson().entries.every((e) => e.value == null) ? null : patch;
  }

  Future<void> _toggleActive() async {
    final p = _current!;
    final api = ref.read(apiClientProvider).products;
    try {
      Product updated;
      if (p.isActive) {
        final reason = await askReason(
          context,
          title: 'Inativar produto',
          message: 'O produto deixa de ser oferecido em novas OS e cadastros de ativo. Nada é apagado.',
          confirmLabel: 'Inativar',
        );
        if (reason == null) return;
        updated = await api.deactivate(p.id, reason, p.version);
      } else {
        updated = await api.reactivate(p.id, p.version);
      }
      if (!mounted) return;
      setState(() => _fill(updated));
      showInfoSnack(context, updated.isActive ? 'Produto reativado.' : 'Produto inativado.');
    } on ApiException catch (e) {
      if (!mounted) return;
      if (e.code == 'VERSION_MISMATCH') {
        if (await askReloadAfterConflict(context, what: 'Este produto')) await _load();
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
            const Text('Produto não encontrado.'),
            const SizedBox(height: 12),
            TextButton(onPressed: () => context.go('/catalogo/produtos'), child: const Text('Voltar para a lista')),
          ],
        ),
      );
    }

    final current = _current;
    final families = [
      for (final n in _families.tree)
        if (n.family.isActive || n.family.id == _familyId) n,
    ];

    return Form(
      key: _form,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          RecordHeader(
            title: _isNew ? 'Novo produto' : current!.name,
            isNew: _isNew,
            canManage: canManage,
            saving: _saving,
            backPath: '/catalogo/produtos',
            onSave: _save,
            isActive: current?.isActive,
            fromErp: _fromErp,
            version: current?.version,
            updatedAt: current?.updatedAt,
            onToggleActive: _fromErp ? null : _toggleActive,
            readOnlyMessage: 'Você pode consultar, mas não alterar o catálogo.',
            erpMessage:
                'Este produto vem do ERP: código, nome, descrição, unidade, GTIN e preço só mudam por lá. '
                'Família, tipo, ativos, garantia e etiqueta são editáveis.',
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
                  decoration: const InputDecoration(labelText: 'Nome *', hintText: 'Freezer horizontal 500 L'),
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
                width: 220,
                child: DropdownButtonFormField<ProductKind>(
                  initialValue: _kind,
                  decoration: const InputDecoration(labelText: 'Tipo'),
                  items: [
                    for (final k in ProductKind.values)
                      DropdownMenuItem(value: k, child: Text(CatalogFormat.productKind(k))),
                  ],
                  onChanged: readOnly
                      ? null
                      : (k) => setState(() {
                          _kind = k!;
                          // Sugestão ao criar: equipamento vira ativo; os outros não.
                          if (_isNew) _tracksAssets = _serialized = k == ProductKind.equipment;
                          if (k == ProductKind.consumable) _tracksAssets = _serialized = false;
                        }),
                ),
              ),
              FieldBox(
                width: 340,
                child: DropdownButtonFormField<UuidValue?>(
                  initialValue: _familyId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Família',
                    helperText: families.isEmpty ? 'Cadastre famílias na aba Famílias' : null,
                  ),
                  items: [
                    const DropdownMenuItem(child: Text('Sem família')),
                    for (final n in families)
                      DropdownMenuItem(
                        value: n.family.id,
                        child: Text('${'   ' * n.depth}${n.family.name}', overflow: TextOverflow.ellipsis),
                      ),
                  ],
                  onChanged: readOnly ? null : (f) => setState(() => _familyId = f),
                  validator: (_) => _serverErrors['productFamilyId'],
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
            title: 'Venda e estoque',
            children: [
              FieldBox(
                width: 140,
                child: TextFormField(
                  controller: _unit,
                  readOnly: master,
                  maxLength: 6,
                  textCapitalization: TextCapitalization.characters,
                  decoration: const InputDecoration(labelText: 'Unidade *', helperText: 'UN, PC, KG, M'),
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return 'Informe a unidade.';
                    if (!RegExp(r'^[A-Za-z0-9]{1,6}$').hasMatch(t)) return 'Só letras e números.';
                    return _serverErrors['unitCode'];
                  },
                ),
              ),
              FieldBox(
                width: 240,
                child: TextFormField(
                  controller: _gtin,
                  readOnly: master,
                  decoration: const InputDecoration(labelText: 'GTIN / EAN', prefixIcon: Icon(Icons.qr_code)),
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isNotEmpty && !Gtin.isValid(t)) return 'Código de barras inválido.';
                    return _serverErrors['gtin'];
                  },
                ),
              ),
              FieldBox(
                width: 220,
                child: TextFormField(
                  controller: _price,
                  readOnly: master,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(labelText: 'Preço de referência', prefixText: r'R$ '),
                  validator: (v) {
                    try {
                      final c = CatalogFormat.parsePrice(v ?? '');
                      if (c != null && c < 0) return 'Preço não pode ser negativo.';
                    } on FormatException {
                      return 'Valor inválido. Ex.: 4590,00';
                    }
                    return _serverErrors['referencePrice'];
                  },
                ),
              ),
              FieldBox(
                width: 180,
                child: TextFormField(
                  controller: _warranty,
                  readOnly: readOnly,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Garantia padrão', suffixText: 'meses'),
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    if (t.isEmpty) return _serverErrors['defaultWarrantyMonths'];
                    final m = int.tryParse(t);
                    if (m == null || m < 0 || m > 240) return 'De 0 a 240.';
                    return _serverErrors['defaultWarrantyMonths'];
                  },
                ),
              ),
            ],
          ),
          FormSection(
            title: 'Ativos e etiqueta QR',
            children: [
              FieldBox(
                width: 700,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _tracksAssets,
                  onChanged: readOnly || _kind == ProductKind.consumable
                      ? null
                      : (v) => setState(() {
                          _tracksAssets = v;
                          if (!v) _serialized = false;
                        }),
                  title: const Text('Cada unidade vira um ativo'),
                  subtitle: Text(
                    _serverErrors['tracksAssets'] ??
                        'O equipamento no cliente ganha ficha própria, histórico e etiqueta QR.',
                  ),
                ),
              ),
              FieldBox(
                width: 700,
                child: SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _serialized,
                  onChanged: readOnly || !_tracksAssets ? null : (v) => setState(() => _serialized = v),
                  title: const Text('Tem número de série'),
                  subtitle: Text(_serverErrors['isSerialized'] ?? 'O técnico informa a série ao cadastrar o ativo.'),
                ),
              ),
              if (_tracksAssets)
                FieldBox(
                  width: 700,
                  child: TextFormField(
                    controller: _label,
                    readOnly: readOnly,
                    maxLength: 1000,
                    decoration: const InputDecoration(
                      labelText: 'Onde colar a etiqueta QR',
                      hintText: 'Ex.: lateral direita, acima da placa de identificação',
                    ),
                    validator: (_) => _serverErrors['labelPositionInstructions'],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
