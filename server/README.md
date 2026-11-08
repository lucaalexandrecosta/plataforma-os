# server — Serverpod 4.1 (api + worker)

Um executável, dois papéis (docs/02 §3.1): `--role serverless` (api) e `--role monolith` (worker; em dev, tudo num processo só).

## Estrutura

```text
lib/
├── server.dart                 # Serverpod + handler de autenticação + databaseInterceptor
└── src/
    ├── platform/               # núcleo técnico, sem regra de negócio
    │   ├── context/            # RequestContext anexado à Session
    │   ├── db/                 # TenantScopedDatabase (set_config por transação)
    │   ├── auth/               # tokens ES256, token do Keycloak, handler, revogação
    │   ├── endpoints/          # StaffEndpoint, CustomerEndpoint, PublicEndpoint
    │   ├── errors/             # ApiException (modelo) e fábricas do catálogo
    │   ├── authz/              # Grants: papéis e permissões relidos do banco por requisição
    │   ├── paging/             # PageRequest + cursor keyset assinado (HMAC)
    │   ├── outbox/             # eventos de domínio na mesma transação
    │   └── models/             # enums comuns (RecordSource)
    ├── tenancy/                # camada 1: tenants (TenantDirectory)
    ├── identity_access/        # camada 2: vínculos, papéis, auth.*, me.*
    ├── customers/              # camada 2: customers.*, customerSites.*, customerContacts.* e as importações deles
    ├── imports/                # imports.*: planilha (CSV/XLSX) → prévia → confirmação → relatório
    └── generated/              # gerado pelo Serverpod (versionado; o CI confere)
migrations/                     # só as tabelas internas do Serverpod (schema public)
test/unit/                      # sem banco
test/e2e/                       # servidor + banco reais (isolamento, Keycloak, cadastros)
```

## Padrão de cadastro (docs/08 §3.1)

O [cadastro de clientes](lib/src/customers/internal/customer_service.dart) é a referência para os próximos:

| Peça | Como |
|---|---|
| Leitura | `requireAnyRole(internalRoles)`; outro tenant → `NOT_FOUND` (a RLS esconde) |
| Escrita | `requirePermission('<recurso>.manage')`, relida do banco: um token com papel forjado não ganha nada |
| Validação | Regras puras em `internal/<recurso>_rules.dart` (testes unitários), todos os erros por campo de uma vez; a importação por planilha usa as mesmas |
| Criação | Aceita `id` UUID v7 do app (`INVALID_UUID` se não for); `tenantId` só do contexto |
| Alteração | `<Recurso>Patch` (nulo = sem mudança, `clear` = apagar) + `expectedVersion`; `updateWhere(id & version)`; patch sem mudança real não gasta versão |
| Inativação | `deactivate(reason)` / `reactivate`; nada é apagado |
| Eventos | `Outbox.record` na mesma transação (nomes do catálogo do docs/08) |
| Auditoria, versão, `created_by` | Triggers do banco |
| Lista | `<Recurso>Filter` tipado + `PageRequest`; ordenação só pelos campos da lista; cursor de outra combinação → `CURSOR_MISMATCH` |
| Origem ERP | Campos mestres → `MASTER_FIELD_READ_ONLY` (espelha `trg_guard_erp_master`) |

Cada módulo expõe só o arquivo `<módulo>.dart`; o resto fica em `internal/`. As tabelas de negócio são SQL-first (`db/schema.sql` + dbmate) e entram nos modelos com `managedMigration: false`.

## Regras que valem desde já

- O `tenant_id` nunca vem do cliente: só do token validado (`RequestContext`).
- Todo acesso ao banco passa pelo interceptor. Endpoint sem contexto quebra com `MissingRequestContextError`.
- SQL próprio sempre parametrizado; `UuidValue` vai como texto com cast (`@id::uuid`).
- Helpers nunca como métodos públicos de endpoint (viram RPC).
- Depois de mudar um `.spy.yaml` ou um endpoint: `serverpod generate` e versionar o código gerado.

## Rodar localmente

Pré-requisitos: Dart 3.13+, `dart pub global activate serverpod_cli 4.1.1` e o ambiente de [infra/local](../infra/local/README.md).

```bash
node tool/dev/generate_dev_secrets.mjs        # cria config/passwords.yaml (fora do Git)
# tabelas internas do Serverpod, com o papel app_pod_migrator, conferidas pelo banco
PSQL="docker compose -f infra/local/compose.yaml exec -T postgres psql -U postgres -d plataforma_os" \
  bash tool/db/apply_pod_migrations.sh development
cd server
dart bin/main.dart --role monolith            # api + worker em http://localhost:8080
```

No Windows, rode o script pelo Git Bash. O código de saída do `--apply-migrations` não serve para conferir a migração neste projeto; o motivo está no cabeçalho do script.

Ao subir, o servidor avisa `Database does not match target state` por causa das colunas `timestamptz`. É esperado: o Serverpod 4.1 não conhece esse tipo (achado do S2 no relatório do spike).

## Testes

```bash
dart test test/unit                            # sem banco
# e2e: banco de teste (porta 5433) com migração + seed, Keycloak do compose,
# e o servidor em modo test
dart bin/main.dart --mode test --role monolith &
dart test test/e2e                             # isolamento entre tenants + login pelo Keycloak
```

O passo a passo completo do e2e está no job `e2e` de [.github/workflows/ci.yml](../.github/workflows/ci.yml).
