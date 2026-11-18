import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'open_url_stub.dart' if (dart.library.js_interop) 'open_url_web.dart' as impl;

/// Abre um endereço numa aba nova (no navegador).
typedef OpenUrl = void Function(String url);

/// Trocado nos testes para guardar o endereço aberto.
final openUrlProvider = Provider<OpenUrl>((ref) => impl.openUrl);
