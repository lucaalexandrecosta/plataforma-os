import 'package:flutter/material.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';

/// Texto para pessoas a partir de um erro da API. A decisão de fluxo é sempre
/// pelo `code` (docs/08 §2.8); o `detail` só é exibido.
String describeError(Object error) {
  if (error is ApiException) return error.detail;
  if (error is ServerpodClientHttpException) {
    return switch (error.statusCode) {
      401 => 'Sua sessão expirou. Entre de novo.',
      403 => 'Você não tem permissão para esta ação.',
      _ => 'O servidor não respondeu como esperado (${error.statusCode}). Tente de novo.',
    };
  }
  return 'Não foi possível falar com o servidor. Confira a conexão e tente de novo.';
}

/// Erros por campo (`fieldErrors[].path`), para os formulários.
Map<String, String> fieldErrorsOf(Object error) => {
  if (error is ApiException)
    for (final f in error.fieldErrors ?? const <FieldError>[]) f.path: f.message,
};

void showErrorSnack(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(describeError(error)), behavior: SnackBarBehavior.floating),
  );
}

void showInfoSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));
}

/// Mensagem de bloco para estados de erro de uma tela inteira.
class ErrorPanel extends StatelessWidget {
  const ErrorPanel({required this.error, required this.onRetry, super.key});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off_outlined, size: 40, color: Theme.of(context).colorScheme.error),
          const SizedBox(height: 12),
          Text(describeError(error), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton.tonal(onPressed: onRetry, child: const Text('Tentar de novo')),
        ],
      ),
    ),
  );
}
