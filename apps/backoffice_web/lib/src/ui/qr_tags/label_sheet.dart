import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:plataforma_os_client/plataforma_os_client.dart';

/// Folha A4 de etiquetas para imprimir: 3 colunas × 8 linhas, cada uma com o
/// QR (a URL da etiqueta), o código curto para digitar e o lote.
Future<Uint8List> buildLabelSheet(QrTagBatch batch, List<QrTag> tags) {
  const columns = 3;
  const rows = 8;
  final doc = pw.Document(title: 'Etiquetas ${batch.code}', creator: 'Plataforma OS');
  for (var start = 0; start < tags.length; start += columns * rows) {
    final page = tags.skip(start).take(columns * rows).toList();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.symmetric(horizontal: 8 * PdfPageFormat.mm, vertical: 10 * PdfPageFormat.mm),
        build: (context) => pw.GridView(
          crossAxisCount: columns,
          childAspectRatio: 0.5,
          children: [for (final tag in page) _label(batch, tag)],
        ),
      ),
    );
  }
  return doc.save();
}

pw.Widget _label(QrTagBatch batch, QrTag tag) => pw.Container(
  margin: const pw.EdgeInsets.all(2 * PdfPageFormat.mm),
  padding: const pw.EdgeInsets.all(2 * PdfPageFormat.mm),
  decoration: pw.BoxDecoration(border: pw.Border.all(color: PdfColors.grey400, width: 0.5)),
  child: pw.Row(
    children: [
      pw.BarcodeWidget(
        barcode: pw.Barcode.qrCode(),
        data: tag.url,
        width: 26 * PdfPageFormat.mm,
        height: 26 * PdfPageFormat.mm,
      ),
      pw.SizedBox(width: 3 * PdfPageFormat.mm),
      pw.Expanded(
        child: pw.Column(
          mainAxisAlignment: pw.MainAxisAlignment.center,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(tag.shortCode, style: pw.TextStyle(fontSize: 13, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 2),
            pw.Text(batch.code, style: const pw.TextStyle(fontSize: 7)),
          ],
        ),
      ),
    ],
  ),
);
