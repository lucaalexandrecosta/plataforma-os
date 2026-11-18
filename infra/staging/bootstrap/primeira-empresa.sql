-- =============================================================================
-- Primeira empresa (tenant) e o administrador dela, no ambiente de testes.
-- Não há tela de cadastro de empresas ainda: o resto (equipe, técnicos,
-- clientes, bens) o administrador faz pelo backoffice. Idempotente: se a
-- empresa ou o e-mail já existem, nada muda.
--
-- Variáveis do psql: slug, nome, cnpj (pode ser vazio), admin_email, admin_nome.
-- Roda como superusuário, depois das migrações (scripts/migrar.sh).
-- =============================================================================
BEGIN;
SET LOCAL search_path = app, public;
SELECT set_config('app.actor_type', 'system', true),
       set_config('app.correlation_id', 'staging-bootstrap', true);

INSERT INTO app.tenants (slug, legal_name, display_name, document_number, status, plan_id)
SELECT :'slug', :'nome', :'nome', nullif(:'cnpj', ''), 'active', p.id
  FROM app.plans p
 WHERE p.code = 'professional'
ON CONFLICT (slug) DO NOTHING;

SELECT id AS tenant_id FROM app.tenants WHERE slug = :'slug' \gset
SELECT set_config('app.tenant_id', :'tenant_id', true);

INSERT INTO app.tenant_settings (tenant_id) VALUES (:'tenant_id')
ON CONFLICT (tenant_id) DO NOTHING;

INSERT INTO app.branches (tenant_id, code, legal_name, trade_name, document_number, is_default)
SELECT :'tenant_id', 'MATRIZ', :'nome', :'nome', nullif(:'cnpj', ''), true
 WHERE NOT EXISTS (SELECT 1 FROM app.branches WHERE tenant_id = :'tenant_id');

INSERT INTO app.users (user_type, full_name, email, email_verified_at, status)
SELECT 'staff', :'admin_nome', lower(:'admin_email'), now(), 'active'
 WHERE NOT EXISTS (SELECT 1 FROM app.users WHERE user_type = 'staff' AND lower(email) = lower(:'admin_email'));

SELECT id AS user_id FROM app.users WHERE user_type = 'staff' AND lower(email) = lower(:'admin_email') \gset

INSERT INTO app.tenant_memberships (tenant_id, user_id, status, joined_at)
VALUES (:'tenant_id', :'user_id', 'active', now())
ON CONFLICT (tenant_id, user_id) DO NOTHING;

INSERT INTO app.tenant_membership_roles (tenant_id, membership_id, role_code)
SELECT :'tenant_id', m.id, 'tenant_admin'
  FROM app.tenant_memberships m
 WHERE m.tenant_id = :'tenant_id' AND m.user_id = :'user_id'
ON CONFLICT (tenant_id, membership_id, role_code) DO NOTHING;

COMMIT;
