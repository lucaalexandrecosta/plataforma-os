import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

/// Planilha lida: cabeçalho + linhas (texto já sem espaços nas pontas).
final class SheetTable {
  const SheetTable(this.header, this.rows);
  final List<String> header;
  final List<List<String>> rows;
}

final class TabularFormatException implements Exception {
  const TabularFormatException(this.message);
  final String message;
  @override
  String toString() => message;
}

/// Lê CSV ou XLSX (primeira planilha). CSV: separador `;` ou `,` detectado no
/// cabeçalho, aspas RFC 4180, BOM e Windows-1252 (o "CSV" do Excel em pt-BR).
abstract final class Tabular {
  static const maxRows = 20000;

  static SheetTable read(String fileName, Uint8List bytes) {
    final lower = fileName.toLowerCase();
    final isZip = bytes.length > 4 && bytes[0] == 0x50 && bytes[1] == 0x4B;
    final table = lower.endsWith('.xlsx') || isZip ? _xlsx(bytes) : _csv(bytes);
    if (table.header.every((h) => h.isEmpty)) throw const TabularFormatException('A planilha não tem cabeçalho.');
    if (table.rows.length > maxRows) {
      throw const TabularFormatException('A planilha passa de $maxRows linhas. Divida em arquivos menores.');
    }
    return table;
  }

  // --- CSV -------------------------------------------------------------------

  static SheetTable _csv(Uint8List bytes) {
    var text = _decode(bytes);
    if (text.startsWith('﻿')) text = text.substring(1);
    final firstLine = text.split(RegExp(r'\r?\n')).first;
    final separator = ';'.allMatches(firstLine).length >= ','.allMatches(firstLine).length ? ';' : ',';
    final records = _parseCsv(text, separator);
    final nonEmpty = records.where((r) => r.any((c) => c.trim().isNotEmpty)).toList();
    if (nonEmpty.isEmpty) throw const TabularFormatException('A planilha está vazia.');
    return SheetTable(
      [for (final h in nonEmpty.first) h.trim()],
      [
        for (final r in nonEmpty.skip(1)) [for (final c in r) c.trim()],
      ],
    );
  }

  /// UTF-8 se válido; senão Windows-1252 (Latin-1 + símbolos do Excel).
  static String _decode(Uint8List bytes) {
    try {
      return utf8.decode(bytes);
    } on FormatException {
      return String.fromCharCodes([for (final b in bytes) _cp1252[b] ?? b]);
    }
  }

  static const _cp1252 = {
    0x80: 0x20AC, 0x82: 0x201A, 0x83: 0x0192, 0x84: 0x201E, 0x85: 0x2026, 0x86: 0x2020, 0x87: 0x2021, //
    0x88: 0x02C6, 0x89: 0x2030, 0x8A: 0x0160, 0x8B: 0x2039, 0x8C: 0x0152, 0x8E: 0x017D, 0x91: 0x2018,
    0x92: 0x2019, 0x93: 0x201C, 0x94: 0x201D, 0x95: 0x2022, 0x96: 0x2013, 0x97: 0x2014, 0x98: 0x02DC,
    0x99: 0x2122, 0x9A: 0x0161, 0x9B: 0x203A, 0x9C: 0x0153, 0x9E: 0x017E, 0x9F: 0x0178,
  };

  static List<List<String>> _parseCsv(String text, String sep) {
    final records = <List<String>>[];
    var record = <String>[];
    final field = StringBuffer();
    var quoted = false;
    for (var i = 0; i < text.length; i++) {
      final ch = text[i];
      if (quoted) {
        if (ch == '"') {
          if (i + 1 < text.length && text[i + 1] == '"') {
            field.write('"');
            i++;
          } else {
            quoted = false;
          }
        } else {
          field.write(ch);
        }
      } else if (ch == '"' && field.isEmpty) {
        quoted = true;
      } else if (ch == sep) {
        record.add(field.toString());
        field.clear();
      } else if (ch == '\n' || ch == '\r') {
        if (ch == '\r' && i + 1 < text.length && text[i + 1] == '\n') i++;
        record.add(field.toString());
        field.clear();
        records.add(record);
        record = <String>[];
      } else {
        field.write(ch);
      }
    }
    if (field.isNotEmpty || record.isNotEmpty) {
      record.add(field.toString());
      records.add(record);
    }
    return records;
  }

  // --- XLSX ------------------------------------------------------------------

  static SheetTable _xlsx(Uint8List bytes) {
    final Archive zip;
    try {
      zip = ZipDecoder().decodeBytes(bytes);
    } on Object {
      throw const TabularFormatException('Arquivo XLSX inválido ou corrompido.');
    }
    XmlDocument? doc(String path) {
      final f = zip.findFile(path);
      if (f == null) return null;
      return XmlDocument.parse(utf8.decode(f.content));
    }

    final shared = <String>[];
    final sst = doc('xl/sharedStrings.xml');
    if (sst != null) {
      for (final si in sst.findAllElements('si')) {
        shared.add(si.findAllElements('t').map((t) => t.innerText).join());
      }
    }

    // Primeira planilha: workbook.xml → relationship → arquivo.
    var sheetPath = 'xl/worksheets/sheet1.xml';
    final workbook = doc('xl/workbook.xml');
    final rels = doc('xl/_rels/workbook.xml.rels');
    final firstSheet = workbook?.findAllElements('sheet').firstOrNull;
    final relId = firstSheet?.attributes.where((a) => a.name.local == 'id').firstOrNull?.value;
    if (relId != null && rels != null) {
      final target = rels.findAllElements('Relationship').where((r) => r.getAttribute('Id') == relId).firstOrNull;
      final t = target?.getAttribute('Target');
      if (t != null) sheetPath = t.startsWith('/') ? t.substring(1) : 'xl/$t';
    }
    final sheet = doc(sheetPath) ?? (throw const TabularFormatException('A planilha não tem nenhuma aba.'));

    final rows = <List<String>>[];
    for (final row in sheet.findAllElements('row')) {
      final cells = <String>[];
      for (final c in row.findElements('c')) {
        final col = _columnIndex(c.getAttribute('r'));
        while (col != null && cells.length < col) {
          cells.add('');
        }
        final type = c.getAttribute('t');
        final v = c.findElements('v').firstOrNull?.innerText ?? '';
        final value = switch (type) {
          's' => int.tryParse(v) != null && int.parse(v) < shared.length ? shared[int.parse(v)] : '',
          'inlineStr' => c.findAllElements('t').map((t) => t.innerText).join(),
          'b' => v == '1' ? 'sim' : 'não',
          _ => _number(v),
        };
        cells.add(value.trim());
      }
      rows.add(cells);
    }
    final nonEmpty = rows.where((r) => r.any((c) => c.isNotEmpty)).toList();
    if (nonEmpty.isEmpty) throw const TabularFormatException('A planilha está vazia.');
    return SheetTable(nonEmpty.first, nonEmpty.skip(1).toList());
  }

  /// `C12` → 2 (base zero).
  static int? _columnIndex(String? ref) {
    if (ref == null) return null;
    final letters = RegExp(r'^[A-Z]+').stringMatch(ref);
    if (letters == null) return null;
    var n = 0;
    for (final u in letters.codeUnits) {
      n = n * 26 + (u - 64);
    }
    return n - 1;
  }

  /// Número do Excel sem notação científica nem `.0` (códigos e CEPs digitados
  /// como número continuam legíveis).
  static String _number(String v) {
    final d = double.tryParse(v);
    if (d == null) return v;
    if (d == d.truncateToDouble() && d.abs() < 1e15) return d.toInt().toString();
    return v;
  }
}
