# plataforma_os_depreciation

Motor de depreciação em Dart puro, portado do Painel de Depreciação (HTML) e conferido com a memória de cálculo **F670 do ERP Senior**.

- **Mesmo cálculo na tela e no servidor:** o backoffice (Flutter Web) usa para recalcular na hora; o servidor usa para fechar a competência.
- **Sem `double`:** as contas são feitas com frações exatas (`rational`) e arredondadas nos mesmos pontos da F670 (5 casas em índice, 2 em reais, meio para longe do zero). Entradas e saídas são `Decimal`.
- **Livros:** gerencial (linear, soma dos dígitos, saldo decrescente, unidades produzidas), que é o livro da plataforma, e fiscal (linear com coeficiente de turnos), usado só para conferir com o Senior, que continua sendo o livro oficial.

```dart
final memory = F670Record(/* campos do XML da F670 */);
final schedule = calculateDepreciation(memory.toAsset());
final october = schedule.monthOf(const Period(2026, 10));
```

## Testes

```sh
dart test packages/depreciation
```

| Arquivo | O que prova |
|---|---|
| `test/f670_test.dart` | Uma memória F670 real (10/2026) bate campo a campo: VlrMio, CotDpm, CotDao, DprMes, DprAcu, CotDpg, CotDag, PpiMes |
| `test/painel_parity_test.dart` | 200 bens pseudoaleatórios dão o mesmo resultado que o motor JavaScript do painel. Em 13 deles uma cota mensal difere em 1 na última casa, porque o painel usa `double`; os totais finais são sempre idênticos |
| `test/engine_test.dart` | Regras: pró-rata, mês seguinte, turnos, residual, baixa, índice e os quatro métodos gerenciais |

Os casos de paridade são gerados por `tool/depreciation/fixtures_from_painel.mjs`, a partir do HTML do painel:

```sh
node tool/depreciation/fixtures_from_painel.mjs "Painel de Depreciação.html"
```

## Diferenças em relação ao painel

1. **Arredondamento exato.** Quando o valor cai exatamente no meio (ex.: cota de 18.241,189625), o painel às vezes arredonda para baixo por erro de `double`; aqui arredonda para cima, como a função Arredonda do Senior.
2. **% da parcela do mês (PpiMes):** taxa fiscal efetiva ÷ 12 × fração do mês, que é o que a F670 grava (1,66666666666667 a 20% a.a.). O painel calculava (cota × índice) ÷ valor atual e dava 1,66666666735789.
