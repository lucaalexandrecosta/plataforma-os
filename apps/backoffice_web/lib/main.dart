import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'src/auth/auth_controller.dart';
import 'src/auth/login_page.dart';
import 'src/routing/router.dart';
import 'src/ui/theme.dart';

Future<void> main() async {
  // URLs sem "#": o Keycloak devolve para /auth/callback e os links
  // (/clientes/<id>) podem ser compartilhados.
  usePathUrlStrategy();
  await initializeDateFormatting('pt_BR');
  runApp(const ProviderScope(child: BackofficeApp()));
}

class BackofficeApp extends ConsumerStatefulWidget {
  const BackofficeApp({super.key});

  @override
  ConsumerState<BackofficeApp> createState() => _BackofficeAppState();
}

class _BackofficeAppState extends ConsumerState<BackofficeApp> {
  @override
  void initState() {
    super.initState();
    // Lê a volta do login, ou tenta o login silencioso numa recarga.
    Future.microtask(() => ref.read(authProvider.notifier).start());
  }

  static const _locale = Locale('pt', 'BR');
  static const _delegates = [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ];

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider);
    final light = buildTheme(Brightness.light);
    final dark = buildTheme(Brightness.dark);

    if (auth is AuthSignedIn) {
      return MaterialApp.router(
        title: 'Plataforma OS — ${auth.me.tenant.displayName}',
        theme: light,
        darkTheme: dark,
        locale: _locale,
        supportedLocales: const [_locale],
        localizationsDelegates: _delegates,
        debugShowCheckedModeBanner: false,
        routerConfig: ref.watch(routerProvider),
      );
    }
    return MaterialApp(
      title: 'Plataforma OS',
      theme: light,
      darkTheme: dark,
      locale: _locale,
      supportedLocales: const [_locale],
      localizationsDelegates: _delegates,
      debugShowCheckedModeBanner: false,
      home: switch (auth) {
        AuthSignedOut() => LoginPage(key: ValueKey(auth.message), state: auth),
        AuthLoading(:final message) => LoadingPage(message: message),
        AuthSignedIn() => const SizedBox.shrink(),
      },
    );
  }
}
