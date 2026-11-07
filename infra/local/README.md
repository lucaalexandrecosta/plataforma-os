# Ambiente local

Sobe PostgreSQL 18 (dev na porta 5434 e teste na 5433), Valkey, Keycloak (8180), S3 local (RustFS: API 9000, console 9001, usuário `s3-dev` / senha `s3-dev-password`) e Mailpit (8025).

> O PostgreSQL de dev usa a porta **5434** (e não a padrão 5432) para não conflitar com um PostgreSQL já instalado na máquina. Para mudar, altere a porta publicada de `postgres` no `compose.yaml` e `database.port` em `server/config/development.yaml`.

## 1. Subir os serviços

```bash
docker compose -f infra/local/compose.yaml up -d
```

O container do PostgreSQL cria, na primeira inicialização, os usuários de login (`app_api`, `app_worker`, `app_migrator`, `app_pod_migrator`, senha `dev`) a partir de [postgres/10-login-roles.sql](postgres/10-login-roles.sql).

## 2. Banco: migração inicial e seed

```bash
# dbmate pelo container oficial (Docker Desktop: o host é host.docker.internal; no Linux use --network host e localhost)
docker run --rm -v "$PWD/db:/db" ghcr.io/amacneil/dbmate:2.28 \
  --url "postgres://postgres:postgres@host.docker.internal:5434/plataforma_os?sslmode=disable" \
  --migrations-dir /db/migrations --migrations-table public.schema_migrations --no-dump-schema up

# dois tenants fictícios (frio-sul e forno-norte)
docker compose -f infra/local/compose.yaml exec -T postgres \
  psql -v ON_ERROR_STOP=1 -U postgres -d plataforma_os < db/seeds/dev_seed.sql
```

Para recriar do zero: `docker compose -f infra/local/compose.yaml down -v` e repetir.

## 3. Servidor

Veja [server/README.md](../../server/README.md): segredos de dev, migrações internas do Serverpod e `--role monolith`.

## Usuários do Keycloak (realm `staff`, senha `dev`)

| Usuário | Tenant e papel |
|---|---|
| `ana.admin@frio-sul.test` | frio-sul · tenant_admin |
| `bruno.despacho@frio-sul.test` | frio-sul · dispatcher |
| `carla.admin@forno-norte.test` | forno-norte · tenant_admin |
| `davi.consultor@dev.test` | manager nos dois (troca de tenant) |

Clientes OIDC: `backoffice-web` e `technician-app` (públicos, PKCE S256). Para obter um token rapidamente em dev (grant de senha, **só local**):

```bash
curl -s -d grant_type=password -d client_id=backoffice-web \
  -d username=ana.admin@frio-sul.test -d password=dev \
  http://localhost:8180/realms/staff/protocol/openid-connect/token
```

O `access_token` devolvido é o `idpToken` de `auth.exchangeIdpToken(idpToken, 'frio-sul')`.
