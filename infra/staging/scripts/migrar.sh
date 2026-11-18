#!/bin/sh
# Prepara o banco antes do servidor subir (serviço "migrar" do compose):
#   1. usuários de login do banco, com a senha do .env;
#   2. migrações do schema "app" (dbmate, como no CI);
#   3. migrações internas do Serverpod (tabelas serverpod_* em "public"),
#      conferidas pelo banco (ver tool/db/apply_pod_migrations.sh);
#   4. opcional: empresas fictícias (CARREGAR_DEMO=sim) e a primeira empresa
#      de verdade (EMPRESA_SLUG + ADMIN_EMAIL).
# Idempotente: roda a cada "docker compose up".
set -eu

: "${PGPASSWORD:?POSTGRES_PASSWORD ausente no .env}"
: "${SERVERPOD_DATABASE_PASSWORD:?APP_DB_PASSWORD ausente no .env}"
for s in "$PGPASSWORD" "$SERVERPOD_DATABASE_PASSWORD"; do
  case "$s" in
    *[!A-Za-z0-9_-]*) echo "As senhas do banco no .env só podem ter letras, números, - e _." >&2; exit 1 ;;
  esac
done

/app/scripts/segredos.sh

echo "migrar: aguardando o PostgreSQL"
i=0
until pg_isready -q; do
  i=$((i + 1)); [ "$i" -gt 60 ] && { echo "PostgreSQL não respondeu." >&2; exit 1; }
  sleep 1
done

PSQL="psql -v ON_ERROR_STOP=1 -q"

echo "migrar: usuários de login"
$PSQL -f /app/db/10-login-roles.sql
for role in app_api app_worker app_migrator app_pod_migrator; do
  $PSQL -v role="$role" -v pw="$SERVERPOD_DATABASE_PASSWORD" <<'SQL'
ALTER ROLE :"role" PASSWORD :'pw';
SQL
done

echo "migrar: schema app (dbmate)"
url="postgres://$PGUSER:$PGPASSWORD@$PGHOST:${PGPORT:-5432}/$PGDATABASE?sslmode=disable"
# Tabela de controle qualificada: o schema.sql troca o search_path no meio.
dbmate --url "$url" --migrations-dir /app/db/migrations --migrations-table public.schema_migrations \
  --no-dump-schema --wait up
dbmate --url "$url" --migrations-dir /app/db/migrations --migrations-table public.schema_migrations \
  --no-dump-schema status --exit-code >/dev/null

echo "migrar: tabelas internas do Serverpod"
esperada="$(grep -v '^#' /app/migrations/migration_registry.txt | sed '/^[[:space:]]*$/d' | tail -n 1 | tr -d '\r')"
log="$(mktemp)"
SERVERPOD_DATABASE_USER=app_pod_migrator SERVERPOD_DATABASE_SEARCH_PATHS=public \
  /app/bin/main --mode staging --role maintenance --apply-migrations >"$log" 2>&1 || true
if grep -Eq 'Failed to apply database migrations|Error initializing Serverpod|Unhandled exception' "$log"; then
  cat "$log"
  echo "FALHOU: o Serverpod não conseguiu aplicar as migrações." >&2
  exit 1
fi
aplicada="$($PSQL -tAc "SELECT version FROM public.serverpod_migrations WHERE module = 'plataforma_os'" | tr -d '\r[:space:]')"
if [ "$aplicada" != "$esperada" ]; then
  cat "$log"
  echo "FALHOU: versão registrada '$aplicada', esperada '$esperada'." >&2
  exit 1
fi
rm -f "$log"

case "${CARREGAR_DEMO:-nao}" in
  sim|true|1)
    echo "migrar: empresas fictícias (frio-sul e forno-norte)"
    $PSQL -f /app/db/seeds/dev_seed.sql >/dev/null
    ;;
esac

if [ -n "${EMPRESA_SLUG:-}" ] && [ -n "${ADMIN_EMAIL:-}" ]; then
  echo "migrar: primeira empresa ($EMPRESA_SLUG, administrador $ADMIN_EMAIL)"
  $PSQL -v slug="$EMPRESA_SLUG" -v nome="${EMPRESA_NOME:-$EMPRESA_SLUG}" -v cnpj="${EMPRESA_CNPJ:-}" \
    -v admin_email="$ADMIN_EMAIL" -v admin_nome="${ADMIN_NOME:-Administrador}" \
    -f /app/bootstrap/primeira-empresa.sql >/dev/null
fi

echo "migrar: pronto"
