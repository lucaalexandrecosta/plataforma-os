import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:plataforma_os_backoffice/src/app.dart';
import 'package:plataforma_os_backoffice/src/session/session.dart';
import 'package:plataforma_os_backoffice/src/ui/common/pick_file.dart';
import 'package:plataforma_os_backoffice/src/ui/common/save_file.dart';
import 'package:plataforma_os_backoffice/src/ui/customers/spreadsheet.dart';

import 'app_test.dart' show login;
import 'customers_test.dart' show tapKey;
import 'fake_gateway.dart';

Uint8List xlsx(List<String> shared, String sheetRows) {
  final zip = Archive()
    ..add(
      ArchiveFile.string(
        'xl/workbook.xml',
        '<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" '
            'xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">'
            '<sheets><sheet name="Clientes" sheetId="1" r:id="rId7"/></sheets></workbook>',
      ),
    )
    ..add(
      ArchiveFile.string(
        'xl/_rels/workbook.xml.rels',
        '<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">'
            '<Relationship Id="rId7" Type="worksheet" Target="worksheets/clientes.xml"/></Relationships>',
      ),
    )
    ..add(
      ArchiveFile.string(
        'xl/sharedStrings.xml',
        '<sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">'
            '${shared.map((s) => '<si><t>$s</t></si>').join()}</sst>',
      ),
    )
    ..add(
      ArchiveFile.string(
        'xl/worksheets/clientes.xml',
        '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"><sheetData>$sheetRows'
            '</sheetData></worksheet>',
      ),
    );
  return ZipEncoder().encodeBytes(zip);
}

void main() {
  group('leitura da planilha', () {
    test('CSV com ; aspas, acentos no cabeçalho e linhas vazias', () {
      const csv =
          'Código;Nome;Documento;Unidade;Contato;Contato Telefone\r\n'
          'C1;"Mercado ""Bom"" Ltda";11.222.333/0001-81;Loja Centro;Rita;51 98888-7777\r\n'
          ';;;;;\r\n'
          'C1;;;"Loja\nBairro";;\r\n';
      final rows = CustomerSpreadsheet.read('clientes.csv', Uint8List.fromList(utf8.encode(csv)));
      expect(rows, hasLength(2));
      expect(rows[0].line, 2);
      expect(rows[0].name, 'Mercado "Bom" Ltda');
      expect(rows[0].contactPhone, '51 98888-7777');
      expect(rows[1].line, 4);
      expect(rows[1].siteName, 'Loja\nBairro');
      expect(rows[1].name, isNull);
    });

    test('CSV com vírgula em Latin-1', () {
      final bytes = Uint8List.fromList(latin1.encode('nome,cidade,unidade\nPadaria São João,Canoas,Matriz\n'));
      final row = CustomerSpreadsheet.read('a.csv', bytes).single;
      expect((row.name, row.city, row.siteName), ('Padaria São João', 'Canoas', 'Matriz'));
    });

    test('XLSX: textos compartilhados, números sem zeros à esquerda e células puladas', () {
      final bytes = xlsx(
        ['nome', 'tipo', 'documento', 'cep', 'Padaria Zero', 'PJ', 'Joana', 'PF'],
        '<row r="1"><c r="A1" t="s"><v>0</v></c><c r="B1" t="s"><v>1</v></c><c r="C1" t="s"><v>2</v></c>'
        '<c r="D1" t="s"><v>3</v></c></row>'
        '<row r="2"><c r="A2" t="s"><v>4</v></c><c r="B2" t="s"><v>5</v></c><c r="C2"><v>1222333000181</v></c>'
        '<c r="D2"><v>1000000</v></c></row>'
        '<row r="4"><c r="A4" t="inlineStr"><is><t>Joana</t></is></c><c r="B4" t="s"><v>7</v></c>'
        '<c r="C4"><v>5.2998224725E10</v></c></row>',
      );
      final rows = CustomerSpreadsheet.read('Clientes.XLSX', bytes);
      expect(rows.map((r) => (r.line, r.name, r.documentNumber, r.postalCode)), [
        (2, 'Padaria Zero', '01222333000181', '01000000'),
        (4, 'Joana', '52998224725', null),
      ]);
    });

    test('sem cabeçalho conhecido, arquivo vazio ou extensão errada', () {
      expect(
        () => CustomerSpreadsheet.read('a.csv', Uint8List.fromList(utf8.encode('x;y\n1;2\n'))),
        throwsA(isA<FormatException>().having((e) => e.message, 'msg', contains('cabeçalho'))),
      );
      expect(() => CustomerSpreadsheet.read('a.csv', Uint8List(0)), throwsFormatException);
      expect(() => CustomerSpreadsheet.read('a.pdf', Uint8List(0)), throwsFormatException);
      expect(() => CustomerSpreadsheet.read('a.xlsx', Uint8List.fromList([1, 2, 3])), throwsFormatException);
    });

    test('o modelo volta a ser lido igual', () {
      final rows = CustomerSpreadsheet.read('modelo-clientes.csv', CustomerSpreadsheet.template());
      final r = rows.single;
      expect(
        (r.code, r.name, r.state, r.contactName, r.contactJobTitle),
        (
          'C100',
          'Mercado Exemplo Ltda',
          'RS',
          'Rita Souza',
          'Gerente',
        ),
      );
    });
  });

  group('tela', () {
    late List<(String, String, Uint8List)> saved;
    late PickedFile? next;

    Future<void> open(WidgetTester tester, FakeGateway gateway) async {
      saved = [];
      tester.view.physicalSize = const Size(1400, 1000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            gatewayProvider.overrideWithValue(gateway),
            saveFileProvider.overrideWithValue((name, type, bytes) async => saved.add((name, type, bytes))),
            pickFileProvider.overrideWithValue((accept) async => next),
          ],
          child: const BackofficeApp(),
        ),
      );
      await tester.pumpAndSettle();
      await login(tester);
      await tester.tap(find.text('Clientes'));
      await tester.pumpAndSettle();
      await tapKey(tester, 'customer-import');
    }

    PickedFile csv(String text) => (name: 'clientes.csv', bytes: Uint8List.fromList(utf8.encode(text)));

    testWidgets('baixa o modelo, confere, mostra erros e importa depois de corrigir', (tester) async {
      final gateway = FakeGateway();
      await open(tester, gateway);

      await tapKey(tester, 'import-template');
      expect(saved.single.$1, 'modelo-clientes.csv');

      next = csv('codigo;nome\nA1;Alfa\nA2;\n');
      await tapKey(tester, 'import-choose');
      expect(find.textContaining('1 problema(s)'), findsOneWidget);
      expect(find.text('Informe o nome.'), findsOneWidget);
      expect(tester.widget<FilledButton>(find.byKey(const Key('import-apply'))).onPressed, isNull);
      expect(gateway.customerList, isEmpty);

      next = csv('codigo;nome;unidade\nA1;Alfa;Loja\nA2;Beta;\n');
      await tapKey(tester, 'import-choose');
      expect(find.text('Serão criados: 2 clientes, 1 unidade e 0 contatos.'), findsOneWidget);
      await tapKey(tester, 'import-apply');

      expect(gateway.importCalls, [(2, true), (2, true), (2, false)]);
      expect(find.text('Importar clientes'), findsNothing);
      expect(find.text('Alfa'), findsWidgets);
      expect(find.text('Beta'), findsWidgets);
    });

    testWidgets('arquivo ilegível mostra o motivo sem chamar o servidor', (tester) async {
      final gateway = FakeGateway();
      await open(tester, gateway);
      next = csv('qualquer;coisa\n1;2\n');
      await tapKey(tester, 'import-choose');
      expect(find.textContaining('Não achei o cabeçalho'), findsOneWidget);
      expect(gateway.importCalls, isEmpty);
    });
  });
}
