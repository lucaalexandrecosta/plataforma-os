# ADR-011 — Fila de jobs no PostgreSQL (pg-boss), junto com o outbox

- **Status:** Substituído pelo [ADR-017](ADR-017-stack-dart-flutter-serverpod.md) em 02/11/2026. A fila continua no PostgreSQL e transacional, agora nas tabelas de jobs do próprio schema (`SKIP LOCKED`), com as future calls do Serverpod para os horários; o pg-boss é específico de Node
- **Relacionados:** [Arquitetura de solução](../02-arquitetura-de-solucao.md), [ADR-008](ADR-008-integracao-erp-conectores-outbox.md)

## Contexto

- Casos de uso disparam trabalho assíncrono: notificações (OTP, WhatsApp, push), fan-out de eventos do outbox, SLA, geração de etiquetas, importações e integrações com o ERP.
- Um job perdido ou duplicado tem custo real: OTP que não chega, pedido duplicado no ERP.
- Um tenant com uma importação grande não pode atrasar os OTPs dos outros ("vizinho barulhento").

## Decisão

1. **pg-boss 12** como fila de jobs, atrás de uma porta `JobQueue` em `platform/jobs`. Os documentos dizem apenas "fila de jobs".
2. **Enfileirar na mesma transação** do caso de uso (`send(..., { db: fromKysely(trx) })`): ou o dado e o job são gravados juntos, ou nenhum dos dois.
3. **Três filas por prioridade:** `critical` (OTP, push, WhatsApp), `default` (fan-out do outbox, SLA) e `heavy` (importações, exportações, etiquetas, sync com ERP), com `groupConcurrency` por `tenant_id` nas filas pesadas.
4. **O Valkey (Redis) fica 100% efêmero** (cache, rate limit, pub/sub de tempo real) e pode ser esvaziado sem perda.
5. O schema do pg-boss é criado e migrado pelo pipeline de migrações, nunca pelo papel de runtime, que não tem DDL.

## Consequências

**Positivas**
- Uma classe inteira de inconsistências some: não existe "gravou a OS mas não enfileirou a notificação".
- A durabilidade dos jobs é a do PostgreSQL (Multi-AZ, PITR), sem Redis persistente para operar.

**Negativas / cuidados**
- Vazão de centenas a poucos milhares de jobs/s: sobra para 10× a premissa, mas não é um broker de alto volume.
- **Quando revisitar:** vazão sustentada acima de ~500 jobs/s, workflows longos com compensação (avaliar Temporal) ou extração de serviços (broker gerenciado).

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| BullMQ (Redis) | Não é transacional com o banco; exige Redis persistente com `noeviction`, em conflito com o uso como cache; grupos por tenant só na edição paga |
| SQS e equivalentes | Prendem a nuvem (ADR-009) e não são transacionais com o banco |
| Temporal no MVP | Peso operacional desproporcional ao problema atual |
