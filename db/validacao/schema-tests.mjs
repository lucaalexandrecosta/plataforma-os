// Testes funcionais do db/schema.sql (v0.3: tipos compatíveis com o ORM do
// Serverpod — dinheiro em centavos e quantidade em milésimos, bigint; medidas em
// double precision). Inclui a regressão completa da v0.1 e da v0.2.
// Carregado por validate-schema.mjs:
//   node validate-schema.mjs <pglite-dir> <schema.sql> schema-tests.mjs
// Cada teste roda com "reset role; reset all" antes e depois (feito pelo validador).
// A preparação roda como superusuário (ignora RLS); os testes de isolamento fazem
// SET ROLE app_runtime + app.tenant_id.

export async function run({ db, q, t }) {
  const assert = (cond, msg) => { if (!cond) throw new Error(msg) }
  const setTenant = (id) => q(`select set_config('app.tenant_id', $1, false)`, [id])
  const fails = async (fn, re, label) => {
    try { await fn() } catch (e) {
      await db.exec('ROLLBACK').catch(() => {})
      if (re && !re.test(e.message)) throw new Error(`${label}: falhou com a mensagem errada: ${e.message}`)
      return
    }
    throw new Error(`${label}: deveria ter falhado`)
  }
  const tx = async (sql) => {
    try { await db.exec(`BEGIN; ${sql}; COMMIT;`) } catch (e) { await db.exec('ROLLBACK').catch(() => {}); throw e }
  }
  const one = async (text, params) => (await q(text, params))[0]

  // Tenant mínimo: settings, cliente, duas unidades, produto, ativo em estoque, tipo de OS.
  async function mkTenant() {
    const slug = 't' + Math.random().toString(36).slice(2, 10)
    const tn = await one(`insert into app.tenants (slug, legal_name, display_name, plan_id)
                          select $1, $1, $1, id from app.plans where code = 'starter' returning id`, [slug])
    await setTenant(tn.id)
    await q(`insert into app.tenant_settings (tenant_id) values ($1)`, [tn.id])
    const cu = await one(`insert into app.customers (tenant_id, name, document_type) values ($1, 'Cliente', 'none') returning id`, [tn.id])
    const s1 = await one(`insert into app.customer_sites (tenant_id, customer_id, name) values ($1, $2, 'Centro') returning id`, [tn.id, cu.id])
    const s2 = await one(`insert into app.customer_sites (tenant_id, customer_id, name) values ($1, $2, 'Norte') returning id`, [tn.id, cu.id])
    const pr = await one(`insert into app.products (tenant_id, code, name, tracks_assets) values ($1, 'FRZ-500', 'Freezer', true) returning id`, [tn.id])
    const as = await one(`insert into app.assets (tenant_id, product_id, serial_number) values ($1, $2, 'SN-' || $3) returning id`, [tn.id, pr.id, slug])
    const ty = await one(`insert into app.work_order_types (tenant_id, code, name, category) values ($1, 'COR', 'Corretiva', 'corrective') returning id`, [tn.id])
    const te = await one(`insert into app.technicians (tenant_id, code, name) values ($1, 'T1', 'Técnico próprio') returning id`, [tn.id])
    return { tenant: tn.id, customer: cu.id, site1: s1.id, site2: s2.id, product: pr.id, asset: as.id, type: ty.id, tech: te.id }
  }
  async function mkWorkOrder(f, extra = {}) {
    await setTenant(f.tenant)
    const r = await one(`insert into app.work_orders (tenant_id, work_order_type_id, origin, customer_id, customer_site_id, asset_id, status)
                         values ($1, $2, $3, $4, $5, $6, $7) returning id, number`,
      [f.tenant, f.type, extra.origin || 'backoffice', f.customer, f.site1, f.asset, extra.status || 'requested'])
    return r
  }
  async function mkVisit(f, woId, techId, n = 1, provider = null) {
    return one(`insert into app.work_order_visits (tenant_id, work_order_id, visit_number, technician_id, service_provider_id, scheduled_start, scheduled_end)
                values ($1, $2, $3, $4, $5, now(), now() + interval '2 hours') returning id`, [f.tenant, woId, n, techId, provider])
  }
  async function mkProvider(f, code = 'P1') {
    return one(`insert into app.service_providers (tenant_id, code, legal_name, served_states) values ($1, $2, 'Prestador ' || $2, '{RS,SC}') returning id`, [f.tenant, code])
  }
  const CROCK = '0123456789ABCDEFGHJKMNPQRSTVWXYZ'
  const randCrock = (n) => Array.from({ length: n }, () => CROCK[Math.floor(Math.random() * 32)]).join('')
  // Etiqueta QR: token de 26 caracteres (começa com "01" para exercitar a normalização O/L)
  // e short code de 8 (7 aleatórios + verificador Luhn mod 32 calculado pelo banco).
  async function mkTag(f) {
    const token = '01' + randCrock(24)
    const payload = randCrock(7)
    const chk = await one(`select app.crockford_luhn32_check_char($1) as c`, [payload])
    const shortCode = payload + chk.c
    await setTenant(f.tenant)
    const r = await one(`insert into app.qr_tags (tenant_id, token, short_code) values ($1, $2, $3) returning id`, [f.tenant, token, shortCode])
    return { id: r.id, token, shortCode }
  }
  async function mkUser(subject = null, type = 'staff') {
    return one(`insert into app.users (user_type, idp_subject, full_name) values ($1, $2, 'Pessoa ' || coalesce($2, 'x')) returning id`, [type, subject])
  }
  async function mkDevice(f, extra = {}) {
    await setTenant(f.tenant)
    const u = extra.user || (await mkUser('sub-' + Math.random().toString(36).slice(2))).id
    return one(`insert into app.devices (tenant_id, user_id, app_kind, platform, technician_id) values ($1, $2, 'technician_app', 'android', $3) returning id`,
      [f.tenant, u, f.tech])
  }
  const asRuntime = async (tenantId, userId) => {
    await db.exec(`set role app_runtime;`)
    await q(`select set_config('app.tenant_id', $1, false), set_config('app.user_id', $2, false)`, [tenantId || '', userId || ''])
  }

  // ------------------------------------------------------------------ regressão v0.1
  await t('RLS: app_runtime só lê o tenant ativo', async () => {
    const a = await mkTenant(), b = await mkTenant()
    await db.exec(`set role app_runtime; select set_config('app.tenant_id', '${a.tenant}', false);`)
    const rows = await q(`select tenant_id from app.customers`)
    assert(rows.length === 1 && rows[0].tenant_id === a.tenant, `esperava 1 cliente do tenant A, veio ${JSON.stringify(rows)}`)
    await db.exec(`reset app.tenant_id;`)
    assert((await q(`select 1 from app.customers`)).length === 0, 'sem app.tenant_id deveria ver 0 linhas')
    void b
  })

  await t('RLS: WITH CHECK impede gravar em outro tenant', async () => {
    const a = await mkTenant(), b = await mkTenant()
    await db.exec(`set role app_runtime; select set_config('app.tenant_id', '${a.tenant}', false);`)
    await fails(() => q(`insert into app.customers (tenant_id, name, document_type) values ($1, 'X', 'none')`, [b.tenant]), /row-level security/, 'insert cruzado')
  })

  await t('Numeração sequencial por tenant', async () => {
    const f = await mkTenant()
    const w1 = await mkWorkOrder(f), w2 = await mkWorkOrder(f)
    assert(/-000001$/.test(w1.number) && /-000002$/.test(w2.number), `números: ${w1.number}, ${w2.number}`)
  })

  await t('Guarda de transição da OS: requested -> in_progress é rejeitada', async () => {
    const f = await mkTenant()
    const w = await mkWorkOrder(f)
    await fails(() => q(`update app.work_orders set status = 'in_progress' where tenant_id = $1 and id = $2`, [f.tenant, w.id]), /Transição de status inválida/, 'transição')
  })

  await t('Invariante ativo x alocação no COMMIT: installed sem alocação falha', async () => {
    const f = await mkTenant()
    await fails(() => tx(`update app.assets set status = 'installed' where id = '${f.asset}'`), /exige alocação vigente/, 'installed sem alocação')
  })

  await t('Campos mestres do ERP em customers só pelo ator integration', async () => {
    const f = await mkTenant()
    await db.exec(`set app.actor_type = 'integration';`)
    await q(`update app.customers set source = 'erp', external_system = 'senior_erpx', external_id = 'C1' where id = $1`, [f.customer])
    await db.exec(`reset app.actor_type;`)
    await fails(() => q(`update app.customers set name = 'Outro' where id = $1`, [f.customer]), /mestre do ERP/, 'nome de cliente ERP')
    await q(`update app.customers set notes = 'extensão local' where id = $1`, [f.customer])
  })

  await t('Apontamentos sem sobreposição por técnico', async () => {
    const f = await mkTenant()
    const w = await mkWorkOrder(f, { status: 'open' })
    await q(`insert into app.time_entries (tenant_id, work_order_id, technician_id, type, started_at, ended_at, source, justification)
             values ($1, $2, $3, 'work', '2026-11-02T10:00Z', '2026-11-02T11:00Z', 'manual', 'teste')`, [f.tenant, w.id, f.tech])
    await fails(() => q(`insert into app.time_entries (tenant_id, work_order_id, technician_id, type, started_at, ended_at, source, justification)
                         values ($1, $2, $3, 'travel', '2026-11-02T10:30Z', '2026-11-02T10:45Z', 'manual', 'teste')`, [f.tenant, w.id, f.tech]),
      /exclusion constraint|conflicting key/, 'sobreposição')
  })

  // ------------------------------------------------------------------ regressão restaurada (v0.1/v0.2)
  await t('RLS: sem app.tenant_id nenhuma tabela de tenant mostra linhas', async () => {
    const f = await mkTenant()
    await mkWorkOrder(f)
    await mkTag(f)
    await asRuntime(null, null)
    for (const tbl of ['customers', 'customer_sites', 'products', 'assets', 'qr_tags', 'work_orders', 'work_order_status_history', 'technicians', 'tenant_settings']) {
      const n = await one(`select count(*)::int as n from app.${tbl}`)
      assert(n.n === 0, `${tbl}: sem tenant deveria ver 0 linhas, viu ${n.n}`)
    }
    await q(`select set_config('app.tenant_id', 'nao-e-uuid', false)`)
    assert((await q(`select 1 from app.customers`)).length === 0, 'app.tenant_id malformado deveria ver 0 linhas')
  })

  await t('FK composta impede referência entre tenants', async () => {
    const a = await mkTenant(), b = await mkTenant()
    await fails(() => q(`insert into app.customer_sites (tenant_id, customer_id, name) values ($1, $2, 'Cruzada')`, [a.tenant, b.customer]),
      /foreign key/, 'unidade do tenant A apontando para cliente do B')
    await fails(() => q(`insert into app.work_orders (tenant_id, work_order_type_id, origin, customer_id, customer_site_id, asset_id)
                         values ($1, $2, 'backoffice', $3, $4, $5)`, [a.tenant, a.type, a.customer, a.site1, b.asset]),
      /foreign key/, 'OS do tenant A com ativo do B')
    await fails(() => q(`insert into app.asset_assignments (tenant_id, asset_id, customer_id, customer_site_id, ownership_type, started_at, start_reason)
                         values ($1, $2, $3, $4, 'tenant_loan', now(), 'delivery')`, [a.tenant, a.asset, b.customer, b.site1]),
      /foreign key/, 'alocação do ativo A em unidade do B')
  })

  await t('resolve_qr_token: sem tenant, entre tenants e com normalização', async () => {
    const a = await mkTenant(), b = await mkTenant()
    const ta = await mkTag(a), tb = await mkTag(b)
    await asRuntime(null, null)
    // Digitado/lido em minúsculas e com O/L no lugar de 0/1: normaliza para o token canônico.
    const typed = 'ol' + ta.token.slice(2).toLowerCase()
    const r = await q(`select * from public.resolve_qr_token($1)`, [typed])
    assert(r.length === 1 && r[0].tenant_id === a.tenant && r[0].qr_tag_id === ta.id && r[0].status === 'generated', `token A: ${JSON.stringify(r)}`)
    const rb = await q(`select tenant_id from public.resolve_qr_token($1)`, [tb.token])
    assert(rb.length === 1 && rb[0].tenant_id === b.tenant, 'token B resolve para o tenant B')
    assert((await q(`select 1 from public.resolve_qr_token($1)`, ['0' + randCrock(25)])).length === 0, 'token inexistente => 0 linhas')
    assert((await q(`select 1 from public.resolve_qr_token($1)`, ['ABC'])).length === 0, 'token curto => 0 linhas')
    assert((await q(`select 1 from app.qr_tags`)).length === 0, 'sem tenant o runtime não lê qr_tags diretamente')
    // Tenant suspenso não resolve.
    await db.exec('reset role;')
    await q(`update app.tenants set status = 'suspended', suspended_at = now() where id = $1`, [a.tenant])
    await asRuntime(null, null)
    assert((await q(`select 1 from public.resolve_qr_token($1)`, [ta.token])).length === 0, 'tenant suspenso não resolve')
  })

  await t('resolve_qr_short_code: hífen/minúsculas aceitos; verificador inválido rejeitado', async () => {
    const f = await mkTenant()
    const tg = await mkTag(f)
    await asRuntime(null, null)
    const typed = (tg.shortCode.slice(0, 4) + '-' + tg.shortCode.slice(4)).toLowerCase()
    const r = await q(`select * from public.resolve_qr_short_code($1)`, [typed])
    assert(r.length === 1 && r[0].qr_tag_id === tg.id && r[0].tenant_id === f.tenant, `short code: ${JSON.stringify(r)}`)
    const last = tg.shortCode.slice(-1)
    const wrong = tg.shortCode.slice(0, 7) + CROCK[(CROCK.indexOf(last) + 1) % 32]
    assert((await q(`select 1 from public.resolve_qr_short_code($1)`, [wrong])).length === 0, 'verificador inválido => 0 linhas')
    const v = await one(`select app.crockford_luhn32_is_valid($1) as ok`, [wrong])
    assert(v.ok === false, 'crockford_luhn32_is_valid deveria rejeitar o verificador trocado')
  })

  await t('RLS: runtime não lê nem altera qr_tags de outro tenant', async () => {
    const a = await mkTenant(), b = await mkTenant()
    const ta = await mkTag(a)
    await asRuntime(b.tenant, null)
    assert((await q(`select 1 from app.qr_tags where id = $1`, [ta.id])).length === 0, 'tenant B não vê a etiqueta do A')
    const upd = await q(`update app.qr_tags set print_count = 99 where id = $1 returning id`, [ta.id])
    assert(upd.length === 0, 'tenant B não altera a etiqueta do A')
    await q(`select set_config('app.tenant_id', $1, false)`, [a.tenant])
    assert((await q(`select 1 from app.qr_tags where id = $1`, [ta.id])).length === 1, 'tenant A vê a própria etiqueta')
  })

  await t('Numeração sequencial independente por tenant e prefixada pelo ano', async () => {
    const a = await mkTenant(), b = await mkTenant()
    const a1 = await mkWorkOrder(a), a2 = await mkWorkOrder(a), a3 = await mkWorkOrder(a)
    const b1 = await mkWorkOrder(b)
    const y = (await one(`select to_char(now() AT TIME ZONE 'America/Sao_Paulo', 'YYYY') as y`)).y
    assert(a1.number === `${y}-000001` && a2.number === `${y}-000002` && a3.number === `${y}-000003`, `A: ${a1.number}, ${a2.number}, ${a3.number}`)
    assert(b1.number === `${y}-000001`, `B começa do 1: ${b1.number}`)
    const p = await one(`select number_period, number_seq from app.work_orders where id = $1`, [a3.id])
    assert(p.number_period === y && Number(p.number_seq) === 3, `período/sequência: ${JSON.stringify(p)}`)
  })

  await t('Máquina de estados da OS grava o histórico de cada transição', async () => {
    const f = await mkTenant()
    const w = await mkWorkOrder(f)
    await q(`update app.work_orders set status = 'open' where id = $1`, [w.id])
    await q(`update app.work_orders set status = 'in_progress' where id = $1`, [w.id])
    await q(`update app.work_orders set status = 'on_hold', hold_reason = 'awaiting_part' where id = $1`, [w.id])
    await fails(() => q(`update app.work_orders set status = 'completed', completed_at = now() where id = $1`, [w.id]),
      /Transição de status inválida/, 'on_hold -> completed')
    await fails(() => q(`update app.work_orders set hold_reason = null where id = $1`, [w.id]), /check constraint/, 'on_hold sem hold_reason')
    const h = await q(`select from_status, to_status, hold_reason from app.work_order_status_history where work_order_id = $1 order by changed_at, created_at, to_status`, [w.id])
    const pairs = h.map(x => `${x.from_status || '-'}>${x.to_status}`)
    for (const p of ['->requested', 'requested>open', 'open>in_progress', 'in_progress>on_hold'])
      assert(pairs.includes(p), `histórico sem ${p}: ${pairs.join(', ')}`)
    assert(h.length === 4, `esperava 4 linhas de histórico, veio ${h.length}`)
    assert(h.find(x => x.to_status === 'on_hold').hold_reason === 'awaiting_part', 'histórico guarda o hold_reason')
  })

  await t('Alocação vigente duplicada do mesmo ativo falha', async () => {
    const f = await mkTenant()
    await tx(`insert into app.asset_assignments (tenant_id, asset_id, customer_id, customer_site_id, ownership_type, started_at, start_reason)
              values ('${f.tenant}', '${f.asset}', '${f.customer}', '${f.site1}', 'tenant_loan', now() - interval '1 day', 'delivery');
              update app.assets set status = 'installed' where id = '${f.asset}'`)
    await fails(() => tx(`insert into app.asset_assignments (tenant_id, asset_id, customer_id, customer_site_id, ownership_type, started_at, start_reason)
                          values ('${f.tenant}', '${f.asset}', '${f.customer}', '${f.site2}', 'tenant_loan', now(), 'transfer')`),
      /asset_assignments_current_key|exclusion constraint|conflicting key/, 'segunda alocação vigente')
    const a = await one(`select current_customer_site_id from app.assets where id = $1`, [f.asset])
    assert(a.current_customer_site_id === f.site1, 'a alocação vigente continua a primeira')
  })

  await t('Etiqueta: uma bound por ativo; desfazer vínculo libera o ativo', async () => {
    const f = await mkTenant()
    const t1 = await mkTag(f), t2 = await mkTag(f)
    const bind = (id) => q(`update app.qr_tags set status = 'bound', asset_id = $2, bound_at = now(), bound_via = 'backoffice' where id = $1`, [id, f.asset])
    await bind(t1.id)
    await fails(() => bind(t2.id), /qr_tags_one_bound_per_asset_key/, 'segunda etiqueta bound no mesmo ativo')
    await q(`update app.qr_tags set status = 'printed' where id = $1`, [t1.id])
    const r = await one(`select status, asset_id, last_bound_asset_id, unbind_count from app.qr_tags where id = $1`, [t1.id])
    assert(r.status === 'printed' && r.asset_id === null && r.last_bound_asset_id === f.asset && r.unbind_count === 1, `desfazer vínculo: ${JSON.stringify(r)}`)
    await bind(t2.id)
    await fails(() => q(`update app.qr_tags set status = 'bound', bound_at = now(), bound_via = 'backoffice' where id = $1`, [t1.id]),
      /check constraint/, 'bound sem asset_id')
  })

  await t('Etiqueta: revoked é terminal', async () => {
    const f = await mkTenant()
    const tg = await mkTag(f)
    await fails(() => q(`update app.qr_tags set status = 'revoked', revoked_at = now() where id = $1`, [tg.id]), /check constraint/, 'revogar sem motivo')
    await q(`update app.qr_tags set status = 'revoked', revoked_at = now(), revoked_reason = 'damaged' where id = $1`, [tg.id])
    for (const st of ['generated', 'printed'])
      await fails(() => q(`update app.qr_tags set status = $2, revoked_at = null, revoked_reason = null where id = $1`, [tg.id, st]),
        /Transição inválida da etiqueta/, `revoked -> ${st}`)
    await fails(() => q(`update app.qr_tags set status = 'bound', asset_id = $2, bound_at = now(), bound_via = 'backoffice', revoked_at = null, revoked_reason = null where id = $1`, [tg.id, f.asset]),
      /Transição inválida da etiqueta/, 'revoked -> bound')
  })

  await t('row_version cresce a cada alteração e a auditoria grava antes/depois', async () => {
    const f = await mkTenant()
    const before = await one(`select row_version, version from app.customers where id = $1`, [f.customer])
    await q(`update app.customers set notes = 'primeira' where id = $1`, [f.customer])
    const mid = await one(`select row_version, version from app.customers where id = $1`, [f.customer])
    await q(`update app.customers set notes = 'segunda' where id = $1`, [f.customer])
    const after = await one(`select row_version, version from app.customers where id = $1`, [f.customer])
    assert(Number(before.row_version) > 0 && Number(mid.row_version) > Number(before.row_version) && Number(after.row_version) > Number(mid.row_version),
      `row_version: ${before.row_version} -> ${mid.row_version} -> ${after.row_version}`)
    assert(after.version === before.version + 2, `version: ${before.version} -> ${after.version}`)
    const logs = await q(`select action, changed_fields, before_data ->> 'notes' as b, after_data ->> 'notes' as a
                            from app.audit_logs where tenant_id = $1 and entity_id = $2 order by occurred_at, created_at`, [f.tenant, f.customer])
    assert(logs.some(l => l.action === 'customers.insert'), 'auditoria do insert')
    const u = logs.filter(l => l.action === 'customers.update')
    assert(u.length === 2 && u[1].b === 'primeira' && u[1].a === 'segunda' && u[1].changed_fields.includes('notes'), `auditoria do update: ${JSON.stringify(u)}`)
  })

  await t('users e vínculos: o usuário vê os próprios vínculos e, no tenant, só quem pertence a ele', async () => {
    const a = await mkTenant(), b = await mkTenant()
    const uu = await mkUser('kc-' + Math.random().toString(36).slice(2)), vv = await mkUser('kc-' + Math.random().toString(36).slice(2))
    for (const [tn, us] of [[a.tenant, uu.id], [b.tenant, uu.id], [b.tenant, vv.id]]) {
      await setTenant(tn)
      await q(`insert into app.tenant_memberships (tenant_id, user_id, status, joined_at) values ($1, $2, 'active', now())`, [tn, us])
    }
    await asRuntime(null, uu.id)
    const ms = await q(`select tenant_id, user_id from app.tenant_memberships`)
    assert(ms.length === 2 && ms.every(m => m.user_id === uu.id), `sem tenant, só os próprios vínculos: ${JSON.stringify(ms)}`)
    const ts = await q(`select id from app.tenants`)
    assert(ts.length === 2, `tenants dos próprios vínculos: ${ts.length}`)
    let us = await q(`select id from app.users`)
    assert(us.length === 1 && us[0].id === uu.id, `sem tenant vê só a si mesmo: ${JSON.stringify(us)}`)
    await q(`select set_config('app.tenant_id', $1, false)`, [a.tenant])
    us = await q(`select id from app.users where id in ($1, $2)`, [uu.id, vv.id])
    assert(us.length === 1 && us[0].id === uu.id, 'no tenant A, V (só do B) não aparece')
    await q(`select set_config('app.tenant_id', $1, false)`, [b.tenant])
    us = await q(`select id from app.users where id in ($1, $2)`, [uu.id, vv.id])
    assert(us.length === 2, 'no tenant B, U e V aparecem')
    // Vínculos de OUTROS usuários só aparecem no tenant ativo (own_memberships_read cobre apenas os próprios).
    await asRuntime(a.tenant, vv.id)
    const seen = await q(`select tenant_id, user_id from app.tenant_memberships`)
    assert(seen.some(m => m.tenant_id === a.tenant && m.user_id === uu.id), 'no tenant A vê o vínculo de U no A')
    assert(seen.some(m => m.tenant_id === b.tenant && m.user_id === vv.id), 'V continua vendo o próprio vínculo no B')
    assert(!seen.some(m => m.tenant_id === b.tenant && m.user_id === uu.id), 'V no contexto do A não vê o vínculo de U no B')
  })

  await t('find_user_by_idp_subject e claim_outbox_messages: entre tenants só pela função', async () => {
    const a = await mkTenant(), b = await mkTenant()
    const sub = 'kc-' + Math.random().toString(36).slice(2)
    const uu = await mkUser(sub)
    const ids = []
    for (const f of [a, b]) {
      await setTenant(f.tenant)
      ids.push((await one(`insert into app.outbox_messages (tenant_id, event_type, aggregate_type, aggregate_id, payload)
                           values ($1, 'work_order.created', 'work_order', app.uuid_v7(), '{}') returning id`, [f.tenant])).id)
    }
    await asRuntime(null, null)
    assert((await q(`select 1 from app.users where idp_subject = $1`, [sub])).length === 0, 'sem contexto, users não é legível diretamente')
    const fu = await q(`select * from app.find_user_by_idp_subject($1)`, [sub])
    assert(fu.length === 1 && fu[0].user_id === uu.id && fu[0].status === 'active', `find_user_by_idp_subject: ${JSON.stringify(fu)}`)
    assert((await q(`select 1 from app.find_user_by_idp_subject('inexistente')`)).length === 0, 'subject desconhecido => 0 linhas')
    assert((await q(`select 1 from app.outbox_messages`)).length === 0, 'sem tenant, outbox não é legível diretamente')
    const claimed = await q(`select id, tenant_id, status, locked_by from app.claim_outbox_messages(500, 'worker-1')`)
    for (const id of ids) assert(claimed.some(c => c.id === id && c.status === 'processing' && c.locked_by === 'worker-1'), `mensagem ${id} reservada`)
    assert(new Set(claimed.filter(c => ids.includes(c.id)).map(c => c.tenant_id)).size === 2, 'o relay reserva mensagens dos dois tenants')
    assert((await q(`select 1 from app.claim_outbox_messages(500, 'worker-2') where id = any($1::uuid[])`, [ids])).length === 0, 'lease vigente: não reserva de novo')
    await q(`select set_config('app.tenant_id', $1, false)`, [a.tenant])
    const va = await q(`select id from app.outbox_messages where id = any($1::uuid[])`, [ids])
    assert(va.length === 1 && va[0].id === ids[0], 'no contexto do tenant A, só a mensagem do A')
  })

  await t('v0.3 background_jobs: isolado, claim entre tenants por prioridade, lease e idempotência', async () => {
    const a = await mkTenant(), b = await mkTenant()
    const ids = {}
    for (const [f, name, prio] of [[a, 'a', 5], [b, 'b', 1]]) {
      await setTenant(f.tenant)
      ids[name] = (await one(`insert into app.background_jobs (tenant_id, kind, priority, payload, idempotency_key)
                              values ($1, 'qr_label_batch.render', $2, '{"batch_id":"x"}', 'lote-1') returning id`, [f.tenant, prio])).id
    }
    await setTenant(a.tenant)
    await fails(() => q(`insert into app.background_jobs (tenant_id, kind, idempotency_key) values ($1, 'qr_label_batch.render', 'lote-1')`, [a.tenant]),
      /duplicate key|unique/, 'mesma chave de idempotência no mesmo tenant')
    await asRuntime(b.tenant, null)
    assert((await q(`select id from app.background_jobs where id = $1`, [ids.a])).length === 0, 'tenant B não vê o job de A')
    await fails(() => q(`insert into app.background_jobs (tenant_id, kind) values ($1, 'export.process')`, [a.tenant]), /row-level security/, 'gravar job em outro tenant')
    await asRuntime(null, null)
    // Um por vez: a ordem do RETURNING não é garantida, a do claim (ORDER BY priority) é.
    const first = await q(`select * from app.claim_background_jobs(1, 'worker-1')`)
    assert(first.length === 1 && first[0].background_job_id === ids.b && first[0].tenant_id === b.tenant, `prioridade 1 (tenant B) é reservada primeiro: ${JSON.stringify(first)}`)
    const second = await q(`select * from app.claim_background_jobs(1, 'worker-1')`)
    assert(second.length === 1 && second[0].background_job_id === ids.a && second[0].tenant_id === a.tenant, `depois o job do tenant A: ${JSON.stringify(second)}`)
    const claimed = [...first, ...second]
    assert(claimed.every(c => c.attempt_count === 1 && c.kind === 'qr_label_batch.render'), 'conta a tentativa e devolve o tipo')
    assert((await q(`select 1 from app.claim_background_jobs(10, 'worker-2') where background_job_id = any($1::uuid[])`, [[ids.a, ids.b]])).length === 0,
      'lease vigente: não reserva de novo')
  })

  await t('v0.3 display_tokens e meter_reading_daily: resolução sem tenant, revogação, isolamento e CHECKs', async () => {
    const a = await mkTenant(), b = await mkTenant()
    await setTenant(a.tenant)
    const tok = await one(`insert into app.display_tokens (tenant_id, name, dashboard, token_hash, expires_at)
                           values ($1, 'TV operação', 'work_orders_board', sha256('segredo-tv-a'::bytea), now() + interval '30 days') returning id`, [a.tenant])
    await fails(() => q(`insert into app.display_tokens (tenant_id, name, dashboard, token_hash, expires_at)
                         values ($1, 'TV longa', 'sla', sha256('x'::bytea), now() + interval '400 days')`, [a.tenant]), /check/i, 'validade acima de 1 ano')
    await asRuntime(null, null)
    const r = await q(`select * from app.find_display_token_by_hash(sha256('segredo-tv-a'::bytea))`)
    assert(r.length === 1 && r[0].tenant_id === a.tenant && r[0].display_token_id === tok.id, `resolve o token: ${JSON.stringify(r)}`)
    assert((await q(`select 1 from app.display_tokens`)).length === 0, 'sem tenant, display_tokens não é legível diretamente')
    await asRuntime(b.tenant, null)
    assert((await q(`select 1 from app.display_tokens where id = $1`, [tok.id])).length === 0, 'tenant B não vê o token de A')
    await db.exec('reset role;')
    await setTenant(a.tenant)
    const u = await mkUser('rev-' + Math.random().toString(36).slice(2))
    await q(`update app.display_tokens set revoked_at = now(), revoked_by = $2 where id = $1`, [tok.id, u.id])
    await asRuntime(null, null)
    assert((await q(`select 1 from app.find_display_token_by_hash(sha256('segredo-tv-a'::bytea))`)).length === 0, 'token revogado não resolve')
    await db.exec('reset role;')
    await setTenant(a.tenant)
    const m = await one(`insert into app.asset_meters (tenant_id, asset_id, meter_type, name, unit_code, is_cumulative)
                         values ($1, $2, 'hour_meter', 'Horímetro', 'h', true) returning id`, [a.tenant, a.asset])
    await q(`insert into app.meter_reading_daily (tenant_id, asset_meter_id, day, reading_count, min_value, max_value, avg_value, last_value, delta_value)
             values ($1, $2, current_date, 24, 100.0, 108.5, 104.2, 108.5, 8.5)`, [a.tenant, m.id])
    await fails(() => q(`insert into app.meter_reading_daily (tenant_id, asset_meter_id, day, reading_count, min_value, max_value, avg_value, last_value)
                         values ($1, $2, current_date, 1, 1, 1, 1, 1)`, [a.tenant, m.id]), /duplicate key|unique/, 'um consolidado por medidor e dia')
    await fails(() => q(`insert into app.meter_reading_daily (tenant_id, asset_meter_id, day, reading_count, min_value, max_value, avg_value, last_value)
                         values ($1, $2, current_date - 1, 3, 10, 5, 7, 5)`, [a.tenant, m.id]), /check/i, 'min <= avg <= max')
  })

  await t('runtime não altera nem apaga audit_logs', async () => {
    const f = await mkTenant()
    await asRuntime(f.tenant, null)
    const n = await one(`select count(*)::int as n from app.audit_logs where tenant_id = $1`, [f.tenant])
    assert(n.n > 0, 'o tenant lê a própria auditoria')
    await fails(() => q(`update app.audit_logs set reason = 'x' where tenant_id = $1`, [f.tenant]), /permission denied/, 'update em audit_logs')
    await fails(() => q(`delete from app.audit_logs where tenant_id = $1`, [f.tenant]), /permission denied/, 'delete em audit_logs')
    await fails(() => q(`select 1 from app.audit_logs_default`), /permission denied/, 'partição direta')
  })

  await t('devices: coerência status x revoked_at e bloqueio', async () => {
    const f = await mkTenant()
    const d = await mkDevice(f)
    await fails(() => q(`update app.devices set status = 'blocked' where id = $1`, [d.id]), /check constraint/, 'blocked sem revoked_at')
    await q(`update app.devices set status = 'logout_requested' where id = $1`, [d.id])
    await q(`update app.devices set status = 'blocked', revoked_at = now(), revoked_reason = 'perdido' where id = $1`, [d.id])
    await fails(() => q(`update app.devices set status = 'active' where id = $1`, [d.id]), /check constraint/, 'active com revoked_at')
    await q(`update app.devices set status = 'active', revoked_at = null, revoked_reason = null where id = $1`, [d.id])
    await fails(() => q(`update app.devices set push_provider = 'fcm' where id = $1`, [d.id]), /check constraint/, 'push_provider sem push_token')
    await fails(() => q(`update app.devices set push_provider = 'expo', push_token = 'x' where id = $1`, [d.id]), /check constraint/, 'v0.3: expo não é provedor')
    await q(`update app.devices set push_provider = 'fcm', push_token = 'tok-1' where id = $1`, [d.id])
    await fails(() => q(`insert into app.devices (tenant_id, user_id, app_kind, platform) select tenant_id, user_id, 'technician_app', 'ios' from app.devices where id = $1`, [d.id]),
      /check constraint/, 'technician_app sem technician_id')
  })

  await t('device_sync_scopes: isolado por tenant e apagado em cascata com o dispositivo', async () => {
    const a = await mkTenant(), b = await mkTenant()
    const d = await mkDevice(a)
    await setTenant(a.tenant)
    await q(`insert into app.device_sync_scopes (tenant_id, device_id, entity_type, entity_id) values ($1, $2, 'work_orders', app.uuid_v7()), ($1, $2, 'assets', $3)`, [a.tenant, d.id, a.asset])
    await fails(() => q(`insert into app.device_sync_scopes (tenant_id, device_id, entity_type, entity_id) values ($1, $2, 'Work Orders', app.uuid_v7())`, [a.tenant, d.id]),
      /check constraint/, 'entity_type fora do padrão')
    await fails(() => q(`insert into app.device_sync_scopes (tenant_id, device_id, entity_type, entity_id) values ($1, $2, 'assets', $3)`, [b.tenant, d.id, b.asset]),
      /foreign key/, 'escopo do tenant B apontando para dispositivo do A')
    await asRuntime(b.tenant, null)
    assert((await q(`select 1 from app.device_sync_scopes`)).length === 0, 'tenant B não vê o escopo do A')
    await q(`select set_config('app.tenant_id', $1, false)`, [a.tenant])
    assert((await q(`select 1 from app.device_sync_scopes where device_id = $1`, [d.id])).length === 2, 'tenant A vê o próprio escopo')
    await db.exec('reset role;')
    await q(`delete from app.devices where id = $1`, [d.id])
    const n = await one(`select count(*)::int as n from app.device_sync_scopes where device_id = $1`, [d.id])
    assert(n.n === 0, 'apagar o dispositivo apaga o snapshot (ON DELETE CASCADE)')
  })

  await t('sync_review_items: único por mutation_id e isolado por tenant', async () => {
    const a = await mkTenant(), b = await mkTenant()
    const w = await mkWorkOrder(a, { status: 'open' })
    const d = await mkDevice(a)
    const mid = (await one(`select app.uuid_v7() as id`)).id
    const ins = () => q(`insert into app.sync_review_items (tenant_id, work_order_id, technician_id, device_id, mutation_id, mutation_type, payload, reason)
                         values ($1, $2, $3, $4, $5, 'time_entry.create', '{"minutes": 30}', 'work_order_cancelled') returning id`, [a.tenant, w.id, a.tech, d.id, mid])
    const r = (await ins())[0]
    await fails(ins, /sync_review_items_tenant_id_mutation_id_key|duplicate key/, 'mesma mutação duas vezes')
    await fails(() => q(`update app.sync_review_items set status = 'discarded', decided_by = app.uuid_v7(), decided_at = now() where id = $1`, [r.id]),
      /check constraint/, 'descartar sem decision_note')
    await asRuntime(b.tenant, null)
    assert((await q(`select 1 from app.sync_review_items`)).length === 0, 'tenant B não vê registros a revisar do A')
    await q(`select set_config('app.tenant_id', $1, false)`, [a.tenant])
    assert((await q(`select 1 from app.sync_review_items where mutation_id = $1`, [mid])).length === 1, 'tenant A vê o próprio registro')
  })

  await t('support_sessions: read_write exige segundo aprovador; validade máxima de 60 min', async () => {
    const f = await mkTenant()
    const req = await mkUser('sup-' + Math.random().toString(36).slice(2)), second = await mkUser('sup-' + Math.random().toString(36).slice(2))
    const ins = (mode, second2, start, end, renewals = 0) => q(`insert into app.support_sessions (tenant_id, requested_by_user_id, mode, reason, status, second_approver_user_id, starts_at, expires_at, renewal_count)
                         values ($1, $2, $3, 'Chamado 123', 'active', $4, $5, $6, $7)`, [f.tenant, req.id, mode, second2, start, end, renewals])
    await fails(() => ins('read_write', null, '2026-11-02T10:00Z', '2026-11-02T10:30Z'), /check constraint/, 'read_write ativa sem segundo aprovador')
    await fails(() => ins('read_write', req.id, '2026-11-02T10:00Z', '2026-11-02T10:30Z'), /check constraint/, 'segundo aprovador = solicitante')
    await ins('read_write', second.id, '2026-11-02T10:00Z', '2026-11-02T10:30Z')
    await fails(() => ins('read_only', null, '2026-11-02T10:00Z', '2026-11-02T11:01Z'), /check constraint/, 'expires_at > 60 min')
    await ins('read_only', null, '2026-11-02T10:00Z', '2026-11-02T11:00Z')
    await ins('read_only', null, '2026-11-02T10:00Z', '2026-11-02T12:00Z', 1)
    await fails(() => ins('read_only', null, '2026-11-02T10:00Z', '2026-11-02T12:01Z', 1), /check constraint/, 'renovada além de 120 min')
    await q(`insert into app.support_sessions (tenant_id, requested_by_user_id, mode, reason, status) values ($1, $2, 'read_write', 'Pedido', 'pending_approval')`, [f.tenant, req.id])
  })

  await t('outbox: traceparent inválido falha; válido grava', async () => {
    const f = await mkTenant()
    const ins = (tp) => q(`insert into app.outbox_messages (tenant_id, event_type, aggregate_type, aggregate_id, payload, traceparent)
                           values ($1, 'work_order.created', 'work_order', app.uuid_v7(), '{}', $2)`, [f.tenant, tp])
    await fails(() => ins('abc'), /check constraint/, 'traceparent malformado')
    await fails(() => ins('00-' + 'A'.repeat(32) + '-' + '0'.repeat(16) + '-01'), /check constraint/, 'traceparent com hex maiúsculo')
    await ins('00-' + '4bf92f3577b34da6a3ce929d0e0e4736' + '-' + '00f067aa0ba902b7' + '-01')
    await ins(null)
    await fails(() => q(`insert into app.outbox_messages (tenant_id, event_type, aggregate_type, aggregate_id, payload) values ($1, 'WorkOrderCreated', 'work_order', app.uuid_v7(), '{}')`, [f.tenant]),
      /check constraint/, 'event_type fora do catálogo canônico')
  })

  // ------------------------------------------------------------------ v0.2
  await t('v0.2 branches: uma filial padrão por tenant; auditoria nas tabelas novas', async () => {
    const f = await mkTenant()
    await q(`insert into app.branches (tenant_id, code, legal_name, is_default) values ($1, 'MATRIZ', 'Matriz', true)`, [f.tenant])
    await fails(() => q(`insert into app.branches (tenant_id, code, legal_name, is_default) values ($1, 'FIL2', 'Filial 2', true)`, [f.tenant]),
      /branches_default_key/, 'segunda filial padrão')
    const p = await mkProvider(f)
    const a = await q(`select action from app.audit_logs where tenant_id = $1 and entity_id = $2`, [f.tenant, p.id])
    assert(a.some(x => x.action === 'service_providers.insert'), 'service_providers deveria ser auditada')
  })

  await t('v0.2 escalonamento: aceite exige quem; nível > 0 exige política', async () => {
    const f = await mkTenant()
    const w = await mkWorkOrder(f)
    await fails(() => q(`update app.work_orders set acknowledged_at = now() where id = $1`, [w.id]), /check constraint/, 'aceite sem acknowledged_by')
    await fails(() => q(`update app.work_orders set escalation_level = 1 where id = $1`, [w.id]), /check constraint/, 'nível sem política')
    const ep = await one(`insert into app.escalation_policies (tenant_id, name, priority, steps)
                          values ($1, 'Urgente 24x7', 'urgent', '[{"wait_minutes": 10, "notify": {"kind": "on_call", "on_call_role": "dispatcher"}, "channels": ["push"]}]')
                          returning id`, [f.tenant])
    await q(`update app.work_orders set escalation_policy_id = $2, escalation_level = 1 where id = $1`, [w.id, ep.id])
    await q(`update app.work_orders set acknowledged_at = now(), acknowledged_by = app.uuid_v7() where id = $1`, [w.id])
    await fails(() => q(`insert into app.escalation_policies (tenant_id, name, priority, steps) values ($1, 'Vazia', 'high', '[]')`, [f.tenant]),
      /check constraint/, 'política sem passos')
  })

  await t('v0.2 resolução remota: requested -> completed sem visita e completed -> closed', async () => {
    const f = await mkTenant()
    const w = await mkWorkOrder(f)
    await q(`update app.work_orders set status = 'completed', resolution_mode = 'remote', completed_at = now(),
               resolution_notes = 'Orientado por telefone a religar o disjuntor' where id = $1`, [w.id])
    const r = await one(`select status, first_response_at from app.work_orders where id = $1`, [w.id])
    assert(r.status === 'completed' && r.first_response_at, 'remota deveria concluir e preencher first_response_at')
    await q(`update app.work_orders set status = 'closed', closed_at = now() where id = $1`, [w.id])
    const h = await q(`select from_status, to_status from app.work_order_status_history where work_order_id = $1 order by changed_at, created_at`, [w.id])
    assert(h.some(x => x.from_status === 'requested' && x.to_status === 'completed'), 'histórico requested -> completed')
    assert(h.some(x => x.from_status === 'completed' && x.to_status === 'closed'), 'histórico completed -> closed')
  })

  await t('v0.2 resolução remota: exige modo remote, descrição e nenhuma visita ativa', async () => {
    const f = await mkTenant()
    const w = await mkWorkOrder(f, { status: 'open' })
    await fails(() => q(`update app.work_orders set status = 'completed', completed_at = now(), resolution_notes = 'x' where id = $1`, [w.id]),
      /só por resolução remota/, 'open -> completed com field')
    await fails(() => q(`update app.work_orders set status = 'completed', resolution_mode = 'remote', completed_at = now() where id = $1`, [w.id]),
      /check constraint/, 'remota sem resolution_notes')
    await mkVisit(f, w.id, f.tech)
    await fails(() => q(`update app.work_orders set status = 'completed', resolution_mode = 'remote', completed_at = now(), resolution_notes = 'x' where id = $1`, [w.id]),
      /visita ativa/, 'remota com visita agendada')
    // in_progress -> completed não aceita remote
    const w2 = await mkWorkOrder(f, { status: 'open' })
    await q(`update app.work_orders set status = 'in_progress' where id = $1`, [w2.id])
    await fails(() => q(`update app.work_orders set status = 'completed', resolution_mode = 'remote', completed_at = now(), resolution_notes = 'x' where id = $1`, [w2.id]),
      /só a partir de requested ou open/, 'in_progress -> completed remote')
  })

  await t('v0.2 movimentação pendente não vira vigente; aprovada vira', async () => {
    const f = await mkTenant()
    // ativo em estoque + alocação pendente: COMMIT passa e nada muda no ativo
    await tx(`insert into app.asset_assignments (tenant_id, asset_id, customer_id, customer_site_id, ownership_type, started_at, start_reason, approval_status)
              values ('${f.tenant}', '${f.asset}', '${f.customer}', '${f.site1}', 'tenant_loan', now(), 'delivery', 'pending')`)
    let a = await one(`select status, current_customer_id from app.assets where id = $1`, [f.asset])
    assert(a.status === 'in_stock' && a.current_customer_id === null, `pendente não pode virar vigente: ${JSON.stringify(a)}`)
    // aprovar sem mudar o status do ativo quebra a invariante no COMMIT
    await fails(() => tx(`update app.asset_assignments set approval_status = 'approved', approved_by = app.uuid_v7(), approved_at = now() where asset_id = '${f.asset}'`),
      /não pode ter alocação vigente/, 'aprovar sem instalar')
    // aprovar + instalar na mesma transação
    await tx(`update app.asset_assignments set approval_status = 'approved', approved_by = app.uuid_v7(), approved_at = now() where asset_id = '${f.asset}';
              update app.assets set status = 'installed' where id = '${f.asset}'`)
    a = await one(`select status, current_customer_site_id from app.assets where id = $1`, [f.asset])
    assert(a.status === 'installed' && a.current_customer_site_id === f.site1, `aprovada deveria valer: ${JSON.stringify(a)}`)
    // transferência pendente convive com a vigente (sem conflito na exclusion constraint)
    await tx(`insert into app.asset_assignments (tenant_id, asset_id, customer_id, customer_site_id, ownership_type, started_at, start_reason, approval_status)
              values ('${f.tenant}', '${f.asset}', '${f.customer}', '${f.site2}', 'tenant_loan', now(), 'transfer', 'pending')`)
    a = await one(`select current_customer_site_id from app.assets where id = $1`, [f.asset])
    assert(a.current_customer_site_id === f.site1, 'transferência pendente não muda a unidade vigente')
    await fails(() => q(`insert into app.asset_assignments (tenant_id, asset_id, customer_id, customer_site_id, ownership_type, started_at, start_reason, approval_status)
                         values ($1, $2, $3, $4, 'tenant_loan', now(), 'transfer', 'pending')`, [f.tenant, f.asset, f.customer, f.site2]),
      /asset_assignments_one_pending_key/, 'segunda pendente')
    // aprovar a transferência: encerra a anterior e aprova a nova
    await tx(`update app.asset_assignments set ended_at = now(), end_reason = 'transfer' where asset_id = '${f.asset}' and approval_status = 'approved' and ended_at is null;
              update app.asset_assignments set approval_status = 'approved', approved_by = app.uuid_v7(), approved_at = now(), started_at = now()
               where asset_id = '${f.asset}' and approval_status = 'pending'`)
    a = await one(`select status, current_customer_site_id from app.assets where id = $1`, [f.asset])
    assert(a.status === 'installed' && a.current_customer_site_id === f.site2, `transferência aprovada: ${JSON.stringify(a)}`)
    // aprovada exige quem e quando
    await fails(() => q(`insert into app.asset_assignments (tenant_id, asset_id, customer_id, customer_site_id, ownership_type, started_at, start_reason, approval_status)
                         values ($1, $2, $3, $4, 'tenant_loan', now() - interval '10 years', 'correction', 'approved')`, [f.tenant, f.asset, f.customer, f.site1]),
      /check constraint/, 'approved sem approved_by')
  })

  await t('v0.2 technicians: contractor exige prestador; employee não pode ter', async () => {
    const f = await mkTenant()
    const p = await mkProvider(f)
    await fails(() => q(`insert into app.technicians (tenant_id, code, name, kind) values ($1, 'C1', 'Terceiro', 'contractor')`, [f.tenant]),
      /check constraint/, 'contractor sem prestador')
    await fails(() => q(`insert into app.technicians (tenant_id, code, name, kind, service_provider_id) values ($1, 'E1', 'Próprio', 'employee', $2)`, [f.tenant, p.id]),
      /check constraint/, 'employee com prestador')
    await q(`insert into app.technicians (tenant_id, code, name, kind, service_provider_id) values ($1, 'C2', 'Terceiro', 'contractor', $2)`, [f.tenant, p.id])
  })

  await t('v0.2 visita: técnico precisa ser do prestador da visita; só prestador fica scheduled', async () => {
    const f = await mkTenant()
    const p1 = await mkProvider(f, 'P1'), p2 = await mkProvider(f, 'P2')
    const c1 = await one(`insert into app.technicians (tenant_id, code, name, kind, service_provider_id) values ($1, 'C1', 'T P1', 'contractor', $2) returning id`, [f.tenant, p1.id])
    const w = await mkWorkOrder(f, { status: 'open' })
    await fails(() => mkVisit(f, w.id, c1.id, 1, p2.id), /foreign key/, 'técnico de outro prestador')
    const v = await mkVisit(f, w.id, null, 1, p1.id)
    await fails(() => q(`update app.work_order_visits set status = 'en_route' where id = $1`, [v.id]), /check constraint/, 'en_route sem técnico')
    await q(`update app.work_order_visits set technician_id = $2 where id = $1`, [v.id, c1.id])
    const tomb = await q(`select 1 from app.sync_tombstones where entity_id = $1`, [v.id])
    assert(tomb.length === 0, 'atribuir técnico a visita só do prestador não gera tombstone')
  })

  await t('v0.2 work_order_costs: FK composta, valores, conferência e isolamento', async () => {
    const a = await mkTenant(), b = await mkTenant()
    const p = await mkProvider(a)
    const wa = await mkWorkOrder(a, { status: 'open' }), wa2 = await mkWorkOrder(a, { status: 'open' })
    const va = await mkVisit(a, wa.id, a.tech)
    await setTenant(a.tenant)
    await q(`insert into app.work_order_costs (tenant_id, work_order_id, visit_id, service_provider_id, cost_type, description, unit_cost)
             values ($1, $2, $3, $4, 'third_party_labor', 'Visita do prestador', 18000)`, [a.tenant, wa.id, va.id, p.id])
    await fails(() => q(`insert into app.work_order_costs (tenant_id, work_order_id, visit_id, cost_type, description, unit_cost)
                         values ($1, $2, $3, 'travel', 'km', 10)`, [a.tenant, wa2.id, va.id]), /foreign key/, 'visita de outra OS')
    const wb = await mkWorkOrder(b, { status: 'open' })
    await fails(() => q(`insert into app.work_order_costs (tenant_id, work_order_id, cost_type, description, unit_cost)
                         values ($1, $2, 'other', 'x', 1)`, [a.tenant, wb.id]), /foreign key/, 'OS de outro tenant')
    await fails(() => q(`insert into app.work_order_costs (tenant_id, work_order_id, cost_type, description, unit_cost)
                         values ($1, $2, 'other', 'x', -1)`, [a.tenant, wa.id]), /check constraint/, 'valor negativo')
    await fails(() => q(`insert into app.work_order_costs (tenant_id, work_order_id, cost_type, description, unit_cost)
                         values ($1, $2, 'third_party_labor', 'x', 1)`, [a.tenant, wa.id]), /check constraint/, 'terceiro sem prestador')
    await fails(() => q(`insert into app.work_order_costs (tenant_id, work_order_id, cost_type, status, description, unit_cost)
                         values ($1, $2, 'parts', 'approved', 'x', 1)`, [a.tenant, wa.id]), /check constraint/, 'approved sem conferência')
    const tot = await one(`select total_amount from app.work_order_costs where work_order_id = $1`, [wa.id])
    // v0.3: centavos (R$ 180,00 = 18000) x quantidade padrão 1000 (1 unidade).
    assert(Number(tot.total_amount) === 18000, `total gerado em centavos: ${tot.total_amount}`)
    await db.exec(`set role app_runtime; select set_config('app.tenant_id', '${b.tenant}', false);`)
    assert((await q(`select 1 from app.work_order_costs`)).length === 0, 'tenant B não pode ver custos do A')
    await db.exec(`select set_config('app.tenant_id', '${a.tenant}', false);`)
    assert((await q(`select 1 from app.work_order_costs`)).length === 1, 'tenant A vê o próprio custo')
  })

  await t('v0.2 maintenance_plans: CHECKs por trigger_type', async () => {
    const f = await mkTenant()
    const ins = (cols, vals) => q(`insert into app.maintenance_plans (tenant_id, code, name, work_order_type_id, trigger_type, ${cols})
                                   values ($1, 'P' || floor(random()*1e9)::text, 'Plano', $2, ${vals})`, [f.tenant, f.type])
    await fails(() => ins('interval_days', `'interval_days', 0`), /interval_days_check/, 'interval_days = 0')
    await fails(() => ins('interval_days, monthly_day', `'interval_days', 30, 5`), /interval_days_check/, 'interval_days com monthly_day')
    await fails(() => ins('monthly_day', `'monthly_day', 29`), /monthly_day_check/, 'monthly_day 29')
    await fails(() => ins('meter_interval', `'meter', 500`), /meter_check/, 'meter sem meter_type')
    await fails(() => ins('meter_type, meter_interval', `'meter', 'hour_meter', 0`), /meter_check/, 'meter_interval 0')
    await fails(() => ins('interval_days, applies_to', `'interval_days', 30, 'product'`), /scope_check/, 'product sem product_id')
    await ins('interval_days', `'interval_days', 90`)
    await ins('monthly_day', `'monthly_day', 28`)
    await ins('meter_type, meter_interval', `'meter', 'hour_meter', 500`)
  })

  await t('v0.2 meter_readings: idempotência por (medidor, read_at, source) e asset_meters sincronizado', async () => {
    const f = await mkTenant()
    const m = await one(`insert into app.asset_meters (tenant_id, asset_id, meter_type, name, unit_code, is_cumulative)
                         values ($1, $2, 'hour_meter', 'Horímetro', 'h', true) returning id, row_version`, [f.tenant, f.asset])
    assert(Number(m.row_version) > 0, 'asset_meters deveria ganhar row_version (sincronizada)')
    const ts = '2026-11-02T10:00:00Z'
    await q(`insert into app.meter_readings (tenant_id, asset_meter_id, value, read_at, source) values ($1, $2, 1234.5, $3, 'manual')`, [f.tenant, m.id, ts])
    await fails(() => q(`insert into app.meter_readings (tenant_id, asset_meter_id, value, read_at, source) values ($1, $2, 1234.5, $3, 'manual')`, [f.tenant, m.id, ts]),
      /meter_readings_idempotency_key/, 'leitura repetida')
    const r = await q(`insert into app.meter_readings (tenant_id, asset_meter_id, value, read_at, source) values ($1, $2, 1234.5, $3, 'manual')
                       on conflict (tenant_id, asset_meter_id, read_at, source) do nothing returning id`, [f.tenant, m.id, ts])
    assert(r.length === 0, 'reenvio com ON CONFLICT DO NOTHING não duplica')
    await q(`insert into app.meter_readings (tenant_id, asset_meter_id, value, read_at, source) values ($1, $2, 1234.5, $3, 'import')`, [f.tenant, m.id, ts])
    await fails(() => q(`insert into app.meter_readings (tenant_id, asset_meter_id, value, read_at, source) values ($1, $2, 1, now(), 'iot')`, [f.tenant, m.id]),
      /check constraint/, 'iot sem dispositivo')
    const n = await one(`select count(*)::int as n from app.meter_readings where asset_meter_id = $1`, [m.id])
    assert(n.n === 2, `esperava 2 leituras, veio ${n.n}`)
  })

  await t('v0.2 assets vindos do ERP: colunas mestres só pelo ator integration', async () => {
    const f = await mkTenant()
    await db.exec(`set app.actor_type = 'integration';`)
    await q(`update app.assets set source = 'erp', external_system = 'senior_erpx', external_id = 'PAT-1', acquisition_cost = 5000 where id = $1`, [f.asset])
    await db.exec(`reset app.actor_type;`)
    await fails(() => q(`update app.assets set acquisition_cost = 1 where id = $1`, [f.asset]), /mestre do ERP/, 'custo de aquisição do bem ERP')
    await fails(() => q(`update app.assets set serial_number = 'X' where id = $1`, [f.asset]), /mestre do ERP/, 'série do bem ERP')
    await q(`update app.assets set location_note = 'cozinha', notes = 'ok' where id = $1`, [f.asset])
    await fails(() => q(`update app.assets set source = 'erp', external_system = null, external_id = null where id = $1`, [f.asset]), /mestre do ERP|check constraint/, 'erp sem external_id')
  })

  await t('v0.2 FK de plano na OS e uma OS aberta por plano x ativo', async () => {
    const f = await mkTenant()
    const p = await one(`insert into app.maintenance_plans (tenant_id, code, name, work_order_type_id, trigger_type, interval_days)
                         values ($1, 'PM90', 'Preventiva 90 dias', $2, 'interval_days', 90) returning id`, [f.tenant, f.type])
    const pa = await one(`insert into app.maintenance_plan_assets (tenant_id, maintenance_plan_id, asset_id, next_due_date)
                          values ($1, $2, $3, current_date) returning id`, [f.tenant, p.id, f.asset])
    const ins = () => q(`insert into app.work_orders (tenant_id, work_order_type_id, origin, entry_method, status, customer_id, customer_site_id, asset_id, maintenance_plan_asset_id)
                         values ($1, $2, 'preventive_plan', 'preventive_plan', 'open', $3, $4, $5, $6)`, [f.tenant, f.type, f.customer, f.site1, f.asset, pa.id])
    await ins()
    await fails(ins, /work_orders_open_plan_asset_key/, 'segunda OS aberta do mesmo plano x ativo')
  })

  // ------------------------------------------------------------------ v0.3 (tipos do ORM do Serverpod)
  await t('v0.3 dinheiro em centavos (bigint): grava e soma sem erro de arredondamento', async () => {
    const numericCols = await q(`select table_name || '.' || column_name as c from information_schema.columns
                                  where table_schema = 'app' and data_type = 'numeric' order by 1`)
    assert(numericCols.length === 0, `nenhuma coluna numeric deveria sobrar: ${numericCols.map(r => r.c).join(', ')}`)
    const money = await q(`select table_name || '.' || column_name as c, data_type from information_schema.columns
                            where table_schema = 'app' and (table_name, column_name) in (
                              ('work_order_items','unit_price'), ('work_order_items','total_amount'), ('work_order_items','discount_amount'),
                              ('work_order_costs','unit_cost'), ('work_order_costs','total_amount'), ('assets','acquisition_cost'),
                              ('provider_rates','amount'), ('technicians','hourly_cost'), ('products','reference_price'),
                              ('services','default_price'), ('provider_settlements','total_amount'), ('customer_sales_summaries','net_amount'),
                              ('notifications','provider_cost'))`)
    assert(money.length === 13 && money.every(m => m.data_type === 'bigint'), `colunas de dinheiro em bigint: ${JSON.stringify(money)}`)
    const f = await mkTenant()
    const w = await mkWorkOrder(f, { status: 'open' })
    await setTenant(f.tenant)
    // 10 linhas de R$ 0,10: em double daria 0.9999999999999999; em centavos soma exatamente 100.
    for (let i = 0; i < 10; i++)
      await q(`insert into app.work_order_costs (tenant_id, work_order_id, cost_type, description, unit_cost) values ($1, $2, 'other', 'Taxa', 10)`, [f.tenant, w.id])
    const s = await one(`select sum(total_amount)::bigint as cents, pg_typeof(sum(total_amount))::text as t from app.work_order_costs where work_order_id = $1`, [w.id])
    assert(Number(s.cents) === 100, `soma de 10 x R$ 0,10 = 100 centavos, veio ${s.cents}`)
    const dbl = await one(`select sum(0.1::double precision) = 1 as exact from generate_series(1, 10)`)
    assert(dbl.exact === false, 'controle: a mesma soma em double precision não é exata')
    // Valores grandes: R$ 90 trilhões cabem em bigint e em int de 53 bits (Flutter Web).
    await q(`insert into app.work_order_costs (tenant_id, work_order_id, cost_type, description, unit_cost) values ($1, $2, 'other', 'Grande', 9000000000000000)`, [f.tenant, w.id])
    const g = await one(`select max(total_amount)::text as v from app.work_order_costs where work_order_id = $1`, [w.id])
    assert(g.v === '9000000000000000', `valor grande preservado: ${g.v}`)
    // Fração de centavo enviada como texto é recusada pelo tipo (a conversão decimal -> centavos é do adaptador).
    await fails(() => q(`insert into app.work_order_costs (tenant_id, work_order_id, cost_type, description, unit_cost) values ($1, $2, 'other', 'x', $3)`, [f.tenant, w.id, '10.5']),
      /invalid input syntax/, 'fração de centavo')
    await q(`update app.assets set acquisition_cost = 500000 where id = $1`, [f.asset])
    const a = await one(`select acquisition_cost from app.assets where id = $1`, [f.asset])
    assert(Number(a.acquisition_cost) === 500000, 'R$ 5.000,00 = 500000 centavos')
  })

  await t('v0.3 quantidade em milésimos: linha = quantidade x preço / 1000, arredondada ao centavo', async () => {
    const f = await mkTenant()
    const w = await mkWorkOrder(f, { status: 'open' })
    await setTenant(f.tenant)
    const item = (qty, price, disc = 0) => one(`insert into app.work_order_items (tenant_id, work_order_id, kind, product_id, item_code, description, unit_code,
                                                 quantity, unit_price, discount_amount, added_via)
                                                values ($1, $2, 'product', $3, 'FRZ-500', 'Peça', 'UN', $4, $5, $6, 'backoffice') returning total_amount`,
      [f.tenant, w.id, f.product, qty, price, disc])
    let r = await item(1500, 1234)          // 1,5 x R$ 12,34 = R$ 18,51
    assert(Number(r.total_amount) === 1851, `1,5 x 12,34: ${r.total_amount}`)
    r = await item(333, 100)                // 0,333 x R$ 1,00 = R$ 0,333 -> 0,33
    assert(Number(r.total_amount) === 33, `0,333 x 1,00: ${r.total_amount}`)
    r = await item(1, 500)                  // 0,001 x R$ 5,00 = R$ 0,005 -> 0,01 (meio para longe do zero)
    assert(Number(r.total_amount) === 1, `0,001 x 5,00: ${r.total_amount}`)
    r = await item(2000, 1999, 998)         // 2 x R$ 19,99 - R$ 9,98 = R$ 30,00
    assert(Number(r.total_amount) === 3000, `2 x 19,99 - 9,98: ${r.total_amount}`)
    await fails(() => item(1500, 1234, 1852), /check constraint/, 'desconto maior que o bruto da linha')
    await fails(() => item(0, 1234), /check constraint/, 'quantidade zero')
    const sum = await one(`select sum(total_amount)::bigint as s from app.work_order_items where work_order_id = $1`, [w.id])
    assert(Number(sum.s) === 1851 + 33 + 1 + 3000, `soma dos itens: ${sum.s}`)
    const fn = await one(`select app.line_amount_cents(2500, 8550) as v`)   // 2,5 h x R$ 85,50 = R$ 213,75
    assert(Number(fn.v) === 21375, `line_amount_cents: ${fn.v}`)
    const qt = await q(`select table_name, data_type from information_schema.columns
                         where table_schema = 'app' and column_name = 'quantity' and table_name in ('work_order_items', 'work_order_costs', 'customer_sales_summaries')`)
    assert(qt.length === 3 && qt.every(x => x.data_type === 'bigint'), `quantidades em bigint: ${JSON.stringify(qt)}`)
    // Duração calculada do apontamento em minutos inteiros (59 min 40 s -> 60).
    const te = await one(`insert into app.time_entries (tenant_id, work_order_id, technician_id, type, started_at, ended_at, source, justification)
                          values ($1, $2, $3, 'work', '2026-11-02T10:00:00Z', '2026-11-02T10:59:40Z', 'manual', 'teste') returning duration_minutes`, [f.tenant, w.id, f.tech])
    assert(te.duration_minutes === 60, `duration_minutes inteiro: ${te.duration_minutes}`)
    // Medidas em double precision.
    const geo = await one(`insert into app.customer_sites (tenant_id, customer_id, name, latitude, longitude) values ($1, $2, 'Geo', -30.0346471, -51.2176584)
                           returning latitude, longitude, pg_typeof(latitude)::text as t`, [f.tenant, f.customer])
    assert(geo.t === 'double precision' && Math.abs(geo.latitude + 30.0346471) < 1e-9, `latitude double: ${JSON.stringify(geo)}`)
  })
}
