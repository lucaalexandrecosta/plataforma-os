import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../session/session.dart';
import 'database.dart';
import 'field_store.dart';

/// Relógio do app; os testes fixam o "agora".
final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

/// Abre o banco local de uma empresa; os testes trocam por um em memória.
final databaseOpenerProvider = Provider<FieldDatabase Function(String tenantSlug)>(
  (ref) => FieldDatabase.forTenant,
);

/// Intervalo do sync com o app aberto (docs/06 §5.4); nulo desliga (testes).
final syncIntervalProvider = Provider<Duration?>((ref) => const Duration(minutes: 5));

/// Banco local e sync da empresa em que o técnico entrou; nulo fora dela.
/// Trocar de empresa fecha um banco e abre o outro.
final storeProvider = Provider<FieldStore?>((ref) {
  final session = ref.watch(sessionProvider);
  if (session is! SignedIn) return null;
  final store = FieldStore(
    ref.read(databaseOpenerProvider)(session.me.tenant.slug),
    ref.read(gatewayProvider),
    clock: ref.read(clockProvider),
  );
  final interval = ref.read(syncIntervalProvider);
  final timer = interval == null ? null : Timer.periodic(interval, (_) => unawaited(store.sync().catchError((_) {})));
  ref.onDispose(() {
    timer?.cancel();
    unawaited(store.close());
  });
  return store;
});
