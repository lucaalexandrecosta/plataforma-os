# ADR-003 — Identidade: IdP OIDC para a equipe interna e OTP próprio para contatos de clientes

- **Status:** Proposto — 27/10/2026
- **Relacionados:** [Multi-tenancy e segurança](../04-multi-tenancy-e-seguranca.md), [Aplicações e fluxos](../06-aplicacoes-e-fluxos.md)

## Contexto

- A equipe interna (atendentes, despachantes, gestores, técnicos, admins) precisa de MFA e de recuperação de senha. Tenants maiores vão pedir SSO com o próprio diretório. Os técnicos precisam de sessão longa para trabalhar offline.
- O contato do cliente (ex.: gerente de um bar) não vai criar senha para pedir assistência de um freezer. No Brasil, o canal natural é o WhatsApp.
- IdPs de mercado têm suporte limitado ou caro a OTP por WhatsApp. Também cobram por usuário ativo, o que pesa com milhares de contatos de clientes.

## Decisão

1. **Equipe interna → Keycloak 26.8**, auto-hospedado (realms `staff` e `platform`; cada tenant é uma Organization, o que habilita SSO corporativo depois). A escolha e as alternativas avaliadas estão em [Multi-tenancy e segurança](../04-multi-tenancy-e-seguranca.md). Fluxo Authorization Code + PKCE no backoffice e nos apps; refresh de longa duração para técnicos trabalharem offline, vinculado ao dispositivo e revogável remotamente.
1a. **A API só aceita tokens emitidos por ela mesma.** O token do Keycloak é trocado por um **token de tenant** (JWT ES256, 10 min) em `POST /api/v1/auth/tenant-token`. Com isso, o tenant ativo fica assinado no token, os papéis vêm do nosso banco (`tenant_memberships`, revogação imediata, sem sincronizar com o IdP) e todos os atores usam um único validador. No app do técnico, a troca exige prova de posse da chave do aparelho (`devices.public_key_jwk`): um token roubado não serve em outro aparelho.
2. **Contatos de clientes → OTP próprio da plataforma** (módulo `identity_access`): código de 6 dígitos por WhatsApp, SMS ou e-mail; validade de 10 minutos; tentativas limitadas; código e destino guardados só como HMAC (`otp_challenges`). Após validar, a API emite seus próprios tokens: access token de 10 min + refresh token rotativo guardado como hash em `auth_sessions`, com detecção de reuso por família de sessões. Na página web leve do QR (v0.3), o refresh fica em cookie `__Host-pos_rt_<slug>` (HttpOnly, SameSite=Strict); no app Flutter, em armazenamento seguro do aparelho. No Serverpod, os tokens próprios são validados por um handler de autenticação customizado ([ADR-017](ADR-017-stack-dart-flutter-serverpod.md)). A abertura de chamado a partir do QR exige o `qr_context`, a prova de leitura física definida no 04.
3. **Usuários globais:** a tabela `users` representa pessoas, não vínculos. A equipe tem `idp_subject`; contatos de clientes não têm. O vínculo com tenants fica em `tenant_memberships`, e o vínculo com clientes em `customer_contacts`.

## Consequências

**Positivas**
- Abertura de chamado sem atrito para o cliente final, no canal que ele já usa.
- Controle total de canal, custo e UX do OTP; nenhum custo por usuário ativo de IdP para contatos.
- A equipe ganha MFA e SSO corporativo sem desenvolvimento próprio.

**Negativas / cuidados**
- Dois caminhos de autenticação para proteger e testar. O OTP próprio exige rate limit por telefone, IP e tenant; proteção contra enumeração; auditoria; rotação de chaves de assinatura.
- O OTP por WhatsApp depende de modelo de mensagem de autenticação aprovado pela Meta. SMS e e-mail ficam como alternativa.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Tudo no IdP, inclusive clientes | Extensões customizadas para OTP por WhatsApp; custo por usuário ativo; UX de login genérica |
| Link mágico por e-mail para clientes | Muitos contatos não usam e-mail no dia a dia; atrito maior que o WhatsApp |
| Senha para clientes | Atrito incompatível com "ler o QR e abrir o chamado em segundos" |
| Autenticação própria também para a equipe | Reimplementar MFA, recuperação e SSO/SAML é caro e arriscado |
