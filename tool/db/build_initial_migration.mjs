// Gera db/migrations/<ts>_initial_schema.sql (dbmate) a partir de db/schema.sql.
//
// A migração inicial é derivada do schema de referência (docs/02 §4.2.2,
// docs/13 §3.2). Depois dela, toda mudança entra por migração nova + atualização
// do schema.sql no mesmo PR.
//
// Uso:
//   node tool/db/build_initial_migration.mjs          # (re)gera o arquivo
//   node tool/db/build_initial_migration.mjs --check  # CI: falha se divergir
import crypto from 'node:crypto'
import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..')
const schemaPath = path.join(root, 'db', 'schema.sql')
const migrationPath = path.join(root, 'db', 'migrations', '20261107000000_initial_schema.sql')

const schema = fs.readFileSync(schemaPath, 'utf8').replace(/\r\n/g, '\n')
const sha = crypto.createHash('sha256').update(schema).digest('hex')

// schema.sql já tem BEGIN/COMMIT próprios (e CREATE ROLE/EXTENSION), por isso
// a migração roda com transaction:false — a transação é a do próprio arquivo.
const content = `-- migrate:up transaction:false
-- =============================================================================
-- Migração inicial — GERADA por tool/db/build_initial_migration.mjs. Não editar.
-- Origem: db/schema.sql (sha256 ${sha})
-- Precisa de um papel administrativo (superusuário em dev/CI; o admin do RDS
-- em homologação e produção), porque cria papéis-grupo e extensões.
-- =============================================================================
${schema.trimEnd()}

-- migrate:down
-- Sem "down": em homologação e produção só se migra para frente
-- (docs/02 §4.2.2). Em desenvolvimento, recrie o banco: infra/local/README.md.
SELECT 1;
`

if (process.argv.includes('--check')) {
  const current = fs.existsSync(migrationPath) ? fs.readFileSync(migrationPath, 'utf8').replace(/\r\n/g, '\n') : ''
  if (current !== content) {
    console.error(`ERRO: ${path.relative(root, migrationPath)} está desatualizada em relação a db/schema.sql.`)
    console.error('Rode: node tool/db/build_initial_migration.mjs')
    process.exit(1)
  }
  console.log('OK: migração inicial confere com db/schema.sql')
} else {
  fs.mkdirSync(path.dirname(migrationPath), { recursive: true })
  fs.writeFileSync(migrationPath, content)
  console.log(`gerado: ${path.relative(root, migrationPath)} (schema.sql sha256 ${sha.slice(0, 12)}…)`)
}
