import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_controller.dart';

/// Itens do menu lateral. Os próximos cadastros (unidades, produtos, ativos,
/// técnicos) e as OS entram aqui conforme as etapas do guia (docs/13 §4).
final class _Destination {
  const _Destination(this.path, this.label, this.icon, this.selectedIcon, {this.permission});
  final String path;

  /// Só aparece para quem tem a permissão (o servidor confere de novo).
  final String? permission;
  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

const _allDestinations = [
  _Destination('/', 'Início', Icons.home_outlined, Icons.home),
  _Destination('/clientes', 'Clientes', Icons.storefront_outlined, Icons.storefront),
  _Destination('/importacoes', 'Importar', Icons.upload_file_outlined, Icons.upload_file, permission: 'imports.run'),
];

/// Estrutura das telas logadas: menu lateral (recolhido em telas estreitas),
/// empresa atual e usuário.
class AppShell extends ConsumerWidget {
  const AppShell({required this.location, required this.child, super.key});

  final String location;
  final Widget child;

  int _selectedIn(List<_Destination> destinations) {
    for (var i = destinations.length - 1; i >= 0; i--) {
      final p = destinations[i].path;
      if (p == '/' ? location == '/' : location.startsWith(p)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final me = auth is AuthSignedIn ? auth.me : null;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final theme = Theme.of(context);
    final destinations = [
      for (final d in _allDestinations)
        if (d.permission == null || (auth is AuthSignedIn && auth.can(d.permission!))) d,
    ];
    final selected = _selectedIn(destinations);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            Icon(Icons.build_circle_outlined, color: theme.colorScheme.primary),
            const SizedBox(width: 8),
            const Text('Plataforma OS'),
            if (me != null) ...[
              const SizedBox(width: 16),
              Chip(
                avatar: const Icon(Icons.apartment_outlined, size: 18),
                label: Text(me.tenant.displayName),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ],
        ),
        actions: [
          if (me != null)
            PopupMenuButton<String>(
              tooltip: 'Conta',
              offset: const Offset(0, 48),
              itemBuilder: (_) => [
                PopupMenuItem(
                  enabled: false,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(me.fullName),
                    subtitle: Text([me.email, me.roles.map(_roleLabel).join(', ')].whereType<String>().join('\n')),
                  ),
                ),
                const PopupMenuDivider(),
                const PopupMenuItem(
                  value: 'logout',
                  child: ListTile(leading: Icon(Icons.logout), title: Text('Sair')),
                ),
              ],
              onSelected: (v) {
                if (v == 'logout') ref.read(authProvider.notifier).signOut();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CircleAvatar(radius: 16, child: Text(_initials(me.fullName))),
              ),
            ),
        ],
      ),
      drawer: wide ? null : Drawer(child: _navList(context, destinations, selected)),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (wide)
            NavigationRail(
              extended: MediaQuery.sizeOf(context).width >= 1200,
              selectedIndex: selected,
              labelType: MediaQuery.sizeOf(context).width >= 1200 ? null : NavigationRailLabelType.all,
              onDestinationSelected: (i) => context.go(destinations[i].path),
              destinations: [
                for (final d in destinations)
                  NavigationRailDestination(
                    icon: Icon(d.icon),
                    selectedIcon: Icon(d.selectedIcon),
                    label: Text(d.label),
                  ),
              ],
            ),
          if (wide) const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }

  Widget _navList(BuildContext context, List<_Destination> destinations, int selected) => ListView(
    children: [
      for (var i = 0; i < destinations.length; i++)
        ListTile(
          leading: Icon(i == selected ? destinations[i].selectedIcon : destinations[i].icon),
          title: Text(destinations[i].label),
          selected: i == selected,
          onTap: () {
            Navigator.of(context).pop();
            context.go(destinations[i].path);
          },
        ),
    ],
  );

  static String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    return (parts.first[0] + (parts.length > 1 ? parts.last[0] : '')).toUpperCase();
  }
}

String _roleLabel(String role) => switch (role) {
  'tenant_admin' => 'Administrador',
  'dispatcher' => 'Despacho',
  'backoffice_agent' => 'Atendimento',
  'manager' => 'Gestor',
  'technician' => 'Técnico',
  'sales_rep' => 'Vendedor',
  _ => role,
};
