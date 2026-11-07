# ADR-002 — Multi-tenancy: banco compartilhado, `tenant_id`, RLS com FORCE e FKs compostas

- **Status:** Proposto — 27/10/2026
- **Relacionados:** [Multi-tenancy e segurança](../04-multi-tenancy-e-seguranca.md), [Modelo de domínio](../03-modelo-de-dominio.md), [schema.sql](../../db/schema.sql)

## Contexto

- O produto será vendido a várias empresas. O custo por tenant precisa ser baixo e o onboarding, rápido.
- Vazamento de dados entre tenants é o pior incidente possível: LGPD, contrato e reputação.
- Escala do primeiro ano: até ~50 tenants, com volume por tenant moderado.

## Decisão

1. **Modelo pool:** um banco e um schema para todos os tenants. Toda tabela de dados de tenant tem `tenant_id NOT NULL`.
2. **Row-Level Security como segunda barreira:** `ENABLE` + `FORCE ROW LEVEL SECURITY` e política por `tenant_id = current_setting('app.tenant_id')` em todas as tabelas de tenant. A aplicação faz `SET LOCAL app.tenant_id` no início de cada transação, o que é compatível com pool em modo transação. O papel de banco da aplicação (`app_runtime`) não é dono das tabelas e não tem `BYPASSRLS`.
3. **FKs compostas:** toda referência entre tabelas de tenant usa `(tenant_id, x_id)` apontando para `UNIQUE (tenant_id, id)`. Assim, uma linha de um tenant não consegue apontar para uma linha de outro, nem por bug.
4. **Isolamento fora do banco também:** chaves de object storage com prefixo do tenant, chaves de cache com o tenant, jobs com `tenant_id` no payload (o worker restaura o contexto), logs e traces com `tenant_id`.
5. **Testes que provam o isolamento** rodam no CI contra PostgreSQL real.
6. **Caminho para "silo":** um tenant grande pode ir para um banco dedicado. Um catálogo de tenants roteia a conexão, sem mudar o código de domínio.

## Consequências

**Positivas**
- Uma migração por release, não uma por tenant. Custo marginal de um tenant novo perto de zero.
- Um esquecimento de filtro na aplicação não vaza dados: o banco bloqueia.

**Negativas / cuidados**
- Risco de vizinho barulhento: exige limites por tenant (rate limit, filas justas) e monitoramento.
- Índices devem começar por `tenant_id`; consultas sem contexto de tenant retornam vazio (falha segura, mas pode confundir em jobs mal configurados).
- Restaurar um único tenant exige exportação lógica filtrada, não o restore do banco inteiro.
- Tarefas de plataforma que cruzam tenants (relatórios do SaaS, manutenção) usam um papel privilegiado separado, com auditoria.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Schema por tenant | Migrações × N, catálogo do PostgreSQL inchado, pool de conexões difícil; o isolamento não é muito melhor que RLS bem feito |
| Banco por tenant (para todos) | Custo e operação altos para tenants pequenos; fica como opção "silo" para grandes |
| Só filtro na aplicação, sem RLS | Um bug de query vira vazamento; não há defesa em profundidade |
