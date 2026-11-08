import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Contrato de uma importação por planilha (docs/06 §3, "Importação
/// CSV/XLSX"). O módulo dono dos dados implementa as regras (as mesmas das
/// telas); o módulo `imports` cuida do arquivo, da execução e do relatório.
///
/// Regras comuns:
/// * upsert pela chave natural (código), idempotente: reenviar a mesma
///   planilha não duplica nada e responde "sem mudança";
/// * célula vazia = não mexer no valor atual (a importação não apaga dados);
/// * linhas com erro são ignoradas e vão para o relatório; as outras são
///   aplicadas numa transação só.
abstract class ImportSpec {
  ImportEntityType get entity;
  String get title;
  String get description;
  List<ImportColumn> get columns;

  /// Classifica cada linha (criar, atualizar, sem mudança, erro) olhando o
  /// banco. Na confirmação roda de novo dentro da transação de aplicação.
  Future<List<ImportRowPlan>> plan(Session session, List<ImportRecord> records, {Transaction? transaction});

  /// Aplica as linhas `create` e `update` do plano (eventos no outbox com
  /// `origin = file_import`). Devolve quantos foram criados e atualizados.
  Future<({int created, int updated})> apply(
    Session session,
    Transaction transaction,
    List<ImportRowPlan> plan, {
    required UuidValue runId,
  });
}

final class ImportColumn {
  const ImportColumn(
    this.key,
    this.label, {
    required this.help,
    required this.example,
    this.isRequired = false,
    this.aliases = const [],
  });

  /// Cabeçalho do modelo (snake_case, sem acento).
  final String key;
  final String label;
  final bool isRequired;
  final String help;
  final String example;

  /// Outros cabeçalhos aceitos (comparados sem acento, caixa ou pontuação).
  final List<String> aliases;

  ImportColumnInfo toInfo() =>
      ImportColumnInfo(key: key, label: label, isRequired: isRequired, help: help, example: example);
}

/// Uma linha da planilha: coluna (key) → valor não vazio.
final class ImportRecord {
  const ImportRecord(this.rowNumber, this.values);

  /// Linha como o Excel mostra (cabeçalho = 1).
  final int rowNumber;
  final Map<String, String> values;

  String? operator [](String key) => values[key];
}

enum ImportAction { create, update, unchanged, error }

final class ImportRowPlan {
  const ImportRowPlan({
    required this.rowNumber,
    required this.action,
    this.key,
    this.messages = const [],
    this.payload,
  });

  final int rowNumber;
  final ImportAction action;
  final String? key;
  final List<String> messages;

  /// Dados já validados para o `apply` do próprio módulo.
  final Object? payload;

  ImportRowPlan withError(String message) =>
      ImportRowPlan(rowNumber: rowNumber, action: ImportAction.error, key: key, messages: [...messages, message]);
}

/// Utilitários de leitura de células, iguais para todos os módulos.
abstract final class ImportCells {
  static const _true = {'sim', 's', 'yes', 'y', 'x', '1', 'verdadeiro', 'true'};
  static const _false = {'nao', 'não', 'n', 'no', '0', 'falso', 'false'};

  /// `null` se vazio; lança [FormatException] se não for sim/não.
  static bool? boolean(String? v) {
    if (v == null) return null;
    final t = v.trim().toLowerCase();
    if (_true.contains(t)) return true;
    if (_false.contains(t)) return false;
    throw const FormatException('use "sim" ou "não"');
  }

  /// Aceita vírgula decimal (`-30,0277`).
  static double? decimal(String? v) {
    if (v == null) return null;
    final d = double.tryParse(v.trim().replaceAll(',', '.'));
    if (d == null) throw const FormatException('número inválido');
    return d;
  }

  /// Cabeçalho comparável: minúsculas, sem acento nem pontuação, `_` entre palavras.
  static String normalizeHeader(String h) {
    const from = 'áàâãäéèêëíìîïóòôõöúùûüçñ';
    const to = 'aaaaaeeeeiiiiooooouuuucn';
    final lower = h.trim().toLowerCase();
    final buffer = StringBuffer();
    for (final ch in lower.split('')) {
      final i = from.indexOf(ch);
      buffer.write(i >= 0 ? to[i] : ch);
    }
    return buffer.toString().replaceAll(RegExp(r'[^a-z0-9]+'), '_').replaceAll(RegExp(r'^_+|_+$'), '');
  }
}
