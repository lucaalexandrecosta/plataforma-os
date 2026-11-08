import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../context/request_context.dart';

/// Grava eventos de domínio em `app.outbox_messages` **na mesma transação** do
/// caso de uso (docs/02 §5; regra "Eventos" do docs/13 §5). O relay do worker
/// publica depois; se a transação desfizer, o evento some junto.
abstract final class Outbox {
  static final _eventType = RegExp(r'^[a-z_]+\.[a-z_]+$');

  static Future<void> record(
    Session session,
    Transaction transaction, {
    required String eventType,
    required String aggregateType,
    required UuidValue aggregateId,
    required int aggregateVersion,
    required Map<String, Object?> payload,
  }) async {
    if (!_eventType.hasMatch(eventType)) {
      throw ArgumentError.value(eventType, 'eventType', 'use o catálogo canônico (docs/08), ex.: customer.created');
    }
    final ctx = session.context;
    await session.db.unsafeExecute(
      'INSERT INTO app.outbox_messages '
      '  (tenant_id, event_type, aggregate_type, aggregate_id, aggregate_version, correlation_id, payload, metadata) '
      'VALUES (@tenantId::uuid, @eventType, @aggregateType, @aggregateId::uuid, @version, '
      '        @correlationId::uuid, @payload::jsonb, @metadata::jsonb)',
      parameters: QueryParameters.named({
        'tenantId': ctx.tenantId!.uuid,
        'eventType': eventType,
        'aggregateType': aggregateType,
        'aggregateId': aggregateId.uuid,
        'version': aggregateVersion,
        'correlationId': ctx.correlationId,
        'payload': jsonEncode(payload),
        'metadata': jsonEncode({
          'actor_type': ctx.actorType.dbValue,
          if (ctx.userId != null) 'actor_user_id': ctx.userId!.uuid,
        }),
      }),
      transaction: transaction,
    );
  }
}
