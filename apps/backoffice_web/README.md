# Backoffice web (Flutter Web)

Primeira fatia do backoffice da equipe (docs/13 §4, etapa 4): login próprio,
primeiro acesso, escolha de empresa, ordens de serviço (lista, abertura pelo bem
ou pela etiqueta, detalhe com histórico e ciclo de status) e bens (lista e ficha
com as OS do bem). As ações aparecem conforme as permissões do usuário; o
servidor sempre confere de novo.

Tokens ficam só em memória (docs/04 §4.3): recarregar a página pede login de
novo. A sessão de login (10 min) é renovada pelo refresh token, e o token da
empresa (10 min) é pedido de novo a `auth.selectTenant` antes de vencer.

## Rodar

Com o servidor em modo development (API em `http://localhost:8080/`):

```bash
flutter run -d chrome
```

Contra outro servidor: `--dart-define=API_URL=https://api.exemplo.com/`.

## Testes e build

```bash
flutter analyze --fatal-infos
flutter test
flutter build web --release --no-web-resources-cdn
```

`--no-web-resources-cdn` empacota o CanvasKit no build, sem buscar no CDN do
Google (docs/04 §4.3: nenhum script de terceiro na origem do backoffice).

Os testes de widget usam `test/fake_gateway.dart` no lugar do servidor; as
telas só falam com o servidor pela interface `Gateway` (`lib/src/api`).
