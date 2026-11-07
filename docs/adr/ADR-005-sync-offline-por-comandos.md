# ADR-005 — App do técnico offline-first com sincronização por comandos (pull/push)

- **Status:** Proposto — 27/10/2026 (validar na POC P3 da fase 0). Em 02/11/2026 o banco local passou a ser **Drift + SQLCipher** em Flutter e ficou decidido o endpoint direto, sem broker ([ADR-018](ADR-018-sync-endpoint-direto-e-drift.md)); o protocolo continua o mesmo
- **Relacionados:** [Aplicações e fluxos](../06-aplicacoes-e-fluxos.md) (protocolo detalhado), [API](../08-api.md), [Modelo de domínio](../03-modelo-de-dominio.md)

## Contexto

- Técnicos trabalham em locais com sinal ruim (cozinhas, câmaras frias, subsolos, zona rural) e não podem parar por falta de conexão.
- Apontamentos de horas, itens, fotos e assinaturas precisam ser registrados na hora, com o horário real.
- O backoffice pode mudar a OS enquanto o técnico está offline: cancelar, reatribuir, alterar itens.
- As regras de negócio e o isolamento entre tenants precisam continuar valendo no servidor.

## Decisão

1. **Banco local SQLite** no app: desde a v0.3, **Drift + SQLCipher** em Flutter (criptografia em repouso, migrações versionadas com o app, consultas reativas), com um motor de sync próprio (pacote Dart `sync_engine`) e a fila local `pending_mutations`. Um banco por tenant no aparelho. Detalhes em [Aplicações e fluxos](../06-aplicacoes-e-fluxos.md) e no [ADR-018](ADR-018-sync-endpoint-direto-e-drift.md). (Na v0.2 era expo-sqlite + Drizzle.)
2. **Pull:** `POST /api/v1/technician/sync/pull` com cursor opaco baseado em `row_version` (sequence global atualizada por trigger), paginado e restrito ao escopo do técnico (visitas atribuídas e dados relacionados). O trigger grava também `sync_xid` (xid8), e o pull só devolve linhas de transações já visíveis a todos, para não perder escritas de transações longas. Saídas de escopo são calculadas contra o snapshot do aparelho (`device_sync_scopes`); exclusões reais chegam como tombstones (`sync_tombstones`).
3. **Push:** `POST /api/v1/technician/sync/push` com uma lista de **comandos de negócio** (`visit.start_travel`, `visit.check_in`, `time_entry.create`, `work_order_item.add`, `visit.finish` etc.), cada um com `mutation_id` (idempotência) e `client_timestamp`. O servidor valida cada comando como se fosse uma chamada online e responde por mutação: `applied`, `duplicate`, `rejected` ou `conflict` (com o estado atual do servidor). A idempotência fica registrada em `sync_mutations`. Fatos de campo que chegam para uma OS cancelada ou encerrada, ou para uma visita reatribuída, não se perdem: viram **registros a revisar** (`sync_review_items`), que o backoffice aceita ou descarta.
4. **IDs UUID v7 gerados no aparelho:** o técnico cria itens e apontamentos offline sem colisão.
5. **Anexos fora do sync de dados:** fila de upload em background para URLs pré-assinadas, com retomada; o comando `attachment.register` liga o arquivo à OS.

## Consequências

**Positivas**
- O servidor continua sendo a autoridade: regras, RBAC, RLS e auditoria valem para o que veio offline.
- A intenção do usuário é preservada ("iniciou deslocamento às 8h02"), o que facilita resolver conflitos e auditar.
- Nenhuma réplica de banco exposta ao dispositivo.

**Negativas / cuidados**
- Mais código do que uma solução de replicação pronta: catálogo de mutações, handlers, testes de conflito.
- O relógio do aparelho pode estar errado: o servidor guarda `client_timestamp` e o horário de recebimento, e aplica limites de plausibilidade.

## Alternativas consideradas

| Alternativa | Por que não (por enquanto) |
|---|---|
| Replicação de banco pronta (PowerSync, ElectricSQL) | Acelera a leitura offline, mas adiciona infraestrutura/fornecedor e dificulta validar regras de negócio na escrita. Pode ser reavaliada para o caminho de leitura |
| Sync genérico de linhas (upsert por tabela) | Perde a intenção, gera conflitos difíceis e pula regras de negócio |
| App só online | Inviável em campo |
