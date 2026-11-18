import 'dart:async';
import 'dart:js_interop';

import 'package:web/web.dart' as web;

import 'pick_file.dart';

Future<PickedFile?> pickFile(String accept) async {
  final input = web.HTMLInputElement()
    ..type = 'file'
    ..accept = accept;
  final chosen = Completer<web.File?>();
  input.onchange = (web.Event _) {
    final files = input.files;
    chosen.complete(files == null || files.length == 0 ? null : files.item(0));
  }.toJS;
  // Navegadores recentes avisam o cancelamento.
  input.addEventListener(
    'cancel',
    (web.Event _) {
      if (!chosen.isCompleted) chosen.complete(null);
    }.toJS,
  );
  input.click();
  final file = await chosen.future;
  if (file == null) return null;
  final buffer = await file.arrayBuffer().toDart;
  return (name: file.name, bytes: buffer.toDart.asUint8List());
}
