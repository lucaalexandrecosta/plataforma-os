import 'dart:math' as math;

import 'package:serverpod/serverpod.dart';

import '../../assets/assets.dart';
import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';
import '../../work_orders/work_orders.dart';
import 'technicians.dart';

/// Visitas: agenda do despacho (`visits.schedule`) e execução pelo técnico da
/// visita no app de campo (`visits.execute`). Cada ação na visita move a OS na
/// mesma transação (docs/03 §6.2). As transições também são garantidas no
/// banco (trg_guard_status da visita e da OS).
///
/// MVP: técnicos próprios, sem apontamento de horas, checklist nem assinatura
/// (vêm nas próximas etapas).
abstract final class Visits {
  static const schedulePermission = 'visits.schedule';
  static const executePermission = 'visits.execute';
  static const _readPermissions = {schedulePermission, 'work_orders.read'};

  /// Distância máxima, em metros, entre o check-in por GPS e a coordenada da
  /// unidade; acima disso a visita e a OS ficam sinalizadas (não bloqueia).
  static const offSiteMeters = 300.0;

  static const _schedulable = {'open', 'scheduled', 'on_hold', 'in_progress'};
  static const _outcomes = {'resolved', 'needs_return', 'customer_absent', 'not_executed'};
  static const _returnHoldReasons = {'awaiting_part', 'needs_return'};
  static const _active = ['en_route', 'on_site', 'paused'];

  static const _select =
      'SELECT v.id, v.work_order_id, w.number, w.status, w.priority, w.problem_description, '
      '       coalesce(a.asset_tag, a.serial_number), p.name, coalesce(cu.trade_name, cu.name), '
      '       coalesce(b.trade_name, b.legal_name), v.visit_number, v.technician_id, te.name, v.status, v.outcome, '
      '       v.outcome_notes, v.scheduled_start, v.scheduled_end, v.travel_started_at, v.checked_in_at, '
      '       v.finished_at, v.cancelled_at, v.cancellation_reason, v.check_in_method, v.check_in_distance_m, '
      '       v.check_in_off_site, v.check_in_justification, v.version '
      '  FROM app.work_order_visits v '
      '  JOIN app.work_orders w ON w.tenant_id = v.tenant_id AND w.id = v.work_order_id '
      '  LEFT JOIN app.assets a ON a.tenant_id = w.tenant_id AND a.id = w.asset_id '
      '  LEFT JOIN app.products p ON p.tenant_id = a.tenant_id AND p.id = a.product_id '
      '  LEFT JOIN app.customers cu ON cu.tenant_id = w.tenant_id AND cu.id = w.customer_id '
      '  LEFT JOIN app.branches b ON b.tenant_id = w.tenant_id AND b.id = w.branch_id '
      '  LEFT JOIN app.technicians te ON te.tenant_id = v.tenant_id AND te.id = v.technician_id ';

  // ------------------------------------------------------------------ agenda

  /// Visitas que começam em [from, to), opcionalmente de um técnico.
  static Future<List<Visit>> agenda(
    Session session, {
    required DateTime from,
    required DateTime to,
    UuidValue? technicianId,
    bool includeCancelled = false,
  }) async {
    await Authorization.requireAny(session, _readPermissions);
    _checkPeriod(session, from, to);
    final rows = await session.db.unsafeQuery(
      '$_select WHERE v.scheduled_start >= @from AND v.scheduled_start < @to '
      '   AND (@tech::uuid IS NULL OR v.technician_id = @tech::uuid) '
      "   AND (@cancelled OR v.status <> 'cancelled') "
      ' ORDER BY v.scheduled_start, te.name, v.id',
      parameters: QueryParameters.named({
        'from': from.toUtc(),
        'to': to.toUtc(),
        'tech': technicianId?.uuid,
        'cancelled': includeCancelled,
      }),
    );
    return [for (final r in rows) _map(r)];
  }

  /// Visitas do técnico logado: as do período e, fora dele, as que ainda
  /// estão em andamento.
  static Future<List<Visit>> mine(Session session, {required DateTime from, required DateTime to}) async {
    await Authorization.require(session, executePermission);
    _checkPeriod(session, from, to);
    final me = await _me(session);
    final rows = await session.db.unsafeQuery(
      '$_select WHERE v.technician_id = @tech::uuid '
      "   AND v.status <> 'cancelled' "
      '   AND ((v.scheduled_start >= @from AND v.scheduled_start < @to) OR v.status = ANY(@active::text[])) '
      ' ORDER BY v.scheduled_start, v.id',
      parameters: QueryParameters.named({
        'tech': me.id.uuid,
        'from': from.toUtc(),
        'to': to.toUtc(),
        'active': _active,
      }),
    );
    return [for (final r in rows) _map(r)];
  }

  static Future<List<Visit>> ofWorkOrder(Session session, UuidValue workOrderId) async {
    await Authorization.requireAny(session, _readPermissions);
    final rows = await session.db.unsafeQuery(
      '$_select WHERE v.work_order_id = @id::uuid ORDER BY v.visit_number',
      parameters: QueryParameters.named({'id': workOrderId.uuid}),
    );
    return [for (final r in rows) _map(r)];
  }

  static Future<Visit> get(Session session, UuidValue id) async {
    await Authorization.requireAny(session, {..._readPermissions, executePermission});
    final visit = await _find(session, id) ?? (throw ApiErrors.notFound(session));
    if (!await _canRead(session, visit)) throw ApiErrors.notFound(session);
    return visit;
  }

  // ------------------------------------------------------------------ despacho

  static Future<Visit> schedule(Session session, UuidValue workOrderId, VisitInput input) async {
    await Authorization.require(session, schedulePermission);
    final technician = await _validateInput(session, input);
    final id = const Uuid().v7obj();
    for (var attempt = 0; ; attempt++) {
      try {
        await session.db.transaction((tx) async {
          final wo = await WorkOrders.findForVisit(session, workOrderId, transaction: tx);
          if (wo == null) throw ApiErrors.notFound(session, 'OS não encontrada.');
          if (!_schedulable.contains(wo.status)) {
            throw ApiErrors.businessRule(
              session,
              'WORK_ORDER_NOT_SCHEDULABLE',
              'Só dá para agendar visita em OS aberta, agendada, pendente ou em atendimento.',
            );
          }
          await session.db.unsafeExecute(
            'INSERT INTO app.work_order_visits (id, tenant_id, work_order_id, visit_number, technician_id, '
            '                                   scheduled_start, scheduled_end) '
            'SELECT @id::uuid, app.current_tenant_id(), @wo::uuid, coalesce(max(visit_number), 0) + 1, @tech::uuid, '
            '       @start, @end '
            '  FROM app.work_order_visits WHERE work_order_id = @wo::uuid',
            parameters: QueryParameters.named({
              'id': id.uuid,
              'wo': workOrderId.uuid,
              'tech': technician.id.uuid,
              'start': input.scheduledStart.toUtc(),
              'end': input.scheduledEnd.toUtc(),
            }),
            transaction: tx,
          );
          await WorkOrders.onVisitScheduled(session, workOrderId, technician.id, tx);
        });
        break;
      } on DatabaseQueryException catch (e) {
        // Outro agendamento da mesma OS pegou o mesmo número de visita.
        if (isUniqueViolation(e) && attempt < 3) continue;
        rethrow;
      }
    }
    return (await _find(session, id))!;
  }

  /// Nova janela e/ou outro técnico, enquanto a visita está agendada.
  static Future<Visit> reschedule(Session session, UuidValue id, int expectedVersion, VisitInput input) async {
    await Authorization.require(session, schedulePermission);
    final technician = await _validateInput(session, input);
    final visit = await _current(session, id, expectedVersion);
    if (visit.status != 'scheduled') {
      throw ApiErrors.businessRule(session, 'VISIT_NOT_SCHEDULED', 'Só visita ainda agendada pode ser reagendada.');
    }
    await session.db.transaction((tx) async {
      await _apply(
        session,
        id,
        expectedVersion,
        'technician_id = @tech::uuid, scheduled_start = @start, scheduled_end = @end',
        {'tech': technician.id.uuid, 'start': input.scheduledStart.toUtc(), 'end': input.scheduledEnd.toUtc()},
        tx,
      );
      await WorkOrders.onVisitScheduled(session, visit.workOrderId, technician.id, tx);
    });
    return (await _find(session, id))!;
  }

  /// Desmarca a visita (agendada ou em deslocamento). Se a OS ficar sem
  /// visita, volta para aberta.
  static Future<Visit> cancel(Session session, UuidValue id, int expectedVersion, {required String reason}) async {
    await Authorization.require(session, schedulePermission);
    final text = cleanText(reason);
    if (text == null) throw ApiErrors.fieldError(session, 'reason', 'REQUIRED', 'Informe o motivo.');
    final visit = await _current(session, id, expectedVersion);
    _requireStatus(session, visit, const {
      'scheduled',
      'en_route',
    }, 'Só visita agendada ou em deslocamento pode ser desmarcada.');
    await session.db.transaction((tx) async {
      await _apply(
        session,
        id,
        expectedVersion,
        "status = 'cancelled', cancelled_at = now(), cancellation_reason = @reason",
        {'reason': text},
        tx,
      );
      await WorkOrders.onVisitCancelled(session, visit.workOrderId, tx);
    });
    return (await _find(session, id))!;
  }

  // ------------------------------------------------------------------ execução (técnico da visita)

  static Future<Visit> startTravel(Session session, UuidValue id, int expectedVersion) async {
    final visit = await _ownVisit(session, id, expectedVersion);
    _requireStatus(session, visit, const {'scheduled'}, 'O deslocamento só começa em visita agendada.');
    await _ensureNoOtherActive(session, visit);
    await session.db.transaction((tx) async {
      await _apply(session, id, expectedVersion, "status = 'en_route', travel_started_at = now()", const {}, tx);
      await WorkOrders.onVisitStarted(session, visit.workOrderId, tx, checkedIn: false);
    });
    return (await _find(session, id))!;
  }

  static Future<Visit> checkIn(Session session, UuidValue id, int expectedVersion, VisitCheckIn input) async {
    final visit = await _ownVisit(session, id, expectedVersion);
    _requireStatus(session, visit, const {
      'scheduled',
      'en_route',
    }, 'Check-in só em visita agendada ou em deslocamento.');
    await _ensureNoOtherActive(session, visit);
    final wo = (await WorkOrders.findForVisit(session, visit.workOrderId))!;
    final justification = cleanText(input.justification);
    double? distance;
    switch (input.method) {
      case 'qr':
        final scanned = cleanText(input.scannedCode);
        if (scanned == null) throw ApiErrors.fieldError(session, 'scannedCode', 'REQUIRED', 'Leia a etiqueta do bem.');
        final found = await QrTags.findByScan(session, scanned);
        if (found == null || found.tag.status != 'bound' || found.tag.assetId != wo.assetId || wo.assetId == null) {
          throw ApiErrors.businessRule(session, 'QR_ASSET_MISMATCH', 'A etiqueta lida não é do bem desta OS.');
        }
      case 'gps':
        if (input.latitude == null || input.longitude == null) {
          throw ApiErrors.fieldError(session, 'latitude', 'REQUIRED', 'Sem a posição do GPS.');
        }
        if (wo.requireQrCheckIn && justification == null) {
          throw ApiErrors.fieldError(
            session,
            'justification',
            'REQUIRED',
            'Esta OS pede a leitura do QR; justifique o check-in por GPS.',
          );
        }
        if (wo.siteLatitude != null && wo.siteLongitude != null) {
          distance = _meters(input.latitude!, input.longitude!, wo.siteLatitude!, wo.siteLongitude!);
        }
      case 'manual':
        if (justification == null) {
          throw ApiErrors.fieldError(session, 'justification', 'REQUIRED', 'Justifique o check-in manual.');
        }
      default:
        throw ApiErrors.fieldError(session, 'method', 'INVALID', 'Método de check-in inválido.');
    }
    final offSite = distance != null && distance > offSiteMeters;
    await session.db.transaction((tx) async {
      await _apply(
        session,
        id,
        expectedVersion,
        "status = 'on_site', checked_in_at = now(), check_in_method = @method, check_in_latitude = @lat, "
        'check_in_longitude = @lng, check_in_accuracy_m = @accuracy, check_in_distance_m = @distance, '
        'check_in_off_site = @offSite, check_in_justification = @justification',
        {
          'method': input.method,
          'lat': input.latitude,
          'lng': input.longitude,
          'accuracy': input.accuracyM,
          'distance': distance,
          'offSite': offSite,
          'justification': justification,
        },
        tx,
      );
      await WorkOrders.onVisitStarted(session, visit.workOrderId, tx, checkedIn: true, offSite: offSite);
    });
    return (await _find(session, id))!;
  }

  static Future<Visit> pause(Session session, UuidValue id, int expectedVersion) async {
    final visit = await _ownVisit(session, id, expectedVersion);
    _requireStatus(session, visit, const {'on_site'}, 'Só visita em execução pode ser pausada.');
    await session.db.transaction(
      (tx) => _apply(session, id, expectedVersion, "status = 'paused'", const {}, tx),
    );
    return (await _find(session, id))!;
  }

  static Future<Visit> resume(Session session, UuidValue id, int expectedVersion) async {
    final visit = await _ownVisit(session, id, expectedVersion);
    _requireStatus(session, visit, const {'paused'}, 'Só visita pausada pode ser retomada.');
    await _ensureNoOtherActive(session, visit);
    await session.db.transaction(
      (tx) => _apply(session, id, expectedVersion, "status = 'on_site'", const {}, tx),
    );
    return (await _find(session, id))!;
  }

  static Future<Visit> finish(Session session, UuidValue id, int expectedVersion, VisitFinish input) async {
    final visit = await _ownVisit(session, id, expectedVersion);
    if (!_outcomes.contains(input.outcome)) {
      throw ApiErrors.fieldError(session, 'outcome', 'INVALID', 'Resultado da visita inválido.');
    }
    final notes = cleanText(input.notes);
    final holdReason = cleanText(input.holdReason);
    final checkedIn = const {'on_site', 'paused'}.contains(visit.status);
    if (checkedIn) {
      // Com check-in vale qualquer resultado.
    } else if (const {'scheduled', 'en_route'}.contains(visit.status)) {
      if (!const {'customer_absent', 'not_executed'}.contains(input.outcome)) {
        throw ApiErrors.businessRule(
          session,
          'CHECK_IN_REQUIRED',
          'Sem check-in a visita só termina como "cliente ausente" ou "não executada".',
        );
      }
    } else {
      throw ApiErrors.businessRule(session, 'INVALID_TRANSITION', 'Esta visita já terminou.');
    }
    if (input.outcome == 'resolved' && notes == null) {
      throw ApiErrors.fieldError(session, 'notes', 'REQUIRED', 'Descreva o que foi feito.');
    }
    if (input.outcome == 'needs_return' && holdReason != null && !_returnHoldReasons.contains(holdReason)) {
      throw ApiErrors.fieldError(session, 'holdReason', 'INVALID', 'Use "aguardando peça" ou "precisa de retorno".');
    }
    await session.db.transaction((tx) async {
      await _apply(
        session,
        id,
        expectedVersion,
        "status = 'finished', finished_at = now(), outcome = @outcome, outcome_notes = @notes, "
        'finish_latitude = @lat, finish_longitude = @lng',
        {'outcome': input.outcome, 'notes': notes, 'lat': input.latitude, 'lng': input.longitude},
        tx,
      );
      await WorkOrders.onVisitFinished(
        session,
        visit.workOrderId,
        tx,
        outcome: input.outcome,
        technicianId: visit.technicianId!,
        notes: notes,
        holdReason: holdReason,
      );
    });
    return (await _find(session, id))!;
  }

  // ------------------------------------------------------------------ internos

  static void _checkPeriod(Session session, DateTime from, DateTime to) {
    if (!to.isAfter(from) || to.difference(from).inDays > 62) {
      throw ApiErrors.fieldError(session, 'to', 'INVALID', 'Escolha um período de até 62 dias.');
    }
  }

  static Future<Technician> _validateInput(Session session, VisitInput input) async {
    final technician = await Technicians.find(session, input.technicianId);
    final errors = [
      if (technician == null)
        FieldError(path: 'technicianId', code: 'NOT_FOUND', message: 'Técnico não encontrado.')
      else if (!technician.isActive)
        FieldError(path: 'technicianId', code: 'INACTIVE', message: 'Este técnico está inativo.'),
      if (!input.scheduledEnd.isAfter(input.scheduledStart))
        FieldError(path: 'scheduledEnd', code: 'INVALID', message: 'O fim precisa ser depois do início.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    return technician!;
  }

  /// Técnico ligado à pessoa logada; sem vínculo = `FORBIDDEN`.
  static Future<Technician> _me(Session session) async {
    final me = await Technicians.mine(session);
    if (me == null) {
      throw ApiErrors.forbidden(session, 'Seu acesso não está ligado a um técnico desta empresa.');
    }
    return me;
  }

  /// Visita do técnico logado, na versão esperada. Visita de outro técnico
  /// responde `NOT_FOUND` (o app só conhece as próprias).
  static Future<Visit> _ownVisit(Session session, UuidValue id, int expectedVersion) async {
    await Authorization.require(session, executePermission);
    final me = await _me(session);
    final visit = await _find(session, id);
    if (visit == null || visit.technicianId != me.id) throw ApiErrors.notFound(session);
    if (visit.version != expectedVersion) throw ApiErrors.versionMismatch(session, visit.version);
    return visit;
  }

  static Future<bool> _canRead(Session session, Visit visit) async {
    try {
      await Authorization.requireAny(session, _readPermissions);
      return true;
    } on ApiException {
      final me = await Technicians.mine(session);
      return me != null && visit.technicianId == me.id;
    }
  }

  static Future<void> _ensureNoOtherActive(Session session, Visit visit) async {
    final rows = await session.db.unsafeQuery(
      'SELECT 1 FROM app.work_order_visits WHERE technician_id = @tech::uuid AND id <> @id::uuid '
      '   AND status = ANY(@active::text[]) LIMIT 1',
      parameters: QueryParameters.named({'tech': visit.technicianId!.uuid, 'id': visit.id.uuid, 'active': _active}),
    );
    if (rows.isNotEmpty) {
      throw ApiErrors.businessRule(
        session,
        'ANOTHER_VISIT_ACTIVE',
        'Você tem outra visita em andamento; finalize ou pause antes.',
      );
    }
  }

  static void _requireStatus(Session session, Visit visit, Set<String> allowed, String message) {
    if (!allowed.contains(visit.status)) throw ApiErrors.businessRule(session, 'INVALID_TRANSITION', message);
  }

  static Future<Visit> _current(Session session, UuidValue id, int expectedVersion) async {
    final visit = await _find(session, id);
    if (visit == null) throw ApiErrors.notFound(session);
    if (visit.version != expectedVersion) throw ApiErrors.versionMismatch(session, visit.version);
    return visit;
  }

  static Future<void> _apply(
    Session session,
    UuidValue id,
    int expectedVersion,
    String set,
    Map<String, Object?> params,
    Transaction tx,
  ) async {
    final changed = await session.db.unsafeExecute(
      'UPDATE app.work_order_visits SET $set WHERE id = @id::uuid AND version = @version',
      parameters: QueryParameters.named({'id': id.uuid, 'version': expectedVersion, ...params}),
      transaction: tx,
    );
    if (changed == 0) {
      final rows = await session.db.unsafeQuery(
        'SELECT version FROM app.work_order_visits WHERE id = @id::uuid',
        parameters: QueryParameters.named({'id': id.uuid}),
        transaction: tx,
      );
      throw ApiErrors.versionMismatch(session, rows.first[0] as int);
    }
  }

  static Future<Visit?> _find(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      '$_select WHERE v.id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return rows.isEmpty ? null : _map(rows.first);
  }

  /// Distância em metros entre dois pontos (haversine).
  static double _meters(double lat1, double lng1, double lat2, double lng2) {
    const r = 6371000.0;
    double rad(double d) => d * math.pi / 180;
    final dLat = rad(lat2 - lat1);
    final dLng = rad(lng2 - lng1);
    final a =
        math.pow(math.sin(dLat / 2), 2) + math.cos(rad(lat1)) * math.cos(rad(lat2)) * math.pow(math.sin(dLng / 2), 2);
    return 2 * r * math.asin(math.sqrt(a));
  }

  static Visit _map(List<Object?> r) => Visit(
    id: sqlUuid(r[0]),
    workOrderId: sqlUuid(r[1]),
    workOrderNumber: r[2] as String,
    workOrderStatus: r[3] as String,
    workOrderPriority: r[4] as String,
    problemDescription: r[5] as String?,
    assetLabel: r[6] as String?,
    productName: r[7] as String?,
    customerName: r[8] as String?,
    branchName: r[9] as String?,
    visitNumber: r[10] as int,
    technicianId: sqlUuidOrNull(r[11]),
    technicianName: r[12] as String?,
    status: r[13] as String,
    outcome: r[14] as String?,
    outcomeNotes: r[15] as String?,
    scheduledStart: r[16] as DateTime,
    scheduledEnd: r[17] as DateTime,
    travelStartedAt: r[18] as DateTime?,
    checkedInAt: r[19] as DateTime?,
    finishedAt: r[20] as DateTime?,
    cancelledAt: r[21] as DateTime?,
    cancellationReason: r[22] as String?,
    checkInMethod: r[23] as String?,
    checkInDistanceM: r[24] as double?,
    checkInOffSite: r[25] as bool,
    checkInJustification: r[26] as String?,
    version: r[27] as int,
  );
}
