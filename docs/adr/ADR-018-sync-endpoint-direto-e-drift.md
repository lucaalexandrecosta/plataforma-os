# ADR-018 — Sincronização offline por endpoint direto (sem broker) e banco local Drift + SQLCipher

- **Status:** Proposto — 02/11/2026
- **Complementa:** [ADR-005](ADR-005-sync-offline-por-comandos.md) (o protocolo por comandos continua; muda a tecnologia do banco local)
- **Relacionados:** [Stack Dart](../12-stack-dart-flutter-serverpod.md), seções 5 e 6

## Contexto

- O técnico grava sem rede e precisa subir tudo quando a conexão voltar, sem perder nem duplicar dados.
- O usuário perguntou se os apps devem publicar numa fila (ex.: RabbitMQ) consumida pelo servidor ou chamar um endpoint direto.
- O usuário sugeriu Hive como banco local, aceitando alternativa melhor.

## Decisão

1. **Endpoint direto no servidor**, sem broker entre o app e o servidor.
   - A fila durável fica **no aparelho** (`pending_mutations` no SQLite, gravada na mesma transação da alteração local).
   - O app envia lotes ao endpoint de push do Serverpod; cada mutação é aplicada numa transação idempotente por `mutation_id` e devolve `applied`, `duplicate`, `rejected` ou `conflict` na hora.
   - O trabalho assíncrono do servidor usa o outbox e as tabelas de jobs no PostgreSQL.
2. **Banco local Drift (SQLite) com SQLCipher:** um arquivo por tenant, chave no Keychain/Keystore, migrações versionadas com o app e consultas reativas. Hive CE só para preferências simples, se precisar.

## Consequências

**Positivas**
- O app recebe a resposta de cada mutação imediatamente e mostra conflitos na hora.
- Menos infraestrutura: nada de cluster de broker exposto a milhares de celulares.
- Regras de negócio, RBAC e RLS valem para o que chega offline.

**Negativas / cuidados**
- O endpoint precisa de lotes limitados, `429` + `Retry-After` sob carga e backoff com *jitter* no app.
- O Drift exige modelar o schema local; a camada de sync (`sync_engine`) é código nosso, com testes de conflito.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Apps publicando no RabbitMQ (AMQP) | Não ajuda quem está sem rede (a fila precisa estar no aparelho); resposta assíncrona exige um segundo canal; broker exposto à internet com credencial por aparelho; mais um cluster para operar |
| Endpoint que só enfileira (inbox) e responde 202 | Mesma perda da resposta imediata; só vale se a carga exigir, o que não é o caso na premissa de volume |
| Hive (CE) como banco principal | Chave-valor, sem consultas relacionais nem transação entre caixas; inadequado para OS, visitas, itens e fila de mutações |
| Isar | Desenvolvimento original parado; sem criptografia em repouso embutida |
| ObjectBox | Criptografia em repouso não nativa; sync comercial |
| PowerSync | Viável para o download; acrescenta um serviço. Fica como plano B |

**Quando reavaliar um broker:** telemetria IoT em alto volume (broker MQTT na borda, não para os apps), trabalho assíncrono acima de ~500 jobs/s ou extração de serviços.
