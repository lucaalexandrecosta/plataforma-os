-- =============================================================================
-- Usuários de LOGIN do ambiente local e de CI (docs/09; db/schema.sql §23).
-- Em homologação e produção a infraestrutura cria os mesmos usuários com
-- senhas do cofre. Senha local de todos: "dev". Idempotente.
--
-- Ordem: este arquivo roda ANTES da migração inicial (init do container) e
-- também pode rodar depois; os papéis-grupo são criados aqui se ainda não
-- existirem (a migração usa IF NOT EXISTS).
-- =============================================================================
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_owner')   THEN CREATE ROLE app_owner NOLOGIN; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_runtime') THEN CREATE ROLE app_runtime NOLOGIN NOBYPASSRLS; END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_system')  THEN CREATE ROLE app_system NOLOGIN NOBYPASSRLS; END IF;

  -- api e worker: só DML, sujeitos a RLS.
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_api') THEN
    CREATE ROLE app_api LOGIN PASSWORD 'dev' NOBYPASSRLS IN ROLE app_runtime;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_worker') THEN
    CREATE ROLE app_worker LOGIN PASSWORD 'dev' NOBYPASSRLS IN ROLE app_runtime;
  END IF;
  -- Migrações de dados/DDL do schema "app" (dbmate em homologação/produção).
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_migrator') THEN
    CREATE ROLE app_migrator LOGIN PASSWORD 'dev' IN ROLE app_owner;
  END IF;
  -- Migrações das tabelas internas do Serverpod (schema "public").
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_pod_migrator') THEN
    CREATE ROLE app_pod_migrator LOGIN PASSWORD 'dev';
  END IF;
END
$$;

ALTER ROLE app_api          SET timezone = 'UTC';
ALTER ROLE app_api          SET search_path = app, public;
ALTER ROLE app_worker       SET timezone = 'UTC';
ALTER ROLE app_worker       SET search_path = app, public;
ALTER ROLE app_migrator     SET timezone = 'UTC';
ALTER ROLE app_migrator     SET search_path = app, public;
ALTER ROLE app_pod_migrator SET timezone = 'UTC';
ALTER ROLE app_pod_migrator SET search_path = public;

-- Limites da api (docs/02 §5.2).
ALTER ROLE app_api SET statement_timeout = '5s';
ALTER ROLE app_api SET idle_in_transaction_session_timeout = '10s';

-- Tabelas serverpod_* (public): criadas por app_pod_migrator; api e worker
-- recebem só DML nelas.
GRANT USAGE, CREATE ON SCHEMA public TO app_pod_migrator;
ALTER DEFAULT PRIVILEGES FOR ROLE app_pod_migrator IN SCHEMA public
  GRANT SELECT, INSERT, UPDATE, DELETE ON TABLES TO app_runtime;
ALTER DEFAULT PRIVILEGES FOR ROLE app_pod_migrator IN SCHEMA public
  GRANT USAGE, SELECT ON SEQUENCES TO app_runtime;
