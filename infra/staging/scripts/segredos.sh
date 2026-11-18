#!/bin/sh
# Gera, no primeiro boot, as chaves que o servidor assina e confere (ES256 dos
# tokens do tenant e segredos do login) em /segredos/passwords.yaml, um volume
# do compose: sobrevivem a recriar os containers. Apagar o volume troca as
# chaves e derruba todas as sessões. Idempotente.
set -eu
alvo=/segredos/passwords.yaml
[ -s "$alvo" ] && exit 0

umask 077
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
openssl ecparam -name prime256v1 -genkey -noout -out "$tmp/ec.pem"
openssl pkcs8 -topk8 -nocrypt -in "$tmp/ec.pem" -out "$tmp/priv.pem"
openssl ec -in "$tmp/ec.pem" -pubout -out "$tmp/pub.pem" 2>/dev/null
segredo() { openssl rand -base64 "$1" | tr -d '\n=' | tr '+/' '-_'; }
recuar() { sed 's/^/    /' "$1"; }

{
  echo "# GERADO no primeiro boot por scripts/segredos.sh (infra/staging)."
  echo "shared:"
  echo "  tokenSigningKeyId: 'stg-$(date -u +%Y%m%d)'"
  echo "  tokenSigningPrivateKey: |"
  recuar "$tmp/priv.pem"
  echo "  tokenSigningPublicKey: |"
  recuar "$tmp/pub.pem"
  echo "  emailSecretHashPepper: '$(segredo 24)'"
  echo "  jwtRefreshTokenHashPepper: '$(segredo 24)'"
  echo "  jwtHmacSha512PrivateKey: '$(segredo 64)'"
  echo "staging:"
  echo "  serviceSecret: '$(segredo 24)'"
} >"$tmp/passwords.yaml"
mv "$tmp/passwords.yaml" "$alvo"
echo "segredos: chaves novas geradas em $alvo"
