# ADR-010 — Acesso a dados SQL-first: Kysely, migrações dbmate e `schema.sql` como referência

- **Status:** Substituído pelo [ADR-019](ADR-019-dados-com-serverpod.md) em 02/11/2026. O princípio SQL-first e as checagens no CI continuam; Kysely dá lugar ao ORM do Serverpod sobre tabelas não gerenciadas
- **Relacionados:** [Arquitetura de solução](../02-arquitetura-de-solucao.md), [schema.sql](../../db/schema.sql), [ADR-002](ADR-002-multi-tenancy-rls.md)

## Contexto

- O isolamento entre tenants depende de recursos do PostgreSQL que ORMs tratam mal ou escondem: RLS com FORCE, FKs compostas com `tenant_id`, triggers de `row_version`/`sync_xid`, funções SECURITY DEFINER, constraints adiadas e de exclusão.
- O contexto do tenant precisa ser aplicado de forma explícita e auditável em cada transação (`SET LOCAL app.tenant_id`).
- A fila de jobs (pg-boss) precisa enfileirar na mesma transação do caso de uso.

## Decisão

1. **Kysely + `pg`** como camada de acesso no backend, com tipos gerados do banco real (`kysely-codegen`) a partir de um banco efêmero com todas as migrações aplicadas.
2. **SQL como única fonte da verdade:** `db/schema.sql` é a referência; as migrações são arquivos SQL do **dbmate** (`-- migrate:up` / `-- migrate:down`), com lint do **squawk** para operações perigosas. Em produção só se migra para frente, com expand/contract.
3. **O CI prova o schema:** aplica as migrações do zero, compara com o `schema.sql` e roda as checagens estruturais (toda tabela de tenant com RLS ENABLE+FORCE e política, nenhuma FK entre tenants sem `tenant_id`, funções SECURITY DEFINER com `search_path` fixo) e os testes de isolamento.
4. **Transação por caso de uso** com `nestjs-cls` + `@nestjs-cls/transactional`: o primeiro comando é sempre `set_config('app.tenant_id', ..., true)`.

## Consequências

**Positivas**
- Nenhuma divergência entre "o schema do ORM" e o banco real; RLS, triggers e funções ficam visíveis e revisáveis.
- Já validado na consolidação: o `schema.sql` executa num PostgreSQL 18 (PGlite) com 0 problemas de RLS, 0 FKs entre tenants sem `tenant_id` e testes funcionais de isolamento passando.

**Negativas / cuidados**
- O time precisa saber SQL de verdade; a curva é maior que a de um ORM com "mágica".
- Os tipos dependem do passo de geração: o CI falha se o código não for regenerado.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Prisma | Segunda fonte de verdade (`schema.prisma`); RLS por extensão do client, fácil de esquecer numa consulta |
| Drizzle (no backend) | Viável e segunda opção; mantém um schema em TypeScript paralelo ao SQL. É usado no app do técnico, onde o banco local é simples |
| MikroORM / TypeORM | Unit of work e identity map complicam o controle explícito da transação, que é onde o tenant é aplicado |
