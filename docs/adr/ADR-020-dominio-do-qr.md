# ADR-020 — Domínio do QR: `qr.platform-lac.com.br`

- **Status:** Aceito — 07/11/2026 (decisão de negócio do guia, [13 §7](../13-guia-de-inicio-do-desenvolvimento.md); fica definitivo na primeira impressão de etiquetas)
- **Relacionados:** [ADR-006](ADR-006-qr-url-token-opaco.md), [Ativos e QR code §3.6 e §3.7](../05-ativos-e-qr-code.md), [Arquitetura de solução §2.3](../02-arquitetura-de-solucao.md), [Infraestrutura §5](../09-infraestrutura-e-operacao.md)

## Contexto

- O ADR-006 fixou o formato `https://<dominio>/q/<token>` num domínio estável da plataforma, mas deixou o domínio em aberto. Ele trava as etiquetas, os links universais dos apps e o remetente de e-mail.
- Depois que a primeira etiqueta for para campo, trocar o domínio significa reimprimir todas.
- A recomendação do doc 05 era um domínio de até 16 caracteres, para o QR caber na versão 4.

## Decisão

1. **Host do QR e da página web leve:** `qr.platform-lac.com.br`. As etiquetas levam `https://qr.platform-lac.com.br/q/<token>`, sempre em minúsculas até o `/q/`.
2. No mesmo host ficam o que os documentos chamam de `<dominio>` na página leve: `/q/*`, `/v/*`, `/chamados/*`, `/static/*`, `/.well-known/apple-app-site-association` e `/.well-known/assetlinks.json`.
3. **Raiz da plataforma:** `platform-lac.com.br`. Os demais hosts da tabela do doc 02 §2.3 (`api.`, `auth.`, `app.`, `console.`, `cdn.`, `status.`, `<slug>.`) ficam sob essa raiz.
4. `qr` entra na lista de slugs reservados, para nenhum tenant ocupar `qr.platform-lac.com.br` como backoffice.
5. O QR é gerado em **versão 5 (37×37 módulos), nível Q**, com o prefixo em modo byte e o token em modo alfanumérico. A versão fica fixa para todas as etiquetas.

## Consequências

**Positivas**
- O domínio é da própria plataforma, desacoplado de qualquer tenant (requisito do doc 05 §3.6).
- O subdomínio dedicado isola a página do QR (CSP rígida, cookie `__Host-` do contato) do backoffice e da api.

**Negativas / cuidados**
- 22 caracteres: o prefixo `https://qr.platform-lac.com.br/q/` tem 33 bytes e, com o token, a URL ocupa 54 codewords de dados. A versão 4 no nível Q comporta 48, então o QR fica na **versão 5**: módulos cerca de 12% menores na mesma etiqueta. Validar a leitura na POC de etiquetas (geada, sujeira e etiqueta pequena), principalmente no tamanho mínimo.
- O domínio `platform-lac.com.br` vira infraestrutura permanente: renovação automática, bloqueio de transferência no registrador, DNSSEC, monitoramento de expiração e certificado, e HSTS (doc 05 §3.6).
- Universal links e App Links passam a declarar `qr.platform-lac.com.br` (Associated Domains `applinks:qr.platform-lac.com.br` e `android:host`).

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Domínio curto dedicado (até 16 caracteres) para manter a versão 4 | Exige registrar outro domínio. Continua possível **até a primeira impressão**: depois disso, este ADR fica definitivo |
| QR na raiz `platform-lac.com.br/q/` | 19 caracteres: também cai na versão 5 e mistura a página do QR com o site institucional da raiz |
| Domínio do tenant | Etiquetas duram anos e tenants mudam de domínio ou saem da plataforma (doc 05 §3.6) |
