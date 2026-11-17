import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../api/gateway.dart';
import '../session/session.dart';
import 'common/errors.dart';

enum _Mode { login, firstAccessEmail, firstAccessCode }

/// Login próprio da plataforma. "Primeiro acesso" é para quem foi convidado:
/// recebe um código no e-mail e cria a senha.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key, this.notice});

  final String? notice;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  final _code = TextEditingController();
  var _mode = _Mode.login;
  UuidValue? _requestId;
  var _busy = false;
  String? _error;

  @override
  void dispose() {
    for (final c in [_email, _password, _confirm, _code]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    final session = ref.read(sessionProvider.notifier);
    try {
      switch (_mode) {
        case _Mode.login:
          await session.login(_email.text, _password.text);
        case _Mode.firstAccessEmail:
          _requestId = await ref.read(gatewayProvider).startRegistration(_email.text);
          _password.clear();
          setState(() => _mode = _Mode.firstAccessCode);
        case _Mode.firstAccessCode:
          await session.finishRegistration(_requestId!, _code.text, _password.text);
      }
    } on GatewayException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  void _switch(_Mode mode) => setState(() {
    _mode = mode;
    _error = null;
    _password.clear();
    _confirm.clear();
    _code.clear();
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final notice = _error ?? widget.notice;
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _form,
                  child: AutofillGroup(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Plataforma OS', style: theme.textTheme.headlineSmall),
                        const SizedBox(height: 4),
                        Text(switch (_mode) {
                          _Mode.login => 'Entre com seu e-mail e senha.',
                          _Mode.firstAccessEmail => 'Primeiro acesso: informe o e-mail em que você recebeu o convite.',
                          _Mode.firstAccessCode =>
                            'Enviamos um código para ${_email.text.trim()}. Digite o código e crie sua senha.',
                        }, style: theme.textTheme.bodyMedium),
                        if (notice != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            notice,
                            key: const Key('login-notice'),
                            style: TextStyle(color: theme.colorScheme.error),
                          ),
                        ],
                        const SizedBox(height: 16),
                        TextFormField(
                          key: const Key('email'),
                          controller: _email,
                          enabled: _mode != _Mode.firstAccessCode,
                          decoration: const InputDecoration(labelText: 'E-mail', border: OutlineInputBorder()),
                          keyboardType: TextInputType.emailAddress,
                          autofillHints: const [AutofillHints.email],
                          validator: (v) => v == null || !v.contains('@') ? 'Informe um e-mail válido.' : null,
                          onFieldSubmitted: (_) => _submit(),
                        ),
                        if (_mode == _Mode.firstAccessCode) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            key: const Key('code'),
                            controller: _code,
                            decoration: const InputDecoration(labelText: 'Código', border: OutlineInputBorder()),
                            autofillHints: const [AutofillHints.oneTimeCode],
                            validator: (v) => v == null || v.trim().isEmpty ? 'Informe o código.' : null,
                          ),
                        ],
                        if (_mode != _Mode.firstAccessEmail) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            key: const Key('password'),
                            controller: _password,
                            obscureText: true,
                            decoration: InputDecoration(
                              labelText: _mode == _Mode.login ? 'Senha' : 'Nova senha',
                              border: const OutlineInputBorder(),
                              helperText: _mode == _Mode.login
                                  ? null
                                  : 'Pelo menos 8 caracteres, com letras e números.',
                            ),
                            autofillHints: [_mode == _Mode.login ? AutofillHints.password : AutofillHints.newPassword],
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Informe a senha.';
                              if (_mode == _Mode.firstAccessCode && !_strongEnough(v)) {
                                return 'Use pelo menos 8 caracteres, com letras e números.';
                              }
                              return null;
                            },
                            onFieldSubmitted: (_) => _mode == _Mode.login ? _submit() : null,
                          ),
                        ],
                        if (_mode == _Mode.firstAccessCode) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            key: const Key('confirm'),
                            controller: _confirm,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Repita a senha',
                              border: OutlineInputBorder(),
                            ),
                            validator: (v) => v != _password.text ? 'As senhas não conferem.' : null,
                            onFieldSubmitted: (_) => _submit(),
                          ),
                        ],
                        const SizedBox(height: 20),
                        FilledButton(
                          key: const Key('submit'),
                          onPressed: _busy ? null : _submit,
                          child: _busy
                              ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                              : Text(switch (_mode) {
                                  _Mode.login => 'Entrar',
                                  _Mode.firstAccessEmail => 'Enviar código',
                                  _Mode.firstAccessCode => 'Criar senha e entrar',
                                }),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: _busy
                              ? null
                              : () => _switch(_mode == _Mode.login ? _Mode.firstAccessEmail : _Mode.login),
                          child: Text(_mode == _Mode.login ? 'Primeiro acesso' : 'Já tenho senha'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Mesma regra do servidor (LoginConfig.isStrongEnough).
bool _strongEnough(String password) =>
    password.length >= 8 && password.contains(RegExp('[A-Za-z]')) && password.contains(RegExp('[0-9]'));

/// Escolha da empresa quando o login tem acesso a mais de uma.
class TenantPickerPage extends ConsumerStatefulWidget {
  const TenantPickerPage({super.key});

  @override
  ConsumerState<TenantPickerPage> createState() => _TenantPickerPageState();
}

class _TenantPickerPageState extends ConsumerState<TenantPickerPage> {
  String? _entering;

  Future<void> _enter(TenantSummary tenant) async {
    setState(() => _entering = tenant.slug);
    try {
      await ref.read(sessionProvider.notifier).enter(tenant.slug);
    } catch (e) {
      if (mounted) reportError(context, ref, e);
    } finally {
      if (mounted) setState(() => _entering = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sessionProvider);
    final tenants = state is ChoosingTenant ? state.tenants : const <TenantSummary>[];
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 440),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Escolha a empresa', style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  for (final t in tenants)
                    ListTile(
                      key: Key('tenant-${t.slug}'),
                      leading: const Icon(Icons.business),
                      title: Text(t.displayName),
                      subtitle: Text(t.slug),
                      trailing: _entering == t.slug
                          ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.chevron_right),
                      onTap: _entering == null ? () => _enter(t) : null,
                    ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => ref.read(sessionProvider.notifier).signOut(),
                    child: const Text('Sair'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
