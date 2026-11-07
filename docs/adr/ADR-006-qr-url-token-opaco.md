# ADR-006 — QR code: URL curta com token opaco e código curto, em domínio estável da plataforma

- **Status:** Proposto — 27/10/2026 (validar material e leitura na POC P1)
- **Relacionados:** [Ativos e QR code](../05-ativos-e-qr-code.md), [Modelo de domínio](../03-modelo-de-dominio.md), [Multi-tenancy e segurança](../04-multi-tenancy-e-seguranca.md)

## Contexto

- A etiqueta é física e dura anos, colada em equipamentos que vão para clientes de vários tenants.
- Ela precisa abrir com a câmera nativa de qualquer celular, sem app específico.
- Qualquer pessoa no local pode fotografar a etiqueta, então ela não pode revelar dados nem permitir adivinhar outros equipamentos.
- Os tenants querem imprimir lotes antecipadamente e colar na instalação.

## Decisão

1. **O QR contém só uma URL:** `https://<dominio-da-plataforma>/q/<token>`.
2. **Token:** 128 bits aleatórios (CSPRNG), em base32 Crockford (26 caracteres), globalmente único. É ele que identifica o tenant; nada sequencial, nada pessoal.
3. **Código curto impresso** (8 caracteres base32 Crockford, exibido como `XXXX-XXXX`: 7 aleatórios + 1 dígito verificador Luhn mod 32, conferido por CHECK no banco), globalmente único, para digitar quando a câmera falhar. O verificador pega erro de digitação antes de qualquer consulta.
4. **Domínio estável da plataforma**, nunca o do tenant: a etiqueta continua válida se o tenant mudar de domínio ou de marca.
5. **Dois modos de emissão:** lote pré-impresso (etiquetas "virgens", vinculadas ao ativo na instalação pelo app do técnico ou no backoffice) e etiqueta gerada para um ativo já cadastrado.
6. **Ciclo de vida:** `generated → printed → bound → revoked`, no máximo uma etiqueta `bound` por ativo; substituir significa revogar a antiga e vincular a nova, com histórico.
7. **Resolução pública** pelas funções `resolve_qr_token` e `resolve_qr_short_code` (SECURITY DEFINER, cujo dono é o papel restrito `app_system`, com `search_path` fixo), que devolvem só o necessário. A página pública não mostra dados pessoais. A resposta inclui um **`qr_context`**, credencial assinada de 30 min que prova a leitura física e é exigida para iniciar o OTP e abrir o chamado. Há rate limit por IP, token e tenant.

## Consequências

**Positivas**
- Funciona com qualquer câmera e leva ao app instalado via universal links.
- Não adivinhável; revogável; sobrevive a mudanças do tenant.
- Etiquetas pré-impressas agilizam a operação de campo.

**Negativas / cuidados**
- O domínio do QR vira infraestrutura crítica permanente (DNS, TLS, arquivos de associação dos apps). Precisa de dono e de renovação garantida.
- O endpoint público é alvo de varredura: rate limit e monitoramento de abuso. Estados exibíveis (etiqueta não ativada, revogada, ativo sem cliente, tenant suspenso) respondem 200 com o estado, para o cliente receber uma orientação útil; só código malformado ou inexistente responde 404. Com 128 bits no token, e com limite de tentativas mais o verificador no código curto, distinguir esses estados não ajuda a enumerar etiquetas.

## Alternativas consideradas

| Alternativa | Por que não |
|---|---|
| Codificar nº de série ou ID do ativo | Adivinhável, vaza informação, não resolve o tenant |
| Codificar dados (JSON) no QR | Fica desatualizado, não abre nada na câmera nativa, QR mais denso |
| Subdomínio do tenant no QR | Quebra se o tenant mudar de domínio ou sair da plataforma |
| Etiqueta NFC | Custo maior e leitura menos universal; pode complementar no futuro |
