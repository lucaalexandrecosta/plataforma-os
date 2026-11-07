# ADR-007 — Ordem de serviço única, nascendo como "Solicitada", com várias visitas

- **Status:** Proposto — 27/10/2026
- **Relacionados:** [Modelo de domínio](../03-modelo-de-dominio.md), [Aplicações e fluxos](../06-aplicacoes-e-fluxos.md)

## Contexto

- Na linguagem do usuário, o cliente "aciona uma ordem de serviço" e ela "cai para a empresa", que faz a triagem e direciona o atendimento.
- Retornos são comuns em reparo de refrigeração: diagnóstico na primeira visita e troca da peça em outra.
- Também existem OS que não nascem de chamado: instalação, retirada, preventiva, OS aberta pelo atendente por telefone.
- O pedido no ERP (fase 2) é uma consequência do encerramento, não um passo operacional.

## Decisão

1. **Uma entidade `work_order`** do primeiro contato ao encerramento. Chamados do cliente nascem com status `requested` e passam por triagem: viram `open` ou `cancelled` (motivo "recusado na triagem" ou "duplicado").
2. **Status canônicos:** `requested → open → scheduled → in_progress ⇄ on_hold → completed → closed`, além de `cancelled`. A conferência do backoffice (`completed → closed`) é configurável por tenant; sem ela, o encerramento é automático.
3. **Várias visitas por OS** (`work_order_visits`), cada uma com status próprio (`scheduled → en_route → on_site ⇄ paused → finished`, além de `cancelled`) e resultado (`resolved`, `needs_return`, `customer_absent`, `not_executed`). `needs_return` leva a OS para `on_hold` até a próxima visita.
4. **Apontamentos e itens pertencem à OS**, referenciando a visita e o técnico.
5. **Integração separada do status operacional:** `erp_sync_status` e `erp_order_number` são campos próprios. Falha no ERP não "desencerra" a OS.

## Consequências

**Positivas**
- Um número só, do chamado ao pedido no ERP; o cliente acompanha sempre a mesma OS.
- Histórico completo de retornos no mesmo lugar, o que melhora o first-time fix e o MTBF.
- Modelo simples para o MVP.

**Negativas / cuidados**
- Chamados recusados consomem numeração (aceitável; a numeração não precisa ser sem lacunas).
- A UI precisa separar bem a fila de triagem (`requested`) das OS operacionais.
- Se surgir a necessidade de um chamado gerar várias OS (ex.: cinco equipamentos num único contato), dá para introduzir uma entidade "chamado" acima da OS sem quebrar o modelo.

## Alternativas consideradas

| Alternativa | Por que não (por enquanto) |
|---|---|
| Entidade "chamado" separada da OS (ticket → OS) | Mais flexível para 1:N, porém mais complexa para o MVP; fica como evolução |
| Uma visita por OS (retorno = nova OS) | Perde o histórico e distorce os indicadores |
| Status de integração dentro do status da OS | Mistura operação com faturamento; falha no ERP travaria o fluxo |
