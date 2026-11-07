# Spike S1 (Serverpod + RLS) e primeiros achados do S2 (ORM em tabelas não gerenciadas)

Data: 07/11/2026 · Serverpod 4.1.1 · Dart 3.13.7 · Situação: **S1 aprovado** em PostgreSQL 18 com o schema completo, login real pelo Keycloak e custo do escopo medido (§3.1). Falta só a primeira execução no CI (o repositório ainda não tem remoto). S2 parcial.

## 1. Pergunta do S1

O `databaseInterceptor` garante `set_config('app.tenant_id', ...)` em toda operação (ORM, SQL próprio, transações) com o pool do Serverpod? ([docs/12 §7](../12-stack-dart-flutter-serverpod.md))

## 2. O que foi construído

| Peça | Arquivo |
|---|---|
| Interceptor que implementa a interface `Database` inteira do Serverpod 4.1.1 e embrulha cada operação numa transação iniciada por `set_config(..., true)` | [tenant_scoped_database.dart](../../server/lib/src/platform/db/tenant_scoped_database.dart) |
| Contexto imutável da requisição, anexado à `Session` | [request_context.dart](../../server/lib/src/platform/context/request_context.dart) |
| Handler de autenticação: só tokens próprios ES256; anexa o contexto | [authentication_handler.dart](../../server/lib/src/platform/auth/authentication_handler.dart) |
| Emissão/validação dos tokens (alg, `kid`, `typ`, `aud`, `iss`, `exp` com tolerância) | [access_token_service.dart](../../server/lib/src/platform/auth/access_token_service.dart) |
| Validação do token do Keycloak pela JWKS (RS256, `azp`, cache e releitura na rotação) | [idp_token_verifier.dart](../../server/lib/src/platform/auth/idp_token_verifier.dart) |
| Endpoints `auth.exchangeIdpToken`, `me.get`, `me.tenants` | [identity_access/endpoints](../../server/lib/src/identity_access/endpoints/) |
| Teste de ponta a ponta com dois tenants | [tenant_isolation_e2e_test.dart](../../server/test/e2e/tenant_isolation_e2e_test.dart) |

## 3. Como foi validado

1. PostgreSQL 16.13 real (pacote `serverpod_embedded_postgres`, sem Docker) com: papéis de login ([10-login-roles.sql](../../infra/local/postgres/10-login-roles.sql)), migração inicial, migrações do Serverpod aplicadas pelo papel `app_pod_migrator` e o [seed de dois tenants](../../db/seeds/dev_seed.sql).
2. Servidor real (`dart bin/main.dart --mode test --role monolith`) conectado como `app_api` (membro de `app_runtime`, sujeito a RLS FORCE).
3. Cliente Dart gerado chamando os endpoints com tokens dos dois tenants.

**Resultado: 8 de 8 testes passaram.**

| Cenário | Resultado |
|---|---|
| Tenant A: `me.get` devolve só o tenant do token, papéis e permissões lidos do banco | ✔ |
| Tenant B: outro usuário só vê o próprio tenant em `me.tenants` | ✔ |
| Usuário com vínculo em A e B vê os dois só na lista de troca | ✔ |
| **Token validamente assinado** com `tid` de um tenant sem vínculo → `FORBIDDEN` (a RLS não mostra o vínculo; o servidor relê o banco) | ✔ |
| Sem token, token adulterado, token de contato em endpoint da equipe → recusados | ✔ |
| `auth.exchangeIdpToken` com token de IdP inválido → `UNAUTHENTICATED` sem detalhes | ✔ |

Os testes unitários dos tokens (11) cobrem `alg: none`, troca de algoritmo (HS256 com a chave pública), `kid` desconhecido, assinatura de outra chave, rotação com duas chaves, assinatura truncada, troca do `tid` no payload, outro emissor, expiração com 60 s de tolerância e token de contato no lugar do da equipe.

Limitação da primeira rodada: o PostgreSQL embutido não traz `btree_gist` nem `pg_trgm`, então ela usou uma variante do schema sem as 6 restrições `EXCLUDE` e sem os índices trigram. A segunda rodada eliminou essa limitação.

### 3.1 Segunda rodada: PostgreSQL 18.1 do compose, schema completo, Keycloak

Ambiente de [infra/local](../../infra/local/README.md) no Docker Desktop (Windows 11, WSL 2 com 4 GB). Banco recriado do zero: papéis de login, migração do dbmate aplicada duas vezes (a segunda não faz nada), seed duas vezes, migrações do Serverpod pelo [script de conferência](../../tool/db/apply_pod_migrations.sh). 85 tabelas com RLS FORCE e as extensões `btree_gist` e `pg_trgm`.

**Resultado: 13 de 13 testes de ponta a ponta passaram**: os 8 acima e os 5 do [login pelo Keycloak](../../server/test/e2e/keycloak_exchange_e2e_test.dart):

| Cenário | Resultado |
|---|---|
| Token RS256 do Keycloak → `auth.exchangeIdpToken('frio-sul')` → token ES256 de 10 min → `me.get` no tenant certo | ✔ |
| Mesmo login pedindo o tenant de outra empresa, ou um slug inexistente → `FORBIDDEN` idêntico | ✔ |
| Usuário em dois tenants troca de tenant com o mesmo token do IdP | ✔ |
| App do técnico: despachante entra; administradora sem papel de campo → `FORBIDDEN` | ✔ |
| Token do Keycloak usado direto num endpoint da equipe → recusado (só vale o token da plataforma) | ✔ |

**Custo do escopo por tenant** (meta < 2 ms): 2.000 execuções por cenário como `app_api`, comparando a consulta avulsa com `BEGIN` + `set_config` (4 valores) + consulta + `COMMIT`, que é o que o interceptor faz:

| | p50 | p95 | p99 |
|---|---|---|---|
| Consulta avulsa | 1,171 ms | 3,434 ms | 5,344 ms |
| Com o escopo do tenant | 2,126 ms | 5,316 ms | 8,405 ms |
| **Custo do escopo** | **+0,96 ms** | **+1,88 ms** | |

Dentro da meta, mas o p95 está perto do limite. O custo são três idas e voltas a mais (`BEGIN`, `set_config`, `COMMIT`), e a medição passou pela rede do Docker Desktop, que é lenta por ida e volta. Repetir em homologação, com a api na mesma rede do banco. Se passar da meta, mandar `BEGIN` e `set_config` numa só ida (pipeline do driver), em vez de afrouxar o escopo.

## 4. Decisões e achados

| # | Achado | Decisão |
|---|---|---|
| 1 | `DatabaseInterceptor` é `Database Function(Session, Database inner)`, chamado uma vez por sessão; `Database` não pode ser estendida, só implementada (24 métodos + 3 getters) | Implementação completa com delegação; cada método passa por `_scoped()`. A versão do Serverpod fica fixada (4.1.1) porque a interface pode mudar numa minor |
| 2 | O ORM usa `session.transaction` quando não recebe transação (o `serverpod_test` usa isso) | O interceptor reaproveita a transação existente e aplica o contexto nela uma vez (`Expando` por transação) |
| 3 | `watch`/`unsafeWatch` não aceitam transação (e no PostgreSQL ainda lançam `UnsupportedError`) | Bloqueados em sessões com contexto; tempo real continua por avisos de invalidação |
| 4 | Sessões internas do Serverpod (`InternalSession`, `FutureCallSession`) também passam pelo interceptor | Sem contexto, passam direto (a RLS fecha); com contexto, mesma regra. Endpoint, stream ou rota web sem contexto → `MissingRequestContextError` |
| 5 | `session.authenticated` é síncrono no 4.1 e o handler recebe a própria sessão | O contexto é anexado à `Session` por `Expando` no handler |
| 6 | Todo método público de uma classe de endpoint vira RPC (o gerador recusa helpers `void`) | Helpers ficam em extensões ou em `internal/` |
| 7 | `searchPaths` do Serverpod é texto separado por vírgula (`app, public`), não lista YAML | Configurado assim em `config/*.yaml` |
| 8 | As migrações do Serverpod criam `serverpod_*` sem schema qualificado | Aplicadas por `app_pod_migrator` (`search_path = public`), com privilégios padrão de DML para `app_runtime` |
| 9 | Biblioteca JOSE | `dart_jsonwebtoken` 3.4.1. Ela lê o `alg` do cabeçalho, então o serviço confere `alg`, `kid` e `typ` **antes** de validar a assinatura. Chaves do Keycloak pelo `x5c` da JWKS |
| 10 | O `schema.sql` executa `SET search_path = app, …`, e o dbmate resolve a tabela de controle pelo schema corrente: a migração era aplicada, mas **não ficava registrada** | dbmate sempre com `--migrations-table public.schema_migrations`. O CI roda `dbmate status --exit-code` logo depois do `up` ([db/migrations/README.md](../../db/migrations/README.md)) |
| 11 | `--role maintenance --apply-migrations` sai com 1 quando a verificação de integridade acusa diferença. Neste projeto ela sempre acusa: `app_pod_migrator` não enxerga as colunas de `app`, e o Serverpod não conhece `timestamptz` | O código de saída não é usado. [apply_pod_migrations.sh](../../tool/db/apply_pod_migrations.sh) falha se o log tiver erro de aplicação ou se a última versão do `migration_registry.txt` não estiver em `public.serverpod_migrations` |
| 12 | No Keycloak 26, um cliente que declara `optionalClientScopes` sem `defaultClientScopes` fica sem o escopo `basic`, e o token sai **sem `sub`** (o verificador recusa, corretamente) | Os clientes declaram `defaultClientScopes` explicitamente. Vale também para o realm de produção |
| 13 | A MinIO parou de publicar as imagens da edição comunitária (`minio/minio` não existe mais no Docker Hub) | Ambiente local usa RustFS 1.0 (Apache 2.0, compatível com S3). O código continua falando S3 com endpoint configurável (docs/09 §1) |

## 5. Primeiros achados do S2

| Item | Situação |
|---|---|
| `uuid` com `UuidValue`, enums `byName`, `column=` para snake_case, `managedMigration: false` | ✔ funcionam no ORM (`Tenant`, `TenantMembership`, `TenantMembershipRole`, `AppUser`) |
| `UuidValue` como parâmetro de SQL próprio | ✘ o driver não infere o tipo. **Regra:** passar `.uuid` (texto) com cast explícito `@id::uuid` |
| `timestamptz` × `DateTime` | ⚠ O Serverpod 4.1 só mapeia `DateTime` para `timestamp without time zone`; `timestamptz` aparece como `unknown` na verificação de integridade, que não pode ser desligada para tabelas não gerenciadas. Na api e no worker é só um aviso na inicialização (achado 11 para o modo de migração). **Mantemos `timestamptz`** (decisão do schema). A leitura e a gravação em UTC ainda precisam de teste no S2 |
| `bigint` em centavos, `jsonb`, CHECKs de texto, CRUD completo de `work_orders` e `work_order_items` | Pendente (etapa 4) |

## 6. Próximos passos

1. Primeira execução do CI, assim que o repositório tiver remoto.
2. Repetir a medição do custo do escopo em homologação.
3. Fechar o S2 com `work_orders`/`work_order_items` (centavos, milésimos, `jsonb`, `timestamptz`).
4. Lista de revogação no Valkey (hoje em memória) e `deviceProof` do app do técnico.
