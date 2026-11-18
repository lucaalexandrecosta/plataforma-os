import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../../api/gateway.dart';
import '../../session/session.dart';
import '../common/errors.dart';

String? _clean(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

String? _required(String? v, String message) => v == null || v.trim().isEmpty ? message : null;

/// Base dos formulários: envia, mostra erro por campo e fecha com o salvo.
mixin _SaveForm<W extends ConsumerStatefulWidget, T> on ConsumerState<W> {
  final form = GlobalKey<FormState>();
  var busy = false;
  Map<String, String> fieldErrors = const {};

  InputDecoration deco(String label, String field, {String? hint}) => InputDecoration(
    labelText: label,
    hintText: hint,
    border: const OutlineInputBorder(),
    errorText: fieldErrors[field],
  );

  Future<void> save(Future<T> Function(Gateway g) action) async {
    if (!form.currentState!.validate()) return;
    setState(() {
      busy = true;
      fieldErrors = const {};
    });
    try {
      final saved = await action(ref.read(gatewayProvider));
      if (mounted) Navigator.of(context).pop(saved);
    } on GatewayException catch (e) {
      if (!mounted) return;
      setState(() => fieldErrors = e.fieldErrors);
      reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Widget dialog({
    required String title,
    required String saveKey,
    required VoidCallback onSave,
    required List<Widget> fields,
  }) {
    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 560,
        child: SingleChildScrollView(
          child: Form(
            key: form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (final f in fields) ...[f, const SizedBox(height: 12)],
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: busy ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(key: Key(saveKey), onPressed: busy ? null : onSave, child: const Text('Salvar')),
      ],
    );
  }
}

Widget _pair(Widget a, Widget b, {int flexA = 1, int flexB = 1}) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Expanded(flex: flexA, child: a),
    const SizedBox(width: 12),
    Expanded(flex: flexB, child: b),
  ],
);

/// Novo cliente ou edição.
class CustomerDialog extends ConsumerStatefulWidget {
  const CustomerDialog({super.key, this.customer});

  final Customer? customer;

  @override
  ConsumerState<CustomerDialog> createState() => _CustomerDialogState();
}

class _CustomerDialogState extends ConsumerState<CustomerDialog> with _SaveForm<CustomerDialog, Customer> {
  late final _code = TextEditingController(text: widget.customer?.code);
  late final _name = TextEditingController(text: widget.customer?.name);
  late final _trade = TextEditingController(text: widget.customer?.tradeName);
  late final _document = TextEditingController(text: widget.customer?.documentNumber);
  late final _ie = TextEditingController(text: widget.customer?.stateRegistration);
  late final _email = TextEditingController(text: widget.customer?.email);
  late final _phone = TextEditingController(text: widget.customer?.phone);
  late final _notes = TextEditingController(text: widget.customer?.notes);
  late var _personType = widget.customer?.personType ?? 'company';
  late var _active = widget.customer?.isActive ?? true;

  bool get _individual => _personType == 'individual';

  @override
  void dispose() {
    for (final c in [_code, _name, _trade, _document, _ie, _email, _phone, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    final input = CustomerInput(
      code: _clean(_code),
      name: _name.text.trim(),
      tradeName: _clean(_trade),
      personType: _personType,
      documentNumber: _clean(_document),
      stateRegistration: _individual ? null : _clean(_ie),
      email: _clean(_email),
      phone: _clean(_phone),
      notes: _clean(_notes),
      isActive: _active,
    );
    final current = widget.customer;
    save((g) => current == null ? g.createCustomer(input) : g.updateCustomer(current, input));
  }

  @override
  Widget build(BuildContext context) {
    final digits = _individual ? 11 : 14;
    return dialog(
      title: widget.customer == null ? 'Novo cliente' : 'Editar cliente',
      saveKey: 'customer-save',
      onSave: _submit,
      fields: [
        SegmentedButton<String>(
          key: const Key('customer-person-type'),
          segments: const [
            ButtonSegment(value: 'company', label: Text('Empresa')),
            ButtonSegment(value: 'individual', label: Text('Pessoa física')),
          ],
          selected: {_personType},
          onSelectionChanged: (v) => setState(() => _personType = v.single),
        ),
        TextFormField(
          key: const Key('customer-name'),
          controller: _name,
          decoration: deco(_individual ? 'Nome' : 'Razão social', 'name'),
          validator: (v) => _required(v, 'Informe o nome.'),
        ),
        _pair(
          TextFormField(
            key: const Key('customer-trade'),
            controller: _trade,
            decoration: deco(_individual ? 'Apelido' : 'Nome fantasia', 'tradeName'),
          ),
          TextFormField(
            key: const Key('customer-code'),
            controller: _code,
            decoration: deco('Código', 'code', hint: 'C001'),
          ),
          flexA: 2,
        ),
        _pair(
          TextFormField(
            key: const Key('customer-document'),
            controller: _document,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(digits)],
            decoration: deco(_individual ? 'CPF (só números)' : 'CNPJ (só números)', 'documentNumber'),
            validator: (v) => v == null || v.isEmpty || v.length == digits
                ? null
                : (_individual ? 'O CPF tem 11 dígitos.' : 'O CNPJ tem 14 dígitos.'),
          ),
          _individual
              ? const SizedBox.shrink()
              : TextFormField(controller: _ie, decoration: deco('Inscrição estadual', 'stateRegistration')),
        ),
        _pair(
          TextFormField(
            key: const Key('customer-email'),
            controller: _email,
            keyboardType: TextInputType.emailAddress,
            decoration: deco('E-mail', 'email'),
          ),
          TextFormField(
            controller: _phone,
            decoration: deco('Telefone', 'phone', hint: '(51) 3333-0000'),
          ),
        ),
        TextFormField(controller: _notes, maxLines: 3, decoration: deco('Observações', 'notes')),
        SwitchListTile(
          key: const Key('customer-active'),
          contentPadding: EdgeInsets.zero,
          title: const Text('Ativo'),
          value: _active,
          onChanged: (v) => setState(() => _active = v),
        ),
      ],
    );
  }
}

/// Nova unidade (local de atendimento) ou edição.
class CustomerSiteDialog extends ConsumerStatefulWidget {
  const CustomerSiteDialog({super.key, required this.customerId, this.site});

  @visibleForTesting
  static (double, double)? parseCoordsForTest(String text) => _CustomerSiteDialogState.parseCoords(text);

  final UuidValue customerId;
  final CustomerSite? site;

  @override
  ConsumerState<CustomerSiteDialog> createState() => _CustomerSiteDialogState();
}

class _CustomerSiteDialogState extends ConsumerState<CustomerSiteDialog>
    with _SaveForm<CustomerSiteDialog, CustomerSite> {
  late final _code = TextEditingController(text: widget.site?.code);
  late final _name = TextEditingController(text: widget.site?.name);
  late final _postal = TextEditingController(text: widget.site?.postalCode);
  late final _street = TextEditingController(text: widget.site?.street);
  late final _number = TextEditingController(text: widget.site?.streetNumber);
  late final _complement = TextEditingController(text: widget.site?.complement);
  late final _district = TextEditingController(text: widget.site?.district);
  late final _city = TextEditingController(text: widget.site?.city);
  late final _state = TextEditingController(text: widget.site?.state);
  late final _phone = TextEditingController(text: widget.site?.phone);
  late final _access = TextEditingController(text: widget.site?.accessNotes);
  late final _coords = TextEditingController(
    text: widget.site?.latitude == null ? null : '${widget.site!.latitude}, ${widget.site!.longitude}',
  );
  late var _active = widget.site?.isActive ?? true;

  @override
  void dispose() {
    for (final c in [_code, _name, _postal, _street, _number, _complement, _district, _city, _state, _phone, _access]) {
      c.dispose();
    }
    _coords.dispose();
    super.dispose();
  }

  /// "-30.03, -51.23" (como o mapa copia) → (lat, lng).
  static (double, double)? parseCoords(String text) {
    final parts = text.split(RegExp(r'[,;\s]+')).where((p) => p.isNotEmpty).toList();
    if (parts.length != 2) return null;
    final lat = double.tryParse(parts[0]);
    final lng = double.tryParse(parts[1]);
    if (lat == null || lng == null || lat.abs() > 90 || lng.abs() > 180) return null;
    return (lat, lng);
  }

  void _submit() {
    final coords = _coords.text.trim().isEmpty ? null : parseCoords(_coords.text);
    final input = CustomerSiteInput(
      code: _clean(_code),
      name: _name.text.trim(),
      street: _clean(_street),
      streetNumber: _clean(_number),
      complement: _clean(_complement),
      district: _clean(_district),
      city: _clean(_city),
      state: _clean(_state)?.toUpperCase(),
      postalCode: _clean(_postal),
      latitude: coords?.$1,
      longitude: coords?.$2,
      phone: _clean(_phone),
      accessNotes: _clean(_access),
      isActive: _active,
    );
    final current = widget.site;
    save(
      (g) => current == null ? g.createCustomerSite(widget.customerId, input) : g.updateCustomerSite(current, input),
    );
  }

  @override
  Widget build(BuildContext context) {
    return dialog(
      title: widget.site == null ? 'Nova unidade' : 'Editar unidade',
      saveKey: 'site-save',
      onSave: _submit,
      fields: [
        _pair(
          TextFormField(
            key: const Key('site-name'),
            controller: _name,
            decoration: deco('Nome', 'name', hint: 'Loja Centro'),
            validator: (v) => _required(v, 'Informe o nome.'),
          ),
          TextFormField(controller: _code, decoration: deco('Código', 'code')),
          flexA: 2,
        ),
        _pair(
          TextFormField(
            key: const Key('site-postal'),
            controller: _postal,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(8)],
            decoration: deco('CEP', 'postalCode'),
            validator: (v) => v == null || v.isEmpty || v.length == 8 ? null : 'O CEP tem 8 dígitos.',
          ),
          TextFormField(key: const Key('site-street'), controller: _street, decoration: deco('Rua', 'street')),
          flexB: 2,
        ),
        _pair(
          TextFormField(controller: _number, decoration: deco('Número', 'streetNumber')),
          TextFormField(controller: _complement, decoration: deco('Complemento', 'complement')),
        ),
        _pair(
          TextFormField(controller: _district, decoration: deco('Bairro', 'district')),
          _pair(
            TextFormField(key: const Key('site-city'), controller: _city, decoration: deco('Cidade', 'city')),
            TextFormField(
              key: const Key('site-state'),
              controller: _state,
              inputFormatters: [LengthLimitingTextInputFormatter(2)],
              decoration: deco('UF', 'state'),
            ),
            flexA: 3,
          ),
        ),
        _pair(
          TextFormField(
            key: const Key('site-coords'),
            controller: _coords,
            decoration: deco('Coordenadas', 'latitude', hint: '-30.0346, -51.2177'),
            validator: (v) => v == null || v.trim().isEmpty || parseCoords(v) != null
                ? null
                : 'Use "latitude, longitude" (ex.: -30.0346, -51.2177).',
          ),
          TextFormField(controller: _phone, decoration: deco('Telefone', 'phone')),
        ),
        TextFormField(
          controller: _access,
          maxLines: 2,
          decoration: deco('Como chegar / acesso', 'accessNotes', hint: 'Entrada pelos fundos, falar com o gerente'),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Ativa'),
          value: _active,
          onChanged: (v) => setState(() => _active = v),
        ),
      ],
    );
  }
}
