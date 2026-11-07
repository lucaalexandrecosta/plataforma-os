// Valida db/schema.sql num PostgreSQL real (PGlite / PostgreSQL 18) e roda checagens
// estruturais de multi-tenancy. Opcionalmente roda um módulo de testes funcionais.
// Uso: node validate-schema.mjs <pglite-dir> <schema.sql> [testes.mjs]
import { pathToFileURL } from 'node:url'
import path from 'node:path'
import fs from 'node:fs'

const [pkgDir, schemaPath, testsPath] = process.argv.slice(2)
const imp = (rel) => import(pathToFileURL(path.join(pkgDir, rel)).href)
const { PGlite } = await imp('dist/index.js')

const wanted = ['pg_trgm', 'btree_gist', 'btree_gin', 'citext', 'pgcrypto', 'uuid_ossp', 'unaccent', 'fuzzystrmatch', 'hstore', 'ltree']
const extensions = {}
for (const name of wanted) {
  try { const m = await imp(`dist/contrib/${name}.js`); if (m[name]) extensions[name] = m[name] } catch { /* indisponível */ }
}
console.log('extensões carregáveis:', Object.keys(extensions).join(', '))

const db = await PGlite.create({ extensions })
const sql = fs.readFileSync(schemaPath, 'utf8')

function context(text, pos) {
  const line = text.slice(0, pos).split('\n').length
  const lines = text.split('\n')
  const from = Math.max(0, line - 12), to = Math.min(lines.length, line + 4)
  return `linha ~${line}\n` + lines.slice(from, to).map((l, i) => `${String(from + i + 1).padStart(5)}| ${l}`).join('\n')
}

try {
  await db.exec(sql)
  console.log('OK: schema.sql executou sem erros')
} catch (e) {
  console.log('ERRO ao executar schema.sql:', e.message)
  for (const k of ['code', 'detail', 'hint', 'where', 'internalQuery', 'schema', 'table', 'column', 'constraint']) if (e[k]) console.log(`  ${k}: ${e[k]}`)
  const pos = Number(e.position || 0)
  if (pos) console.log(context(sql, pos - 1))
  process.exit(1)
}

const q = async (text, params) => (await db.query(text, params)).rows

// ---------- Tabelas, RLS e donos ----------
const tables = await q(`
  select n.nspname as schema, c.relname as name, c.relkind as kind, c.relrowsecurity as rls, c.relforcerowsecurity as force_rls,
         pg_get_userbyid(c.relowner) as owner,
         exists (select 1 from pg_attribute a where a.attrelid = c.oid and a.attname = 'tenant_id' and not a.attisdropped) as has_tenant,
         (select count(*)::int from pg_policy p where p.polrelid = c.oid) as policies
  from pg_class c join pg_namespace n on n.oid = c.relnamespace
  where c.relkind in ('r','p') and n.nspname not in ('pg_catalog','information_schema') and n.nspname not like 'pg\\_%'
  order by 1, 2`)
const tenantTables = tables.filter(t => t.has_tenant)
const globalTables = tables.filter(t => !t.has_tenant)
console.log(`\nTabelas: ${tables.length} (com tenant_id: ${tenantTables.length}; globais: ${globalTables.length})`)
console.log('  globais:', globalTables.map(t => `${t.schema}.${t.name}${t.rls ? ' [rls]' : ''}`).join(', '))
const owners = [...new Set(tables.map(t => t.owner))]
console.log('  donos das tabelas:', owners.join(', '))

const rlsProblems = tenantTables.filter(t => !t.rls || !t.force_rls || t.policies === 0)
console.log(`\n[RLS] tabelas de tenant sem ENABLE+FORCE+política: ${rlsProblems.length}`)
for (const t of rlsProblems) console.log(`  - ${t.schema}.${t.name}: rls=${t.rls} force=${t.force_rls} policies=${t.policies}`)

// ---------- FKs compostas com tenant_id ----------
const fks = await q(`
  select con.conname, cn.nspname || '.' || cl.relname as tbl, fn.nspname || '.' || fcl.relname as ftbl,
    (select array_agg(a.attname::text order by k.ord) from unnest(con.conkey) with ordinality k(attnum, ord)
       join pg_attribute a on a.attrelid = con.conrelid and a.attnum = k.attnum) as cols,
    (select array_agg(a.attname::text order by k.ord) from unnest(con.confkey) with ordinality k(attnum, ord)
       join pg_attribute a on a.attrelid = con.confrelid and a.attnum = k.attnum) as fcols
  from pg_constraint con
  join pg_class cl on cl.oid = con.conrelid join pg_namespace cn on cn.oid = cl.relnamespace
  join pg_class fcl on fcl.oid = con.confrelid join pg_namespace fn on fn.oid = fcl.relnamespace
  where con.contype = 'f'`)
const hasTenant = new Set(tenantTables.map(t => `${t.schema}.${t.name}`))
const badFks = fks.filter(f => hasTenant.has(f.tbl) && hasTenant.has(f.ftbl) && f.ftbl !== 'app.tenants' &&
  !(f.cols.includes('tenant_id') && f.fcols[f.cols.indexOf('tenant_id')] === 'tenant_id'))
console.log(`\n[FK] FKs entre tabelas de tenant sem tenant_id na chave: ${badFks.length} (de ${fks.length} FKs)`)
for (const f of badFks) console.log(`  - ${f.tbl}(${f.cols}) -> ${f.ftbl}(${f.fcols}) [${f.conname}]`)

// ---------- Índices de suporte às FKs (informativo) ----------
const idx = await q(`
  select cn.nspname || '.' || cl.relname as tbl,
    (select array_agg(a.attname::text order by k.ord) from unnest(i.indkey::int2[]) with ordinality k(attnum, ord)
       join pg_attribute a on a.attrelid = i.indrelid and a.attnum = k.attnum) as cols
  from pg_index i join pg_class cl on cl.oid = i.indrelid join pg_namespace cn on cn.oid = cl.relnamespace
  where cn.nspname not in ('pg_catalog','information_schema')`)
const idxBy = new Map()
for (const i of idx) { if (!idxBy.has(i.tbl)) idxBy.set(i.tbl, []); idxBy.get(i.tbl).push(i.cols || []) }
const noIdx = fks.filter(f => !(idxBy.get(f.tbl) || []).some(cols => f.cols.every((c, k) => cols[k] === c) || f.cols.every(c => cols.slice(0, f.cols.length).includes(c))))
console.log(`\n[IDX] FKs sem índice de suporte (informativo): ${noIdx.length}`)
for (const f of noIdx.slice(0, 60)) console.log(`  - ${f.tbl}(${f.cols}) -> ${f.ftbl}`)

// ---------- Papéis ----------
const roles = await q(`select rolname, rolsuper, rolbypassrls, rolcanlogin, rolinherit from pg_roles where rolname not like 'pg\\_%' and rolname <> 'postgres' order by 1`)
console.log('\n[ROLES]', JSON.stringify(roles))
const grants = await q(`select grantee, count(distinct table_schema || '.' || table_name)::int as tables, string_agg(distinct privilege_type, ',') as privs
  from information_schema.role_table_grants where grantee not in ('postgres','PUBLIC') group by grantee order by 1`)
console.log('[GRANTS por papel]', JSON.stringify(grants))
const runtimeRole = roles.find(r => r.rolname === 'app_runtime')
if (runtimeRole) {
  const noGrant = await q(`
    select n.nspname || '.' || c.relname as t from pg_class c join pg_namespace n on n.oid = c.relnamespace
    where c.relkind in ('r','p') and n.nspname not in ('pg_catalog','information_schema') and n.nspname not like 'pg\\_%'
      and not has_table_privilege('app_runtime', c.oid, 'SELECT') order by 1`)
  console.log(`[GRANTS] tabelas sem SELECT para app_runtime: ${noGrant.length}`, noGrant.map(r => r.t).join(', '))
}

// ---------- Funções ----------
const funcs = await q(`
  select n.nspname || '.' || p.proname as fn, p.prosecdef as secdef, p.proconfig as config, pg_get_function_identity_arguments(p.oid) as args
  from pg_proc p join pg_namespace n on n.oid = p.pronamespace
  where n.nspname not in ('pg_catalog','information_schema') and p.prokind = 'f' order by 1`)
console.log(`\n[FUNÇÕES] ${funcs.length}`)
for (const f of funcs) console.log(`  - ${f.fn}(${f.args})${f.secdef ? ' SECURITY DEFINER' : ''}${f.config ? ' ' + JSON.stringify(f.config) : ''}${f.secdef && !(f.config || []).some(c => c.startsWith('search_path')) ? '  <-- SEM search_path FIXO' : ''}`)

// ---------- Triggers e row_version ----------
const trg = await q(`
  select cn.nspname || '.' || cl.relname as tbl, string_agg(t.tgname, ',' order by t.tgname) as triggers
  from pg_trigger t join pg_class cl on cl.oid = t.tgrelid join pg_namespace cn on cn.oid = cl.relnamespace
  where not t.tgisinternal group by 1 order by 1`)
const trgBy = new Map(trg.map(r => [r.tbl, r.triggers]))
const rv = await q(`select table_schema || '.' || table_name as tbl from information_schema.columns where column_name = 'row_version' order by 1`)
console.log(`\n[SYNC] tabelas com row_version: ${rv.length}`)
for (const r of rv) console.log(`  - ${r.tbl}: triggers=${trgBy.get(r.tbl) || '(nenhum)'}`)
const upd = await q(`select table_schema || '.' || table_name as tbl from information_schema.columns where column_name = 'updated_at' order by 1`)
const updNoTrg = upd.filter(r => !(trgBy.get(r.tbl) || '').match(/updated|touch|audit|row_version|stamp/i))
console.log(`[TRIGGERS] tabelas com updated_at sem trigger aparente: ${updNoTrg.length}`, updNoTrg.map(r => r.tbl).join(', '))

// ---------- Testes funcionais opcionais ----------
if (testsPath) {
  const mod = await import(pathToFileURL(path.resolve(testsPath)).href)
  let pass = 0, fail = 0
  const results = []
  const t = async (name, fn) => {
    await db.exec('reset role; reset all;')
    try { await fn(); pass++; results.push(`  PASS ${name}`) } catch (e) { fail++; results.push(`  FAIL ${name}: ${e.message}`) }
    await db.exec('reset role; reset all;').catch(() => {})
  }
  await mod.run({ db, q, t })
  console.log(`\n[TESTES FUNCIONAIS] ${pass} passaram, ${fail} falharam`)
  console.log(results.join('\n'))
}
await db.close()
