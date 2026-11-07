# ADR-017 — Stack Dart: Flutter (iOS, Android e Web) + Serverpod 4 + PostgreSQL

- **Status:** Proposto — 02/11/2026 (decisão do usuário; validar nos spikes S1 a S6)
- **Substitui:** [ADR-004](ADR-004-app-cliente-universal.md) e, na implementação, [ADR-011](ADR-011-fila-de-jobs-pg-boss.md) e [ADR-012](ADR-012-tempo-real-por-sse.md). O [ADR-001](ADR-001-monolito-modular.md) continua válido como princípio (monólito modular) e passa a ser implementado em Serverpod
- **Relacionados:** [Stack Dart](../12-stack-dart-flutter-serverpod.md), [ADR-018](ADR-018-sync-endpoint-direto-e-drift.md), [ADR-019](ADR-019-dados-com-serverpod.md)

## Contexto

O usuário definiu a stack: Flutter para os apps (Android e iOS) e para o backoffice (Flutter Web), e Dart com Serverpod no servidor, com PostgreSQL. O cliente que lê o QR sem o app usa uma página web leve. O desenho de domínio, banco, segurança e integrações da v0.2 continua valendo.

## Decisão

1. **Servidor:** Serverpod 4.1, um projeto com bibliotecas por contexto (`lib/src/<contexto>/`) e fronteiras verificadas no CI. O mesmo executável roda como `api` (`--role serverless`, atrás do load balancer) e como `worker` (`--role monolith`, com as tarefas agendadas e os laços que consomem `outbox_messages`, `integration_jobs` e `notifications` com `FOR UPDATE SKIP LOCKED`).
2. **Apps:** Flutter com Riverpod e go_router. App do técnico e app do cliente para iOS/Android; backoffice em Flutter Web. Cliente da API gerado pelo Serverpod.
3. **Página pública do QR, OTP e chamado sem app:** HTML leve no servidor web do Serverpod, que também publica os arquivos de links universais. Webhooks e ingestão IoT também usam rotas REST desse servidor web.
4. **Tempo real:** streaming do Serverpod com avisos de invalidação (o padrão do ADR-012 continua; o transporte é WebSocket) e difusão entre instâncias via Redis/Valkey.
5. **Jobs:** sem pg-boss. As tabelas de jobs do próprio schema fazem o papel de fila, com tentativas e backoff, e as future calls do Serverpod (pelo menos uma vez, sem retentativa automática) só disparam no horário (cron).

## Consequências

**Positivas**
- Uma linguagem só no time; modelos e cliente gerados eliminam OpenAPI e SDK internos.
- O Serverpod já traz autenticação, streaming, S3, tarefas agendadas e servidor web.

**Negativas / cuidados**
- Ecossistema de servidor menor que o do Node: algumas peças (OpenTelemetry, bibliotecas de integração) são da comunidade ou exigem código próprio.
- O Flutter Web pesa no primeiro carregamento, por isso só no backoffice.
- A API da camada de banco do Serverpod pode mudar em versão *minor*: versão fixada e testes de isolamento no CI.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Manter a stack TypeScript (v0.2) | Decisão do usuário pela stack Dart |
| Flutter Web também na página do QR | Download de alguns MB no momento do defeito (decisão do usuário: página leve) |
| Dart sem Serverpod (shelf/dart_frog) | Perde modelos e cliente gerados, autenticação, streaming e tarefas agendadas prontos |
