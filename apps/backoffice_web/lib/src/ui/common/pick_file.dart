import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'pick_file_stub.dart' if (dart.library.js_interop) 'pick_file_web.dart' as impl;

/// Arquivo escolhido pela pessoa: nome e conteúdo.
typedef PickedFile = ({String name, Uint8List bytes});

/// Abre o seletor de arquivos ([accept] no formato do `<input type=file>`,
/// ex.: `.csv,.xlsx`). `null` = cancelou.
typedef PickFile = Future<PickedFile?> Function(String accept);

/// Trocado nos testes para entregar um arquivo pronto.
final pickFileProvider = Provider<PickFile>((ref) => impl.pickFile);
