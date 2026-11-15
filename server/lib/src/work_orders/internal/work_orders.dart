import 'package:serverpod/serverpod.dart';

import '../../assets/assets.dart';
import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/context/request_context.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';
import '../../tenancy/tenancy.dart';

/// Ordens de serviço (docs/03 §6.1). Abertura pelo bem (lista ou etiqueta QR),
/// herdando filial, centro de custo e, se o bem estiver em comodato, o cliente.
///
/// MVP sem visitas: iniciar, pausar e concluir mudam a OS direto (permissão
/// `work_orders.update` ou `visits.execute`); quando a agenda entrar, esses
/// passos passam a vir das visitas. A tabela de transições também é garantida
/// no banco (trg_guard_status); aqui a pessoa recebe a mensagem certa antes.
abstract final class WorkOrders {
  static const readPermission = 'work_orders.read';
  static const createPermission = 'work_orders.create';
  static const updatePermission = 'work_orders.update';
  static const cancelPermission = 'work_orders.triage';
  static const closePermission = 'work_orders.close';
  static const reopenPermission = 'work_orders.reopen';
  static const _executePermissions = {updatePermission, 'visits.execute'};

  static const priorities = {'low', 'normal', 'high', 'urgent'};
  static const holdReasons = {'awaiting_part', 'awaiting_customer', 'needs_return', 'awaiting_approval', 'other'};
  static const cancellationReasons = {'customer_cancelled', 'created_in_error', 'other'};
  static const openStatuses = ['requested', 'open', 'scheduled', 'in_progress', 'on_hold'];
  static const _finished = {'completed', 'closed', 'cancelled'};

  static const _select =
      'SELECT w.id, w.number, w.work_order_type_id, t.name, w.status, w.priority, w.origin, w.entry_method, '
      '       w.asset_id, coalesce(a.asset_tag, a.serial_number), p.name, w.branch_id, '
      '       coalesce(b.trade_name, b.legal_name), w.cost_center_id, cc.code || \' - \' || cc.name, '
      '       w.customer_id, coalesce(cu.trade_name, cu.name), w.problem_description, w.requester_name, '
      '       w.requester_phone, w.hold_reason, w.status_reason, w.resolution_notes, w.cancellation_reason, '
      '       w.cancellation_note, w.reopened_count, w.created_at, w.status_changed_at, w.started_at, '
      '       w.completed_at, w.closed_at, w.cancelled_at, w.version '
      '  FROM app.work_orders w '
      '  JOIN app.work_order_types t ON t.tenant_id = w.tenant_id AND t.id = w.work_order_type_id '
      '  LEFT JOIN app.assets a ON a.tenant_id = w.tenant_id AND a.id = w.asset_id '
      '  LEFT JOIN app.products p ON p.tenant_id = a.tenant_id AND p.id = a.product_id '
      '  LEFT JOIN app.branches b ON b.tenant_id = w.tenant_id AND b.id = w.branch_id '
      '  LEFT JOIN app.cost_centers cc ON cc.tenant_id = w.tenant_id AND cc.id = w.cost_center_id '
      '  LEFT JOIN app.customers cu ON cu.tenant_id = w.tenant_id AND cu.id = w.customer_id ';

  // ------------------------------------------------------------------ consulta

  static Future<WorkOrderPage> list(
    Session session, {
    String? search,
    List<String>? statuses,
    bool openOnly = false,
    UuidValue? assetId,
    UuidValue? branchId,
    UuidValue? costCenterId,
    UuidValue? workOrderTypeId,
    int limit = 50,
    int offset = 0,
  }) async {
    await Authorization.require(session, readPermission);
    final term = cleanText(search);
    const where =
        ' WHERE (@statuses::text[] IS NULL OR w.status = ANY(@statuses::text[])) '
        '   AND (@assetId::uuid IS NULL OR w.asset_id = @assetId::uuid) '
        '   AND (@branchId::uuid IS NULL OR w.branch_id = @branchId::uuid) '
        '   AND (@costCenterId::uuid IS NULL OR w.cost_center_id = @costCenterId::uuid) '
        '   AND (@typeId::uuid IS NULL OR w.work_order_type_id = @typeId::uuid) '
        "   AND (@term::text IS NULL OR w.number ILIKE '%' || @term || '%' OR a.asset_tag ILIKE '%' || @term || '%' "
        "        OR a.serial_number ILIKE '%' || @term || '%' OR w.problem_description ILIKE '%' || @term || '%') ";
    final wanted = <String>{...?statuses, if (openOnly) ...openStatuses};
    final params = {
      'statuses': wanted.isEmpty ? null : wanted.toList(),
      'assetId': assetId?.uuid,
      'branchId': branchId?.uuid,
      'costCenterId': costCenterId?.uuid,
      'typeId': workOrderTypeId?.uuid,
      'term': term,
    };
    final rows = await session.db.unsafeQuery(
      '$_select$where ORDER BY w.created_at DESC, w.id DESC LIMIT @limit OFFSET @offset',
      parameters: QueryParameters.named({...params, 'limit': limit.clamp(1, 200), 'offset': offset < 0 ? 0 : offset}),
    );
    final total = await session.db.unsafeQuery(
      'SELECT count(*) FROM app.work_orders w LEFT JOIN app.assets a ON a.tenant_id = w.tenant_id AND a.id = w.asset_id '
      '$where',
      parameters: QueryParameters.named(params),
    );
    return WorkOrderPage(items: [for (final r in rows) _map(r)], total: total.first[0] as int);
  }

  static Future<WorkOrderDetail> get(Session session, UuidValue id) async {
    await Authorization.require(session, readPermission);
    return _detail(session, id);
  }

  // ------------------------------------------------------------------ abertura

  static Future<WorkOrderDetail> open(Session session, WorkOrderInput input) async {
    await Authorization.require(session, createPermission);
    final type = await _findType(session, input.workOrderTypeId);
    final priority = cleanText(input.priority) ?? type?.defaultPriority ?? 'normal';
    final errors = [
      if (type == null)
        FieldError(path: 'workOrderTypeId', code: 'NOT_FOUND', message: 'Tipo de OS não encontrado.')
      else if (!type.isActive)
        FieldError(path: 'workOrderTypeId', code: 'INACTIVE', message: 'Este tipo de OS está inativo.'),
      if (!priorities.contains(priority))
        FieldError(path: 'priority', code: 'INVALID', message: 'Prioridade inválida.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);

    var entryMethod = 'backoffice';
    var typedCode = false;
    UuidValue? assetId = input.assetId;
    final scanned = cleanText(input.scannedCode);
    if (scanned != null) {
      final found = await QrTags.findByScan(session, scanned);
      if (found == null) throw ApiErrors.fieldError(session, 'scannedCode', 'NOT_FOUND', 'Etiqueta não encontrada.');
      if (found.tag.status == 'revoked') {
        throw ApiErrors.businessRule(session, 'TAG_REVOKED', 'Esta etiqueta foi revogada e não pode ser usada.');
      }
      if (found.tag.assetId == null) {
        throw ApiErrors.businessRule(session, 'TAG_NOT_BOUND', 'Esta etiqueta ainda não foi vinculada a um bem.');
      }
      if (assetId != null && assetId != found.tag.assetId) {
        throw ApiErrors.fieldError(session, 'scannedCode', 'ASSET_MISMATCH', 'A etiqueta lida é de outro bem.');
      }
      assetId = found.tag.assetId;
      typedCode = found.typedCode;
      entryMethod = typedCode ? 'short_code' : 'qr_token';
    } else if (assetId != null) {
      entryMethod = 'asset_list';
    }

    final asset = assetId == null ? null : await AssetRegistry.findForWorkOrder(session, assetId);
    if (assetId != null && asset == null) {
      throw ApiErrors.fieldError(session, 'assetId', 'NOT_FOUND', 'Bem não encontrado.');
    }
    if (asset == null && type!.requiresAsset) {
      throw ApiErrors.fieldError(session, 'assetId', 'REQUIRED', 'Este tipo de OS exige o bem.');
    }
    if (asset != null && asset.status == 'retired') {
      throw ApiErrors.businessRule(session, 'ASSET_RETIRED', 'Este bem foi baixado e não recebe OS.');
    }
    if (asset != null && !asset.isActive) {
      throw ApiErrors.businessRule(session, 'ASSET_INACTIVE', 'Este bem está inativo e não recebe OS.');
    }

    final branchId = asset?.branchId ?? (await Branches.findDefault(session))?.id;
    final origin = session.context.actorType == ActorType.technician ? 'technician_app' : 'backoffice';
    final id = const Uuid().v7obj();
    await session.db.unsafeExecute(
      'INSERT INTO app.work_orders (id, tenant_id, work_order_type_id, status, priority, origin, entry_method, '
      '                             branch_id, cost_center_id, customer_id, customer_site_id, asset_id, '
      '                             problem_description, requester_name, requester_phone, flag_typed_code, '
      '                             triaged_at, triaged_by) '
      "VALUES (@id::uuid, app.current_tenant_id(), @typeId::uuid, 'open', @priority, @origin, @entryMethod, "
      '        @branchId::uuid, @costCenterId::uuid, @customerId::uuid, @customerSiteId::uuid, @assetId::uuid, '
      '        @problem, @requesterName, @requesterPhone, @typedCode, now(), app.current_user_id())',
      parameters: QueryParameters.named({
        'id': id.uuid,
        'typeId': type!.id.uuid,
        'priority': priority,
        'origin': origin,
        'entryMethod': entryMethod,
        'branchId': branchId?.uuid,
        'costCenterId': asset?.costCenterId?.uuid,
        'customerId': asset?.customerId?.uuid,
        'customerSiteId': asset?.customerSiteId?.uuid,
        'assetId': asset?.id.uuid,
        'problem': cleanText(input.problemDescription),
        'requesterName': cleanText(input.requesterName),
        'requesterPhone': cleanText(input.requesterPhone),
        'typedCode': typedCode,
      }),
    );
    return _detail(session, id);
  }

  // ------------------------------------------------------------------ edição

  static Future<WorkOrder> update(Session session, UuidValue id, int expectedVersion, WorkOrderChanges changes) async {
    await Authorization.require(session, updatePermission);
    final current = await _current(session, id, expectedVersion);
    if (_finished.contains(current.status)) {
      throw ApiErrors.businessRule(session, 'WORK_ORDER_FINISHED', 'OS concluída, encerrada ou cancelada não muda.');
    }
    final type = await _findType(session, changes.workOrderTypeId);
    final errors = [
      if (type == null)
        FieldError(path: 'workOrderTypeId', code: 'NOT_FOUND', message: 'Tipo de OS não encontrado.')
      else if (!type.isActive && type.id != current.workOrderTypeId)
        FieldError(path: 'workOrderTypeId', code: 'INACTIVE', message: 'Este tipo de OS está inativo.')
      else if (type.requiresAsset && current.assetId == null)
        FieldError(path: 'workOrderTypeId', code: 'ASSET_REQUIRED', message: 'Este tipo de OS exige o bem.'),
      if (!priorities.contains(changes.priority))
        FieldError(path: 'priority', code: 'INVALID', message: 'Prioridade inválida.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    await _apply(
      session,
      id,
      expectedVersion,
      'work_order_type_id = @typeId::uuid, priority = @priority, problem_description = @problem, '
      'requester_name = @requesterName, requester_phone = @requesterPhone',
      {
        'typeId': changes.workOrderTypeId.uuid,
        'priority': changes.priority,
        'problem': cleanText(changes.problemDescription),
        'requesterName': cleanText(changes.requesterName),
        'requesterPhone': cleanText(changes.requesterPhone),
      },
    );
    return (await _find(session, id))!;
  }

  // ------------------------------------------------------------------ status

  /// Início (ou retomada) do atendimento: `open`/`scheduled`/`on_hold` →
  /// `in_progress`. O primeiro início marca `started_at` e o primeiro
  /// atendimento do SLA.
  static Future<WorkOrder> start(Session session, UuidValue id, int expectedVersion) async {
    await Authorization.requireAny(session, _executePermissions);
    return _transition(
      session,
      id,
      expectedVersion,
      from: const {'open', 'scheduled', 'on_hold'},
      to: 'in_progress',
      set: 'started_at = coalesce(started_at, now()), first_response_at = coalesce(first_response_at, now())',
    );
  }

  /// Pendência (peça, cliente, retorno...): `in_progress`/`scheduled` →
  /// `on_hold`.
  static Future<WorkOrder> hold(
    Session session,
    UuidValue id,
    int expectedVersion, {
    required String holdReason,
    String? note,
  }) async {
    await Authorization.requireAny(session, _executePermissions);
    if (!holdReasons.contains(holdReason)) {
      throw ApiErrors.fieldError(session, 'holdReason', 'INVALID', 'Motivo de pendência inválido.');
    }
    if (holdReason == 'other' && cleanText(note) == null) {
      throw ApiErrors.fieldError(session, 'note', 'REQUIRED', 'Descreva o motivo da pendência.');
    }
    return _transition(
      session,
      id,
      expectedVersion,
      from: const {'in_progress', 'scheduled'},
      to: 'on_hold',
      reason: note,
      set: 'hold_reason = @holdReason',
      params: {'holdReason': holdReason},
    );
  }

  /// Conclusão pelo técnico: `in_progress` → `completed`, com o que foi feito.
  static Future<WorkOrder> complete(
    Session session,
    UuidValue id,
    int expectedVersion, {
    required String resolutionNotes,
  }) async {
    await Authorization.requireAny(session, _executePermissions);
    final notes = cleanText(resolutionNotes);
    if (notes == null) {
      throw ApiErrors.fieldError(session, 'resolutionNotes', 'REQUIRED', 'Descreva o que foi feito.');
    }
    await _ensureNoActiveVisit(session, id);
    return _transition(
      session,
      id,
      expectedVersion,
      from: const {'in_progress'},
      to: 'completed',
      set: 'completed_at = now(), resolution_notes = @notes',
      params: {'notes': notes},
    );
  }

  /// Conferência e encerramento: `completed` → `closed`.
  static Future<WorkOrder> close(Session session, UuidValue id, int expectedVersion) async {
    await Authorization.require(session, closePermission);
    return _transition(
      session,
      id,
      expectedVersion,
      from: const {'completed'},
      to: 'closed',
      set: 'closed_at = now(), closed_by = app.current_user_id()',
    );
  }

  static Future<WorkOrder> cancel(
    Session session,
    UuidValue id,
    int expectedVersion, {
    required String reason,
    String? note,
  }) async {
    await Authorization.require(session, cancelPermission);
    if (!cancellationReasons.contains(reason)) {
      throw ApiErrors.fieldError(session, 'reason', 'INVALID', 'Motivo de cancelamento inválido.');
    }
    if (reason == 'other' && cleanText(note) == null) {
      throw ApiErrors.fieldError(session, 'note', 'REQUIRED', 'Descreva o motivo do cancelamento.');
    }
    await _ensureNoActiveVisit(session, id);
    final cancelled = await _transition(
      session,
      id,
      expectedVersion,
      from: const {'requested', 'open', 'scheduled', 'on_hold'},
      to: 'cancelled',
      reason: note,
      set:
          'cancelled_at = now(), cancelled_by = app.current_user_id(), cancellation_reason = @reason, '
          'cancellation_note = @note',
      params: {'reason': reason, 'note': cleanText(note)},
    );
    // Visitas ainda agendadas caem junto com a OS.
    await session.db.unsafeExecute(
      "UPDATE app.work_order_visits SET status = 'cancelled', cancelled_at = now(), "
      "       cancellation_reason = 'OS cancelada' "
      " WHERE work_order_id = @id::uuid AND status = 'scheduled'",
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return cancelled;
  }

  static Future<void> _ensureNoActiveVisit(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      'SELECT 1 FROM app.work_order_visits WHERE work_order_id = @id::uuid '
      "   AND status IN ('en_route', 'on_site', 'paused') LIMIT 1",
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    if (rows.isNotEmpty) {
      throw ApiErrors.businessRule(
        session,
        'VISIT_IN_PROGRESS',
        'Há uma visita em andamento nesta OS; o técnico precisa finalizá-la antes.',
      );
    }
  }

  /// Devolução ou reabertura: `completed`/`closed`/`cancelled` → `open`, com
  /// motivo. Limpa conclusão, encerramento e cancelamento (o histórico de
  /// status guarda o que houve).
  static Future<WorkOrder> reopen(Session session, UuidValue id, int expectedVersion, {required String reason}) async {
    await Authorization.require(session, reopenPermission);
    if (cleanText(reason) == null) {
      throw ApiErrors.fieldError(session, 'reason', 'REQUIRED', 'Informe o motivo da reabertura.');
    }
    return _transition(
      session,
      id,
      expectedVersion,
      from: const {'completed', 'closed', 'cancelled'},
      to: 'open',
      reason: reason,
      set:
          'completed_at = NULL, closed_at = NULL, closed_by = NULL, cancelled_at = NULL, cancelled_by = NULL, '
          'cancellation_reason = NULL, cancellation_note = NULL',
    );
  }

  // ------------------------------------------------------------------ visitas

  // Efeitos das visitas na OS (docs/03 §6.2, "Como a visita move a OS"),
  // chamados pelo módulo scheduling na mesma transação da visita. Quem chama
  // já conferiu a permissão; aqui não há versão esperada (é efeito do sistema).

  /// OS para a visita (sem checar permissão), com o que o check-in precisa.
  static Future<WorkOrderForVisit?> findForVisit(Session session, UuidValue id, {Transaction? transaction}) async {
    final rows = await session.db.unsafeQuery(
      'SELECT w.id, w.number, w.status, w.asset_id, s.latitude, s.longitude, '
      '       coalesce(t.require_qr_check_in, ts.require_qr_check_in, false) '
      '  FROM app.work_orders w '
      '  JOIN app.work_order_types t ON t.tenant_id = w.tenant_id AND t.id = w.work_order_type_id '
      '  LEFT JOIN app.tenant_settings ts ON ts.tenant_id = w.tenant_id '
      '  LEFT JOIN app.customer_sites s ON s.tenant_id = w.tenant_id AND s.id = w.customer_site_id '
      ' WHERE w.id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
      transaction: transaction,
    );
    if (rows.isEmpty) return null;
    final r = rows.first;
    return WorkOrderForVisit(
      id: sqlUuid(r[0]),
      number: r[1] as String,
      status: r[2] as String,
      assetId: sqlUuidOrNull(r[3]),
      siteLatitude: r[4] as double?,
      siteLongitude: r[5] as double?,
      requireQrCheckIn: r[6] as bool,
    );
  }

  /// Visita agendada: `open`/`on_hold` → `scheduled`; o técnico vira o
  /// atribuído da OS.
  static Future<void> onVisitScheduled(Session session, UuidValue id, UuidValue technicianId, Transaction tx) =>
      session.db.unsafeExecute(
        'UPDATE app.work_orders SET assigned_technician_id = @tech::uuid, '
        "       status = CASE WHEN status IN ('open', 'on_hold') THEN 'scheduled' ELSE status END, "
        "       status_reason = CASE WHEN status IN ('open', 'on_hold') THEN NULL ELSE status_reason END "
        ' WHERE id = @id::uuid',
        parameters: QueryParameters.named({'id': id.uuid, 'tech': technicianId.uuid}),
        transaction: tx,
      );

  /// Deslocamento ou check-in: `open`/`scheduled`/`on_hold` → `in_progress`.
  /// O check-in marca o primeiro atendimento (SLA); [offSite] sinaliza a OS.
  static Future<void> onVisitStarted(
    Session session,
    UuidValue id,
    Transaction tx, {
    required bool checkedIn,
    bool offSite = false,
  }) => session.db.unsafeExecute(
    "UPDATE app.work_orders SET status = CASE WHEN status IN ('open', 'scheduled', 'on_hold') THEN 'in_progress' ELSE status END, "
    '       status_reason = NULL, started_at = coalesce(started_at, now()), '
    '       first_response_at = CASE WHEN @checkedIn THEN coalesce(first_response_at, now()) ELSE first_response_at END, '
    '       flag_off_site = flag_off_site OR @offSite '
    ' WHERE id = @id::uuid',
    parameters: QueryParameters.named({'id': id.uuid, 'checkedIn': checkedIn, 'offSite': offSite}),
    transaction: tx,
  );

  /// Visita finalizada. Se ainda houver outra visita ativa da OS, a OS fica
  /// como está. `resolved` conclui (e encerra direto se o tenant dispensa a
  /// conferência); `needs_return` e `customer_absent` deixam pendente;
  /// `not_executed` devolve à fila.
  static Future<void> onVisitFinished(
    Session session,
    UuidValue id,
    Transaction tx, {
    required String outcome,
    required UuidValue technicianId,
    String? notes,
    String? holdReason,
  }) async {
    if (await _hasActiveVisit(session, id, tx)) return;
    // O driver recusa parâmetro que a SQL não usa: cada caso monta os seus.
    final params = <String, Object?>{'id': id.uuid, 'notes': notes};
    final String set;
    switch (outcome) {
      case 'resolved':
        set =
            "status = 'completed', completed_at = now(), completed_by_technician_id = @tech::uuid, "
            'resolution_notes = coalesce(@notes, resolution_notes), status_reason = NULL';
        params['tech'] = technicianId.uuid;
      case 'needs_return':
        set = "status = 'on_hold', hold_reason = @hold, status_reason = @notes";
        params['hold'] = holdReason ?? 'needs_return';
      case 'customer_absent':
        set = "status = 'on_hold', hold_reason = 'awaiting_customer', status_reason = @notes";
      default:
        set = "status = 'open', status_reason = @notes";
    }
    await session.db.unsafeExecute(
      'UPDATE app.work_orders SET $set WHERE id = @id::uuid',
      parameters: QueryParameters.named(params),
      transaction: tx,
    );
    if (outcome == 'resolved') {
      await session.db.unsafeExecute(
        "UPDATE app.work_orders SET status = 'closed', closed_at = now(), status_reason = 'Encerrada sem conferência' "
        ' WHERE id = @id::uuid AND EXISTS (SELECT 1 FROM app.tenant_settings s '
        '                                  WHERE s.tenant_id = app.current_tenant_id() AND NOT s.require_backoffice_review)',
        parameters: QueryParameters.named({'id': id.uuid}),
        transaction: tx,
      );
    }
  }

  /// Visita cancelada: se a OS estava `scheduled` e não sobrou visita
  /// agendada ou ativa, volta para `open`.
  static Future<void> onVisitCancelled(Session session, UuidValue id, Transaction tx) async {
    final remaining = await session.db.unsafeQuery(
      'SELECT 1 FROM app.work_order_visits WHERE work_order_id = @id::uuid '
      "   AND status IN ('scheduled', 'en_route', 'on_site', 'paused') LIMIT 1",
      parameters: QueryParameters.named({'id': id.uuid}),
      transaction: tx,
    );
    if (remaining.isNotEmpty) return;
    await session.db.unsafeExecute(
      "UPDATE app.work_orders SET status = 'open', status_reason = NULL WHERE id = @id::uuid AND status = 'scheduled'",
      parameters: QueryParameters.named({'id': id.uuid}),
      transaction: tx,
    );
  }

  static Future<bool> _hasActiveVisit(Session session, UuidValue id, Transaction tx) async {
    final rows = await session.db.unsafeQuery(
      'SELECT 1 FROM app.work_order_visits WHERE work_order_id = @id::uuid '
      "   AND status IN ('en_route', 'on_site', 'paused') LIMIT 1",
      parameters: QueryParameters.named({'id': id.uuid}),
      transaction: tx,
    );
    return rows.isNotEmpty;
  }

  // ------------------------------------------------------------------ tipos

  static Future<List<WorkOrderType>> types(Session session, {bool includeInactive = false}) async {
    await Authorization.requireAny(session, const {readPermission, createPermission, 'catalog.manage'});
    final rows = await session.db.unsafeQuery(
      'SELECT $_typeColumns FROM app.work_order_types WHERE (@all OR is_active) ORDER BY sort_order, name',
      parameters: QueryParameters.named({'all': includeInactive}),
    );
    return [for (final r in rows) _mapType(r)];
  }

  static Future<WorkOrderType> createType(Session session, WorkOrderTypeInput input) async {
    await Authorization.require(session, 'catalog.manage');
    final params = _validateType(session, input);
    final id = const Uuid().v7obj();
    await _writeType(
      session,
      () => session.db.unsafeExecute(
        'INSERT INTO app.work_order_types (id, tenant_id, code, name, category, default_priority, requires_asset, is_active) '
        'VALUES (@id::uuid, app.current_tenant_id(), @code, @name, @category, @priority, @requiresAsset, @isActive)',
        parameters: QueryParameters.named({'id': id.uuid, ...params}),
      ),
    );
    return (await _findType(session, id))!;
  }

  static Future<WorkOrderType> updateType(
    Session session,
    UuidValue id,
    int expectedVersion,
    WorkOrderTypeInput input,
  ) async {
    await Authorization.require(session, 'catalog.manage');
    final params = _validateType(session, input);
    final rows = await session.db.unsafeQuery(
      'SELECT version FROM app.work_order_types WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    if (rows.isEmpty) throw ApiErrors.notFound(session);
    final changed = await _writeType(
      session,
      () => session.db.unsafeExecute(
        'UPDATE app.work_order_types SET code = @code, name = @name, category = @category, '
        '       default_priority = @priority, requires_asset = @requiresAsset, is_active = @isActive '
        ' WHERE id = @id::uuid AND version = @version',
        parameters: QueryParameters.named({'id': id.uuid, 'version': expectedVersion, ...params}),
      ),
    );
    if (changed == 0) throw ApiErrors.versionMismatch(session, rows.first[0] as int);
    return (await _findType(session, id))!;
  }

  // ------------------------------------------------------------------ internos

  static const _typeColumns = 'id, code, name, category, default_priority, requires_asset, is_active, version';
  static const _categories = {
    'corrective',
    'preventive',
    'installation',
    'removal',
    'inspection',
    'refurbishment',
    'teardown',
    'other',
  };

  static Future<WorkOrder> _transition(
    Session session,
    UuidValue id,
    int expectedVersion, {
    required Set<String> from,
    required String to,
    required String set,
    String? reason,
    Map<String, Object?> params = const {},
  }) async {
    final current = await _current(session, id, expectedVersion);
    if (!from.contains(current.status)) {
      throw ApiErrors.businessRule(
        session,
        'INVALID_TRANSITION',
        'Não é possível passar a OS de "${_statusLabels[current.status]}" para "${_statusLabels[to]}".',
      );
    }
    await _apply(session, id, expectedVersion, 'status = @to, status_reason = @statusReason, $set', {
      'to': to,
      'statusReason': cleanText(reason),
      ...params,
    });
    return (await _find(session, id))!;
  }

  static Future<void> _apply(
    Session session,
    UuidValue id,
    int expectedVersion,
    String set,
    Map<String, Object?> params,
  ) async {
    final changed = await session.db.unsafeExecute(
      'UPDATE app.work_orders SET $set WHERE id = @id::uuid AND version = @version',
      parameters: QueryParameters.named({'id': id.uuid, 'version': expectedVersion, ...params}),
    );
    if (changed == 0) throw ApiErrors.versionMismatch(session, (await _find(session, id))!.version);
  }

  /// OS atual na versão esperada, senão `NOT_FOUND` ou `VERSION_MISMATCH`.
  static Future<WorkOrder> _current(Session session, UuidValue id, int expectedVersion) async {
    final current = await _find(session, id);
    if (current == null) throw ApiErrors.notFound(session);
    if (current.version != expectedVersion) throw ApiErrors.versionMismatch(session, current.version);
    return current;
  }

  static Future<WorkOrderDetail> _detail(Session session, UuidValue id) async {
    final workOrder = await _find(session, id) ?? (throw ApiErrors.notFound(session));
    final history = await session.db.unsafeQuery(
      'SELECT h.from_status, h.to_status, h.hold_reason, h.reason, h.changed_at, u.full_name '
      '  FROM app.work_order_status_history h '
      '  LEFT JOIN app.users u ON u.id = h.changed_by '
      ' WHERE h.work_order_id = @id::uuid '
      ' ORDER BY h.changed_at, h.id',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    final others = workOrder.assetId == null
        ? const <List<Object?>>[]
        : await session.db.unsafeQuery(
            '$_select WHERE w.asset_id = @assetId::uuid AND w.id <> @id::uuid AND w.status = ANY(@open::text[]) '
            ' ORDER BY w.created_at DESC',
            parameters: QueryParameters.named({
              'assetId': workOrder.assetId!.uuid,
              'id': id.uuid,
              'open': openStatuses,
            }),
          );
    return WorkOrderDetail(
      workOrder: workOrder,
      history: [
        for (final r in history)
          WorkOrderStatusChange(
            fromStatus: r[0] as String?,
            toStatus: r[1] as String,
            holdReason: r[2] as String?,
            reason: r[3] as String?,
            changedAt: r[4] as DateTime,
            changedByName: r[5] as String?,
          ),
      ],
      otherOpenOnAsset: [for (final r in others) _map(r)],
    );
  }

  static Future<WorkOrder?> _find(Session session, UuidValue id, {Transaction? transaction}) async {
    final rows = await session.db.unsafeQuery(
      '$_select WHERE w.id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
      transaction: transaction,
    );
    return rows.isEmpty ? null : _map(rows.first);
  }

  static Future<WorkOrderType?> _findType(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      'SELECT $_typeColumns FROM app.work_order_types WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return rows.isEmpty ? null : _mapType(rows.first);
  }

  static Map<String, Object?> _validateType(Session session, WorkOrderTypeInput input) {
    final code = cleanText(input.code)?.toUpperCase();
    final name = cleanText(input.name);
    final errors = [
      if (code == null) FieldError(path: 'code', code: 'REQUIRED', message: 'Informe o código.'),
      if (name == null) FieldError(path: 'name', code: 'REQUIRED', message: 'Informe o nome.'),
      if (!_categories.contains(input.category))
        FieldError(path: 'category', code: 'INVALID', message: 'Categoria inválida.'),
      if (!priorities.contains(input.defaultPriority))
        FieldError(path: 'defaultPriority', code: 'INVALID', message: 'Prioridade inválida.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    return {
      'code': code,
      'name': name,
      'category': input.category,
      'priority': input.defaultPriority,
      'requiresAsset': input.requiresAsset,
      'isActive': input.isActive,
    };
  }

  static Future<int> _writeType(Session session, Future<int> Function() body) async {
    try {
      return await body();
    } on DatabaseQueryException catch (e) {
      if (isUniqueViolation(e, 'work_order_types_tenant_id_code_key')) {
        throw ApiErrors.fieldError(session, 'code', 'DUPLICATE', 'Já existe um tipo de OS com este código.');
      }
      rethrow;
    }
  }

  static const _statusLabels = {
    'requested': 'Solicitada',
    'open': 'Aberta',
    'scheduled': 'Agendada',
    'in_progress': 'Em atendimento',
    'on_hold': 'Pendente',
    'completed': 'Concluída',
    'closed': 'Encerrada',
    'cancelled': 'Cancelada',
  };

  static WorkOrderType _mapType(List<Object?> r) => WorkOrderType(
    id: sqlUuid(r[0]),
    code: r[1] as String,
    name: r[2] as String,
    category: r[3] as String,
    defaultPriority: r[4] as String,
    requiresAsset: r[5] as bool,
    isActive: r[6] as bool,
    version: r[7] as int,
  );

  static WorkOrder _map(List<Object?> r) => WorkOrder(
    id: sqlUuid(r[0]),
    number: r[1] as String,
    workOrderTypeId: sqlUuid(r[2]),
    workOrderTypeName: r[3] as String,
    status: r[4] as String,
    priority: r[5] as String,
    origin: r[6] as String,
    entryMethod: r[7] as String,
    assetId: sqlUuidOrNull(r[8]),
    assetLabel: r[9] as String?,
    productName: r[10] as String?,
    branchId: sqlUuidOrNull(r[11]),
    branchName: r[12] as String?,
    costCenterId: sqlUuidOrNull(r[13]),
    costCenterName: r[14] as String?,
    customerId: sqlUuidOrNull(r[15]),
    customerName: r[16] as String?,
    problemDescription: r[17] as String?,
    requesterName: r[18] as String?,
    requesterPhone: r[19] as String?,
    holdReason: r[20] as String?,
    statusReason: r[21] as String?,
    resolutionNotes: r[22] as String?,
    cancellationReason: r[23] as String?,
    cancellationNote: r[24] as String?,
    reopenedCount: r[25] as int,
    createdAt: r[26] as DateTime,
    statusChangedAt: r[27] as DateTime,
    startedAt: r[28] as DateTime?,
    completedAt: r[29] as DateTime?,
    closedAt: r[30] as DateTime?,
    cancelledAt: r[31] as DateTime?,
    version: r[32] as int,
  );
}

/// O que a visita precisa saber da OS (agendar e check-in).
final class WorkOrderForVisit {
  const WorkOrderForVisit({
    required this.id,
    required this.number,
    required this.status,
    required this.assetId,
    required this.siteLatitude,
    required this.siteLongitude,
    required this.requireQrCheckIn,
  });

  final UuidValue id;
  final String number;
  final String status;
  final UuidValue? assetId;

  /// Coordenada da unidade do cliente (nula em OS interna ou sem cadastro).
  final double? siteLatitude;
  final double? siteLongitude;

  /// Exige QR no check-in (tipo de OS, senão configuração do tenant).
  final bool requireQrCheckIn;
}
