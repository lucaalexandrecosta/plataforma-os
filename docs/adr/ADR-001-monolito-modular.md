# ADR-001 — Monólito modular com dois deployables (api e worker) — implementado em Serverpod desde a v0.3 (originalmente NestJS)

- **Status:** Proposto — 27/10/2026. Em 02/11/2026 a implementação passou a ser **Serverpod 4** ([ADR-017](ADR-017-stack-dart-flutter-serverpod.md)); o princípio do monólito modular com dois deployables continua
- **Decisores:** arquitetura (rascunho para validação do time)
- **Relacionados:** [Arquitetura de solução](../02-arquitetura-de-solucao.md), [Modelo de domínio](../03-modelo-de-dominio.md)

## Contexto

- Time pequeno, MVP com prazo e um domínio que ainda está sendo descoberto (OS, ativos, QR, sync offline).
- Escala do primeiro ano modesta (até ~50 tenants; ~5 mil OS/mês por tenant). Um PostgreSQL bem dimensionado atende com folga.
- Muitos casos de uso cruzam contextos na mesma transação. Exemplo: concluir uma visita mexe em visita, OS, apontamentos e outbox.
- O usuário escolheu TypeScript/NestJS no backend na v0.1 e trocou para Dart/Serverpod na v0.3 ([ADR-017](ADR-017-stack-dart-flutter-serverpod.md)). O princípio deste ADR vale para as duas.

## Decisão

1. **Um único código** (Serverpod desde a v0.3: bibliotecas Dart por contexto em `lib/src/<contexto>/`) organizado em **módulos por bounded context**: `identity_access`, `tenancy`, `customers`, `catalog`, `assets`, `work_orders`, `scheduling`, `field_execution`, `notifications`, `integrations`, `reporting`, `audit`.
2. **Dois deployables a partir da mesma imagem:** `api` (HTTP) e `worker` (fila de jobs, relay do outbox, integrações, notificações). Escalam de forma independente.
3. **Fronteiras verificadas por máquina:** cada módulo expõe uma interface pública; acessar internals ou tabelas de outro módulo quebra o lint de dependências e os testes de arquitetura no CI.
4. **Comunicação entre módulos:** chamadas síncronas pela interface pública (mesma transação, quando preciso) e eventos de domínio. Tudo que sai do processo (ERP, notificações, tempo real) passa pelo outbox.

## Consequências

**Positivas**
- Deploy, observabilidade e depuração simples; transações ACID entre módulos sem sagas.
- Refatorar fronteiras é barato enquanto o domínio amadurece.
- Caminho de extração preservado: um módulo com interface pública e eventos no outbox pode virar serviço depois.

**Negativas / cuidados**
- Exige disciplina: sem as regras automáticas, o monólito degrada.
- A escala é por deployable, não por módulo. Se um módulo pesado (ex.: geração de PDFs) incomodar, ele pode ir para uma fila dedicada no worker.

## Alternativas consideradas

| Alternativa | Por que não agora |
|---|---|
| Microsserviços | Custo operacional (deploys, contratos, tracing distribuído, consistência eventual em tudo) desproporcional ao time e à escala |
| Funções serverless | Cold start, desenvolvimento local mais difícil, acoplamento à nuvem (o usuário quer portabilidade) |
| Monólito sem módulos | Vira um emaranhado; impede extrair partes e paralelizar o time |
