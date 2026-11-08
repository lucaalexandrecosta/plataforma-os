#!/usr/bin/env bash
# Recria do zero os bancos do compose local (dev na 5434, teste na 5433):
# papéis de login (init do container), migração do dbmate, seed e migrações
# internas do Serverpod. Use depois de mudar o schema.sql ou o seed.
#
# Uso (na raiz, Git Bash no Windows): bash tool/dev/reset_local_db.sh [dev|test|all]
set -euo pipefail

target="${1:-all}"
root="$(cd "$(dirname "$0")/../.." && pwd)"
cd "$root"
compose=(docker compose -f infra/local/compose.yaml)
# Caminho do diretório db para o volume do container (Git Bash no Windows usa pwd -W).
dbdir="$(pwd -W 2>/dev/null || pwd)/db"
export MSYS_NO_PATHCONV=1

node tool/dev/generate_dev_secrets.mjs

reset_one() {
  local service="$1" port="$2" database="$3" mode="$4"
  echo "== $database ($service, porta $port)"
  "${compose[@]}" rm -sfv "$service" >/dev/null 2>&1 || true
  if [ "$service" = "postgres" ]; then docker volume rm -f plataforma-os_pgdata >/dev/null; fi
  "${compose[@]}" up -d --wait "$service" >/dev/null
  docker run --rm -v "$dbdir:/db" ghcr.io/amacneil/dbmate:2.28 \
    --url "postgres://postgres:postgres@host.docker.internal:$port/$database?sslmode=disable" \
    --migrations-dir /db/migrations --migrations-table public.schema_migrations --no-dump-schema up
  "${compose[@]}" exec -T "$service" psql -q -v ON_ERROR_STOP=1 -U postgres -d "$database" < db/seeds/dev_seed.sql >/dev/null
  echo "seed aplicado"
  PSQL="${compose[*]} exec -T $service psql -U postgres -d $database" \
    bash tool/db/apply_pod_migrations.sh "$mode" | tail -n 1
}

case "$target" in
  dev) reset_one postgres 5434 plataforma_os development ;;
  test) reset_one postgres-test 5433 plataforma_os_test test ;;
  all)
    reset_one postgres 5434 plataforma_os development
    reset_one postgres-test 5433 plataforma_os_test test
    ;;
  *) echo "uso: $0 [dev|test|all]" >&2; exit 2 ;;
esac
