import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/gateway.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/paged_table.dart';

/// Cadastro de técnicos próprios (permissão `visits.schedule`).
class TechniciansPage extends ConsumerStatefulWidget {
  const TechniciansPage({super.key});

  @override
  ConsumerState<TechniciansPage> createState() => _TechniciansPageState();
}

class _TechniciansPageState extends ConsumerState<TechniciansPage> {
  late Future<List<Technician>> _list;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _list = ref.read(gatewayProvider).technicians(includeInactive: true);
  }

  Future<void> _edit([Technician? technician]) async {
    final saved = await showDialog<Technician>(
      context: context,
      builder: (_) => TechnicianDialog(technician: technician),
    );
    if (saved != null && mounted) setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(sessionProvider);
    final canManage = session is SignedIn && session.can('visits.schedule');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PageHeader(
          title: 'Técnicos',
          actions: [
            if (canManage)
              FilledButton.icon(
                key: const Key('tech-new'),
                onPressed: _edit,
                icon: const Icon(Icons.add),
                label: const Text('Novo técnico'),
              ),
          ],
        ),
        Expanded(
          child: FutureBuilder<List<Technician>>(
            future: _list,
            builder: (context, snap) {
              if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: () => setState(_load));
              if (!snap.hasData) return const Center(child: CircularProgressIndicator());
              final list = snap.data!;
              if (list.isEmpty) return const Center(child: Text('Nenhum técnico cadastrado.'));
              return SingleChildScrollView(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    showCheckboxColumn: false,
                    columns: const [
                      DataColumn(label: Text('Código')),
                      DataColumn(label: Text('Nome')),
                      DataColumn(label: Text('E-mail')),
                      DataColumn(label: Text('Telefone')),
                      DataColumn(label: Text('Acesso ao app')),
                      DataColumn(label: Text('Situação')),
                    ],
                    rows: [
                      for (final t in list)
                        DataRow(
                          key: ValueKey(t.id),
                          onSelectChanged: canManage ? (_) => _edit(t) : null,
                          cells: [
                            DataCell(Text(t.code, style: const TextStyle(fontWeight: FontWeight.w600))),
                            DataCell(Text(t.name)),
                            DataCell(Text(t.email ?? '—')),
                            DataCell(Text(t.phone ?? '—')),
                            DataCell(Text(t.userId == null ? 'Sem usuário' : 'Com usuário')),
                            DataCell(Text(t.isActive ? 'Ativo' : 'Inativo')),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Novo técnico ou edição. O vínculo com o usuário do app é mantido como está.
class TechnicianDialog extends ConsumerStatefulWidget {
  const TechnicianDialog({super.key, this.technician});

  final Technician? technician;

  @override
  ConsumerState<TechnicianDialog> createState() => _TechnicianDialogState();
}

class _TechnicianDialogState extends ConsumerState<TechnicianDialog> {
  final _form = GlobalKey<FormState>();
  late final _code = TextEditingController(text: widget.technician?.code);
  late final _name = TextEditingController(text: widget.technician?.name);
  late final _email = TextEditingController(text: widget.technician?.email);
  late final _phone = TextEditingController(text: widget.technician?.phone);
  late var _active = widget.technician?.isActive ?? true;
  var _busy = false;
  Map<String, String> _fieldErrors = const {};

  @override
  void dispose() {
    for (final c in [_code, _name, _email, _phone]) {
      c.dispose();
    }
    super.dispose();
  }

  String? _clean(TextEditingController c) => c.text.trim().isEmpty ? null : c.text.trim();

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _fieldErrors = const {};
    });
    final current = widget.technician;
    final input = TechnicianInput(
      code: _code.text.trim(),
      name: _name.text.trim(),
      email: _clean(_email),
      phone: _clean(_phone),
      userId: current?.userId,
      branchId: current?.branchId,
      isActive: _active,
    );
    final g = ref.read(gatewayProvider);
    try {
      final saved = current == null ? await g.createTechnician(input) : await g.updateTechnician(current, input);
      if (mounted) Navigator.of(context).pop(saved);
    } on GatewayException catch (e) {
      if (!mounted) return;
      setState(() => _fieldErrors = e.fieldErrors);
      reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration deco(String label, String field, {String? hint}) => InputDecoration(
      labelText: label,
      hintText: hint,
      border: const OutlineInputBorder(),
      errorText: _fieldErrors[field],
    );
    return AlertDialog(
      title: Text(widget.technician == null ? 'Novo técnico' : 'Editar técnico'),
      content: SizedBox(
        width: 440,
        child: Form(
          key: _form,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                key: const Key('tech-code'),
                controller: _code,
                decoration: deco('Código', 'code', hint: 'T01'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Informe o código.' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('tech-name'),
                controller: _name,
                decoration: deco('Nome', 'name'),
                validator: (v) => v == null || v.trim().isEmpty ? 'Informe o nome.' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(controller: _email, decoration: deco('E-mail', 'email')),
              const SizedBox(height: 12),
              TextFormField(
                key: const Key('tech-phone'),
                controller: _phone,
                decoration: deco('Celular', 'phone', hint: '(51) 99999-0000'),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Ativo'),
                value: _active,
                onChanged: (v) => setState(() => _active = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(key: const Key('tech-save'), onPressed: _busy ? null : _submit, child: const Text('Salvar')),
      ],
    );
  }
}
