import 'package:decimal/decimal.dart';
import 'package:plataforma_os_depreciation/plataforma_os_depreciation.dart';
import 'package:test/test.dart';

Decimal d(String s) => Decimal.parse(s);

/// Memória F670 real do Senior (competência 10/2026), a mesma que vem de
/// exemplo no Painel de Depreciação. Só os campos não zerados.
F670Record territory() => F670Record(
  company: '1',
  assetCode: 'VEI001599-000',
  name: 'VEI001599-000 - TERRITORY 5DOORS SUV CH',
  date: parseBrDate('31/10/2026'),
  fields: const {
    'F670Cal.IofMes': '0,8287',
    'F670Cal.IogMes': '4,85',
    'F670Cal.VlrAnt': '219900',
    'F670Cal.VlrAtu': '219900',
    'F670Loc.VlrMio': '265355,37589',
    'F670Loc.QtdItm': '1',
    'F670Cal.DprMes': '3665',
    'F670Cal.CotDpm': '4422,5896',
    'F670Cal.TaxIof': '20',
    'F670Cal.DprAcu': '22967,33',
    'F670Cal.OldDprAcu': '19302,33',
    'F670Cal.CotDao': '27714,89483',
    'F670Cal.OldCotDao': '23292,30523',
    'F670Cal.CotDpg': '755,6701',
    'F670Cal.TaxIog': '20',
    'F670Loc.VlrMgr': '45340,20619',
    'F670Cal.CotDag': '4735,53263',
    'F670Cal.OldCotDag': '3979,86253',
    'F670Cal.PpiMes': '1,66666666666667',
  },
);

void main() {
  group('F670Record', () {
    test('lê números e datas no formato brasileiro', () {
      expect(parsePtBrDecimal('265355,37589'), d('265355.37589'));
      expect(parsePtBrDecimal('1.234,5'), d('1234.5'));
      expect(parsePtBrDecimal('1.234.567'), d('1234567'));
      expect(parsePtBrDecimal('1234.5'), d('1234.5'));
      expect(parsePtBrDecimal(r'R$ 12,30'), d('12.3'));
      expect(parsePtBrDecimal(''), Decimal.zero);
      expect(() => parsePtBrDecimal('abc'), throwsFormatException);
      expect(parseBrDate('31/10/2026'), const CalendarDate(2026, 10, 31));
      expect(() => parseBrDate('31/02/2026'), throwsFormatException);
    });

    test('descrição sem o código', () => expect(territory().description, 'TERRITORY 5DOORS SUV CH'));

    test('deduz o início pelo acumulado anterior: 23/04/2026, pró-rata', () {
      final start = territory().inferStart();
      expect(start.start, const CalendarDate(2026, 4, 23));
      expect(start.rule, StartRule.proRataDays);
    });
  });

  group('confere com a memória F670 do Senior (10/2026)', () {
    final memory = territory();
    final schedule = calculateDepreciation(memory.toAsset());
    final month = schedule.monthOf(memory.period)!;
    Decimal f(String field) => memory.value(field);

    test('bases em índice', () {
      expect(schedule.officialIndexValue, f('F670Loc.VlrMio'));
      expect(schedule.managerialIndexValue, f('F670Loc.VlrMgr'));
      expect(schedule.currentValue, f('F670Cal.VlrAtu'));
    });

    test('livro fiscal (conferência com o oficial do ERP)', () {
      expect(month.previousFiscalIndexTotal, f('F670Cal.OldCotDao'));
      expect(month.fiscalIndexQuota, f('F670Cal.CotDpm'));
      expect(month.fiscalIndexTotal, f('F670Cal.CotDao'));
      expect(month.previousFiscalTotal, f('F670Cal.OldDprAcu'));
      expect(month.fiscalAmount, f('F670Cal.DprMes'));
      expect(month.fiscalTotal, f('F670Cal.DprAcu'));
      expect(month.monthlyPercent, f('F670Cal.PpiMes'));
    });

    test('livro gerencial', () {
      expect(month.previousManagerialIndexTotal, f('F670Cal.OldCotDag'));
      expect(month.managerialIndexQuota, f('F670Cal.CotDpg'));
      expect(month.managerialIndexTotal, f('F670Cal.CotDag'));
    });
  });
}
