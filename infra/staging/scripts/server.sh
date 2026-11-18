#!/bin/sh
# Servidor (api + worker num processo só, como em desenvolvimento).
set -eu
/app/scripts/segredos.sh
exec /app/bin/main --mode staging --role monolith "$@"
