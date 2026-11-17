import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:serverpod_client/serverpod_client.dart' show UuidValue;

import '../api/gateway.dart';
import '../api/server_gateway.dart';
import '../config.dart';

/// Gateway do app; os testes trocam por uma falsa com `overrideWithValue`.
final gatewayProvider = Provider<Gateway>((ref) => ServerGateway(apiUrl));

final sessionProvider = NotifierProvider<SessionNotifier, SessionState>(SessionNotifier.new);

sealed class SessionState {
  const SessionState();
}

/// Fora. [notice] explica por que (sessão expirada, acesso removido).
class SignedOut extends SessionState {
  const SignedOut({this.notice});
  final String? notice;
}

/// Login feito, falta escolher a empresa.
class ChoosingTenant extends SessionState {
  const ChoosingTenant(this.tenants);
  final List<TenantSummary> tenants;
}

class SignedIn extends SessionState {
  const SignedIn(this.me, this.tenants);
  final MeInfo me;
  final List<TenantSummary> tenants;

  bool can(String permission) => me.permissions.contains(permission);
}

class SessionNotifier extends Notifier<SessionState> {
  @override
  SessionState build() => const SignedOut();

  Gateway get _gateway => ref.read(gatewayProvider);

  Future<void> login(String email, String password) async {
    await _gateway.login(email, password);
    await _afterLogin();
  }

  Future<void> finishRegistration(UuidValue requestId, String code, String password) async {
    await _gateway.finishRegistration(requestId, code, password);
    await _afterLogin();
  }

  /// Com uma empresa só, entra direto; com várias, mostra a escolha.
  Future<void> _afterLogin() async {
    final tenants = await _gateway.myTenants();
    if (tenants.isEmpty) {
      _gateway.signOut();
      throw const GatewayException('Seu usuário não tem acesso a nenhuma empresa ativa. Fale com o administrador.');
    }
    if (tenants.length == 1) {
      await enter(tenants.single.slug, tenants: tenants);
    } else {
      state = ChoosingTenant(tenants);
    }
  }

  Future<void> enter(String slug, {List<TenantSummary>? tenants}) async {
    final me = await _gateway.enterTenant(slug);
    state = SignedIn(me, tenants ?? _knownTenants);
  }

  void chooseAnotherTenant() => state = ChoosingTenant(_knownTenants);

  void signOut() {
    _gateway.signOut();
    state = const SignedOut();
  }

  /// O servidor recusou a sessão: volta ao login com o aviso.
  void lost([String notice = 'Sua sessão expirou. Entre de novo.']) {
    _gateway.signOut();
    state = SignedOut(notice: notice);
  }

  List<TenantSummary> get _knownTenants => switch (state) {
    ChoosingTenant(:final tenants) => tenants,
    SignedIn(:final tenants) => tenants,
    SignedOut() => const [],
  };
}
