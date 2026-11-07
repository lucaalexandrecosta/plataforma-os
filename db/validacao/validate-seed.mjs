// Valida a migração inicial do dbmate + o seed de desenvolvimento num PostgreSQL
// real (PGlite / PostgreSQL 18), e confere o isolamento com os dados do seed.
// Uso: node validate-seed.mjs <pglite-dir> <migração inicial.sql> <seed.sql>
import { pathToFileURL } from 'node:url'
import path from 'node:path'
import fs from 'node:fs'

const [pkgDir, migrationPath, seedPath] = process.argv.slice(2)
const imp = (rel) => import(pathToFileURL(path.join(pkgDir, rel)).href)
const { PGlite } = await imp('dist/index.js')
const extensions = {}
for (const name of ['pg_trgm', 'btree_gist']) {
  const m = await imp(`dist/contrib/${name}.js`)
  extensions[name] = m[name]
}
const db = await PGlite.create({ extensions })
const q = async (text, params) => (await db.query(text, params)).rows

// Só a seção "up" da migração (o dbmate executa assim).
const migration = fs.readFileSync(migrationPath, 'utf8')
const up = migration.split(/^-- migrate:down/m)[0].replace(/^-- migrate:up.*$/m, '')
const seed = fs.readFileSync(seedPath, 'utf8')

let pass = 0, fail = 0
const t = async (name, fn) => {
  await db.exec('reset role; reset all;').catch(() => {})
  try { await fn(); pass++; console.log(`  PASS ${name}`) } catch (e) {
    fail++; console.log(`  FAIL ${name}: ${e.message}`)
    await db.exec('ROLLBACK').catch(() => {})
  }
  await db.exec('reset role; reset all;').catch(() => {})
}
const assert = (cond, msg) => { if (!cond) throw new Error(msg) }

const A = '0197f000-0001-7000-8000-000000000001'
const B = '0197f000-0002-7000-8000-000000000002'
const DAVI = '0197f000-0100-7000-8000-000000000004'
const ANA = '0197f000-0100-7000-8000-000000000001'

await t('migração inicial executa num banco vazio', async () => { await db.exec(up) })
await t('seed executa', async () => { await db.exec(seed) })
await t('seed é idempotente (segunda execução não falha nem duplica)', async () => {
  await db.exec(seed)
  const [{ n }] = await q(`select count(*)::int as n from app.tenants`)
  assert(n === 2, `esperava 2 tenants, veio ${n}`)
})

const asRuntime = async (tenantId, userId) => {
  await db.exec('set role app_runtime;')
  await q(`select set_config('app.tenant_id', $1, false), set_config('app.user_id', $2, false)`, [tenantId || '', userId || ''])
}

await t('RLS: tenant A vê só os próprios clientes, ativos e etiquetas', async () => {
  await asRuntime(A, ANA)
  const c = await q(`select tenant_id from app.customers`)
  const a = await q(`select tenant_id from app.assets`)
  const g = await q(`select tenant_id from app.qr_tags`)
  assert(c.length === 2 && c.every(r => r.tenant_id === A), `clientes: ${JSON.stringify(c)}`)
  assert(a.length === 2 && a.every(r => r.tenant_id === A), `ativos: ${JSON.stringify(a)}`)
  assert(g.length === 2 && g.every(r => r.tenant_id === A), `etiquetas: ${JSON.stringify(g)}`)
})

await t('RLS: tenant B vê só os próprios dados', async () => {
  await asRuntime(B, null)
  const c = await q(`select tenant_id from app.customers`)
  assert(c.length === 1 && c[0].tenant_id === B, `clientes: ${JSON.stringify(c)}`)
})

await t('RLS: sem app.tenant_id nada de tenant é visível (falha fechada)', async () => {
  await asRuntime(null, null)
  for (const tbl of ['customers', 'assets', 'qr_tags', 'branches', 'tenant_settings', 'tenant_memberships']) {
    const r = await q(`select 1 from app.${tbl}`)
    assert(r.length === 0, `${tbl}: ${r.length} linhas sem tenant`)
  }
})

await t('RLS: tenant A não insere linha com tenant_id de B', async () => {
  await asRuntime(A, ANA)
  try {
    await q(`insert into app.customers (tenant_id, name, document_type) values ($1, 'Intruso', 'none')`, [B])
  } catch (e) {
    assert(/row-level security/i.test(e.message), `mensagem inesperada: ${e.message}`)
    return
  }
  throw new Error('insert com tenant de outro tenant deveria falhar')
})

await t('troca de tenant: usuário em dois tenants lê os próprios vínculos antes de escolher', async () => {
  await asRuntime(null, DAVI)
  const m = await q(`select tenant_id from app.tenant_memberships order by tenant_id`)
  assert(m.length === 2 && m[0].tenant_id === A && m[1].tenant_id === B, `vínculos: ${JSON.stringify(m)}`)
  const r = await q(`select role_code from app.tenant_membership_roles`)
  assert(r.length === 2 && r.every(x => x.role_code === 'manager'), `papéis: ${JSON.stringify(r)}`)
  const tn = await q(`select slug from app.tenants order by slug`)
  assert(tn.length === 2, `tenants visíveis: ${JSON.stringify(tn)}`)
})

await t('troca de tenant: usuário de um tenant só não enxerga o outro', async () => {
  await asRuntime(null, ANA)
  const tn = await q(`select slug from app.tenants`)
  assert(tn.length === 1 && tn[0].slug === 'frio-sul', `tenants visíveis: ${JSON.stringify(tn)}`)
})

await t('login da equipe: find_user_by_idp_subject resolve o sub do Keycloak', async () => {
  await asRuntime(null, null)
  const r = await q(`select user_id, status from app.find_user_by_idp_subject($1)`, ['7d0a0001-0000-4000-8000-000000000004'])
  assert(r.length === 1 && r[0].user_id === DAVI && r[0].status === 'active', JSON.stringify(r))
})

await t('QR do seed: short code válido resolve o tenant certo', async () => {
  const [{ sc }] = await q(`select short_code as sc from app.qr_tags where id = '0197f000-0002-7700-8000-000000000001'`)
  await asRuntime(null, null)
  const r = await q(`select tenant_id from public.resolve_qr_short_code($1)`, [sc.slice(0, 4) + '-' + sc.slice(4).toLowerCase()])
  assert(r.length === 1 && r[0].tenant_id === B, JSON.stringify(r))
})

await t('permissões efetivas do tenant_admin vêm do seed global', async () => {
  await asRuntime(A, ANA)
  const r = await q(`select count(distinct p.code)::int as n
                       from app.tenant_membership_roles mr
                       join app.roles ro on ro.code = mr.role_code
                       join app.role_permissions rp on rp.role_id = ro.id
                       join app.permissions p on p.id = rp.permission_id
                      where mr.membership_id = '0197f000-0001-7200-8000-000000000001'`)
  assert(r[0].n >= 25, `tenant_admin com ${r[0].n} permissões`)
})

console.log(`\n[SEED] ${pass} passaram, ${fail} falharam`)
await db.close()
process.exit(fail ? 1 : 0)
