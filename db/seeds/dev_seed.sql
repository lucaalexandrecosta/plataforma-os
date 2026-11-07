-- =============================================================================
-- Seed de desenvolvimento: DOIS tenants fictícios, para enxergar o isolamento
-- desde o primeiro dia (docs/02 §6.1, "melos run dev").
--
--   frio-sul     Frio Sul Refrigeração        plano professional
--   forno-norte  Forno Norte Equipamentos     plano starter
--
-- Usuários da equipe (idp_subject = id do usuário no realm "staff" do Keycloak
-- local, infra/local/keycloak/realm-staff.json; senha local: "dev"):
--   ana.admin@frio-sul.test       tenant_admin  em frio-sul
--   bruno.despacho@frio-sul.test  dispatcher    em frio-sul
--   carla.admin@forno-norte.test  tenant_admin  em forno-norte
--   davi.consultor@dev.test       manager nos DOIS tenants (troca de tenant)
--
-- Roda como superusuário (dev/CI), depois da migração inicial. Idempotente:
-- pode ser reaplicado (ON CONFLICT DO NOTHING). Nunca rodar em produção.
-- Os ids são UUID v7 fixos para facilitar testes manuais e e2e.
-- =============================================================================
BEGIN;
SET LOCAL search_path = app, public;
SELECT set_config('app.actor_type', 'system', true),
       set_config('app.correlation_id', 'dev-seed', true);

-- ---------------------------------------------------------------- tenants
INSERT INTO app.tenants (id, slug, legal_name, display_name, document_number, status, plan_id)
SELECT v.id::uuid, v.slug, v.legal_name, v.display_name, v.doc, 'active', p.id
  FROM (VALUES
    ('0197f000-0001-7000-8000-000000000001', 'frio-sul',    'Frio Sul Refrigeração Ltda',    'Frio Sul',    '11222333000181', 'professional'),
    ('0197f000-0002-7000-8000-000000000002', 'forno-norte', 'Forno Norte Equipamentos Ltda', 'Forno Norte', '44555666000172', 'starter')
  ) AS v(id, slug, legal_name, display_name, doc, plan_code)
  JOIN app.plans p ON p.code = v.plan_code
ON CONFLICT (id) DO NOTHING;

-- ---------------------------------------------------------------- usuários (globais)
INSERT INTO app.users (id, user_type, idp_subject, full_name, email, email_verified_at, status) VALUES
  ('0197f000-0100-7000-8000-000000000001', 'staff', '7d0a0001-0000-4000-8000-000000000001', 'Ana Admin',      'ana.admin@frio-sul.test',      now(), 'active'),
  ('0197f000-0100-7000-8000-000000000002', 'staff', '7d0a0001-0000-4000-8000-000000000002', 'Bruno Despacho', 'bruno.despacho@frio-sul.test', now(), 'active'),
  ('0197f000-0100-7000-8000-000000000003', 'staff', '7d0a0001-0000-4000-8000-000000000003', 'Carla Admin',    'carla.admin@forno-norte.test', now(), 'active'),
  ('0197f000-0100-7000-8000-000000000004', 'staff', '7d0a0001-0000-4000-8000-000000000004', 'Davi Consultor', 'davi.consultor@dev.test',      now(), 'active')
ON CONFLICT (id) DO NOTHING;

-- =============================================================== tenant A: frio-sul
SELECT set_config('app.tenant_id', '0197f000-0001-7000-8000-000000000001', true);

INSERT INTO app.tenant_settings (tenant_id, triage_mode, require_qr_check_in)
VALUES ('0197f000-0001-7000-8000-000000000001', 'sales_rep_first', true)
ON CONFLICT (tenant_id) DO NOTHING;

INSERT INTO app.branches (id, tenant_id, code, legal_name, trade_name, document_number, city, state, is_default)
VALUES ('0197f000-0001-7100-8000-000000000001', '0197f000-0001-7000-8000-000000000001',
        'MATRIZ', 'Frio Sul Refrigeração Ltda', 'Frio Sul', '11222333000181', 'Porto Alegre', 'RS', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.tenant_memberships (id, tenant_id, user_id, status, joined_at) VALUES
  ('0197f000-0001-7200-8000-000000000001', '0197f000-0001-7000-8000-000000000001', '0197f000-0100-7000-8000-000000000001', 'active', now()),
  ('0197f000-0001-7200-8000-000000000002', '0197f000-0001-7000-8000-000000000001', '0197f000-0100-7000-8000-000000000002', 'active', now()),
  ('0197f000-0001-7200-8000-000000000004', '0197f000-0001-7000-8000-000000000001', '0197f000-0100-7000-8000-000000000004', 'active', now())
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.tenant_membership_roles (tenant_id, membership_id, role_code) VALUES
  ('0197f000-0001-7000-8000-000000000001', '0197f000-0001-7200-8000-000000000001', 'tenant_admin'),
  ('0197f000-0001-7000-8000-000000000001', '0197f000-0001-7200-8000-000000000002', 'dispatcher'),
  ('0197f000-0001-7000-8000-000000000001', '0197f000-0001-7200-8000-000000000004', 'manager')
ON CONFLICT (tenant_id, membership_id, role_code) DO NOTHING;

INSERT INTO app.customers (id, tenant_id, code, name, trade_name, document_type, document_number, phone) VALUES
  ('0197f000-0001-7300-8000-000000000001', '0197f000-0001-7000-8000-000000000001', 'C001', 'Padaria Pão Quente Ltda', 'Pão Quente', 'cnpj', '12345678000195', '+5551999990001'),
  ('0197f000-0001-7300-8000-000000000002', '0197f000-0001-7000-8000-000000000001', 'C002', 'Mercado Bom Preço Ltda',  'Bom Preço',  'cnpj', '98765432000110', '+5551999990002')
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.customer_sites (id, tenant_id, customer_id, name) VALUES
  ('0197f000-0001-7310-8000-000000000001', '0197f000-0001-7000-8000-000000000001', '0197f000-0001-7300-8000-000000000001', 'Loja Centro'),
  ('0197f000-0001-7310-8000-000000000002', '0197f000-0001-7000-8000-000000000001', '0197f000-0001-7300-8000-000000000002', 'Loja Zona Norte')
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.products (id, tenant_id, code, name, tracks_assets) VALUES
  ('0197f000-0001-7400-8000-000000000001', '0197f000-0001-7000-8000-000000000001', 'FRZ-500', 'Freezer horizontal 500 L', true),
  ('0197f000-0001-7400-8000-000000000002', '0197f000-0001-7000-8000-000000000001', 'EXP-2P',  'Expositor refrigerado 2 portas', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.assets (id, tenant_id, product_id, serial_number) VALUES
  ('0197f000-0001-7410-8000-000000000001', '0197f000-0001-7000-8000-000000000001', '0197f000-0001-7400-8000-000000000001', 'FS-FRZ-0001'),
  ('0197f000-0001-7410-8000-000000000002', '0197f000-0001-7000-8000-000000000001', '0197f000-0001-7400-8000-000000000002', 'FS-EXP-0001')
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.work_order_types (id, tenant_id, code, name, category) VALUES
  ('0197f000-0001-7500-8000-000000000001', '0197f000-0001-7000-8000-000000000001', 'COR', 'Corretiva',  'corrective'),
  ('0197f000-0001-7500-8000-000000000002', '0197f000-0001-7000-8000-000000000001', 'INS', 'Instalação', 'installation')
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.technicians (id, tenant_id, code, name) VALUES
  ('0197f000-0001-7600-8000-000000000001', '0197f000-0001-7000-8000-000000000001', 'T01', 'Eduardo Técnico')
ON CONFLICT (id) DO NOTHING;

-- Etiquetas QR em estado "generated" (short code = 7 caracteres + verificador).
INSERT INTO app.qr_tags (id, tenant_id, token, short_code)
SELECT v.id::uuid, '0197f000-0001-7000-8000-000000000001', v.token, v.payload || app.crockford_luhn32_check_char(v.payload)
  FROM (VALUES
    ('0197f000-0001-7700-8000-000000000001', '0FS000000000000000000000A1', 'FSAAAA1'),
    ('0197f000-0001-7700-8000-000000000002', '0FS000000000000000000000A2', 'FSAAAA2')
  ) AS v(id, token, payload)
ON CONFLICT (id) DO NOTHING;

-- =============================================================== tenant B: forno-norte
SELECT set_config('app.tenant_id', '0197f000-0002-7000-8000-000000000002', true);

INSERT INTO app.tenant_settings (tenant_id, triage_mode)
VALUES ('0197f000-0002-7000-8000-000000000002', 'central')
ON CONFLICT (tenant_id) DO NOTHING;

INSERT INTO app.branches (id, tenant_id, code, legal_name, trade_name, document_number, city, state, is_default)
VALUES ('0197f000-0002-7100-8000-000000000001', '0197f000-0002-7000-8000-000000000002',
        'MATRIZ', 'Forno Norte Equipamentos Ltda', 'Forno Norte', '44555666000172', 'Recife', 'PE', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.tenant_memberships (id, tenant_id, user_id, status, joined_at) VALUES
  ('0197f000-0002-7200-8000-000000000003', '0197f000-0002-7000-8000-000000000002', '0197f000-0100-7000-8000-000000000003', 'active', now()),
  ('0197f000-0002-7200-8000-000000000004', '0197f000-0002-7000-8000-000000000002', '0197f000-0100-7000-8000-000000000004', 'active', now())
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.tenant_membership_roles (tenant_id, membership_id, role_code) VALUES
  ('0197f000-0002-7000-8000-000000000002', '0197f000-0002-7200-8000-000000000003', 'tenant_admin'),
  ('0197f000-0002-7000-8000-000000000002', '0197f000-0002-7200-8000-000000000004', 'manager')
ON CONFLICT (tenant_id, membership_id, role_code) DO NOTHING;

INSERT INTO app.customers (id, tenant_id, code, name, trade_name, document_type, document_number) VALUES
  ('0197f000-0002-7300-8000-000000000001', '0197f000-0002-7000-8000-000000000002', 'C001', 'Confeitaria Doce Lar Ltda', 'Doce Lar', 'cnpj', '11111111000191')
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.customer_sites (id, tenant_id, customer_id, name) VALUES
  ('0197f000-0002-7310-8000-000000000001', '0197f000-0002-7000-8000-000000000002', '0197f000-0002-7300-8000-000000000001', 'Matriz Boa Viagem')
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.products (id, tenant_id, code, name, tracks_assets) VALUES
  ('0197f000-0002-7400-8000-000000000001', '0197f000-0002-7000-8000-000000000002', 'FRN-10E', 'Forno de lastro 10 esteiras', true)
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.assets (id, tenant_id, product_id, serial_number) VALUES
  ('0197f000-0002-7410-8000-000000000001', '0197f000-0002-7000-8000-000000000002', '0197f000-0002-7400-8000-000000000001', 'FN-FRN-0001')
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.work_order_types (id, tenant_id, code, name, category) VALUES
  ('0197f000-0002-7500-8000-000000000001', '0197f000-0002-7000-8000-000000000002', 'COR', 'Corretiva', 'corrective')
ON CONFLICT (id) DO NOTHING;

INSERT INTO app.qr_tags (id, tenant_id, token, short_code)
SELECT v.id::uuid, '0197f000-0002-7000-8000-000000000002', v.token, v.payload || app.crockford_luhn32_check_char(v.payload)
  FROM (VALUES
    ('0197f000-0002-7700-8000-000000000001', '0FN000000000000000000000B1', 'FNBBBB1')
  ) AS v(id, token, payload)
ON CONFLICT (id) DO NOTHING;

COMMIT;
