import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/auth_controller.dart';

/// Início: atalhos. O painel em tempo real das OS entra na etapa 4/8.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    if (auth is! AuthSignedIn) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final firstName = auth.me.fullName.split(' ').first;
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text('Olá, $firstName', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 4),
        Text(
          auth.me.tenant.displayName,
          style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _Shortcut(
              icon: Icons.storefront_outlined,
              title: 'Clientes',
              subtitle: 'Cadastro de clientes, documentos e contatos gerais',
              onTap: () => context.go('/clientes'),
            ),
            if (auth.can('customers.manage'))
              _Shortcut(
                icon: Icons.add_business_outlined,
                title: 'Novo cliente',
                subtitle: 'Cadastrar um cliente',
                onTap: () => context.go('/clientes/novo'),
              ),
            _Shortcut(
              icon: Icons.inventory_2_outlined,
              title: 'Catálogo',
              subtitle: 'Produtos, serviços e famílias',
              onTap: () => context.go('/catalogo'),
            ),
            if (auth.can('imports.run'))
              _Shortcut(
                icon: Icons.upload_file_outlined,
                title: 'Importar planilha',
                subtitle: 'Clientes, produtos e serviços em lote',
                onTap: () => context.go('/importacoes'),
              ),
            const _Shortcut(
              icon: Icons.assignment_outlined,
              title: 'Ordens de serviço',
              subtitle: 'Em breve (etapa 4)',
            ),
            const _Shortcut(icon: Icons.qr_code_2, title: 'Equipamentos e QR', subtitle: 'Em breve (etapa 3)'),
          ],
        ),
      ],
    );
  }
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({required this.icon, required this.title, required this.subtitle, this.onTap});

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final enabled = onTap != null;
    return SizedBox(
      width: 280,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 32, color: enabled ? theme.colorScheme.primary : theme.disabledColor),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(color: enabled ? null : theme.disabledColor),
                      ),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
