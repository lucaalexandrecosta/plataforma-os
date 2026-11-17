import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:rational/rational.dart';

/// Como a depreciação começa no mês de início do bem.
enum StartRule {
  /// Pró-rata pelos dias restantes do primeiro mês.
  proRataDays,

  /// Mês integral, mesmo começando no meio do mês.
  fullMonth,

  /// Começa só no mês seguinte.
  nextMonth,
}

/// Método do livro gerencial (o livro fiscal é sempre linear).
enum ManagerialMethod {
  /// Linha reta: taxa anual sobre a base depreciável.
  straightLine,

  /// Soma dos dígitos dos anos (decrescente).
  sumOfYearsDigits,

  /// Saldo decrescente com o dobro da taxa, trocando para linear quando ela
  /// passa a dar uma cota maior.
  doubleDecliningBalance,

  /// Unidades produzidas no mês ÷ capacidade total.
  unitsOfProduction,
}

/// Competência (ano e mês). [key] = ano × 12 + (mês − 1), para comparar e
/// somar meses sem lidar com virada de ano.
@immutable
final class Period implements Comparable<Period> {
  const Period(this.year, this.month) : assert(month >= 1 && month <= 12);

  factory Period.fromKey(int key) => Period(key ~/ 12, key % 12 + 1);

  final int year;
  final int month;

  int get key => year * 12 + (month - 1);

  int get daysInMonth => daysIn(year, month);

  static int daysIn(int year, int month) {
    const days = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
    if (month == 2 && (year % 4 == 0 && (year % 100 != 0 || year % 400 == 0))) return 29;
    return days[month - 1];
  }

  @override
  int compareTo(Period other) => key.compareTo(other.key);

  @override
  bool operator ==(Object other) => other is Period && other.key == key;

  @override
  int get hashCode => key;

  /// `2026-10`
  @override
  String toString() => '$year-${month.toString().padLeft(2, '0')}';
}

/// Data simples (sem hora nem fuso), como no cadastro do bem.
@immutable
final class CalendarDate {
  const CalendarDate(this.year, this.month, this.day);

  /// `2026-10-31`
  factory CalendarDate.parse(String iso) {
    final parts = iso.split('-');
    if (parts.length != 3) throw FormatException('Data inválida (esperado AAAA-MM-DD)', iso);
    final y = int.parse(parts[0]), m = int.parse(parts[1]), d = int.parse(parts[2]);
    if (m < 1 || m > 12 || d < 1 || d > Period.daysIn(y, m)) throw FormatException('Data inválida', iso);
    return CalendarDate(y, m, d);
  }

  final int year;
  final int month;
  final int day;

  Period get period => Period(year, month);

  @override
  bool operator ==(Object other) =>
      other is CalendarDate && other.year == year && other.month == month && other.day == day;

  @override
  int get hashCode => Object.hash(year, month, day);

  @override
  String toString() => '$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';
}

/// Dados do bem que entram no cálculo. Valores em reais e taxas em % ao ano,
/// todos como [Decimal] (sem `double`): o motor calcula com frações exatas e
/// arredonda nos mesmos pontos da memória F670 do Senior.
@immutable
final class DepreciableAsset {
  DepreciableAsset({
    required this.acquisitionCost,
    required this.start,
    this.disposal,
    this.startRule = StartRule.proRataDays,
    this.quantity = 1,
    Decimal? officialIndex,
    Decimal? managerialIndex,
    Decimal? fiscalRate,
    this.shifts = 1,
    Decimal? fiscalResidual,
    this.managerialMethod = ManagerialMethod.straightLine,
    Decimal? managerialRate,
    Decimal? managerialResidual,
    Decimal? totalCapacity,
    Decimal? monthlyProduction,
  }) : officialIndex = _positiveOrOne(officialIndex),
       managerialIndex = _positiveOrOne(managerialIndex),
       fiscalRate = fiscalRate ?? Decimal.zero,
       fiscalResidual = fiscalResidual ?? Decimal.zero,
       managerialRate = managerialRate ?? Decimal.zero,
       managerialResidual = managerialResidual ?? Decimal.zero,
       totalCapacity = totalCapacity ?? Decimal.zero,
       monthlyProduction = monthlyProduction ?? Decimal.zero {
    if (shifts < 1 || shifts > 3) throw ArgumentError.value(shifts, 'shifts', 'turnos de 1 a 3');
  }

  /// Custo de aquisição total do bem, em reais.
  final Decimal acquisitionCost;

  /// Informativa: o custo já é o total.
  final int quantity;

  /// Início da depreciação.
  final CalendarDate start;

  /// Data de baixa: a depreciação para nesse dia (pró-rata no mês da baixa).
  final CalendarDate? disposal;

  final StartRule startRule;

  /// Cotação do índice oficial (F670Cal.IofMes). 1 quando o bem é em reais.
  final Decimal officialIndex;

  /// Cotação do índice gerencial (F670Cal.IogMes).
  final Decimal managerialIndex;

  /// Taxa fiscal anual em %, antes do coeficiente de turnos.
  final Decimal fiscalRate;

  /// Turnos de operação: 1 (coef. 1,0), 2 (1,5) ou 3 (2,0).
  final int shifts;

  final Decimal fiscalResidual;
  final ManagerialMethod managerialMethod;

  /// Taxa gerencial anual em %. A vida útil é 100 ÷ taxa.
  final Decimal managerialRate;

  final Decimal managerialResidual;

  /// Só para [ManagerialMethod.unitsOfProduction].
  final Decimal totalCapacity;

  /// Só para [ManagerialMethod.unitsOfProduction].
  final Decimal monthlyProduction;

  static Decimal _positiveOrOne(Decimal? v) => (v == null || v <= Decimal.zero) ? Decimal.one : v;
}

/// Uma competência da memória de cálculo. Valores em índice com 5 casas e em
/// reais com 2, como na F670. Os nomes entre parênteses são os campos da F670.
@immutable
final class DepreciationMonth {
  const DepreciationMonth({
    required this.period,
    required this.fraction,
    required this.disposedThisMonth,
    required this.previousFiscalIndexTotal,
    required this.fiscalIndexQuota,
    required this.fiscalIndexTotal,
    required this.previousFiscalTotal,
    required this.fiscalAmount,
    required this.fiscalTotal,
    required this.fiscalNetBookValue,
    required this.previousManagerialIndexTotal,
    required this.managerialIndexQuota,
    required this.managerialIndexTotal,
    required this.previousManagerialTotal,
    required this.managerialAmount,
    required this.managerialTotal,
    required this.managerialNetBookValue,
    required this.monthlyPercent,
    required this.managerialRule,
    required this.fiscalLastMonth,
    required this.managerialLastMonth,
  });

  final Period period;

  /// Parte do mês depreciada (1 no mês cheio; menor no início pró-rata e na baixa).
  final Rational fraction;

  final bool disposedThisMonth;

  /// Acumulada anterior em índice oficial (OldCotDao).
  final Decimal previousFiscalIndexTotal;

  /// Cota do mês em índice oficial (CotDpm).
  final Decimal fiscalIndexQuota;

  /// Acumulada em índice oficial (CotDao).
  final Decimal fiscalIndexTotal;

  /// Acumulada anterior em reais (OldDprAcu).
  final Decimal previousFiscalTotal;

  /// Depreciação do mês em reais (DprMes).
  final Decimal fiscalAmount;

  /// Acumulada em reais (DprAcu).
  final Decimal fiscalTotal;

  final Decimal fiscalNetBookValue;

  /// Acumulada anterior em índice gerencial (OldCotDag).
  final Decimal previousManagerialIndexTotal;

  /// Cota do mês em índice gerencial (CotDpg).
  final Decimal managerialIndexQuota;

  /// Acumulada em índice gerencial (CotDag).
  final Decimal managerialIndexTotal;

  final Decimal previousManagerialTotal;
  final Decimal managerialAmount;
  final Decimal managerialTotal;
  final Decimal managerialNetBookValue;

  /// % do bem depreciado no mês (PpiMes): taxa fiscal efetiva ÷ 12 × fração
  /// do mês, 14 casas. É a base do crédito de PIS/COFINS/CSLL na F670.
  ///
  /// O painel calculava (cota × índice) ÷ valor atual × 100, que arredonda
  /// diferente do Senior (1,66666666735789 contra 1,66666666666667 na memória
  /// de exemplo); aqui segue o Senior.
  final Decimal monthlyPercent;

  /// Como a cota gerencial foi obtida (ex.: `ano 2: 4/15`, `linear`).
  final String managerialRule;

  final bool fiscalLastMonth;
  final bool managerialLastMonth;
}

/// Resultado do cálculo: bases e a memória mês a mês até o fim da vida útil
/// dos dois livros ou até a baixa.
@immutable
final class DepreciationSchedule {
  const DepreciationSchedule({
    required this.officialIndexValue,
    required this.managerialIndexValue,
    required this.currentValue,
    required this.managerialCurrentValue,
    required this.fullFiscalIndexQuota,
    required this.effectiveFiscalRate,
    required this.shiftCoefficient,
    required this.months,
  });

  /// Valor do bem em índice oficial (F670Loc.VlrMio).
  final Decimal officialIndexValue;

  /// Valor do bem em índice gerencial (F670Loc.VlrMgr).
  final Decimal managerialIndexValue;

  /// Valor atual em reais (F670Cal.VlrAtu).
  final Decimal currentValue;
  final Decimal managerialCurrentValue;

  /// Cota mensal cheia em índice oficial, sem arredondar (TaxIof × VlrMio ÷ 12 ÷ 100).
  final Rational fullFiscalIndexQuota;

  /// Taxa fiscal × coeficiente de turnos (TaxIof).
  final Decimal effectiveFiscalRate;
  final Decimal shiftCoefficient;

  final List<DepreciationMonth> months;

  /// Linha da competência, ou `null` se o bem não deprecia nela.
  DepreciationMonth? monthOf(Period period) {
    for (final m in months) {
      if (m.period == period) return m;
    }
    return null;
  }
}

final _r0 = Rational.zero;
final _r1 = Rational.one;
final _r12 = Rational.fromInt(12);
final _r100 = Rational.fromInt(100);

/// Arredonda(x; casas) da F670: meio para longe do zero, sobre a fração exata.
Rational roundTo(Rational x, int places) {
  final factor = Rational(BigInt.from(10).pow(places));
  return Rational((x * factor).round(), factor.numerator);
}

Decimal _dec(Rational x, int places) => roundTo(x, places).toDecimal(scaleOnInfinitePrecision: places);

Rational _max(Rational a, Rational b) => a >= b ? a : b;

Rational _min(Rational a, Rational b) => a <= b ? a : b;

/// Calcula a memória de depreciação do bem.
///
/// Espelha o motor do Painel de Depreciação (`ENG.calcular`), com uma
/// diferença deliberada: aqui as contas são feitas com frações exatas em vez de
/// `double`, então os arredondamentos de 5 e 2 casas não dependem de erro de
/// ponto flutuante.
DepreciationSchedule calculateDepreciation(DepreciableAsset asset) {
  final cost = asset.acquisitionCost.toRational();
  final iof = asset.officialIndex.toRational();
  final iog = asset.managerialIndex.toRational();
  final coef = switch (asset.shifts) {
    2 => Rational.fromInt(3, 2),
    3 => Rational.fromInt(2),
    _ => _r1,
  };
  final fiscalRate = asset.fiscalRate.toRational() * coef;
  final managerialRate = asset.managerialRate.toRational();
  final usefulLifeYears = managerialRate > _r0 ? _r100 / managerialRate : _r0;

  final vlrMio = roundTo(cost / iof, 5);
  final vlrMgr = roundTo(cost / iog, 5);
  final residualF = roundTo(asset.fiscalResidual.toRational() / iof, 5);
  final residualG = roundTo(asset.managerialResidual.toRational() / iog, 5);
  final vlrAtu = roundTo(vlrMio * iof, 5);
  final vlrAtuG = roundTo(vlrMgr * iog, 5);
  final depreciableF = _max(_r0, vlrMio - residualF);
  final depreciableG = _max(_r0, vlrMgr - residualG);

  final fullQuotaF = fiscalRate * vlrMio / _r12 / _r100;
  final straightQuotaG = managerialRate * depreciableG / _r12 / _r100;

  final months = <DepreciationMonth>[];
  DepreciationSchedule result() => DepreciationSchedule(
    officialIndexValue: _dec(vlrMio, 5),
    managerialIndexValue: _dec(vlrMgr, 5),
    currentValue: _dec(vlrAtu, 5),
    managerialCurrentValue: _dec(vlrAtuG, 5),
    fullFiscalIndexQuota: fullQuotaF,
    effectiveFiscalRate: fiscalRate.toDecimal(scaleOnInfinitePrecision: 10),
    shiftCoefficient: coef.toDecimal(scaleOnInfinitePrecision: 1),
    months: List.unmodifiable(months),
  );

  if (cost <= _r0) return result();

  final start = asset.start;
  var startKey = start.period.key;
  var startFraction = _r1;
  final firstMonthDays = Period.daysIn(start.year, start.month);
  switch (asset.startRule) {
    case StartRule.proRataDays:
      startFraction = Rational.fromInt(firstMonthDays - start.day + 1, firstMonthDays);
    case StartRule.nextMonth:
      startKey += 1;
    case StartRule.fullMonth:
      break;
  }
  final disposal = asset.disposal;
  final disposalKey = disposal?.period.key;

  var accF = _r0, accFR = _r0, accG = _r0, accGR = _r0, usedMonths = _r0;
  final capacity = asset.totalCapacity.toRational();
  final production = asset.monthlyProduction.toRational();

  // Limite de segurança: 1.500 meses (125 anos), o mesmo do painel.
  for (var k = startKey, i = 0; i < 1500; k++, i++) {
    final period = Period.fromKey(k);
    var fraction = k == startKey ? startFraction : _r1;
    var disposed = false;
    if (disposalKey != null) {
      if (k > disposalKey) break;
      if (k == disposalKey) {
        fraction = _min(fraction, Rational.fromInt(disposal!.day, period.daysInMonth));
        disposed = true;
      }
    }
    final doneF = accF >= depreciableF;
    final doneG = accG >= depreciableG;
    if (doneF && doneG) break;

    // ---------- Livro fiscal ----------
    final oldCotDao = accF, oldDprAcu = accFR;
    var cotDpm = doneF ? _r0 : roundTo(fullQuotaF * fraction, 5);
    var lastF = false;
    if (!doneF && accF + cotDpm >= depreciableF) {
      cotDpm = roundTo(depreciableF - accF, 5);
      lastF = true;
    }
    var dprMes = roundTo(cotDpm * iof, 2);
    if (lastF) dprMes = roundTo(roundTo(depreciableF * iof, 2) - accFR, 2);
    accF = roundTo(accF + cotDpm, 5);
    accFR = roundTo(accFR + dprMes, 2);

    // ---------- Livro gerencial ----------
    final oldCotDag = accG, oldDagR = accGR;
    var cotDpg = _r0;
    var rule = '';
    if (!doneG) {
      final year = (usedMonths / _r12).floor().toInt() + 1;
      switch (asset.managerialMethod) {
        case ManagerialMethod.sumOfYearsDigits when usefulLifeYears > _r0:
          final n = usefulLifeYears.ceil().toInt();
          final sum = n * (n + 1) ~/ 2;
          final weight = n - year + 1 > 0 ? n - year + 1 : 0;
          cotDpg = depreciableG * Rational.fromInt(weight, sum) / _r12 * fraction;
          rule = 'ano $year: $weight/$sum';
        case ManagerialMethod.doubleDecliningBalance when usefulLifeYears > _r0:
          final rate = Rational.fromInt(2) / usefulLifeYears;
          final declining = (vlrMgr - accG) * rate / _r12;
          final remaining = _max(_r1, usefulLifeYears * _r12 - usedMonths);
          final linear = (depreciableG - accG) / remaining;
          cotDpg = _max(declining, linear) * fraction;
          rule = declining >= linear
              ? 'saldo decrescente ${_dec(rate * _r100, 1).toStringAsFixed(1)}% a.a.'
              : 'troca p/ linear no saldo';
        case ManagerialMethod.unitsOfProduction when capacity > _r0:
          cotDpg = depreciableG * (production * fraction) / capacity;
          rule = '${_dec(production * fraction, 5)} de ${asset.totalCapacity} un.';
        default:
          cotDpg = straightQuotaG * fraction;
          rule = 'linear';
      }
      cotDpg = roundTo(cotDpg, 5);
    }
    var lastG = false;
    if (!doneG && accG + cotDpg >= depreciableG) {
      cotDpg = roundTo(depreciableG - accG, 5);
      lastG = true;
    }
    var dprMesG = roundTo(cotDpg * iog, 2);
    if (lastG) dprMesG = roundTo(roundTo(depreciableG * iog, 2) - accGR, 2);
    accG = roundTo(accG + cotDpg, 5);
    accGR = roundTo(accGR + dprMesG, 2);

    usedMonths += fraction;
    months.add(
      DepreciationMonth(
        period: period,
        fraction: fraction,
        disposedThisMonth: disposed,
        previousFiscalIndexTotal: _dec(oldCotDao, 5),
        fiscalIndexQuota: _dec(cotDpm, 5),
        fiscalIndexTotal: _dec(accF, 5),
        previousFiscalTotal: _dec(oldDprAcu, 2),
        fiscalAmount: _dec(dprMes, 2),
        fiscalTotal: _dec(accFR, 2),
        fiscalNetBookValue: _dec(vlrAtu - accFR, 2),
        previousManagerialIndexTotal: _dec(oldCotDag, 5),
        managerialIndexQuota: _dec(cotDpg, 5),
        managerialIndexTotal: _dec(accG, 5),
        previousManagerialTotal: _dec(oldDagR, 2),
        managerialAmount: _dec(dprMesG, 2),
        managerialTotal: _dec(accGR, 2),
        managerialNetBookValue: _dec(vlrAtuG - accGR, 2),
        monthlyPercent: doneF ? Decimal.zero : _dec(fiscalRate / _r12 * fraction, 14),
        managerialRule: rule,
        fiscalLastMonth: lastF,
        managerialLastMonth: lastG,
      ),
    );
    if (disposed) break;
  }
  return result();
}
