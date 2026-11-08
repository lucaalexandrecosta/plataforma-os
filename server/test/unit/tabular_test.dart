import 'dart:convert';
import 'dart:typed_data';

import 'package:plataforma_os_server/src/imports/internal/tabular.dart';
import 'package:plataforma_os_server/src/platform/imports/import_spec.dart';
import 'package:test/test.dart';

import '../support/xlsx.dart';

Uint8List _utf8(String s) => Uint8List.fromList(utf8.encode(s));

void main() {
  group('CSV', () {
    test('separador ";" do Excel pt-BR, BOM, aspas e quebra de linha dentro da célula', () {
      final t = Tabular.read(
        'a.csv',
        _utf8('﻿codigo;razao_social;observacoes\r\nC1;"Padaria; Ltda";"linha 1\nlinha 2"\r\n'),
      );
      expect(t.header, ['codigo', 'razao_social', 'observacoes']);
      expect(t.rows.single, ['C1', 'Padaria; Ltda', 'linha 1\nlinha 2']);
    });

    test('separador "," e aspas escapadas', () {
      final t = Tabular.read('a.csv', _utf8('codigo,nome\nC1,"Bar ""do Zé"""\n\n'));
      expect(t.rows, [
        ['C1', 'Bar "do Zé"'],
      ]);
    });

    test('Windows-1252 (CSV salvo pelo Excel antigo)', () {
      final bytes = Uint8List.fromList([...latin1.encode('codigo;nome\nC1;Pão Açúcar'), 0x96, ...latin1.encode('x')]);
      final t = Tabular.read('a.csv', bytes);
      expect(t.rows.single[1], 'Pão Açúcar–x');
    });

    test('vazio e sem cabeçalho são recusados', () {
      expect(() => Tabular.read('a.csv', _utf8('\n\n')), throwsA(isA<TabularFormatException>()));
    });
  });

  group('XLSX', () {
    test('primeira aba, shared strings, inline, números sem ".0" e célula pulada', () {
      final bytes = buildXlsx([
        ['codigo', 'razao_social', 'cep'],
        ['C1', 'Padaria Pão Quente', 90020007],
        ['C2', null, 1.5],
      ]);
      final t = Tabular.read('clientes.xlsx', bytes);
      expect(t.header, ['codigo', 'razao_social', 'cep']);
      expect(t.rows[0], ['C1', 'Padaria Pão Quente', '90020007']);
      expect(t.rows[1], ['C2', '', '1.5']);
    });

    test('arquivo corrompido', () {
      expect(
        () => Tabular.read('x.xlsx', Uint8List.fromList([0x50, 0x4B, 1, 2, 3])),
        throwsA(isA<TabularFormatException>()),
      );
    });
  });

  test('cabeçalhos comparáveis sem acento, caixa ou pontuação', () {
    expect(ImportCells.normalizeHeader(' Razão Social '), 'razao_social');
    expect(ImportCells.normalizeHeader('CNPJ/CPF'), 'cnpj_cpf');
    expect(ImportCells.normalizeHeader('Instruções de acesso'), 'instrucoes_de_acesso');
    expect(ImportCells.boolean('Sim'), isTrue);
    expect(ImportCells.boolean('não'), isFalse);
    expect(() => ImportCells.boolean('talvez'), throwsFormatException);
    expect(ImportCells.decimal('-30,0277'), closeTo(-30.0277, 1e-9));
  });
}
