import 'package:flutter/foundation.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

/// Tipo da mutação de envio do checklist (docs/06 §6.7); entityId é a visita.
const checklistSubmitType = 'checklist_response.submit';

/// Checklist da visita como a tela mostra: o modelo e as respostas do
/// aparelho (rascunho) ou, sem rascunho, as que o servidor guardou.
@immutable
class VisitChecklistState {
  const VisitChecklistState({
    required this.template,
    required this.answers,
    required this.submitted,
    required this.pending,
  });

  final ChecklistTemplate template;

  /// Respostas por chave do item.
  final Map<String, ChecklistAnswer> answers;

  /// Enviado (na fila ou já aceito) e sem mudança depois.
  final bool submitted;

  /// Envio ainda na fila do aparelho.
  final bool pending;

  int get answered => template.items.where((i) => _filled(answers[i.key])).length;

  int get total => template.items.length;

  /// Itens obrigatórios ainda sem resposta.
  List<ChecklistItem> get missing => [
    for (final i in template.items)
      if (i.required && !_filled(answers[i.key])) i,
  ];

  static bool _filled(ChecklistAnswer? a) => a != null && a.value.trim().isNotEmpty;
}

/// Confere as respostas antes do envio, com as regras do servidor: tipo de
/// cada resposta e obrigatórios. Devolve erros por chave do item (vazio = ok)
/// e as respostas normalizadas (número com ponto, sem as vazias).
(Map<String, String> errors, List<ChecklistAnswer> answers) checkChecklist(
  ChecklistTemplate template,
  Map<String, ChecklistAnswer> answers,
) {
  final errors = <String, String>{};
  final result = <ChecklistAnswer>[];
  for (final item in template.items) {
    final key = item.key!;
    final answer = answers[key];
    var value = answer?.value.trim() ?? '';
    if (value.isEmpty) {
      if (item.required) errors[key] = 'Obrigatório.';
      continue;
    }
    if (item.type == 'number') value = value.replaceAll(',', '.');
    final ok = switch (item.type) {
      'yes_no' => const {'yes', 'no', 'na'}.contains(value),
      'ok_nok' => const {'ok', 'nok', 'na'}.contains(value),
      'number' => double.tryParse(value)?.isFinite ?? false,
      'choice' => item.options?.contains(value) ?? false,
      _ => value.length <= 2000,
    };
    if (!ok) {
      errors[key] = item.type == 'number' ? 'Informe um número.' : 'Resposta inválida.';
      continue;
    }
    final note = answer?.note?.trim();
    result.add(ChecklistAnswer(itemKey: key, value: value, note: note == null || note.isEmpty ? null : note));
  }
  return (errors, result);
}
