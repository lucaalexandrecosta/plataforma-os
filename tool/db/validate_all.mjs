// Roda toda a validação do banco localmente e no CI, sem Docker:
//   1. migração inicial confere com db/schema.sql;
//   2. schema.sql + checagens estruturais + testes funcionais (db/validacao);
//   3. migração inicial + seed de desenvolvimento + isolamento com os dados do seed.
// Instala o PGlite em ./.pglite na primeira execução.
import { execFileSync } from 'node:child_process'
import fs from 'node:fs'
import path from 'node:path'
import { fileURLToPath } from 'node:url'

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), '..', '..')
const pglite = path.join(root, '.pglite', 'node_modules', '@electric-sql', 'pglite')
const run = (args) => execFileSync(process.execPath, args, { cwd: root, encoding: 'utf8' })

if (!fs.existsSync(pglite)) {
  console.log('instalando @electric-sql/pglite@0.5.8 em ./.pglite ...')
  const npm = process.platform === 'win32' ? 'npm.cmd' : 'npm'
  execFileSync(npm, ['install', '--prefix', './.pglite', '@electric-sql/pglite@0.5.8'], { cwd: root, stdio: 'inherit', shell: process.platform === 'win32' })
}

let failed = false
const step = (title, args, okPattern) => {
  console.log(`\n=== ${title}`)
  try {
    const out = run(args)
    process.stdout.write(out)
    if (okPattern && !okPattern.test(out)) { failed = true; console.log(`>>> FALHOU: saída não contém ${okPattern}`) }
  } catch (e) {
    failed = true
    process.stdout.write(e.stdout || '')
    process.stderr.write(e.stderr || '')
  }
}

step('migração inicial x schema.sql', ['tool/db/build_initial_migration.mjs', '--check'])
step('schema.sql: estrutura + testes funcionais',
  ['db/validacao/validate-schema.mjs', pglite, 'db/schema.sql', 'db/validacao/schema-tests.mjs'],
  /\[RLS\][^\n]*: 0\n[\s\S]*\[FK\][^\n]*: 0 [\s\S]*\[TESTES FUNCIONAIS\] \d+ passaram, 0 falharam/)
step('migração inicial + seed de desenvolvimento',
  ['db/validacao/validate-seed.mjs', pglite, 'db/migrations/20261107000000_initial_schema.sql', 'db/seeds/dev_seed.sql'])

console.log(failed ? '\nVALIDAÇÃO DO BANCO: FALHOU' : '\nVALIDAÇÃO DO BANCO: OK')
process.exit(failed ? 1 : 0)
