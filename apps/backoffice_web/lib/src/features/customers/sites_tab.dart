import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_core/plataforma_os_core.dart';

import '../../api/api_client.dart';
import '../../ui/dialogs.dart';
import '../../ui/errors.dart';
import 'customer_format.dart';

/// Aba Unidades da ficha do cliente (`customerSites.list(customerId)`).
class SitesTab extends ConsumerStatefulWidget {
  const SitesTab({required this.customer, required this.canManage, this.onChanged, super.key});

  final Customer customer;
  final bool canManage;

  /// Avisa a ficha (a aba Contatos usa a lista de unidades).
  final VoidCallback? onChanged;

  @override
  ConsumerState<SitesTab> createState() => _SitesTabState();
}

class _SitesTabState extends ConsumerState<SitesTab> {
  List<CustomerSite>? _sites;
  Object? _error;
  bool _showInactive = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _error = null);
    try {
      final all = <CustomerSite>[];
      String? cursor;
      do {
        final page = await ref
            .read(apiClientProvider)
            .customerSites
            .list(CustomerSiteFilter(customerId: widget.customer.id), PageRequest(limit: 200, cursor: cursor));
        all.addAll(page.items);
        cursor = page.nextCursor;
      } while (cursor != null);
      if (mounted) setState(() => _sites = all);
    } on Object catch (e) {
      if (mounted) setState(() => _error = e);
    }
  }

  Future<void> _edit([CustomerSite? site]) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (_) => _SiteDialog(customer: widget.customer, site: site, canManage: widget.canManage),
    );
    if (saved == true) {
      await _load();
      widget.onChanged?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) return ErrorPanel(error: _error!, onRetry: _load);
    final sites = _sites;
    if (sites == null) return const Center(child: CircularProgressIndicator());
    final visible = _showInactive ? sites : sites.where((s) => s.isActive).toList();
    final inactiveCount = sites.length - sites.where((s) => s.isActive).length;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                sites.isEmpty ? 'Nenhuma unidade' : '${visible.length} unidade(s)',
                style: theme.textTheme.titleMedium,
              ),
            ),
            if (inactiveCount > 0)
              FilterChip(
                label: Text('Mostrar inativas ($inactiveCount)'),
                selected: _showInactive,
                onSelected: (v) => setState(() => _showInactive = v),
              ),
            const SizedBox(width: 12),
            if (widget.canManage && widget.customer.isActive)
              FilledButton.icon(
                onPressed: _edit,
                icon: const Icon(Icons.add_location_alt_outlined),
                label: const Text('Nova unidade'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Endereços onde os equipamentos ficam e onde o técnico atende. A localização no mapa ajuda na agenda e no check-in.',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        if (visible.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Center(
              child: Text(
                widget.customer.isActive ? 'Cadastre a primeira unidade deste cliente.' : 'Cliente inativo.',
              ),
            ),
          ),
        for (final s in visible)
          Card(
            child: ListTile(
              leading: Icon(
                s.latitude != null ? Icons.location_on : Icons.location_off_outlined,
                color: s.latitude != null ? theme.colorScheme.primary : theme.colorScheme.outline,
              ),
              title: Row(
                children: [
                  Flexible(child: Text(s.name)),
                  if (s.code != null) ...[
                    const SizedBox(width: 8),
                    Text('· ${s.code}', style: theme.textTheme.bodySmall),
                  ],
                  const SizedBox(width: 8),
                  if (!s.isActive) const StatusPill(label: 'Inativa', tone: StatusTone.neutral),
                ],
              ),
              subtitle: Text(
                [
                  SiteFormat.address(s),
                  if (s.phone != null) CustomerFormat.phone(s.phone),
                  if (s.accessNotes != null) 'Acesso: ${s.accessNotes}',
                ].where((x) => x.isNotEmpty).join('\n'),
              ),
              isThreeLine: s.accessNotes != null,
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _edit(s),
            ),
          ),
      ],
    );
  }
}

abstract final class SiteFormat {
  static String address(CustomerSite s) {
    final line1 = [s.street, s.streetNumber].whereType<String>().join(', ');
    final line2 = [s.complement, s.district].whereType<String>().join(' · ');
    final cityState = [s.city, s.state].whereType<String>().join('/');
    final cep = s.postalCode == null
        ? null
        : (s.postalCode!.length == 8 && s.countryCode == 'BR'
              ? 'CEP ${s.postalCode!.substring(0, 5)}-${s.postalCode!.substring(5)}'
              : s.postalCode);
    return [line1, line2, cityState, cep].whereType<String>().where((x) => x.isNotEmpty).join(' — ');
  }
}

class _SiteDialog extends ConsumerStatefulWidget {
  const _SiteDialog({required this.customer, required this.canManage, this.site});

  final Customer customer;
  final CustomerSite? site;
  final bool canManage;

  @override
  ConsumerState<_SiteDialog> createState() => _SiteDialogState();
}

class _SiteDialogState extends ConsumerState<_SiteDialog> {
  final _form = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.site?.name);
  late final _code = TextEditingController(text: widget.site?.code);
  late final _postalCode = TextEditingController(text: _cep(widget.site?.postalCode));
  late final _street = TextEditingController(text: widget.site?.street);
  late final _number = TextEditingController(text: widget.site?.streetNumber);
  late final _complement = TextEditingController(text: widget.site?.complement);
  late final _district = TextEditingController(text: widget.site?.district);
  late final _city = TextEditingController(text: widget.site?.city);
  late final _state = TextEditingController(text: widget.site?.state);
  late final _lat = TextEditingController(text: widget.site?.latitude?.toString());
  late final _lng = TextEditingController(text: widget.site?.longitude?.toString());
  late final _phone = TextEditingController(
    text: widget.site?.phone == null ? '' : CustomerFormat.phone(widget.site!.phone),
  );
  late final _notes = TextEditingController(text: widget.site?.accessNotes);
  bool _saving = false;
  Map<String, String> _serverErrors = const {};

  bool get _isNew => widget.site == null;
  bool get _fromErp => widget.site?.source == RecordSource.erp;
  bool get _readOnly => !widget.canManage || _saving;

  static String _cep(String? v) => v != null && v.length == 8 ? '${v.substring(0, 5)}-${v.substring(5)}' : v ?? '';

  @override
  void dispose() {
    for (final c in [
      _name,
      _code,
      _postalCode,
      _street,
      _number,
      _complement,
      _district,
      _city,
      _state,
      _lat,
      _lng,
      _phone,
      _notes,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _t(TextEditingController c) {
    final v = c.text.trim();
    return v.isEmpty ? null : v;
  }

  double? _d(TextEditingController c) => double.tryParse(c.text.trim().replaceAll(',', '.'));

  Future<void> _save() async {
    setState(() => _serverErrors = const {});
    if (!(_form.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final api = ref.read(apiClientProvider).customerSites;
    try {
      if (_isNew) {
        await api.create(
          CustomerSiteInput(
            id: const Uuid().v7obj(),
            customerId: widget.customer.id,
            name: _name.text,
            code: _t(_code),
            postalCode: _t(_postalCode),
            street: _t(_street),
            streetNumber: _t(_number),
            complement: _t(_complement),
            district: _t(_district),
            city: _t(_city),
            state: _t(_state),
            latitude: _d(_lat),
            longitude: _d(_lng),
            phone: _t(_phone),
            accessNotes: _t(_notes),
          ),
        );
      } else {
        final s = widget.site!;
        final clear = <CustomerSiteField>[];
        String? diff(
          TextEditingController c,
          String? current,
          CustomerSiteField field, {
          String Function(String)? norm,
        }) {
          final v = _t(c);
          if (v == null) {
            if (current != null) clear.add(field);
            return null;
          }
          return (norm?.call(v) ?? v) == current ? null : v;
        }

        final lat = _d(_lat);
        final lng = _d(_lng);
        final locationCleared = lat == null && lng == null && s.latitude != null;
        if (locationCleared) clear.add(CustomerSiteField.location);
        final patch = CustomerSitePatch(
          name: _name.text.trim() == s.name ? null : _name.text,
          code: diff(_code, s.code, CustomerSiteField.code),
          postalCode: diff(
            _postalCode,
            s.postalCode,
            CustomerSiteField.postalCode,
            norm: (v) => v.replaceAll(RegExp(r'\D'), ''),
          ),
          street: diff(_street, s.street, CustomerSiteField.street),
          streetNumber: diff(_number, s.streetNumber, CustomerSiteField.streetNumber),
          complement: diff(_complement, s.complement, CustomerSiteField.complement),
          district: diff(_district, s.district, CustomerSiteField.district),
          city: diff(_city, s.city, CustomerSiteField.city),
          state: diff(_state, s.state, CustomerSiteField.state, norm: (v) => v.toUpperCase()),
          latitude: lat == s.latitude ? null : lat,
          longitude: lng == s.longitude ? null : lng,
          phone: diff(_phone, s.phone, CustomerSiteField.phone, norm: (v) => Phones.toE164(v) ?? v),
          accessNotes: diff(_notes, s.accessNotes, CustomerSiteField.accessNotes),
          clear: clear.isEmpty ? null : clear,
        );
        if (patch.toJson().values.every((v) => v == null)) {
          if (mounted) Navigator.pop(context, false);
          return;
        }
        await api.update(s.id, patch, s.version);
      }
      if (mounted) Navigator.pop(context, true);
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      if (e.code == 'VERSION_MISMATCH') {
        if (await askReloadAfterConflict(context, what: 'Esta unidade') && mounted) Navigator.pop(context, true);
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

  Future<void> _toggleActive() async {
    final s = widget.site!;
    final api = ref.read(apiClientProvider).customerSites;
    try {
      if (s.isActive) {
        final reason = await askReason(
          context,
          title: 'Inativar unidade',
          message: 'A unidade some das listas de ativas. Equipamentos e OS dela continuam no histórico.',
          confirmLabel: 'Inativar',
        );
        if (reason == null) return;
        await api.deactivate(s.id, reason, s.version);
      } else {
        await api.reactivate(s.id, s.version);
      }
      if (mounted) Navigator.pop(context, true);
    } on Object catch (e) {
      if (mounted) showErrorSnack(context, e);
    }
  }

  Widget _field(
    TextEditingController c,
    String label,
    String path, {
    double width = 220,
    bool master = true,
    String? hint,
    String? Function(String?)? validator,
    TextInputType? keyboard,
    List<TextInputFormatter>? formatters,
    int maxLines = 1,
  }) => SizedBox(
    width: width,
    child: TextFormField(
      controller: c,
      readOnly: _readOnly || (master && _fromErp),
      keyboardType: keyboard,
      inputFormatters: formatters,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, hintText: hint),
      validator: (v) => validator?.call(v) ?? _serverErrors[path],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final site = widget.site;
    return AlertDialog(
      title: Text(_isNew ? 'Nova unidade' : site!.name),
      content: SizedBox(
        width: 720,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                if (_fromErp)
                  const SizedBox(
                    width: 720,
                    child: Text(
                      'Endereço mantido pelo ERP. Localização, telefone e instruções de acesso são editáveis.',
                    ),
                  ),
                _field(
                  _name,
                  'Nome da unidade *',
                  'name',
                  width: 460,
                  hint: 'ex.: Loja Centro',
                  validator: (v) => (v?.trim().isEmpty ?? true) ? 'Informe o nome.' : null,
                ),
                _field(_code, 'Código', 'code', width: 200),
                _field(
                  _postalCode,
                  'CEP',
                  'postalCode',
                  width: 140,
                  hint: '00000-000',
                  keyboard: TextInputType.number,
                  validator: (v) {
                    final d = v?.replaceAll(RegExp(r'\D'), '') ?? '';
                    return d.isNotEmpty && d.length != 8 ? 'CEP com 8 dígitos.' : null;
                  },
                ),
                _field(_street, 'Logradouro', 'street', width: 420),
                _field(_number, 'Número', 'streetNumber', width: 100),
                _field(_complement, 'Complemento', 'complement', width: 240),
                _field(_district, 'Bairro', 'district', width: 240),
                _field(_city, 'Cidade', 'city', width: 300),
                _field(
                  _state,
                  'UF',
                  'state',
                  width: 80,
                  formatters: [LengthLimitingTextInputFormatter(2), UpperCaseTextFormatter()],
                ),
                _field(
                  _lat,
                  'Latitude',
                  'latitude',
                  width: 160,
                  master: false,
                  hint: '-30.0277',
                  keyboard: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  validator: (v) {
                    if ((v?.trim().isEmpty ?? true) != _lng.text.trim().isEmpty) return 'Latitude e longitude juntas.';
                    final d = _d(_lat);
                    return (v?.trim().isNotEmpty ?? false) && (d == null || d < -90 || d > 90)
                        ? 'Entre -90 e 90.'
                        : null;
                  },
                ),
                _field(
                  _lng,
                  'Longitude',
                  'longitude',
                  width: 160,
                  master: false,
                  hint: '-51.2287',
                  keyboard: const TextInputType.numberWithOptions(decimal: true, signed: true),
                  validator: (v) {
                    final d = _d(_lng);
                    return (v?.trim().isNotEmpty ?? false) && (d == null || d < -180 || d > 180)
                        ? 'Entre -180 e 180.'
                        : null;
                  },
                ),
                _field(
                  _phone,
                  'Telefone da unidade',
                  'phone',
                  width: 220,
                  master: false,
                  keyboard: TextInputType.phone,
                  validator: (v) {
                    final t = v?.trim() ?? '';
                    return t.isNotEmpty && Phones.toE164(t) == null ? 'Telefone inválido.' : null;
                  },
                ),
                _field(
                  _notes,
                  'Instruções de acesso',
                  'accessNotes',
                  width: 720,
                  master: false,
                  maxLines: 3,
                  hint: 'Portaria, horário de recebimento, onde estacionar…',
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (site != null && widget.canManage && !_fromErp)
          TextButton(onPressed: _saving ? null : _toggleActive, child: Text(site.isActive ? 'Inativar' : 'Reativar')),
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

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) =>
      newValue.copyWith(text: newValue.text.toUpperCase());
}
