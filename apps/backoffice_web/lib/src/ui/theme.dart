import 'package:flutter/material.dart';

/// Tema base do backoffice. A cor primária do tenant (branding, docs/04 §9)
/// entra depois pelo endpoint público de branding; até lá, a da plataforma.
ThemeData buildTheme(Brightness brightness, {Color seed = const Color(0xFF0B5FFF)}) {
  final scheme = ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
  return ThemeData(
    colorScheme: scheme,
    useMaterial3: true,
    visualDensity: VisualDensity.standard,
    inputDecorationTheme: const InputDecorationTheme(border: OutlineInputBorder(), isDense: true),
    cardTheme: CardThemeData(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: scheme.outlineVariant),
      ),
    ),
    dataTableTheme: DataTableThemeData(
      headingTextStyle: TextStyle(fontWeight: FontWeight.w600, color: scheme.onSurface),
    ),
  );
}
