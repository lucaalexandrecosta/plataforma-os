# ADR-008 — Integração com ERPs: porta `ErpConnector`, adaptadores, outbox e jobs idempotentes

- **Status:** Proposto — 27/10/2026 (validar com a Senior na POC P4)
- **Relacionados:** [Integração com o ERP Senior](../07-integracao-erp-senior.md), [API](../08-api.md), [Modelo de domínio](../03-modelo-de-dominio.md)

## Contexto

- O primeiro tenant usa o ERP X da Senior. Os próximos podem usar outro ERP (inclusive o ERP Senior "clássico") ou nenhum.
- Clientes, produtos e serviços passarão a vir do ERP; o pedido de serviço sai da plataforma quando a OS é encerrada.
- O ERP pode estar fora do ar ou lento, e um pedido não pode ser criado duas vezes.

## Decisão

1. **Porta `ErpConnector`** (arquitetura hexagonal) com flags de capacidade: ler clientes, produtos e serviços com delta; criar pedido; consultar pedido; healthcheck.
2. **Adaptadores:** `SeniorErpXConnector` primeiro. Previstos: `SeniorG5SoapConnector`, um conector genérico REST/webhook e o modo "sem ERP" (cadastro local + importação por planilha).
3. **Dados mestres com origem explícita:** `source` (`local` ou `erp`), `external_system`, `external_id`, `external_payload`, `last_synced_at`. Campos mestres vindos do ERP são somente leitura na UI; extensões locais são permitidas.
4. **Saída assíncrona e confiável:** o encerramento grava `work_order.closed` no outbox, na mesma transação. O worker cria um `integration_job` idempotente (chave = id da OS; consulta antes de criar), com retry exponencial, separação entre falha transitória e permanente, e reprocessamento manual no Monitor de Integrações.
5. **Credenciais do ERP por tenant em cofre de segredos.** O banco guarda só a referência.

## Consequências

**Positivas**
- O produto não depende de um ERP específico, o que é essencial para vendê-lo como SaaS.
- O técnico e o backoffice não esperam o ERP; quedas viram fila, não erro na tela.
- Toda tentativa fica rastreável e reprocessável.

**Negativas / cuidados**
- Consistência eventual: o número do pedido aparece na OS alguns segundos ou minutos depois.
- Cada conector exige telas de configuração e mapeamento, e testes de contrato próprios.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Chamada síncrona ao ERP no encerramento | Frágil; trava o usuário quando o ERP cai; risco de pedido duplicado em retry manual |
| iPaaS/ESB de terceiros | Mais um fornecedor e custo; pode virar um adaptador no futuro |
| Só carga em lote (ETL noturno) | Sem tempo quase real para o pedido; dados mestres desatualizados durante o dia |
