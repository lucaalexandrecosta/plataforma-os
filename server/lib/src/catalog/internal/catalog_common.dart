import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/errors/api_errors.dart';
import '../../platform/outbox/outbox.dart';

/// Peças comuns aos cadastros do catálogo.
abstract final class CatalogCommon {
  static const managePermission = 'catalog.manage';

  /// `id` gerado pelo app: precisa ser UUID v7 recente (docs/08 §2.9).
  static void checkClientId(Session session, UuidValue? id) {
    if (id != null && !UuidV7.isAcceptable(id.uuid, now: DateTime.now().toUtc())) {
      throw ApiErrors.invalidUuid(session, 'id');
    }
  }

  static String requireReason(Session session, String reason) {
    final why = reason.trim();
    if (why.isEmpty || why.length > 500) {
      throw ApiErrors.validation(session, [
        FieldError(path: 'reason', code: 'required', message: 'Informe o motivo (até 500 caracteres).'),
      ]);
    }
    return why;
  }

  /// Campos que mudaram (nome do campo → valor novo).
  static Map<String, Object?> changed(Map<String, Object?> before, Map<String, Object?> after) => {
    for (final e in after.entries)
      if (e.value != before[e.key]) e.key: e.value,
  };

  /// `product.*` e `service.*` (docs/08 §6): `id`, `source`, `is_active`.
  static Future<void> event(
    Session session,
    Transaction tx, {
    required String type,
    required String aggregateType,
    required UuidValue id,
    required int version,
    required RecordSource source,
    required bool isActive,
    Map<String, Object?> extra = const {},
  }) => Outbox.record(
    session,
    tx,
    eventType: type,
    aggregateType: aggregateType,
    aggregateId: id,
    aggregateVersion: version,
    payload: {'id': id.uuid, 'source': source.name, 'is_active': isActive, ...extra},
  );

  /// Unicidade do banco → `DUPLICATE` no campo certo.
  static Future<T> translateUnique<T>(
    Session session,
    String table,
    String what,
    Future<T> Function() body,
  ) async {
    try {
      return await body();
    } on DatabaseUniqueViolationException catch (e) {
      if (e.constraintName == '${table}_tenant_id_code_key') {
        throw ApiErrors.duplicate(session, path: 'code', message: 'Já existe $what com este código.');
      }
      if (e.constraintName == '${table}_pkey') {
        throw ApiErrors.duplicate(session, path: 'id', message: 'Já existe $what com este identificador.');
      }
      rethrow;
    }
  }
}
