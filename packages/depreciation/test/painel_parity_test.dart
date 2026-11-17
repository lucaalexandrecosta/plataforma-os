import 'dart:convert';
import 'dart:io';

import 'package:decimal/decimal.dart';
import 'package:plataforma_os_depreciation/plataforma_os_depreciation.dart';
import 'package:test/test.dart';

/// Paridade com o motor JavaScript do Painel de Depreciação (`ENG.calcular`).
/// Os casos foram gerados por `tool/depreciation/fixtures_from_painel.mjs`.
///
/// O motor Dart calcula com frações exatas e o painel com `double`. Quando o
/// valor exato cai bem no meio de duas casas (ex.: cota de 18.241,189625), o
/// `double` do JavaScript pode arredondar para baixo e o Dart, como a função
/// Arredonda do Senior, arredonda para cima. Por isso o teste aceita, num
/// pequeno número de bens, cotas mensais diferentes em 1 na última casa, desde
/// que os totais no fim da vida útil sejam idênticos.
void main() {
  // Funciona rodando de dentro do pacote ou da raiz do repositório.
  final file = [
    'test/fixtures/painel_js.json',
    'packages/depreciation/test/fixtures/painel_js.json',
  ].map(File.new).firstWhere((f) => f.existsSync());
  final data = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
  final cases = (data['casos']! as List<Object?>).cast<Map<String, Object?>>();

  StartRule rule(String s) => switch (s) {
    'dias' => StartRule.proRataDays,
    'integral' => StartRule.fullMonth,
    'seguinte' => StartRule.nextMonth,
    _ => throw ArgumentError(s),
  };
  ManagerialMethod method(String s) => switch (s) {
    'linear' => ManagerialMethod.straightLine,
    'sda' => ManagerialMethod.sumOfYearsDigits,
    'sd' => ManagerialMethod.doubleDecliningBalance,
    'unidades' => ManagerialMethod.unitsOfProduction,
    _ => throw ArgumentError(s),
  };

  test('${cases.length} bens do painel dão o mesmo resultado no Dart', () {
    final differingCases = <String>[];
    for (final (i, c) in cases.indexed) {
      final input = (c['input']! as Map<String, Object?>).cast<String, String>();
      final disposal = input['dataBaixa']!;
      final asset = DepreciableAsset(
        acquisitionCost: Decimal.parse(input['valor']!),
        start: CalendarDate.parse(input['dataInicio']!),
        disposal: disposal.isEmpty ? null : CalendarDate.parse(disposal),
        startRule: rule(input['prorata']!),
        officialIndex: Decimal.parse(input['iof']!),
        managerialIndex: Decimal.parse(input['iog']!),
        fiscalRate: Decimal.parse(input['taxaFiscal']!),
        shifts: int.parse(input['turnos']!),
        fiscalResidual: Decimal.parse(input['residualFiscal']!),
        managerialMethod: method(input['metodoGer']!),
        managerialRate: Decimal.parse(input['taxaGer']!),
        managerialResidual: Decimal.parse(input['residualGer']!),
        totalCapacity: Decimal.parse(input['capacidade']!),
        monthlyProduction: Decimal.parse(input['producaoMes']!),
      );
      final schedule = calculateDepreciation(asset);
      final info = c['info']! as Map<String, Object?>;
      expect(schedule.officialIndexValue, Decimal.parse(info['vlrMio']! as String), reason: 'caso $i: VlrMio');
      expect(schedule.managerialIndexValue, Decimal.parse(info['vlrMgr']! as String), reason: 'caso $i: VlrMgr');

      final rows = (c['months']! as List<Object?>).map((r) => (r! as List<Object?>).cast<String>()).toList();
      if (rows.isEmpty) {
        expect(schedule.months, isEmpty, reason: 'caso $i: sem meses');
        continue;
      }
      List<Decimal> values(DepreciationMonth m) => [
        m.fiscalIndexQuota,
        m.fiscalIndexTotal,
        m.fiscalAmount,
        m.fiscalTotal,
        m.managerialIndexQuota,
        m.managerialIndexTotal,
        m.managerialAmount,
        m.managerialTotal,
      ];
      List<Decimal> expected(List<String> row) => row.skip(1).map(Decimal.parse).toList();
      Period period(String s) => Period(int.parse(s.substring(0, 4)), int.parse(s.substring(5)));

      var identical = true;
      for (final row in rows) {
        final m = schedule.monthOf(period(row[0]));
        if (m == null) {
          identical = false;
          // Só pode faltar mês no fim: a vida útil acabou um mês antes.
          expect(period(row[0]).key, greaterThan(schedule.months.last.period.key), reason: 'caso $i: ${row[0]}');
          continue;
        }
        final actual = values(m), exp = expected(row);
        for (var j = 0; j < actual.length; j += 2) {
          if (actual[j] == exp[j] && actual[j + 1] == exp[j + 1]) continue;
          identical = false;
          // No mês em que um dos dois motores fecha o saldo do livro, a cota é
          // o que falta para a base, e pode diferir mais que 1 na última casa.
          final finished = actual[j + 1] == values(schedule.months.last)[j + 1];
          final closing = finished || (j < 4 ? m.fiscalLastMonth : m.managerialLastMonth);
          final unit = Decimal.parse(j % 4 == 0 ? '0.00001' : '0.01');
          if (!closing) {
            expect(
              (actual[j] - exp[j]).abs() <= unit,
              isTrue,
              reason: 'caso $i ${row[0]}: cota ${actual[j]} × ${exp[j]}',
            );
          }
        }
      }
      // Totais no fim da vida útil (ou na baixa): sempre idênticos.
      final last = values(schedule.months.last), lastExp = expected(rows.last);
      for (final j in [1, 3, 5, 7]) {
        expect(last[j], lastExp[j], reason: 'caso $i: total final (coluna ${j + 1})');
      }
      if (!identical) differingCases.add('$i');
    }
    // Em 15/11/2026: 13 de 200 bens com alguma cota diferente em 1 na última
    // casa, todos com os mesmos totais finais. Mais que 10% indica mudança de
    // regra, não arredondamento.
    expect(differingCases.length, lessThanOrEqualTo(cases.length ~/ 10), reason: differingCases.join(', '));
  });

  test('arredonda o meio exato para cima, como o Senior (o painel em double erra aqui)', () {
    // Caso 62 dos fixtures: R$ 1.459.295,17 a 10% a.a. com 2 turnos.
    // Cota exata = 15 × 1.459.295,17 ÷ 1.200 = 18.241,189625.
    final schedule = calculateDepreciation(
      DepreciableAsset(
        acquisitionCost: Decimal.parse('1459295.17'),
        start: const CalendarDate(2020, 2, 2),
        startRule: StartRule.fullMonth,
        fiscalRate: Decimal.fromInt(10),
        shifts: 2,
      ),
    );
    expect(schedule.months.first.fiscalIndexQuota, Decimal.parse('18241.18963'));
  });
}
