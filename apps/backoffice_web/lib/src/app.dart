import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import 'session/session.dart';
import 'ui/agenda/agenda_page.dart';
import 'ui/agenda/technicians_page.dart';
import 'ui/assets/asset_detail_page.dart';
import 'ui/assets/assets_page.dart';
import 'ui/depreciation/depreciation_page.dart';
import 'ui/login_page.dart';
import 'ui/shell.dart';
import 'ui/work_orders/work_order_detail_page.dart';
import 'ui/work_orders/work_orders_page.dart';

/// Rotas do backoffice. O estado da sessão decide para onde ir: fora →
/// `/entrar`; login sem empresa → `/empresa`; dentro → as telas.
final routerProvider = Provider<GoRouter>((ref) {
  final session = ValueNotifier<SessionState>(ref.read(sessionProvider));
  ref.listen(sessionProvider, (_, next) => session.value = next);
  ref.onDispose(session.dispose);

  return GoRouter(
    initialLocation: '/os',
    refreshListenable: session,
    redirect: (context, state) {
      final here = state.matchedLocation;
      return switch (session.value) {
        SignedOut() => here == '/entrar' ? null : '/entrar',
        ChoosingTenant() => here == '/empresa' ? null : '/empresa',
        SignedIn() => here == '/entrar' || here == '/empresa' ? '/os' : null,
      };
    },
    routes: [
      GoRoute(
        path: '/entrar',
        builder: (context, state) {
          final s = session.value;
          return LoginPage(notice: s is SignedOut ? s.notice : null);
        },
      ),
      GoRoute(path: '/empresa', builder: (context, state) => const TenantPickerPage()),
      ShellRoute(
        builder: (context, state, child) => AppShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: '/os',
            builder: (context, state) => const WorkOrdersPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) =>
                    WorkOrderDetailPage(id: UuidValue.withValidation(state.pathParameters['id']!)),
              ),
            ],
          ),
          GoRoute(path: '/agenda', builder: (context, state) => const AgendaPage()),
          GoRoute(path: '/tecnicos', builder: (context, state) => const TechniciansPage()),
          GoRoute(path: '/depreciacao', builder: (context, state) => const DepreciationPage()),
          GoRoute(
            path: '/bens',
            builder: (context, state) => const AssetsPage(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => AssetDetailPage(id: UuidValue.withValidation(state.pathParameters['id']!)),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class BackofficeApp extends ConsumerWidget {
  const BackofficeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Plataforma OS',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: const Color(0xFF0B5CAD), useMaterial3: true),
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
