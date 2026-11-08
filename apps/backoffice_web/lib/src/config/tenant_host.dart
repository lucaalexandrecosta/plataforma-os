/// Empresa a partir do endereço (docs/02 §2.3): `frio-sul.platform-lac.com.br`
/// e `frio-sul.localhost` → `frio-sul`. Na entrada genérica (`localhost`,
/// `app.`, e os demais hosts reservados) devolve `null` e o login pede a
/// empresa. Sem dependência do navegador, para rodar nos testes da VM.
String? tenantSlugFromHost(String host) {
  final parts = host.toLowerCase().split('.');
  if (parts.length < 2) return null;
  final first = parts.first;
  if (_reserved.contains(first)) return null;
  return _slug.hasMatch(first) ? first : null;
}

final _slug = RegExp(r'^[a-z0-9][a-z0-9-]{1,38}[a-z0-9]$');

/// Slugs reservados da plataforma (docs/02 §2.3) + endereços locais.
const _reserved = {
  'localhost', '127', 'api', 'app', 'auth', 'cdn', 'console', 'status', 'www', 'admin', 'mail', 'docs', 'help', //
  'suporte', 'static', 'assets', 'q', 't', 'mqtt', 'iot', 'tv', 'qr',
};
