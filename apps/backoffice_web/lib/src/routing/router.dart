import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../features/catalog/catalog_page.dart';
import '../features/catalog/product_form_page.dart';
import '../features/catalog/service_form_page.dart';
import '../features/customers/customer_form_page.dart';
import '../features/customers/customers_list_page.dart';
import '../features/home/home_page.dart';
import '../features/imports/imports_page.dart';
import '../ui/app_shell.dart';

/// Rotas das telas logadas. URLs em português, como o usuário as vê.
/// O login (e a volta do Keycloak em /auth/callback) é resolvido antes do
/// roteador existir (ver `BackofficeApp`).
final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: _initialLocation(),
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(location: state.uri.path, child: child),
        routes: [
          GoRoute(
            path: '/',
            pageBuilder: (_, _) => const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: '/importacoes',
            pageBuilder: (_, _) => const NoTransitionPage(child: ImportsPage()),
          ),
          GoRoute(path: '/catalogo', redirect: (_, _) => '/catalogo/produtos'),
          GoRoute(
            path: '/catalogo/produtos',
            pageBuilder: (_, _) => const NoTransitionPage(child: CatalogPage(tab: CatalogTab.products)),
            routes: [
              GoRoute(path: 'novo', builder: (_, _) => const ProductFormPage()),
              GoRoute(
                path: ':id',
                builder: (_, state) {
                  final id = _uuidOrNull(state.pathParameters['id']!);
                  return id == null ? const _NotFound() : ProductFormPage(key: ValueKey(id), id: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/catalogo/servicos',
            pageBuilder: (_, _) => const NoTransitionPage(child: CatalogPage(tab: CatalogTab.services)),
            routes: [
              GoRoute(path: 'novo', builder: (_, _) => const ServiceFormPage()),
              GoRoute(
                path: ':id',
                builder: (_, state) {
                  final id = _uuidOrNull(state.pathParameters['id']!);
                  return id == null ? const _NotFound() : ServiceFormPage(key: ValueKey(id), id: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/catalogo/familias',
            pageBuilder: (_, _) => const NoTransitionPage(child: CatalogPage(tab: CatalogTab.families)),
          ),
          GoRoute(
            path: '/clientes',
            pageBuilder: (_, _) => const NoTransitionPage(child: CustomersListPage()),
            routes: [
              GoRoute(path: 'novo', builder: (_, _) => const CustomerFormPage()),
              GoRoute(
                path: ':id',
                builder: (_, state) {
                  final id = _uuidOrNull(state.pathParameters['id']!);
                  return id == null ? const _NotFound() : CustomerFormPage(key: ValueKey(id), id: id);
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (_, _) => const _NotFound(),
  );
  ref.onDispose(router.dispose);
  return router;
});

UuidValue? _uuidOrNull(String raw) {
  try {
    return UuidValue.withValidation(raw);
  } on FormatException {
    return null;
  }
}

String _initialLocation() {
  final uri = Uri.base;
  if (uri.path == '/auth/callback' || uri.path.isEmpty) return '/';
  return uri.hasQuery ? '${uri.path}?${uri.query}' : uri.path;
}

class _NotFound extends StatelessWidget {
  const _NotFound();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Página não encontrada.'),
          const SizedBox(height: 12),
          TextButton(onPressed: () => context.go('/'), child: const Text('Ir para o início')),
        ],
      ),
    ),
  );
}
