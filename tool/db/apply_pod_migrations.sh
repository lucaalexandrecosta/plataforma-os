#!/usr/bin/env bash
# Aplica as migrações internas do Serverpod (tabelas serverpod_* em "public")
# com o papel app_pod_migrator e confere o resultado pelo banco.
#
# Por que não basta o código de saída: depois de migrar, o Serverpod 4.1 compara
# os modelos com o banco e sai com 1 se houver diferença. Neste projeto ela
# sempre existe, por dois motivos esperados (docs/spikes/S1-S2-serverpod-rls.md):
#   1. app_pod_migrator não tem privilégio nas tabelas de "app", então o
#      information_schema não mostra as colunas delas ("Missing Column");
#   2. o Serverpod 4.1 só conhece "timestamp without time zone" e o schema usa
#      timestamptz em toda data/hora ("found unknown").
# A conferência real é: nenhuma falha de aplicação no log e a última versão do
# migration_registry.txt registrada em public.serverpod_migrations.
#
# Uso (na raiz do repositório):
#   PSQL="psql -h localhost -p 5433 -U postgres -d plataforma_os_test" tool/db/apply_pod_migrations.sh test
#   PSQL="docker compose -f infra/local/compose.yaml exec -T postgres psql -U postgres -d plataforma_os" \
#     tool/db/apply_pod_migrations.sh development
set -uo pipefail

mode="${1:-development}"
: "${PSQL:?defina PSQL com o comando psql do banco alvo}"
root="$(cd "$(dirname "$0")/../.." && pwd)"
log="$(mktemp)"
trap 'rm -f "$log"' EXIT

expected="$(grep -v '^#' "$root/server/migrations/migration_registry.txt" | sed '/^[[:space:]]*$/d' | tail -n 1 | tr -d '\r')"
if [ -z "$expected" ]; then
  echo "migration_registry.txt sem versões" >&2
  exit 1
fi

(
  cd "$root/server" &&
    SERVERPOD_DATABASE_USER=app_pod_migrator SERVERPOD_DATABASE_SEARCH_PATHS=public \
      dart bin/main.dart --mode "$mode" --role maintenance --apply-migrations
) >"$log" 2>&1
status=$?
cat "$log"

if grep -Eq 'Failed to apply database migrations|Error initializing Serverpod|Unhandled exception' "$log"; then
  echo "FALHOU: o Serverpod não conseguiu aplicar as migrações (ver log acima)." >&2
  exit 1
fi

applied="$($PSQL -tAc "SELECT version FROM public.serverpod_migrations WHERE module = 'plataforma_os'" | tr -d '\r[:space:]')"
if [ "$applied" != "$expected" ]; then
  echo "FALHOU: versão registrada '$applied', esperada '$expected'." >&2
  exit 1
fi

if [ "$status" -ne 0 ]; then
  echo "OK: migração $expected registrada (a saída $status vem da verificação de integridade; diferenças esperadas, ver cabeçalho)."
else
  echo "OK: migração $expected registrada."
fi
