# ADR-009 — AWS sa-east-1 como nuvem de referência, com desenho portátil

- **Status:** Proposto — 28/10/2026
- **Relacionados:** [Infraestrutura e operação](../09-infraestrutura-e-operacao.md), [Arquitetura de solução](../02-arquitetura-de-solucao.md)

## Contexto

- O usuário não tem preferência de nuvem, mas o produto precisa de uma nuvem concreta para o MVP, com estimativa de custo.
- Dados de clientes brasileiros (LGPD) e latência baixa para técnicos e clientes favorecem uma região no Brasil.
- O produto será vendido a outras empresas; algumas podem exigir outra nuvem ou ambiente dedicado no futuro.

## Decisão

1. **AWS, região São Paulo (sa-east-1), como referência do MVP:** ECS Fargate (`api`, `worker`, Keycloak), RDS for PostgreSQL 18 Multi-AZ, ElastiCache para Valkey, S3, CloudFront + WAF, Secrets Manager/KMS, SES. IaC em OpenTofu.
2. **Só componentes com equivalente direto** na Azure e no Google Cloud (tabela de equivalência no 09): containers OCI, PostgreSQL gerenciado, Valkey/Redis, object storage S3-compatível, IdP próprio em container. Nada de serviços proprietários no caminho crítico (sem SQS, Cognito ou Lambda).
3. **Células de implantação:** cada tenant aponta para uma célula (`tenants.deployment_cell`); no MVP existe uma (`br-1`). Uma célula dedicada é o caminho para o tenant grande ou com exigência de isolamento ("silo").

## Consequências

**Positivas**
- Região no Brasil, serviços gerenciados maduros e boa oferta de mão de obra.
- Migrar de nuvem ou abrir uma célula em outra continua viável, porque o código não depende de serviços proprietários.

**Negativas / cuidados**
- sa-east-1 costuma ser mais cara que regiões dos EUA. A estimativa do 09 é de ordem de grandeza (≈ R$ 7 mil a R$ 16 mil/mês para produção + homologação, sem as mensagens) e deve ser refeita na calculadora antes do orçamento.
- Mensagens (WhatsApp/SMS) podem custar mais que a infraestrutura com volume alto: precisam entrar no preço dos planos.
- Abrir mão de serviços proprietários significa operar Keycloak e a fila de jobs (tabelas no PostgreSQL desde a v0.3) por conta própria.

## Alternativas consideradas

| Alternativa | Por que não (como referência do MVP) |
|---|---|
| Azure | Equivalente técnico; seria a escolha se a empresa já tivesse contrato e ecossistema Microsoft |
| Google Cloud | Equivalente técnico; menor base de profissionais e parceiros no mercado-alvo |
| Kubernetes gerenciado desde o início | Operação mais pesada que o ECS Fargate para um time pequeno; pode vir com mais serviços ou células |
