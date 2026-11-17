/// Endereço da API. Em desenvolvimento, o servidor local (`--mode development`
/// escuta na 8080); no build: `flutter build apk --dart-define=API_URL=...`.
const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8080/');
