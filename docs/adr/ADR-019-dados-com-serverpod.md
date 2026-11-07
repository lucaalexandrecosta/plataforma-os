# ADR-019 — Dados com Serverpod: tabelas não gerenciadas (SQL-first), tenant pelo interceptor e dinheiro em inteiros

- **Status:** Proposto — 02/11/2026 (validar nos spikes S1 e S2)
- **Substitui:** [ADR-010](ADR-010-acesso-a-dados-sql-first.md) (o princípio SQL-first continua; muda a camada de acesso)
- **Relacionados:** [Stack Dart](../12-stack-dart-flutter-serverpod.md), seção 4; [ADR-002](ADR-002-multi-tenancy-rls.md)

## Contexto

- O isolamento entre tenants depende de RLS FORCE, FKs compostas, CHECKs, triggers e funções SECURITY DEFINER, que as migrações geradas pelo Serverpod não expressam.
- O ORM do Serverpod não tem tipo decimal e grava `DateTime` como timestamp sem fuso.
- O Serverpod 4 tem `databaseInterceptor`, ponto único por onde passa todo acesso ao banco da sessão, inclusive SQL próprio e transações.

## Decisão

1. **SQL-first continua:** `db/schema.sql` + migrações dbmate são a fonte da verdade. As tabelas de negócio são declaradas nos modelos do Serverpod com `managedMigration: false` (ORM e classes geradas, sem DDL do Serverpod). O CI confere modelos × banco e roda as checagens estruturais e os testes de isolamento.
2. **Tenant pelo interceptor:** o `databaseInterceptor` garante que toda operação rode em transação iniciada por `set_config('app.tenant_id', ..., true)`. O RLS FORCE continua como segunda barreira.
3. **Tipos compatíveis com o ORM:**
   - dinheiro em **centavos** e quantidades em **milésimos**, como `bigint` (Dart `int`);
   - datas em `timestamptz`, com o papel da aplicação em `timezone = 'UTC'`;
   - `search_path = app, public`;
   - `jsonb` validado no spike S2 (se não mapear, SQL próprio nessas colunas).
4. **SQL próprio parametrizado** (`unsafeQuery`/`unsafeExecute`) para relatórios e consultas complexas, sempre pelo mesmo interceptor.

## Consequências

**Positivas**
- O banco mantém todas as garantias já validadas (isolamento, invariantes), e o time ganha ORM e classes geradas.
- Dinheiro em inteiros elimina erro de arredondamento ponta a ponta.

**Negativas / cuidados**
- Converter decimal ↔ centavos nas bordas (ERP, planilhas, relatórios, telas).
- Manter os modelos `.spy.yaml` alinhados ao SQL: o CI precisa falhar se divergirem.
- A API do interceptor pode mudar em versão *minor*: versão fixada e testes a cada atualização.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Migrações gerenciadas pelo Serverpod | Perderiam RLS, FKs compostas, CHECKs e triggers, ou exigiriam remendos frágeis |
| Dinheiro como `double` | Impreciso para valores monetários |
| Sem ORM (só SQL próprio) | Perde as classes geradas e o cliente tipado, principal ganho do Serverpod |
| Drift no servidor (drift_postgres) | Segunda camada de banco paralela ao Serverpod, com outro pool e outras transações |
