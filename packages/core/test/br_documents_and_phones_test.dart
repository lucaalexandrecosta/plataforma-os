import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:test/test.dart';

void main() {
  group('CPF', () {
    test('válidos, com e sem máscara', () {
      expect(BrDocuments.isValidCpf('529.982.247-25'), isTrue);
      expect(BrDocuments.isValidCpf('52998224725'), isTrue);
      expect(BrDocuments.isValidCpf('111.444.777-35'), isTrue);
    });
    test('dígito errado, repetidos, tamanho errado', () {
      expect(BrDocuments.isValidCpf('529.982.247-24'), isFalse);
      expect(BrDocuments.isValidCpf('111.111.111-11'), isFalse);
      expect(BrDocuments.isValidCpf('5299822472'), isFalse);
      expect(BrDocuments.isValidCpf('5299822472A'), isFalse);
    });
  });

  group('CNPJ', () {
    test('numérico (formato antigo continua válido)', () {
      expect(BrDocuments.isValidCnpj('11.222.333/0001-81'), isTrue);
      expect(BrDocuments.isValidCnpj('11222333000181'), isTrue);
      expect(BrDocuments.isValidCnpj('11.222.333/0001-80'), isFalse);
      expect(BrDocuments.isValidCnpj('00.000.000/0000-00'), isFalse);
    });
    test('alfanumérico (exemplo oficial da Receita)', () {
      expect(BrDocuments.isValidCnpj('12.ABC.345/01DE-35'), isTrue);
      expect(BrDocuments.isValidCnpj('12abc34501de35'), isTrue, reason: 'normaliza para maiúsculas');
      expect(BrDocuments.isValidCnpj('12.ABC.345/01DE-36'), isFalse);
      expect(BrDocuments.isValidCnpj('12.ABC.345/01DE-3X'), isFalse, reason: 'verificadores são numéricos');
    });
    test('normalização e máscara', () {
      expect(BrDocuments.normalize(' 12.abc.345/01de-35 '), '12ABC34501DE35');
      expect(BrDocuments.format('12ABC34501DE35'), '12.ABC.345/01DE-35');
      expect(BrDocuments.format('52998224725'), '529.982.247-25');
    });
  });

  group('telefone E.164', () {
    test('formas brasileiras comuns', () {
      expect(Phones.toE164('(51) 99999-0001'), '+5551999990001');
      expect(Phones.toE164('51 3333-4444'), '+555133334444');
      expect(Phones.toE164('0 51 3333-4444'), '+555133334444');
      expect(Phones.toE164('55 51 99999-0001'), '+5551999990001');
      expect(Phones.toE164('+55 (51) 99999-0001'), '+5551999990001');
      expect(Phones.toE164('0055 51 99999-0001'), '+5551999990001');
    });
    test('inválidos viram null', () {
      expect(Phones.toE164(''), isNull);
      expect(Phones.toE164('9999-0001'), isNull, reason: 'sem DDD');
      expect(Phones.toE164('(51) 89999-0001'), isNull, reason: 'celular com 9 dígitos começa em 9');
      expect(Phones.toE164('ramal 12'), isNull);
      expect(Phones.toE164('+0123'), isNull);
    });
    test('estrangeiro com +', () {
      expect(Phones.toE164('+1 415 555 2671'), '+14155552671');
      expect(Phones.isE164('+14155552671'), isTrue);
    });
  });
}
