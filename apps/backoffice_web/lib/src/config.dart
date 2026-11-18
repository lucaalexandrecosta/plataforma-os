/// Endereço da API. Em desenvolvimento, o servidor local (`--mode development`
/// escuta na 8080); no build: `flutter build web --dart-define=API_URL=...`.
///
/// Um endereço relativo (ex.: `/api/`, usado na imagem do infra/staging, em
/// que o backoffice e a API saem pelo mesmo endereço) é resolvido contra o
/// endereço da página.
final apiUrl = resolveApiUrl(const String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8080/'), Uri.base);

String resolveApiUrl(String configured, Uri page) {
  final uri = Uri.parse(configured);
  final absolute = uri.hasScheme ? uri : page.resolveUri(uri);
  final text = absolute.toString();
  return text.endsWith('/') ? text : '$text/';
}
