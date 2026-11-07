# ADR-014 — Triagem configurável (central, vendedor ou direta), resolução remota e plantão com escalonamento

- **Status:** Proposto — 02/11/2026
- **Relacionados:** [Benchmark Sismetro](../11-benchmark-sismetro-e-novas-funcionalidades.md) (seções 4.2 e 4.4), [ADR-007](ADR-007-os-unica-com-visitas.md), [Aplicações e fluxos](../06-aplicacoes-e-fluxos.md)

## Contexto

- Hoje o cliente final liga para o vendedor ou o gerente, que filtra e muitas vezes resolve por telefone. A empresa ainda não decidiu se mantém esse filtro ou se centraliza.
- Outros tenants podem querer o oposto: chamado direto ao técnico da região, sem triagem.
- Os chamados precisam ser atendidos no mesmo dia, inclusive em fins de semana e feriados. Um e-mail para a caixa de alguém não garante isso.

## Decisão

1. **Modo de triagem por tenant** (`tenant_settings.triage_mode`):
   - `central`: tudo cai na fila do despacho;
   - `sales_rep_first`: chamados de clientes com vendedor passam primeiro por ele, com prazo, e sobem para a central se o prazo vencer;
   - `direct`: clientes ou tipos marcados vão direto ao técnico ou prestador da região.
2. **Resolução remota como desfecho de primeira classe:** a OS pode ir de `requested`/`open` para `completed` com `resolution_mode = remote`, sem visita e com descrição obrigatória. Ela conta nos indicadores e não gera custo de campo.
3. **Plantão e escalonamento:**
   - `on_call_assignments` define quem responde fora do horário;
   - `escalation_policies` define os passos (espera em minutos, quem avisar, canais push/WhatsApp/SMS);
   - a OS registra o aceite (`acknowledged_at`/`acknowledged_by`) e o nível de escalonamento;
   - um job a cada minuto sobe o nível até alguém assumir.
4. **Despacho no celular:** aba "Despacho" no app do técnico para quem tem papel `dispatcher` (online), recebendo push de OS nova e de escalonamento.

## Consequências

**Positivas**
- A plataforma se adapta ao processo de cada tenant sem código específico.
- "Mesmo dia" vira regra verificável: aceite, tempo até o aceite e escalonamentos ficam medidos.
- A resolução remota fica visível e evita visitas que hoje viram custo.

**Negativas / cuidados**
- O escalonamento por WhatsApp/SMS tem custo por mensagem: limitar os passos e preferir push.
- O vendedor como filtro pode atrasar o atendimento, daí o prazo com subida automática.
- A transição direta para `completed` amplia a máquina de estados do ADR-007. É uma extensão compatível.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Triagem fixa na central | Não atende quem quer manter o vendedor como filtro, nem quem quer despacho direto |
| Resolução remota como cancelamento | Perde a informação: um atendimento resolvido não é um chamado cancelado |
| Alerta só por e-mail | Não garante resposta em fim de semana; sem aceite, não há como medir nem escalar |
