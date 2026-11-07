// Gera server/config/passwords.yaml para desenvolvimento e testes locais:
// senha dos usuários do banco local ("dev"), chave ES256 de assinatura dos
// tokens próprios e os emissores (api e Keycloak local).
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
  keycloakStaffIssuer: 'http://localhost:8180/realms/staff'

development:
  database: 'dev'
  redis: ''
  serviceSecret: '${secret()}'
  tokenIssuer: 'http://localhost:8080'

test:
  database: 'dev'
  redis: ''
  serviceSecret: '${secret()}'
  tokenIssuer: 'http://localhost:9080'
`

fs.writeFileSync(target, yaml)
console.log(`gerado: ${path.relative(root, target)} (kid ${kid})`)
