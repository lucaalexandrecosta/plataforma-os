# 11 — Benchmark Sismetro e novas funcionalidades

Versão 0.2 — 02/11/2026 — rascunho para revisão (referências de implementação atualizadas para a [stack Dart](12-stack-dart-flutter-serverpod.md) na v0.3)

Propósito: registrar o que a demonstração do Sismetro (gestão de manutenção) e o folheto do Sismetro Kairós (horímetro e consumo elétrico IoT) revelaram, decidir o que entra na plataforma e em que fase, e fixar os nomes canônicos das mudanças nos demais documentos.

---

## 1. Fontes e método

- **Reunião de demonstração do Sismetro para a Superpan** (~52 min), com o comercial do Sismetro, a consultoria de implantação do ERP Senior e as áreas de patrimônio, comercial e controladoria da Superpan. A transcrição é automática e tem trechos mal reconhecidos; usamos só o que ficou claro.
- **Folheto do Sismetro Kairós** (1 página): especificações do dispositivo.
- **Método:** cada funcionalidade foi comparada com a arquitetura v0.1 e classificada como *já temos*, *adotar*, *adaptar* ou *não adotar*, com fase.

## 2. O que a reunião revelou sobre a operação

| # | Constatação | Consequência no desenho |
|---|---|---|
| C1 | Os equipamentos em comodato nos clientes são fornos, estufas, armários e freezers, de valor alto. A consultoria do ERP quer cruzar o custo de cada cliente com as vendas a ele ("o cliente compra o que justifica o equipamento?") | Bens patrimoniais vindos do ERP (F2) e **rentabilidade do comodato** por cliente (F3) |
| C2 | O maior volume de atendimentos é de **técnicos terceirizados** no RS, PR e SC, coordenados hoje por grupos de WhatsApp, sem histórico nem relatório. Parte deles tem dificuldade até com o WhatsApp | **Prestadores de serviço** como entidade, custo do terceiro por OS, fechamento (F2), app muito simples e atendimento por link sem app (F2) |
| C3 | Há abuso: visitas desnecessárias (o técnico prefere ir para faturar) e conserto de equipamento que não é da empresa, cobrado dela | **Antifraude**: triagem antes do despacho, resolução remota, check-in pelo QR do ativo, fotos obrigatórias, custo só após conferência, indicadores por prestador |
| C4 | O chamado precisa ser atendido no mesmo dia, inclusive em fins de semana e feriados | **Plantão**, **escalonamento** até alguém assumir, **despacho pelo celular**, SLA 24×7 por cliente |
| C5 | Hoje o cliente liga para o vendedor ou gerente, que faz a triagem e muitas vezes resolve por telefone | Papel **vendedor** com carteira de clientes, abertura em nome do cliente, pré-triagem pelo vendedor (configurável), **resolução remota** registrada |
| C6 | O patrimônio nasce no ERP: a NF de entrada gera o bem, e a etiqueta QR é gerada depois da integração. O legado já nos clientes será catalogado aos poucos | **Ativos com origem no ERP** (F2); mutirão de etiquetagem pelo app do técnico (já previsto) |
| C7 | O contrato de comodato é emitido pelo ERP e precisa ficar anexado ao ativo. Toda movimentação gera uma declaração (de onde, para onde, quem aprovou) | **Documentos do ativo**, **termo de movimentação** em PDF e **aprovação** opcional da movimentação |
| C8 | Peças são requisitadas ao estoque do ERP, com aprovação lá, e a baixa fica vinculada à OS | **Requisição de materiais** ao ERP (F2) |
| C9 | Equipamentos recolhidos são desmontados e as peças reaproveitadas em outros (estoque de seminovos no ERP) | OS de **oficina** (recondicionamento e desmontagem), baixa com motivo; entrada das peças no ERP fica manual por enquanto (F3) |
| C10 | A empresa tem mais de um CNPJ | **Filiais** como entidade (MVP com uma filial padrão) |
| C11 | Não há processo de calibração | Calibração fica fora |

## 3. Matriz de funcionalidades

| Funcionalidade vista no Sismetro | Plataforma v0.1 | Decisão | Fase |
|---|---|---|---|
| Árvore de patrimônios (filial → solicitante → localização → patrimônio → filhos) | Tenant → cliente → unidade → ativo, sem filial nem pai/filho | **Adaptar:** filiais; `location_note` já existe; ativo pai/filho | MVP / F3 |
| QR code no ativo abrindo OS | Já temos, com mais segurança (token opaco, página web leve sem instalar, OTP, `qr_context`) | Manter | MVP |
| Integração de bens com o ERP Senior | Não previsto | **Adotar** | F2 |
| Integração de clientes com o ERP (rotina a cada 2 h) | Já temos (delta a cada 15 min ou 2×/dia) | Manter | F2 |
| Histórico de OS do ativo com filtros | Já temos | Manter | MVP |
| Movimentação com declaração impressa e aprovador | Histórico de alocação, sem aprovação nem termo | **Adotar** | MVP |
| Documentos do ativo (contrato, NF, manuais) | Anexos genéricos | **Adaptar:** categorias de documento no ativo e no modelo; manuais offline no app | MVP / F2 |
| Planos de manutenção (a cada N dias, dia fixo do mês, por medidor) com OS automática e checklist | Só a categoria "preventiva" | **Adotar** | F2 |
| Checklist com itens obrigatórios que bloqueiam o encerramento | Já temos | Manter; novo tipo de item "leitura de medidor" | MVP / F2 |
| Especificações técnicas e componentes | Atributos do produto | **Adaptar:** componentes como ativos filhos | F3 |
| Calibração | — | Não adotar agora | — |
| Garantia visível na abertura da OS | Já temos (selo e sugestão de `billing_type`) | Manter; acrescentar dados de aquisição | MVP |
| Rastreabilidade de quem fez o quê | Já temos (`audit_logs`) | Manter | MVP |
| Aviso de nova OS por e-mail e push | Já temos, sem plantão nem escalonamento | **Adotar** plantão e escalonamento | MVP |
| Gestor abrindo OS e atribuindo técnico pelo celular | Só pelo backoffice web | **Adotar:** modo despacho no app do técnico | MVP |
| Relatório PDF da OS com logo, fotos, checklist e assinatura | Já temos | Manter; envio automático ao cliente no encerramento | MVP |
| Requisição de estoque ao ERP com aprovação e baixa na OS | Estoque do técnico (F3) | **Adotar** | F2 |
| Técnicos terceirizados e custo do terceiro na OS | Técnico só como colaborador | **Adotar** prestadores e custos; fechamento | MVP / F2 |
| Agenda com previsão das preventivas | Agenda de visitas | **Adotar** a previsão dos planos | F2 |
| Relatórios de custo, MTBF, MTTR, horas (HH) e backlog | Indicadores sem custo | **Adotar** custos | MVP (básico) / F2 |
| Analytics em tempo real, montagem de gráficos, TV na sala de operação | Painel em tempo real (streaming do Serverpod) | **Adotar** modo TV (F2); painéis personalizáveis (F3) | F2 / F3 |
| Kanban por status | Já temos | Manter | MVP |
| App offline com fotos, vídeos, arquivos, checklist, horas e assinatura | Já temos | Manter | MVP |
| Licença por usuário técnico, com usuários de cliente gratuitos | Planos a definir | Considerar no modelo comercial | Comercial |
| Horímetro e consumo elétrico IoT (Kairós) | — | **Adotar** telemetria genérica, começando pela leitura manual de horímetro | F2 / F3 |

## 4. Funcionalidades adotadas

### 4.1 Prestadores de serviço terceirizados — MVP (fechamento na F2)

- **Cadastro:** `service_providers` (razão social, CNPJ, contato, regiões atendidas, status, vigência do contrato) e `provider_rates` (taxa por visita, por hora, por km ou valor fixo por serviço, com vigência).
- **Técnicos:** `technicians.kind` (`employee` ou `contractor`) e `technicians.service_provider_id`. Os técnicos do prestador usam o mesmo app. Um técnico pode atender mais de um tenant (já previsto).
- **Gestor do prestador:** novo papel `provider_admin`. Vê e redistribui as OS atribuídas à sua empresa e acompanha os próprios técnicos, sem acesso ao resto do tenant.
- **Despacho:** a visita é atribuída a um técnico (próprio ou terceirizado) ou ao prestador, que escolhe o técnico.
- **Custos da OS:** `work_order_costs`, com linhas `parts`, `own_labor`, `third_party_labor`, `travel` e `other`. A taxa do prestador gera uma linha automática ao finalizar a visita, com status `pending_review`. Ela só vale depois da conferência no backoffice.
- **F2 — fechamento:** `provider_settlements` agrupa as linhas conferidas de um período por prestador (`draft → approved → sent_to_erp`), com demonstrativo para o prestador e envio ao ERP como conta a pagar ou nota de serviço tomado (a validar com a Senior).
- **F2 — atendimento por link:** prestador sem o app recebe a OS por WhatsApp com um link de uso único para um fluxo web (online), com check-in pelo QR, fotos, checklist e assinatura.

### 4.2 Vendedores e triagem pela carteira — MVP

- **Cadastro:** `sales_reps` (nome, contato, `user_id` opcional, código do representante no ERP) e `customers.primary_sales_rep_id`.
- **Papel `sales_rep`:** vê os clientes da sua carteira, os ativos e as OS deles; abre OS em nome do cliente (`origin = sales_rep`).
- **Modo de triagem por tenant** (`tenant_settings.triage_mode`):
  - `central`: tudo cai na fila do despacho;
  - `sales_rep_first`: chamados de clientes com vendedor passam primeiro por ele, com prazo (`sales_rep_triage_timeout_minutes`); sem resposta no prazo, sobem para a fila central;
  - `direct`: sem triagem para clientes ou tipos marcados, a OS vai direto ao técnico ou prestador da região.
- **Resolução remota:** a triagem pode resolver por orientação (telefone/WhatsApp) sem visita: `work_orders.resolution_mode = remote`, com descrição obrigatória. Evento `work_order.resolved_remotely`; indicador "% resolvido remotamente" por cliente, vendedor e prestador.

### 4.3 Antifraude e controle de visitas — MVP

1. **Check-in pelo QR do ativo da OS**, obrigatório por política (`tenant_settings.require_qr_check_in` e por tipo de OS). GPS só como alternativa justificada e sinalizada.
2. **Só há OS para ativos do tenant:** o ativo precisa estar vinculado e alocado ao cliente. OS sem ativo exige justificativa e fica sinalizada na conferência.
3. **Fotos antes/depois obrigatórias** por tipo de OS (checklist).
4. **Custo do terceiro só após conferência.** Visita sem check-in válido ou com `check_in_off_site` não gera custo automático.
5. **Indicadores e alertas por prestador e técnico:** visitas por cliente, reincidência em 30 dias, tempo no local, custo médio por OS, OS sem ativo, check-ins fora do local.

### 4.4 Plantão, escalonamento e despacho pelo celular — MVP

- **Plantão:** `on_call_assignments` (usuário, papel no plantão `dispatcher` ou `technician`, filial ou região opcional, início e fim). Complementa as escalas de técnicos, que já preveem plantão como exceção.
- **Escalonamento:** `escalation_policies` (por prioridade, tipo e cliente; passos com espera em minutos, quem avisar — plantonista, papel ou usuário — e canais push, WhatsApp ou SMS). Na OS: `acknowledged_at`, `acknowledged_by` (o primeiro "assumi" de um humano), `escalation_level` e `escalation_policy_id`. Um job a cada minuto sobe o nível enquanto ninguém assumir. Eventos `work_order.acknowledged` e `work_order.escalated`.
- **SLA 24×7:** calendário por cliente ou contrato (já existe `business_calendars`), com relógio corrido para quem tem atendimento no mesmo dia.
- **Despacho no celular:** aba "Despacho" no app do técnico, só para quem tem papel `dispatcher` e só online. Tem fila de triagem, aceitar/recusar, resolver remotamente, atribuir técnico ou prestador e mapa, com push a cada OS nova e a cada escalonamento.

### 4.5 Ativos: movimentação com termo, documentos e aquisição — MVP

- **Movimentação:** `asset_assignments` ganha `approval_status` (`not_required`, `pending`, `approved`, `rejected`), `approved_by`, `approved_at` e `term_attachment_id`. A plataforma gera o **termo de entrega, retirada ou transferência** em PDF; em campo, o cliente assina pelo app do técnico. A aprovação é opcional por tenant. Eventos `asset.movement_requested`, `asset.movement_approved` e `asset.movement_rejected`.
- **Documentos:** anexos do ativo e do modelo com categoria (`comodato_contract`, `invoice`, `manual`, `movement_term`, `photo`, `other`). O contrato de comodato emitido pelo ERP é anexado: por upload no MVP, e pelo ERP na F2 se a API permitir.
- **Aquisição:** `acquisition_date`, `acquisition_cost`, `supplier_name` e `acquisition_document` no ativo.

### 4.6 Filiais — MVP com uma filial padrão

- **Cadastro:** `branches` (CNPJ, IE, endereço, código da filial no ERP, `is_default`), com `branch_id` em `assets`, `work_orders` e `technicians`.
- **Usos:** define a filial do pedido no ERP (passa a ser a fonte principal, no lugar do mapeamento `service_area_branch`) e permite limitar o escopo de usuários a filiais.

### 4.7 Planos de manutenção preventiva e medidores — F2

- **Planos:** `maintenance_plans` (tipo de OS, checklist, gatilho `interval_days`, `monthly_day` ou `meter`, intervalo, antecedência, tolerância, aplicação por modelo de produto ou por ativo) e `maintenance_plan_assets` (plano × ativo, próxima data ou leitura prevista, última OS gerada).
- **Geração automática:** job diário, mais reação a cada nova leitura de medidor, cria OS com `origin = preventive_plan` e `work_orders.maintenance_plan_asset_id`, agrupando por cliente/unidade para uma visita atender vários ativos. A previsão aparece na agenda. Evento `maintenance_plan.work_order_generated`.
- **Medidores:** `asset_meters` (`hour_meter`, `energy_kwh`, `temperature`, `cycles`) e `meter_readings` (origem `manual`, `iot` ou `file_import`). O técnico lê o horímetro como item de checklist do tipo `meter_reading`, gravado pela mutação `meter_reading.record`. Evento `meter_reading.recorded`.

### 4.8 Bens do ERP e etiqueta após a integração — F2

Ativos com `source = erp` (bens do módulo de patrimônio da Senior), com as mesmas colunas de origem externa dos demais cadastros mestres (`external_*`, `missing_since`). A plataforma gera a etiqueta para bens novos e o app do técnico vincula os bens do legado no mutirão.

### 4.9 Requisição de materiais ao ERP — F2

`work_order_items.stock_requisition_status` (`not_required`, `pending`, `approved`, `rejected`, `issued`) e `erp_requisition_ref`, com a capacidade `create_stock_requisition` no conector. O custo das peças vem da baixa no ERP. Evento `work_order_item.requisition_status_changed`.

### 4.10 Custos e relatórios — MVP básico, F2 completo

- **Custo da OS:** peças + mão de obra própria + terceiros + deslocamento + outros.
- **Relatórios:** custos por período, tipo, cliente, ativo, modelo e prestador; MTBF, MTTR, HH e backlog.
- **Modo TV (F2):** painel só-leitura, acessado por um token de exibição revogável e atualizado pelo streaming do Serverpod.

### 4.11 Rentabilidade do comodato — F3

`customer_sales_summaries` (vendas mensais por cliente vindas do ERP), cruzadas com os ativos alocados (valor de aquisição) e com os custos de manutenção. Indicadores: receita por equipamento, custo de manutenção sobre receita, clientes abaixo do mínimo. Alertas ao vendedor para renegociar ou recolher o equipamento.

### 4.12 Oficina, desmontagem e manutenção interna — F3

- Categorias de OS `refurbishment` (recondicionamento) e `teardown` (desmontagem para peças).
- Baixa do ativo com motivo `cannibalized`; as peças recuperadas ficam registradas na OS, para entrada manual no ERP (estoque de seminovos).
- `customers.kind = internal` para setores e oficina do próprio tenant: manutenção interna com o mesmo modelo.

### 4.13 Hierarquia de ativos — F3

`assets.parent_asset_id` para componentes rastreados (ex.: o motor de um forno), com histórico por componente.

## 5. Kairós e telemetria IoT

**O que o folheto mostra:** dispositivo Wi-Fi com sensor de corrente não invasivo (até 100 A; alimentação de 85 a 260 VAC), instalado em paralelo com o equipamento (trilho DIN ou painel). Ele conta as horas ligado (horímetro) e **estima** o consumo pela corrente medida e pela tensão nominal. Tem display OLED, memória flash para guardar dados sem internet, acesso por navegador, app iOS/Android e transmissão para smart TV.

**Valor para o comodato:**
1. Preventiva pelo uso real (horas de compressor ou de forno), em vez de calendário.
2. Equipamento desligado ou parado por dias = equipamento ocioso no cliente, candidato a recolher ou realocar.
3. Anomalia antes da quebra: freezer funcionando sem parar (vedação ou gás) ou consumo fora do padrão viram OS preditiva.
4. Consumo como argumento comercial e de eficiência.

**Decisão:** não depender de um dispositivo ou de uma nuvem específicos. A plataforma ganha um módulo `telemetry` genérico:
- `iot_devices`: dispositivo vinculado ao ativo, com credencial por dispositivo guardada no cofre;
- ingestão por HTTPS (`POST /api/v1/integrations/iot/readings`) e, se necessário, MQTT via broker na F3;
- leituras em `meter_readings` com origem `iot`, aceitando lotes atrasados com o horário do dispositivo (idempotência por dispositivo + horário);
- `telemetry_alert_rules`, que notificam ou abrem OS (`origin = telemetry`, evento `telemetry.alert_triggered`);
- uso das leituras pelos planos de manutenção por medidor.

**Compatibilidade com o Kairós:** depende de o fabricante expor os dados (API, webhook ou MQTT), o que precisa ser validado. Se não expuser, escolher hardware aberto equivalente, com sensor de corrente e de temperatura (essencial para freezers).

**Cuidados:**
- O consumo é estimado, não é medição de energia ativa.
- O Wi-Fi do cliente é instável: considerar conectividade celular nos pontos críticos.
- O dispositivo precisa guardar dados localmente e enviar com o próprio horário.
- Credencial por dispositivo, com rotação.
- Comparar o custo do hardware por equipamento com o valor do ativo.
- Volume: leituras agregadas a cada 5 a 15 min, consolidação diária, particionamento mensal. O RDS não oferece TimescaleDB, então o particionamento é nativo.

**Fases:** F2 com leitura manual de horímetro pelo técnico; F3 com IoT, começando por um piloto em cerca de 20 equipamentos de clientes grandes.

## 6. O que não adotamos, e por quê

| Item | Motivo |
|---|---|
| Calibração | Não é processo da Superpan; pode voltar se outro tenant pedir |
| Árvore genérica de N níveis | Mantemos cliente → unidade → ativo, que cobre o comodato, com pai/filho na F3 |
| E-mail como alerta principal de OS urgente | Push e WhatsApp, com escalonamento, atendem o "mesmo dia" |
| Nomenclatura "SS" | Mantemos "OS", que é a linguagem do usuário |
| Licenciamento copiado | O modelo "por técnico, com contatos de clientes gratuitos" é uma referência para a decisão comercial, não uma regra técnica |

## 7. Onde a plataforma já vai além

- Abertura pelo QR sem instalar nada (página web leve), com login por WhatsApp e prova de leitura física (`qr_context`).
- Offline-first com sincronização por comandos e "registros a revisar".
- SaaS multi-tenant com isolamento garantido pelo banco e conector ERP independente de fornecedor.
- Pedido de serviço automático e idempotente no encerramento.
- Antifraude de prestadores desenhado desde o início (seção 4.3).

## 8. Impacto nos documentos

| Documento | Mudanças |
|---|---|
| [01](01-visao-geral-e-requisitos.md) | Novos requisitos RF-80 a RF-99 e fases |
| [02](02-arquitetura-de-solucao.md) | Novos módulos `maintenance` (planos, medidores) e `telemetry` (F3); prestadores, plantão e escalonamento em `scheduling`; custos em `field_execution`; vendedores em `customers`; filiais em `tenancy`; jobs de escalonamento e de planos |
| [03](03-modelo-de-dominio.md) e [schema.sql](../db/schema.sql) | Tabelas e colunas do apêndice A; transição de resolução remota; novas origens e categorias |
| [04](04-multi-tenancy-e-seguranca.md) | Papéis `sales_rep` e `provider_admin` e seus escopos de dados; escopo por filial; token de exibição do modo TV; credenciais de dispositivos IoT; prestadores como terceiros na LGPD |
| [05](05-ativos-e-qr-code.md) | Movimentação com aprovação e termo; documentos do ativo; aquisição; bens do ERP; pai/filho (F3); check-in por QR obrigatório como antifraude |
| [06](06-aplicacoes-e-fluxos.md) | Telas de prestadores, vendedores, plantão e escalonamento, planos e medidores, custos e relatórios, modo TV; aba Despacho e leitura de medidor no app do técnico; atendimento por link (F2); notificações de plantão e escalonamento |
| [07](07-integracao-erp-senior.md) | Bens (patrimônio), requisição de materiais, fechamento de prestadores e vendas por cliente; capacidades novas do conector |
| [08](08-api.md) | Endpoints, eventos e mutação novos do apêndice A; ingestão de telemetria |
| [09](09-infraestrutura-e-operacao.md) | Volume de telemetria e particionamento, job de escalonamento a cada minuto, custo de mensagens de plantão |
| [10](10-roadmap-e-riscos.md) | Épicos, fases e riscos novos |

## 9. Questões em aberto (novas)

1. **Prestadores:** como são pagos hoje (por visita, hora, km ou valor fixo por serviço)? Há contrato com tabela de preços?
2. **Fechamento:** o pagamento aos prestadores entra no ERP como nota de serviço tomado ou como conta a pagar? Qual módulo da Senior?
3. **Triagem:** manter o vendedor como primeiro filtro (`sales_rep_first`) ou centralizar no despacho?
4. **Plantão:** quem atende fins de semana e feriados, e por região?
5. **Bens no ERP:** o módulo de patrimônio da Senior está no escopo da implantação? O número do patrimônio é o que vai impresso na etiqueta?
6. **Telemetria:** vale um piloto com o Kairós ou hardware equivalente em freezers e fornos de clientes grandes? O fabricante expõe os dados?
7. **Desmontagem:** o controle das peças reaproveitadas precisa estar na plataforma ou pode ficar só no ERP?
8. **Rentabilidade:** que métrica a empresa usa hoje para justificar um equipamento em comodato (faturamento mínimo, mix de produtos)?

---

## Apêndice A — Nomes canônicos desta versão

**Tabelas novas:** `branches` (tenancy); `sales_reps` (customers); `service_providers`, `provider_rates`, `on_call_assignments`, `escalation_policies` (scheduling); `work_order_costs` e `provider_settlements` — esta na F2 (field_execution); `maintenance_plans`, `maintenance_plan_assets`, `asset_meters` e `meter_readings` — F2 (maintenance); `iot_devices` e `telemetry_alert_rules` — F3 (telemetry); `customer_sales_summaries` — F3 (customers).

**Colunas novas:**
- `technicians`: `kind` (`employee`, `contractor`), `service_provider_id`, `branch_id`
- `customers`: `kind` (`standard`, `internal`), `primary_sales_rep_id`
- `assets`: `branch_id`, `parent_asset_id`, `acquisition_date`, `acquisition_cost`, `supplier_name`, `acquisition_document`, `source`, `external_system`, `external_id`, `external_payload`, `external_hash`, `last_synced_at`, `missing_since`
- `asset_assignments`: `approval_status`, `approved_by`, `approved_at`, `term_attachment_id`
- `work_orders`: `branch_id`, `resolution_mode` (`field`, `remote`, `workshop`), `acknowledged_at`, `acknowledged_by`, `escalation_level`, `escalation_policy_id`, `service_provider_id`, `maintenance_plan_asset_id`
- `work_order_visits`: `service_provider_id`
- `work_order_items`: `stock_requisition_status`, `erp_requisition_ref`
- `work_order_costs`: `cost_type` (`parts`, `own_labor`, `third_party_labor`, `travel`, `other`), `status` (`pending_review`, `approved`, `rejected`), `settlement_id`
- `tenant_settings`: `triage_mode` (`central`, `sales_rep_first`, `direct`), `sales_rep_triage_timeout_minutes`, `require_qr_check_in`, `require_movement_approval`

**Valores novos em listas existentes:** `work_orders.origin` e `entry_method` + `sales_rep`, `telemetry`; `work_order_types.category` + `refurbishment`, `teardown`; tipo de item de checklist + `meter_reading`; categorias de anexo + `comodato_contract`, `invoice`, `manual`, `movement_term`.

**Papéis novos:** `sales_rep` (vendedor: carteira de clientes) e `provider_admin` (gestor do prestador: OS e técnicos da sua empresa).

**Eventos novos:** `work_order.acknowledged`, `work_order.escalated`, `work_order.resolved_remotely`, `asset.movement_requested`, `asset.movement_approved`, `asset.movement_rejected`, `service_provider.created`, `service_provider.updated`, `service_provider.deactivated`, `work_order_cost.added`, `work_order_cost.reviewed`, `maintenance_plan.work_order_generated`, `meter_reading.recorded`, `work_order_item.requisition_status_changed`, `provider_settlement.approved`, `provider_settlement.sent_to_erp`, `telemetry.alert_triggered`.

**Mutação nova no app do técnico:** `meter_reading.record`. As ações de despacho no celular são chamadas online da API, não mutações de sync.
