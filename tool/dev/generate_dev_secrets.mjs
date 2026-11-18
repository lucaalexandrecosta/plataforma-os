// Gera server/config/passwords.yaml para desenvolvimento e testes locais:
// senha dos usuários do banco local ("dev"), chave ES256 de assinatura dos
// tokens próprios, o emissor da api e os segredos do login por e-mail e senha.
//
// O arquivo é ignorado pelo Git (.gitignore). Em homologação e produção os
// mesmos nomes vêm do cofre como variáveis SERVERPOD_PASSWORD_<nome>.
//
// Uso: node tool/dev/generate_dev_secrets.mjs [--force]
import crypto from 'node:crypto'
import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..')
const target = path.join(root, 'server', 'config', 'passwords.yaml')

if (fs.existsSync(target) && !process.argv.includes('--force')) {
  console.log(`${path.relative(root, target)} já existe (use --force para recriar).`)
  process.exit(0)
}

const { privateKey, publicKey } = crypto.generateKeyPairSync('ec', { namedCurve: 'P-256' })
const priv = privateKey.export({ type: 'pkcs8', format: 'pem' }).trim()
const pub = publicKey.export({ type: 'spki', format: 'pem' }).trim()
const indent = (pem) => pem.split('\n').map((l) => '    ' + l).join('\n')
const secret = () => crypto.randomBytes(24).toString('base64url')
const kid = 'dev-' + new Date().toISOString().slice(0, 10)

const yaml = `# GERADO por tool/dev/generate_dev_secrets.mjs — só para desenvolvimento.
# Nunca versionar. Em homologação/produção: cofre (SERVERPOD_PASSWORD_<nome>).
shared:
  tokenSigningKeyId: '${kid}'
  tokenSigningPrivateKey: |
${indent(priv)}
  tokenSigningPublicKey: |
${indent(pub)}
  # Login por e-mail e senha (módulo serverpod_auth_idp).
  emailSecretHashPepper: '${secret()}'
  jwtRefreshTokenHashPepper: '${secret()}'
  jwtHmacSha512PrivateKey: '${crypto.randomBytes(64).toString('base64url')}'

development:
  database: 'dev'
  redis: ''
  serviceSecret: '${secret()}'
  tokenIssuer: 'http://localhost:8080'
  # Object storage local (RustFS do infra/local/compose.yaml).
  s3Endpoint: 'http://localhost:9000'
  s3Bucket: 'plataforma-os-dev'
  s3AccessKey: 's3-dev'
  s3SecretKey: 's3-dev-password'

test:
  database: 'dev'
  redis: ''
  serviceSecret: '${secret()}'
  tokenIssuer: 'http://localhost:9080'
  s3Endpoint: 'http://localhost:9000'
  s3Bucket: 'plataforma-os-test'
  s3AccessKey: 's3-dev'
  s3SecretKey: 's3-dev-password'
`

fs.writeFileSync(target, yaml)
console.log(`gerado: ${path.relative(root, target)} (kid ${kid})`)
