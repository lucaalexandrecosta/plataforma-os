# Ambiente de testes (staging)

Sobe a plataforma inteira com Docker, num endereço **https** que o celular alcança de qualquer rede: dá para testar o app de campo de verdade (offline, sincronização, fotos e assinatura) sem pagar nuvem.

| Serviço | Papel |
|---|---|
| `postgres` | PostgreSQL 18 (volume `banco`) |
| `migrar` | Roda e termina a cada `up`: usuários do banco, migrações, empresa inicial |
| `server` | Servidor Serverpod compilado, modo `staging` |
| `s3` | Fotos e assinaturas (RustFS, S3-compatível; volume `arquivos`) |
| `mailpit` | Caixa de e-mail de teste: códigos de acesso e convites |
| `proxy` | Caddy: backoffice em `/`, API em `/api/`, arquivos em `/arquivos/`, e-mails em `/mail/` |
| `ngrok` / `cloudflared` | Túnel opcional até o `proxy` (perfis do compose) |

As chaves de assinatura dos tokens e os segredos do login são gerados no primeiro boot e ficam no volume `segredos`.

> Isto é um ambiente de **testes**: uma máquina só, sem backup automático e sem alta disponibilidade. Para produção, ver docs/09.

## Duas formas de rodar de graça

| | A. Seu computador + ngrok | B. Oracle Cloud Always Free |
|---|---|---|
| Custo | Grátis | Grátis (pede cartão só para verificação) |
| Fica no ar | Enquanto o PC estiver ligado | 24 horas |
| Endereço | Domínio fixo grátis do ngrok (`algo.ngrok-free.app`) | Domínio grátis do DuckDNS (`algo.duckdns.org`) |
| HTTPS | Do ngrok | Do Caddy (Let's Encrypt, automático) |

Quem já tem um domínio na Cloudflare pode trocar o ngrok pelo túnel da Cloudflare (perfil `cloudflare`, ao final).

## Antes de tudo: o arquivo .env

```bash
cp infra/staging/.env.example infra/staging/.env
```

Edite `infra/staging/.env` (ele fica fora do Git): o endereço público, as senhas (só letras, números, `-` e `_`), a empresa inicial e o e-mail do administrador. Os comandos abaixo rodam na raiz do repositório.

## A. Seu computador + ngrok

1. Instale o [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/Mac) ou o Docker Engine (Linux).
2. Crie uma conta grátis no [ngrok](https://ngrok.com). No painel:
   - **Your Authtoken**: copie para `NGROK_AUTHTOKEN` no `.env`;
   - **Domains**: pegue o domínio fixo grátis e coloque em `PUBLIC_HOST` (sem `https://`).
3. Deixe `SITE_ADDRESS=:80` e suba tudo:

   ```bash
   docker compose -f infra/staging/compose.yaml --env-file infra/staging/.env --profile ngrok up -d --build
   ```

   O primeiro build demora (baixa o Flutter e compila servidor e backoffice: 10 a 20 minutos). Os seguintes reaproveitam o cache.
4. Abra `https://PUBLIC_HOST`. Na primeira visita pelo navegador o ngrok grátis mostra um aviso; clique em **Visit Site**. O app do celular não passa por esse aviso.

## B. Oracle Cloud Always Free (fica no ar)

1. Crie a conta em [oracle.com/cloud/free](https://www.oracle.com/cloud/free/) escolhendo a região **Brazil East (São Paulo)**.
2. **Compute → Instances → Create instance**:
   - imagem **Ubuntu 24.04**; forma **VM.Standard.A1.Flex** (Ampere) com 2 a 4 OCPUs e 12 a 24 GB (dentro do grátis);
   - guarde a chave SSH e anote o IP público.
   - Se aparecer "Out of capacity", tente de novo mais tarde ou em outro domínio de disponibilidade.
3. Libere as portas 80 e 443:
   - na nuvem: **Networking → Virtual Cloud Networks → (sua VCN) → Security Lists → Default** → *Add Ingress Rules*: origem `0.0.0.0/0`, TCP, portas `80` e `443`;
   - na máquina (a imagem Ubuntu da Oracle bloqueia por padrão):

     ```bash
     sudo iptables -I INPUT 6 -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW -j ACCEPT
     sudo netfilter-persistent save
     ```
4. Domínio grátis: entre no [DuckDNS](https://www.duckdns.org), crie um subdomínio e aponte para o IP público da máquina.
5. Na máquina, instale Docker e Git e baixe o projeto:

   ```bash
   curl -fsSL https://get.docker.com | sudo sh
   sudo usermod -aG docker $USER && newgrp docker
   git clone https://github.com/lucaalexandrecosta/plataforma-os.git && cd plataforma-os
   cp infra/staging/.env.example infra/staging/.env && nano infra/staging/.env
   ```

   No `.env`: `PUBLIC_HOST` e `SITE_ADDRESS` = o domínio do DuckDNS, `HTTP_PORT=80`, `HTTPS_PORT=443`.
6. Suba (sem perfil de túnel; o Caddy pega o certificado HTTPS sozinho):

   ```bash
   docker compose -f infra/staging/compose.yaml --env-file infra/staging/.env up -d --build
   ```

## Primeiro acesso

1. Abra `https://PUBLIC_HOST` e use **Primeiro acesso** com o `ADMIN_EMAIL` do `.env`.
2. O código chega na caixa de teste: `https://PUBLIC_HOST/mail` (usuário `teste`, senha `MAILPIT_PASSWORD`). Para mandar e-mail de verdade, preencha as linhas `SMTP_*` do `.env` (Brevo, Amazon SES, Gmail com senha de app etc.) e rode o `up -d` de novo.
3. No backoffice, em **Usuários**, convide o técnico (o convite também cai na caixa de teste) e, em **Técnicos**, cadastre-o ligado a esse usuário.

Com `CARREGAR_DEMO=sim` entram também as empresas fictícias do ambiente local (`frio-sul`, `forno-norte`) e o técnico `eduardo.tecnico@frio-sul.test`, que já tem agenda e bens para testar.

## O app no celular

Gere o APK apontando para o endereço público (https, então o Android aceita sem exceção de tráfego):

```bash
cd apps/field_app
flutter build apk --release --dart-define=API_URL=https://PUBLIC_HOST/api/
# instalar pelo cabo:  adb install -r build/app/outputs/flutter-apk/app-release.apk
# ou mande o .apk para o celular (Drive, WhatsApp) e instale autorizando "fontes desconhecidas"
```

Para testar o offline: entre no app com sinal, sincronize a agenda, ligue o modo avião, faça check-in, checklist, fotos e assinatura, conclua, e desligue o modo avião. A fila sobe sozinha (ou pelo botão de sincronizar) e as fotos aparecem na OS no backoffice.

## Operação

```bash
C="docker compose -f infra/staging/compose.yaml --env-file infra/staging/.env"
$C ps                                   # o que está no ar ("migrar" aparece como Exited 0: normal)
$C logs -f server                       # log do servidor
$C logs migrar                          # se o servidor não subiu, o motivo costuma estar aqui
git pull && $C up -d --build            # atualizar para a versão mais nova
$C exec -T postgres pg_dump -U postgres plataforma_os > backup.sql   # cópia do banco
$C down                                 # parar (os dados ficam nos volumes)
$C down -v                              # apagar TUDO: banco, fotos e chaves
```

## Túnel da Cloudflare (para quem tem domínio na Cloudflare)

No painel **Zero Trust → Networks → Tunnels**, crie um túnel do tipo *cloudflared*, copie o token para `CLOUDFLARE_TUNNEL_TOKEN` e adicione um *Public Hostname* (ex.: `os.seudominio.com.br`) com serviço `HTTP` e URL `proxy:80`. No `.env`, `PUBLIC_HOST=os.seudominio.com.br` e `SITE_ADDRESS=:80`. Suba com `--profile cloudflare` no lugar de `--profile ngrok`.
