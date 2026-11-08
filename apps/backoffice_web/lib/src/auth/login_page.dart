import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_controller.dart';

/// Entrada do backoffice. No subdomínio do tenant (`<slug>.<dominio>`) a
/// empresa já vem do endereço; na entrada genérica, a pessoa informa.
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({required this.state, super.key});

  final AuthSignedOut state;

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final _slug = TextEditingController(text: widget.state.tenantSlug ?? '');
  final _form = GlobalKey<FormState>();

  @override
  void dispose() {
    _slug.dispose();
    super.dispose();
  }

  void _submit() {
    if (_form.currentState?.validate() ?? false) ref.read(authProvider.notifier).signIn(_slug.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fixedTenant = ref.watch(appConfigProvider).tenantSlug != null;
    final message = widget.state.message;
    return Scaffold(
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(Icons.build_circle_outlined, size: 48, color: theme.colorScheme.primary),
                      const SizedBox(height: 12),
                      Text('Plataforma OS', style: theme.textTheme.headlineSmall, textAlign: TextAlign.center),
                      const SizedBox(height: 4),
                      Text(
                        'Backoffice: ordens de serviço, clientes e equipamentos',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      if (message != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.errorContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(message, style: TextStyle(color: theme.colorScheme.onErrorContainer)),
                        ),
                        const SizedBox(height: 16),
                      ],
                      TextFormField(
                        controller: _slug,
                        readOnly: fixedTenant,
                        autofocus: !fixedTenant,
                        decoration: const InputDecoration(
                          labelText: 'Empresa',
                          hintText: 'ex.: frio-sul',
                          prefixIcon: Icon(Icons.apartment_outlined),
                        ),
                        validator: (v) {
                          final s = v?.trim().toLowerCase() ?? '';
                          if (s.isEmpty) return 'Informe o identificador da empresa.';
                          if (!RegExp(r'^[a-z0-9][a-z0-9-]{1,38}[a-z0-9]$').hasMatch(s)) {
                            return 'Use letras minúsculas, números e hífen.';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: _submit,
                        icon: const Icon(Icons.login),
                        label: const Text('Entrar'),
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(44)),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Você será levado à página de login segura da plataforma.',
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                    ],
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

class LoadingPage extends StatelessWidget {
  const LoadingPage({required this.message, super.key});
  final String message;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [const CircularProgressIndicator(), const SizedBox(height: 16), Text(message)],
      ),
    ),
  );
}
