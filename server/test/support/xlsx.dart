import 'dart:typed_data';

import 'package:archive/archive.dart';

/// XLSX mínimo: shared strings, string inline, número e uma célula pulada.
Uint8List buildXlsx(List<List<Object?>> rows) {
  final shared = <String>[];
  String col(int i) => String.fromCharCode(65 + i);
  final sheetRows = StringBuffer();
  for (var r = 0; r < rows.length; r++) {
    sheetRows.write('<row r="${r + 1}">');
    for (var c = 0; c < rows[r].length; c++) {
      final v = rows[r][c];
      final ref = '${col(c)}${r + 1}';
      if (v == null) continue; // célula ausente: o leitor precisa respeitar a coluna
      if (v is num) {
        sheetRows.write('<c r="$ref"><v>$v</v></c>');
      } else if (c.isEven) {
        shared.add('$v');
        sheetRows.write('<c r="$ref" t="s"><v>${shared.length - 1}</v></c>');
      } else {
        sheetRows.write('<c r="$ref" t="inlineStr"><is><t>$v</t></is></c>');
      }
    }
    sheetRows.write('</row>');
  }
  final archive = Archive()
    ..addFile(
      ArchiveFile.string(
        'xl/workbook.xml',
        '<workbook xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"><sheets><sheet name="Clientes" sheetId="1" r:id="rId1"/></sheets></workbook>',
      ),
    )
    ..addFile(
      ArchiveFile.string(
        'xl/_rels/workbook.xml.rels',
        '<Relationships><Relationship Id="rId1" Target="worksheets/sheet1.xml"/></Relationships>',
      ),
    )
    ..addFile(
      ArchiveFile.string('xl/sharedStrings.xml', '<sst>${shared.map((s) => '<si><t>$s</t></si>').join()}</sst>'),
    )
    ..addFile(
      ArchiveFile.string('xl/worksheets/sheet1.xml', '<worksheet><sheetData>$sheetRows</sheetData></worksheet>'),
    );
  return Uint8List.fromList(ZipEncoder().encode(archive));
}
