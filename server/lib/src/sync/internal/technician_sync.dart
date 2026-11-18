import 'dart:convert';

import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/errors/api_errors.dart';
import '../../scheduling/scheduling.dart';
import '../../work_orders/work_orders.dart';

/// Sincronização do app do técnico (D11, docs/06 §6): registro do aparelho,
/// pull do recorte e push de mutações por comando.
///
/// Push: cada mutação roda na sua própria transação, na ordem do lote, e é
/// gravada em `app.sync_mutations` na mesma transação quando aplicada — o
/// reenvio do mesmo `mutationId` devolve o resultado gravado, sem reaplicar.
/// Recusada ou em conflito, as seguintes da mesma visita no lote nem rodam
/// (`DEPENDENCY_FAILED`).
abstract final class TechnicianSync {
  static const maxBatch = 100;
  static const scopeDaysBack = 2;
  static const scopeDaysAhead = 14;

  static const _visitTypes = {
    'visit.start_travel',
    'visit.check_in',
    'visit.pause',
    'visit.resume',
    'visit.finish',
  };
  static const checklistSubmit = 'checklist_response.submit';

  /// Mutações que não mudam o status da visita (entityId ainda é a visita).
  static const _otherTypes = {checklistSubmit, Attachments.registerType, Attachments.signatureType};

  /// Erros que dizem que o servidor mudou (e não que a ação era inválida).
  static const _conflictCodes = {'VERSION_MISMATCH', 'VISIT_CANCELLED', 'VISIT_REASSIGNED'};

  static Future<void> registerDevice(Session session, DeviceRegistration input) async {
    final me = await _technician(session);
    await Devices.registerTechnicianDevice(
      session,
      deviceId: input.deviceId,
      technicianId: me.id,
      platform: input.platform,
      appVersion: input.appVersion,
      osVersion: input.osVersion,
      deviceModel: input.deviceModel,
    );
  }

  static Future<SyncPullResult> pull(Session session, UuidValue deviceId) async {
    await _technician(session);
    await Devices.requireActive(session, deviceId);
    final now = DateTime.now().toUtc();
    final today = DateTime.utc(now.year, now.month, now.day);
    final from = today.subtract(const Duration(days: scopeDaysBack));
    final to = today.add(const Duration(days: scopeDaysAhead + 1));
    final visits = await Visits.mine(session, from: from, to: to);
    final workOrders = await WorkOrders.byIds(session, {for (final v in visits) v.workOrderId}.toList());
    final checklists = await ChecklistResponses.forVisits(session, [for (final v in visits) v.id]);
    return SyncPullResult(
      serverTime: now,
      scopeFrom: from,
      scopeTo: to,
      visits: visits,
      workOrders: workOrders,
      checklists: checklists,
    );
  }

  static Future<List<SyncMutationResult>> push(Session session, SyncPushRequest request) async {
    final me = await _technician(session);
    if (request.mutations.length > maxBatch) {
      throw ApiErrors.fieldError(session, 'mutations', 'TOO_MANY', 'Envie no máximo $maxBatch ações por vez.');
    }
    await Devices.requireActive(session, request.deviceId);
    final failed = <UuidValue>{};
    return [
      for (final m in request.mutations) await _one(session, request.deviceId, me, m, failed),
    ];
  }

  static Future<SyncMutationResult> _one(
    Session session,
    UuidValue deviceId,
    Technician me,
    SyncMutation m,
    Set<UuidValue> failed,
  ) async {
    final previous = await _previous(session, m.mutationId);
    if (previous != null) return previous;

    SyncMutationResult refuse(String status, String code, String message, [Visit? visit]) => SyncMutationResult(
      mutationId: m.mutationId,
      status: status,
      errorCode: code,
      errorMessage: message,
      visit: visit,
    );

    Future<SyncMutationResult> recorded(SyncMutationResult result) async {
      failed.add(m.entityId);
      return _recordOutside(session, deviceId, me, m, result);
    }

    if (failed.contains(m.entityId)) {
      return recorded(
        refuse('rejected', 'DEPENDENCY_FAILED', 'Uma ação anterior desta visita não foi aceita.'),
      );
    }
    if (!_visitTypes.contains(m.type) && !_otherTypes.contains(m.type)) {
      return recorded(refuse('rejected', 'UNKNOWN_TYPE', 'Ação desconhecida: ${m.type}.'));
    }
    VisitMutationPayload? payload;
    ChecklistSubmitPayload? checklist;
    AttachmentRegisterPayload? attachment;
    SignatureCapturePayload? signature;
    try {
      final json = jsonDecode(m.payload) as Map<String, dynamic>;
      switch (m.type) {
        case checklistSubmit:
          checklist = ChecklistSubmitPayload.fromJson(json);
        case Attachments.registerType:
          attachment = AttachmentRegisterPayload.fromJson(json);
        case Attachments.signatureType:
          signature = SignatureCapturePayload.fromJson(json);
        default:
          payload = VisitMutationPayload.fromJson(json);
      }
    } on Object {
      return recorded(refuse('rejected', 'INVALID_PAYLOAD', 'Dados da ação ilegíveis.'));
    }
    final visit = await Visits.findForSync(session, m.entityId);
    if (visit == null) return recorded(refuse('rejected', 'NOT_FOUND', 'Visita não encontrada.'));
    if (visit.technicianId != me.id) {
      return recorded(
        refuse('conflict', 'VISIT_REASSIGNED', 'Esta visita foi transferida para outro técnico.', visit),
      );
    }
    if (visit.status == 'cancelled') {
      return recorded(refuse('conflict', 'VISIT_CANCELLED', 'Esta visita foi cancelada pelo despacho.', visit));
    }

    try {
      Future<SyncMutationResult> apply(Future<SyncMutationResult> Function(Transaction tx) body) =>
          session.db.transaction((tx) async {
            final result = await body(tx);
            await _record(session, deviceId, me, m, result, tx);
            return result;
          });
      SyncMutationResult applied({Visit? updated, VisitChecklist? saved}) =>
          SyncMutationResult(mutationId: m.mutationId, status: 'applied', visit: updated ?? visit, checklist: saved);
      if (checklist case final c?) {
        return await apply((tx) async => applied(saved: await ChecklistResponses.submit(session, visit, me.id, c, tx)));
      }
      if (attachment case final a?) {
        return await apply((tx) async {
          await Attachments.register(session, visit, me.id, a, tx);
          return applied();
        });
      }
      if (signature case final sig?) {
        return await apply(
          (tx) async => applied(updated: await Attachments.captureSignature(session, visit, sig, tx)),
        );
      }
      final p = payload!;
      return await session.db.transaction((tx) async {
        final at = p.occurredAt;
        final v = visit.version;
        final updated = switch (m.type) {
          'visit.start_travel' => await Visits.startTravel(session, visit.id, v, occurredAt: at, transaction: tx),
          'visit.check_in' => await Visits.checkIn(
            session,
            visit.id,
            v,
            p.checkIn ?? VisitCheckIn(method: ''),
            occurredAt: at,
            transaction: tx,
          ),
          'visit.pause' => await Visits.pause(session, visit.id, v, transaction: tx),
          'visit.resume' => await Visits.resume(session, visit.id, v, transaction: tx),
          _ => await Visits.finish(
            session,
            visit.id,
            v,
            p.finish ?? VisitFinish(outcome: ''),
            occurredAt: at,
            transaction: tx,
          ),
        };
        final result = SyncMutationResult(mutationId: m.mutationId, status: 'applied', visit: updated);
        await _record(session, deviceId, me, m, result, tx);
        return result;
      });
    } on DatabaseException {
      // Outro envio do mesmo id gravou primeiro (corrida de reenvio).
      final stored = await _previous(session, m.mutationId);
      if (stored != null) return stored;
      rethrow;
    } on ApiException catch (e) {
      final current = await Visits.findForSync(session, m.entityId);
      final message = switch (e.fieldErrors) {
        final errors? when errors.isNotEmpty => errors.first.message,
        _ => e.detail,
      };
      return recorded(
        refuse(_conflictCodes.contains(e.code) ? 'conflict' : 'rejected', e.code, message, current),
      );
    }
  }

  static Future<Technician> _technician(Session session) async {
    await Authorization.require(session, Visits.executePermission);
    final me = await Technicians.mine(session);
    if (me == null) throw ApiErrors.forbidden(session, 'Seu acesso não está ligado a um técnico desta empresa.');
    return me;
  }

  /// Resultado gravado de um envio anterior. Aplicada vira `duplicate`;
  /// recusada ou em conflito volta como estava.
  static Future<SyncMutationResult?> _previous(Session session, UuidValue mutationId) async {
    final rows = await session.db.unsafeQuery(
      'SELECT result::text FROM app.sync_mutations WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': mutationId.uuid}),
    );
    if (rows.isEmpty) return null;
    final stored = SyncMutationResult.fromJson(jsonDecode(rows.first[0] as String) as Map<String, dynamic>);
    return stored.status == 'applied' ? stored.copyWith(status: 'duplicate') : stored;
  }

  static Future<void> _record(
    Session session,
    UuidValue deviceId,
    Technician me,
    SyncMutation m,
    SyncMutationResult result,
    Transaction tx,
  ) => session.db.unsafeExecute(
    'INSERT INTO app.sync_mutations (id, tenant_id, device_id, technician_id, type, entity_id, status, '
    '                                payload_hash, result, client_timestamp) '
    'VALUES (@id::uuid, app.current_tenant_id(), @device::uuid, @tech::uuid, @type, @entity::uuid, @status, '
    "        sha256(convert_to(@payload, 'UTF8')), @result::jsonb, @ts)",
    parameters: QueryParameters.named({
      'id': m.mutationId.uuid,
      'device': deviceId.uuid,
      'tech': me.id.uuid,
      'type': m.type,
      'entity': m.entityId.uuid,
      'status': result.status,
      'payload': m.payload,
      'result': SerializationManager.encode(result),
      'ts': m.clientTimestamp.toUtc(),
    }),
    transaction: tx,
  );

  /// Grava a recusa numa transação própria (a da mutação foi desfeita).
  /// Se outro envio do mesmo id gravou antes, devolve o que ficou gravado.
  static Future<SyncMutationResult> _recordOutside(
    Session session,
    UuidValue deviceId,
    Technician me,
    SyncMutation m,
    SyncMutationResult result,
  ) async {
    try {
      await session.db.transaction((tx) => _record(session, deviceId, me, m, result, tx));
      return result;
    } on DatabaseException {
      return await _previous(session, m.mutationId) ?? result;
    }
  }
}
