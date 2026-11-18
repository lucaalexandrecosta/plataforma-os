import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../session/session.dart';

/// Moldura das telas internas: empresa e usuário no topo, menu à esquerda.
class AppShell extends ConsumerWidget {
  const AppShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  static const _allSections = [
    (path: '/os', label: 'Ordens de serviço', icon: Icons.assignment_outlined, selected: Icons.assignment, needs: null),
    (path: '/agenda', label: 'Agenda', icon: Icons.event_outlined, selected: Icons.event, needs: null),
    (path: '/bens', label: 'Bens', icon: Icons.inventory_2_outlined, selected: Icons.inventory_2, needs: null),
    (
      path: '/clientes',
      label: 'Clientes',
      icon: Icons.storefront_outlined,
      selected: Icons.storefront,
      needs: 'customers.manage|work_orders.read|assets.manage|visits.schedule',
    ),
    (
      path: '/depreciacao',
      label: 'Depreciação',
      icon: Icons.trending_down_outlined,
      selected: Icons.trending_down,
      needs: 'depreciation.read',
    ),
    (
      path: '/tecnicos',
      label: 'Técnicos',
      icon: Icons.engineering_outlined,
      selected: Icons.engineering,
      needs: 'visits.schedule',
    ),
    (
      path: '/cadastros',
      label: 'Cadastros',
      icon: Icons.domain_outlined,
      selected: Icons.domain,
      needs: 'settings.manage|catalog.manage|assets.manage',
    ),
    (
      path: '/checklists',
      label: 'Checklists',
      icon: Icons.checklist_outlined,
      selected: Icons.checklist,
      needs: 'catalog.manage',
    ),
    (
      path: '/etiquetas',
      label: 'Etiquetas QR',
      icon: Icons.qr_code_2_outlined,
      selected: Icons.qr_code_2,
      needs: 'qr_tags.manage',
    ),
    (
      path: '/usuarios',
      label: 'Usuários',
      icon: Icons.manage_accounts_outlined,
      selected: Icons.manage_accounts,
      needs: 'users.manage',
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionProvider);
    if (state is! SignedIn) return const SizedBox.shrink();
    final me = state.me;
    final sections = [
      for (final s in _allSections)
        if (s.needs == null || s.needs!.split('|').any(state.can)) s,
    ];
    final index = sections.indexWhere((s) => location.startsWith(s.path));
    final wide = MediaQuery.sizeOf(context).width >= 900;

    return Scaffold(
      appBar: AppBar(
        title: Text(me.tenant.displayName),
        actions: [
          PopupMenuButton<String>(
            key: const Key('user-menu'),
            tooltip: 'Conta',
            onSelected: (choice) {
              final session = ref.read(sessionProvider.notifier);
              if (choice == 'switch') session.chooseAnotherTenant();
              if (choice == 'logout') session.signOut();
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                enabled: false,
                child: Text(me.email == null ? me.fullName : '${me.fullName}\n${me.email}'),
              ),
              const PopupMenuDivider(),
              if (state.tenants.length > 1) const PopupMenuItem(value: 'switch', child: Text('Trocar de empresa')),
              const PopupMenuItem(value: 'logout', child: Text('Sair')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Icon(Icons.account_circle_outlined),
                  const SizedBox(width: 8),
                  Text(me.fullName),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            extended: wide,
            selectedIndex: index < 0 ? null : index,
            labelType: wide ? NavigationRailLabelType.none : NavigationRailLabelType.all,
            onDestinationSelected: (i) => context.go(sections[i].path),
            destinations: [
              for (final s in sections)
                NavigationRailDestination(icon: Icon(s.icon), selectedIcon: Icon(s.selected), label: Text(s.label)),
            ],
          ),
          const VerticalDivider(width: 1),
          // A chave da empresa zera o estado das telas ao trocar de empresa.
          Expanded(
            child: KeyedSubtree(key: ValueKey(me.tenant.id), child: child),
          ),
        ],
      ),
    );
  }
}
