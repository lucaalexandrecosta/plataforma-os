# backoffice_web — Flutter Web

Backoffice do tenant (docs/06 §3). Roda no navegador em `<slug>.<dominio>` (produção: `<slug>.platform-lac.com.br`).

## Rodar localmente

Pré-requisitos: ambiente de [infra/local](../../infra/local/README.md) no ar (PostgreSQL, Keycloak) e a API de dev rodando:

```bash
# na raiz
bash tool/dev/reset_local_db.sh dev            # só na primeira vez ou depois de mudar o schema
cd server && dart bin/main.dart --role monolith  # API em http://localhost:8080
```

Em outro terminal:

```bash
cd apps/backoffice_web
flutter run -d chrome --web-port 8090          # ou: -d web-server e abra no navegador
```

Abra **http://frio-sul.localhost:8090** (a empresa vem do subdomínio) ou **http://localhost:8090** (a tela pede a empresa). Usuários do Keycloak de dev, senha `dev`:

| Usuário | O que vê |
|---|---|
| `ana.admin@frio-sul.test` | frio-sul, administradora (cria e edita clientes) |
| `bruno.despacho@frio-sul.test` | frio-sul, despacho (cria e edita clientes) |
| `davi.consultor@dev.test` | frio-sul ou forno-norte, gestor (só consulta) |
| `carla.admin@forno-norte.test` | forno-norte, administradora |

A porta 8090 é a registrada no cliente `backoffice-web` do Keycloak (`redirect_uri` e `webOrigins`).

## Como funciona o login

- OIDC Authorization Code + PKCE (S256) no próprio app ([oidc.dart](lib/src/auth/oidc.dart)); sem pacote de terceiros.
- O token do Keycloak vira o token do tenant (`auth.exchangeIdpToken`, 10 min) e o app renova um minuto antes de expirar.
- **Tokens só em memória** (docs/04 §6.3). Ao recarregar a página, um novo *authorize* com `prompt=none` reaproveita a sessão SSO do Keycloak, sem pedir senha.
- "Sair" encerra também a sessão do Keycloak.

## Configuração de build

| `--dart-define` | Padrão (dev) |
|---|---|
| `API_URL` | `http://localhost:8080/` |
| `IDP_ISSUER` | `http://localhost:8180/realms/staff` |
| `IDP_CLIENT_ID` | `backoffice-web` |

Em produção a API fica na mesma origem (`/api/`, pela CDN), sem CORS.

## Estrutura

```text
lib/
├── main.dart                 # ProviderScope, tema, login antes do roteador
└── src/
    ├── config/               # AppConfig (--dart-define) e slug pelo host
    ├── auth/                 # OIDC + PKCE, AuthController (Riverpod), tela de entrada
    ├── api/                  # cliente gerado do Serverpod com o token do tenant
    ├── routing/              # go_router (URLs em português, sem #)
    ├── ui/                   # tema, menu lateral, erros
    └── features/
        ├── home/
        └── customers/        # lista (busca, filtro, cursor) e ficha com abas Dados, Unidades e Contatos
```
