import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import 'session/session.dart';
import 'ui/login_page.dart';
import 'ui/visits/agenda_page.dart';
import 'ui/visits/checklist_page.dart';
import 'ui/visits/signature_page.dart';
import 'ui/visits/visit_page.dart';

/// Rotas do app. O estado da sessão decide para onde ir: fora → `/entrar`;
/// login sem empresa → `/empresa`; dentro → agenda e visitas.
final routerProvider = Provider<GoRouter>((ref) {
  final session = ValueNotifier<SessionState>(ref.read(sessionProvider));
  ref.listen(sessionProvider, (_, next) => session.value = next);
  ref.onDispose(session.dispose);

  return GoRouter(
    initialLocation: '/agenda',
    refreshListenable: session,
    redirect: (context, state) {
      final here = state.matchedLocation;
      return switch (session.value) {
        SignedOut() => here == '/entrar' ? null : '/entrar',
        ChoosingTenant() => here == '/empresa' ? null : '/empresa',
        SignedIn() => here == '/entrar' || here == '/empresa' ? '/agenda' : null,
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
      GoRoute(
        path: '/agenda',
        builder: (context, state) => const AgendaPage(),
        routes: [
          GoRoute(
            path: 'visita/:id',
            builder: (context, state) => VisitPage(id: UuidValue.withValidation(state.pathParameters['id']!)),
            routes: [
              GoRoute(
                path: 'checklist',
                builder: (context, state) =>
                    ChecklistPage(visitId: UuidValue.withValidation(state.pathParameters['id']!)),
              ),
              GoRoute(
                path: 'assinatura',
                builder: (context, state) =>
                    SignaturePage(visitId: UuidValue.withValidation(state.pathParameters['id']!)),
              ),
            ],
          ),
        ],
      ),
    ],
  );
});

class FieldApp extends ConsumerWidget {
  const FieldApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const seed = Color(0xFF0B5CAD);
    return MaterialApp.router(
      title: 'Plataforma OS · Técnico',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: seed, useMaterial3: true),
      darkTheme: ThemeData(colorSchemeSeed: seed, brightness: Brightness.dark, useMaterial3: true),
      locale: const Locale('pt', 'BR'),
      supportedLocales: const [Locale('pt', 'BR')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: ref.watch(routerProvider),
    );
  }
}
