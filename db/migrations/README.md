# Migrações (dbmate)

- `20261107000000_initial_schema.sql` é **gerada** a partir de [db/schema.sql](../schema.sql) por `node tool/db/build_initial_migration.mjs`. O CI confere que ela está em dia (`--check`).
- Enquanto nada tiver ido para homologação, mudanças no schema entram editando o `schema.sql` e regerando a migração inicial.
- **Depois da primeira implantação em homologação**, a migração inicial fica congelada: toda mudança vira um arquivo novo `<timestamp>_<descricao>.sql` (com `-- migrate:up` e `-- migrate:down`), o `schema.sql` é atualizado no mesmo PR, e a conferência do CI passa a comparar o schema resultante das migrações com o `schema.sql` (docs/02 §4.2.2). Nesse momento, remova o passo `--check` de `tool/db/validate_all.mjs`.
- Rode o dbmate **sempre** com `--migrations-table public.schema_migrations`. O `schema.sql` executa `SET search_path = app, …` e o dbmate resolve o nome da tabela de controle pelo schema corrente: sem o schema explícito, a migração é aplicada mas não fica registrada, e a próxima execução tenta aplicá-la de novo.
- As tabelas internas do Serverpod (`serverpod_*`) não ficam aqui: estão em `server/migrations`, aplicadas pelo próprio Serverpod com o papel `app_pod_migrator`.
