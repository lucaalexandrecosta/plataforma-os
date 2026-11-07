# ADR-004 — App do cliente universal: um código Expo para iOS, Android e PWA

- **Status:** Substituído pelo [ADR-017](ADR-017-stack-dart-flutter-serverpod.md) em 02/11/2026. Os apps passam a ser Flutter (iOS/Android) e o cliente sem app usa uma página web leve; o princípio "o QR abre o app se instalado, senão o navegador, sem instalar nada" continua
- **Relacionados:** [Aplicações e fluxos](../06-aplicacoes-e-fluxos.md), [Ativos e QR code](../05-ativos-e-qr-code.md), [Arquitetura de solução](../02-arquitetura-de-solucao.md)

## Contexto

- O usuário quer "os dois": uma PWA aberta direto pelo QR, sem instalar nada, para o primeiro acesso, e um app nativo nas lojas para clientes frequentes.
- O primeiro contato acontece com a câmera nativa do celular lendo a etiqueta. Exigir instalação antes do primeiro chamado derrubaria a adesão.
- Manter duas bases de UI para a mesma jornada dobraria o custo de um time pequeno.

## Decisão

1. **Um único código** Expo (React Native + Expo Router), publicado como app iOS/Android **e** como PWA web (react-native-web), no mesmo repositório e com os mesmos pacotes compartilhados (cliente de API, validações, design tokens).
2. **O QR aponta para o domínio estável da plataforma** (`https://<dominio>/q/<token>`). Esse domínio publica `apple-app-site-association` e `assetlinks.json`: se o app estiver instalado, o sistema operacional abre o app (universal links / app links); senão, abre a PWA no navegador.
3. **A rota `/q/<token>` é tratada como página de entrada crítica:** renderização estática, bundle mínimo e meta de conteúdo útil em menos de 2 s em 4G.
4. **Plano B**, se a POC P2 mostrar desempenho web insuficiente: PWA leve em React/Vite só para a jornada de chamado, reaproveitando os pacotes compartilhados. O app nativo continua no Expo.

## Consequências

**Positivas**
- Uma jornada, um código, três plataformas.
- O primeiro chamado não depende de instalação; quem usa sempre instala e ganha push nativo.

**Negativas / cuidados**
- O react-native-web aumenta o bundle; daí a otimização da rota do QR e a POC.
- Web push no iOS só funciona com a PWA adicionada à tela inicial. Por isso, WhatsApp e e-mail continuam como canais principais de notificação ao cliente.
- O domínio do QR vira infraestrutura permanente: precisa servir os arquivos de associação dos apps para sempre.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| PWA em React/Vite + app nativo em Expo, separados | Duas UIs para a mesma jornada; fica como plano B |
| Só app nativo | Instalar antes do primeiro chamado mata o fluxo do QR |
| Só PWA | O usuário pediu os dois; push e câmera nativos são melhores para clientes frequentes |
| Um único app para cliente e técnico | Públicos, permissões, offline e publicação nas lojas diferentes demais |
