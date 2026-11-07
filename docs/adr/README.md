# Registros de decisão de arquitetura (ADRs)

Cada ADR registra **uma** decisão relevante: o contexto, o que foi decidido, as consequências e as alternativas descartadas. Um ADR aceito não é editado. Se a decisão mudar, cria-se um novo ADR que "substitui" o anterior.

Status possíveis: **Proposto** (rascunho para validação) · **Aceito** · **Substituído por ADR-xxx** · **Descartado**.

| ADR | Decisão | Status |
|---|---|---|
| [ADR-001](ADR-001-monolito-modular.md) | Monólito modular em NestJS, com dois deployables (api e worker) | Proposto |
| [ADR-002](ADR-002-multi-tenancy-rls.md) | Multi-tenancy com banco compartilhado, `tenant_id`, RLS com FORCE e FKs compostas | Proposto |
| [ADR-003](ADR-003-identidade-idp-e-otp.md) | Keycloak para a equipe interna (com token de tenant emitido pela api) e OTP próprio para contatos de clientes | Proposto |
| [ADR-004](ADR-004-app-cliente-universal.md) | App do cliente universal: um código Expo para iOS, Android e PWA | Proposto (POC P2) |
| [ADR-005](ADR-005-sync-offline-por-comandos.md) | App do técnico offline-first com sincronização por comandos | Proposto (POC P3) |
| [ADR-006](ADR-006-qr-url-token-opaco.md) | QR com URL curta, token opaco e código curto, em domínio estável da plataforma | Proposto (POC P1) |
| [ADR-007](ADR-007-os-unica-com-visitas.md) | OS única nascendo como "Solicitada", com várias visitas | Proposto |
| [ADR-008](ADR-008-integracao-erp-conectores-outbox.md) | Integração com ERPs por porta `ErpConnector`, outbox e jobs idempotentes | Proposto (POC P4) |
| [ADR-009](ADR-009-nuvem-de-referencia-aws.md) | AWS sa-east-1 como nuvem de referência, com desenho portátil e células de implantação | Proposto |
| [ADR-010](ADR-010-acesso-a-dados-sql-first.md) | Acesso a dados SQL-first: Kysely, migrações dbmate e `schema.sql` como referência | Proposto |
| [ADR-011](ADR-011-fila-de-jobs-pg-boss.md) | Fila de jobs no PostgreSQL (pg-boss), transacional com o caso de uso | Proposto |
| [ADR-012](ADR-012-tempo-real-por-sse.md) | Tempo real no backoffice por SSE com avisos de invalidação | Proposto |
| [ADR-013](ADR-013-prestadores-e-antifraude.md) | Prestadores terceirizados como entidade, com custos conferidos e controles antifraude | Proposto (v0.2) |
| [ADR-014](ADR-014-triagem-configuravel-e-plantao.md) | Triagem configurável (central, vendedor ou direta), resolução remota e plantão com escalonamento | Proposto (v0.2) |
| [ADR-015](ADR-015-planos-de-manutencao-e-medidores.md) | Manutenção planejada por planos (calendário ou medidor) e medidores com origem manual ou IoT | Proposto (v0.2, F2) |
| [ADR-016](ADR-016-telemetria-generica.md) | Telemetria IoT genérica, sem dependência de fabricante | Proposto (v0.2, F3) |
| [ADR-017](ADR-017-stack-dart-flutter-serverpod.md) | Stack Dart: Flutter (iOS, Android e Web) + Serverpod 4 + PostgreSQL | Proposto (v0.3) |
| [ADR-018](ADR-018-sync-endpoint-direto-e-drift.md) | Sync offline por endpoint direto (sem broker) e banco local Drift + SQLCipher | Proposto (v0.3) |
| [ADR-019](ADR-019-dados-com-serverpod.md) | Dados com Serverpod: tabelas não gerenciadas, tenant pelo interceptor, dinheiro em inteiros | Proposto (v0.3) |
| [ADR-020](ADR-020-dominio-do-qr.md) | Domínio do QR `qr.platform-lac.com.br`, raiz `platform-lac.com.br`, QR versão 5 | Aceito (definitivo na primeira impressão) |

**Substituídos na v0.3:** ADR-004 → ADR-017 · ADR-010 → ADR-019 · ADR-011 → ADR-017 · ADR-012 → ADR-017. O ADR-001 (monólito modular) e o ADR-005 (sync por comandos) continuam válidos, com a implementação atualizada.

## Modelo para novos ADRs

```markdown
# ADR-NNN — Título curto da decisão

- **Status:** Proposto — DD/MM/AAAA
- **Relacionados:** links para documentos e ADRs

## Contexto
O problema, as forças em jogo e as restrições.

## Decisão
O que foi decidido, de forma verificável.

## Consequências
Positivas, negativas e cuidados.

## Alternativas consideradas
| Alternativa | Por que não |
```
