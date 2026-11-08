-- migrate:up transaction:false
-- =============================================================================
-- Migração inicial — GERADA por tool/db/build_initial_migration.mjs. Não editar.
-- Origem: db/schema.sql (sha256 3bfeeddae77181156b978cbbcaceceec7f201b5fccbf3edfcca394a5181138a8)
-- Precisa de um papel administrativo (superusuário em dev/CI; o admin do RDS
-- em homologação e produção), porque cria papéis-grupo e extensões.
-- =============================================================================
-- =============================================================================
-- plataforma-os — schema PostgreSQL de referência (DDL completo)
-- Versão 0.3 — 02/11/2026 — rascunho para revisão (stack Dart: Flutter + Serverpod)
-- Propósito: materializar o modelo de domínio de docs/03-modelo-de-dominio.md
-- (tabelas, invariantes, RLS multi-tenant, triggers e funções de apoio).
--
-- Execução (banco VAZIO, PostgreSQL 16+; recomendado 18):
--   psql -v ON_ERROR_STOP=1 -d <banco> -f db/schema.sql
-- Rodar com um papel administrativo: superusuário (dev/CI) ou o administrador
-- do serviço gerenciado com CREATEROLE e dono do banco. O script:
--   1) cria os papéis-grupo app_owner, app_runtime e app_system (NOLOGIN);
--   2) cria as extensões e o schema "app";
--   3) faz SET ROLE app_owner e cria os objetos (app_owner é o dono de tudo);
--   4) faz SET ROLE app_system só para criar as funções SECURITY DEFINER de
--      leitura entre tenants (resolução de QR, login de contato, claims).
-- Os usuários de conexão (LOGIN) NÃO são criados aqui: a infraestrutura
-- (docs/09-infraestrutura-e-operacao.md) cria, por exemplo, app_migrator
-- (membro de app_owner) e app_api/app_worker (membros de app_runtime), com
-- senhas no cofre de segredos.
--
-- Decisão de schema: todos os objetos de negócio ficam no schema "app" (dono
-- app_owner, sem CREATE para os papéis de runtime). Motivos: (a) search_path e
-- grants explícitos, sem depender dos privilégios históricos do "public";
-- (b) um único schema simplifica ORM/migrações — a separação entre dados de
-- tenant e dados globais é feita por RLS e grants, não por schema.
-- O schema "public" contém as extensões, as duas funções públicas de
-- resolução de QR exigidas pelo contrato (public.resolve_qr_token e
-- public.resolve_qr_short_code) e, a partir da v0.3, as tabelas internas do
-- Serverpod (serverpod_*), criadas e migradas pelo próprio Serverpod (seção 23).
--
-- Convenções (contrato D14; v0.3 conforme docs/12 §4.1 e ADR-019, tipos
-- compatíveis com o ORM do Serverpod, sem numeric):
--   * snake_case em inglês, tabelas no plural;
--   * timestamptz, com a sessão dos papéis de login fixada em UTC;
--   * dinheiro em CENTAVOS, bigint (int no Dart): R$ 12,34 = 1234;
--   * quantidades em MILÉSIMOS, bigint: 1,5 m = 1500; 1 UN = 1000;
--   * custo de provedor de mensagens (fração de centavo) em MICRO-unidades
--     da moeda, bigint: US$ 0,0079 = 7900 (notifications.provider_cost);
--   * medidas (latitude, longitude, precisão, distância, leituras e intervalos
--     de medidor) em double precision (double no Dart);
--   * duração calculada de apontamento em minutos inteiros (integer);
--   * a unidade de cada coluna convertida está no COMMENT dela; no JSON
--     externo (webhooks, ERP) o adaptador converte para decimal;
--   * tipos discretos como text + CHECK (sem ENUM nativo);
--   * UUID v7 gerado pela aplicação (UuidValue, defaultModel = random_v7 no
--     Serverpod; o DEFAULT app.uuid_v7() existe para inserts feitos no banco).
-- Tabelas de tenant: tenant_id NOT NULL, UNIQUE (tenant_id, id), FKs compostas
-- (tenant_id, x_id) e RLS ENABLE + FORCE (laço automático na seção 22).
-- Migrações: dbmate com SQL puro (docs/02); este arquivo é a referência do
-- schema completo e a migração inicial é gerada a partir dele. Os modelos
-- .spy.yaml do Serverpod espelham estas tabelas com managedMigration: false
-- (o Serverpod não gera DDL para elas) e o CI confere modelos x banco.
--
-- Variáveis de sessão (definidas pela API/worker a cada transação, com
-- set_config(..., true) no databaseInterceptor do Serverpod):
--   app.tenant_id       uuid do tenant ativo (obrigatória para dados de tenant)
--   app.user_id         uuid de users.id do ator autenticado (auditoria e
--                       leitura dos próprios vínculos antes de escolher tenant)
--   app.actor_type      opcional: user | customer_contact | technician |
--                       system | integration | platform_support
--   app.correlation_id  opcional: id de correlação da requisição/job
--
-- v0.2 (docs/11-benchmark-sismetro-e-novas-funcionalidades.md, apêndice A):
-- filiais, vendedores, prestadores e tarifas, plantão e escalonamento, custos
-- da OS, resolução remota, movimentação com aprovação, ativos vindos do ERP
-- (MVP); fechamento de prestadores, planos de manutenção, medidores e leituras
-- (F2); dispositivos IoT, regras de alerta e vendas por cliente (F3). As
-- tabelas F2/F3 já são criadas agora (COMMENT indica a fase) para que as
-- migrações futuras sejam só de dados e de código.
--
-- Status de validação (02/11/2026, v0.3): executado sem erros em PostgreSQL 18
-- (PGlite/WebAssembly) num banco vazio; 87 tabelas (81 de tenant); nenhuma
-- coluna numeric; 0 tabelas de tenant sem ENABLE+FORCE+política; 0 FKs entre
-- tabelas de tenant sem tenant_id (de 272); funções SECURITY DEFINER com
-- search_path fixo; 23 tabelas sincronizadas; 40 testes funcionais passaram
-- (regressão da v0.1 e da v0.2 restaurada: RLS, FKs compostas, QR, numeração,
-- máquina de estados, alocação, etiquetas, auditoria, vínculos, funções definer,
-- dispositivos, escopo de sync, registros a revisar, suporte, outbox, resolução
-- remota, movimentação, prestadores, custos, planos, medidores, bens do ERP; e
-- 2 da v0.3: dinheiro em centavos e quantidade em milésimos).
-- Detalhes em docs/03-modelo-de-dominio.md §11.5.
-- Pendente: rodar no RDS for PostgreSQL 18 com os usuários LOGIN reais e o
-- spike S2 (ORM do Serverpod nas tabelas com managedMigration: false).
-- =============================================================================

BEGIN;

-- =============================================================================
-- 1. Papéis-grupo
-- =============================================================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_owner') THEN
    CREATE ROLE app_owner NOLOGIN;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_runtime') THEN
    CREATE ROLE app_runtime NOLOGIN NOBYPASSRLS;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_system') THEN
    CREATE ROLE app_system NOLOGIN NOBYPASSRLS;
  END IF;
END
$$;

COMMENT ON ROLE app_owner IS
  'Dono do schema app e de todas as tabelas; usado apenas por migrações. Sujeito a RLS (FORCE).';
COMMENT ON ROLE app_runtime IS
  'Papel da API e do worker: só DML necessário, sem BYPASSRLS, não é dono de nenhuma tabela.';
COMMENT ON ROLE app_system IS
  'Dono exclusivo das funções SECURITY DEFINER que leem entre tenants (QR, login de contato, claims de outbox/jobs). NOLOGIN, sem BYPASSRLS; enxerga todas as linhas apenas nas tabelas em que possui política explícita.';

-- O administrador que executa o script precisa poder fazer SET ROLE app_owner.
GRANT app_owner TO CURRENT_USER;
-- app_owner pode assumir app_system (para criar/alterar as funções definer),
-- mas não herda as políticas de app_system (INHERIT FALSE, sintaxe PG16+).
GRANT app_system TO app_owner WITH INHERIT FALSE;

-- =============================================================================
-- 2. Extensões (somente as usadas de fato)
--   btree_gist: constraints de exclusão com igualdade em uuid + sobreposição de
--               intervalos (apontamentos sem sobreposição por técnico, alocação
--               de ativo sem sobreposição, escalas sem sobreposição).
--   pg_trgm:    busca "contém" no backoffice (nome de cliente, produto, série).
--   gen_random_uuid() é nativo desde o PG13 (sem pgcrypto).
-- =============================================================================
CREATE EXTENSION IF NOT EXISTS btree_gist WITH SCHEMA public;
CREATE EXTENSION IF NOT EXISTS pg_trgm   WITH SCHEMA public;

-- =============================================================================
-- 3. Schema
-- =============================================================================
CREATE SCHEMA IF NOT EXISTS app AUTHORIZATION app_owner;
COMMENT ON SCHEMA app IS 'Objetos de negócio da plataforma-os (dados globais e de tenant).';

-- app_system precisa de CREATE em public para ser dono das funções públicas de
-- resolução de QR (no PG15+ o PUBLIC já não tem CREATE em public).
GRANT USAGE, CREATE ON SCHEMA public TO app_system;

SET ROLE app_owner;
SET search_path = app, public, pg_catalog;

GRANT USAGE ON SCHEMA app TO app_runtime;
GRANT USAGE, CREATE ON SCHEMA app TO app_system;

-- =============================================================================
-- 4. Funções utilitárias (sem acesso a tabelas)
-- =============================================================================

-- UUID v7 (RFC 9562): 48 bits de timestamp em ms + versão 7 + bits aleatórios.
-- A aplicação gera os IDs (inclusive offline); este DEFAULT cobre inserts do
-- próprio banco (triggers, seeds, migrações). No PG18 pode ser trocado por uuidv7().
CREATE FUNCTION app.uuid_v7() RETURNS uuid
LANGUAGE sql VOLATILE PARALLEL SAFE
AS $$
  SELECT encode(
           set_bit(
             set_bit(
               overlay(uuid_send(gen_random_uuid())
                       PLACING substring(int8send((extract(epoch FROM clock_timestamp()) * 1000)::bigint) FROM 3)
                       FROM 1 FOR 6),
               52, 1),
             53, 1),
           'hex')::uuid
$$;
COMMENT ON FUNCTION app.uuid_v7() IS 'Gera UUID v7 (ordenável por tempo). Fallback do banco; a aplicação gera os IDs.';

-- Tenant ativo da transação. Ausente, vazio ou malformado => NULL (nenhuma linha
-- visível), sem erro de cast. Observação: após um SET LOCAL, o valor da sessão
-- volta a ser '' (string vazia), por isso o teste por regex.
CREATE FUNCTION app.current_tenant_id() RETURNS uuid
LANGUAGE sql STABLE PARALLEL SAFE
AS $$
  SELECT CASE
           WHEN current_setting('app.tenant_id', true) ~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
           THEN current_setting('app.tenant_id', true)::uuid
         END
$$;
COMMENT ON FUNCTION app.current_tenant_id() IS 'uuid de app.tenant_id ou NULL; usada em todas as políticas de RLS.';

CREATE FUNCTION app.current_user_id() RETURNS uuid
LANGUAGE sql STABLE PARALLEL SAFE
AS $$
  SELECT CASE
           WHEN current_setting('app.user_id', true) ~* '^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
           THEN current_setting('app.user_id', true)::uuid
         END
$$;
COMMENT ON FUNCTION app.current_user_id() IS 'uuid de app.user_id (ator autenticado) ou NULL (ator de sistema).';

-- Normaliza entrada em base32 Crockford: maiúsculas, I/L -> 1, O -> 0, remove
-- hífens e espaços (o short code é exibido como XXXX-XXXX).
CREATE FUNCTION app.normalize_crockford_base32(p_value text) RETURNS text
LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
AS $$
  SELECT translate(upper(p_value), 'ILO- ', '110')
$$;
COMMENT ON FUNCTION app.normalize_crockford_base32(text) IS 'Normaliza token/short code base32 Crockford digitado ou lido do QR.';

-- v0.3 (docs/12 §4.1, ADR-019): dinheiro em centavos e quantidade em milésimos,
-- ambos bigint (int no Dart). Valor da linha = quantidade x preço unitário,
-- com arredondamento ao centavo (meio para longe do zero, como round(numeric)).
-- O cálculo intermediário em numeric evita estouro e erro de ponto flutuante;
-- o resultado volta a bigint. Usada em colunas geradas e CHECKs (IMMUTABLE).
CREATE FUNCTION app.line_amount_cents(p_quantity_milli bigint, p_unit_cents bigint) RETURNS bigint
LANGUAGE sql IMMUTABLE STRICT PARALLEL SAFE
AS $$
  SELECT round((p_quantity_milli::numeric * p_unit_cents::numeric) / 1000)::bigint
$$;
COMMENT ON FUNCTION app.line_amount_cents(bigint, bigint) IS 'Valor da linha em centavos: quantidade (milésimos) x preço unitário (centavos) / 1000, arredondado ao centavo. Ex.: 1500 (1,5 un) x 1234 (R$ 12,34) = 1851 (R$ 18,51).';

-- Sequence global do cursor incremental de sincronização (contrato D11).
CREATE SEQUENCE app.sync_row_version_seq AS bigint START WITH 1 INCREMENT BY 1 NO CYCLE;
COMMENT ON SEQUENCE app.sync_row_version_seq IS 'Fonte de row_version de todas as tabelas sincronizadas com o app do técnico.';

-- =============================================================================
-- 5. Funções de trigger genéricas (plpgsql: validadas na execução, não na criação)
-- =============================================================================

-- Colunas padrão: created_*/updated_*/version (concorrência otimista, D12).
CREATE FUNCTION app.tg_set_standard_columns() RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.created_at := coalesce(NEW.created_at, now());
    NEW.updated_at := NEW.created_at;
    NEW.created_by := coalesce(NEW.created_by, app.current_user_id());
    NEW.updated_by := coalesce(NEW.updated_by, NEW.created_by);
    NEW.version    := 1;
  ELSE
    NEW.created_at := OLD.created_at;
    NEW.created_by := OLD.created_by;
    NEW.updated_at := now();
    IF NEW.updated_by IS NOT DISTINCT FROM OLD.updated_by THEN
      NEW.updated_by := app.current_user_id();
    END IF;
    NEW.version := OLD.version + 1;
  END IF;
  RETURN NEW;
END
$$;
COMMENT ON FUNCTION app.tg_set_standard_columns() IS 'BEFORE INSERT/UPDATE: preenche created_*/updated_* e incrementa version.';

-- row_version + sync_xid nas tabelas sincronizadas (cursor do pull, D11).
CREATE FUNCTION app.tg_bump_row_version() RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.row_version := nextval('app.sync_row_version_seq');
  NEW.sync_xid    := pg_current_xact_id();
  RETURN NEW;
END
$$;
COMMENT ON FUNCTION app.tg_bump_row_version() IS 'BEFORE INSERT/UPDATE: novo row_version (sequence global) e xid da transação escritora.';

-- Exclusão física em tabela sincronizada => tombstone para todos os dispositivos.
CREATE FUNCTION app.tg_sync_tombstone_on_delete() RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  INSERT INTO app.sync_tombstones (tenant_id, entity_type, entity_id, technician_id, reason)
  VALUES (OLD.tenant_id, TG_TABLE_NAME, OLD.id, NULL, 'deleted');
  RETURN NULL;
END
$$;
COMMENT ON FUNCTION app.tg_sync_tombstone_on_delete() IS 'AFTER DELETE: grava tombstone (reason=deleted) para o pull do app do técnico.';

-- Short code: 7 caracteres aleatórios + 1 verificador Luhn mod 32 sobre o
-- alfabeto Crockford (docs/05-ativos-e-qr-code.md). IMMUTABLE para uso em CHECK.
CREATE FUNCTION app.crockford_luhn32_is_valid(p_code text) RETURNS boolean
LANGUAGE plpgsql IMMUTABLE STRICT PARALLEL SAFE
AS $$
DECLARE
  c_alphabet constant text := '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
  v_factor int := 1;
  v_sum    int := 0;
  v_addend int;
  i        int;
BEGIN
  IF p_code !~ '^[0-9A-HJKMNP-TV-Z]{2,}$' THEN
    RETURN false;
  END IF;
  FOR i IN REVERSE length(p_code)..1 LOOP
    v_addend := v_factor * (strpos(c_alphabet, substr(p_code, i, 1)) - 1);
    v_factor := CASE WHEN v_factor = 2 THEN 1 ELSE 2 END;
    v_sum := v_sum + (v_addend / 32) + (v_addend % 32);
  END LOOP;
  RETURN v_sum % 32 = 0;
END
$$;
COMMENT ON FUNCTION app.crockford_luhn32_is_valid(text) IS 'Valida o dígito verificador Luhn mod 32 (alfabeto Crockford) do short code.';

CREATE FUNCTION app.crockford_luhn32_check_char(p_payload text) RETURNS text
LANGUAGE plpgsql IMMUTABLE STRICT PARALLEL SAFE
AS $$
DECLARE
  c_alphabet constant text := '0123456789ABCDEFGHJKMNPQRSTVWXYZ';
  v_factor int := 2;
  v_sum    int := 0;
  v_addend int;
  i        int;
BEGIN
  IF p_payload !~ '^[0-9A-HJKMNP-TV-Z]+$' THEN
    RAISE EXCEPTION 'payload fora do alfabeto Crockford: %', p_payload USING ERRCODE = 'invalid_parameter_value';
  END IF;
  FOR i IN REVERSE length(p_payload)..1 LOOP
    v_addend := v_factor * (strpos(c_alphabet, substr(p_payload, i, 1)) - 1);
    v_factor := CASE WHEN v_factor = 2 THEN 1 ELSE 2 END;
    v_sum := v_sum + (v_addend / 32) + (v_addend % 32);
  END LOOP;
  RETURN substr(c_alphabet, ((32 - (v_sum % 32)) % 32) + 1, 1);
END
$$;
COMMENT ON FUNCTION app.crockford_luhn32_check_char(text) IS 'Calcula o caractere verificador Luhn mod 32 (a aplicação gera o short code; usado em seeds e testes).';

-- Contexto de plataforma (/api/v1/platform/*): a API faz SET LOCAL app.platform_scope = 'on'
-- somente para platform_admin autenticado. Libera leitura/escrita de dados GLOBAIS
-- (tenants, users, audit de plataforma); nunca libera linhas de tenant.
CREATE FUNCTION app.is_platform_context() RETURNS boolean
LANGUAGE sql STABLE PARALLEL SAFE
AS $$
  SELECT coalesce(current_setting('app.platform_scope', true), '') = 'on'
$$;
COMMENT ON FUNCTION app.is_platform_context() IS 'true quando a transação está em contexto de administração da plataforma (app.platform_scope = on).';

-- Guarda de campos mestres do ERP (D10): se a linha veio do ERP (source = erp),
-- só o ator "integration" altera as colunas passadas em TG_ARGV.
CREATE FUNCTION app.tg_guard_erp_master_fields() RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  v_col text;
  v_old jsonb := to_jsonb(OLD);
  v_new jsonb := to_jsonb(NEW);
BEGIN
  IF OLD.source = 'erp' AND coalesce(current_setting('app.actor_type', true), '') <> 'integration' THEN
    FOREACH v_col IN ARRAY TG_ARGV LOOP
      IF (v_new -> v_col) IS DISTINCT FROM (v_old -> v_col) THEN
        RAISE EXCEPTION 'O campo %.% é mestre do ERP e é somente leitura (registro %)', TG_TABLE_NAME, v_col, OLD.id
          USING ERRCODE = 'insufficient_privilege';
      END IF;
    END LOOP;
  END IF;
  RETURN NEW;
END
$$;
COMMENT ON FUNCTION app.tg_guard_erp_master_fields() IS 'BEFORE UPDATE: impede alterar campos mestres de registros com source = erp fora do ator integration.';

-- Auditoria genérica (antes/depois em jsonb). Ignora colunas técnicas.
CREATE FUNCTION app.tg_audit_row() RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  c_ignore constant text[] := ARRAY['updated_at','updated_by','version','row_version','sync_xid','external_payload','last_synced_at'];
  v_old jsonb;
  v_new jsonb;
  v_changed text[];
  v_row jsonb;
BEGIN
  IF TG_OP IN ('UPDATE', 'DELETE') THEN v_old := to_jsonb(OLD); END IF;
  IF TG_OP IN ('INSERT', 'UPDATE') THEN v_new := to_jsonb(NEW); END IF;
  IF TG_OP = 'UPDATE' THEN
    SELECT array_agg(k ORDER BY k) INTO v_changed
      FROM jsonb_object_keys(v_new) AS k
     WHERE k <> ALL (c_ignore)
       AND (v_new -> k) IS DISTINCT FROM (v_old -> k);
    IF v_changed IS NULL THEN
      RETURN NULL;
    END IF;
  END IF;
  v_row := coalesce(v_new, v_old);
  INSERT INTO app.audit_logs (tenant_id, actor_type, actor_user_id, action, entity_type, entity_id,
                              before_data, after_data, changed_fields, correlation_id)
  VALUES ((v_row ->> 'tenant_id')::uuid,
          coalesce(nullif(current_setting('app.actor_type', true), ''), 'user'),
          app.current_user_id(),
          TG_TABLE_NAME || '.' || lower(TG_OP),
          TG_TABLE_NAME,
          (v_row ->> 'id')::uuid,
          v_old, v_new, v_changed,
          nullif(current_setting('app.correlation_id', true), ''));
  RETURN NULL;
END
$$;
COMMENT ON FUNCTION app.tg_audit_row() IS 'AFTER INSERT/UPDATE/DELETE: grava audit_logs com antes/depois e campos alterados.';

-- =============================================================================
-- 6. Plataforma e tenancy (módulo tenancy)
-- =============================================================================

CREATE TABLE app.plans (
  id          uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  code        text NOT NULL UNIQUE CHECK (code ~ '^[a-z0-9_]{2,40}$'),
  name        text NOT NULL,
  limits      jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(limits) = 'object'),
  features    jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(features) = 'object'),
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  created_by  uuid,
  updated_by  uuid,
  version     integer NOT NULL DEFAULT 1
);
COMMENT ON TABLE app.plans IS 'Plano comercial (global). limits: ex. {"max_assets":20000,"max_technicians":200}.';

CREATE TABLE app.tenants (
  id                  uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  slug                text NOT NULL UNIQUE CHECK (slug ~ '^[a-z0-9][a-z0-9-]{1,38}[a-z0-9]$'),
  legal_name          text NOT NULL,
  display_name        text NOT NULL,
  document_number     text,
  status              text NOT NULL DEFAULT 'trial' CHECK (status IN ('trial', 'active', 'suspended', 'cancelled')),
  plan_id             uuid NOT NULL REFERENCES app.plans (id),
  idp_organization_id text UNIQUE,
  deployment_cell     text NOT NULL DEFAULT 'shared',
  trial_ends_at       timestamptz,
  suspended_at        timestamptz,
  cancelled_at        timestamptz,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  created_by          uuid,
  updated_by          uuid,
  version             integer NOT NULL DEFAULT 1
);
CREATE INDEX tenants_plan_id_idx ON app.tenants (plan_id);
COMMENT ON TABLE app.tenants IS 'Empresa assinante (global; o próprio id é o tenant_id). Catálogo de tenants e caminho para silo.';
COMMENT ON COLUMN app.tenants.idp_organization_id IS 'Id da Organization no Keycloak (equipe interna).';
COMMENT ON COLUMN app.tenants.deployment_cell IS 'shared (banco compartilhado) ou identificador do banco dedicado (silo, fase 3).';

CREATE TABLE app.tenant_settings (
  id                                uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id                         uuid NOT NULL UNIQUE REFERENCES app.tenants (id),
  timezone                          text NOT NULL DEFAULT 'America/Sao_Paulo',
  locale                            text NOT NULL DEFAULT 'pt-BR',
  currency_code                     char(3) NOT NULL DEFAULT 'BRL',
  require_backoffice_review         boolean NOT NULL DEFAULT true,
  work_order_number_format          text NOT NULL DEFAULT '{YYYY}-{SEQ}' CHECK (position('{SEQ}' IN work_order_number_format) > 0),
  work_order_number_padding         smallint NOT NULL DEFAULT 6 CHECK (work_order_number_padding BETWEEN 3 AND 12),
  work_order_number_reset           text NOT NULL DEFAULT 'yearly' CHECK (work_order_number_reset IN ('yearly', 'never')),
  default_business_calendar_id      uuid,
  sla_time_basis                    text NOT NULL DEFAULT 'business_hours' CHECK (sla_time_basis IN ('business_hours', 'calendar')),
  duplicate_window_hours            integer NOT NULL DEFAULT 72 CHECK (duplicate_window_hours >= 0),
  reopen_window_days                integer NOT NULL DEFAULT 30 CHECK (reopen_window_days >= 0),
  time_entry_approval_required      boolean NOT NULL DEFAULT true,
  allow_unregistered_contacts       boolean NOT NULL DEFAULT false,
  max_self_service_requests_per_day smallint NOT NULL DEFAULT 2 CHECK (max_self_service_requests_per_day >= 0),
  otp_channels                      text[] NOT NULL DEFAULT ARRAY['whatsapp', 'sms', 'email']
                                    CHECK (otp_channels <@ ARRAY['whatsapp', 'sms', 'email']),
  branding                          jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(branding) = 'object'),
  customer_app                      jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(customer_app) = 'object'),
  triage_mode                       text NOT NULL DEFAULT 'central' CHECK (triage_mode IN ('central', 'sales_rep_first', 'direct')),
  sales_rep_triage_timeout_minutes  integer NOT NULL DEFAULT 60 CHECK (sales_rep_triage_timeout_minutes BETWEEN 5 AND 1440),
  require_qr_check_in               boolean NOT NULL DEFAULT false,
  require_movement_approval         boolean NOT NULL DEFAULT false,
  created_at                        timestamptz NOT NULL DEFAULT now(),
  updated_at                        timestamptz NOT NULL DEFAULT now(),
  created_by                        uuid,
  updated_by                        uuid,
  version                           integer NOT NULL DEFAULT 1
);
COMMENT ON TABLE app.tenant_settings IS 'Configurações do tenant (1 linha por tenant): fuso, numeração da OS, conferência do backoffice, SLA, app do cliente, branding.';
COMMENT ON COLUMN app.tenant_settings.require_backoffice_review IS 'Se false, completed -> closed automaticamente (D9).';
COMMENT ON COLUMN app.tenant_settings.work_order_number_format IS 'Marcadores {YYYY} e {SEQ} (obrigatório). Ex.: {YYYY}-{SEQ} => 2026-000123.';
COMMENT ON COLUMN app.tenant_settings.triage_mode IS 'v0.2 (MVP). central: todo chamado cai na fila do despacho; sales_rep_first: chamado de cliente com vendedor (customers.primary_sales_rep_id) passa primeiro pelo vendedor e sobe para a fila central após sales_rep_triage_timeout_minutes sem resposta; direct: clientes ou tipos com skip_triage vão direto ao técnico ou prestador da região.';
COMMENT ON COLUMN app.tenant_settings.sales_rep_triage_timeout_minutes IS 'v0.2 (MVP). Prazo da pré-triagem pelo vendedor no modo sales_rep_first, contado de work_orders.created_at.';
COMMENT ON COLUMN app.tenant_settings.require_qr_check_in IS 'v0.2 (MVP, antifraude). true: o check-in da visita exige a leitura do QR do ativo da OS (check_in_method = qr); GPS/manual só com justificativa e sinalização. work_order_types.require_qr_check_in sobrescreve por tipo.';
COMMENT ON COLUMN app.tenant_settings.require_movement_approval IS 'v0.2 (MVP). true: alocações novas nascem com asset_assignments.approval_status = pending e só passam a valer quando aprovadas.';

CREATE TABLE app.tenant_sequences (
  id            uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id     uuid NOT NULL REFERENCES app.tenants (id),
  sequence_key  text NOT NULL CHECK (sequence_key ~ '^[a-z_]{2,40}$'),
  period_key    text NOT NULL DEFAULT '',
  last_value    bigint NOT NULL DEFAULT 0 CHECK (last_value >= 0),
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid,
  updated_by    uuid,
  version       integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, sequence_key, period_key)
);
COMMENT ON TABLE app.tenant_sequences IS 'Contadores por tenant/chave/período (ex.: work_order/2026). Incremento atômico via app.next_tenant_sequence.';

-- Próximo valor, seguro sob concorrência: o upsert trava a linha até o COMMIT,
-- então duas transações nunca recebem o mesmo número; rollback não gera lacuna.
CREATE FUNCTION app.next_tenant_sequence(p_key text, p_period text DEFAULT '') RETURNS bigint
LANGUAGE sql VOLATILE
AS $$
  INSERT INTO app.tenant_sequences AS s (tenant_id, sequence_key, period_key, last_value)
  VALUES (app.current_tenant_id(), p_key, coalesce(p_period, ''), 1)
  ON CONFLICT (tenant_id, sequence_key, period_key)
  DO UPDATE SET last_value = s.last_value + 1
  RETURNING s.last_value
$$;
COMMENT ON FUNCTION app.next_tenant_sequence(text, text) IS 'Próximo número da sequência do tenant ativo (sem lacunas; serializa por chave/período).';

-- v0.2 (MVP): filiais (mais de um CNPJ por tenant). Todo tenant nasce com uma
-- filial padrão (is_default) no provisionamento; branch_id nas tabelas de
-- negócio é nulo só em dados anteriores à v0.2 (a aplicação usa a padrão).
CREATE TABLE app.branches (
  id                 uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id          uuid NOT NULL REFERENCES app.tenants (id),
  code               text NOT NULL,
  legal_name         text NOT NULL,
  trade_name         text,
  document_number    text,
  state_registration text,
  street             text,
  street_number      text,
  complement         text,
  district           text,
  city               text,
  state              text,
  postal_code        text,
  phone              text,
  email              text,
  erp_branch_code    text,
  is_default         boolean NOT NULL DEFAULT false,
  is_active          boolean NOT NULL DEFAULT true,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  created_by         uuid,
  updated_by         uuid,
  version            integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  CHECK (NOT is_default OR is_active)
);
CREATE UNIQUE INDEX branches_default_key ON app.branches (tenant_id) WHERE is_default;
CREATE UNIQUE INDEX branches_document_key ON app.branches (tenant_id, document_number) WHERE document_number IS NOT NULL;
CREATE UNIQUE INDEX branches_erp_code_key ON app.branches (tenant_id, erp_branch_code) WHERE erp_branch_code IS NOT NULL;
COMMENT ON TABLE app.branches IS 'v0.2 (MVP, módulo tenancy). Filial do tenant (CNPJ, IE, endereço, código no ERP). Define a filial do pedido no ERP (fonte principal, no lugar do mapeamento service_area_branch) e permite limitar o escopo de usuários a filiais. Uma filial padrão por tenant.';
COMMENT ON COLUMN app.branches.erp_branch_code IS 'Código da filial no ERP (Senior: código da filial/empresa), usado no pedido de serviço, na requisição de materiais e no fechamento de prestadores.';

-- =============================================================================
-- 7. Identidade e acesso — tabelas base (módulo identity_access)
-- =============================================================================

CREATE TABLE app.users (
  id                uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  user_type         text NOT NULL CHECK (user_type IN ('staff', 'customer_contact')),
  idp_subject       text UNIQUE,
  full_name         text NOT NULL,
  email             text,
  email_verified_at timestamptz,
  phone_e164        text CHECK (phone_e164 ~ '^\+[1-9][0-9]{7,14}$'),
  phone_verified_at timestamptz,
  status            text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'disabled', 'blocked')),
  is_platform_admin boolean NOT NULL DEFAULT false,
  locale            text NOT NULL DEFAULT 'pt-BR',
  last_login_at     timestamptz,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  created_by        uuid,
  updated_by        uuid,
  version           integer NOT NULL DEFAULT 1,
  CHECK (user_type = 'staff' OR idp_subject IS NULL),
  CHECK (NOT is_platform_admin OR user_type = 'staff')
);
CREATE UNIQUE INDEX users_staff_email_key ON app.users (lower(email)) WHERE user_type = 'staff' AND email IS NOT NULL;
CREATE INDEX users_phone_idx ON app.users (phone_e164) WHERE phone_e164 IS NOT NULL;
COMMENT ON TABLE app.users IS 'Identidade global (uma pessoa pode estar em vários tenants). Senhas nunca ficam aqui: equipe autentica no IdP (idp_subject); contatos, por OTP.';

CREATE TABLE app.roles (
  id          uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  code        text NOT NULL UNIQUE CHECK (code IN ('platform_admin', 'tenant_admin', 'dispatcher', 'backoffice_agent',
                                                   'manager', 'technician', 'customer_contact', 'customer_admin',
                                                   'sales_rep', 'provider_admin')),
  name        text NOT NULL,
  scope       text NOT NULL CHECK (scope IN ('platform', 'tenant', 'customer')),
  description text,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  created_by  uuid,
  updated_by  uuid,
  version     integer NOT NULL DEFAULT 1
);
COMMENT ON TABLE app.roles IS 'Papéis canônicos do RBAC (global; papéis customizados por tenant são fase 3). v0.2 (MVP): sales_rep (vendedor; carteira = customers.primary_sales_rep_id do sales_reps ligado ao usuário) e provider_admin (gestor do prestador; OS e técnicos de tenant_memberships.service_provider_id). Esses dois escopos são de APLICAÇÃO: a RLS continua isolando só por tenant (tenant_isolation), e a API acrescenta o filtro de carteira/prestador em toda consulta e comando desses papéis (docs/04).';

CREATE TABLE app.permissions (
  id          uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  code        text NOT NULL UNIQUE CHECK (code ~ '^[a-z_]+\.[a-z_]+$'),
  module      text NOT NULL,
  description text,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  created_by  uuid,
  updated_by  uuid,
  version     integer NOT NULL DEFAULT 1
);
COMMENT ON TABLE app.permissions IS 'Permissões (<recurso>.<ação>) verificadas pela API; seed versionado em migrações.';

CREATE TABLE app.role_permissions (
  role_id       uuid NOT NULL REFERENCES app.roles (id) ON DELETE CASCADE,
  permission_id uuid NOT NULL REFERENCES app.permissions (id) ON DELETE CASCADE,
  created_at    timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (role_id, permission_id)
);
CREATE INDEX role_permissions_permission_id_idx ON app.role_permissions (permission_id);
COMMENT ON TABLE app.role_permissions IS 'Matriz papel x permissão (global).';

CREATE TABLE app.tenant_memberships (
  id             uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id      uuid NOT NULL REFERENCES app.tenants (id),
  user_id        uuid NOT NULL REFERENCES app.users (id),
  status         text NOT NULL DEFAULT 'invited' CHECK (status IN ('invited', 'active', 'suspended', 'removed')),
  invited_at     timestamptz,
  invited_by     uuid,
  joined_at      timestamptz,
  removed_at     timestamptz,
  last_access_at timestamptz,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now(),
  created_by     uuid,
  updated_by     uuid,
  version        integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, user_id)
);
CREATE INDEX tenant_memberships_user_id_idx ON app.tenant_memberships (user_id);
COMMENT ON TABLE app.tenant_memberships IS 'Vínculo usuário (equipe interna) x tenant. O usuário lê os próprios vínculos de todos os tenants (política own_memberships_read) para escolher o tenant.';

CREATE TABLE app.tenant_membership_roles (
  id            uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id     uuid NOT NULL REFERENCES app.tenants (id),
  membership_id uuid NOT NULL,
  role_code     text NOT NULL REFERENCES app.roles (code),
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid,
  updated_by    uuid,
  version       integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, membership_id, role_code),
  FOREIGN KEY (tenant_id, membership_id) REFERENCES app.tenant_memberships (tenant_id, id) ON DELETE CASCADE,
  CHECK (role_code IN ('tenant_admin', 'dispatcher', 'backoffice_agent', 'manager', 'technician', 'sales_rep', 'provider_admin'))
);
CREATE INDEX tenant_membership_roles_role_idx ON app.tenant_membership_roles (tenant_id, role_code);
COMMENT ON TABLE app.tenant_membership_roles IS 'Papéis do vínculo no tenant (só papéis de equipe; papéis de contato ficam em customer_contacts.contact_role).';

-- Chaves de idempotência das requisições HTTP (Idempotency-Key, D12), gravadas
-- na mesma transação do caso de uso.
CREATE TABLE app.idempotency_keys (
  id              uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id       uuid NOT NULL REFERENCES app.tenants (id),
  scope           text NOT NULL,
  idempotency_key text NOT NULL CHECK (length(idempotency_key) BETWEEN 8 AND 200),
  actor_id        uuid,
  request_hash    bytea NOT NULL,
  status          text NOT NULL DEFAULT 'in_progress' CHECK (status IN ('in_progress', 'completed')),
  response_status smallint,
  response_body   jsonb,
  resource_type   text,
  resource_id     uuid,
  expires_at      timestamptz NOT NULL,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid,
  updated_by      uuid,
  version         integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, scope, idempotency_key)
);
CREATE INDEX idempotency_keys_expires_at_idx ON app.idempotency_keys (expires_at);
COMMENT ON TABLE app.idempotency_keys IS 'Idempotency-Key de POSTs (mobile e integrações): mesma chave + mesmo hash => mesma resposta. Expurgo diário por expires_at.';

-- =============================================================================
-- 8. Calendários e regiões (módulo scheduling)
-- =============================================================================

CREATE TABLE app.business_calendars (
  id          uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id   uuid NOT NULL REFERENCES app.tenants (id),
  name        text NOT NULL,
  timezone    text NOT NULL DEFAULT 'America/Sao_Paulo',
  is_default  boolean NOT NULL DEFAULT false,
  is_active   boolean NOT NULL DEFAULT true,
  created_at  timestamptz NOT NULL DEFAULT now(),
  updated_at  timestamptz NOT NULL DEFAULT now(),
  created_by  uuid,
  updated_by  uuid,
  version     integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, name)
);
CREATE UNIQUE INDEX business_calendars_default_key ON app.business_calendars (tenant_id) WHERE is_default;
COMMENT ON TABLE app.business_calendars IS 'Calendário de expediente e feriados (base das horas úteis do SLA e dos turnos).';

CREATE TABLE app.business_calendar_hours (
  id                   uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id            uuid NOT NULL REFERENCES app.tenants (id),
  business_calendar_id uuid NOT NULL,
  weekday              smallint NOT NULL CHECK (weekday BETWEEN 1 AND 7),
  start_time           time NOT NULL,
  end_time             time NOT NULL,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),
  created_by           uuid,
  updated_by           uuid,
  version              integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, business_calendar_id) REFERENCES app.business_calendars (tenant_id, id) ON DELETE CASCADE,
  CHECK (end_time > start_time)
);
CREATE INDEX business_calendar_hours_calendar_idx ON app.business_calendar_hours (tenant_id, business_calendar_id, weekday);
COMMENT ON TABLE app.business_calendar_hours IS 'Janelas de expediente por dia da semana (ISO 1=segunda .. 7=domingo).';

CREATE TABLE app.holidays (
  id                   uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id            uuid NOT NULL REFERENCES app.tenants (id),
  business_calendar_id uuid NOT NULL,
  holiday_date         date NOT NULL,
  name                 text NOT NULL,
  is_recurring         boolean NOT NULL DEFAULT false,
  start_time           time,
  end_time             time,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),
  created_by           uuid,
  updated_by           uuid,
  version              integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, business_calendar_id, holiday_date),
  FOREIGN KEY (tenant_id, business_calendar_id) REFERENCES app.business_calendars (tenant_id, id) ON DELETE CASCADE,
  CHECK ((start_time IS NULL) = (end_time IS NULL)),
  CHECK (end_time IS NULL OR end_time > start_time)
);
COMMENT ON TABLE app.holidays IS 'Feriados/pontos facultativos. is_recurring: repete todo ano (dia/mês). start/end_time: meio expediente.';

CREATE TABLE app.service_areas (
  id                   uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id            uuid NOT NULL REFERENCES app.tenants (id),
  code                 text NOT NULL,
  name                 text NOT NULL,
  description          text,
  business_calendar_id uuid,
  postal_code_prefixes text[] NOT NULL DEFAULT '{}',
  geo_boundary         jsonb,
  is_active            boolean NOT NULL DEFAULT true,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),
  created_by           uuid,
  updated_by           uuid,
  version              integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  FOREIGN KEY (tenant_id, business_calendar_id) REFERENCES app.business_calendars (tenant_id, id)
);
CREATE INDEX service_areas_calendar_idx ON app.service_areas (tenant_id, business_calendar_id);
COMMENT ON TABLE app.service_areas IS 'Região de atendimento. geo_boundary (GeoJSON) é fase 3 (roteirização/PostGIS).';

ALTER TABLE app.tenant_settings
  ADD FOREIGN KEY (tenant_id, default_business_calendar_id) REFERENCES app.business_calendars (tenant_id, id);
CREATE INDEX tenant_settings_calendar_idx ON app.tenant_settings (tenant_id, default_business_calendar_id);

-- =============================================================================
-- 9. Clientes (módulo customers) — dados mestres ERP x locais (D10)
-- Colunas mestres comuns: source, external_system, external_id, external_payload,
-- external_hash (docs/07), last_synced_at; único (tenant_id, external_system,
-- external_id) quando external_id não é nulo.
-- =============================================================================

-- v0.2 (MVP): vendedores e carteira de clientes.
CREATE TABLE app.sales_reps (
  id                      uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id               uuid NOT NULL REFERENCES app.tenants (id),
  code                    text NOT NULL,
  name                    text NOT NULL,
  email                   text,
  phone_e164              text CHECK (phone_e164 ~ '^\+[1-9][0-9]{7,14}$'),
  user_id                 uuid REFERENCES app.users (id),
  branch_id               uuid,
  erp_representative_code text,
  is_active               boolean NOT NULL DEFAULT true,
  created_at              timestamptz NOT NULL DEFAULT now(),
  updated_at              timestamptz NOT NULL DEFAULT now(),
  created_by              uuid,
  updated_by              uuid,
  version                 integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  FOREIGN KEY (tenant_id, branch_id) REFERENCES app.branches (tenant_id, id)
);
CREATE UNIQUE INDEX sales_reps_user_key ON app.sales_reps (tenant_id, user_id) WHERE user_id IS NOT NULL;
CREATE UNIQUE INDEX sales_reps_erp_code_key ON app.sales_reps (tenant_id, erp_representative_code) WHERE erp_representative_code IS NOT NULL;
CREATE INDEX sales_reps_user_id_idx ON app.sales_reps (user_id) WHERE user_id IS NOT NULL;
CREATE INDEX sales_reps_branch_idx ON app.sales_reps (tenant_id, branch_id) WHERE branch_id IS NOT NULL;
COMMENT ON TABLE app.sales_reps IS 'v0.2 (MVP, módulo customers). Vendedor/representante: carteira = clientes com primary_sales_rep_id = id. Com user_id e papel sales_rep, vê os clientes da carteira, os ativos e as OS deles, abre OS em nome do cliente (origin = sales_rep) e faz a pré-triagem no modo sales_rep_first. O filtro de carteira é da aplicação (a RLS isola só por tenant).';
COMMENT ON COLUMN app.sales_reps.erp_representative_code IS 'Código do representante no ERP (F2: preenche a carteira a partir do cadastro de clientes do ERP).';

CREATE TABLE app.customers (
  id                 uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id          uuid NOT NULL REFERENCES app.tenants (id),
  code               text,
  name               text NOT NULL,
  trade_name         text,
  person_type        text NOT NULL DEFAULT 'company' CHECK (person_type IN ('company', 'individual')),
  document_type      text NOT NULL DEFAULT 'cnpj' CHECK (document_type IN ('cnpj', 'cpf', 'foreign', 'none')),
  document_number    text,
  state_registration text,
  email              text,
  phone              text,
  notes              text,
  kind               text NOT NULL DEFAULT 'standard' CHECK (kind IN ('standard', 'internal')),
  primary_sales_rep_id uuid,
  skip_triage        boolean NOT NULL DEFAULT false,
  is_active          boolean NOT NULL DEFAULT true,
  deactivated_at     timestamptz,
  source             text NOT NULL DEFAULT 'local' CHECK (source IN ('local', 'erp')),
  external_system    text,
  external_id        text,
  external_payload   jsonb,
  external_hash      text,
  last_synced_at     timestamptz,
  missing_since      timestamptz,
  row_version        bigint NOT NULL DEFAULT 0,
  sync_xid           xid8,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  created_by         uuid,
  updated_by         uuid,
  version            integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, primary_sales_rep_id) REFERENCES app.sales_reps (tenant_id, id),
  CHECK ((external_system IS NULL) = (external_id IS NULL)),
  CHECK (source = 'local' OR external_id IS NOT NULL),
  CHECK (document_type = 'none' OR document_number IS NOT NULL),
  CHECK (kind = 'standard' OR source = 'local')
);
CREATE INDEX customers_sales_rep_idx ON app.customers (tenant_id, primary_sales_rep_id) WHERE primary_sales_rep_id IS NOT NULL;
CREATE UNIQUE INDEX customers_external_key ON app.customers (tenant_id, external_system, external_id) WHERE external_id IS NOT NULL;
CREATE UNIQUE INDEX customers_code_key ON app.customers (tenant_id, code) WHERE code IS NOT NULL;
CREATE INDEX customers_document_idx ON app.customers (tenant_id, document_number);
CREATE INDEX customers_name_trgm_idx ON app.customers USING gin (name gin_trgm_ops);
CREATE INDEX customers_row_version_idx ON app.customers (tenant_id, row_version);
COMMENT ON TABLE app.customers IS 'Cliente do tenant. MVP: local/importação; fase 2: mestre do ERP (campos mestres somente leitura quando source = erp). Documento não é único: o ERP pode ter duplicidades (vira integration_issue possible_duplicate).';
COMMENT ON COLUMN app.customers.external_hash IS 'SHA-256 do registro normalizado do ERP, para detectar mudança em varredura completa (docs/07).';
COMMENT ON COLUMN app.customers.kind IS 'v0.2 (F3). standard: cliente de verdade; internal: setor ou oficina do próprio tenant (manutenção interna com o mesmo modelo). Cliente interno é sempre local (CHECK).';
COMMENT ON COLUMN app.customers.primary_sales_rep_id IS 'v0.2 (MVP). Vendedor responsável (carteira). Extensão local mesmo com source = erp (F2: pode vir do representante do ERP pela integração).';
COMMENT ON COLUMN app.customers.skip_triage IS 'v0.2 (MVP). No modo de triagem direct, chamados deste cliente vão direto ao técnico ou prestador da região, sem fila de triagem. Extensão local.';

CREATE TABLE app.customer_sites (
  id                   uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id            uuid NOT NULL REFERENCES app.tenants (id),
  customer_id          uuid NOT NULL,
  code                 text,
  name                 text NOT NULL,
  street               text,
  street_number        text,
  complement           text,
  district             text,
  city                 text,
  state                text,
  postal_code          text,
  country_code         char(2) NOT NULL DEFAULT 'BR',
  latitude             double precision CHECK (latitude BETWEEN -90 AND 90),
  longitude            double precision CHECK (longitude BETWEEN -180 AND 180),
  suggested_latitude   double precision CHECK (suggested_latitude BETWEEN -90 AND 90),
  suggested_longitude  double precision CHECK (suggested_longitude BETWEEN -180 AND 180),
  location_suggested_at timestamptz,
  location_suggested_by uuid,
  phone                text,
  access_notes         text,
  service_area_id      uuid,
  business_calendar_id uuid,
  is_active            boolean NOT NULL DEFAULT true,
  source               text NOT NULL DEFAULT 'local' CHECK (source IN ('local', 'erp')),
  external_system      text,
  external_id          text,
  external_payload     jsonb,
  external_hash        text,
  last_synced_at       timestamptz,
  missing_since        timestamptz,
  row_version          bigint NOT NULL DEFAULT 0,
  sync_xid             xid8,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),
  created_by           uuid,
  updated_by           uuid,
  version              integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, customer_id, id),
  FOREIGN KEY (tenant_id, customer_id) REFERENCES app.customers (tenant_id, id),
  FOREIGN KEY (tenant_id, service_area_id) REFERENCES app.service_areas (tenant_id, id),
  FOREIGN KEY (tenant_id, business_calendar_id) REFERENCES app.business_calendars (tenant_id, id),
  CHECK ((external_system IS NULL) = (external_id IS NULL)),
  CHECK (source = 'local' OR external_id IS NOT NULL),
  CHECK ((suggested_latitude IS NULL) = (suggested_longitude IS NULL)),
  CHECK (suggested_latitude IS NULL OR location_suggested_at IS NOT NULL)
);
CREATE UNIQUE INDEX customer_sites_external_key ON app.customer_sites (tenant_id, external_system, external_id) WHERE external_id IS NOT NULL;
CREATE INDEX customer_sites_service_area_idx ON app.customer_sites (tenant_id, service_area_id);
CREATE INDEX customer_sites_calendar_idx ON app.customer_sites (tenant_id, business_calendar_id) WHERE business_calendar_id IS NOT NULL;
CREATE INDEX customer_sites_row_version_idx ON app.customer_sites (tenant_id, row_version);
CREATE INDEX customer_sites_location_suggested_idx ON app.customer_sites (tenant_id, location_suggested_at) WHERE suggested_latitude IS NOT NULL;
COMMENT ON TABLE app.customer_sites IS 'Unidade/local de atendimento do cliente (endereço). Geolocalização, região e observações de acesso são extensões locais mesmo quando source = erp.';
COMMENT ON COLUMN app.customer_sites.latitude IS 'Latitude WGS 84 em graus decimais (double precision; double no Dart).';
COMMENT ON COLUMN app.customer_sites.longitude IS 'Longitude WGS 84 em graus decimais (double precision; double no Dart).';
COMMENT ON COLUMN app.customer_sites.suggested_longitude IS 'Longitude sugerida em campo, em graus decimais (double precision). Ver suggested_latitude.';
COMMENT ON COLUMN app.customer_sites.suggested_latitude IS 'Latitude sugerida em campo, em graus decimais (double precision). Coordenada sugerida em campo (mutação customer_site.suggest_location, docs/06). Não altera latitude/longitude: o backoffice aceita (copia para latitude/longitude e limpa a sugestão, emite customer_site.updated) ou descarta (limpa a sugestão). Extensão local, editável mesmo com source = erp.';
COMMENT ON COLUMN app.customer_sites.location_suggested_by IS 'Usuário (users.id; em geral o do técnico) que sugeriu a coordenada. Sem FK: referência histórica a usuário global, como created_by/updated_by.';
COMMENT ON COLUMN app.customer_sites.missing_since IS 'Primeira varredura completa do ERP em que o registro não veio. Volta a nulo se reaparecer; inativação só na segunda varredura completa consecutiva em que continuar ausente (docs/07).';
COMMENT ON COLUMN app.customers.missing_since IS 'Primeira varredura completa do ERP em que o registro não veio. Volta a nulo se reaparecer; inativação (customer.deactivated) só na segunda varredura completa consecutiva em que continuar ausente (docs/07).';

CREATE TABLE app.customer_contacts (
  id                uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id         uuid NOT NULL REFERENCES app.tenants (id),
  customer_id       uuid NOT NULL,
  customer_site_id  uuid,
  user_id           uuid REFERENCES app.users (id),
  name              text NOT NULL,
  email             text,
  phone_e164        text CHECK (phone_e164 ~ '^\+[1-9][0-9]{7,14}$'),
  job_title         text,
  contact_role      text NOT NULL DEFAULT 'customer_contact' CHECK (contact_role IN ('customer_contact', 'customer_admin')),
  status            text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'pending_approval', 'blocked')),
  origin            text NOT NULL DEFAULT 'backoffice' CHECK (origin IN ('backoffice', 'file_import', 'erp', 'qr_self_service')),
  can_open_requests boolean NOT NULL DEFAULT true,
  preferred_channel text CHECK (preferred_channel IN ('whatsapp', 'sms', 'email')),
  whatsapp_opt_in_at timestamptz,
  approved_at       timestamptz,
  approved_by       uuid,
  blocked_reason    text,
  last_login_at     timestamptz,
  is_active         boolean NOT NULL DEFAULT true,
  source            text NOT NULL DEFAULT 'local' CHECK (source IN ('local', 'erp')),
  external_system   text,
  external_id       text,
  external_payload  jsonb,
  external_hash     text,
  last_synced_at    timestamptz,
  missing_since     timestamptz,
  row_version       bigint NOT NULL DEFAULT 0,
  sync_xid          xid8,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  created_by        uuid,
  updated_by        uuid,
  version           integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, customer_id) REFERENCES app.customers (tenant_id, id),
  FOREIGN KEY (tenant_id, customer_id, customer_site_id) REFERENCES app.customer_sites (tenant_id, customer_id, id),
  CHECK ((external_system IS NULL) = (external_id IS NULL)),
  CHECK (source = 'local' OR external_id IS NOT NULL),
  CHECK (status <> 'blocked' OR blocked_reason IS NOT NULL)
);
CREATE UNIQUE INDEX customer_contacts_external_key ON app.customer_contacts (tenant_id, external_system, external_id) WHERE external_id IS NOT NULL;
CREATE INDEX customer_contacts_customer_site_idx ON app.customer_contacts (tenant_id, customer_id, customer_site_id);
CREATE INDEX customer_contacts_user_id_idx ON app.customer_contacts (user_id) WHERE user_id IS NOT NULL;
CREATE INDEX customer_contacts_phone_idx ON app.customer_contacts (phone_e164) WHERE phone_e164 IS NOT NULL;
CREATE INDEX customer_contacts_email_idx ON app.customer_contacts (lower(email)) WHERE email IS NOT NULL;
CREATE INDEX customer_contacts_row_version_idx ON app.customer_contacts (tenant_id, row_version);
COMMENT ON TABLE app.customer_contacts IS 'Contato do cliente (abre chamados pelo app Flutter ou pela página web leve). customer_site_id nulo = todas as unidades. Ligado a um user global no primeiro login por OTP.';
COMMENT ON COLUMN app.customer_contacts.origin IS 'qr_self_service: cadastrado pelo próprio contato a partir de leitura física do QR (nasce pending_approval, docs/05; emite customer_contact.created).';
COMMENT ON COLUMN app.customer_contacts.whatsapp_opt_in_at IS 'Momento do consentimento explícito do contato para receber mensagens de WhatsApp. Nulo = sem consentimento: o módulo de notificações não envia WhatsApp (exceto o OTP pedido pelo próprio contato, que é a resposta a uma solicitação dele) e cai para SMS/e-mail.';
COMMENT ON COLUMN app.customer_contacts.missing_since IS 'Primeira varredura completa do ERP em que o registro não veio. Volta a nulo se reaparecer; inativação (customer_contact.deactivated) só na segunda varredura completa consecutiva em que continuar ausente (docs/07).';

-- v0.2 (F3): vendas mensais por cliente vindas do ERP (rentabilidade do comodato).
CREATE TABLE app.customer_sales_summaries (
  id               uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id        uuid NOT NULL REFERENCES app.tenants (id),
  customer_id      uuid NOT NULL,
  branch_id        uuid,
  period_month     date NOT NULL CHECK (period_month = date_trunc('month', period_month)::date),
  gross_amount     bigint NOT NULL DEFAULT 0 CHECK (gross_amount >= 0),
  net_amount       bigint NOT NULL DEFAULT 0,
  quantity         bigint CHECK (quantity >= 0),
  invoice_count    integer CHECK (invoice_count >= 0),
  external_system  text NOT NULL,
  external_hash    text,
  external_payload jsonb,
  last_synced_at   timestamptz NOT NULL DEFAULT now(),
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),
  created_by       uuid,
  updated_by       uuid,
  version          integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, customer_id) REFERENCES app.customers (tenant_id, id),
  FOREIGN KEY (tenant_id, branch_id) REFERENCES app.branches (tenant_id, id)
);
CREATE UNIQUE INDEX customer_sales_summaries_period_key ON app.customer_sales_summaries
  (tenant_id, customer_id, period_month, coalesce(branch_id, '00000000-0000-0000-0000-000000000000'::uuid));
CREATE INDEX customer_sales_summaries_branch_idx ON app.customer_sales_summaries (tenant_id, branch_id, period_month) WHERE branch_id IS NOT NULL;
COMMENT ON TABLE app.customer_sales_summaries IS 'v0.2 (F3, módulo customers). Vendas mensais por cliente (e filial) importadas do ERP, só gravadas pela integração (upsert idempotente pela chave cliente + mês + filial). Cruzadas com os ativos alocados (assets.acquisition_cost) e os custos de manutenção (work_order_costs) nos indicadores de rentabilidade do comodato.';
COMMENT ON COLUMN app.customer_sales_summaries.gross_amount IS 'Valor bruto do mês, em centavos (bigint; R$ 12,34 = 1234). O adaptador do ERP converte do decimal.';
COMMENT ON COLUMN app.customer_sales_summaries.net_amount IS 'Valor líquido do mês, em centavos (bigint); pode ficar negativo com devoluções.';
COMMENT ON COLUMN app.customer_sales_summaries.quantity IS 'Quantidade vendida no mês, em milésimos da unidade (bigint; 1,5 = 1500).';

-- =============================================================================
-- 10. Catálogo (módulo catalog)
-- =============================================================================

CREATE TABLE app.product_families (
  id               uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id        uuid NOT NULL REFERENCES app.tenants (id),
  parent_id        uuid,
  code             text NOT NULL,
  name             text NOT NULL,
  is_active        boolean NOT NULL DEFAULT true,
  source           text NOT NULL DEFAULT 'local' CHECK (source IN ('local', 'erp')),
  external_system  text,
  external_id      text,
  external_payload jsonb,
  external_hash    text,
  last_synced_at   timestamptz,
  row_version      bigint NOT NULL DEFAULT 0,
  sync_xid         xid8,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),
  created_by       uuid,
  updated_by       uuid,
  version          integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  FOREIGN KEY (tenant_id, parent_id) REFERENCES app.product_families (tenant_id, id),
  CHECK (parent_id <> id),
  CHECK ((external_system IS NULL) = (external_id IS NULL))
);
CREATE UNIQUE INDEX product_families_external_key ON app.product_families (tenant_id, external_system, external_id) WHERE external_id IS NOT NULL;
CREATE INDEX product_families_parent_idx ON app.product_families (tenant_id, parent_id) WHERE parent_id IS NOT NULL;
CREATE INDEX product_families_row_version_idx ON app.product_families (tenant_id, row_version);
COMMENT ON TABLE app.product_families IS 'Família/categoria de produto (ex.: Refrigeração > Freezer horizontal). Filtra sintomas, causas, checklists e habilidades.';

CREATE TABLE app.products (
  id                           uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id                    uuid NOT NULL REFERENCES app.tenants (id),
  code                         text NOT NULL,
  name                         text NOT NULL,
  description                  text,
  product_family_id            uuid,
  product_kind                 text NOT NULL DEFAULT 'equipment' CHECK (product_kind IN ('equipment', 'spare_part', 'consumable', 'other')),
  unit_code                    text NOT NULL DEFAULT 'UN',
  gtin                         text,
  is_serialized                boolean NOT NULL DEFAULT false,
  tracks_assets                boolean NOT NULL DEFAULT false,
  default_warranty_months      smallint CHECK (default_warranty_months >= 0),
  reference_price              bigint CHECK (reference_price >= 0),
  label_position_instructions  text,
  label_position_attachment_id uuid,
  is_active                    boolean NOT NULL DEFAULT true,
  source                       text NOT NULL DEFAULT 'local' CHECK (source IN ('local', 'erp')),
  external_system              text,
  external_id                  text,
  external_payload             jsonb,
  external_hash                text,
  last_synced_at               timestamptz,
  missing_since                timestamptz,
  row_version                  bigint NOT NULL DEFAULT 0,
  sync_xid                     xid8,
  created_at                   timestamptz NOT NULL DEFAULT now(),
  updated_at                   timestamptz NOT NULL DEFAULT now(),
  created_by                   uuid,
  updated_by                   uuid,
  version                      integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  FOREIGN KEY (tenant_id, product_family_id) REFERENCES app.product_families (tenant_id, id),
  CHECK ((external_system IS NULL) = (external_id IS NULL)),
  CHECK (source = 'local' OR external_id IS NOT NULL)
);
CREATE UNIQUE INDEX products_external_key ON app.products (tenant_id, external_system, external_id) WHERE external_id IS NOT NULL;
CREATE INDEX products_family_idx ON app.products (tenant_id, product_family_id);
CREATE INDEX products_name_trgm_idx ON app.products USING gin (name gin_trgm_ops);
CREATE INDEX products_row_version_idx ON app.products (tenant_id, row_version);
COMMENT ON TABLE app.products IS 'Produto do catálogo (modelo/SKU: equipamento, peça, consumível). A unidade física é o asset. Mestre do ERP na fase 2.';
COMMENT ON COLUMN app.products.reference_price IS 'Preço de referência em centavos (bigint; R$ 12,34 = 1234). Mestre do ERP quando source = erp (o adaptador converte do decimal).';
COMMENT ON COLUMN app.products.label_position_instructions IS 'Onde colar/encontrar a etiqueta QR neste modelo (docs/05); foto de referência em label_position_attachment_id.';

CREATE TABLE app.services (
  id                uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id         uuid NOT NULL REFERENCES app.tenants (id),
  code              text NOT NULL,
  name              text NOT NULL,
  description       text,
  unit_code         text NOT NULL DEFAULT 'H',
  default_price     bigint CHECK (default_price >= 0),
  estimated_minutes integer CHECK (estimated_minutes > 0),
  service_kind      text NOT NULL DEFAULT 'other' CHECK (service_kind IN ('labour', 'travel', 'visit', 'other')),
  is_active         boolean NOT NULL DEFAULT true,
  source            text NOT NULL DEFAULT 'local' CHECK (source IN ('local', 'erp')),
  external_system   text,
  external_id       text,
  external_payload  jsonb,
  external_hash     text,
  last_synced_at    timestamptz,
  missing_since     timestamptz,
  row_version       bigint NOT NULL DEFAULT 0,
  sync_xid          xid8,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  created_by        uuid,
  updated_by        uuid,
  version           integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  CHECK ((external_system IS NULL) = (external_id IS NULL)),
  CHECK (source = 'local' OR external_id IS NOT NULL)
);
CREATE UNIQUE INDEX services_external_key ON app.services (tenant_id, external_system, external_id) WHERE external_id IS NOT NULL;
CREATE INDEX services_row_version_idx ON app.services (tenant_id, row_version);
CREATE INDEX services_kind_idx ON app.services (tenant_id, service_kind) WHERE is_active;
COMMENT ON TABLE app.services IS 'Serviço do catálogo (item faturável de mão de obra/visita: hora técnica, visita, deslocamento). Mestre do ERP na fase 2.';
COMMENT ON COLUMN app.services.default_price IS 'Preço padrão por unidade do serviço (unit_code), em centavos (bigint; R$ 12,34 = 1234).';
COMMENT ON COLUMN app.services.service_kind IS 'Natureza do serviço, usada na conferência para converter apontamentos em itens (docs/07 §9.4): time_entries.type work -> labour, travel -> travel; taxa de visita fixa -> visit; demais -> other. Extensão local mesmo com source = erp.';
COMMENT ON COLUMN app.services.missing_since IS 'Primeira varredura completa do ERP em que o registro não veio. Volta a nulo se reaparecer; inativação só na segunda varredura completa consecutiva em que continuar ausente (docs/07).';
COMMENT ON COLUMN app.products.missing_since IS 'Primeira varredura completa do ERP em que o registro não veio. Volta a nulo se reaparecer; inativação só na segunda varredura completa consecutiva em que continuar ausente (docs/07).';

CREATE TABLE app.symptoms (
  id                  uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id           uuid NOT NULL REFERENCES app.tenants (id),
  code                text NOT NULL,
  name                text NOT NULL,
  customer_label      text,
  icon                text,
  visible_to_customer boolean NOT NULL DEFAULT true,
  suggested_priority  text CHECK (suggested_priority IN ('low', 'normal', 'high', 'urgent')),
  sort_order          integer NOT NULL DEFAULT 0,
  is_active           boolean NOT NULL DEFAULT true,
  row_version         bigint NOT NULL DEFAULT 0,
  sync_xid            xid8,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  created_by          uuid,
  updated_by          uuid,
  version             integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  CHECK (NOT visible_to_customer OR customer_label IS NOT NULL)
);
CREATE INDEX symptoms_row_version_idx ON app.symptoms (tenant_id, row_version);
COMMENT ON TABLE app.symptoms IS 'Sintoma relatado (ex.: "não gela"). customer_label/icon são o que o cliente vê na abertura do chamado.';

CREATE TABLE app.symptom_applicabilities (
  id                uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id         uuid NOT NULL REFERENCES app.tenants (id),
  symptom_id        uuid NOT NULL,
  product_family_id uuid,
  product_id        uuid,
  row_version       bigint NOT NULL DEFAULT 0,
  sync_xid          xid8,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  created_by        uuid,
  updated_by        uuid,
  version           integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, symptom_id) REFERENCES app.symptoms (tenant_id, id) ON DELETE CASCADE,
  FOREIGN KEY (tenant_id, product_family_id) REFERENCES app.product_families (tenant_id, id),
  FOREIGN KEY (tenant_id, product_id) REFERENCES app.products (tenant_id, id),
  CHECK (num_nonnulls(product_family_id, product_id) = 1)
);
CREATE UNIQUE INDEX symptom_applicabilities_key ON app.symptom_applicabilities
  (tenant_id, symptom_id, coalesce(product_family_id, product_id));
CREATE INDEX symptom_applicabilities_family_idx ON app.symptom_applicabilities (tenant_id, product_family_id) WHERE product_family_id IS NOT NULL;
CREATE INDEX symptom_applicabilities_product_idx ON app.symptom_applicabilities (tenant_id, product_id) WHERE product_id IS NOT NULL;
CREATE INDEX symptom_applicabilities_row_version_idx ON app.symptom_applicabilities (tenant_id, row_version);
COMMENT ON TABLE app.symptom_applicabilities IS 'A que famílias/modelos o sintoma se aplica. Sem linhas = aplica-se a todos.';

CREATE TABLE app.failure_causes (
  id                uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id         uuid NOT NULL REFERENCES app.tenants (id),
  code              text NOT NULL,
  name              text NOT NULL,
  product_family_id uuid,
  is_active         boolean NOT NULL DEFAULT true,
  row_version       bigint NOT NULL DEFAULT 0,
  sync_xid          xid8,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  created_by        uuid,
  updated_by        uuid,
  version           integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  FOREIGN KEY (tenant_id, product_family_id) REFERENCES app.product_families (tenant_id, id)
);
CREATE INDEX failure_causes_family_idx ON app.failure_causes (tenant_id, product_family_id);
CREATE INDEX failure_causes_row_version_idx ON app.failure_causes (tenant_id, row_version);
COMMENT ON TABLE app.failure_causes IS 'Causa da falha (diagnóstico do técnico). product_family_id nulo = todas as famílias.';

CREATE TABLE app.resolution_codes (
  id                uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id         uuid NOT NULL REFERENCES app.tenants (id),
  code              text NOT NULL,
  name              text NOT NULL,
  product_family_id uuid,
  is_active         boolean NOT NULL DEFAULT true,
  row_version       bigint NOT NULL DEFAULT 0,
  sync_xid          xid8,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  created_by        uuid,
  updated_by        uuid,
  version           integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  FOREIGN KEY (tenant_id, product_family_id) REFERENCES app.product_families (tenant_id, id)
);
CREATE INDEX resolution_codes_family_idx ON app.resolution_codes (tenant_id, product_family_id);
CREATE INDEX resolution_codes_row_version_idx ON app.resolution_codes (tenant_id, row_version);
COMMENT ON TABLE app.resolution_codes IS 'Solução aplicada (ex.: troca de termostato). product_family_id nulo = todas as famílias.';

CREATE TABLE app.checklist_templates (
  id                uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id         uuid NOT NULL REFERENCES app.tenants (id),
  code              text NOT NULL,
  name              text NOT NULL,
  description       text,
  template_version  integer NOT NULL DEFAULT 1 CHECK (template_version > 0),
  status            text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'published', 'archived')),
  items             jsonb NOT NULL DEFAULT '[]'::jsonb CHECK (jsonb_typeof(items) = 'array'),
  product_family_id uuid,
  published_at      timestamptz,
  is_active         boolean NOT NULL DEFAULT true,
  row_version       bigint NOT NULL DEFAULT 0,
  sync_xid          xid8,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  created_by        uuid,
  updated_by        uuid,
  version           integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code, template_version),
  FOREIGN KEY (tenant_id, product_family_id) REFERENCES app.product_families (tenant_id, id),
  CHECK (status <> 'published' OR published_at IS NOT NULL)
);
CREATE INDEX checklist_templates_family_idx ON app.checklist_templates (tenant_id, product_family_id);
CREATE INDEX checklist_templates_row_version_idx ON app.checklist_templates (tenant_id, row_version);
COMMENT ON TABLE app.checklist_templates IS 'Modelo de checklist versionado: versão publicada é imutável (alterar = nova template_version). items: [{key,label,type,required,options}].';
COMMENT ON COLUMN app.checklist_templates.items IS 'Array jsonb de itens {key,label,type,required,options}; o tipo é validado pela aplicação (schema JSON do módulo catalog), não por CHECK. v0.2 (F2): novo type meter_reading com options {meter_type: hour_meter|energy_kwh|temperature|cycles, unit_code}; a resposta grava uma leitura em meter_readings pela mutação meter_reading.record (source = manual) e guarda em checklist_responses.answers o meter_reading_id. Fotos antes/depois obrigatórias por tipo de OS (antifraude, MVP) são itens type photo com required = true.';

-- =============================================================================
-- 11. Tipos de OS e SLA (módulo work_orders)
-- =============================================================================

CREATE TABLE app.work_order_types (
  id                            uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id                     uuid NOT NULL REFERENCES app.tenants (id),
  code                          text NOT NULL,
  name                          text NOT NULL,
  category                      text NOT NULL CHECK (category IN ('corrective', 'preventive', 'installation', 'removal', 'inspection',
                                                                  'refurbishment', 'teardown', 'other')),
  default_priority              text NOT NULL DEFAULT 'normal' CHECK (default_priority IN ('low', 'normal', 'high', 'urgent')),
  requires_asset                boolean NOT NULL DEFAULT true,
  available_to_customer         boolean NOT NULL DEFAULT false,
  require_qr_check_in           boolean,
  skip_triage                   boolean NOT NULL DEFAULT false,
  default_checklist_template_id uuid,
  default_service_id            uuid,
  estimated_minutes             integer CHECK (estimated_minutes > 0),
  color                         text CHECK (color ~ '^#[0-9A-Fa-f]{6}$'),
  sort_order                    integer NOT NULL DEFAULT 0,
  is_active                     boolean NOT NULL DEFAULT true,
  row_version                   bigint NOT NULL DEFAULT 0,
  sync_xid                      xid8,
  created_at                    timestamptz NOT NULL DEFAULT now(),
  updated_at                    timestamptz NOT NULL DEFAULT now(),
  created_by                    uuid,
  updated_by                    uuid,
  version                       integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  FOREIGN KEY (tenant_id, default_checklist_template_id) REFERENCES app.checklist_templates (tenant_id, id),
  FOREIGN KEY (tenant_id, default_service_id) REFERENCES app.services (tenant_id, id)
);
CREATE INDEX work_order_types_checklist_idx ON app.work_order_types (tenant_id, default_checklist_template_id) WHERE default_checklist_template_id IS NOT NULL;
CREATE INDEX work_order_types_service_idx ON app.work_order_types (tenant_id, default_service_id) WHERE default_service_id IS NOT NULL;
CREATE INDEX work_order_types_row_version_idx ON app.work_order_types (tenant_id, row_version);
COMMENT ON TABLE app.work_order_types IS 'Tipo de OS (corretiva, preventiva, instalação, retirada...). available_to_customer: aparece na abertura pelo app do cliente.';
COMMENT ON COLUMN app.work_order_types.category IS 'v0.2 (F3): refurbishment (recondicionamento em oficina) e teardown (desmontagem para peças; ao concluir, baixa do ativo com retirement_reason = cannibalized). Essas OS usam resolution_mode = workshop.';
COMMENT ON COLUMN app.work_order_types.require_qr_check_in IS 'v0.2 (MVP, antifraude). Nulo = herda tenant_settings.require_qr_check_in; true/false sobrescreve para o tipo.';
COMMENT ON COLUMN app.work_order_types.skip_triage IS 'v0.2 (MVP). No modo de triagem direct, chamados deste tipo pulam a fila de triagem.';

CREATE TABLE app.sla_policies (
  id                     uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id              uuid NOT NULL REFERENCES app.tenants (id),
  name                   text NOT NULL,
  priority               text NOT NULL CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  work_order_type_id     uuid,
  customer_id            uuid,
  triage_minutes         integer CHECK (triage_minutes > 0),
  first_response_minutes integer NOT NULL CHECK (first_response_minutes > 0),
  resolution_minutes     integer NOT NULL CHECK (resolution_minutes > 0),
  time_basis             text NOT NULL DEFAULT 'business_hours' CHECK (time_basis IN ('business_hours', 'calendar')),
  business_calendar_id   uuid,
  pause_on_hold          boolean NOT NULL DEFAULT true,
  is_active              boolean NOT NULL DEFAULT true,
  created_at             timestamptz NOT NULL DEFAULT now(),
  updated_at             timestamptz NOT NULL DEFAULT now(),
  created_by             uuid,
  updated_by             uuid,
  version                integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_type_id) REFERENCES app.work_order_types (tenant_id, id),
  FOREIGN KEY (tenant_id, customer_id) REFERENCES app.customers (tenant_id, id),
  FOREIGN KEY (tenant_id, business_calendar_id) REFERENCES app.business_calendars (tenant_id, id),
  CHECK (resolution_minutes >= first_response_minutes)
);
CREATE UNIQUE INDEX sla_policies_scope_key ON app.sla_policies
  (tenant_id, priority,
   coalesce(work_order_type_id, '00000000-0000-0000-0000-000000000000'::uuid),
   coalesce(customer_id, '00000000-0000-0000-0000-000000000000'::uuid))
  WHERE is_active;
CREATE INDEX sla_policies_type_idx ON app.sla_policies (tenant_id, work_order_type_id);
CREATE INDEX sla_policies_customer_idx ON app.sla_policies (tenant_id, customer_id);
CREATE INDEX sla_policies_calendar_idx ON app.sla_policies (tenant_id, business_calendar_id);
COMMENT ON TABLE app.sla_policies IS 'Política de SLA por prioridade x tipo de OS x cliente (nulos = qualquer). Vence a mais específica: cliente+tipo > cliente > tipo > genérica.';
COMMENT ON COLUMN app.sla_policies.first_response_minutes IS 'Prazo de primeiro atendimento: até o primeiro check-in (visita on_site) ou resolução remota.';

-- =============================================================================
-- 12. Técnicos, equipes, turnos e escalas (módulo scheduling)
-- =============================================================================

CREATE TABLE app.work_shifts (
  id                   uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id            uuid NOT NULL REFERENCES app.tenants (id),
  code                 text NOT NULL,
  name                 text NOT NULL,
  business_calendar_id uuid,
  tolerance_minutes    smallint NOT NULL DEFAULT 10 CHECK (tolerance_minutes >= 0),
  is_active            boolean NOT NULL DEFAULT true,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),
  created_by           uuid,
  updated_by           uuid,
  version              integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  FOREIGN KEY (tenant_id, business_calendar_id) REFERENCES app.business_calendars (tenant_id, id)
);
CREATE INDEX work_shifts_calendar_idx ON app.work_shifts (tenant_id, business_calendar_id);
COMMENT ON TABLE app.work_shifts IS 'Turno de trabalho (ex.: Comercial 08-18, Plantão noturno). Feriados vêm do business_calendar.';

CREATE TABLE app.work_shift_periods (
  id               uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id        uuid NOT NULL REFERENCES app.tenants (id),
  work_shift_id    uuid NOT NULL,
  weekday          smallint NOT NULL CHECK (weekday BETWEEN 1 AND 7),
  period_type      text NOT NULL DEFAULT 'work' CHECK (period_type IN ('work', 'rest_break')),
  start_time       time NOT NULL,
  end_time         time NOT NULL,
  crosses_midnight boolean GENERATED ALWAYS AS (end_time <= start_time) STORED,
  created_at       timestamptz NOT NULL DEFAULT now(),
  updated_at       timestamptz NOT NULL DEFAULT now(),
  created_by       uuid,
  updated_by       uuid,
  version          integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, work_shift_id) REFERENCES app.work_shifts (tenant_id, id) ON DELETE CASCADE,
  CHECK (start_time <> end_time)
);
CREATE INDEX work_shift_periods_shift_idx ON app.work_shift_periods (tenant_id, work_shift_id, weekday);
COMMENT ON TABLE app.work_shift_periods IS 'Janelas do turno por dia da semana (work/break). end_time <= start_time = vira a meia-noite.';

CREATE TABLE app.teams (
  id              uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id       uuid NOT NULL REFERENCES app.tenants (id),
  code            text NOT NULL,
  name            text NOT NULL,
  service_area_id uuid,
  is_active       boolean NOT NULL DEFAULT true,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid,
  updated_by      uuid,
  version         integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  FOREIGN KEY (tenant_id, service_area_id) REFERENCES app.service_areas (tenant_id, id)
);
CREATE INDEX teams_service_area_idx ON app.teams (tenant_id, service_area_id);
COMMENT ON TABLE app.teams IS 'Equipe de técnicos (agrupamento para despacho e visibilidade de agenda).';

-- v0.2 (MVP): prestadores de serviço terceirizados e suas tarifas.
CREATE TABLE app.service_providers (
  id                  uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id           uuid NOT NULL REFERENCES app.tenants (id),
  code                text NOT NULL,
  legal_name          text NOT NULL,
  trade_name          text,
  document_number     text,
  contact_name        text,
  email               text,
  phone_e164          text CHECK (phone_e164 ~ '^\+[1-9][0-9]{7,14}$'),
  served_states       text[] NOT NULL DEFAULT '{}',
  branch_id           uuid,
  status              text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'suspended', 'inactive')),
  contract_start_date date,
  contract_end_date   date,
  erp_supplier_code   text,
  notes               text,
  deactivated_at      timestamptz,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  created_by          uuid,
  updated_by          uuid,
  version             integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  FOREIGN KEY (tenant_id, branch_id) REFERENCES app.branches (tenant_id, id),
  CHECK (contract_end_date IS NULL OR contract_start_date IS NULL OR contract_end_date >= contract_start_date),
  CHECK ((status = 'inactive') = (deactivated_at IS NOT NULL)),
  CHECK (served_states <@ ARRAY['AC','AL','AP','AM','BA','CE','DF','ES','GO','MA','MT','MS','MG','PA','PB','PR','PE','PI','RJ','RN','RS','RO','RR','SC','SP','SE','TO'])
);
CREATE UNIQUE INDEX service_providers_document_key ON app.service_providers (tenant_id, document_number) WHERE document_number IS NOT NULL;
CREATE INDEX service_providers_branch_idx ON app.service_providers (tenant_id, branch_id) WHERE branch_id IS NOT NULL;
CREATE INDEX service_providers_states_idx ON app.service_providers USING gin (served_states);
COMMENT ON TABLE app.service_providers IS 'v0.2 (MVP, módulo scheduling). Empresa prestadora de serviço (técnicos terceirizados): razão social, CNPJ, contato, UFs atendidas, status e vigência do contrato. A cobertura fina por região é a dos técnicos do prestador (technician_service_areas). Prestador é terceiro na LGPD (docs/04). Eventos service_provider.created/.updated/.deactivated.';
COMMENT ON COLUMN app.service_providers.served_states IS 'UFs atendidas (filtro de despacho e relatórios). Ex.: {RS,PR,SC}.';
COMMENT ON COLUMN app.service_providers.erp_supplier_code IS 'Código do fornecedor no ERP, usado no envio do fechamento (provider_settlements, F2).';

CREATE TABLE app.provider_rates (
  id                  uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id           uuid NOT NULL REFERENCES app.tenants (id),
  service_provider_id uuid NOT NULL,
  rate_type           text NOT NULL CHECK (rate_type IN ('per_visit', 'per_hour', 'per_km', 'fixed_per_service')),
  work_order_type_id  uuid,
  service_id          uuid,
  amount              bigint NOT NULL CHECK (amount >= 0),
  valid_from          date NOT NULL,
  valid_to            date,
  notes               text,
  is_active           boolean NOT NULL DEFAULT true,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  created_by          uuid,
  updated_by          uuid,
  version             integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, service_provider_id, id),
  FOREIGN KEY (tenant_id, service_provider_id) REFERENCES app.service_providers (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_type_id) REFERENCES app.work_order_types (tenant_id, id),
  FOREIGN KEY (tenant_id, service_id) REFERENCES app.services (tenant_id, id),
  CHECK (valid_to IS NULL OR valid_to >= valid_from),
  CHECK (rate_type <> 'fixed_per_service' OR service_id IS NOT NULL OR work_order_type_id IS NOT NULL),
  EXCLUDE USING gist (tenant_id WITH =, service_provider_id WITH =, rate_type WITH =,
                      (coalesce(work_order_type_id, '00000000-0000-0000-0000-000000000000'::uuid)) WITH =,
                      (coalesce(service_id, '00000000-0000-0000-0000-000000000000'::uuid)) WITH =,
                      daterange(valid_from, valid_to, '[]') WITH &&)
    WHERE (is_active)
);
CREATE INDEX provider_rates_type_idx ON app.provider_rates (tenant_id, work_order_type_id) WHERE work_order_type_id IS NOT NULL;
CREATE INDEX provider_rates_service_idx ON app.provider_rates (tenant_id, service_id) WHERE service_id IS NOT NULL;
COMMENT ON TABLE app.provider_rates IS 'v0.2 (MVP). Tarifa do prestador com vigência: por visita, por hora, por km ou valor fixo por serviço (opcionalmente por tipo de OS). Sem sobreposição de vigência para a mesma combinação (exclusion constraint). Ao finalizar a visita de um prestador, a tarifa vigente gera uma linha automática em work_order_costs (pending_review).';
COMMENT ON COLUMN app.provider_rates.amount IS 'Valor da tarifa em centavos (bigint; R$ 12,34 = 1234), por unidade do rate_type (visita, hora, km ou serviço).';

-- v0.2 (MVP): plantão (complementa as escalas, que já preveem plantão como exceção).
CREATE TABLE app.on_call_assignments (
  id              uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id       uuid NOT NULL REFERENCES app.tenants (id),
  user_id         uuid NOT NULL REFERENCES app.users (id),
  on_call_role    text NOT NULL CHECK (on_call_role IN ('dispatcher', 'technician')),
  branch_id       uuid,
  service_area_id uuid,
  starts_at       timestamptz NOT NULL,
  ends_at         timestamptz NOT NULL,
  notes           text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid,
  updated_by      uuid,
  version         integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, branch_id) REFERENCES app.branches (tenant_id, id),
  FOREIGN KEY (tenant_id, service_area_id) REFERENCES app.service_areas (tenant_id, id),
  CHECK (ends_at > starts_at),
  EXCLUDE USING gist (tenant_id WITH =, user_id WITH =, on_call_role WITH =, tstzrange(starts_at, ends_at, '[)') WITH &&)
);
CREATE INDEX on_call_assignments_window_idx ON app.on_call_assignments USING gist (tenant_id, tstzrange(starts_at, ends_at, '[)'));
CREATE INDEX on_call_assignments_user_idx ON app.on_call_assignments (user_id, starts_at);
CREATE INDEX on_call_assignments_branch_idx ON app.on_call_assignments (tenant_id, branch_id) WHERE branch_id IS NOT NULL;
CREATE INDEX on_call_assignments_area_idx ON app.on_call_assignments (tenant_id, service_area_id) WHERE service_area_id IS NOT NULL;
COMMENT ON TABLE app.on_call_assignments IS 'v0.2 (MVP, módulo scheduling). Plantão: quem responde (usuário com membership no tenant) como dispatcher ou technician num intervalo, opcionalmente por filial ou região. Sem sobreposição para o mesmo usuário e papel. É o destino "plantonista" dos passos de escalation_policies.';

CREATE TABLE app.escalation_policies (
  id                 uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id          uuid NOT NULL REFERENCES app.tenants (id),
  name               text NOT NULL,
  priority           text CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  work_order_type_id uuid,
  customer_id        uuid,
  steps              jsonb NOT NULL CHECK (jsonb_typeof(steps) = 'array' AND jsonb_array_length(steps) BETWEEN 1 AND 10),
  is_active          boolean NOT NULL DEFAULT true,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  created_by         uuid,
  updated_by         uuid,
  version            integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_type_id) REFERENCES app.work_order_types (tenant_id, id),
  FOREIGN KEY (tenant_id, customer_id) REFERENCES app.customers (tenant_id, id)
);
CREATE UNIQUE INDEX escalation_policies_scope_key ON app.escalation_policies
  (tenant_id,
   coalesce(priority, '*'),
   coalesce(work_order_type_id, '00000000-0000-0000-0000-000000000000'::uuid),
   coalesce(customer_id, '00000000-0000-0000-0000-000000000000'::uuid))
  WHERE is_active;
CREATE INDEX escalation_policies_type_idx ON app.escalation_policies (tenant_id, work_order_type_id) WHERE work_order_type_id IS NOT NULL;
CREATE INDEX escalation_policies_customer_idx ON app.escalation_policies (tenant_id, customer_id) WHERE customer_id IS NOT NULL;
COMMENT ON TABLE app.escalation_policies IS 'v0.2 (MVP). Política de escalonamento por prioridade x tipo x cliente (nulos = qualquer; vence a mais específica, como em sla_policies). O job de escalonamento (a cada minuto) sobe work_orders.escalation_level enquanto acknowledged_at for nulo.';
COMMENT ON COLUMN app.escalation_policies.steps IS 'Passos em ordem: [{"wait_minutes": 10, "notify": {"kind": "on_call"|"role"|"user", "on_call_role": "dispatcher"|"technician", "role_code": "...", "user_id": "..."}, "channels": ["push","whatsapp","sms"]}]. O passo N vale quando escalation_level = N; validado pela aplicação (schema JSON).';

CREATE TABLE app.technicians (
  id                   uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id            uuid NOT NULL REFERENCES app.tenants (id),
  user_id              uuid REFERENCES app.users (id),
  code                 text NOT NULL,
  name                 text NOT NULL,
  email                text,
  phone_e164           text CHECK (phone_e164 ~ '^\+[1-9][0-9]{7,14}$'),
  home_service_area_id uuid,
  color                text CHECK (color ~ '^#[0-9A-Fa-f]{6}$'),
  hourly_cost          bigint CHECK (hourly_cost >= 0),
  max_daily_visits     smallint CHECK (max_daily_visits > 0),
  kind                 text NOT NULL DEFAULT 'employee' CHECK (kind IN ('employee', 'contractor')),
  service_provider_id  uuid,
  branch_id            uuid,
  is_active            boolean NOT NULL DEFAULT true,
  deactivated_at       timestamptz,
  row_version          bigint NOT NULL DEFAULT 0,
  sync_xid             xid8,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),
  created_by           uuid,
  updated_by           uuid,
  version              integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  UNIQUE (tenant_id, service_provider_id, id),
  FOREIGN KEY (tenant_id, home_service_area_id) REFERENCES app.service_areas (tenant_id, id),
  FOREIGN KEY (tenant_id, service_provider_id) REFERENCES app.service_providers (tenant_id, id),
  FOREIGN KEY (tenant_id, branch_id) REFERENCES app.branches (tenant_id, id),
  CHECK ((kind = 'contractor') = (service_provider_id IS NOT NULL))
);
CREATE INDEX technicians_provider_idx ON app.technicians (tenant_id, service_provider_id) WHERE service_provider_id IS NOT NULL;
CREATE INDEX technicians_branch_idx ON app.technicians (tenant_id, branch_id) WHERE branch_id IS NOT NULL;
CREATE UNIQUE INDEX technicians_user_key ON app.technicians (tenant_id, user_id) WHERE user_id IS NOT NULL;
CREATE INDEX technicians_user_id_idx ON app.technicians (user_id) WHERE user_id IS NOT NULL;
CREATE INDEX technicians_service_area_idx ON app.technicians (tenant_id, home_service_area_id);
CREATE INDEX technicians_row_version_idx ON app.technicians (tenant_id, row_version);
COMMENT ON TABLE app.technicians IS 'Operador/técnico de campo. user_id liga ao login (Keycloak) com papel technician no tenant; pode existir antes do convite.';
COMMENT ON COLUMN app.technicians.kind IS 'v0.2 (MVP). employee (colaborador próprio) ou contractor (técnico de prestador). contractor exige service_provider_id e employee não pode ter (CHECK). Os dois usam o mesmo app.';
COMMENT ON COLUMN app.technicians.service_provider_id IS 'v0.2 (MVP). Prestador do técnico terceirizado. UNIQUE (tenant_id, service_provider_id, id) permite FKs compostas que garantem "técnico pertence ao prestador" em work_orders e work_order_visits.';
COMMENT ON COLUMN app.technicians.branch_id IS 'v0.2 (MVP). Filial do técnico (escopo e relatórios); nulo = filial padrão.';
COMMENT ON COLUMN app.technicians.hourly_cost IS 'Custo da hora do técnico próprio, em centavos (bigint; R$ 85,50 = 8550). Base das linhas source = time_entry em work_order_costs.';

-- Gestor do prestador (papel provider_admin): a qual prestador o vínculo pertence.
ALTER TABLE app.tenant_memberships
  ADD COLUMN service_provider_id uuid,
  ADD FOREIGN KEY (tenant_id, service_provider_id) REFERENCES app.service_providers (tenant_id, id);
CREATE INDEX tenant_memberships_provider_idx ON app.tenant_memberships (tenant_id, service_provider_id) WHERE service_provider_id IS NOT NULL;
COMMENT ON COLUMN app.tenant_memberships.service_provider_id IS 'v0.2 (MVP). Prestador do usuário com papel provider_admin: ele vê e redistribui só as OS/visitas com esse service_provider_id e os técnicos desse prestador. Filtro de aplicação; a RLS continua só por tenant. A API exige o preenchimento ao atribuir o papel provider_admin.';

CREATE TABLE app.team_members (
  id            uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id     uuid NOT NULL REFERENCES app.tenants (id),
  team_id       uuid NOT NULL,
  technician_id uuid NOT NULL,
  is_leader     boolean NOT NULL DEFAULT false,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid,
  updated_by    uuid,
  version       integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, team_id, technician_id),
  FOREIGN KEY (tenant_id, team_id) REFERENCES app.teams (tenant_id, id),
  FOREIGN KEY (tenant_id, technician_id) REFERENCES app.technicians (tenant_id, id)
);
CREATE INDEX team_members_technician_idx ON app.team_members (tenant_id, technician_id);
COMMENT ON TABLE app.team_members IS 'Técnicos de cada equipe (um técnico pode estar em várias equipes).';

CREATE TABLE app.technician_service_areas (
  id              uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id       uuid NOT NULL REFERENCES app.tenants (id),
  technician_id   uuid NOT NULL,
  service_area_id uuid NOT NULL,
  is_primary      boolean NOT NULL DEFAULT false,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid,
  updated_by      uuid,
  version         integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, technician_id, service_area_id),
  FOREIGN KEY (tenant_id, technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, service_area_id) REFERENCES app.service_areas (tenant_id, id)
);
CREATE INDEX technician_service_areas_area_idx ON app.technician_service_areas (tenant_id, service_area_id);
COMMENT ON TABLE app.technician_service_areas IS 'Regiões que o técnico atende (sugestão de despacho).';

CREATE TABLE app.technician_shift_assignments (
  id            uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id     uuid NOT NULL REFERENCES app.tenants (id),
  technician_id uuid NOT NULL,
  work_shift_id uuid NOT NULL,
  valid_from    date NOT NULL,
  valid_to      date,
  notes         text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  updated_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid,
  updated_by    uuid,
  version       integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, work_shift_id) REFERENCES app.work_shifts (tenant_id, id),
  CHECK (valid_to IS NULL OR valid_to >= valid_from),
  EXCLUDE USING gist (tenant_id WITH =, technician_id WITH =, daterange(valid_from, valid_to, '[]') WITH &&)
);
CREATE INDEX technician_shift_assignments_shift_idx ON app.technician_shift_assignments (tenant_id, work_shift_id);
COMMENT ON TABLE app.technician_shift_assignments IS 'Escala do técnico: qual turno vale em cada período (sem sobreposição por técnico).';

CREATE TABLE app.technician_skills (
  id                 uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id          uuid NOT NULL REFERENCES app.tenants (id),
  technician_id      uuid NOT NULL,
  skill_type         text NOT NULL CHECK (skill_type IN ('work_order_type', 'product_family')),
  work_order_type_id uuid,
  product_family_id  uuid,
  level              smallint NOT NULL DEFAULT 3 CHECK (level BETWEEN 1 AND 5),
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  created_by         uuid,
  updated_by         uuid,
  version            integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_type_id) REFERENCES app.work_order_types (tenant_id, id),
  FOREIGN KEY (tenant_id, product_family_id) REFERENCES app.product_families (tenant_id, id),
  CHECK ((skill_type = 'work_order_type' AND work_order_type_id IS NOT NULL AND product_family_id IS NULL)
      OR (skill_type = 'product_family' AND product_family_id IS NOT NULL AND work_order_type_id IS NULL))
);
CREATE UNIQUE INDEX technician_skills_key ON app.technician_skills
  (tenant_id, technician_id, coalesce(work_order_type_id, product_family_id));
CREATE INDEX technician_skills_type_idx ON app.technician_skills (tenant_id, work_order_type_id) WHERE work_order_type_id IS NOT NULL;
CREATE INDEX technician_skills_family_idx ON app.technician_skills (tenant_id, product_family_id) WHERE product_family_id IS NOT NULL;
COMMENT ON TABLE app.technician_skills IS 'Habilidades do técnico (tipo de OS ou família de produto), usadas na sugestão de despacho.';

-- =============================================================================
-- 13. Ativos, alocações e etiquetas QR (módulo assets)
-- =============================================================================

CREATE TABLE app.assets (
  id                       uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id                uuid NOT NULL REFERENCES app.tenants (id),
  product_id               uuid NOT NULL,
  serial_number            text,
  asset_tag                text,
  status                   text NOT NULL DEFAULT 'in_stock' CHECK (status IN ('in_stock', 'installed', 'in_workshop', 'retired')),
  ownership_type           text NOT NULL DEFAULT 'tenant_loan' CHECK (ownership_type IN ('tenant_loan', 'tenant_rental', 'customer_owned')),
  location_note            text,
  warranty_until           date,
  branch_id                uuid,
  parent_asset_id          uuid,
  acquisition_date         date,
  acquisition_cost         bigint CHECK (acquisition_cost >= 0),
  supplier_name            text,
  acquisition_document     text,
  current_customer_id      uuid,
  current_customer_site_id uuid,
  retired_at               timestamptz,
  retirement_reason        text,
  notes                    text,
  is_active                boolean NOT NULL DEFAULT true,
  source                   text NOT NULL DEFAULT 'local' CHECK (source IN ('local', 'erp')),
  external_system          text,
  external_id              text,
  external_payload         jsonb,
  external_hash            text,
  last_synced_at           timestamptz,
  missing_since            timestamptz,
  row_version              bigint NOT NULL DEFAULT 0,
  sync_xid                 xid8,
  created_at               timestamptz NOT NULL DEFAULT now(),
  updated_at               timestamptz NOT NULL DEFAULT now(),
  created_by               uuid,
  updated_by               uuid,
  version                  integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, product_id) REFERENCES app.products (tenant_id, id),
  FOREIGN KEY (tenant_id, current_customer_id, current_customer_site_id) REFERENCES app.customer_sites (tenant_id, customer_id, id),
  FOREIGN KEY (tenant_id, branch_id) REFERENCES app.branches (tenant_id, id),
  FOREIGN KEY (tenant_id, parent_asset_id) REFERENCES app.assets (tenant_id, id),
  CHECK (serial_number IS NOT NULL OR asset_tag IS NOT NULL),
  CHECK ((current_customer_id IS NULL) = (current_customer_site_id IS NULL)),
  CHECK (status <> 'retired' OR retired_at IS NOT NULL),
  CHECK ((external_system IS NULL) = (external_id IS NULL)),
  CHECK (source = 'local' OR external_id IS NOT NULL),
  CHECK (parent_asset_id IS NULL OR parent_asset_id <> id)
);
CREATE INDEX assets_branch_idx ON app.assets (tenant_id, branch_id) WHERE branch_id IS NOT NULL;
CREATE INDEX assets_parent_idx ON app.assets (tenant_id, parent_asset_id) WHERE parent_asset_id IS NOT NULL;
CREATE UNIQUE INDEX assets_serial_key ON app.assets (tenant_id, product_id, serial_number) WHERE serial_number IS NOT NULL;
CREATE UNIQUE INDEX assets_tag_key ON app.assets (tenant_id, asset_tag) WHERE asset_tag IS NOT NULL;
CREATE UNIQUE INDEX assets_external_key ON app.assets (tenant_id, external_system, external_id) WHERE external_id IS NOT NULL;
CREATE INDEX assets_product_idx ON app.assets (tenant_id, product_id);
CREATE INDEX assets_current_customer_idx ON app.assets (tenant_id, current_customer_id, current_customer_site_id);
CREATE INDEX assets_serial_trgm_idx ON app.assets USING gin (serial_number gin_trgm_ops);
CREATE INDEX assets_row_version_idx ON app.assets (tenant_id, row_version);
COMMENT ON TABLE app.assets IS 'Ativo/equipamento: unidade física de um produto (nº de série e/ou patrimônio). Vínculo com o cliente em asset_assignments.';
COMMENT ON COLUMN app.assets.current_customer_id IS 'Desnormalizado da alocação vigente pelo trigger de asset_assignments (não editar diretamente).';
COMMENT ON COLUMN app.assets.location_note IS 'Posição no local (ex.: "cozinha, ao lado da porta"), docs/05.';
COMMENT ON COLUMN app.assets.source IS 'v0.2: o ativo passa a ser cadastro mestre que pode vir do ERP (F2: bens do módulo de patrimônio da Senior, source = erp). Com source = erp, as colunas mestres (produto, série, patrimônio, filial, aquisição, is_active, missing_since e as external_*) só são gravadas pelo ator integration (trigger trg_guard_erp_master). Status, alocação, local, garantia, propriedade, pai/filho, baixa operacional e notas são extensões locais.';
COMMENT ON COLUMN app.assets.missing_since IS 'v0.2 (F2). Primeira varredura completa do ERP em que o bem não veio. Volta a nulo se reaparecer; inativação só na segunda ausência consecutiva (docs/07).';
COMMENT ON COLUMN app.assets.acquisition_date IS 'v0.2 (MVP). Data de aquisição (substitui o antigo acquired_at). Com acquisition_cost, supplier_name e acquisition_document (número da NF de entrada) compõe os dados de aquisição mostrados com a garantia na abertura da OS e usados na rentabilidade do comodato (F3).';
COMMENT ON COLUMN app.assets.acquisition_cost IS 'v0.2 (MVP). Valor de aquisição do bem em centavos (bigint, não negativo; R$ 5.000,00 = 500000). v0.3: era numeric(14,2); o adaptador do ERP converte do decimal.';
COMMENT ON COLUMN app.assets.branch_id IS 'v0.2 (MVP). Filial dona do bem (define a filial do pedido no ERP); nulo = filial padrão.';
COMMENT ON COLUMN app.assets.parent_asset_id IS 'v0.2 (F3). Ativo pai de um componente rastreado (ex.: o motor de um forno), com histórico de OS por componente. Não pode apontar para si mesmo; ciclos maiores são barrados pela aplicação.';
COMMENT ON COLUMN app.assets.retirement_reason IS 'Motivo da baixa (texto livre controlado pela aplicação). v0.2 (F3): cannibalized = desmontado para peças ao concluir uma OS teardown.';

CREATE TABLE app.asset_assignments (
  id                     uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id              uuid NOT NULL REFERENCES app.tenants (id),
  asset_id               uuid NOT NULL,
  customer_id            uuid NOT NULL,
  customer_site_id       uuid NOT NULL,
  ownership_type         text NOT NULL CHECK (ownership_type IN ('tenant_loan', 'tenant_rental', 'customer_owned')),
  started_at             timestamptz NOT NULL,
  ended_at               timestamptz,
  start_reason           text NOT NULL CHECK (start_reason IN ('delivery', 'installation', 'transfer', 'file_import', 'correction')),
  end_reason             text CHECK (end_reason IN ('transfer', 'withdrawal', 'return_to_stock', 'retirement', 'customer_purchase', 'correction')),
  source_document_type   text CHECK (source_document_type IN ('shipment_invoice', 'loan_contract', 'rental_contract', 'sale_invoice', 'work_order', 'other')),
  source_document_number text,
  source_document_date   date,
  work_order_id          uuid,
  ended_work_order_id    uuid,
  notes                  text,
  approval_status        text NOT NULL DEFAULT 'not_required'
                         CHECK (approval_status IN ('not_required', 'pending', 'approved', 'rejected')),
  approved_by            uuid,
  approved_at            timestamptz,
  term_attachment_id     uuid,
  created_at             timestamptz NOT NULL DEFAULT now(),
  updated_at             timestamptz NOT NULL DEFAULT now(),
  created_by             uuid,
  updated_by             uuid,
  version                integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, asset_id) REFERENCES app.assets (tenant_id, id),
  FOREIGN KEY (tenant_id, customer_id, customer_site_id) REFERENCES app.customer_sites (tenant_id, customer_id, id),
  CHECK (ended_at IS NULL OR ended_at >= started_at),
  CHECK ((ended_at IS NULL) = (end_reason IS NULL)),
  CHECK ((approval_status IN ('approved', 'rejected')) = (approved_by IS NOT NULL AND approved_at IS NOT NULL)),
  CHECK (approval_status <> 'pending' OR ended_at IS NULL),
  -- Só alocações efetivas (not_required/approved) ocupam o período: a pendente
  -- convive com a vigente anterior até ser aprovada; a rejeitada nunca vale.
  EXCLUDE USING gist (tenant_id WITH =, asset_id WITH =, tstzrange(started_at, ended_at, '[)') WITH &&)
    WHERE (approval_status IN ('not_required', 'approved'))
);
CREATE UNIQUE INDEX asset_assignments_current_key ON app.asset_assignments (tenant_id, asset_id)
  WHERE ended_at IS NULL AND approval_status IN ('not_required', 'approved');
CREATE UNIQUE INDEX asset_assignments_one_pending_key ON app.asset_assignments (tenant_id, asset_id) WHERE approval_status = 'pending';
CREATE INDEX asset_assignments_pending_idx ON app.asset_assignments (tenant_id, created_at) WHERE approval_status = 'pending';
CREATE INDEX asset_assignments_customer_idx ON app.asset_assignments (tenant_id, customer_id, customer_site_id, started_at DESC);
COMMENT ON TABLE app.asset_assignments IS 'Alocação do ativo no cliente (vínculo produto-cliente com histórico). Vigente = ended_at nulo E approval_status em (not_required, approved): no máximo uma por ativo e sem sobreposição de períodos entre alocações efetivas. v0.2 (MVP): com tenant_settings.require_movement_approval, a alocação nova nasce pending e não conta como vigente (não atualiza assets.current_customer_* nem entra na invariante status x alocação) até ser aprovada; no máximo uma pendente por ativo.';
COMMENT ON COLUMN app.asset_assignments.approval_status IS 'v0.2 (MVP). not_required (sem política de aprovação), pending (aguardando; não vale), approved (vale a partir da aprovação), rejected (nunca valeu; fica como histórico). Aprovar = na mesma transação encerrar a vigente anterior (se houver), mudar o status do ativo e marcar approved; a invariante é verificada no COMMIT. Eventos asset.movement_requested/.movement_approved/.movement_rejected.';
COMMENT ON COLUMN app.asset_assignments.approved_by IS 'v0.2 (MVP). Usuário (users.id, sem FK, como closed_by) que decidiu: aprovou ou rejeitou. Obrigatório com approved_at quando approved/rejected; nunca o mesmo que created_by (regra da API).';
COMMENT ON COLUMN app.asset_assignments.term_attachment_id IS 'v0.2 (MVP). Termo de entrega, retirada ou transferência em PDF (attachments.category = movement_term), assinado pelo cliente no app do técnico quando em campo.';
COMMENT ON COLUMN app.asset_assignments.source_document_number IS 'Documento de origem: NF de remessa em comodato, contrato de locação, NF de venda, OS de instalação.';

CREATE TABLE app.qr_tag_batches (
  id                    uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id             uuid NOT NULL REFERENCES app.tenants (id),
  code                  text NOT NULL,
  quantity              integer NOT NULL CHECK (quantity BETWEEN 1 AND 10000),
  label_layout          text NOT NULL DEFAULT 'default',
  notes                 text,
  printed_at            timestamptz,
  printed_by            uuid,
  custody_technician_id uuid,
  custody_team_id       uuid,
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now(),
  created_by            uuid,
  updated_by            uuid,
  version               integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  FOREIGN KEY (tenant_id, custody_technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, custody_team_id) REFERENCES app.teams (tenant_id, id)
);
CREATE INDEX qr_tag_batches_custody_technician_idx ON app.qr_tag_batches (tenant_id, custody_technician_id) WHERE custody_technician_id IS NOT NULL;
CREATE INDEX qr_tag_batches_custody_team_idx ON app.qr_tag_batches (tenant_id, custody_team_id) WHERE custody_team_id IS NOT NULL;
COMMENT ON TABLE app.qr_tag_batches IS 'Lote de etiquetas pré-impressas. Custódia (técnico/equipe) é fase 2.';

CREATE TABLE app.qr_tags (
  id                  uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id           uuid NOT NULL REFERENCES app.tenants (id),
  token               text NOT NULL CHECK (token ~ '^[0-7][0-9A-HJKMNP-TV-Z]{25}$'),
  short_code          text NOT NULL CHECK (short_code ~ '^[0-9A-HJKMNP-TV-Z]{8}$' AND app.crockford_luhn32_is_valid(short_code)),
  status              text NOT NULL DEFAULT 'generated' CHECK (status IN ('generated', 'printed', 'bound', 'revoked')),
  batch_id            uuid,
  asset_id            uuid,
  last_bound_asset_id uuid,
  bound_at            timestamptz,
  bound_by            uuid,
  bound_via           text CHECK (bound_via IN ('backoffice', 'technician_app', 'file_import')),
  bound_work_order_id uuid,
  printed_at          timestamptz,
  print_count         integer NOT NULL DEFAULT 0 CHECK (print_count >= 0),
  last_printed_by     uuid,
  unbind_count        integer NOT NULL DEFAULT 0 CHECK (unbind_count >= 0),
  revoked_at          timestamptz,
  revoked_by          uuid,
  revoked_reason      text CHECK (revoked_reason IN ('damaged', 'lost', 'replaced', 'asset_retired', 'misprint', 'security', 'other')),
  revocation_note     text,
  replaced_by_tag_id  uuid,
  scan_count          bigint NOT NULL DEFAULT 0 CHECK (scan_count >= 0),
  last_scanned_at     timestamptz,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  created_by          uuid,
  updated_by          uuid,
  version             integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (token),
  UNIQUE (short_code),
  FOREIGN KEY (tenant_id, batch_id) REFERENCES app.qr_tag_batches (tenant_id, id),
  FOREIGN KEY (tenant_id, asset_id) REFERENCES app.assets (tenant_id, id),
  FOREIGN KEY (tenant_id, last_bound_asset_id) REFERENCES app.assets (tenant_id, id),
  FOREIGN KEY (tenant_id, replaced_by_tag_id) REFERENCES app.qr_tags (tenant_id, id),
  CHECK ((status = 'bound') = (asset_id IS NOT NULL)),
  CHECK (status <> 'bound' OR (bound_at IS NOT NULL AND bound_via IS NOT NULL)),
  CHECK ((status = 'revoked') = (revoked_at IS NOT NULL)),
  CHECK (status <> 'revoked' OR revoked_reason IS NOT NULL),
  CHECK (replaced_by_tag_id IS NULL OR (replaced_by_tag_id <> id AND status = 'revoked'))
);
CREATE UNIQUE INDEX qr_tags_one_bound_per_asset_key ON app.qr_tags (tenant_id, asset_id) WHERE status = 'bound';
CREATE INDEX qr_tags_batch_idx ON app.qr_tags (tenant_id, batch_id, status);
CREATE INDEX qr_tags_last_asset_idx ON app.qr_tags (tenant_id, last_bound_asset_id) WHERE last_bound_asset_id IS NOT NULL;
CREATE INDEX qr_tags_replaced_by_idx ON app.qr_tags (tenant_id, replaced_by_tag_id) WHERE replaced_by_tag_id IS NOT NULL;
COMMENT ON TABLE app.qr_tags IS 'Etiqueta QR: token opaco de 128 bits (URL /q/<token>) e short code de 8 caracteres (7 aleatórios + verificador Luhn mod 32), ambos globalmente únicos. No máximo uma etiqueta bound por ativo.';
COMMENT ON COLUMN app.qr_tags.asset_id IS 'Preenchido somente quando status = bound. last_bound_asset_id preserva o último ativo após desvínculo/revogação.';
COMMENT ON COLUMN app.qr_tags.unbind_count IS 'Quantas vezes houve "desfazer vínculo" (bound -> printed), exceção auditada só para tenant_admin.';

-- =============================================================================
-- 14. Identidade e acesso — tabelas que dependem de contatos/técnicos/QR
-- =============================================================================

CREATE TABLE app.devices (
  id                  uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id           uuid NOT NULL REFERENCES app.tenants (id),
  user_id             uuid NOT NULL REFERENCES app.users (id),
  app_kind            text NOT NULL CHECK (app_kind IN ('technician_app', 'customer_app', 'customer_web')),
  platform            text NOT NULL CHECK (platform IN ('ios', 'android', 'web')),
  technician_id       uuid,
  customer_contact_id uuid,
  push_provider       text CHECK (push_provider IN ('fcm', 'apns')),
  push_token          text,
  app_version         text,
  os_version          text,
  device_model        text,
  last_seen_at        timestamptz,
  last_sync_at        timestamptz,
  status              text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'logout_requested', 'blocked')),
  public_key_jwk      jsonb,
  revoked_at          timestamptz,
  revoked_reason      text,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  created_by          uuid,
  updated_by          uuid,
  version             integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, customer_contact_id) REFERENCES app.customer_contacts (tenant_id, id),
  CHECK (app_kind <> 'technician_app' OR technician_id IS NOT NULL),
  CHECK (app_kind = 'technician_app' OR customer_contact_id IS NOT NULL),
  CHECK ((push_provider IS NULL) = (push_token IS NULL)),
  CHECK (app_kind <> 'customer_web' OR (platform = 'web' AND push_provider IS NULL)),
  CHECK (status <> 'active' OR revoked_at IS NULL),
  CHECK (status <> 'blocked' OR revoked_at IS NOT NULL),
  CHECK (public_key_jwk IS NULL OR (jsonb_typeof(public_key_jwk) = 'object' AND public_key_jwk ? 'kty'))
);
CREATE UNIQUE INDEX devices_push_token_key ON app.devices (tenant_id, push_token) WHERE push_token IS NOT NULL AND revoked_at IS NULL;
CREATE INDEX devices_user_id_idx ON app.devices (user_id);
CREATE INDEX devices_technician_idx ON app.devices (tenant_id, technician_id) WHERE technician_id IS NOT NULL;
CREATE INDEX devices_contact_idx ON app.devices (tenant_id, customer_contact_id) WHERE customer_contact_id IS NOT NULL;
COMMENT ON TABLE app.devices IS 'Dispositivo móvel/navegador por tenant: token de push, versão do app e estado de sync. Revogar = parar push e recusar sync.';
COMMENT ON COLUMN app.devices.app_kind IS 'v0.3: technician_app e customer_app são os apps Flutter (Android/iOS); customer_web é o navegador do contato na página web leve servida pelo servidor web do Serverpod (sem push, platform = web). Substitui customer_pwa da v0.2.';
COMMENT ON COLUMN app.devices.push_provider IS 'v0.3: fcm (Android, e iOS via Firebase Cloud Messaging) ou apns (iOS direto). Sem push na página web leve. Substitui expo e web_push da v0.2.';
COMMENT ON COLUMN app.devices.status IS 'Estado de acesso do aparelho (docs/06). active: sync e push liberados (revoked_at nulo). logout_requested: logout remoto pedido; no próximo contato o app recebe a ordem de apagar a base local e enviar o que estiver pendente; revoked_at é preenchido quando o logout se confirma (ou expira). blocked: acesso recusado de imediato (revoked_at obrigatório), sem nova troca por token de tenant; emite device.blocked. Desbloquear = voltar a active e limpar revoked_at.';
COMMENT ON COLUMN app.devices.revoked_at IS 'Momento em que o aparelho perdeu o acesso; mantido junto com status por compatibilidade e para o índice único de push_token (só aparelhos não revogados). Coerência garantida por CHECK: active => nulo; blocked => preenchido.';
COMMENT ON COLUMN app.devices.public_key_jwk IS 'Chave pública (JWK, só a parte pública) gerada no aparelho no registro; usada para prova de posse (assinatura de nonce) na troca do token do IdP por token de tenant (docs/04 §4). A chave privada nunca sai do armazenamento seguro do aparelho.';

CREATE TABLE app.otp_challenges (
  id                  uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id           uuid NOT NULL REFERENCES app.tenants (id),
  purpose             text NOT NULL DEFAULT 'customer_login' CHECK (purpose IN ('customer_login', 'contact_registration')),
  channel             text NOT NULL CHECK (channel IN ('whatsapp', 'sms', 'email')),
  destination_hash    bytea NOT NULL,
  destination_masked  text NOT NULL,
  code_hash           bytea NOT NULL,
  key_version         smallint NOT NULL DEFAULT 1 CHECK (key_version > 0),
  send_count          smallint NOT NULL DEFAULT 1 CHECK (send_count >= 1),
  last_sent_at        timestamptz,
  customer_contact_id uuid,
  qr_tag_id           uuid,
  status              text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'verified', 'expired', 'locked', 'cancelled')),
  expires_at          timestamptz NOT NULL,
  attempt_count       smallint NOT NULL DEFAULT 0,
  max_attempts        smallint NOT NULL DEFAULT 5 CHECK (max_attempts BETWEEN 1 AND 10),
  verified_at         timestamptz,
  delivery_status     text NOT NULL DEFAULT 'queued' CHECK (delivery_status IN ('queued', 'sent', 'delivered', 'failed')),
  provider_message_id text,
  request_ip          inet,
  user_agent          text,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  created_by          uuid,
  updated_by          uuid,
  version             integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, customer_contact_id) REFERENCES app.customer_contacts (tenant_id, id),
  FOREIGN KEY (tenant_id, qr_tag_id) REFERENCES app.qr_tags (tenant_id, id),
  CHECK (attempt_count BETWEEN 0 AND max_attempts),
  CHECK (expires_at <= created_at + interval '10 minutes'),
  CHECK (status <> 'verified' OR verified_at IS NOT NULL)
);
CREATE INDEX otp_challenges_destination_idx ON app.otp_challenges (tenant_id, destination_hash, created_at DESC);
CREATE INDEX otp_challenges_contact_idx ON app.otp_challenges (tenant_id, customer_contact_id) WHERE customer_contact_id IS NOT NULL;
CREATE INDEX otp_challenges_qr_tag_idx ON app.otp_challenges (tenant_id, qr_tag_id) WHERE qr_tag_id IS NOT NULL;
COMMENT ON TABLE app.otp_challenges IS 'Desafio OTP (6 dígitos, 10 min, tentativas limitadas). Código e destino só como hash (HMAC com pepper do cofre). Expurgo após 30 dias.';
COMMENT ON COLUMN app.otp_challenges.qr_tag_id IS 'Etiqueta do qr_context apresentado no início do OTP (prova de leitura física, docs/05).';
COMMENT ON COLUMN app.otp_challenges.key_version IS 'Versão do pepper HMAC usada em code_hash/destination_hash; permite rotacionar o pepper no cofre sem invalidar desafios em andamento (a verificação usa a versão gravada).';
COMMENT ON COLUMN app.otp_challenges.send_count IS 'Quantas vezes o código foi enviado (1 = envio inicial). Os limites de reenvio do docs/04 são aplicados pela API sobre send_count e last_sent_at.';
COMMENT ON COLUMN app.otp_challenges.last_sent_at IS 'Último envio/reenvio do código; base do intervalo mínimo entre reenvios (docs/04).';

CREATE TABLE app.auth_sessions (
  id                  uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id           uuid NOT NULL REFERENCES app.tenants (id),
  user_id             uuid NOT NULL REFERENCES app.users (id),
  customer_contact_id uuid NOT NULL,
  device_id           uuid,
  family_id           uuid NOT NULL,
  parent_session_id   uuid,
  refresh_token_hash  bytea NOT NULL UNIQUE,
  status              text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'rotated', 'revoked', 'reuse_detected')),
  issued_at           timestamptz NOT NULL DEFAULT now(),
  expires_at          timestamptz NOT NULL,
  absolute_expires_at timestamptz NOT NULL,
  last_used_at        timestamptz,
  rotated_at          timestamptz,
  revoked_at          timestamptz,
  revoked_reason      text,
  ip                  inet,
  user_agent          text,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  created_by          uuid,
  updated_by          uuid,
  version             integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, customer_contact_id) REFERENCES app.customer_contacts (tenant_id, id),
  FOREIGN KEY (tenant_id, device_id) REFERENCES app.devices (tenant_id, id),
  FOREIGN KEY (tenant_id, parent_session_id) REFERENCES app.auth_sessions (tenant_id, id),
  CHECK (expires_at <= absolute_expires_at),
  CHECK (status <> 'rotated' OR rotated_at IS NOT NULL),
  CHECK (status NOT IN ('revoked', 'reuse_detected') OR revoked_at IS NOT NULL)
);
CREATE INDEX auth_sessions_family_idx ON app.auth_sessions (tenant_id, family_id);
CREATE INDEX auth_sessions_contact_idx ON app.auth_sessions (tenant_id, customer_contact_id, status);
CREATE INDEX auth_sessions_user_id_idx ON app.auth_sessions (user_id);
CREATE INDEX auth_sessions_device_idx ON app.auth_sessions (tenant_id, device_id) WHERE device_id IS NOT NULL;
CREATE INDEX auth_sessions_parent_idx ON app.auth_sessions (tenant_id, parent_session_id) WHERE parent_session_id IS NOT NULL;
COMMENT ON TABLE app.auth_sessions IS 'Sessão própria do contato: um registro por refresh token (hash). Rotação encadeia parent_session_id na mesma family_id; reapresentar um token rotated revoga a família (reuse_detected).';

-- Acesso de suporte da plataforma a um tenant (docs/04 §3.6).
CREATE TABLE app.support_sessions (
  id                      uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id               uuid NOT NULL REFERENCES app.tenants (id),
  requested_by_user_id    uuid NOT NULL REFERENCES app.users (id),
  mode                    text NOT NULL DEFAULT 'read_only' CHECK (mode IN ('read_only', 'read_write')),
  reason                  text NOT NULL CHECK (length(btrim(reason)) > 0),
  support_ticket_ref      text,
  status                  text NOT NULL CHECK (status IN ('pending_approval', 'active', 'ended', 'rejected', 'expired')),
  approved_by_user_id     uuid REFERENCES app.users (id),
  second_approver_user_id uuid REFERENCES app.users (id),
  is_emergency            boolean NOT NULL DEFAULT false,
  starts_at               timestamptz,
  expires_at              timestamptz,
  renewal_count           smallint NOT NULL DEFAULT 0 CHECK (renewal_count BETWEEN 0 AND 1),
  ended_at                timestamptz,
  end_reason              text,
  created_at              timestamptz NOT NULL DEFAULT now(),
  updated_at              timestamptz NOT NULL DEFAULT now(),
  created_by              uuid,
  updated_by              uuid,
  version                 integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  -- read_write exige segundo aprovador (platform_admin) para começar; o pedido pode nascer sem ele.
  CHECK (mode <> 'read_write' OR starts_at IS NULL OR second_approver_user_id IS NOT NULL),
  CHECK (second_approver_user_id IS NULL OR second_approver_user_id <> requested_by_user_id),
  CHECK (status NOT IN ('active', 'ended') OR (starts_at IS NOT NULL AND expires_at IS NOT NULL)),
  CHECK (expires_at IS NULL OR (starts_at IS NOT NULL AND expires_at > starts_at)),
  -- Validade máxima de 60 min, renovável uma vez (+60 min no máximo).
  CHECK (expires_at <= starts_at + interval '60 minutes' * (renewal_count + 1)),
  CHECK (status <> 'ended' OR ended_at IS NOT NULL)
);
CREATE INDEX support_sessions_status_idx ON app.support_sessions (tenant_id, status, starts_at DESC);
CREATE INDEX support_sessions_requested_by_idx ON app.support_sessions (requested_by_user_id, created_at DESC);
CREATE INDEX support_sessions_approved_by_idx ON app.support_sessions (approved_by_user_id) WHERE approved_by_user_id IS NOT NULL;
CREATE INDEX support_sessions_second_approver_idx ON app.support_sessions (second_approver_user_id) WHERE second_approver_user_id IS NOT NULL;
COMMENT ON TABLE app.support_sessions IS 'Sessão de suporte da plataforma num tenant (docs/04 §3.6): motivo, chamado, modo (read_only padrão), aprovação, prazo. A api só aceita X-Support-Session/imp de sessão active e não expirada; toda ação grava audit_logs com o ator real e a sessão. Tabela de tenant (RLS tenant_isolation): o tenant_admin vê as sessões do seu tenant. O console da plataforma cria, lê e encerra sessões com SET LOCAL app.tenant_id do tenant-alvo (o contexto de plataforma nunca libera linhas de tenant, D4). O suporte nunca se loga como um usuário do tenant.';
COMMENT ON COLUMN app.support_sessions.approved_by_user_id IS 'tenant_admin que aprovou (quando a configuração do tenant exige aprovação prévia, padrão). Pode ser nulo com is_emergency = true (exceção registrada e notificada ao tenant_admin) ou quando o tenant dispensa aprovação.';
COMMENT ON COLUMN app.support_sessions.second_approver_user_id IS 'platform_admin (diferente do solicitante) que aprovou o modo read_write. Obrigatório (CHECK) antes de a sessão read_write começar (starts_at preenchido).';
COMMENT ON COLUMN app.support_sessions.expires_at IS 'Fim da validade: no máximo starts_at + 60 min; a única renovação permitida (renewal_count = 1) estende até starts_at + 120 min. Ao passar de expires_at a sessão vai para expired.';

-- =============================================================================
-- 15. Ordens de serviço e visitas (módulos work_orders e scheduling)
-- =============================================================================

CREATE TABLE app.work_orders (
  id                          uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id                   uuid NOT NULL REFERENCES app.tenants (id),
  number                      text NOT NULL,
  number_period               text NOT NULL DEFAULT '',
  number_seq                  bigint,
  work_order_type_id          uuid NOT NULL,
  status                      text NOT NULL DEFAULT 'requested'
                              CHECK (status IN ('requested', 'open', 'scheduled', 'in_progress', 'on_hold', 'completed', 'closed', 'cancelled')),
  status_reason               text,
  status_changed_at           timestamptz NOT NULL DEFAULT now(),
  hold_reason                 text CHECK (hold_reason IN ('awaiting_part', 'awaiting_customer', 'needs_return', 'awaiting_approval', 'other')),
  priority                    text NOT NULL DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  origin                      text NOT NULL CHECK (origin IN ('backoffice', 'customer_app', 'technician_app', 'api', 'file_import', 'preventive_plan',
                                                              'sales_rep', 'telemetry')),
  entry_method                text NOT NULL DEFAULT 'backoffice'
                              CHECK (entry_method IN ('qr_token', 'short_code', 'asset_list', 'backoffice', 'technician_app', 'api', 'file_import', 'preventive_plan',
                                                      'sales_rep', 'telemetry')),
  branch_id                   uuid,
  resolution_mode             text NOT NULL DEFAULT 'field' CHECK (resolution_mode IN ('field', 'remote', 'workshop')),
  acknowledged_at             timestamptz,
  acknowledged_by             uuid,
  escalation_level            smallint NOT NULL DEFAULT 0 CHECK (escalation_level BETWEEN 0 AND 10),
  escalation_policy_id        uuid,
  service_provider_id         uuid,
  maintenance_plan_asset_id   uuid,
  customer_id                 uuid NOT NULL,
  customer_site_id            uuid NOT NULL,
  asset_id                    uuid,
  requested_by_contact_id     uuid,
  requester_name              text,
  requester_phone             text,
  reported_symptom_id         uuid,
  problem_description         text,
  customer_reference          text,
  flag_unverified_requester   boolean NOT NULL DEFAULT false,
  flag_off_site               boolean NOT NULL DEFAULT false,
  flag_typed_code             boolean NOT NULL DEFAULT false,
  duplicate_of_work_order_id  uuid,
  service_area_id             uuid,
  assigned_team_id            uuid,
  assigned_technician_id      uuid,
  preferred_window_start      timestamptz,
  preferred_window_end        timestamptz,
  sla_policy_id               uuid,
  sla_time_basis              text CHECK (sla_time_basis IN ('business_hours', 'calendar')),
  sla_first_response_due_at   timestamptz,
  sla_resolution_due_at       timestamptz,
  sla_paused_since            timestamptz,
  sla_paused_minutes          integer NOT NULL DEFAULT 0 CHECK (sla_paused_minutes >= 0),
  first_response_at           timestamptz,
  sla_first_response_breached boolean NOT NULL DEFAULT false,
  sla_resolution_breached     boolean NOT NULL DEFAULT false,
  failure_cause_id            uuid,
  resolution_code_id          uuid,
  resolution_notes            text,
  triaged_at                  timestamptz,
  triaged_by                  uuid,
  started_at                  timestamptz,
  completed_at                timestamptz,
  completed_by_technician_id  uuid,
  closed_at                   timestamptz,
  closed_by                   uuid,
  cancelled_at                timestamptz,
  cancelled_by                uuid,
  cancellation_reason         text CHECK (cancellation_reason IN ('rejected_in_triage', 'duplicate', 'customer_cancelled', 'created_in_error', 'other')),
  cancellation_note           text,
  reopened_count              integer NOT NULL DEFAULT 0 CHECK (reopened_count >= 0),
  last_reopened_at            timestamptz,
  erp_sync_status             text NOT NULL DEFAULT 'not_required'
                              CHECK (erp_sync_status IN ('not_required', 'pending', 'processing', 'succeeded', 'failed')),
  erp_order_number            text,
  erp_order_id                text,
  erp_synced_at               timestamptz,
  erp_last_error              text,
  row_version                 bigint NOT NULL DEFAULT 0,
  sync_xid                    xid8,
  created_at                  timestamptz NOT NULL DEFAULT now(),
  updated_at                  timestamptz NOT NULL DEFAULT now(),
  created_by                  uuid,
  updated_by                  uuid,
  version                     integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, number),
  FOREIGN KEY (tenant_id, work_order_type_id) REFERENCES app.work_order_types (tenant_id, id),
  FOREIGN KEY (tenant_id, customer_id) REFERENCES app.customers (tenant_id, id),
  FOREIGN KEY (tenant_id, customer_id, customer_site_id) REFERENCES app.customer_sites (tenant_id, customer_id, id),
  FOREIGN KEY (tenant_id, asset_id) REFERENCES app.assets (tenant_id, id),
  FOREIGN KEY (tenant_id, requested_by_contact_id) REFERENCES app.customer_contacts (tenant_id, id),
  FOREIGN KEY (tenant_id, reported_symptom_id) REFERENCES app.symptoms (tenant_id, id),
  FOREIGN KEY (tenant_id, duplicate_of_work_order_id) REFERENCES app.work_orders (tenant_id, id),
  FOREIGN KEY (tenant_id, service_area_id) REFERENCES app.service_areas (tenant_id, id),
  FOREIGN KEY (tenant_id, assigned_team_id) REFERENCES app.teams (tenant_id, id),
  FOREIGN KEY (tenant_id, assigned_technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, sla_policy_id) REFERENCES app.sla_policies (tenant_id, id),
  FOREIGN KEY (tenant_id, failure_cause_id) REFERENCES app.failure_causes (tenant_id, id),
  FOREIGN KEY (tenant_id, resolution_code_id) REFERENCES app.resolution_codes (tenant_id, id),
  FOREIGN KEY (tenant_id, completed_by_technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, branch_id) REFERENCES app.branches (tenant_id, id),
  FOREIGN KEY (tenant_id, escalation_policy_id) REFERENCES app.escalation_policies (tenant_id, id),
  FOREIGN KEY (tenant_id, service_provider_id) REFERENCES app.service_providers (tenant_id, id),
  -- Técnico atribuído pertence ao prestador atribuído (verificada só com os dois preenchidos).
  FOREIGN KEY (tenant_id, service_provider_id, assigned_technician_id) REFERENCES app.technicians (tenant_id, service_provider_id, id),
  CHECK ((acknowledged_at IS NULL) = (acknowledged_by IS NULL)),
  CHECK (escalation_level = 0 OR escalation_policy_id IS NOT NULL),
  CHECK (resolution_mode <> 'remote' OR status NOT IN ('completed', 'closed') OR resolution_notes IS NOT NULL),
  CHECK (status <> 'on_hold' OR hold_reason IS NOT NULL),
  CHECK (status <> 'cancelled' OR (cancelled_at IS NOT NULL AND cancellation_reason IS NOT NULL)),
  CHECK (cancellation_reason IS DISTINCT FROM 'duplicate' OR duplicate_of_work_order_id IS NOT NULL),
  CHECK (duplicate_of_work_order_id IS NULL OR duplicate_of_work_order_id <> id),
  CHECK (status NOT IN ('completed', 'closed') OR completed_at IS NOT NULL),
  CHECK (status <> 'closed' OR closed_at IS NOT NULL),
  CHECK (erp_sync_status <> 'succeeded' OR erp_order_number IS NOT NULL OR erp_order_id IS NOT NULL),
  CHECK (preferred_window_end IS NULL OR preferred_window_start IS NULL OR preferred_window_end > preferred_window_start)
);
CREATE INDEX work_orders_queue_idx ON app.work_orders (tenant_id, status, priority, created_at);
CREATE INDEX work_orders_customer_idx ON app.work_orders (tenant_id, customer_id, customer_site_id, created_at DESC);
CREATE INDEX work_orders_asset_idx ON app.work_orders (tenant_id, asset_id, created_at DESC) WHERE asset_id IS NOT NULL;
CREATE INDEX work_orders_open_by_asset_idx ON app.work_orders (tenant_id, asset_id)
  WHERE asset_id IS NOT NULL AND status IN ('requested', 'open', 'scheduled', 'in_progress', 'on_hold');
CREATE INDEX work_orders_type_idx ON app.work_orders (tenant_id, work_order_type_id, created_at DESC);
CREATE INDEX work_orders_technician_idx ON app.work_orders (tenant_id, assigned_technician_id, status);
CREATE INDEX work_orders_team_idx ON app.work_orders (tenant_id, assigned_team_id, status);
CREATE INDEX work_orders_service_area_idx ON app.work_orders (tenant_id, service_area_id, status);
CREATE INDEX work_orders_contact_idx ON app.work_orders (tenant_id, requested_by_contact_id, created_at DESC) WHERE requested_by_contact_id IS NOT NULL;
CREATE INDEX work_orders_sla_due_idx ON app.work_orders (tenant_id, sla_resolution_due_at)
  WHERE status IN ('requested', 'open', 'scheduled', 'in_progress', 'on_hold');
CREATE INDEX work_orders_erp_pending_idx ON app.work_orders (tenant_id, erp_sync_status) WHERE erp_sync_status IN ('pending', 'processing', 'failed');
CREATE INDEX work_orders_duplicate_of_idx ON app.work_orders (tenant_id, duplicate_of_work_order_id) WHERE duplicate_of_work_order_id IS NOT NULL;
CREATE INDEX work_orders_row_version_idx ON app.work_orders (tenant_id, row_version);
CREATE INDEX work_orders_completed_by_idx ON app.work_orders (tenant_id, completed_by_technician_id, completed_at)
  WHERE completed_by_technician_id IS NOT NULL;
CREATE INDEX work_orders_failure_cause_idx ON app.work_orders (tenant_id, failure_cause_id, completed_at)
  WHERE failure_cause_id IS NOT NULL;
CREATE INDEX work_orders_branch_idx ON app.work_orders (tenant_id, branch_id, created_at DESC) WHERE branch_id IS NOT NULL;
CREATE INDEX work_orders_escalation_policy_idx ON app.work_orders (tenant_id, escalation_policy_id) WHERE escalation_policy_id IS NOT NULL;
CREATE INDEX work_orders_provider_idx ON app.work_orders (tenant_id, service_provider_id, assigned_technician_id, status) WHERE service_provider_id IS NOT NULL;
-- Fila do job de escalonamento (a cada minuto): OS ainda sem "assumi".
CREATE INDEX work_orders_unacknowledged_idx ON app.work_orders (tenant_id, escalation_level, created_at)
  WHERE acknowledged_at IS NULL AND status IN ('requested', 'open');
CREATE INDEX work_orders_resolution_mode_idx ON app.work_orders (tenant_id, resolution_mode, completed_at) WHERE resolution_mode <> 'field';
-- Sem índice de propósito (FKs para cadastros que nunca são apagados fisicamente e
-- sem consulta frequente por esse filtro): reported_symptom_id, sla_policy_id,
-- resolution_code_id e tenant_membership_roles.role_code. Criar quando um
-- relatório passar a filtrar por eles.
COMMENT ON TABLE app.work_orders IS 'Ordem de Serviço (entidade única; chamado do cliente nasce requested). customer_id/customer_site_id são gravados na abertura e não mudam se o ativo for transferido.';
COMMENT ON COLUMN app.work_orders.number IS 'Número legível por tenant (ex.: 2026-000123), atribuído pelo trigger trg_number via tenant_sequences.';
COMMENT ON COLUMN app.work_orders.erp_sync_status IS 'Integração com ERP, separada do status operacional (D9).';
COMMENT ON COLUMN app.work_orders.flag_unverified_requester IS 'Sinalização de triagem: solicitante não cadastrado/aprovado (docs/05).';
COMMENT ON COLUMN app.work_orders.origin IS 'Canal de abertura. v0.2: sales_rep (vendedor abriu em nome do cliente, MVP) e telemetry (regra de alerta de telemetria, F3); preventive_plan (gerada por plano, F2).';
COMMENT ON COLUMN app.work_orders.resolution_mode IS 'v0.2 (MVP). field (padrão: resolvida em visita), remote (resolvida na triagem por orientação por telefone/WhatsApp, sem visita: permite requested -> completed e open -> completed, exige resolution_notes; evento work_order.resolved_remotely) ou workshop (F3: OS de oficina refurbishment/teardown). completed -> closed vale para todos.';
COMMENT ON COLUMN app.work_orders.acknowledged_at IS 'v0.2 (MVP). Primeiro "assumi" de um humano (dispatcher, plantonista, técnico ou prestador); para o escalonamento. Evento work_order.acknowledged.';
COMMENT ON COLUMN app.work_orders.acknowledged_by IS 'v0.2 (MVP). users.id de quem assumiu (sem FK, como closed_by).';
COMMENT ON COLUMN app.work_orders.escalation_level IS 'v0.2 (MVP). Passo atual da política de escalonamento (0 = ninguém avisado além da fila). O job sobe o nível enquanto acknowledged_at for nulo; evento work_order.escalated.';
COMMENT ON COLUMN app.work_orders.service_provider_id IS 'v0.2 (MVP). Prestador a quem a OS foi atribuída (o gestor do prestador escolhe o técnico). Se assigned_technician_id também estiver preenchido, ele é técnico desse prestador (FK composta).';
COMMENT ON COLUMN app.work_orders.maintenance_plan_asset_id IS 'v0.2 (F2). Plano x ativo que gerou a OS (origin = preventive_plan). No máximo uma OS não terminal por plano x ativo (índice único parcial = idempotência do job de geração).';
COMMENT ON COLUMN app.work_orders.branch_id IS 'v0.2 (MVP). Filial da OS (filial do pedido no ERP); padrão = filial do ativo, senão a padrão do tenant.';

CREATE TABLE app.work_order_visits (
  id                      uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id               uuid NOT NULL REFERENCES app.tenants (id),
  work_order_id           uuid NOT NULL,
  visit_number            smallint NOT NULL CHECK (visit_number > 0),
  technician_id           uuid,
  service_provider_id     uuid,
  team_id                 uuid,
  status                  text NOT NULL DEFAULT 'scheduled'
                          CHECK (status IN ('scheduled', 'en_route', 'on_site', 'paused', 'finished', 'cancelled')),
  outcome                 text CHECK (outcome IN ('resolved', 'needs_return', 'customer_absent', 'not_executed')),
  outcome_notes           text,
  scheduled_start         timestamptz NOT NULL,
  scheduled_end           timestamptz NOT NULL,
  travel_started_at       timestamptz,
  checked_in_at           timestamptz,
  finished_at             timestamptz,
  cancelled_at            timestamptz,
  cancellation_reason     text,
  check_in_latitude       double precision CHECK (check_in_latitude BETWEEN -90 AND 90),
  check_in_longitude      double precision CHECK (check_in_longitude BETWEEN -180 AND 180),
  check_in_accuracy_m     double precision CHECK (check_in_accuracy_m IS NULL OR check_in_accuracy_m >= 0),
  check_in_method         text CHECK (check_in_method IN ('qr', 'gps', 'manual')),
  check_in_distance_m     double precision CHECK (check_in_distance_m IS NULL OR check_in_distance_m >= 0),
  check_in_off_site       boolean NOT NULL DEFAULT false,
  finish_latitude         double precision CHECK (finish_latitude BETWEEN -90 AND 90),
  finish_longitude        double precision CHECK (finish_longitude BETWEEN -180 AND 180),
  signature_attachment_id uuid,
  signer_name             text,
  signer_document         text,
  signed_at               timestamptz,
  confirmed_symptom_id    uuid,
  failure_cause_id        uuid,
  resolution_code_id      uuid,
  diagnosis_notes         text,
  row_version             bigint NOT NULL DEFAULT 0,
  sync_xid                xid8,
  created_at              timestamptz NOT NULL DEFAULT now(),
  updated_at              timestamptz NOT NULL DEFAULT now(),
  created_by              uuid,
  updated_by              uuid,
  version                 integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, work_order_id, id),
  UNIQUE (tenant_id, work_order_id, visit_number),
  FOREIGN KEY (tenant_id, work_order_id) REFERENCES app.work_orders (tenant_id, id),
  FOREIGN KEY (tenant_id, technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, team_id) REFERENCES app.teams (tenant_id, id),
  FOREIGN KEY (tenant_id, confirmed_symptom_id) REFERENCES app.symptoms (tenant_id, id),
  FOREIGN KEY (tenant_id, failure_cause_id) REFERENCES app.failure_causes (tenant_id, id),
  FOREIGN KEY (tenant_id, resolution_code_id) REFERENCES app.resolution_codes (tenant_id, id),
  FOREIGN KEY (tenant_id, service_provider_id) REFERENCES app.service_providers (tenant_id, id),
  FOREIGN KEY (tenant_id, service_provider_id, technician_id) REFERENCES app.technicians (tenant_id, service_provider_id, id),
  CHECK (technician_id IS NOT NULL OR service_provider_id IS NOT NULL),
  CHECK (technician_id IS NOT NULL OR status IN ('scheduled', 'cancelled')),
  CHECK (scheduled_end > scheduled_start),
  CHECK ((status = 'finished') = (outcome IS NOT NULL)),
  CHECK (status <> 'finished' OR finished_at IS NOT NULL),
  CHECK (status <> 'cancelled' OR cancelled_at IS NOT NULL),
  CHECK (status NOT IN ('on_site', 'paused', 'finished') OR checked_in_at IS NOT NULL OR outcome IN ('customer_absent', 'not_executed')),
  CHECK ((signature_attachment_id IS NULL) OR (signer_name IS NOT NULL AND signed_at IS NOT NULL))
);
CREATE INDEX work_order_visits_agenda_idx ON app.work_order_visits (tenant_id, technician_id, scheduled_start);
CREATE INDEX work_order_visits_team_idx ON app.work_order_visits (tenant_id, team_id, scheduled_start) WHERE team_id IS NOT NULL;
CREATE INDEX work_order_visits_row_version_idx ON app.work_order_visits (tenant_id, row_version);
CREATE INDEX work_order_visits_symptom_idx ON app.work_order_visits (tenant_id, confirmed_symptom_id) WHERE confirmed_symptom_id IS NOT NULL;
CREATE INDEX work_order_visits_failure_cause_idx ON app.work_order_visits (tenant_id, failure_cause_id) WHERE failure_cause_id IS NOT NULL;
CREATE INDEX work_order_visits_resolution_idx ON app.work_order_visits (tenant_id, resolution_code_id) WHERE resolution_code_id IS NOT NULL;
CREATE INDEX work_order_visits_provider_idx ON app.work_order_visits (tenant_id, service_provider_id, technician_id, scheduled_start) WHERE service_provider_id IS NOT NULL;
COMMENT ON COLUMN app.work_order_visits.check_in_latitude IS 'Latitude do check-in em graus decimais WGS 84 (double precision; double no Dart). Idem check_in_longitude.';
COMMENT ON COLUMN app.work_order_visits.check_in_longitude IS 'Longitude do check-in em graus decimais WGS 84 (double precision).';
COMMENT ON COLUMN app.work_order_visits.check_in_accuracy_m IS 'Precisão informada pelo GPS no check-in, em metros (double precision).';
COMMENT ON COLUMN app.work_order_visits.check_in_distance_m IS 'Distância entre o check-in e a coordenada da unidade, em metros (double precision); base de check_in_off_site.';
COMMENT ON COLUMN app.work_order_visits.finish_latitude IS 'Latitude na finalização, em graus decimais WGS 84 (double precision).';
COMMENT ON COLUMN app.work_order_visits.finish_longitude IS 'Longitude na finalização, em graus decimais WGS 84 (double precision).';
COMMENT ON COLUMN app.work_order_visits.technician_id IS 'Técnico responsável. v0.2 (MVP): pode ficar nulo enquanto a visita estiver atribuída só ao prestador (service_provider_id) e ainda scheduled; o gestor do prestador escolhe o técnico antes do deslocamento (CHECK).';
COMMENT ON COLUMN app.work_order_visits.service_provider_id IS 'v0.2 (MVP). Prestador da visita (técnico terceirizado ou atribuição ao prestador). Com técnico preenchido, ele é do prestador (FK composta). A API preenche ao atribuir um técnico contractor. A tarifa do prestador gera a linha de custo automática ao finalizar (work_order_costs, pending_review), exceto sem check-in válido ou com check_in_off_site (antifraude).';
COMMENT ON TABLE app.work_order_visits IS 'Visita/atendimento de uma OS (uma OS pode ter várias: retorno por falta de peça etc.). Técnico responsável único por visita no MVP. Transições: scheduled -> en_route (visit.start_travel, emite visit.travel_started); scheduled/en_route -> on_site (visit.check_in, emite visit.checked_in).';
COMMENT ON COLUMN app.work_order_visits.check_in_method IS 'Como a presença foi comprovada no check-in: qr (leitura da etiqueta do ativo), gps (dentro do raio do local) ou manual (justificado pelo técnico). A API exige o método em todo check-in novo; nulo apenas em visitas sem check-in.';
COMMENT ON COLUMN app.work_order_visits.check_in_distance_m IS 'Distância, em metros, entre a posição do check-in e a coordenada do local (customer_sites) no momento do check-in.';
COMMENT ON COLUMN app.work_order_visits.check_in_off_site IS 'Check-in feito fora do raio do local; não bloqueia o atendimento, sinaliza para conferência.';
COMMENT ON COLUMN app.work_order_visits.signer_document IS 'Documento (CPF/RG/matrícula) informado por quem assinou o atendimento; dado pessoal, mascarado nas listagens.';
COMMENT ON COLUMN app.work_order_visits.confirmed_symptom_id IS 'Diagnóstico por visita (mutação visit.record_diagnosis, evento visit.diagnosis_recorded): sintoma confirmado em campo. O diagnóstico da OS (work_orders.failure_cause_id/resolution_code_id/resolution_notes) é o da última visita finalizada: ao finalizar uma visita com diagnóstico, a aplicação copia esses campos para a OS; o backoffice pode corrigir a OS na conferência sem alterar a visita.';
COMMENT ON COLUMN app.work_order_visits.failure_cause_id IS 'Causa da falha registrada nesta visita (ver regra em confirmed_symptom_id).';
COMMENT ON COLUMN app.work_order_visits.resolution_code_id IS 'Código de solução aplicado nesta visita (ver regra em confirmed_symptom_id).';
COMMENT ON COLUMN app.work_order_visits.diagnosis_notes IS 'Observações técnicas do diagnóstico desta visita; a da última visita finalizada alimenta work_orders.resolution_notes.';

CREATE TABLE app.work_order_status_history (
  id            uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id     uuid NOT NULL REFERENCES app.tenants (id),
  work_order_id uuid NOT NULL,
  from_status   text CHECK (from_status IN ('requested', 'open', 'scheduled', 'in_progress', 'on_hold', 'completed', 'closed', 'cancelled')),
  to_status     text NOT NULL CHECK (to_status IN ('requested', 'open', 'scheduled', 'in_progress', 'on_hold', 'completed', 'closed', 'cancelled')),
  hold_reason   text,
  reason        text,
  changed_at    timestamptz NOT NULL DEFAULT now(),
  changed_by    uuid,
  actor_type    text,
  created_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id) REFERENCES app.work_orders (tenant_id, id)
);
CREATE INDEX work_order_status_history_wo_idx ON app.work_order_status_history (tenant_id, work_order_id, changed_at);
COMMENT ON TABLE app.work_order_status_history IS 'Histórico de status da OS (append-only, gravado por trigger). Base de tempos de SLA e relatórios.';

CREATE TABLE app.work_order_comments (
  id                   uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id            uuid NOT NULL REFERENCES app.tenants (id),
  work_order_id        uuid NOT NULL,
  visit_id             uuid,
  visibility           text NOT NULL DEFAULT 'internal' CHECK (visibility IN ('internal', 'customer')),
  author_type          text NOT NULL CHECK (author_type IN ('user', 'technician', 'customer_contact', 'system')),
  author_user_id       uuid,
  author_technician_id uuid,
  author_contact_id    uuid,
  body                 text NOT NULL CHECK (length(body) BETWEEN 1 AND 10000),
  edited_at            timestamptz,
  deleted_at           timestamptz,
  row_version          bigint NOT NULL DEFAULT 0,
  sync_xid             xid8,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),
  created_by           uuid,
  updated_by           uuid,
  version              integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id) REFERENCES app.work_orders (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id, visit_id) REFERENCES app.work_order_visits (tenant_id, work_order_id, id),
  FOREIGN KEY (tenant_id, author_technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, author_contact_id) REFERENCES app.customer_contacts (tenant_id, id),
  CHECK (author_type <> 'customer_contact' OR (visibility = 'customer' AND author_contact_id IS NOT NULL)),
  CHECK (author_type <> 'technician' OR author_technician_id IS NOT NULL)
);
CREATE INDEX work_order_comments_wo_idx ON app.work_order_comments (tenant_id, work_order_id, visit_id, created_at);
CREATE INDEX work_order_comments_technician_idx ON app.work_order_comments (tenant_id, author_technician_id) WHERE author_technician_id IS NOT NULL;
CREATE INDEX work_order_comments_contact_idx ON app.work_order_comments (tenant_id, author_contact_id) WHERE author_contact_id IS NOT NULL;
CREATE INDEX work_order_comments_row_version_idx ON app.work_order_comments (tenant_id, row_version);
COMMENT ON TABLE app.work_order_comments IS 'Comentário da OS: internal (só equipe) ou customer (visível ao cliente). Exclusão lógica (deleted_at).';

CREATE TABLE app.work_order_feedback (
  id                  uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id           uuid NOT NULL REFERENCES app.tenants (id),
  work_order_id       uuid NOT NULL,
  customer_contact_id uuid NOT NULL,
  rating              smallint NOT NULL CHECK (rating BETWEEN 1 AND 5),
  nps_score           smallint CHECK (nps_score BETWEEN 0 AND 10),
  comment             text CHECK (length(comment) <= 2000),
  submitted_at        timestamptz NOT NULL DEFAULT now(),
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  created_by          uuid,
  updated_by          uuid,
  version             integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, work_order_id),
  FOREIGN KEY (tenant_id, work_order_id) REFERENCES app.work_orders (tenant_id, id),
  FOREIGN KEY (tenant_id, customer_contact_id) REFERENCES app.customer_contacts (tenant_id, id)
);
CREATE INDEX work_order_feedback_contact_idx ON app.work_order_feedback (tenant_id, customer_contact_id);
COMMENT ON TABLE app.work_order_feedback IS 'Avaliação do cliente (uma por OS), liberada após completed/closed.';

-- =============================================================================
-- 16. Execução em campo e sync (módulo field_execution)
-- =============================================================================

CREATE TABLE app.time_entries (
  id                  uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id           uuid NOT NULL REFERENCES app.tenants (id),
  work_order_id       uuid NOT NULL,
  visit_id            uuid,
  technician_id       uuid NOT NULL,
  type                text NOT NULL CHECK (type IN ('travel', 'work', 'pause')),
  started_at          timestamptz NOT NULL,
  ended_at            timestamptz,
  duration_minutes    integer GENERATED ALWAYS AS (
                        CASE WHEN ended_at IS NULL THEN NULL
                             ELSE round(extract(epoch FROM (ended_at - started_at)) / 60)::integer END) STORED,
  source              text NOT NULL DEFAULT 'visit_transition' CHECK (source IN ('visit_transition', 'manual', 'backoffice')),
  justification       text,
  approval_status     text NOT NULL DEFAULT 'pending' CHECK (approval_status IN ('pending', 'approved', 'rejected')),
  approved_by         uuid,
  approved_at         timestamptz,
  rejection_reason    text,
  hour_classification text CHECK (hour_classification IN ('regular', 'overtime', 'night', 'holiday')),
  voided_at           timestamptz,
  void_reason         text,
  notes               text,
  row_version         bigint NOT NULL DEFAULT 0,
  sync_xid            xid8,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  created_by          uuid,
  updated_by          uuid,
  version             integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id) REFERENCES app.work_orders (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id, visit_id) REFERENCES app.work_order_visits (tenant_id, work_order_id, id),
  FOREIGN KEY (tenant_id, technician_id) REFERENCES app.technicians (tenant_id, id),
  CHECK (ended_at IS NULL OR ended_at > started_at),
  CHECK (source = 'visit_transition' OR justification IS NOT NULL),
  CHECK (approval_status = 'pending' OR (approved_by IS NOT NULL AND approved_at IS NOT NULL)),
  CHECK (approval_status <> 'rejected' OR rejection_reason IS NOT NULL),
  CHECK ((voided_at IS NULL) = (void_reason IS NULL)),
  EXCLUDE USING gist (tenant_id WITH =, technician_id WITH =, tstzrange(started_at, ended_at, '[)') WITH &&)
    WHERE (voided_at IS NULL AND approval_status <> 'rejected')
);
CREATE INDEX time_entries_wo_idx ON app.time_entries (tenant_id, work_order_id, visit_id);
CREATE INDEX time_entries_pending_idx ON app.time_entries (tenant_id, approval_status, started_at) WHERE approval_status = 'pending' AND voided_at IS NULL;
CREATE INDEX time_entries_row_version_idx ON app.time_entries (tenant_id, row_version);
COMMENT ON TABLE app.time_entries IS 'Apontamento de horas (travel/work/pause). Sem sobreposição por técnico (exclusion constraint). Gerado pelas transições da visita ou manual com justificativa; aprovado pelo backoffice.';
COMMENT ON COLUMN app.time_entries.duration_minutes IS 'Duração calculada em minutos inteiros, arredondada ao minuto mais próximo (integer; int no Dart). v0.3: era numeric(10,2). Cálculos de custo usam started_at/ended_at quando precisarem de fração.';
COMMENT ON COLUMN app.time_entries.hour_classification IS 'Fase 2: classificação normal/extra/noturna/feriado calculada pelo turno (work_shifts) e calendário.';

CREATE TABLE app.work_order_items (
  id                uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id         uuid NOT NULL REFERENCES app.tenants (id),
  work_order_id     uuid NOT NULL,
  visit_id          uuid,
  technician_id     uuid,
  kind              text NOT NULL CHECK (kind IN ('product', 'service')),
  product_id        uuid,
  service_id        uuid,
  item_code         text NOT NULL,
  description       text NOT NULL,
  unit_code         text NOT NULL,
  quantity          bigint NOT NULL CHECK (quantity > 0),
  unit_price        bigint NOT NULL DEFAULT 0 CHECK (unit_price >= 0),
  discount_amount   bigint NOT NULL DEFAULT 0 CHECK (discount_amount >= 0),
  total_amount      bigint GENERATED ALWAYS AS (app.line_amount_cents(quantity, unit_price) - discount_amount) STORED,
  billing_type      text NOT NULL DEFAULT 'billable' CHECK (billing_type IN ('billable', 'warranty', 'contract', 'no_charge')),
  billing_note      text,
  price_source      text NOT NULL DEFAULT 'catalog' CHECK (price_source IN ('catalog', 'erp_price_list', 'manual')),
  added_via         text NOT NULL CHECK (added_via IN ('technician_app', 'backoffice', 'api')),
  part_serial_number text,
  voided_at         timestamptz,
  void_reason       text,
  erp_line_reference text,
  source_time_entry_ids uuid[],
  stock_requisition_status text NOT NULL DEFAULT 'not_required'
                    CHECK (stock_requisition_status IN ('not_required', 'pending', 'approved', 'rejected', 'issued')),
  erp_requisition_ref text,
  row_version       bigint NOT NULL DEFAULT 0,
  sync_xid          xid8,
  created_at        timestamptz NOT NULL DEFAULT now(),
  updated_at        timestamptz NOT NULL DEFAULT now(),
  created_by        uuid,
  updated_by        uuid,
  version           integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, work_order_id, id),
  CHECK (stock_requisition_status = 'not_required' OR kind = 'product'),
  CHECK (stock_requisition_status <> 'issued' OR erp_requisition_ref IS NOT NULL),
  FOREIGN KEY (tenant_id, work_order_id) REFERENCES app.work_orders (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id, visit_id) REFERENCES app.work_order_visits (tenant_id, work_order_id, id),
  FOREIGN KEY (tenant_id, technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, product_id) REFERENCES app.products (tenant_id, id),
  FOREIGN KEY (tenant_id, service_id) REFERENCES app.services (tenant_id, id),
  CHECK ((kind = 'product' AND product_id IS NOT NULL AND service_id IS NULL)
      OR (kind = 'service' AND service_id IS NOT NULL AND product_id IS NULL)),
  CHECK (discount_amount <= app.line_amount_cents(quantity, unit_price)),
  CHECK (billing_type = 'billable' OR discount_amount = 0),
  CHECK ((voided_at IS NULL) = (void_reason IS NULL))
);
CREATE INDEX work_order_items_wo_idx ON app.work_order_items (tenant_id, work_order_id, visit_id);
CREATE INDEX work_order_items_product_idx ON app.work_order_items (tenant_id, product_id) WHERE product_id IS NOT NULL;
CREATE INDEX work_order_items_service_idx ON app.work_order_items (tenant_id, service_id) WHERE service_id IS NOT NULL;
CREATE INDEX work_order_items_technician_idx ON app.work_order_items (tenant_id, technician_id) WHERE technician_id IS NOT NULL;
CREATE INDEX work_order_items_row_version_idx ON app.work_order_items (tenant_id, row_version);
COMMENT ON TABLE app.work_order_items IS 'Item da OS (peça ou serviço): produto XOR serviço; item_code/description/unit_code/unit_price são snapshot do momento do lançamento.';
COMMENT ON COLUMN app.work_order_items.quantity IS 'Quantidade em milésimos da unidade (bigint; 1,5 m = 1500; 2 UN = 2000).';
COMMENT ON COLUMN app.work_order_items.unit_price IS 'Preço unitário (snapshot) em centavos (bigint; R$ 12,34 = 1234).';
COMMENT ON COLUMN app.work_order_items.discount_amount IS 'Desconto da linha em centavos (bigint); não passa do bruto da linha.';
COMMENT ON COLUMN app.work_order_items.total_amount IS 'Total da linha em centavos (bigint, coluna gerada): app.line_amount_cents(quantity, unit_price) - discount_amount.';
COMMENT ON COLUMN app.work_order_items.billing_type IS 'billable | warranty | contract (comodato/contrato de manutenção) | no_charge.';
CREATE INDEX work_order_items_source_time_entries_idx ON app.work_order_items USING gin (source_time_entry_ids) WHERE source_time_entry_ids IS NOT NULL;
CREATE INDEX work_order_items_requisition_idx ON app.work_order_items (tenant_id, stock_requisition_status, created_at)
  WHERE stock_requisition_status IN ('pending', 'approved');
COMMENT ON COLUMN app.work_order_items.stock_requisition_status IS 'v0.2 (F2). Requisição da peça ao estoque do ERP (capacidade create_stock_requisition do conector): not_required -> pending -> approved/rejected -> issued (baixa no ERP vinculada à OS; o custo da peça vem da baixa e gera work_order_costs parts). Só para kind = product. Evento work_order_item.requisition_status_changed.';
COMMENT ON COLUMN app.work_order_items.erp_requisition_ref IS 'v0.2 (F2). Número/id da requisição ou da baixa no ERP; obrigatório em issued.';
COMMENT ON COLUMN app.work_order_items.source_time_entry_ids IS 'Apontamentos (time_entries.id da mesma OS) que geraram este item na conferência (docs/07 §9.4: work -> serviço labour, travel -> serviço travel). Sem FK por ser array: a aplicação valida, na mesma transação, que cada id existe no mesmo tenant e OS e não está em outro item não anulado; anular o item libera os apontamentos para nova conversão.';

CREATE TABLE app.checklist_responses (
  id                         uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id                  uuid NOT NULL REFERENCES app.tenants (id),
  work_order_id              uuid NOT NULL,
  visit_id                   uuid NOT NULL,
  checklist_template_id      uuid NOT NULL,
  template_version           integer NOT NULL,
  status                     text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'submitted')),
  answers                    jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(answers) = 'object'),
  submitted_at               timestamptz,
  submitted_by_technician_id uuid,
  row_version                bigint NOT NULL DEFAULT 0,
  sync_xid                   xid8,
  created_at                 timestamptz NOT NULL DEFAULT now(),
  updated_at                 timestamptz NOT NULL DEFAULT now(),
  created_by                 uuid,
  updated_by                 uuid,
  version                    integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, visit_id, checklist_template_id),
  FOREIGN KEY (tenant_id, work_order_id) REFERENCES app.work_orders (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id, visit_id) REFERENCES app.work_order_visits (tenant_id, work_order_id, id),
  FOREIGN KEY (tenant_id, checklist_template_id) REFERENCES app.checklist_templates (tenant_id, id),
  FOREIGN KEY (tenant_id, submitted_by_technician_id) REFERENCES app.technicians (tenant_id, id),
  CHECK (status <> 'submitted' OR submitted_at IS NOT NULL)
);
CREATE INDEX checklist_responses_wo_idx ON app.checklist_responses (tenant_id, work_order_id, visit_id);
CREATE INDEX checklist_responses_template_idx ON app.checklist_responses (tenant_id, checklist_template_id);
CREATE INDEX checklist_responses_technician_idx ON app.checklist_responses (tenant_id, submitted_by_technician_id) WHERE submitted_by_technician_id IS NOT NULL;
CREATE INDEX checklist_responses_row_version_idx ON app.checklist_responses (tenant_id, row_version);
COMMENT ON TABLE app.checklist_responses IS 'Respostas de um checklist numa visita (vinculadas à versão do modelo).';

CREATE TABLE app.attachments (
  id                        uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id                 uuid NOT NULL REFERENCES app.tenants (id),
  kind                      text NOT NULL CHECK (kind IN ('photo', 'signature', 'document', 'audio', 'video')),
  category                  text CHECK (category IN ('comodato_contract', 'invoice', 'manual', 'movement_term', 'photo', 'other')),
  work_order_id             uuid,
  visit_id                  uuid,
  comment_id                uuid,
  checklist_response_id     uuid,
  asset_id                  uuid,
  product_id                uuid,
  storage_key               text NOT NULL UNIQUE,
  file_name                 text,
  content_type              text NOT NULL,
  size_bytes                bigint CHECK (size_bytes >= 0),
  sha256                    bytea,
  upload_status             text NOT NULL DEFAULT 'pending' CHECK (upload_status IN ('pending', 'uploaded', 'failed', 'quarantined', 'deleted')),
  uploaded_at               timestamptz,
  visible_to_customer       boolean NOT NULL DEFAULT false,
  caption                   text,
  captured_at               timestamptz,
  captured_by_technician_id uuid,
  captured_by_contact_id    uuid,
  latitude                  double precision CHECK (latitude BETWEEN -90 AND 90),
  longitude                 double precision CHECK (longitude BETWEEN -180 AND 180),
  deleted_at                timestamptz,
  row_version               bigint NOT NULL DEFAULT 0,
  sync_xid                  xid8,
  created_at                timestamptz NOT NULL DEFAULT now(),
  updated_at                timestamptz NOT NULL DEFAULT now(),
  created_by                uuid,
  updated_by                uuid,
  version                   integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id) REFERENCES app.work_orders (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id, visit_id) REFERENCES app.work_order_visits (tenant_id, work_order_id, id),
  FOREIGN KEY (tenant_id, comment_id) REFERENCES app.work_order_comments (tenant_id, id),
  FOREIGN KEY (tenant_id, checklist_response_id) REFERENCES app.checklist_responses (tenant_id, id),
  FOREIGN KEY (tenant_id, asset_id) REFERENCES app.assets (tenant_id, id),
  FOREIGN KEY (tenant_id, product_id) REFERENCES app.products (tenant_id, id),
  FOREIGN KEY (tenant_id, captured_by_technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, captured_by_contact_id) REFERENCES app.customer_contacts (tenant_id, id),
  CHECK (num_nonnulls(work_order_id, asset_id, product_id) >= 1),
  CHECK (visit_id IS NULL OR work_order_id IS NOT NULL),
  CHECK (comment_id IS NULL OR work_order_id IS NOT NULL),
  CHECK (checklist_response_id IS NULL OR work_order_id IS NOT NULL),
  CHECK (kind <> 'signature' OR visit_id IS NOT NULL),
  CHECK (starts_with(storage_key, 't/' || tenant_id::text || '/')),
  CHECK (category IS NULL OR asset_id IS NOT NULL OR product_id IS NOT NULL),
  CHECK (category IS DISTINCT FROM 'movement_term' OR (asset_id IS NOT NULL AND kind = 'document'))
);
CREATE INDEX attachments_asset_category_idx ON app.attachments (tenant_id, asset_id, category) WHERE category IS NOT NULL;
CREATE INDEX attachments_wo_idx ON app.attachments (tenant_id, work_order_id, visit_id) WHERE work_order_id IS NOT NULL;
CREATE INDEX attachments_comment_idx ON app.attachments (tenant_id, comment_id) WHERE comment_id IS NOT NULL;
CREATE INDEX attachments_checklist_idx ON app.attachments (tenant_id, checklist_response_id) WHERE checklist_response_id IS NOT NULL;
CREATE INDEX attachments_asset_idx ON app.attachments (tenant_id, asset_id) WHERE asset_id IS NOT NULL;
CREATE INDEX attachments_product_idx ON app.attachments (tenant_id, product_id) WHERE product_id IS NOT NULL;
CREATE INDEX attachments_technician_idx ON app.attachments (tenant_id, captured_by_technician_id) WHERE captured_by_technician_id IS NOT NULL;
CREATE INDEX attachments_contact_idx ON app.attachments (tenant_id, captured_by_contact_id) WHERE captured_by_contact_id IS NOT NULL;
CREATE INDEX attachments_pending_idx ON app.attachments (tenant_id, upload_status, created_at) WHERE upload_status = 'pending';
CREATE INDEX attachments_row_version_idx ON app.attachments (tenant_id, row_version);
COMMENT ON TABLE app.attachments IS 'Anexo (foto, assinatura, documento): metadados; o binário fica no object storage sob t/<tenant_id>/ (CHECK). Registro criado antes do upload (upload_status pending).';
COMMENT ON COLUMN app.attachments.latitude IS 'Latitude da captura em graus decimais WGS 84 (double precision; double no Dart).';
COMMENT ON COLUMN app.attachments.longitude IS 'Longitude da captura em graus decimais WGS 84 (double precision; double no Dart).';
COMMENT ON COLUMN app.attachments.category IS 'v0.2 (MVP). Categoria de documento do ativo ou do modelo (exige asset_id ou product_id): comodato_contract (contrato de comodato emitido pelo ERP; upload no MVP, pelo ERP na F2), invoice (NF), manual (manual técnico; offline no app na F2), movement_term (termo de movimentação em PDF, só no ativo e kind = document), photo, other. Nulo nos anexos de OS/visita/comentário/checklist.';

-- Deferidas (referências circulares): foto da posição da etiqueta, assinatura da visita,
-- OS de instalação/recolhimento na alocação e OS do vínculo da etiqueta.
ALTER TABLE app.products
  ADD FOREIGN KEY (tenant_id, label_position_attachment_id) REFERENCES app.attachments (tenant_id, id);
CREATE INDEX products_label_attachment_idx ON app.products (tenant_id, label_position_attachment_id) WHERE label_position_attachment_id IS NOT NULL;
ALTER TABLE app.work_order_visits
  ADD FOREIGN KEY (tenant_id, signature_attachment_id) REFERENCES app.attachments (tenant_id, id);
CREATE INDEX work_order_visits_signature_idx ON app.work_order_visits (tenant_id, signature_attachment_id) WHERE signature_attachment_id IS NOT NULL;
ALTER TABLE app.asset_assignments
  ADD FOREIGN KEY (tenant_id, work_order_id) REFERENCES app.work_orders (tenant_id, id),
  ADD FOREIGN KEY (tenant_id, ended_work_order_id) REFERENCES app.work_orders (tenant_id, id);
CREATE INDEX asset_assignments_wo_idx ON app.asset_assignments (tenant_id, work_order_id) WHERE work_order_id IS NOT NULL;
CREATE INDEX asset_assignments_ended_wo_idx ON app.asset_assignments (tenant_id, ended_work_order_id) WHERE ended_work_order_id IS NOT NULL;
ALTER TABLE app.qr_tags
  ADD FOREIGN KEY (tenant_id, bound_work_order_id) REFERENCES app.work_orders (tenant_id, id);
CREATE INDEX qr_tags_bound_wo_idx ON app.qr_tags (tenant_id, bound_work_order_id) WHERE bound_work_order_id IS NOT NULL;
ALTER TABLE app.asset_assignments
  ADD FOREIGN KEY (tenant_id, term_attachment_id) REFERENCES app.attachments (tenant_id, id);
CREATE INDEX asset_assignments_term_idx ON app.asset_assignments (tenant_id, term_attachment_id) WHERE term_attachment_id IS NOT NULL;

-- v0.2: fechamento de prestadores (F2) e custos da OS (MVP), módulo field_execution.
CREATE TABLE app.provider_settlements (
  id                      uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id               uuid NOT NULL REFERENCES app.tenants (id),
  service_provider_id     uuid NOT NULL,
  branch_id               uuid,
  period_start            date NOT NULL,
  period_end              date NOT NULL,
  status                  text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'approved', 'sent_to_erp')),
  total_amount            bigint NOT NULL DEFAULT 0 CHECK (total_amount >= 0),
  line_count             integer NOT NULL DEFAULT 0 CHECK (line_count >= 0),
  statement_attachment_id uuid,
  approved_by             uuid,
  approved_at             timestamptz,
  sent_to_erp_at          timestamptz,
  erp_document_ref        text,
  notes                   text,
  created_at              timestamptz NOT NULL DEFAULT now(),
  updated_at              timestamptz NOT NULL DEFAULT now(),
  created_by              uuid,
  updated_by              uuid,
  version                 integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, service_provider_id, id),
  FOREIGN KEY (tenant_id, service_provider_id) REFERENCES app.service_providers (tenant_id, id),
  FOREIGN KEY (tenant_id, branch_id) REFERENCES app.branches (tenant_id, id),
  FOREIGN KEY (tenant_id, statement_attachment_id) REFERENCES app.attachments (tenant_id, id),
  CHECK (period_end >= period_start),
  CHECK (status = 'draft' OR (approved_by IS NOT NULL AND approved_at IS NOT NULL)),
  CHECK (status <> 'sent_to_erp' OR sent_to_erp_at IS NOT NULL),
  EXCLUDE USING gist (tenant_id WITH =, service_provider_id WITH =,
                      (coalesce(branch_id, '00000000-0000-0000-0000-000000000000'::uuid)) WITH =,
                      daterange(period_start, period_end, '[]') WITH &&)
);
CREATE INDEX provider_settlements_branch_idx ON app.provider_settlements (tenant_id, branch_id) WHERE branch_id IS NOT NULL;
CREATE INDEX provider_settlements_statement_idx ON app.provider_settlements (tenant_id, statement_attachment_id) WHERE statement_attachment_id IS NOT NULL;
CREATE INDEX provider_settlements_status_idx ON app.provider_settlements (tenant_id, status, period_end) WHERE status <> 'sent_to_erp';
COMMENT ON TABLE app.provider_settlements IS 'v0.2 (F2, módulo field_execution). Fechamento do prestador num período: agrupa linhas approved de work_order_costs (settlement_id), draft -> approved -> sent_to_erp, com demonstrativo em PDF (statement_attachment_id) e envio ao ERP como conta a pagar ou nota de serviço tomado (a validar com a Senior). Períodos sem sobreposição por prestador e filial. Eventos provider_settlement.approved/.sent_to_erp.';
COMMENT ON COLUMN app.provider_settlements.total_amount IS 'Soma das linhas do fechamento em centavos (bigint), recalculada pela aplicação enquanto draft e congelada na aprovação.';

CREATE TABLE app.work_order_costs (
  id                  uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id           uuid NOT NULL REFERENCES app.tenants (id),
  work_order_id       uuid NOT NULL,
  visit_id            uuid,
  work_order_item_id  uuid,
  service_provider_id uuid,
  provider_rate_id    uuid,
  settlement_id       uuid,
  cost_type           text NOT NULL CHECK (cost_type IN ('parts', 'own_labor', 'third_party_labor', 'travel', 'other')),
  source              text NOT NULL DEFAULT 'manual' CHECK (source IN ('provider_rate', 'time_entry', 'erp_issue', 'manual')),
  status              text NOT NULL DEFAULT 'pending_review' CHECK (status IN ('pending_review', 'approved', 'rejected')),
  description         text NOT NULL,
  quantity            bigint NOT NULL DEFAULT 1000 CHECK (quantity > 0),
  unit_cost           bigint NOT NULL CHECK (unit_cost >= 0),
  total_amount        bigint GENERATED ALWAYS AS (app.line_amount_cents(quantity, unit_cost)) STORED,
  incurred_at         timestamptz NOT NULL DEFAULT now(),
  reviewed_by         uuid,
  reviewed_at         timestamptz,
  rejection_reason    text,
  notes               text,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  created_by          uuid,
  updated_by          uuid,
  version             integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id) REFERENCES app.work_orders (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id, visit_id) REFERENCES app.work_order_visits (tenant_id, work_order_id, id),
  FOREIGN KEY (tenant_id, work_order_id, work_order_item_id) REFERENCES app.work_order_items (tenant_id, work_order_id, id),
  FOREIGN KEY (tenant_id, service_provider_id) REFERENCES app.service_providers (tenant_id, id),
  FOREIGN KEY (tenant_id, service_provider_id, provider_rate_id) REFERENCES app.provider_rates (tenant_id, service_provider_id, id),
  FOREIGN KEY (tenant_id, service_provider_id, settlement_id) REFERENCES app.provider_settlements (tenant_id, service_provider_id, id),
  CHECK (cost_type <> 'third_party_labor' OR service_provider_id IS NOT NULL),
  CHECK (provider_rate_id IS NULL OR service_provider_id IS NOT NULL),
  CHECK (settlement_id IS NULL OR (service_provider_id IS NOT NULL AND status = 'approved')),
  CHECK (source <> 'provider_rate' OR (provider_rate_id IS NOT NULL AND visit_id IS NOT NULL)),
  CHECK (status = 'pending_review' OR (reviewed_by IS NOT NULL AND reviewed_at IS NOT NULL)),
  CHECK (status <> 'rejected' OR rejection_reason IS NOT NULL)
);
-- Idempotência da linha automática: uma por visita e tarifa.
CREATE UNIQUE INDEX work_order_costs_rate_line_key ON app.work_order_costs (tenant_id, visit_id, provider_rate_id) WHERE source = 'provider_rate';
CREATE INDEX work_order_costs_wo_idx ON app.work_order_costs (tenant_id, work_order_id, visit_id);
CREATE INDEX work_order_costs_item_idx ON app.work_order_costs (tenant_id, work_order_id, work_order_item_id) WHERE work_order_item_id IS NOT NULL;
CREATE INDEX work_order_costs_provider_idx ON app.work_order_costs (tenant_id, service_provider_id, status, incurred_at) WHERE service_provider_id IS NOT NULL;
CREATE INDEX work_order_costs_rate_idx ON app.work_order_costs (tenant_id, service_provider_id, provider_rate_id) WHERE provider_rate_id IS NOT NULL;
CREATE INDEX work_order_costs_settlement_idx ON app.work_order_costs (tenant_id, service_provider_id, settlement_id) WHERE settlement_id IS NOT NULL;
CREATE INDEX work_order_costs_review_idx ON app.work_order_costs (tenant_id, status, created_at) WHERE status = 'pending_review';
COMMENT ON TABLE app.work_order_costs IS 'v0.2 (MVP, módulo field_execution). Linha de custo da OS (custo para o tenant, não preço ao cliente): parts, own_labor, third_party_labor, travel, other; opcionalmente ligada à visita, ao item, ao prestador, à tarifa e ao fechamento (F2), sempre da mesma OS e do mesmo prestador (FKs compostas). Nasce pending_review e só entra nos relatórios e no fechamento depois de approved (conferência no backoffice). Valores em centavos e quantidade em milésimos (bigint), não negativos. Eventos work_order_cost.added/.reviewed.';
COMMENT ON COLUMN app.work_order_costs.quantity IS 'Quantidade em milésimos (bigint; padrão 1000 = 1 unidade; 2,5 h = 2500; 12,3 km = 12300).';
COMMENT ON COLUMN app.work_order_costs.unit_cost IS 'Custo unitário em centavos (bigint; R$ 180,00 = 18000).';
COMMENT ON COLUMN app.work_order_costs.total_amount IS 'Total em centavos (bigint, coluna gerada): app.line_amount_cents(quantity, unit_cost).';
COMMENT ON COLUMN app.work_order_costs.source IS 'provider_rate (linha automática da tarifa do prestador ao finalizar a visita; uma por visita e tarifa), time_entry (mão de obra própria: horas aprovadas x technicians.hourly_cost), erp_issue (F2: custo da peça pela baixa da requisição no ERP), manual (lançada no backoffice).';
COMMENT ON COLUMN app.work_order_costs.settlement_id IS 'v0.2 (F2). Fechamento que pagou a linha; só linhas approved do mesmo prestador (FK composta + CHECK).';

-- =============================================================================
-- 16b. Manutenção preventiva e medidores (módulo maintenance) — v0.2, F2
-- =============================================================================

CREATE TABLE app.maintenance_plans (
  id                    uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id             uuid NOT NULL REFERENCES app.tenants (id),
  code                  text NOT NULL,
  name                  text NOT NULL,
  description           text,
  work_order_type_id    uuid NOT NULL,
  checklist_template_id uuid,
  priority              text NOT NULL DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  trigger_type          text NOT NULL CHECK (trigger_type IN ('interval_days', 'monthly_day', 'meter')),
  interval_days         integer,
  monthly_day           smallint,
  meter_type            text CHECK (meter_type IN ('hour_meter', 'energy_kwh', 'temperature', 'cycles')),
  meter_interval        double precision,
  lead_days             integer NOT NULL DEFAULT 0 CHECK (lead_days >= 0),
  tolerance_days        integer NOT NULL DEFAULT 0 CHECK (tolerance_days >= 0),
  meter_lead            double precision NOT NULL DEFAULT 0 CHECK (meter_lead >= 0),
  applies_to            text NOT NULL DEFAULT 'asset' CHECK (applies_to IN ('product', 'asset')),
  product_id            uuid,
  group_by_site         boolean NOT NULL DEFAULT true,
  starts_on             date,
  is_active             boolean NOT NULL DEFAULT true,
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now(),
  created_by            uuid,
  updated_by            uuid,
  version               integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, code),
  FOREIGN KEY (tenant_id, work_order_type_id) REFERENCES app.work_order_types (tenant_id, id),
  FOREIGN KEY (tenant_id, checklist_template_id) REFERENCES app.checklist_templates (tenant_id, id),
  FOREIGN KEY (tenant_id, product_id) REFERENCES app.products (tenant_id, id),
  CONSTRAINT maintenance_plans_interval_days_check CHECK (trigger_type <> 'interval_days'
    OR (interval_days > 0 AND monthly_day IS NULL AND meter_type IS NULL AND meter_interval IS NULL)),
  CONSTRAINT maintenance_plans_monthly_day_check CHECK (trigger_type <> 'monthly_day'
    OR (monthly_day BETWEEN 1 AND 28 AND interval_days IS NULL AND meter_type IS NULL AND meter_interval IS NULL)),
  CONSTRAINT maintenance_plans_meter_check CHECK (trigger_type <> 'meter'
    OR (meter_type IS NOT NULL AND meter_interval > 0 AND interval_days IS NULL AND monthly_day IS NULL)),
  CONSTRAINT maintenance_plans_scope_check CHECK ((applies_to = 'product') = (product_id IS NOT NULL))
);
CREATE INDEX maintenance_plans_type_idx ON app.maintenance_plans (tenant_id, work_order_type_id);
CREATE INDEX maintenance_plans_checklist_idx ON app.maintenance_plans (tenant_id, checklist_template_id) WHERE checklist_template_id IS NOT NULL;
CREATE INDEX maintenance_plans_product_idx ON app.maintenance_plans (tenant_id, product_id) WHERE product_id IS NOT NULL;
COMMENT ON TABLE app.maintenance_plans IS 'v0.2 (F2, módulo maintenance). Plano de manutenção preventiva: tipo de OS, checklist, gatilho (interval_days: a cada N dias; monthly_day: dia fixo do mês, 1 a 28 para valer em fevereiro; meter: a cada meter_interval unidades do medidor meter_type), antecedência (lead_days / meter_lead), tolerância (tolerance_days) e aplicação por modelo (product) ou por ativo. CHECKs por trigger_type garantem que só os campos do gatilho escolhido estejam preenchidos.';
COMMENT ON COLUMN app.maintenance_plans.meter_interval IS 'Intervalo do gatilho meter, na unidade do medidor (asset_meters.unit_code: h, kWh, ciclos); double precision (medida, não dinheiro).';
COMMENT ON COLUMN app.maintenance_plans.meter_lead IS 'Antecedência do gatilho meter, na unidade do medidor (double precision).';
COMMENT ON COLUMN app.maintenance_plans.group_by_site IS 'Agrupa as OS geradas no mesmo dia por cliente/unidade, para uma visita atender vários ativos.';

CREATE TABLE app.asset_meters (
  id              uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id       uuid NOT NULL REFERENCES app.tenants (id),
  asset_id        uuid NOT NULL,
  meter_type      text NOT NULL CHECK (meter_type IN ('hour_meter', 'energy_kwh', 'temperature', 'cycles')),
  name            text NOT NULL,
  unit_code       text NOT NULL,
  is_cumulative   boolean NOT NULL,
  current_value   double precision,
  current_read_at timestamptz,
  is_active       boolean NOT NULL DEFAULT true,
  row_version     bigint NOT NULL DEFAULT 0,
  sync_xid        xid8,
  created_at      timestamptz NOT NULL DEFAULT now(),
  updated_at      timestamptz NOT NULL DEFAULT now(),
  created_by      uuid,
  updated_by      uuid,
  version         integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, asset_id, name),
  FOREIGN KEY (tenant_id, asset_id) REFERENCES app.assets (tenant_id, id),
  CHECK (is_cumulative = (meter_type <> 'temperature')),
  CHECK ((current_value IS NULL) = (current_read_at IS NULL))
);
CREATE INDEX asset_meters_row_version_idx ON app.asset_meters (tenant_id, row_version);
COMMENT ON TABLE app.asset_meters IS 'v0.2 (F2, módulo maintenance). Medidor do ativo: hour_meter (horímetro, h), energy_kwh (consumo estimado, kWh), temperature (°C, não cumulativo), cycles. current_value/current_read_at = última leitura válida (desnormalizada pela aplicação ao gravar meter_readings). Sincronizada com o app do técnico (row_version), no escopo dos ativos das OS do técnico, para o item de checklist meter_reading mostrar a leitura anterior offline.';
COMMENT ON COLUMN app.asset_meters.current_value IS 'Última leitura válida, na unidade do medidor (unit_code); double precision (double no Dart).';

CREATE TABLE app.maintenance_plan_assets (
  id                           uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id                    uuid NOT NULL REFERENCES app.tenants (id),
  maintenance_plan_id          uuid NOT NULL,
  asset_id                     uuid NOT NULL,
  asset_meter_id               uuid,
  status                       text NOT NULL DEFAULT 'active' CHECK (status IN ('active', 'paused', 'ended')),
  next_due_date                date,
  next_due_meter_value         double precision,
  last_generated_work_order_id uuid,
  last_generated_at            timestamptz,
  last_completed_at            timestamptz,
  created_at                   timestamptz NOT NULL DEFAULT now(),
  updated_at                   timestamptz NOT NULL DEFAULT now(),
  created_by                   uuid,
  updated_by                   uuid,
  version                      integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, maintenance_plan_id, asset_id),
  FOREIGN KEY (tenant_id, maintenance_plan_id) REFERENCES app.maintenance_plans (tenant_id, id),
  FOREIGN KEY (tenant_id, asset_id) REFERENCES app.assets (tenant_id, id),
  FOREIGN KEY (tenant_id, asset_meter_id) REFERENCES app.asset_meters (tenant_id, id),
  FOREIGN KEY (tenant_id, last_generated_work_order_id) REFERENCES app.work_orders (tenant_id, id),
  CHECK (next_due_date IS NOT NULL OR next_due_meter_value IS NOT NULL OR status <> 'active'),
  CHECK (next_due_meter_value IS NULL OR asset_meter_id IS NOT NULL)
);
CREATE INDEX maintenance_plan_assets_due_date_idx ON app.maintenance_plan_assets (tenant_id, next_due_date) WHERE status = 'active' AND next_due_date IS NOT NULL;
CREATE INDEX maintenance_plan_assets_meter_idx ON app.maintenance_plan_assets (tenant_id, asset_meter_id) WHERE asset_meter_id IS NOT NULL;
CREATE INDEX maintenance_plan_assets_asset_idx ON app.maintenance_plan_assets (tenant_id, asset_id);
CREATE INDEX maintenance_plan_assets_last_wo_idx ON app.maintenance_plan_assets (tenant_id, last_generated_work_order_id) WHERE last_generated_work_order_id IS NOT NULL;
COMMENT ON TABLE app.maintenance_plan_assets IS 'v0.2 (F2). Plano x ativo: próxima data (gatilhos por data) ou próxima leitura (gatilho meter, com o medidor) e a última OS gerada. O job diário e a reação a meter_reading.recorded criam a OS (origin = preventive_plan, work_orders.maintenance_plan_asset_id) quando hoje >= next_due_date - lead_days ou leitura >= next_due_meter_value - meter_lead; ao concluir a OS, recalculam o próximo vencimento. A previsão aparece na agenda. Evento maintenance_plan.work_order_generated.';
COMMENT ON COLUMN app.maintenance_plan_assets.next_due_meter_value IS 'Próxima leitura de vencimento (gatilho meter), na unidade do medidor; double precision.';

ALTER TABLE app.work_orders
  ADD FOREIGN KEY (tenant_id, maintenance_plan_asset_id) REFERENCES app.maintenance_plan_assets (tenant_id, id);
-- No máximo uma OS não terminal por plano x ativo: o job de geração é idempotente.
CREATE UNIQUE INDEX work_orders_open_plan_asset_key ON app.work_orders (tenant_id, maintenance_plan_asset_id)
  WHERE maintenance_plan_asset_id IS NOT NULL AND status IN ('requested', 'open', 'scheduled', 'in_progress', 'on_hold');
CREATE INDEX work_orders_plan_asset_idx ON app.work_orders (tenant_id, maintenance_plan_asset_id, created_at DESC) WHERE maintenance_plan_asset_id IS NOT NULL;

-- =============================================================================
-- 16c. Telemetria IoT (módulo telemetry) — v0.2, F3
-- =============================================================================

CREATE TABLE app.iot_devices (
  id                    uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id             uuid NOT NULL REFERENCES app.tenants (id),
  device_uid            text NOT NULL CHECK (length(device_uid) BETWEEN 6 AND 100),
  vendor                text,
  model                 text,
  firmware_version      text,
  asset_id              uuid,
  status                text NOT NULL DEFAULT 'provisioned' CHECK (status IN ('provisioned', 'active', 'inactive', 'revoked')),
  credential_secret_ref text,
  credential_rotated_at timestamptz,
  installed_at          timestamptz,
  last_seen_at          timestamptz,
  notes                 text,
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now(),
  created_by            uuid,
  updated_by            uuid,
  version               integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (device_uid),
  FOREIGN KEY (tenant_id, asset_id) REFERENCES app.assets (tenant_id, id),
  CHECK (status <> 'active' OR (asset_id IS NOT NULL AND credential_secret_ref IS NOT NULL))
);
CREATE UNIQUE INDEX iot_devices_one_active_per_asset_key ON app.iot_devices (tenant_id, asset_id) WHERE status = 'active';
CREATE INDEX iot_devices_asset_idx ON app.iot_devices (tenant_id, asset_id) WHERE asset_id IS NOT NULL;
COMMENT ON TABLE app.iot_devices IS 'v0.2 (F3, módulo telemetry). Dispositivo de telemetria (ex.: Kairós ou hardware aberto equivalente) vinculado ao ativo. device_uid é globalmente único (identifica o tenant na ingestão POST /api/v1/integrations/iot/readings); a credencial por dispositivo fica no cofre (credential_secret_ref), com rotação. Um dispositivo ativo por ativo.';

CREATE TABLE app.meter_readings (
  id             uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id      uuid NOT NULL REFERENCES app.tenants (id),
  asset_meter_id uuid NOT NULL,
  value          double precision NOT NULL,
  read_at        timestamptz NOT NULL,
  received_at    timestamptz NOT NULL DEFAULT now(),
  source         text NOT NULL CHECK (source IN ('manual', 'iot', 'file_import')),
  work_order_id  uuid,
  visit_id       uuid,
  technician_id  uuid,
  iot_device_id  uuid,
  is_valid       boolean NOT NULL DEFAULT true,
  invalid_reason text,
  notes          text,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now(),
  created_by     uuid,
  updated_by     uuid,
  version        integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, asset_meter_id) REFERENCES app.asset_meters (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id) REFERENCES app.work_orders (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id, visit_id) REFERENCES app.work_order_visits (tenant_id, work_order_id, id),
  FOREIGN KEY (tenant_id, technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, iot_device_id) REFERENCES app.iot_devices (tenant_id, id),
  CHECK (visit_id IS NULL OR work_order_id IS NOT NULL),
  CHECK (source <> 'iot' OR iot_device_id IS NOT NULL),
  CHECK (is_valid OR invalid_reason IS NOT NULL)
);
-- Idempotência: reenvio da mesma leitura (lote atrasado do dispositivo, push repetido do app) não duplica.
CREATE UNIQUE INDEX meter_readings_idempotency_key ON app.meter_readings (tenant_id, asset_meter_id, read_at, source);
CREATE INDEX meter_readings_meter_idx ON app.meter_readings (tenant_id, asset_meter_id, read_at DESC);
CREATE INDEX meter_readings_read_at_brin ON app.meter_readings USING brin (read_at);
CREATE INDEX meter_readings_wo_idx ON app.meter_readings (tenant_id, work_order_id, visit_id) WHERE work_order_id IS NOT NULL;
CREATE INDEX meter_readings_technician_idx ON app.meter_readings (tenant_id, technician_id) WHERE technician_id IS NOT NULL;
CREATE INDEX meter_readings_device_idx ON app.meter_readings (tenant_id, iot_device_id, read_at) WHERE iot_device_id IS NOT NULL;
COMMENT ON TABLE app.meter_readings IS 'v0.2 (F2 manual, F3 IoT; módulo maintenance). Leitura de medidor: manual (item de checklist meter_reading, mutação meter_reading.record do app do técnico), iot (ingestão de telemetria, aceita lotes atrasados com o horário do dispositivo) ou import. Idempotência por (tenant_id, asset_meter_id, read_at, source). Não é sincronizada para o app (só push; o app lê asset_meters.current_value). Evento meter_reading.recorded. Volume: com IoT, leituras agregadas a cada 5-15 min; quando a telemetria entrar (F3), converter para PARTITION BY RANGE (read_at) mensal, com PK (id, read_at) e a chave de idempotência (que já contém read_at). Por isso nenhuma tabela pode ter FK para meter_readings. Não particionada agora para manter o padrão UNIQUE (tenant_id, id) enquanto o volume é só manual.';
COMMENT ON COLUMN app.meter_readings.value IS 'Valor lido, na unidade do medidor (asset_meters.unit_code); double precision (double no Dart). v0.3: era numeric(14,4).';
COMMENT ON COLUMN app.meter_readings.is_valid IS 'false = leitura descartada na conferência ou por regra (ex.: horímetro menor que a anterior), com invalid_reason; nunca se apaga uma leitura.';

CREATE TABLE app.telemetry_alert_rules (
  id                 uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id          uuid NOT NULL REFERENCES app.tenants (id),
  name               text NOT NULL,
  meter_type         text NOT NULL CHECK (meter_type IN ('hour_meter', 'energy_kwh', 'temperature', 'cycles')),
  applies_to         text NOT NULL CHECK (applies_to IN ('product', 'asset')),
  product_id         uuid,
  asset_id           uuid,
  condition          text NOT NULL CHECK (condition IN ('above', 'below', 'no_data', 'continuous_on', 'idle')),
  threshold          double precision,
  duration_minutes   integer NOT NULL DEFAULT 0 CHECK (duration_minutes >= 0),
  action             text NOT NULL CHECK (action IN ('notify', 'open_work_order')),
  work_order_type_id uuid,
  priority           text NOT NULL DEFAULT 'normal' CHECK (priority IN ('low', 'normal', 'high', 'urgent')),
  cooldown_minutes   integer NOT NULL DEFAULT 1440 CHECK (cooldown_minutes >= 0),
  is_active          boolean NOT NULL DEFAULT true,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  created_by         uuid,
  updated_by         uuid,
  version            integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, product_id) REFERENCES app.products (tenant_id, id),
  FOREIGN KEY (tenant_id, asset_id) REFERENCES app.assets (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_type_id) REFERENCES app.work_order_types (tenant_id, id),
  CHECK ((applies_to = 'product' AND product_id IS NOT NULL AND asset_id IS NULL)
      OR (applies_to = 'asset' AND asset_id IS NOT NULL AND product_id IS NULL)),
  CHECK (condition NOT IN ('above', 'below') OR threshold IS NOT NULL),
  CHECK (condition NOT IN ('no_data', 'continuous_on', 'idle') OR duration_minutes > 0),
  CHECK (action <> 'open_work_order' OR work_order_type_id IS NOT NULL)
);
CREATE INDEX telemetry_alert_rules_product_idx ON app.telemetry_alert_rules (tenant_id, product_id) WHERE product_id IS NOT NULL;
CREATE INDEX telemetry_alert_rules_asset_idx ON app.telemetry_alert_rules (tenant_id, asset_id) WHERE asset_id IS NOT NULL;
CREATE INDEX telemetry_alert_rules_type_idx ON app.telemetry_alert_rules (tenant_id, work_order_type_id) WHERE work_order_type_id IS NOT NULL;
COMMENT ON TABLE app.telemetry_alert_rules IS 'v0.2 (F3, módulo telemetry). Regra de alerta sobre leituras: acima/abaixo de um limite, sem dados, ligado sem parar (freezer com vedação ou gás) ou ocioso (equipamento parado no cliente), por modelo ou ativo, durante duration_minutes. Ação: notificar ou abrir OS (origin = telemetry, deduplicada pela regra de chamado duplicado por ativo e por cooldown_minutes). Evento telemetry.alert_triggered.';
COMMENT ON COLUMN app.telemetry_alert_rules.threshold IS 'Limite das condições above/below, na unidade do medidor (°C, kWh, h, ciclos); double precision.';

-- =============================================================================
-- 16d. Sync do app do técnico (continuação do módulo field_execution)
-- =============================================================================

-- Registro das mutações do push (idempotência por mutation_id, D11).
CREATE TABLE app.sync_mutations (
  id               uuid NOT NULL PRIMARY KEY,
  tenant_id        uuid NOT NULL REFERENCES app.tenants (id),
  device_id        uuid NOT NULL,
  technician_id    uuid NOT NULL,
  type             text NOT NULL CHECK (type ~ '^[a-z_]+\.[a-z_]+$'),
  entity_id        uuid,
  status           text NOT NULL CHECK (status IN ('applied', 'rejected', 'conflict')),
  payload_hash     bytea NOT NULL,
  result           jsonb,
  client_timestamp timestamptz NOT NULL,
  received_at      timestamptz NOT NULL DEFAULT now(),
  created_at       timestamptz NOT NULL DEFAULT now(),
  created_by       uuid,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, device_id) REFERENCES app.devices (tenant_id, id),
  FOREIGN KEY (tenant_id, technician_id) REFERENCES app.technicians (tenant_id, id)
);
CREATE INDEX sync_mutations_device_idx ON app.sync_mutations (tenant_id, device_id, received_at);
CREATE INDEX sync_mutations_technician_idx ON app.sync_mutations (tenant_id, technician_id, received_at);
CREATE INDEX sync_mutations_entity_idx ON app.sync_mutations (tenant_id, entity_id) WHERE entity_id IS NOT NULL;
COMMENT ON TABLE app.sync_mutations IS 'Mutações recebidas no push (id = mutation_id). Reenvio do mesmo id => resposta duplicate com o result gravado. Append-only; expurgo após 90 dias.';

CREATE TABLE app.sync_tombstones (
  id            uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id     uuid NOT NULL REFERENCES app.tenants (id),
  entity_type   text NOT NULL,
  entity_id     uuid NOT NULL,
  technician_id uuid,
  reason        text NOT NULL CHECK (reason IN ('deleted', 'scope_lost')),
  row_version   bigint NOT NULL DEFAULT 0,
  sync_xid      xid8,
  created_at    timestamptz NOT NULL DEFAULT now(),
  created_by    uuid,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, technician_id) REFERENCES app.technicians (tenant_id, id)
);
CREATE INDEX sync_tombstones_row_version_idx ON app.sync_tombstones (tenant_id, row_version);
CREATE INDEX sync_tombstones_technician_idx ON app.sync_tombstones (tenant_id, technician_id, row_version) WHERE technician_id IS NOT NULL;
COMMENT ON TABLE app.sync_tombstones IS 'Remoções para o pull: deleted (exclusão física, todos os dispositivos) ou scope_lost (só technician_id). Expurgo após a janela máxima offline (30 dias) => cliente mais antigo faz ressincronização completa.';

-- Snapshot do escopo por dispositivo (docs/06 §6): base para entradas/saídas de escopo no pull.
CREATE TABLE app.device_sync_scopes (
  tenant_id   uuid NOT NULL REFERENCES app.tenants (id),
  device_id   uuid NOT NULL,
  entity_type text NOT NULL CHECK (entity_type ~ '^[a-z_]+$'),
  entity_id   uuid NOT NULL,
  added_at    timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (tenant_id, device_id, entity_type, entity_id),
  FOREIGN KEY (tenant_id, device_id) REFERENCES app.devices (tenant_id, id) ON DELETE CASCADE
);
CREATE INDEX device_sync_scopes_entity_idx ON app.device_sync_scopes (tenant_id, entity_type, entity_id);
COMMENT ON TABLE app.device_sync_scopes IS 'Snapshot do escopo de sync de cada dispositivo: as entidades (entity_type = nome da tabela, ex.: work_order_visits, work_orders, customers, assets) que o aparelho tem hoje. No pull a api calcula o escopo atual e compara: entradas são enviadas por inteiro (independente do watermark) e inseridas aqui; saídas vão em deletes com meta.removed_reasons = scope_lost e são removidas daqui na mesma transação que fecha a página. Estado técnico de alta rotatividade (inserções/exclusões a cada pull), recalculável a partir do escopo: por isso sem colunas padrão de auditoria (created_*/updated_*/version), sem row_version e com exclusão física; apagar o dispositivo apaga o snapshot (ON DELETE CASCADE) e uma ressincronização completa o reconstrói.';
COMMENT ON COLUMN app.device_sync_scopes.added_at IS 'Quando a entidade entrou no escopo do aparelho (envio por inteiro).';

-- "Registros a revisar" (docs/06): fatos de campo que chegaram por sync e não puderam ser aplicados.
CREATE TABLE app.sync_review_items (
  id             uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id      uuid NOT NULL REFERENCES app.tenants (id),
  work_order_id  uuid NOT NULL,
  visit_id       uuid,
  technician_id  uuid NOT NULL,
  device_id      uuid NOT NULL,
  mutation_id    uuid NOT NULL,
  mutation_type  text NOT NULL CHECK (mutation_type ~ '^[a-z_]+\.[a-z_]+$'),
  payload        jsonb NOT NULL,
  reason         text NOT NULL CHECK (reason IN ('work_order_cancelled', 'work_order_closed', 'visit_reassigned', 'other')),
  status         text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'accepted', 'discarded')),
  decided_by     uuid,
  decided_at     timestamptz,
  decision_note  text,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now(),
  created_by     uuid,
  updated_by     uuid,
  version        integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, mutation_id),
  FOREIGN KEY (tenant_id, work_order_id) REFERENCES app.work_orders (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id, visit_id) REFERENCES app.work_order_visits (tenant_id, work_order_id, id),
  FOREIGN KEY (tenant_id, technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, device_id) REFERENCES app.devices (tenant_id, id),
  CHECK ((status = 'pending') = (decided_at IS NULL)),
  CHECK (status = 'pending' OR decided_by IS NOT NULL),
  CHECK (status <> 'discarded' OR decision_note IS NOT NULL)
);
CREATE INDEX sync_review_items_wo_idx ON app.sync_review_items (tenant_id, work_order_id, status);
CREATE INDEX sync_review_items_visit_idx ON app.sync_review_items (tenant_id, work_order_id, visit_id) WHERE visit_id IS NOT NULL;
CREATE INDEX sync_review_items_pending_idx ON app.sync_review_items (tenant_id, created_at) WHERE status = 'pending';
CREATE INDEX sync_review_items_technician_idx ON app.sync_review_items (tenant_id, technician_id, created_at);
CREATE INDEX sync_review_items_device_idx ON app.sync_review_items (tenant_id, device_id);
COMMENT ON TABLE app.sync_review_items IS 'Registros a revisar (docs/06 §6): horas, itens, fotos, diagnóstico ou assinatura enviados por sync para uma OS cancelada/encerrada ou visita reatribuída. A mutação responde conflict, o payload original é guardado aqui e não entra nos totais da OS. O backoffice aceita (reaplica o payload: reabre a OS ou gera OS nova) ou descarta com motivo (decision_note obrigatória). Nunca descartado silenciosamente.';
COMMENT ON COLUMN app.sync_review_items.mutation_id IS 'mutation_id do push (= sync_mutations.id, status conflict). UNIQUE por tenant: reenvio da mesma mutação não duplica o registro. Sem FK porque sync_mutations é expurgada após 90 dias e o registro a revisar precisa sobreviver até a decisão.';
COMMENT ON COLUMN app.sync_review_items.payload IS 'Payload original da mutação, intacto, para reaplicação na aceitação.';

-- =============================================================================
-- 17. Notificações (módulo notifications)
-- =============================================================================

CREATE TABLE app.notification_templates (
  id                    uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id             uuid NOT NULL REFERENCES app.tenants (id),
  event_type            text NOT NULL CHECK (event_type ~ '^[a-z_]+\.[a-z_]+$'),
  channel               text NOT NULL CHECK (channel IN ('email', 'sms', 'whatsapp', 'push', 'in_app')),
  audience              text NOT NULL CHECK (audience IN ('customer_contact', 'technician', 'backoffice')),
  locale                text NOT NULL DEFAULT 'pt-BR',
  subject               text,
  body                  text NOT NULL,
  provider_template_ref text,
  is_active             boolean NOT NULL DEFAULT true,
  created_at            timestamptz NOT NULL DEFAULT now(),
  updated_at            timestamptz NOT NULL DEFAULT now(),
  created_by            uuid,
  updated_by            uuid,
  version               integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, event_type, channel, audience, locale)
);
COMMENT ON TABLE app.notification_templates IS 'Personalização por tenant; sem linha => modelo padrão da plataforma (versionado no código). provider_template_ref: modelo aprovado do WhatsApp.';

CREATE TABLE app.notifications (
  id                      uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id               uuid NOT NULL REFERENCES app.tenants (id),
  event_type              text NOT NULL,
  channel                 text NOT NULL CHECK (channel IN ('email', 'sms', 'whatsapp', 'push', 'in_app')),
  category                text CHECK (category IN ('authentication', 'utility', 'service', 'marketing')),
  template_id             uuid,
  recipient_user_id       uuid REFERENCES app.users (id),
  recipient_contact_id    uuid,
  recipient_technician_id uuid,
  destination_masked      text,
  work_order_id           uuid,
  source_event_id         uuid,
  dedup_key               text,
  payload                 jsonb NOT NULL DEFAULT '{}'::jsonb,
  status                  text NOT NULL DEFAULT 'queued' CHECK (status IN ('queued', 'sending', 'sent', 'delivered', 'read', 'failed', 'cancelled')),
  provider                text,
  provider_message_id     text,
  provider_cost           bigint CHECK (provider_cost IS NULL OR provider_cost >= 0),
  provider_cost_currency  char(3) CHECK (provider_cost_currency IS NULL OR provider_cost_currency ~ '^[A-Z]{3}$'),
  attempt_count           smallint NOT NULL DEFAULT 0,
  next_attempt_at         timestamptz,
  sent_at                 timestamptz,
  delivered_at            timestamptz,
  read_at                 timestamptz,
  failed_at               timestamptz,
  last_error              text,
  created_at              timestamptz NOT NULL DEFAULT now(),
  updated_at              timestamptz NOT NULL DEFAULT now(),
  created_by              uuid,
  updated_by              uuid,
  version                 integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, template_id) REFERENCES app.notification_templates (tenant_id, id),
  FOREIGN KEY (tenant_id, recipient_contact_id) REFERENCES app.customer_contacts (tenant_id, id),
  FOREIGN KEY (tenant_id, recipient_technician_id) REFERENCES app.technicians (tenant_id, id),
  FOREIGN KEY (tenant_id, work_order_id) REFERENCES app.work_orders (tenant_id, id),
  CHECK (num_nonnulls(recipient_user_id, recipient_contact_id, recipient_technician_id) >= 1),
  CHECK (channel <> 'whatsapp' OR category IS NOT NULL),
  CHECK (provider_cost IS NULL OR provider_cost_currency IS NOT NULL)
);
CREATE UNIQUE INDEX notifications_dedup_key ON app.notifications (tenant_id, dedup_key) WHERE dedup_key IS NOT NULL;
CREATE INDEX notifications_user_inbox_idx ON app.notifications (recipient_user_id, tenant_id, created_at DESC) WHERE recipient_user_id IS NOT NULL;
CREATE INDEX notifications_contact_idx ON app.notifications (tenant_id, recipient_contact_id, created_at DESC) WHERE recipient_contact_id IS NOT NULL;
CREATE INDEX notifications_technician_idx ON app.notifications (tenant_id, recipient_technician_id, created_at DESC) WHERE recipient_technician_id IS NOT NULL;
CREATE INDEX notifications_wo_idx ON app.notifications (tenant_id, work_order_id) WHERE work_order_id IS NOT NULL;
CREATE INDEX notifications_template_idx ON app.notifications (tenant_id, template_id) WHERE template_id IS NOT NULL;
CREATE INDEX notifications_retry_idx ON app.notifications (status, next_attempt_at) WHERE status IN ('queued', 'failed');
COMMENT ON TABLE app.notifications IS 'Notificação enviada/agendada (e caixa in_app). dedup_key evita reenvio do mesmo evento ao mesmo destinatário. Resultado do envio emite notification.sent ou notification.failed.';
COMMENT ON COLUMN app.notifications.category IS 'Categoria de cobrança do WhatsApp (authentication = OTP; utility = transacional ligado a uma OS; service = resposta dentro da janela de atendimento; marketing). Obrigatória no canal whatsapp; nos demais canais é opcional (relatórios). WhatsApp só sai para contato com customer_contacts.whatsapp_opt_in_at preenchido, salvo authentication pedida pelo próprio contato.';
COMMENT ON COLUMN app.notifications.provider_cost IS 'Custo informado pelo provedor (webhook/billing) para esta mensagem, em MICRO-unidades de provider_cost_currency (ISO 4217): bigint, 1 unidade = 1.000.000 (US$ 0,0079 = 7900; R$ 0,05 = 50000). Exceção à regra de centavos porque o preço por mensagem tem fração de centavo. Base do relatório de custo por tenant (somas em bigint; conversão para centavos só no relatório).';

CREATE TABLE app.notification_preferences (
  id                  uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id           uuid NOT NULL REFERENCES app.tenants (id),
  user_id             uuid REFERENCES app.users (id),
  customer_contact_id uuid,
  event_type          text NOT NULL,
  channel             text NOT NULL CHECK (channel IN ('email', 'sms', 'whatsapp', 'push', 'in_app')),
  is_enabled          boolean NOT NULL DEFAULT true,
  created_at          timestamptz NOT NULL DEFAULT now(),
  updated_at          timestamptz NOT NULL DEFAULT now(),
  created_by          uuid,
  updated_by          uuid,
  version             integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, customer_contact_id) REFERENCES app.customer_contacts (tenant_id, id),
  CHECK (num_nonnulls(user_id, customer_contact_id) = 1)
);
CREATE UNIQUE INDEX notification_preferences_key ON app.notification_preferences
  (tenant_id, coalesce(user_id, customer_contact_id), event_type, channel);
CREATE INDEX notification_preferences_user_idx ON app.notification_preferences (user_id) WHERE user_id IS NOT NULL;
CREATE INDEX notification_preferences_contact_idx ON app.notification_preferences (tenant_id, customer_contact_id) WHERE customer_contact_id IS NOT NULL;
COMMENT ON TABLE app.notification_preferences IS 'Opt-out por evento/canal (sem linha = padrão habilitado). Mensagens transacionais obrigatórias (OTP) ignoram preferências.';

-- =============================================================================
-- 18. Integrações (módulo integrations) — docs/07-integracao-erp-senior.md
-- =============================================================================

CREATE TABLE app.integration_connections (
  id                   uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id            uuid NOT NULL REFERENCES app.tenants (id),
  name                 text NOT NULL,
  external_system      text NOT NULL CHECK (external_system ~ '^[a-z0-9_]{2,40}$'),
  connector_type       text NOT NULL CHECK (connector_type IN ('senior_erpx', 'senior_g5_soap', 'generic_rest', 'file_only')),
  connector_version    text,
  status               text NOT NULL DEFAULT 'draft' CHECK (status IN ('draft', 'active', 'paused', 'error', 'disabled')),
  base_url             text,
  secret_ref           text CHECK (secret_ref !~ '\s'),
  config               jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(config) = 'object'),
  enabled_features     text[] NOT NULL DEFAULT '{}',
  sync_schedule        jsonb NOT NULL DEFAULT '{}'::jsonb,
  last_health_check_at timestamptz,
  last_health_status   text CHECK (last_health_status IN ('ok', 'degraded', 'failing')),
  last_error           text,
  activated_at         timestamptz,
  is_active            boolean NOT NULL DEFAULT true,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),
  created_by           uuid,
  updated_by           uuid,
  version              integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  CHECK (status <> 'active' OR connector_type = 'file_only' OR secret_ref IS NOT NULL)
);
CREATE UNIQUE INDEX integration_connections_system_key ON app.integration_connections (tenant_id, external_system) WHERE is_active;
COMMENT ON TABLE app.integration_connections IS 'Conexão do tenant com um ERP. secret_ref é só a referência no cofre de segredos (nunca o segredo). config: parâmetros não secretos (empresa/filial, códigos padrão).';

CREATE TABLE app.outbox_messages (
  id             uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id      uuid NOT NULL REFERENCES app.tenants (id),
  event_type     text NOT NULL CHECK (event_type ~ '^[a-z_]+\.[a-z_]+$'),
  event_version  smallint NOT NULL DEFAULT 1,
  aggregate_type text NOT NULL,
  aggregate_id   uuid NOT NULL,
  aggregate_version integer CHECK (aggregate_version IS NULL OR aggregate_version > 0),
  correlation_id uuid,
  traceparent    text CHECK (traceparent IS NULL OR traceparent ~ '^[0-9a-f]{2}-[0-9a-f]{32}-[0-9a-f]{16}-[0-9a-f]{2}$'),
  payload        jsonb NOT NULL,
  metadata       jsonb NOT NULL DEFAULT '{}'::jsonb,
  occurred_at    timestamptz NOT NULL DEFAULT now(),
  status         text NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'published', 'failed')),
  attempt_count  integer NOT NULL DEFAULT 0,
  available_at   timestamptz NOT NULL DEFAULT now(),
  locked_until   timestamptz,
  locked_by      text,
  published_at   timestamptz,
  last_error     text,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now(),
  created_by     uuid,
  updated_by     uuid,
  version        integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  CHECK (status <> 'published' OR published_at IS NOT NULL)
);
CREATE INDEX outbox_messages_relay_idx ON app.outbox_messages (available_at, id) WHERE status IN ('pending', 'processing');
CREATE INDEX outbox_messages_aggregate_idx ON app.outbox_messages (tenant_id, aggregate_type, aggregate_id, occurred_at);
CREATE INDEX outbox_messages_published_idx ON app.outbox_messages (published_at) WHERE status = 'published';
CREATE INDEX outbox_messages_correlation_idx ON app.outbox_messages (tenant_id, correlation_id) WHERE correlation_id IS NOT NULL;
COMMENT ON TABLE app.outbox_messages IS 'Outbox transacional: eventos de domínio gravados na mesma transação do caso de uso; o relay (worker) os publica para consumidores internos e integrações. Colunas = envelope do evento (docs/02 §5); event_type segue o catálogo canônico (ex.: work_order.created, visit.travel_started, visit.checked_in). Expurgo de published após 7 dias.';
COMMENT ON COLUMN app.outbox_messages.aggregate_version IS 'Versão do agregado (coluna version da linha) depois da mudança que gerou o evento; consumidores descartam eventos com versão menor ou igual à já processada para o mesmo aggregate_id.';
COMMENT ON COLUMN app.outbox_messages.correlation_id IS 'Correlaciona todos os eventos/jobs originados do mesmo comando ou requisição (ex.: um push de sync, uma varredura do ERP).';
COMMENT ON COLUMN app.outbox_messages.traceparent IS 'Contexto W3C Trace Context (versão-trace_id-span_id-flags) da requisição de origem, propagado ao relay e aos jobs para rastreamento distribuído.';

CREATE TABLE app.sync_runs (
  id                 uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id          uuid NOT NULL REFERENCES app.tenants (id),
  connection_id      uuid,
  entity_type        text NOT NULL CHECK (entity_type IN ('customers', 'customer_sites', 'customer_contacts', 'products', 'services', 'assets')),
  mode               text NOT NULL CHECK (mode IN ('full', 'incremental', 'single', 'file_import')),
  trigger            text NOT NULL CHECK (trigger IN ('schedule', 'manual', 'webhook', 'lookup', 'file_upload')),
  dry_run            boolean NOT NULL DEFAULT false,
  status             text NOT NULL DEFAULT 'queued' CHECK (status IN ('queued', 'running', 'succeeded', 'partially_succeeded', 'failed', 'cancelled')),
  cursor_before      text,
  cursor_after       text,
  stats              jsonb NOT NULL DEFAULT '{}'::jsonb,
  file_storage_key   text,
  file_name          text,
  file_sha256        text,
  report_storage_key text,
  error_message      text,
  started_at         timestamptz,
  finished_at        timestamptz,
  requested_by       uuid,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  created_by         uuid,
  updated_by         uuid,
  version            integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, connection_id) REFERENCES app.integration_connections (tenant_id, id),
  CHECK ((mode = 'file_import') = (connection_id IS NULL)),
  CHECK (mode <> 'file_import' OR file_storage_key IS NOT NULL)
);
CREATE INDEX sync_runs_connection_idx ON app.sync_runs (tenant_id, connection_id, entity_type, created_at DESC);
CREATE INDEX sync_runs_recent_idx ON app.sync_runs (tenant_id, created_at DESC);
COMMENT ON TABLE app.sync_runs IS 'Execução de sincronização com o ERP ou importação de planilha (connection_id nulo). Visível no Monitor de Integrações.';

CREATE TABLE app.integration_jobs (
  id                   uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id            uuid NOT NULL REFERENCES app.tenants (id),
  connection_id        uuid NOT NULL,
  direction            text NOT NULL CHECK (direction IN ('outbound', 'inbound')),
  operation            text NOT NULL CHECK (operation ~ '^[a-z0-9_]+(\.[a-z0-9_]+)+$'),
  subject_type         text,
  subject_id           uuid,
  idempotency_key      text NOT NULL,
  external_reference   text,
  status               text NOT NULL DEFAULT 'pending'
                       CHECK (status IN ('pending', 'processing', 'waiting_external', 'succeeded', 'failed', 'cancelled')),
  attempt_count        integer NOT NULL DEFAULT 0 CHECK (attempt_count >= 0),
  max_attempts         integer NOT NULL DEFAULT 10 CHECK (max_attempts > 0),
  next_attempt_at      timestamptz NOT NULL DEFAULT now(),
  locked_until         timestamptz,
  locked_by            text,
  last_error_kind      text CHECK (last_error_kind IN ('transient', 'permanent', 'auth', 'rate_limited', 'ambiguous')),
  last_error_code      text,
  last_error_message   text,
  request_payload      jsonb,
  response_payload     jsonb,
  result               jsonb,
  attempt_log          jsonb NOT NULL DEFAULT '[]'::jsonb CHECK (jsonb_typeof(attempt_log) = 'array'),
  connector_type       text,
  connector_version    text,
  source_event_id      uuid,
  resolution_note      text,
  resolved_manually_by uuid,
  completed_at         timestamptz,
  created_at           timestamptz NOT NULL DEFAULT now(),
  updated_at           timestamptz NOT NULL DEFAULT now(),
  created_by           uuid,
  updated_by           uuid,
  version              integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, idempotency_key),
  FOREIGN KEY (tenant_id, connection_id) REFERENCES app.integration_connections (tenant_id, id),
  CHECK ((subject_type IS NULL) = (subject_id IS NULL)),
  CHECK (status NOT IN ('succeeded', 'cancelled') OR completed_at IS NOT NULL)
);
CREATE INDEX integration_jobs_schedule_idx ON app.integration_jobs (status, next_attempt_at)
  WHERE status IN ('pending', 'processing', 'waiting_external');
CREATE INDEX integration_jobs_subject_idx ON app.integration_jobs (tenant_id, subject_type, subject_id);
CREATE INDEX integration_jobs_connection_idx ON app.integration_jobs (tenant_id, connection_id, created_at DESC);
COMMENT ON TABLE app.integration_jobs IS 'Unidade de trabalho idempotente contra o ERP (ex.: erp.sales_order.create ao encerrar a OS). Retry exponencial e reprocessamento manual pelo Monitor.';

-- v0.3: fila genérica do worker para o trabalho assíncrono que não é integração
-- nem notificação (no lugar das filas do pg-boss da v0.2). Mesmo molde de
-- integration_jobs: claim com FOR UPDATE SKIP LOCKED e lease, retry com backoff
-- calculado pela aplicação em next_attempt_at.
CREATE TABLE app.background_jobs (
  id                 uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id          uuid NOT NULL REFERENCES app.tenants (id),
  kind               text NOT NULL CHECK (kind ~ '^[a-z0-9_]+(\.[a-z0-9_]+)+$'),
  priority           smallint NOT NULL DEFAULT 5 CHECK (priority BETWEEN 1 AND 9),
  payload            jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(payload) = 'object'),
  idempotency_key    text,
  status             text NOT NULL DEFAULT 'pending'
                     CHECK (status IN ('pending', 'processing', 'succeeded', 'failed', 'cancelled')),
  attempt_count      integer NOT NULL DEFAULT 0 CHECK (attempt_count >= 0),
  max_attempts       integer NOT NULL DEFAULT 5 CHECK (max_attempts > 0),
  next_attempt_at    timestamptz NOT NULL DEFAULT now(),
  locked_until       timestamptz,
  locked_by          text,
  last_error         text,
  result             jsonb,
  completed_at       timestamptz,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  created_by         uuid,
  updated_by         uuid,
  version            integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  CHECK (status NOT IN ('succeeded', 'cancelled') OR completed_at IS NOT NULL),
  CHECK (attempt_count <= max_attempts)
);
CREATE UNIQUE INDEX background_jobs_idempotency_key ON app.background_jobs (tenant_id, kind, idempotency_key)
  WHERE idempotency_key IS NOT NULL;
CREATE INDEX background_jobs_schedule_idx ON app.background_jobs (priority, next_attempt_at)
  WHERE status IN ('pending', 'processing');
CREATE INDEX background_jobs_tenant_idx ON app.background_jobs (tenant_id, kind, created_at DESC);
COMMENT ON TABLE app.background_jobs IS 'v0.3: fila genérica do worker (Serverpod --role monolith) para trabalho assíncrono que não é integração nem notificação: geração de PDF/ZPL de lotes de etiquetas (qr_label_batch.render), termos e relatórios de atendimento (report.render), importações e exportações de planilhas (import.process, export.process), verificação de anexos (attachment.verify), geração de OS por planos (maintenance_plan.generate). Consumida por app.claim_background_jobs; o executor roda cada job com SET LOCAL app.tenant_id do job. Expurgo de concluídos após 30 dias.';
COMMENT ON COLUMN app.background_jobs.kind IS 'Tipo do job, no formato <agregado>.<ação> (ex.: qr_label_batch.render).';
COMMENT ON COLUMN app.background_jobs.priority IS '1 = mais urgente; os laços do worker reservam por prioridade e horário.';
COMMENT ON COLUMN app.background_jobs.idempotency_key IS 'Opcional; impede enfileirar duas vezes o mesmo trabalho (ex.: o mesmo lote de etiquetas).';

-- v0.3 (F2): token de exibição do modo TV (painel só-leitura na sala de operação).
CREATE TABLE app.display_tokens (
  id                 uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id          uuid NOT NULL REFERENCES app.tenants (id),
  name               text NOT NULL CHECK (length(btrim(name)) > 0),
  dashboard          text NOT NULL CHECK (dashboard IN ('work_orders_board', 'sla', 'dispatch', 'costs')),
  scope              jsonb NOT NULL DEFAULT '{}'::jsonb CHECK (jsonb_typeof(scope) = 'object'),
  token_hash         bytea NOT NULL,
  allowed_ip_ranges  cidr[],
  expires_at         timestamptz NOT NULL,
  revoked_at         timestamptz,
  revoked_by         uuid,
  last_used_at       timestamptz,
  last_used_ip       inet,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  created_by         uuid,
  updated_by         uuid,
  version            integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (token_hash),
  CHECK (expires_at > created_at),
  CHECK (expires_at <= created_at + interval '366 days'),
  CHECK ((revoked_at IS NULL) = (revoked_by IS NULL))
);
CREATE INDEX display_tokens_tenant_idx ON app.display_tokens (tenant_id, revoked_at, expires_at);
COMMENT ON TABLE app.display_tokens IS 'v0.3 (F2): token de exibição do modo TV. Só-leitura, revogável, com validade máxima de 1 ano e faixas de IP opcionais. O token em si nunca é gravado: só o SHA-256 (token_hash). A TV não tem login: o servidor resolve o token por app.find_display_token_by_hash (SECURITY DEFINER) e abre o stream do painel no tenant do token, com o recorte de scope (filial, equipe ou região). Criação pela permissão display_token.manage (docs/04).';
COMMENT ON COLUMN app.display_tokens.scope IS 'Recorte do painel: {"branch_id": ..., "team_id": ..., "service_area_id": ...}; vazio = tenant inteiro.';

-- v0.3 (F2/F3): consolidação diária das leituras de medidor, para histórico longo
-- e gráficos sem varrer meter_readings (que guarda dados brutos por prazo curto).
CREATE TABLE app.meter_reading_daily (
  id                 uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id          uuid NOT NULL REFERENCES app.tenants (id),
  asset_meter_id     uuid NOT NULL,
  day                date NOT NULL,
  reading_count      integer NOT NULL CHECK (reading_count > 0),
  min_value          double precision NOT NULL,
  max_value          double precision NOT NULL,
  avg_value          double precision NOT NULL,
  last_value         double precision NOT NULL,
  delta_value        double precision,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  created_by         uuid,
  updated_by         uuid,
  version            integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  UNIQUE (tenant_id, asset_meter_id, day),
  FOREIGN KEY (tenant_id, asset_meter_id) REFERENCES app.asset_meters (tenant_id, id) ON DELETE CASCADE,
  CHECK (min_value <= avg_value AND avg_value <= max_value),
  CHECK (delta_value IS NULL OR delta_value >= 0)
);
COMMENT ON TABLE app.meter_reading_daily IS 'v0.3 (F2/F3): consolidação diária por medidor, gerada pelo job maintenance.meter_rollup (background_jobs) no fuso do tenant. delta_value = consumo do dia em medidores cumulativos (horas, kWh, ciclos); nulo para temperatura. Mantida por tempo indeterminado; os dados brutos de meter_readings podem ser expurgados depois de 90 dias quando a telemetria (F3) gerar volume.';

CREATE TABLE app.integration_issues (
  id                 uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id          uuid NOT NULL REFERENCES app.tenants (id),
  connection_id      uuid,
  issue_type         text NOT NULL CHECK (issue_type IN ('customer_not_linked', 'item_not_linked', 'unmapped_value', 'possible_duplicate',
                                                         'not_found_in_erp', 'erp_rejected', 'record_invalid', 'credentials_invalid')),
  severity           text NOT NULL DEFAULT 'error' CHECK (severity IN ('warning', 'error')),
  entity_type        text,
  entity_id          uuid,
  external_id        text,
  sync_run_id        uuid,
  integration_job_id uuid,
  message            text NOT NULL,
  details            jsonb NOT NULL DEFAULT '{}'::jsonb,
  status             text NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'resolved', 'ignored')),
  occurrences        integer NOT NULL DEFAULT 1 CHECK (occurrences > 0),
  first_seen_at      timestamptz NOT NULL DEFAULT now(),
  last_seen_at       timestamptz NOT NULL DEFAULT now(),
  resolved_at        timestamptz,
  resolved_by        uuid,
  created_at         timestamptz NOT NULL DEFAULT now(),
  updated_at         timestamptz NOT NULL DEFAULT now(),
  created_by         uuid,
  updated_by         uuid,
  version            integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, connection_id) REFERENCES app.integration_connections (tenant_id, id),
  FOREIGN KEY (tenant_id, sync_run_id) REFERENCES app.sync_runs (tenant_id, id),
  FOREIGN KEY (tenant_id, integration_job_id) REFERENCES app.integration_jobs (tenant_id, id),
  CHECK (status = 'open' OR resolved_at IS NOT NULL)
);
CREATE UNIQUE INDEX integration_issues_open_key ON app.integration_issues
  (tenant_id, issue_type, coalesce(entity_type, ''), coalesce(entity_id::text, external_id, ''))
  WHERE status = 'open';
CREATE INDEX integration_issues_connection_idx ON app.integration_issues (tenant_id, connection_id, status);
CREATE INDEX integration_issues_sync_run_idx ON app.integration_issues (tenant_id, sync_run_id) WHERE sync_run_id IS NOT NULL;
CREATE INDEX integration_issues_job_idx ON app.integration_issues (tenant_id, integration_job_id) WHERE integration_job_id IS NOT NULL;
COMMENT ON TABLE app.integration_issues IS 'Pendência de integração que exige ação humana, deduplicada (uma aberta por tipo + registro; repetições incrementam occurrences). Proposta de docs/07.';

CREATE TABLE app.integration_mappings (
  id             uuid NOT NULL DEFAULT app.uuid_v7() PRIMARY KEY,
  tenant_id      uuid NOT NULL REFERENCES app.tenants (id),
  connection_id  uuid NOT NULL,
  mapping_type   text NOT NULL CHECK (mapping_type ~ '^[a-z_]{3,60}$'),
  local_key      text NOT NULL,
  external_value jsonb NOT NULL,
  is_active      boolean NOT NULL DEFAULT true,
  created_at     timestamptz NOT NULL DEFAULT now(),
  updated_at     timestamptz NOT NULL DEFAULT now(),
  created_by     uuid,
  updated_by     uuid,
  version        integer NOT NULL DEFAULT 1,
  UNIQUE (tenant_id, id),
  FOREIGN KEY (tenant_id, connection_id) REFERENCES app.integration_connections (tenant_id, id)
);
CREATE UNIQUE INDEX integration_mappings_key ON app.integration_mappings (tenant_id, connection_id, mapping_type, local_key) WHERE is_active;
CREATE INDEX integration_mappings_connection_idx ON app.integration_mappings (tenant_id, connection_id);
COMMENT ON TABLE app.integration_mappings IS 'De-para de valores por conexão (ex.: billing_type_transaction, service_area_branch, unit_of_measure, work_order_type_transaction). Proposta de docs/07.';

-- =============================================================================
-- 19. Auditoria (módulo audit) — particionada por mês
-- =============================================================================

CREATE TABLE app.audit_logs (
  id             uuid NOT NULL DEFAULT app.uuid_v7(),
  tenant_id      uuid REFERENCES app.tenants (id),
  occurred_at    timestamptz NOT NULL DEFAULT now(),
  actor_type     text NOT NULL CHECK (actor_type IN ('user', 'customer_contact', 'technician', 'system', 'integration', 'platform_support')),
  actor_user_id  uuid,
  action         text NOT NULL,
  entity_type    text NOT NULL,
  entity_id      uuid,
  before_data    jsonb,
  after_data     jsonb,
  changed_fields text[],
  reason         text,
  correlation_id text,
  ip             inet,
  user_agent     text,
  created_at     timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (id, occurred_at)
) PARTITION BY RANGE (occurred_at);
CREATE INDEX audit_logs_entity_idx ON app.audit_logs (tenant_id, entity_type, entity_id, occurred_at DESC);
CREATE INDEX audit_logs_recent_idx ON app.audit_logs (tenant_id, occurred_at DESC);
CREATE INDEX audit_logs_actor_idx ON app.audit_logs (tenant_id, actor_user_id, occurred_at DESC) WHERE actor_user_id IS NOT NULL;
COMMENT ON TABLE app.audit_logs IS 'Log de auditoria append-only (antes/depois em jsonb). tenant_id nulo = ação de plataforma. Particionada por mês; retenção padrão 5 anos (DETACH + arquivo em object storage).';

CREATE TABLE app.audit_logs_default PARTITION OF app.audit_logs DEFAULT;

-- Cria as partições mensais (mês corrente + N meses) com RLS. Executada pela
-- migração/cron de manutenção como app_owner (o runtime não cria tabelas).
CREATE FUNCTION app.ensure_audit_log_partitions(p_months_ahead integer DEFAULT 3) RETURNS integer
LANGUAGE plpgsql
AS $$
DECLARE
  v_start   date;
  v_name    text;
  v_created integer := 0;
  i         integer;
BEGIN
  FOR i IN 0..p_months_ahead LOOP
    v_start := (date_trunc('month', now() AT TIME ZONE 'UTC') + make_interval(months => i))::date;
    v_name  := 'audit_logs_' || to_char(v_start, 'YYYYMM');
    IF to_regclass('app.' || v_name) IS NULL THEN
      EXECUTE format('CREATE TABLE app.%I PARTITION OF app.audit_logs FOR VALUES FROM (%L) TO (%L)',
                     v_name, to_char(v_start, 'YYYY-MM-DD') || ' 00:00:00+00',
                     to_char((v_start + interval '1 month')::date, 'YYYY-MM-DD') || ' 00:00:00+00');
      EXECUTE format('ALTER TABLE app.%I ENABLE ROW LEVEL SECURITY', v_name);
      EXECUTE format('ALTER TABLE app.%I FORCE ROW LEVEL SECURITY', v_name);
      EXECUTE format('CREATE POLICY tenant_isolation ON app.%I AS PERMISSIVE FOR ALL TO app_runtime '
                     'USING (tenant_id = app.current_tenant_id()) WITH CHECK (tenant_id = app.current_tenant_id())', v_name);
      -- Acesso só pela tabela-mãe (o runtime não lê/escreve partições diretamente).
      EXECUTE format('REVOKE ALL ON app.%I FROM app_runtime', v_name);
      v_created := v_created + 1;
    END IF;
  END LOOP;
  RETURN v_created;
END
$$;
COMMENT ON FUNCTION app.ensure_audit_log_partitions(integer) IS 'Cria partições mensais futuras de audit_logs com RLS (rodar mensalmente como app_owner).';

-- =============================================================================
-- 20. Triggers de domínio
-- =============================================================================

-- 20.1 Numeração da OS por tenant/ano (D6), formato configurável em tenant_settings.
CREATE FUNCTION app.tg_work_order_number() RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  v_format  text := '{YYYY}-{SEQ}';
  v_padding int  := 6;
  v_reset   text := 'yearly';
  v_tz      text := 'America/Sao_Paulo';
  v_year    text;
  v_period  text;
  v_seq     bigint;
  v_seq_txt text;
BEGIN
  IF NEW.number IS NOT NULL THEN
    RETURN NEW;  -- importação/migração com número já definido
  END IF;
  SELECT s.work_order_number_format, s.work_order_number_padding, s.work_order_number_reset, s.timezone
    INTO v_format, v_padding, v_reset, v_tz
    FROM app.tenant_settings s
   WHERE s.tenant_id = NEW.tenant_id;
  IF NOT FOUND THEN
    v_format := '{YYYY}-{SEQ}'; v_padding := 6; v_reset := 'yearly'; v_tz := 'America/Sao_Paulo';
  END IF;
  v_year   := to_char(now() AT TIME ZONE v_tz, 'YYYY');
  v_period := CASE WHEN v_reset = 'yearly' THEN v_year ELSE '' END;
  v_seq    := app.next_tenant_sequence('work_order', v_period);
  v_seq_txt := CASE WHEN length(v_seq::text) >= v_padding THEN v_seq::text ELSE lpad(v_seq::text, v_padding, '0') END;
  NEW.number        := replace(replace(v_format, '{YYYY}', v_year), '{SEQ}', v_seq_txt);
  NEW.number_period := v_period;
  NEW.number_seq    := v_seq;
  RETURN NEW;
END
$$;
COMMENT ON FUNCTION app.tg_work_order_number() IS 'BEFORE INSERT em work_orders: atribui number via app.next_tenant_sequence(work_order, <ano no fuso do tenant>).';
-- number é NOT NULL, mas o trigger BEFORE preenche antes da checagem.
CREATE TRIGGER trg_number BEFORE INSERT ON app.work_orders
  FOR EACH ROW EXECUTE FUNCTION app.tg_work_order_number();

-- 20.2 Máquina de estados da OS (D9) — segunda barreira; a regra completa
-- (ator, pré-condições, efeitos) fica no módulo work_orders.
-- v0.2 (MVP): resolução remota. requested -> completed e open -> completed só
-- com resolution_mode = 'remote' e sem visita ativa (scheduled, en_route,
-- on_site, paused); in_progress -> completed não aceita 'remote' (houve visita).
-- A resolução remota conta como primeiro atendimento (first_response_at).
-- completed -> closed continua valendo para todos os modos.
CREATE FUNCTION app.tg_work_order_status_guard() RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  c_allowed constant jsonb := '{
    "requested":   ["open", "completed", "cancelled"],
    "open":        ["scheduled", "in_progress", "completed", "cancelled"],
    "scheduled":   ["open", "in_progress", "on_hold", "cancelled"],
    "in_progress": ["on_hold", "completed", "open", "scheduled"],
    "on_hold":     ["scheduled", "in_progress", "open", "cancelled"],
    "completed":   ["closed", "open"],
    "closed":      ["open"],
    "cancelled":   ["open"]
  }';
BEGIN
  IF NEW.status IS DISTINCT FROM OLD.status THEN
    IF NOT ((c_allowed -> OLD.status) ? NEW.status) THEN
      RAISE EXCEPTION 'Transição de status inválida na OS %: % -> %', OLD.number, OLD.status, NEW.status
        USING ERRCODE = 'check_violation';
    END IF;
    IF NEW.status = 'completed' AND OLD.status IN ('requested', 'open') THEN
      IF NEW.resolution_mode IS DISTINCT FROM 'remote' THEN
        RAISE EXCEPTION 'OS %: % -> completed só por resolução remota (resolution_mode = remote)', OLD.number, OLD.status
          USING ERRCODE = 'check_violation';
      END IF;
      IF EXISTS (SELECT 1 FROM app.work_order_visits v
                  WHERE v.tenant_id = NEW.tenant_id AND v.work_order_id = NEW.id
                    AND v.status IN ('scheduled', 'en_route', 'on_site', 'paused')) THEN
        RAISE EXCEPTION 'OS % tem visita ativa e não pode ser resolvida remotamente', OLD.number
          USING ERRCODE = 'check_violation';
      END IF;
      NEW.first_response_at := coalesce(NEW.first_response_at, NEW.completed_at, now());
    ELSIF NEW.status = 'completed' AND NEW.resolution_mode = 'remote' THEN
      RAISE EXCEPTION 'OS %: resolução remota só a partir de requested ou open (status atual %)', OLD.number, OLD.status
        USING ERRCODE = 'check_violation';
    END IF;
    NEW.status_changed_at := now();
    IF NEW.status <> 'on_hold' THEN
      NEW.hold_reason := NULL;
    END IF;
    IF OLD.status IN ('completed', 'closed', 'cancelled') AND NEW.status = 'open' THEN
      NEW.reopened_count   := OLD.reopened_count + 1;
      NEW.last_reopened_at := now();
    END IF;
  END IF;
  RETURN NEW;
END
$$;
CREATE TRIGGER trg_guard_status BEFORE UPDATE OF status ON app.work_orders
  FOR EACH ROW EXECUTE FUNCTION app.tg_work_order_status_guard();

-- 20.3 Histórico de status da OS.
CREATE FUNCTION app.tg_work_order_status_history() RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF TG_OP = 'INSERT' OR NEW.status IS DISTINCT FROM OLD.status THEN
    INSERT INTO app.work_order_status_history
      (tenant_id, work_order_id, from_status, to_status, hold_reason, reason, changed_at, changed_by, actor_type, created_by)
    VALUES
      (NEW.tenant_id, NEW.id, CASE WHEN TG_OP = 'UPDATE' THEN OLD.status END, NEW.status, NEW.hold_reason,
       NEW.status_reason, NEW.status_changed_at, app.current_user_id(),
       nullif(current_setting('app.actor_type', true), ''), app.current_user_id());
  END IF;
  RETURN NULL;
END
$$;
CREATE TRIGGER trg_status_history AFTER INSERT OR UPDATE OF status ON app.work_orders
  FOR EACH ROW EXECUTE FUNCTION app.tg_work_order_status_history();

-- 20.4 Máquina de estados da visita (D9).
CREATE FUNCTION app.tg_visit_status_guard() RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  c_allowed constant jsonb := '{
    "scheduled": ["en_route", "on_site", "finished", "cancelled"],
    "en_route":  ["on_site", "finished", "cancelled"],
    "on_site":   ["paused", "finished"],
    "paused":    ["on_site", "finished"],
    "finished":  [],
    "cancelled": []
  }';
BEGIN
  IF NEW.status IS DISTINCT FROM OLD.status AND NOT ((c_allowed -> OLD.status) ? NEW.status) THEN
    RAISE EXCEPTION 'Transição de status inválida na visita %: % -> %', OLD.id, OLD.status, NEW.status
      USING ERRCODE = 'check_violation';
  END IF;
  -- scheduled/en_route -> finished só é aceito sem check-in (cliente ausente / não executada).
  IF NEW.status = 'finished' AND OLD.status IN ('scheduled', 'en_route')
     AND NEW.outcome NOT IN ('customer_absent', 'not_executed') THEN
    RAISE EXCEPTION 'Visita % sem check-in só pode terminar como customer_absent ou not_executed', OLD.id
      USING ERRCODE = 'check_violation';
  END IF;
  RETURN NEW;
END
$$;
CREATE TRIGGER trg_guard_status BEFORE UPDATE OF status ON app.work_order_visits
  FOR EACH ROW EXECUTE FUNCTION app.tg_visit_status_guard();

-- 20.5 Perda de escopo no sync: visita reatribuída gera tombstone para o técnico anterior.
CREATE FUNCTION app.tg_visit_scope_lost() RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  -- v0.2: visita atribuída só ao prestador tem technician_id nulo; sem técnico
  -- anterior não há dispositivo a avisar (tombstone com técnico nulo valeria para todos).
  IF OLD.technician_id IS NOT NULL AND NEW.technician_id IS DISTINCT FROM OLD.technician_id THEN
    INSERT INTO app.sync_tombstones (tenant_id, entity_type, entity_id, technician_id, reason)
    VALUES (OLD.tenant_id, 'work_order_visits', OLD.id, OLD.technician_id, 'scope_lost');
  END IF;
  RETURN NULL;
END
$$;
CREATE TRIGGER trg_scope_lost AFTER UPDATE OF technician_id ON app.work_order_visits
  FOR EACH ROW EXECUTE FUNCTION app.tg_visit_scope_lost();

-- 20.6 Ciclo de vida da etiqueta (D9b + docs/05): generated -> printed -> bound;
-- bound -> printed = "desfazer vínculo" (exceção auditada, só tenant_admin na API).
CREATE FUNCTION app.tg_qr_tag_status_guard() RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  c_allowed constant jsonb := '{
    "generated": ["printed", "bound", "revoked"],
    "printed":   ["bound", "revoked"],
    "bound":     ["printed", "revoked"],
    "revoked":   []
  }';
BEGIN
  IF NEW.status IS DISTINCT FROM OLD.status THEN
    IF NOT ((c_allowed -> OLD.status) ? NEW.status) THEN
      RAISE EXCEPTION 'Transição inválida da etiqueta %: % -> %', OLD.short_code, OLD.status, NEW.status
        USING ERRCODE = 'check_violation';
    END IF;
    IF OLD.status = 'bound' THEN
      NEW.last_bound_asset_id := OLD.asset_id;
      NEW.asset_id := NULL;
      IF NEW.status = 'printed' THEN
        NEW.unbind_count := OLD.unbind_count + 1;
      END IF;
    END IF;
  END IF;
  IF NEW.status = 'bound' THEN
    NEW.last_bound_asset_id := NEW.asset_id;
  END IF;
  RETURN NEW;
END
$$;
CREATE TRIGGER trg_guard_status BEFORE UPDATE ON app.qr_tags
  FOR EACH ROW EXECUTE FUNCTION app.tg_qr_tag_status_guard();

-- 20.7 Alocação vigente desnormalizada em assets.current_customer_*.
CREATE FUNCTION app.tg_asset_assignment_refresh_current() RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE app.assets a
     SET current_customer_id      = cur.customer_id,
         current_customer_site_id = cur.customer_site_id
    FROM (SELECT NEW.tenant_id AS tenant_id, NEW.asset_id AS asset_id) k
    LEFT JOIN app.asset_assignments cur
           ON cur.tenant_id = k.tenant_id AND cur.asset_id = k.asset_id AND cur.ended_at IS NULL
          AND cur.approval_status IN ('not_required', 'approved')  -- v0.2: pendente/rejeitada não é vigente
   WHERE a.tenant_id = k.tenant_id
     AND a.id = k.asset_id
     AND (a.current_customer_id IS DISTINCT FROM cur.customer_id
          OR a.current_customer_site_id IS DISTINCT FROM cur.customer_site_id);
  RETURN NULL;
END
$$;
CREATE TRIGGER trg_refresh_current AFTER INSERT OR UPDATE ON app.asset_assignments
  FOR EACH ROW EXECUTE FUNCTION app.tg_asset_assignment_refresh_current();

-- 20.8 Invariante status do ativo x alocação vigente, verificada no COMMIT
-- (permite encerrar/abrir alocação e mudar o status em qualquer ordem na transação).
-- v0.2: "vigente" exclui alocações pending/rejected (assets.current_customer_* só
-- reflete not_required/approved), então registrar uma movimentação pendente não
-- mexe no status nem quebra a invariante; a aprovação aplica tudo de uma vez.
CREATE FUNCTION app.tg_check_asset_state() RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
  v_status   text;
  v_customer uuid;
BEGIN
  SELECT a.status, a.current_customer_id INTO v_status, v_customer
    FROM app.assets a WHERE a.tenant_id = NEW.tenant_id AND a.id = NEW.id;
  IF NOT FOUND THEN
    RETURN NULL;
  END IF;
  IF v_status = 'installed' AND v_customer IS NULL THEN
    RAISE EXCEPTION 'Ativo % com status installed exige alocação vigente', NEW.id USING ERRCODE = 'check_violation';
  END IF;
  IF v_status IN ('in_stock', 'retired') AND v_customer IS NOT NULL THEN
    RAISE EXCEPTION 'Ativo % com status % não pode ter alocação vigente', NEW.id, v_status USING ERRCODE = 'check_violation';
  END IF;
  RETURN NULL;
END
$$;
CREATE CONSTRAINT TRIGGER trg_check_asset_state AFTER INSERT OR UPDATE ON app.assets
  DEFERRABLE INITIALLY DEFERRED
  FOR EACH ROW EXECUTE FUNCTION app.tg_check_asset_state();

-- 20.9 Campos mestres do ERP somente leitura (D10). Extensões locais ficam fora da lista.
CREATE TRIGGER trg_guard_erp_master BEFORE UPDATE ON app.customers
  FOR EACH ROW EXECUTE FUNCTION app.tg_guard_erp_master_fields(
    'source', 'external_system', 'external_id', 'code', 'name', 'trade_name', 'person_type', 'document_type',
    'document_number', 'state_registration', 'email', 'phone', 'is_active', 'missing_since');
CREATE TRIGGER trg_guard_erp_master BEFORE UPDATE ON app.customer_sites
  FOR EACH ROW EXECUTE FUNCTION app.tg_guard_erp_master_fields(
    'source', 'external_system', 'external_id', 'customer_id', 'code', 'name', 'street', 'street_number',
    'complement', 'district', 'city', 'state', 'postal_code', 'country_code', 'is_active', 'missing_since');
CREATE TRIGGER trg_guard_erp_master BEFORE UPDATE ON app.customer_contacts
  FOR EACH ROW EXECUTE FUNCTION app.tg_guard_erp_master_fields(
    'source', 'external_system', 'external_id', 'customer_id', 'name', 'email', 'phone_e164', 'job_title', 'is_active', 'missing_since');
CREATE TRIGGER trg_guard_erp_master BEFORE UPDATE ON app.products
  FOR EACH ROW EXECUTE FUNCTION app.tg_guard_erp_master_fields(
    'source', 'external_system', 'external_id', 'code', 'name', 'description', 'unit_code', 'gtin', 'reference_price', 'is_active', 'missing_since');
CREATE TRIGGER trg_guard_erp_master BEFORE UPDATE ON app.services
  FOR EACH ROW EXECUTE FUNCTION app.tg_guard_erp_master_fields(
    'source', 'external_system', 'external_id', 'code', 'name', 'description', 'unit_code', 'default_price', 'is_active', 'missing_since');
-- v0.2 (F2): bens do ERP (patrimônio). Status, alocação, local, garantia, propriedade,
-- pai/filho, baixa operacional e notas continuam extensões locais.
CREATE TRIGGER trg_guard_erp_master BEFORE UPDATE ON app.assets
  FOR EACH ROW EXECUTE FUNCTION app.tg_guard_erp_master_fields(
    'source', 'external_system', 'external_id', 'product_id', 'serial_number', 'asset_tag', 'branch_id',
    'acquisition_date', 'acquisition_cost', 'supplier_name', 'acquisition_document', 'is_active', 'missing_since');

-- =============================================================================
-- 21. Triggers padrão (laço): colunas padrão, row_version, tombstones, auditoria
-- =============================================================================
DO $$
DECLARE
  r record;
BEGIN
  -- created_*/updated_*/version em toda tabela que tem updated_at.
  FOR r IN
    SELECT c.oid::regclass AS tbl
      FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
     WHERE n.nspname = 'app' AND c.relkind IN ('r', 'p') AND NOT c.relispartition
       AND EXISTS (SELECT 1 FROM pg_attribute a WHERE a.attrelid = c.oid AND a.attname = 'updated_at' AND NOT a.attisdropped)
  LOOP
    EXECUTE format('CREATE TRIGGER trg_stamp BEFORE INSERT OR UPDATE ON %s FOR EACH ROW EXECUTE FUNCTION app.tg_set_standard_columns()', r.tbl);
  END LOOP;

  -- row_version/sync_xid e tombstone de exclusão nas tabelas sincronizadas (D11).
  FOR r IN
    SELECT c.oid::regclass AS tbl, c.relname
      FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
     WHERE n.nspname = 'app' AND c.relkind IN ('r', 'p') AND NOT c.relispartition
       AND EXISTS (SELECT 1 FROM pg_attribute a WHERE a.attrelid = c.oid AND a.attname = 'row_version' AND NOT a.attisdropped)
  LOOP
    EXECUTE format('CREATE TRIGGER trg_row_version BEFORE INSERT OR UPDATE ON %s FOR EACH ROW EXECUTE FUNCTION app.tg_bump_row_version()', r.tbl);
    IF r.relname <> 'sync_tombstones' THEN
      EXECUTE format('CREATE TRIGGER trg_sync_tombstone AFTER DELETE ON %s FOR EACH ROW EXECUTE FUNCTION app.tg_sync_tombstone_on_delete()', r.tbl);
    END IF;
  END LOOP;

  -- Auditoria (antes/depois) em cadastros, ativos/QR, OS e execução.
  FOR r IN
    SELECT unnest(ARRAY[
      'tenant_settings', 'tenant_memberships', 'tenant_membership_roles',
      'customers', 'customer_sites', 'customer_contacts',
      'product_families', 'products', 'services', 'symptoms', 'failure_causes', 'resolution_codes', 'checklist_templates',
      'work_order_types', 'sla_policies', 'business_calendars', 'holidays', 'service_areas',
      'work_shifts', 'work_shift_periods', 'teams', 'team_members', 'technicians', 'technician_shift_assignments',
      'assets', 'asset_assignments', 'qr_tag_batches', 'qr_tags',
      'work_orders', 'work_order_visits', 'work_order_items', 'time_entries',
      'sync_review_items', 'support_sessions',
      'integration_connections', 'integration_mappings',
      -- v0.2 (meter_readings e customer_sales_summaries ficam fora: volume alto e origem automática)
      'branches', 'sales_reps', 'service_providers', 'provider_rates', 'on_call_assignments', 'escalation_policies',
      'work_order_costs', 'provider_settlements', 'maintenance_plans', 'maintenance_plan_assets', 'asset_meters',
      'iot_devices', 'telemetry_alert_rules']) AS relname
  LOOP
    EXECUTE format('CREATE TRIGGER trg_audit AFTER INSERT OR UPDATE OR DELETE ON app.%I FOR EACH ROW EXECUTE FUNCTION app.tg_audit_row()', r.relname);
  END LOOP;
END
$$;

-- =============================================================================
-- 22. Row-Level Security (D4)
-- Toda tabela com tenant_id: ENABLE + FORCE + política tenant_isolation para
-- app_runtime (USING e WITH CHECK com app.current_tenant_id(); sem app.tenant_id
-- => NULL => nenhuma linha). app_owner também fica sujeito (FORCE) e não tem
-- política: migrações de dados fazem SET LOCAL app.tenant_id por tenant.
-- =============================================================================
DO $$
DECLARE
  r record;
BEGIN
  FOR r IN
    SELECT c.oid::regclass AS tbl
      FROM pg_class c JOIN pg_namespace n ON n.oid = c.relnamespace
     WHERE n.nspname = 'app' AND c.relkind IN ('r', 'p')
       AND EXISTS (SELECT 1 FROM pg_attribute a WHERE a.attrelid = c.oid AND a.attname = 'tenant_id' AND NOT a.attisdropped)
  LOOP
    EXECUTE format('ALTER TABLE %s ENABLE ROW LEVEL SECURITY', r.tbl);
    EXECUTE format('ALTER TABLE %s FORCE ROW LEVEL SECURITY', r.tbl);
    EXECUTE format('CREATE POLICY tenant_isolation ON %s AS PERMISSIVE FOR ALL TO app_runtime '
                   'USING (tenant_id = app.current_tenant_id()) WITH CHECK (tenant_id = app.current_tenant_id())', r.tbl);
  END LOOP;
END
$$;

-- 22.1 Vínculos do próprio usuário em todos os tenants (antes de escolher o tenant ativo).
CREATE POLICY own_memberships_read ON app.tenant_memberships FOR SELECT TO app_runtime
  USING (user_id = app.current_user_id());
CREATE POLICY own_membership_roles_read ON app.tenant_membership_roles FOR SELECT TO app_runtime
  USING (EXISTS (SELECT 1 FROM app.tenant_memberships m
                  WHERE m.tenant_id = tenant_membership_roles.tenant_id
                    AND m.id = tenant_membership_roles.membership_id
                    AND m.user_id = app.current_user_id()));

-- 22.2 Auditoria de plataforma (tenant_id nulo) só em contexto de plataforma.
CREATE POLICY platform_audit ON app.audit_logs FOR ALL TO app_runtime
  USING (tenant_id IS NULL AND app.is_platform_context())
  WITH CHECK (tenant_id IS NULL AND app.is_platform_context());
CREATE POLICY platform_audit ON app.audit_logs_default FOR ALL TO app_runtime
  USING (tenant_id IS NULL AND app.is_platform_context())
  WITH CHECK (tenant_id IS NULL AND app.is_platform_context());

-- 22.3 Tabelas globais sensíveis: tenants e users (RLS sem tenant_id).
ALTER TABLE app.tenants ENABLE ROW LEVEL SECURITY;
ALTER TABLE app.tenants FORCE ROW LEVEL SECURITY;
CREATE POLICY tenants_read ON app.tenants FOR SELECT TO app_runtime
  USING (id = app.current_tenant_id()
         OR app.is_platform_context()
         OR EXISTS (SELECT 1 FROM app.tenant_memberships m
                     WHERE m.tenant_id = tenants.id AND m.user_id = app.current_user_id()
                       AND m.status IN ('invited', 'active')));
CREATE POLICY tenants_insert ON app.tenants FOR INSERT TO app_runtime
  WITH CHECK (app.is_platform_context());
CREATE POLICY tenants_update ON app.tenants FOR UPDATE TO app_runtime
  USING (id = app.current_tenant_id() OR app.is_platform_context())
  WITH CHECK (id = app.current_tenant_id() OR app.is_platform_context());

ALTER TABLE app.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE app.users FORCE ROW LEVEL SECURITY;
CREATE POLICY users_read ON app.users FOR SELECT TO app_runtime
  USING (id = app.current_user_id()
         OR app.is_platform_context()
         OR EXISTS (SELECT 1 FROM app.tenant_memberships m WHERE m.user_id = users.id AND m.tenant_id = app.current_tenant_id())
         OR EXISTS (SELECT 1 FROM app.customer_contacts cc WHERE cc.user_id = users.id AND cc.tenant_id = app.current_tenant_id())
         OR EXISTS (SELECT 1 FROM app.technicians t WHERE t.user_id = users.id AND t.tenant_id = app.current_tenant_id()));
-- Provisionamento JIT (primeiro login no IdP, primeiro OTP do contato). O id é
-- gerado pela aplicação, então o INSERT não depende de RETURNING.
CREATE POLICY users_insert ON app.users FOR INSERT TO app_runtime
  WITH CHECK (true);
CREATE POLICY users_update ON app.users FOR UPDATE TO app_runtime
  USING (id = app.current_user_id()
         OR app.is_platform_context()
         OR EXISTS (SELECT 1 FROM app.tenant_memberships m WHERE m.user_id = users.id AND m.tenant_id = app.current_tenant_id())
         OR EXISTS (SELECT 1 FROM app.customer_contacts cc WHERE cc.user_id = users.id AND cc.tenant_id = app.current_tenant_id()))
  WITH CHECK (true);

-- 22.4 app_system (dono das funções SECURITY DEFINER): leitura entre tenants
-- apenas nas tabelas de que essas funções precisam.
CREATE POLICY system_access ON app.tenants           FOR SELECT TO app_system USING (true);
CREATE POLICY system_access ON app.users             FOR SELECT TO app_system USING (true);
CREATE POLICY system_access ON app.qr_tags           FOR SELECT TO app_system USING (true);
CREATE POLICY system_access ON app.customer_contacts FOR SELECT TO app_system USING (true);
CREATE POLICY system_access ON app.auth_sessions     FOR SELECT TO app_system USING (true);
CREATE POLICY system_access ON app.outbox_messages   FOR ALL    TO app_system USING (true) WITH CHECK (true);
CREATE POLICY system_access ON app.integration_jobs  FOR ALL    TO app_system USING (true) WITH CHECK (true);
CREATE POLICY system_access ON app.background_jobs   FOR ALL    TO app_system USING (true) WITH CHECK (true);
CREATE POLICY system_access ON app.display_tokens    FOR SELECT TO app_system USING (true);

-- =============================================================================
-- 23. Grants
-- =============================================================================
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA app TO app_runtime;
-- Catálogos globais: somente leitura em runtime (mudam por migração/seed).
REVOKE INSERT, UPDATE ON app.plans, app.roles, app.permissions, app.role_permissions FROM app_runtime;
-- Append-only.
REVOKE UPDATE ON app.audit_logs, app.work_order_status_history, app.sync_tombstones, app.sync_mutations FROM app_runtime;
-- Partições: acesso só pela tabela-mãe.
REVOKE ALL ON app.audit_logs_default FROM app_runtime;
-- Exclusão física só onde é legítima (associações, preferências e expurgos técnicos).
GRANT DELETE ON
  app.tenant_membership_roles, app.team_members, app.technician_service_areas, app.technician_skills,
  app.symptom_applicabilities, app.work_shift_periods, app.business_calendar_hours, app.holidays,
  app.notification_preferences, app.idempotency_keys, app.otp_challenges, app.auth_sessions,
  app.sync_mutations, app.sync_tombstones, app.outbox_messages, app.device_sync_scopes,
  app.on_call_assignments
TO app_runtime;
GRANT USAGE ON SEQUENCE app.sync_row_version_seq TO app_runtime, app_system;

GRANT SELECT ON app.tenants, app.users, app.qr_tags, app.customer_contacts, app.auth_sessions TO app_system;
GRANT SELECT, UPDATE ON app.outbox_messages, app.integration_jobs, app.background_jobs TO app_system;
GRANT SELECT ON app.display_tokens TO app_system;

ALTER DEFAULT PRIVILEGES FOR ROLE app_owner IN SCHEMA app GRANT SELECT, INSERT, UPDATE ON TABLES TO app_runtime;
ALTER DEFAULT PRIVILEGES FOR ROLE app_owner IN SCHEMA app GRANT USAGE ON SEQUENCES TO app_runtime;

-- Partições mensais iniciais de audit_logs (mês corrente + 3).
SELECT app.ensure_audit_log_partitions(3);

-- v0.3 (docs/12 §3 e §4): não há fila de jobs externa. O trabalho assíncrono
-- usa as tabelas deste schema (outbox_messages, integration_jobs,
-- notifications), consumidas com FOR UPDATE SKIP LOCKED pelas funções claim_*
-- (seção 24) nos laços do worker (Serverpod com --role monolith). As tarefas
-- agendadas do Serverpod (future calls com cron) só disparam no horário
-- (escalonamento, planos, fechamento, partições); são "pelo menos uma vez" e
-- sem retentativa, por isso tentativas e backoff ficam nas nossas tabelas.
--
-- Serverpod 4.1 e as tabelas deste arquivo:
--   * As tabelas de negócio (schema app) são declaradas nos modelos .spy.yaml
--     do Serverpod com "managedMigration: false": o ORM lê e grava, mas o DDL
--     (RLS, FKs compostas, CHECKs, triggers, funções) é SQL-first, aplicado
--     pelo dbmate a partir deste arquivo. O CI confere modelos x banco.
--   * O Serverpod cria e migra as PRÓPRIAS tabelas (serverpod_*: auth, future
--     calls, sessões, logs) no schema public, com as migrações dele. Elas não
--     guardam dados de negócio e não têm tenant_id; nunca rodar "repair
--     migration" em produção sem revisão.
--   * O tenant é aplicado pelo databaseInterceptor do Serverpod: toda operação
--     da sessão (ORM e SQL próprio) roda numa transação que começa com
--     set_config('app.tenant_id', ..., true). O RLS FORCE continua como
--     segunda barreira.
--   * Ids: UuidValue com defaultModel = random_v7 (gerado no app, inclusive
--     offline); o DEFAULT app.uuid_v7() cobre inserts feitos no banco.
--
-- Ajustes por papel de LOGIN (NÃO executável aqui: os usuários de login são
-- criados pela infraestrutura, docs/09, que roda estes comandos depois de
-- criá-los). O ORM do Serverpod grava DateTime sempre em UTC; fixar o fuso da
-- sessão em UTC garante que timestamptz e funções de data (date_trunc, ::date)
-- se comportem igual na api, no worker e nas migrações. O search_path deixa o
-- ORM achar as tabelas de negócio em app e as do Serverpod em public.
--
--   ALTER ROLE app_api      SET timezone = 'UTC';
--   ALTER ROLE app_api      SET search_path = app, public;
--   ALTER ROLE app_worker   SET timezone = 'UTC';
--   ALTER ROLE app_worker   SET search_path = app, public;
--   ALTER ROLE app_migrator SET timezone = 'UTC';
--   ALTER ROLE app_migrator SET search_path = app, public;
--
-- O papel que roda as migrações do Serverpod (tabelas serverpod_* em public)
-- precisa de CREATE em public; app_api e app_worker recebem só DML nelas.

-- =============================================================================
-- 24. Funções SECURITY DEFINER (dono app_system, search_path fixo)
-- =============================================================================
SET ROLE app_system;

-- Resolução pública do QR (D7): só o necessário para a página pública.
-- Etiquetas de tenants suspensos/cancelados não resolvem.
CREATE FUNCTION public.resolve_qr_token(p_token text)
RETURNS TABLE (tenant_id uuid, qr_tag_id uuid, status text, asset_id uuid)
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
AS $$
  SELECT t.tenant_id, t.id, t.status, t.asset_id
    FROM app.qr_tags t
    JOIN app.tenants tn ON tn.id = t.tenant_id AND tn.status IN ('trial', 'active')
   WHERE length(p_token) BETWEEN 26 AND 40
     AND t.token = app.normalize_crockford_base32(p_token)
$$;
COMMENT ON FUNCTION public.resolve_qr_token(text) IS 'Resolve o token da URL /q/<token> (entre tenants, sem expor dados): tenant_id, qr_tag_id, status, asset_id.';

CREATE FUNCTION public.resolve_qr_short_code(p_code text)
RETURNS TABLE (tenant_id uuid, qr_tag_id uuid, status text, asset_id uuid)
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
AS $$
  SELECT t.tenant_id, t.id, t.status, t.asset_id
    FROM app.qr_tags t
    JOIN app.tenants tn ON tn.id = t.tenant_id AND tn.status IN ('trial', 'active')
   WHERE length(p_code) BETWEEN 8 AND 12
     AND app.crockford_luhn32_is_valid(app.normalize_crockford_base32(p_code))
     AND t.short_code = app.normalize_crockford_base32(p_code)
$$;
COMMENT ON FUNCTION public.resolve_qr_short_code(text) IS 'Resolve o short code digitado (XXXX-XXXX, tolerante a hífen/minúsculas/I-L-O); verificador inválido => nenhuma linha sem consultar a tabela.';

-- Login do contato sem QR (app nativo): em quais tenants este destino é contato ativo.
-- A API só revela a lista DEPOIS de validar o OTP.
CREATE FUNCTION app.find_contact_logins(p_channel text, p_destination text)
RETURNS TABLE (tenant_id uuid, tenant_display_name text, customer_contact_id uuid, customer_id uuid, user_id uuid)
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
AS $$
  SELECT cc.tenant_id, tn.display_name, cc.id, cc.customer_id, cc.user_id
    FROM app.customer_contacts cc
    JOIN app.tenants tn ON tn.id = cc.tenant_id AND tn.status IN ('trial', 'active')
   WHERE cc.is_active AND cc.status = 'active' AND cc.can_open_requests
     AND ((p_channel IN ('sms', 'whatsapp') AND cc.phone_e164 = p_destination)
       OR (p_channel = 'email' AND lower(cc.email) = lower(p_destination)))
   ORDER BY tn.display_name
   LIMIT 20
$$;
COMMENT ON FUNCTION app.find_contact_logins(text, text) IS 'Contatos ativos com este telefone/e-mail em todos os tenants (login sem QR).';

-- Refresh token do contato: localiza a sessão (e o tenant) pelo hash antes de haver tenant ativo.
CREATE FUNCTION app.find_auth_session_by_refresh_hash(p_hash bytea)
RETURNS TABLE (tenant_id uuid, auth_session_id uuid, family_id uuid, status text, expires_at timestamptz)
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
AS $$
  SELECT s.tenant_id, s.id, s.family_id, s.status, s.expires_at
    FROM app.auth_sessions s
   WHERE s.refresh_token_hash = p_hash
$$;
COMMENT ON FUNCTION app.find_auth_session_by_refresh_hash(bytea) IS 'Localiza a sessão pelo hash do refresh token (rotação e detecção de reuso).';

-- Login da equipe: idp_subject (sub do Keycloak) -> users.id, antes de existir app.user_id.
CREATE FUNCTION app.find_user_by_idp_subject(p_subject text)
RETURNS TABLE (user_id uuid, status text, is_platform_admin boolean)
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
AS $$
  SELECT u.id, u.status, u.is_platform_admin FROM app.users u WHERE u.idp_subject = p_subject
$$;
COMMENT ON FUNCTION app.find_user_by_idp_subject(text) IS 'Mapeia o sub do IdP para users.id (início da requisição autenticada).';

-- Relay do outbox: reserva um lote entre tenants (SKIP LOCKED, lease). O worker
-- processa cada mensagem com SET LOCAL app.tenant_id = <tenant da mensagem>.
CREATE FUNCTION app.claim_outbox_messages(p_limit integer, p_worker text, p_lease_seconds integer DEFAULT 60)
RETURNS SETOF app.outbox_messages
LANGUAGE sql VOLATILE SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
AS $$
  UPDATE app.outbox_messages o
     SET status = 'processing',
         locked_by = p_worker,
         locked_until = now() + make_interval(secs => p_lease_seconds),
         attempt_count = o.attempt_count + 1
   WHERE o.id IN (SELECT m.id FROM app.outbox_messages m
                   WHERE (m.status = 'pending' AND m.available_at <= now())
                      OR (m.status = 'processing' AND m.locked_until < now())
                   ORDER BY m.available_at, m.id
                   LIMIT greatest(1, least(p_limit, 500))
                   FOR UPDATE SKIP LOCKED)
  RETURNING o.*
$$;
COMMENT ON FUNCTION app.claim_outbox_messages(integer, text, integer) IS 'Reserva mensagens do outbox (todos os tenants) para o relay do worker.';

CREATE FUNCTION app.claim_integration_jobs(p_limit integer, p_worker text, p_lease_seconds integer DEFAULT 120)
RETURNS TABLE (tenant_id uuid, integration_job_id uuid, operation text, status text)
LANGUAGE sql VOLATILE SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
AS $$
  UPDATE app.integration_jobs j
     SET status = 'processing',
         locked_by = p_worker,
         locked_until = now() + make_interval(secs => p_lease_seconds)
   WHERE j.id IN (SELECT x.id FROM app.integration_jobs x
                   WHERE (x.status IN ('pending', 'waiting_external') AND x.next_attempt_at <= now())
                      OR (x.status = 'processing' AND x.locked_until < now())
                   ORDER BY x.next_attempt_at, x.id
                   LIMIT greatest(1, least(p_limit, 200))
                   FOR UPDATE SKIP LOCKED)
  RETURNING j.tenant_id, j.id, j.operation, j.status
$$;
COMMENT ON FUNCTION app.claim_integration_jobs(integer, text, integer) IS 'Reserva jobs de integração vencidos (todos os tenants); o executor roda cada um no contexto do tenant.';

-- v0.3: claim da fila genérica do worker (background_jobs), por prioridade e horário.
CREATE FUNCTION app.claim_background_jobs(p_limit integer, p_worker text, p_lease_seconds integer DEFAULT 300)
RETURNS TABLE (tenant_id uuid, background_job_id uuid, kind text, payload jsonb, attempt_count integer)
LANGUAGE sql VOLATILE SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
AS $$
  UPDATE app.background_jobs j
     SET status = 'processing',
         locked_by = p_worker,
         locked_until = now() + make_interval(secs => p_lease_seconds),
         attempt_count = j.attempt_count + 1
   WHERE j.id IN (SELECT x.id FROM app.background_jobs x
                   WHERE ((x.status = 'pending' AND x.next_attempt_at <= now())
                      OR (x.status = 'processing' AND x.locked_until < now()))
                     AND x.attempt_count < x.max_attempts
                   ORDER BY x.priority, x.next_attempt_at, x.id
                   LIMIT greatest(1, least(p_limit, 200))
                   FOR UPDATE SKIP LOCKED)
  RETURNING j.tenant_id, j.id, j.kind, j.payload, j.attempt_count
$$;
COMMENT ON FUNCTION app.claim_background_jobs(integer, text, integer) IS 'v0.3: reserva jobs genéricos vencidos (todos os tenants) por prioridade; o executor roda cada um com SET LOCAL app.tenant_id do job e grava o resultado (succeeded, ou pending com next_attempt_at em backoff, ou failed ao esgotar max_attempts).';

-- v0.3 (F2): resolve o token de exibição do modo TV (sem tenant ativo, como o QR).
CREATE FUNCTION app.find_display_token_by_hash(p_hash bytea)
RETURNS TABLE (tenant_id uuid, display_token_id uuid, dashboard text, scope jsonb, allowed_ip_ranges cidr[])
LANGUAGE sql STABLE SECURITY DEFINER
SET search_path = pg_catalog, pg_temp
AS $$
  SELECT d.tenant_id, d.id, d.dashboard, d.scope, d.allowed_ip_ranges
    FROM app.display_tokens d
    JOIN app.tenants t ON t.id = d.tenant_id
   WHERE d.token_hash = p_hash
     AND d.revoked_at IS NULL
     AND d.expires_at > now()
     AND t.status IN ('trial', 'active')
$$;
COMMENT ON FUNCTION app.find_display_token_by_hash(bytea) IS 'v0.3 (F2): devolve o painel e o recorte de um token de exibição válido (não revogado, não expirado, tenant ativo). A api confere allowed_ip_ranges e abre o stream no tenant devolvido.';

RESET ROLE;
SET ROLE app_owner;

REVOKE ALL ON FUNCTION app.find_display_token_by_hash(bytea) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION app.find_display_token_by_hash(bytea) TO app_runtime;

REVOKE ALL ON FUNCTION public.resolve_qr_token(text), public.resolve_qr_short_code(text),
  app.find_contact_logins(text, text), app.find_auth_session_by_refresh_hash(bytea),
  app.find_user_by_idp_subject(text), app.claim_outbox_messages(integer, text, integer),
  app.claim_integration_jobs(integer, text, integer), app.claim_background_jobs(integer, text, integer) FROM PUBLIC;
GRANT EXECUTE ON FUNCTION public.resolve_qr_token(text), public.resolve_qr_short_code(text),
  app.find_contact_logins(text, text), app.find_auth_session_by_refresh_hash(bytea),
  app.find_user_by_idp_subject(text), app.claim_outbox_messages(integer, text, integer),
  app.claim_integration_jobs(integer, text, integer), app.claim_background_jobs(integer, text, integer) TO app_runtime;

-- =============================================================================
-- 25. Seeds globais (papéis, permissões, planos)
-- =============================================================================
INSERT INTO app.roles (code, name, scope, description) VALUES
  ('platform_admin',   'Administrador da plataforma', 'platform', 'Operação do SaaS (tenants, planos, suporte)'),
  ('tenant_admin',     'Administrador do tenant',     'tenant',   'Configurações, usuários, integrações e exceções auditadas'),
  ('dispatcher',       'Coordenador/despachante',     'tenant',   'Triagem, agenda e despacho'),
  ('backoffice_agent', 'Atendente',                   'tenant',   'Abertura e acompanhamento de OS, cadastros'),
  ('manager',          'Gestor',                      'tenant',   'Leitura e relatórios'),
  ('technician',       'Técnico',                     'tenant',   'Execução em campo pelo app'),
  ('customer_contact', 'Contato do cliente',          'customer', 'Abre e acompanha chamados'),
  ('customer_admin',   'Administrador do cliente',    'customer', 'Gerencia contatos do mesmo cliente'),
  ('sales_rep',        'Vendedor',                    'tenant',   'Carteira de clientes: ativos e OS dos seus clientes, abertura e pré-triagem (v0.2)'),
  ('provider_admin',   'Gestor do prestador',         'tenant',   'OS e técnicos da própria empresa prestadora (v0.2)');

INSERT INTO app.permissions (code, module, description) VALUES
  ('work_orders.read',         'work_orders',     'Ler OS'),
  ('work_orders.create',       'work_orders',     'Abrir OS'),
  ('work_orders.update',       'work_orders',     'Editar OS'),
  ('work_orders.triage',       'work_orders',     'Triar chamados (requested -> open/cancelled)'),
  ('work_orders.close',        'work_orders',     'Conferir e encerrar OS'),
  ('work_orders.reopen',       'work_orders',     'Reabrir OS encerrada/cancelada'),
  ('visits.schedule',          'scheduling',      'Agendar e despachar visitas'),
  ('visits.execute',           'field_execution', 'Executar visitas no app do técnico'),
  ('time_entries.approve',     'field_execution', 'Aprovar apontamentos'),
  ('customers.manage',         'customers',       'Manter clientes, unidades e contatos'),
  ('catalog.manage',           'catalog',         'Manter produtos, serviços, sintomas, causas, soluções e checklists'),
  ('assets.manage',            'assets',          'Manter ativos e alocações'),
  ('qr_tags.manage',           'assets',          'Gerar, imprimir, vincular e revogar etiquetas'),
  ('qr_tags.unbind',           'assets',          'Desfazer vínculo de etiqueta (exceção auditada)'),
  ('scheduling.manage',        'scheduling',      'Manter técnicos, equipes, regiões, turnos, escalas e calendários'),
  ('integrations.manage',      'integrations',    'Configurar conexões e mapeamentos'),
  ('integrations.monitor',     'integrations',    'Monitor de integrações e reprocessamento'),
  ('imports.run',              'integrations',    'Importar planilhas'),
  ('reports.read',             'reporting',       'Relatórios e painéis'),
  ('settings.manage',          'tenancy',         'Configurações do tenant'),
  ('users.manage',             'identity_access', 'Convidar usuários e atribuir papéis'),
  ('audit.read',               'audit',           'Consultar auditoria'),
  ('customer_portal.request',  'work_orders',     'Abrir chamado pelo app do cliente'),
  ('customer_portal.contacts', 'customers',       'Gerenciar contatos do próprio cliente'),
  ('platform.tenants',         'tenancy',         'Administrar tenants e planos'),
  -- v0.2
  ('work_orders.resolve_remotely', 'work_orders',   'Resolver chamado por orientação remota, sem visita'),
  ('work_orders.acknowledge',  'work_orders',     'Assumir OS (para o escalonamento)'),
  ('asset_movements.approve',  'assets',          'Aprovar ou rejeitar movimentação de ativo'),
  ('service_providers.manage', 'scheduling',      'Manter prestadores, tarifas e técnicos terceirizados'),
  ('on_call.manage',           'scheduling',      'Manter plantão e políticas de escalonamento'),
  ('work_order_costs.review',  'field_execution', 'Lançar e conferir custos da OS'),
  ('provider_settlements.manage', 'field_execution', 'Montar, aprovar e enviar fechamentos de prestadores (F2)'),
  ('maintenance_plans.manage', 'maintenance',     'Manter planos de manutenção e medidores (F2)'),
  ('telemetry.manage',         'telemetry',       'Manter dispositivos IoT e regras de alerta (F3)');

INSERT INTO app.role_permissions (role_id, permission_id)
SELECT r.id, p.id
  FROM (VALUES
    ('platform_admin',   ARRAY['platform.tenants', 'audit.read']),
    ('tenant_admin',     ARRAY['work_orders.read', 'work_orders.create', 'work_orders.update', 'work_orders.triage', 'work_orders.close',
                               'work_orders.reopen', 'visits.schedule', 'time_entries.approve', 'customers.manage', 'catalog.manage',
                               'assets.manage', 'qr_tags.manage', 'qr_tags.unbind', 'scheduling.manage', 'integrations.manage',
                               'integrations.monitor', 'imports.run', 'reports.read', 'settings.manage', 'users.manage', 'audit.read']),
    ('dispatcher',       ARRAY['work_orders.read', 'work_orders.create', 'work_orders.update', 'work_orders.triage', 'work_orders.close',
                               'work_orders.reopen', 'visits.schedule', 'time_entries.approve', 'customers.manage', 'assets.manage',
                               'qr_tags.manage', 'integrations.monitor', 'reports.read']),
    ('backoffice_agent', ARRAY['work_orders.read', 'work_orders.create', 'work_orders.update', 'customers.manage', 'assets.manage',
                               'qr_tags.manage', 'imports.run']),
    ('manager',          ARRAY['work_orders.read', 'reports.read', 'integrations.monitor', 'audit.read']),
    ('technician',       ARRAY['visits.execute', 'work_orders.read']),
    ('customer_contact', ARRAY['customer_portal.request']),
    ('customer_admin',   ARRAY['customer_portal.request', 'customer_portal.contacts']),
    -- v0.2: permissões novas dos papéis existentes e dos papéis novos (escopo de
    -- carteira/prestador aplicado pela API, não pela RLS).
    ('tenant_admin',     ARRAY['work_orders.resolve_remotely', 'work_orders.acknowledge', 'asset_movements.approve',
                               'service_providers.manage', 'on_call.manage', 'work_order_costs.review',
                               'provider_settlements.manage', 'maintenance_plans.manage', 'telemetry.manage']),
    ('dispatcher',       ARRAY['work_orders.resolve_remotely', 'work_orders.acknowledge', 'work_order_costs.review']),
    ('technician',       ARRAY['work_orders.acknowledge']),
    ('sales_rep',        ARRAY['work_orders.read', 'work_orders.create', 'work_orders.triage', 'work_orders.resolve_remotely',
                               'work_orders.acknowledge', 'reports.read']),
    ('provider_admin',   ARRAY['work_orders.read', 'work_orders.acknowledge', 'visits.schedule', 'reports.read'])
  ) AS m(role_code, perms)
  JOIN app.roles r ON r.code = m.role_code
  CROSS JOIN LATERAL unnest(m.perms) AS pc(code)
  JOIN app.permissions p ON p.code = pc.code;

INSERT INTO app.plans (code, name, limits, features) VALUES
  ('starter',      'Starter',      '{"max_assets": 2000,  "max_technicians": 10,  "max_backoffice_users": 5}',  '{"erp_integration": false}'),
  ('professional', 'Professional', '{"max_assets": 20000, "max_technicians": 200, "max_backoffice_users": 50}', '{"erp_integration": true}'),
  ('enterprise',   'Enterprise',   '{}', '{"erp_integration": true, "dedicated_database": true}');

RESET ROLE;
COMMIT;
-- Fim de db/schema.sql

-- migrate:down
-- Sem "down": em homologação e produção só se migra para frente
-- (docs/02 §4.2.2). Em desenvolvimento, recrie o banco: infra/local/README.md.
SELECT 1;
