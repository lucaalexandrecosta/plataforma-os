# Validação do `schema.sql`

Executa o [schema.sql](../schema.sql) num PostgreSQL 18 real e roda as checagens estruturais e os testes funcionais de isolamento e regras. O PostgreSQL usado é o PGlite, compilado para WebAssembly, que roda dentro do Node. Não precisa de servidor nem de Docker.

| Arquivo | O que faz |
|---|---|
| `validate-schema.mjs` | Executa o DDL num banco vazio e checa: toda tabela de tenant com RLS ENABLE + FORCE + política; nenhuma FK entre tabelas de tenant sem `tenant_id`; FKs sem índice; papéis e grants; funções SECURITY DEFINER com `search_path` fixo; triggers de `updated_at` e `row_version` |
| `schema-tests.mjs` | 42 testes funcionais: isolamento entre tenants, QR, numeração, máquinas de estado, alocação, etiquetas, apontamentos, campos do ERP, filas do worker, prestadores, custos, planos, medidores, valores em centavos, modo TV, auditoria |

| `validate-seed.mjs` | Executa a migração inicial do dbmate e o [seed de desenvolvimento](../seeds/dev_seed.sql) (duas vezes, para provar a idempotência) e confere o isolamento com os dados do seed: RLS por tenant, falha fechada sem tenant, troca de tenant, `find_user_by_idp_subject`, QR e permissões |

Atalho para tudo (instala o PGlite na primeira vez e confere se a migração inicial está em dia com o `schema.sql`):

```bash
node tool/db/validate_all.mjs
```

## Como rodar

Requer Node.js 20+.

```bash
npm install --prefix ./.pglite @electric-sql/pglite@0.5.8
```

```bash
node db/validacao/validate-schema.mjs ./.pglite/node_modules/@electric-sql/pglite db/schema.sql db/validacao/schema-tests.mjs
```

A saída esperada é `OK: schema.sql executou sem erros`, `[RLS] ... 0`, `[FK] ... 0` e `[TESTES FUNCIONAIS] 42 passaram, 0 falharam`.

## No CI

Rodar a cada PR que mexa em `db/`. A mesma bateria deve rodar também contra o PostgreSQL de homologação, com as migrações do dbmate aplicadas do zero: o PGlite não substitui o teste no banco real, mas pega erro de DDL e de RLS em segundos. Quando o servidor Serverpod existir, os testes de isolamento passam a rodar também pelo `serverpod_test` (spike S1).
