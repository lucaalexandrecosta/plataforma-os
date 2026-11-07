# ADR-013 — Prestadores terceirizados como entidade, com custos conferidos e controles antifraude

- **Status:** Proposto — 02/11/2026
- **Relacionados:** [Benchmark Sismetro](../11-benchmark-sismetro-e-novas-funcionalidades.md) (seções 4.1 e 4.3), [Modelo de domínio](../03-modelo-de-dominio.md), [Multi-tenancy e segurança](../04-multi-tenancy-e-seguranca.md)

## Contexto

- A maior parte dos atendimentos do primeiro tenant é feita por técnicos terceirizados em três estados, coordenados hoje por grupos de WhatsApp, sem histórico nem relatório.
- Há abuso relatado: visitas desnecessárias (o técnico prefere ir para faturar) e conserto de equipamento que não é da empresa, cobrado dela.
- O custo do terceiro precisa entrar no custo da OS e, depois, no pagamento ao prestador.

## Decisão

1. **Prestador é entidade de primeira classe** (`service_providers`), com tabela de preços (`provider_rates`) e técnicos vinculados (`technicians.kind = contractor`, `service_provider_id`). Novo papel `provider_admin`, que redistribui as OS da sua empresa sem enxergar o resto do tenant.
2. **Custos da OS por linha** (`work_order_costs`). A taxa do prestador gera uma linha automática ao finalizar a visita, com status `pending_review`, que só vale após a conferência. O fechamento mensal (`provider_settlements`, F2) agrupa só linhas aprovadas.
3. **Controles antifraude no fluxo, não em relatório posterior:**
   - check-in pelo QR do ativo da OS, obrigatório por política;
   - OS só para ativo vinculado ao cliente (sem ativo, exige justificativa);
   - fotos obrigatórias por tipo de OS;
   - triagem com resolução remota antes do despacho;
   - sem custo automático para visita sem check-in válido ou fora do local;
   - indicadores e alertas de desvio por prestador e técnico.

## Consequências

**Positivas**
- O WhatsApp sai da coordenação e a empresa ganha histórico, custo real por cliente e ativo, e base para pagar o prestador.
- O incentivo para a visita desnecessária diminui: sem triagem, sem check-in no ativo certo e sem conferência, não há pagamento.

**Negativas / cuidados**
- Adoção por técnicos com pouca familiaridade digital: app muito simples, treinamento e atendimento por link sem instalar app (F2).
- QR obrigatório exige etiqueta legível em todos os equipamentos atendidos (mutirão do legado e reposição de etiquetas).
- O prestador acessa dados de clientes: contrato com cláusula de confidencialidade e LGPD, e o app mostra só o necessário.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Tratar terceirizados como técnicos comuns | Sem prestador, não há custo por empresa, fechamento nem distribuição pelo gestor do prestador |
| Só auditoria posterior (relatórios) | Detecta tarde; o pagamento indevido já aconteceu |
| Portal separado para prestadores | Mais um front-end; o mesmo app com escopo resolve |
