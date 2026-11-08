import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:web/web.dart' as web;

import '../api/api_client.dart';
import '../config/app_config.dart';
import 'oidc.dart';

/// Estado da sessão do backoffice.
sealed class AuthState {
  const AuthState();
}

/// Lendo a volta do login ou fazendo o login silencioso.
final class AuthLoading extends AuthState {
  const AuthLoading([this.message = 'Carregando…']);
  final String message;
}

final class AuthSignedOut extends AuthState {
  const AuthSignedOut({this.message, this.tenantSlug});
  final String? message;
  final String? tenantSlug;
}

final class AuthSignedIn extends AuthState {
  const AuthSignedIn(this.me);
  final MeInfo me;

  bool can(String permission) => me.permissions.contains(permission);
}

final appConfigProvider = Provider<AppConfig>((ref) => AppConfig.fromEnvironment());
final oidcProvider = Provider<OidcClient>((ref) => OidcClient(ref.watch(appConfigProvider)));

final authProvider = NotifierProvider<AuthController, AuthState>(AuthController.new);

/// Login da equipe (docs/04 §4.2 e §4.3): token do Keycloak → token do tenant
/// (`auth.exchangeIdpToken`, 10 min) → `me.get`. Renova sozinho um minuto
/// antes de expirar; se a renovação falhar, volta para o login.
class AuthController extends Notifier<AuthState> {
  static const _slugKey = 'po.tenantSlug';
  static const _returnKey = 'po.returnTo';

  OidcTokens? _idp;
  Timer? _renewal;

  OidcClient get _oidc => ref.read(oidcProvider);
  AppConfig get _config => ref.read(appConfigProvider);
  TokenHolder get _tokens => ref.read(tokenHolderProvider);

  @override
  AuthState build() {
    ref.onDispose(() => _renewal?.cancel());
    return const AuthLoading();
  }

  /// Chamado uma vez na abertura do app.
  Future<void> start() async {
    final uri = Uri.base;
    if (uri.path == '/auth/callback') {
      final result = await _oidc.handleCallback(uri);
      final returnTo = web.window.sessionStorage.getItem(_returnKey) ?? '/';
      web.window.sessionStorage.removeItem(_returnKey);
      web.window.history.replaceState(null, '', returnTo);
      final tokens = result?.tokens;
      if (result == null || tokens == null) {
        state = AuthSignedOut(message: result?.error, tenantSlug: result?.tenantSlug ?? _rememberedSlug);
        return;
      }
      _idp = tokens;
      await _enterTenant(result.tenantSlug ?? _rememberedSlug);
      return;
    }

    final slug = _config.tenantSlug ?? _rememberedSlug;
    if (_oidc.wasSignedIn && slug != null) {
      // Recarga da página: os tokens estavam só em memória. A sessão SSO do
      // Keycloak traz o usuário de volta sem senha (prompt=none).
      state = const AuthLoading('Restaurando a sessão…');
      _rememberReturn(uri);
      _oidc.redirectToLogin(tenantSlug: slug, silent: true);
      return;
    }
    state = AuthSignedOut(tenantSlug: slug);
  }

  /// Botão "Entrar".
  void signIn(String tenantSlug) {
    final slug = tenantSlug.trim().toLowerCase();
    web.window.sessionStorage.setItem(_slugKey, slug);
    state = const AuthLoading('Abrindo o login…');
    _oidc.redirectToLogin(tenantSlug: slug);
  }

  void signOut() {
    _renewal?.cancel();
    _tokens.clear();
    final idp = _idp;
    _idp = null;
    _oidc.logout(idp);
  }

  String? get _rememberedSlug => _config.tenantSlug ?? web.window.sessionStorage.getItem(_slugKey);

  void _rememberReturn(Uri uri) {
    final path = uri.path == '/' ? '/' : '${uri.path}${uri.hasQuery ? '?${uri.query}' : ''}';
    web.window.sessionStorage.setItem(_returnKey, path);
  }

  Future<void> _enterTenant(String? slug) async {
    if (slug == null) {
      state = const AuthSignedOut(message: 'Informe a empresa para entrar.');
      return;
    }
    state = const AuthLoading('Entrando…');
    try {
      final client = ref.read(apiClientProvider);
      final tenantToken = await client.auth.exchangeIdpToken(_idp!.accessToken, slug);
      _tokens.set(tenantToken.accessToken);
      final me = await client.me.get();
      _oidc.markSignedIn();
      web.window.sessionStorage.setItem(_slugKey, slug);
      _scheduleRenewal(Duration(seconds: tenantToken.expiresIn));
      state = AuthSignedIn(me);
    } on ApiException catch (e) {
      _tokens.clear();
      state = AuthSignedOut(message: _loginMessage(e), tenantSlug: slug);
    } on Object {
      _tokens.clear();
      state = AuthSignedOut(message: 'Não foi possível falar com o servidor. Tente de novo.', tenantSlug: slug);
    }
  }

  void _scheduleRenewal(Duration lifetime) {
    _renewal?.cancel();
    final wait = lifetime - const Duration(seconds: 60);
    _renewal = Timer(wait.isNegative ? Duration.zero : wait, _renew);
  }

  Future<void> _renew() async {
    final current = state;
    if (current is! AuthSignedIn) return;
    final slug = current.me.tenant.slug;
    try {
      final refreshed = await _oidc.refresh(_idp!);
      if (refreshed == null) throw StateError('refresh recusado');
      _idp = refreshed;
      final tenantToken = await ref.read(apiClientProvider).auth.exchangeIdpToken(refreshed.accessToken, slug);
      _tokens.set(tenantToken.accessToken);
      _scheduleRenewal(Duration(seconds: tenantToken.expiresIn));
    } on Object {
      _tokens.clear();
      state = AuthSignedOut(message: 'Sua sessão expirou. Entre de novo.', tenantSlug: slug);
    }
  }

  static String _loginMessage(ApiException e) => switch (e.code) {
    'FORBIDDEN' => 'Seu usuário não tem acesso a esta empresa.',
    'TENANT_SUSPENDED' => 'A conta desta empresa está suspensa.',
    'UNAUTHENTICATED' => 'O login expirou. Entre de novo.',
    _ => e.detail,
  };
}
