import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../auth/auth_controller.dart';

/// Token do tenant, só em memória (docs/04 §6.3: nada em localStorage).
final class TokenHolder {
  String? _token;
  String? get token => _token;
  void set(String token) => _token = token;
  void clear() => _token = null;
}

final tokenHolderProvider = Provider<TokenHolder>((ref) => TokenHolder());

final class _TenantTokenProvider implements ClientAuthKeyProvider {
  _TenantTokenProvider(this._holder);
  final TokenHolder _holder;

  @override
  Future<String?> get authHeaderValue async {
    final token = _holder.token;
    return token == null ? null : wrapAsBearerAuthHeaderValue(token);
  }
}

/// Cliente Dart gerado pelo Serverpod. Endpoints públicos (auth.*) vão sem
/// token; os da equipe levam o token do tenant.
final apiClientProvider = Provider<Client>((ref) {
  final client = Client(ref.watch(appConfigProvider).apiUrl)
    ..authKeyProvider = _TenantTokenProvider(ref.watch(tokenHolderProvider));
  ref.onDispose(client.close);
  return client;
});
