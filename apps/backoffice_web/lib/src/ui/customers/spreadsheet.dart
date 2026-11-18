import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:xml/xml.dart';

/// Leitura da planilha de importação de clientes (CSV ou XLSX) e o modelo
/// para baixar. As colunas são as de `CustomerImport.columns` no servidor.
abstract final class CustomerSpreadsheet {
  static const columns = [
    'codigo',
    'nome',
    'nome_fantasia',
    'tipo',
    'documento',
    'inscricao_estadual',
    'email',
    'telefone',
    'observacoes',
    'unidade',
    'unidade_codigo',
    'cep',
    'rua',
    'numero',
    'complemento',
    'bairro',
    'cidade',
    'uf',
    'unidade_telefone',
    'como_chegar',
    'contato',
    'contato_telefone',
    'contato_email',
    'contato_cargo',
  ];

  static const _example = [
    'C100',
    'Mercado Exemplo Ltda',
    'Mercado Exemplo',
    'PJ',
    '11.222.333/0001-81',
    '',
    'compras@exemplo.com.br',
    '(51) 3333-4444',
    '',
    'Loja Centro',
    '',
    '90000-000',
    'Rua dos Andradas',
    '100',
    '',
    'Centro',
    'Porto Alegre',
    'RS',
    '',
    'Entrada pela doca',
    'Rita Souza',
    '(51) 98888-7777',
    'rita@exemplo.com.br',
    'Gerente',
  ];

  /// Modelo em CSV com `;` (o Excel em português abre direto) e BOM UTF-8.
  static Uint8List template() {
    String line(List<String> cells) => cells.map(_quote).join(';');
    return Uint8List.fromList([
      0xEF, 0xBB, 0xBF, //
      ...utf8.encode('${line(columns)}\r\n${line(_example)}\r\n'),
    ]);
  }

  static String _quote(String v) => v.contains(RegExp('[;",\n]')) ? '"${v.replaceAll('"', '""')}"' : v;

  /// Lê o arquivo pela extensão. Lança [FormatException] com mensagem para a
  /// pessoa quando não dá para ler.
  static List<CustomerImportRow> read(String fileName, Uint8List bytes) {
    final lower = fileName.toLowerCase();
    final List<List<String>> table;
    if (lower.endsWith('.xlsx')) {
      table = parseXlsx(bytes);
    } else if (lower.endsWith('.csv') || lower.endsWith('.txt')) {
      table = parseCsv(decodeText(bytes));
    } else {
      throw const FormatException('Use um arquivo .csv ou .xlsx.');
    }
    return rowsFromTable(table);
  }

  /// UTF-8 (com ou sem BOM); se não for, Latin-1 (CSV antigo do Excel).
  static String decodeText(Uint8List bytes) {
    var data = bytes;
    if (data.length >= 3 && data[0] == 0xEF && data[1] == 0xBB && data[2] == 0xBF) data = data.sublist(3);
    try {
      return utf8.decode(data);
    } on FormatException {
      return latin1.decode(data);
    }
  }

  /// CSV com `;` ou `,` (o que aparecer mais na primeira linha), aspas
  /// duplas e quebras de linha dentro de aspas.
  static List<List<String>> parseCsv(String text) {
    final firstLine = text.split('\n').first;
    final sep = ';'.allMatches(firstLine).length >= ','.allMatches(firstLine).length ? ';' : ',';
    final rows = <List<String>>[];
    var row = <String>[];
    final cell = StringBuffer();
    var quoted = false;
    for (var i = 0; i < text.length; i++) {
      final ch = text[i];
      if (quoted) {
        if (ch == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            cell.write('"');
            i++;
          } else {
            quoted = false;
          }
        } else {
          cell.write(ch);
        }
      } else if (ch == '"') {
        quoted = true;
      } else if (ch == sep) {
        row.add(cell.toString());
        cell.clear();
      } else if (ch == '\n' || ch == '\r') {
        if (ch == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
        row.add(cell.toString());
        cell.clear();
        rows.add(row);
        row = <String>[];
      } else {
        cell.write(ch);
      }
    }
    if (cell.isNotEmpty || row.isNotEmpty) {
      row.add(cell.toString());
      rows.add(row);
    }
    return rows;
  }

  /// Primeira aba de um XLSX: textos compartilhados, texto em linha e números.
  static List<List<String>> parseXlsx(Uint8List bytes) {
    final Archive zip;
    try {
      zip = ZipDecoder().decodeBytes(bytes);
    } on Object {
      throw const FormatException('Não deu para abrir o arquivo .xlsx.');
    }
    XmlDocument? xml(String path) {
      final f = zip.findFile(path);
      return f == null ? null : XmlDocument.parse(utf8.decode(f.content));
    }

    final shared = [
      for (final si in xml('xl/sharedStrings.xml')?.findAllElements('si') ?? const <XmlElement>[])
        si.findAllElements('t').map((t) => t.innerText).join(),
    ];
    final sheet = xml(_firstSheetPath(xml)) ?? (throw const FormatException('A planilha não tem abas.'));
    final rows = <List<String>>[];
    for (final r in sheet.findAllElements('row')) {
      final index = int.tryParse(r.getAttribute('r') ?? '') ?? rows.length + 1;
      while (rows.length < index - 1) {
        rows.add(const []);
      }
      final cells = <String>[];
      for (final c in r.findElements('c')) {
        final col = _columnIndex(c.getAttribute('r')) ?? cells.length;
        while (cells.length < col) {
          cells.add('');
        }
        final type = c.getAttribute('t');
        final v = c.getElement('v')?.innerText ?? '';
        cells.add(switch (type) {
          's' => shared[int.parse(v)],
          'inlineStr' => c.findAllElements('t').map((t) => t.innerText).join(),
          'b' => v == '1' ? 'sim' : 'não',
          _ => _number(v),
        });
      }
      rows.add(cells);
    }
    return rows;
  }

  static String _firstSheetPath(XmlDocument? Function(String) xml) {
    final workbook = xml('xl/workbook.xml');
    final sheet = workbook?.findAllElements('sheet').firstOrNull;
    final rid = sheet?.attributes.where((a) => a.name.local == 'id').firstOrNull?.value;
    final rels = xml('xl/_rels/workbook.xml.rels');
    final target = rels
        ?.findAllElements('Relationship')
        .where((r) => r.getAttribute('Id') == rid)
        .firstOrNull
        ?.getAttribute('Target');
    if (target == null) return 'xl/worksheets/sheet1.xml';
    return target.startsWith('/') ? target.substring(1) : 'xl/$target';
  }

  /// "B12" → 1.
  static int? _columnIndex(String? ref) {
    final letters = RegExp('^[A-Z]+').stringMatch(ref ?? '');
    if (letters == null) return null;
    var n = 0;
    for (final ch in letters.codeUnits) {
      n = n * 26 + (ch - 64);
    }
    return n - 1;
  }

  /// Números do Excel: "11222333000181" fica igual; "1.5E+3" vira "1500".
  static String _number(String v) {
    if (!v.contains(RegExp('[eE]'))) return v.endsWith('.0') ? v.substring(0, v.length - 2) : v;
    final d = double.tryParse(v);
    if (d == null) return v;
    return d == d.truncateToDouble() ? d.toStringAsFixed(0) : d.toString();
  }

  static String _header(String h) => h
      .trim()
      .toLowerCase()
      .replaceAllMapped(RegExp('[áàâãäéèêëíìîïóòôõöúùûüç]'), (m) => _plain[m[0]]!)
      .replaceAll(RegExp(r'[\s\-/]+'), '_');

  static const _plain = {
    'á': 'a', 'à': 'a', 'â': 'a', 'ã': 'a', 'ä': 'a', //
    'é': 'e', 'è': 'e', 'ê': 'e', 'ë': 'e', //
    'í': 'i', 'ì': 'i', 'î': 'i', 'ï': 'i', //
    'ó': 'o', 'ò': 'o', 'ô': 'o', 'õ': 'o', 'ö': 'o', //
    'ú': 'u', 'ù': 'u', 'û': 'u', 'ü': 'u', 'ç': 'c',
  };

  /// Primeira linha = cabeçalho com os nomes das colunas; linhas vazias são
  /// puladas. Colunas desconhecidas são ignoradas.
  static List<CustomerImportRow> rowsFromTable(List<List<String>> table) {
    final headerAt = table.indexWhere((r) => r.any((c) => c.trim().isNotEmpty));
    if (headerAt < 0) throw const FormatException('A planilha está vazia.');
    final header = [for (final h in table[headerAt]) _header(h)];
    if (!header.any((h) => h == 'nome' || h == 'codigo' || h == 'documento')) {
      throw const FormatException(
        'Não achei o cabeçalho. A primeira linha precisa ter os nomes das colunas do modelo (codigo, nome, documento…).',
      );
    }
    final out = <CustomerImportRow>[];
    for (var i = headerAt + 1; i < table.length; i++) {
      final cells = table[i];
      if (cells.every((c) => c.trim().isEmpty)) continue;
      String? get(String column) {
        final at = header.indexOf(column);
        if (at < 0 || at >= cells.length) return null;
        final v = cells[at].trim();
        return v.isEmpty ? null : v;
      }

      final tipo = get('tipo');
      out.add(
        CustomerImportRow(
          line: i + 1,
          code: get('codigo'),
          name: get('nome'),
          tradeName: get('nome_fantasia'),
          personType: tipo,
          documentNumber: _document(get('documento'), tipo),
          stateRegistration: get('inscricao_estadual'),
          email: get('email'),
          phone: get('telefone'),
          notes: get('observacoes'),
          siteName: get('unidade'),
          siteCode: get('unidade_codigo'),
          postalCode: _padDigits(get('cep'), 8),
          street: get('rua'),
          streetNumber: get('numero'),
          complement: get('complemento'),
          district: get('bairro'),
          city: get('cidade'),
          state: get('uf'),
          sitePhone: get('unidade_telefone'),
          accessNotes: get('como_chegar'),
          contactName: get('contato'),
          contactPhone: get('contato_telefone'),
          contactEmail: get('contato_email'),
          contactJobTitle: get('contato_cargo'),
        ),
      );
    }
    return out;
  }

  /// O Excel guarda CNPJ, CPF e CEP como número e perde os zeros à esquerda.
  static String? _padDigits(String? v, int length) {
    if (v == null || !RegExp(r'^\d+$').hasMatch(v) || v.length >= length || v.length < length - 3) return v;
    return v.padLeft(length, '0');
  }

  static String? _document(String? v, String? tipo) {
    if (v == null || !RegExp(r'^\d+$').hasMatch(v)) return v;
    final pf = tipo != null && tipo.toLowerCase().contains(RegExp(r'pf|f[ií]sica'));
    return _padDigits(v, pf ? 11 : (v.length > 11 ? 14 : 11));
  }
}
