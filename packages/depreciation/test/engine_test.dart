import 'package:decimal/decimal.dart';
import 'package:plataforma_os_depreciation/plataforma_os_depreciation.dart';
import 'package:rational/rational.dart';
import 'package:test/test.dart';

Decimal d(String s) => Decimal.parse(s);

DepreciableAsset asset({
  String cost = '12000',
  CalendarDate start = const CalendarDate(2026, 1, 1),
  CalendarDate? disposal,
  StartRule rule = StartRule.fullMonth,
  String rate = '10',
  int shifts = 1,
  String residual = '0',
  ManagerialMethod method = ManagerialMethod.straightLine,
  String managerialRate = '10',
  String managerialResidual = '0',
  String capacity = '0',
  String production = '0',
}) => DepreciableAsset(
  acquisitionCost: d(cost),
  start: start,
  disposal: disposal,
  startRule: rule,
  fiscalRate: d(rate),
  shifts: shifts,
  fiscalResidual: d(residual),
  managerialMethod: method,
  managerialRate: d(managerialRate),
  managerialResidual: d(managerialResidual),
  totalCapacity: d(capacity),
  monthlyProduction: d(production),
);

void main() {
  test('roundTo: meio para longe do zero', () {
    expect(roundTo(Rational.parse('2.5'), 0), Rational.fromInt(3));
    expect(roundTo(Rational.parse('-2.5'), 0), Rational.fromInt(-3));
    expect(roundTo(Rational.parse('1.234565'), 5), Rational.parse('1.23457'));
    expect(roundTo(Rational.parse('1.234564999'), 5), Rational.parse('1.23456'));
  });

  test('Period e CalendarDate', () {
    expect(Period.fromKey(const Period(2026, 12).key + 1), const Period(2027, 1));
    expect(Period.daysIn(2024, 2), 29);
    expect(Period.daysIn(2100, 2), 28);
    expect(CalendarDate.parse('2026-02-28').period, const Period(2026, 2));
    expect(() => CalendarDate.parse('2026-02-29'), throwsFormatException);
  });

  group('linear', () {
    test('R\$ 12.000 a 10% a.a.: R\$ 100 por mês por 120 meses', () {
      final s = calculateDepreciation(asset());
      expect(s.months, hasLength(120));
      expect(s.months.first.fiscalAmount, d('100'));
      expect(s.months.last.period, const Period(2035, 12));
      expect(s.months.last.fiscalTotal, d('12000'));
      expect(s.months.last.fiscalNetBookValue, Decimal.zero);
      expect(s.months.last.fiscalLastMonth, isTrue);
    });

    test('pró-rata: começa em 21/01 (11 de 31 dias) e termina com o resto em 01/2036', () {
      final s = calculateDepreciation(asset(start: const CalendarDate(2026, 1, 21), rule: StartRule.proRataDays));
      expect(s.months.first.fraction, Rational.fromInt(11, 31));
      expect(s.months.first.fiscalAmount, d('35.48'));
      expect(s.months, hasLength(121));
      expect(s.months.last.period, const Period(2036, 1));
      expect(s.months.last.fiscalTotal, d('12000'));
    });

    test('mês seguinte: começa em fevereiro', () {
      final s = calculateDepreciation(asset(start: const CalendarDate(2026, 1, 21), rule: StartRule.nextMonth));
      expect(s.months.first.period, const Period(2026, 2));
    });

    test('turnos: 2 turnos = coeficiente 1,5', () {
      final s = calculateDepreciation(asset(shifts: 2));
      expect(s.effectiveFiscalRate, d('15'));
      expect(s.months.first.fiscalAmount, d('150'));
      expect(s.months.lastWhere((m) => m.fiscalLastMonth).period, const Period(2032, 8)); // 80 meses
    });

    test('residual não deprecia', () {
      final s = calculateDepreciation(asset(residual: '2000', managerialResidual: '2000'));
      expect(s.months.last.fiscalTotal, d('10000'));
      expect(s.months.last.managerialTotal, d('10000'));
      expect(s.months.last.fiscalNetBookValue, d('2000'));
    });

    test('baixa em 10/03/2026: pró-rata no mês da baixa e para', () {
      final s = calculateDepreciation(asset(disposal: const CalendarDate(2026, 3, 10)));
      expect(s.months, hasLength(3));
      expect(s.months.last.disposedThisMonth, isTrue);
      expect(s.months.last.fraction, Rational.fromInt(10, 31));
      expect(s.months.last.fiscalAmount, d('32.26'));
    });

    test('custo zero não gera memória', () {
      expect(calculateDepreciation(asset(cost: '0')).months, isEmpty);
    });

    test('índice: valores em índice e em reais', () {
      final s = calculateDepreciation(
        DepreciableAsset(
          acquisitionCost: d('219900'),
          start: const CalendarDate(2026, 5, 1),
          startRule: StartRule.fullMonth,
          officialIndex: d('0.8287'),
          fiscalRate: d('20'),
        ),
      );
      expect(s.officialIndexValue, d('265355.37589'));
      expect(s.months.first.fiscalIndexQuota, d('4422.5896'));
      expect(s.months.first.fiscalAmount, d('3665'));
    });
  });

  group('livro gerencial', () {
    test('soma dos dígitos: vida de 5 anos, pesos 5/15 a 1/15', () {
      final s = calculateDepreciation(
        asset(cost: '15000', method: ManagerialMethod.sumOfYearsDigits, managerialRate: '20'),
      );
      expect(s.months.first.managerialAmount, d('416.67')); // 15.000 × 5/15 ÷ 12
      expect(s.months.first.managerialRule, 'ano 1: 5/15');
      expect(s.monthOf(const Period(2030, 1))!.managerialRule, 'ano 5: 1/15');
      expect(s.monthOf(const Period(2030, 1))!.managerialAmount, d('83.33'));
      final last = s.months.lastWhere((m) => m.managerialLastMonth);
      expect(last.managerialTotal, d('15000'));
    });

    test('saldo decrescente: dobro da taxa e troca para linear no fim', () {
      final s = calculateDepreciation(
        asset(cost: '12000', method: ManagerialMethod.doubleDecliningBalance, managerialRate: '20'),
      );
      expect(s.months.first.managerialAmount, d('400')); // 12.000 × 40% ÷ 12
      expect(s.months.first.managerialRule, 'saldo decrescente 40.0% a.a.');
      expect(s.months.any((m) => m.managerialRule == 'troca p/ linear no saldo'), isTrue);
      final last = s.months.lastWhere((m) => m.managerialLastMonth);
      expect(last.managerialTotal, d('12000'));
    });

    test('unidades produzidas: 500 de 10.000 por mês', () {
      final s = calculateDepreciation(
        asset(method: ManagerialMethod.unitsOfProduction, capacity: '10000', production: '500'),
      );
      expect(s.months.first.managerialAmount, d('600'));
      expect(s.months.where((m) => m.managerialAmount > Decimal.zero), hasLength(20));
    });
  });
}
