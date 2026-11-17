import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../../api/gateway.dart';
import '../../labels.dart';
import '../../session/session.dart';
import '../common/errors.dart';
import '../common/format.dart';
import '../common/paged_table.dart';

/// Pessoas com acesso à empresa (permissão `users.manage`): convidar,
/// trocar perfis, suspender, reativar e remover.
class UsersPage extends ConsumerStatefulWidget {
  const UsersPage({super.key});

  @override
  ConsumerState<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends ConsumerState<UsersPage> {
  late Future<(List<TenantUser>, List<AssignableRole>)> _data;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    final g = ref.read(gatewayProvider);
    _data = () async {
      final users = g.users();
      final roles = await g.assignableRoles();
      return (await users, roles);
    }();
  }

  Future<void> _open(List<AssignableRole> roles, [TenantUser? user]) async {
    final changed = await showDialog<bool>(
      context: context,
      builder: (_) => user == null ? InviteUserDialog(roles: roles) : UserDialog(user: user, roles: roles),
    );
    if (changed == true && mounted) setState(_load);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _data,
      builder: (context, snap) {
        final roles = snap.data?.$2;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PageHeader(
              title: 'Usuários',
              actions: [
                FilledButton.icon(
                  key: const Key('user-invite'),
                  onPressed: roles == null ? null : () => _open(roles),
                  icon: const Icon(Icons.person_add_alt),
                  label: const Text('Convidar'),
                ),
              ],
            ),
            Expanded(child: _body(snap)),
          ],
        );
      },
    );
  }

  Widget _body(AsyncSnapshot<(List<TenantUser>, List<AssignableRole>)> snap) {
    if (snap.hasError) return ErrorPanel(error: snap.error!, onRetry: () => setState(_load));
    if (!snap.hasData) return const Center(child: CircularProgressIndicator());
    final (users, roles) = snap.data!;
    final names = {for (final r in roles) r.code: r.name};
    if (users.isEmpty) return const Center(child: Text('Nenhum usuário.'));
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: Text('Nome')),
            DataColumn(label: Text('E-mail')),
            DataColumn(label: Text('Perfis')),
            DataColumn(label: Text('Situação')),
            DataColumn(label: Text('Último acesso')),
          ],
          rows: [
            for (final u in users)
              DataRow(
                key: ValueKey(u.membershipId),
                onSelectChanged: (_) => _open(roles, u),
                cells: [
                  DataCell(Text(u.fullName, style: const TextStyle(fontWeight: FontWeight.w600))),
                  DataCell(Text(u.email ?? '—')),
                  DataCell(Text(u.roles.isEmpty ? '—' : u.roles.map((c) => names[c] ?? c).join(', '))),
                  DataCell(Text(_situation(u))),
                  DataCell(Text(u.lastAccessAt == null ? '—' : formatDateTime(u.lastAccessAt))),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

String _situation(TenantUser u) {
  final label = membershipStatusLabels[u.status.name] ?? u.status.name;
  if (u.status == MembershipStatus.invited) {
    return u.hasLogin ? '$label (já tem senha)' : '$label (falta o primeiro acesso)';
  }
  return label;
}

/// Perfis como caixas de marcar, com a descrição de cada um.
class _RolePicker extends StatelessWidget {
  const _RolePicker({required this.roles, required this.selected, required this.onChanged, this.error});

  final List<AssignableRole> roles;
  final Set<String> selected;
  final ValueChanged<Set<String>> onChanged;
  final String? error;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Perfis', style: theme.textTheme.titleSmall),
        for (final r in roles)
          CheckboxListTile(
            key: Key('role-${r.code}'),
            dense: true,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            title: Text(r.name),
            subtitle: r.description == null ? null : Text(r.description!),
            value: selected.contains(r.code),
            onChanged: (v) => onChanged(v == true ? {...selected, r.code} : ({...selected}..remove(r.code))),
          ),
        if (error != null) Text(error!, style: TextStyle(color: theme.colorScheme.error)),
      ],
    );
  }
}

/// Convite: a pessoa recebe o código no e-mail e cria a senha no primeiro
/// acesso.
class InviteUserDialog extends ConsumerStatefulWidget {
  const InviteUserDialog({super.key, required this.roles});

  final List<AssignableRole> roles;

  @override
  ConsumerState<InviteUserDialog> createState() => _InviteUserDialogState();
}

class _InviteUserDialogState extends ConsumerState<InviteUserDialog> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  var _roles = <String>{};
  var _busy = false;
  String? _rolesError;
  Map<String, String> _fieldErrors = const {};

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final ok = _form.currentState!.validate();
    setState(() => _rolesError = _roles.isEmpty ? 'Escolha ao menos um perfil.' : null);
    if (!ok || _roles.isEmpty) return;
    setState(() {
      _busy = true;
      _fieldErrors = const {};
    });
    try {
      await ref.read(gatewayProvider).inviteUser(_email.text, _name.text, _roles.toList()..sort());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Convite registrado. ${_name.text.trim()} cria a senha no primeiro acesso.')),
      );
      Navigator.of(context).pop(true);
    } on GatewayException catch (e) {
      if (!mounted) return;
      setState(() {
        _fieldErrors = e.fieldErrors;
        _rolesError = e.fieldErrors['roles'];
      });
      reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    InputDecoration deco(String label, String field) =>
        InputDecoration(labelText: label, border: const OutlineInputBorder(), errorText: _fieldErrors[field]);
    return AlertDialog(
      title: const Text('Convidar usuário'),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Form(
            key: _form,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  key: const Key('invite-name'),
                  controller: _name,
                  decoration: deco('Nome completo', 'fullName'),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Informe o nome.' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  key: const Key('invite-email'),
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: deco('E-mail', 'email'),
                  validator: (v) => v == null || !v.contains('@') ? 'Informe um e-mail válido.' : null,
                ),
                const SizedBox(height: 12),
                _RolePicker(
                  roles: widget.roles,
                  selected: _roles,
                  error: _rolesError,
                  onChanged: (v) => setState(() => _roles = v),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(), child: const Text('Cancelar')),
        FilledButton(key: const Key('invite-save'), onPressed: _busy ? null : _submit, child: const Text('Convidar')),
      ],
    );
  }
}

/// Acesso de uma pessoa: perfis e situação. O servidor barra mexer no
/// próprio acesso e tirar o último administrador.
class UserDialog extends ConsumerStatefulWidget {
  const UserDialog({super.key, required this.user, required this.roles});

  final TenantUser user;
  final List<AssignableRole> roles;

  @override
  ConsumerState<UserDialog> createState() => _UserDialogState();
}

class _UserDialogState extends ConsumerState<UserDialog> {
  late var _roles = widget.user.roles.toSet();
  var _busy = false;
  String? _rolesError;

  bool get _rolesChanged => _roles.length != widget.user.roles.length || !_roles.containsAll(widget.user.roles);

  Future<void> _run(Future<TenantUser> Function(Gateway g) action, String done) async {
    setState(() => _busy = true);
    try {
      await action(ref.read(gatewayProvider));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(done)));
      Navigator.of(context).pop(true);
    } on GatewayException catch (e) {
      if (mounted) reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveRoles() async {
    if (_roles.isEmpty) {
      setState(() => _rolesError = 'Escolha ao menos um perfil.');
      return;
    }
    setState(() => _rolesError = null);
    await _run((g) => g.setUserRoles(widget.user, _roles.toList()..sort()), 'Perfis atualizados.');
  }

  Future<void> _remove() async {
    final sure = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remover acesso?'),
        content: Text(
          '${widget.user.fullName} deixa de entrar nesta empresa. O histórico fica, e a pessoa pode ser convidada de novo.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Voltar')),
          FilledButton(
            key: const Key('confirm-remove'),
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Remover'),
          ),
        ],
      ),
    );
    if (sure == true) await _run((g) => g.removeUser(widget.user), 'Acesso removido.');
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.user;
    final session = ref.watch(sessionProvider);
    final self = session is SignedIn && session.me.userId == u.userId;
    final suspended = u.status == MembershipStatus.suspended;
    return AlertDialog(
      title: Text(u.fullName),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(u.email ?? 'Sem e-mail'),
              Text('Situação: ${_situation(u)}'),
              if (self) ...[
                const SizedBox(height: 8),
                const Text('Este é o seu acesso. Peça a outro administrador para alterá-lo.'),
              ],
              const SizedBox(height: 12),
              IgnorePointer(
                ignoring: self,
                child: _RolePicker(
                  roles: widget.roles,
                  selected: _roles,
                  error: _rolesError,
                  onChanged: (v) => setState(() => _roles = v),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        if (!self) ...[
          TextButton(
            key: const Key('user-remove'),
            onPressed: _busy ? null : _remove,
            child: const Text('Remover acesso'),
          ),
          if (suspended)
            TextButton(
              key: const Key('user-reactivate'),
              onPressed: _busy ? null : () => _run((g) => g.reactivateUser(u), 'Acesso reativado.'),
              child: const Text('Reativar'),
            )
          else
            TextButton(
              key: const Key('user-suspend'),
              onPressed: _busy ? null : () => _run((g) => g.suspendUser(u), 'Acesso suspenso.'),
              child: const Text('Suspender'),
            ),
        ],
        TextButton(onPressed: _busy ? null : () => Navigator.of(context).pop(), child: const Text('Fechar')),
        if (!self)
          FilledButton(
            key: const Key('user-save'),
            onPressed: _busy || !_rolesChanged ? null : _saveRoles,
            child: const Text('Salvar perfis'),
          ),
      ],
    );
  }
}
