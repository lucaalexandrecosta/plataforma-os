# ADR-015 — Manutenção planejada por planos (calendário ou medidor) e medidores com origem manual ou IoT

- **Status:** Proposto — 02/11/2026 (fase 2)
- **Relacionados:** [Benchmark Sismetro](../11-benchmark-sismetro-e-novas-funcionalidades.md) (seção 4.7), [ADR-016](ADR-016-telemetria-generica.md), [Modelo de domínio](../03-modelo-de-dominio.md)

## Contexto

- Preventivas em fornos, estufas e freezers (limpeza de condensador, vedação, gás) reduzem quebras e custo de corretiva.
- O intervalo ideal varia: alguns itens são por calendário, outros pelo uso real (horas de compressor ou de forno).
- O uso pode ser lido pelo técnico na visita (horímetro do equipamento) ou chegar por telemetria (fase 3).

## Decisão

1. **`maintenance_plans`** com gatilho `interval_days`, `monthly_day` ou `meter`, mais tipo de OS, checklist, antecedência e tolerância. O plano se aplica a um modelo de produto (todos os ativos daquele modelo) ou a ativos específicos, por meio de `maintenance_plan_assets`, que guarda a próxima data ou leitura prevista e a última OS gerada.
2. **Geração automática idempotente:** um job diário, mais a reação a cada nova leitura, cria OS com `origin = preventive_plan`, agrupando por cliente/unidade para uma visita atender vários ativos. A previsão aparece na agenda.
3. **Medidores independentes da fonte:** `asset_meters` (`hour_meter`, `energy_kwh`, `temperature`, `cycles`) e `meter_readings` com origem `manual` (item de checklist `meter_reading`, mutação `meter_reading.record`), `iot` ou `file_import`, idempotentes por medidor, horário e origem.

## Consequências

**Positivas**
- A fase 2 já entrega preventiva por uso com leitura manual. Quando a telemetria chegar, os planos passam a usar leituras automáticas sem mudar de modelo.
- Agrupar por unidade reduz deslocamento e custo de terceiros.

**Negativas / cuidados**
- Leitura manual depende de disciplina: o checklist exige o campo e uma faixa válida (leitura menor que a anterior pede justificativa).
- Planos por modelo geram muitas OS de uma vez: limitar a geração diária e espalhar pelo período de tolerância.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Só preventiva por calendário | Ignora o uso real; equipamento parado receberia visita sem necessidade |
| Esperar a telemetria para ter preventiva por uso | Adia valor; a leitura manual resolve boa parte |
| Agenda manual de preventivas | Não escala para milhares de ativos |
