import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:web/web.dart' as web;

/// Arquivo escolhido pelo usuário no navegador.
final class PickedFile {
  const PickedFile(this.name, this.bytes);
  final String name;
  final Uint8List bytes;
}

/// Abre o seletor de arquivos do navegador. `null` se a pessoa cancelar.
Future<PickedFile?> pickFile({String accept = '.xlsx,.csv'}) {
  final completer = Completer<PickedFile?>();
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = accept;
  input.onchange = (web.Event _) {
    final file = input.files?.item(0);
    if (file == null) {
      completer.complete(null);
      return;
    }
    file.arrayBuffer().toDart.then(
      (buffer) => completer.complete(PickedFile(file.name, buffer.toDart.asUint8List())),
      onError: completer.completeError,
    );
  }.toJS;
  // "cancel" existe nos navegadores atuais; sem ele, o Future fica pendente
  // até a próxima escolha, o que é inofensivo.
  input.addEventListener('cancel', ((web.Event _) => completer.isCompleted ? null : completer.complete(null)).toJS);
  input.click();
  return completer.future;
}

/// Faz o navegador baixar [bytes] como [fileName].
void downloadBytes(String fileName, Uint8List bytes, {String mimeType = 'text/csv;charset=utf-8'}) {
  final blob = web.Blob([bytes.toJS].toJS, web.BlobPropertyBag(type: mimeType));
  final url = web.URL.createObjectURL(blob);
  final anchor = web.HTMLAnchorElement()
    ..href = url
    ..download = fileName;
  web.document.body?.append(anchor);
  anchor.click();
  anchor.remove();
  web.URL.revokeObjectURL(url);
}
