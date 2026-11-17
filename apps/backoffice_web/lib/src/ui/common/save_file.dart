import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'save_file_stub.dart' if (dart.library.js_interop) 'save_file_web.dart' as impl;

/// Entrega um arquivo para a pessoa salvar (no navegador, um download).
typedef SaveFile = Future<void> Function(String name, String mimeType, Uint8List bytes);

/// Trocado nos testes para guardar o arquivo em memória.
final saveFileProvider = Provider<SaveFile>((ref) => impl.saveFile);
