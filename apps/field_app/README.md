# App do técnico

App Flutter (Android e iOS) para o técnico de campo: login próprio da
plataforma, escolha da empresa, **minha agenda** e **execução da visita**
(deslocamento, check-in por QR, GPS ou manual, pausa, finalização com
resultado e "Concluir OS").

Esta é a primeira fatia, **online**: cada ação vai direto ao servidor. O banco
local (Drift + SQLCipher), a fila de mutações e o sync offline (docs/06 §5 e
§6), o refresh token no `flutter_secure_storage` (docs/04 §4.4), checklist,
itens, fotos e assinatura vêm nas próximas etapas.

## Rodar

```bash
# servidor local (server/README) e depois:
cd apps/field_app
flutter run --dart-define=API_URL=http://10.0.2.2:8080/   # emulador Android
```

O login precisa de um acesso com papel `technician` ligado a um técnico
(`technicians.userId`); sem o vínculo, a agenda explica o que falta.

## Estrutura

- `lib/src/api`: `Gateway` (tudo o que o app pede ao servidor) e
  `ServerGateway` (cliente gerado do Serverpod, tokens em memória).
- `lib/src/device`: GPS e leitor de QR atrás da interface `Device`.
- `lib/src/session`: estado da sessão (Riverpod) que guia as rotas.
- `lib/src/ui/visits`: agenda, detalhe da visita e diálogos de execução.

## Testes

```bash
flutter analyze --fatal-infos
flutter test
```

Os testes de widget usam `test/fake_gateway.dart`, que imita as regras de
transição da visita do servidor, e um `FakeDevice` para GPS e QR.
