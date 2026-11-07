# ADR-016 — Telemetria IoT genérica, sem dependência de fabricante

- **Status:** Proposto — 02/11/2026 (fase 3, com piloto)
- **Relacionados:** [Benchmark Sismetro](../11-benchmark-sismetro-e-novas-funcionalidades.md) (seção 5), [ADR-015](ADR-015-planos-de-manutencao-e-medidores.md), [ADR-009](ADR-009-nuvem-de-referencia-aws.md)

## Contexto

- Dispositivos como o Sismetro Kairós medem a corrente com sensor não invasivo, contam as horas ligado e estimam o consumo. Também guardam dados quando ficam sem internet.
- Para o comodato, isso vale por quatro motivos: preventiva pelo uso real, detecção de equipamento ocioso no cliente, anomalia antes da quebra (freezer funcionando sem parar) e consumo como argumento comercial.
- Não está confirmado que o fabricante exponha os dados para sistemas de terceiros. Para freezers, temperatura importa tanto quanto corrente.

## Decisão

1. **Módulo `telemetry` genérico:** `iot_devices` (dispositivo vinculado ao ativo, credencial por dispositivo no cofre), ingestão por HTTPS em `POST /api/v1/integrations/iot/readings`, leituras gravadas em `meter_readings` com origem `iot`, e `telemetry_alert_rules` que notificam ou abrem OS (`origin = telemetry`).
2. **Ingestão tolerante:** lotes atrasados com o horário do dispositivo e idempotência por dispositivo + horário, para equipamentos que passam horas sem conexão.
3. **Volume controlado:** dispositivos enviam agregados de 5 a 15 min; dados brutos por prazo curto, consolidação diária para o histórico e particionamento mensal (o RDS não oferece TimescaleDB).
4. **Hardware escolhido no piloto:** o Kairós, se o fabricante expuser os dados (API, webhook ou MQTT), ou hardware aberto equivalente com sensor de corrente e de temperatura. MQTT por broker só se o piloto exigir, mantendo a portabilidade do ADR-009.

## Consequências

**Positivas**
- O tenant escolhe o dispositivo; a plataforma não fica refém de um fabricante.
- As regras de alerta e os planos por medidor reaproveitam o mesmo modelo de leituras.

**Negativas / cuidados**
- O consumo calculado por corrente × tensão nominal é estimativa, não medição de energia ativa.
- O Wi-Fi do cliente é instável; pontos críticos podem precisar de conectividade celular.
- Leituras forjadas (dispositivo clonado): credencial por dispositivo, rotação, limites e checagem de plausibilidade.
- O custo do hardware por equipamento precisa se pagar; daí o piloto antes de escalar.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Integrar só com a nuvem de um fabricante | Dependência comercial e técnica; dados podem não estar disponíveis |
| Serviço IoT proprietário da nuvem | Contraria a portabilidade do ADR-009 |
| Banco de séries temporais separado desde o início | Mais um componente para operar; com agregação e particionamento, o PostgreSQL atende o piloto |
