import 'package:decimal/decimal.dart';
import 'package:meta/meta.dart';
import 'package:rational/rational.dart';

import 'engine.dart';

/// Um registro da memória de cálculo F670 do ERP Senior (um bem numa
/// competência), com os campos como vêm no XML: `"F670Cal.CotDpm"` →
/// `"4422,5896"`.
///
/// Serve para importar bens do Senior e para conferir o nosso cálculo com o do
/// ERP. Na plataforma, a depreciação é gerencial; o livro oficial continua
/// sendo o do Senior.
@immutable
final class F670Record {
  F670Record({
    required this.company,
    required this.assetCode,
    required this.name,
    required this.date,
    required Map<String, String> fields,
  }) : fields = Map.unmodifiable(fields);

  /// Código da empresa no Senior.
  final String company;

  /// Código do bem (ex.: `VEI001599-000`).
  final String assetCode;

  /// Nome como vem no XML (ex.: `VEI001599-000 - TERRITORY 5DOORS SUV CH`).
  final String name;

  /// Data do cálculo (último dia da competência).
  final CalendarDate date;

  final Map<String, String> fields;

  Period get period => date.period;

  /// Descrição sem o código na frente.
  String get description {
    final i = name.indexOf(' - ');
    return i < 0 ? name : name.substring(i + 3);
  }

  /// Valor numérico de um campo; campo ausente ou vazio vale zero.
  Decimal value(String field) => parsePtBrDecimal(fields[field] ?? '');

  Decimal _firstNonZero(List<String> keys) {
    for (final k in keys) {
      final v = value(k);
      if (v != Decimal.zero) return v;
    }
    return Decimal.zero;
  }

  /// Data em que a depreciação começou, deduzida do acumulado anterior em
  /// índice (OldCotDao ÷ cota cheia = meses já depreciados). O XML da F670 não
  /// traz a data de aquisição; confirme no cadastro do bem.
  ({CalendarDate start, StartRule rule}) inferStart() {
    final rate = _firstNonZero(['F670Cal.TaxIof', 'F670Loc.TaxIof']).toRational();
    final quota = rate * value('F670Loc.VlrMio').toRational() / Rational.fromInt(1200);
    if (quota <= Rational.zero) {
      return (start: CalendarDate(date.year, date.month, 1), rule: StartRule.fullMonth);
    }
    final used = value('F670Cal.OldCotDao').toRational() / quota;
    // Tolerâncias do painel: o acumulado vem arredondado a 5 casas mês a mês.
    final whole = (used + Rational.fromInt(1, 1000000)).floor().toInt();
    final partial = used - Rational.fromInt(whole);
    var key = period.key - whole;
    if (partial > Rational.fromInt(1, 10000)) {
      key -= 1;
      final p = Period.fromKey(key);
      final dm = p.daysInMonth;
      final day = dm - (partial * Rational.fromInt(dm)).round().toInt() + 1;
      return (start: CalendarDate(p.year, p.month, day), rule: StartRule.proRataDays);
    }
    final p = Period.fromKey(key);
    return (start: CalendarDate(p.year, p.month, 1), rule: StartRule.fullMonth);
  }

  /// Monta o bem para o motor com os valores da F670 e o início deduzido.
  DepreciableAsset toAsset() {
    final iof = value('F670Cal.IofMes');
    final fiscalRate = _firstNonZero(['F670Cal.TaxIof', 'F670Loc.TaxIof']);
    var cost = value('F670Cal.VlrAtu');
    if (cost == Decimal.zero) {
      final iofOrOne = iof == Decimal.zero ? Decimal.one : iof;
      cost = (value('F670Loc.VlrMio') * iofOrOne).round(scale: 2);
    }
    final quantity = value('F670Loc.QtdItm').toBigInt().toInt();
    final managerialRate = _firstNonZero(['F670Cal.TaxIog', 'F670Loc.TaxIog']);
    final start = inferStart();
    return DepreciableAsset(
      acquisitionCost: cost,
      quantity: quantity < 1 ? 1 : quantity,
      start: start.start,
      startRule: start.rule,
      officialIndex: iof,
      managerialIndex: value('F670Cal.IogMes'),
      fiscalRate: fiscalRate,
      managerialRate: managerialRate == Decimal.zero ? fiscalRate : managerialRate,
    );
  }
}

/// `"265355,37589"` → 265355.37589; `"1.234,5"` → 1234.5; `"1234.5"` → 1234.5.
/// Aceita `R$`, `%` e espaços. Texto vazio vale zero; texto inválido lança
/// [FormatException].
Decimal parsePtBrDecimal(String input) {
  var s = input.replaceAll(RegExp(r'\s|R\$|%'), '');
  if (s.isEmpty) return Decimal.zero;
  if (s.contains(',')) {
    s = s.replaceAll('.', '').replaceFirst(',', '.');
  } else if (RegExp(r'^-?\d{1,3}(\.\d{3})+$').hasMatch(s)) {
    s = s.replaceAll('.', '');
  }
  final v = Decimal.tryParse(s);
  if (v == null) throw FormatException('Número inválido', input);
  return v;
}

/// `"31/10/2026"` → 2026-10-31.
CalendarDate parseBrDate(String input) {
  final parts = input.trim().split('/');
  if (parts.length != 3) throw FormatException('Data inválida (esperado DD/MM/AAAA)', input);
  return CalendarDate.parse('${parts[2]}-${parts[1].padLeft(2, '0')}-${parts[0].padLeft(2, '0')}');
}
