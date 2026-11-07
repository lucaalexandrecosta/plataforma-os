# ADR-012 — Tempo real no backoffice por SSE com avisos de invalidação

- **Status:** Substituído pelo [ADR-017](ADR-017-stack-dart-flutter-serverpod.md) em 02/11/2026. O padrão de **avisos de invalidação sem dados** continua; o transporte passa a ser o streaming do Serverpod (WebSocket)
- **Relacionados:** [Arquitetura de solução](../02-arquitetura-de-solucao.md), [API](../08-api.md), [Aplicações e fluxos](../06-aplicacoes-e-fluxos.md)

## Contexto

- O painel de acompanhamento, a fila de triagem e a agenda precisam refletir mudanças em segundos: chamado novo pelo QR, técnico a caminho, OS concluída.
- O fluxo é quase todo servidor → navegador; o navegador já escreve pela API REST.
- Os dados exibidos dependem de permissão e escopo do usuário. Empurrar dados por um canal paralelo duplicaria a autorização.

## Decisão

1. **Server-Sent Events** do servidor para o navegador no backoffice.
2. **Avisos de invalidação, sem dados:** `{"type": "work_order.status_changed", "id": "...", "version": 7}`. O front invalida as consultas do TanStack Query e busca pela API REST, onde a autorização acontece.
3. **Caminho:** o worker processa o outbox e publica no canal do tenant no Valkey (`t:<tenant_id>:ui`); cada instância da `api` repassa aos navegadores conectados daquele tenant, filtrando por permissão e escopo.
4. **Robustez:** heartbeat a cada 15 s; reconexão com `Last-Event-ID` e recarga das listas se houver lacuna; o stream fecha quando o token expira e o cliente reconecta com token novo (cliente SSE baseado em `fetch`, porque o `EventSource` nativo não envia `Authorization`).
5. **Apps móveis sem conexão persistente:** push "há novidades" + sync no app do técnico; atualização ao abrir a tela no app do cliente.

## Consequências

**Positivas**
- Simples de operar: HTTP comum, atravessa CDN e load balancer, sem afinidade de sessão.
- Nenhum dado sensível trafega pelo canal de tempo real; a autorização fica num lugar só.

**Negativas / cuidados**
- Uma requisição extra por aviso (mitigado com agrupamento de avisos e cache do TanStack Query).
- Conexões longas consomem tarefas da `api`: dimensionar e monitorar, e configurar a CDN sem buffer para o stream.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| WebSocket / socket.io | Bidirecional desnecessário; afinidade de sessão e protocolo próprio |
| Polling | Latência maior e carga constante no banco |
| Serviço gerenciado de tempo real | Custo e dados trafegando fora do país |
