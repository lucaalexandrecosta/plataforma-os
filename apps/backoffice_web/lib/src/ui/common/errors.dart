import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../api/gateway.dart';
import '../../session/session.dart';

/// Mensagem para a pessoa a partir de qualquer erro.
String errorMessage(Object error) => error is GatewayException ? error.message : 'Algo deu errado. Tente de novo.';

/// Mostra o erro numa barra; sessão vencida volta ao login.
void reportError(BuildContext context, WidgetRef ref, Object error) {
  if (error is SessionLost) {
    ref.read(sessionProvider.notifier).lost();
    return;
  }
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(errorMessage(error))));
}

/// Erro de carga no lugar do conteúdo, com "Tentar de novo".
class ErrorPanel extends ConsumerWidget {
  const ErrorPanel({super.key, required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (error is SessionLost) {
      WidgetsBinding.instance.addPostFrameCallback((_) => ref.read(sessionProvider.notifier).lost());
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40, color: Theme.of(context).colorScheme.error),
            const SizedBox(height: 12),
            Text(errorMessage(error), textAlign: TextAlign.center),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Tentar de novo')),
          ],
        ),
      ),
    );
  }
}
