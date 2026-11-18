import 'dart:async';
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:uuid/uuid.dart';

import '../api/gateway.dart';
import 'attachment_rules.dart';
import 'checklist_rules.dart';
import 'database.dart';
import 'visit_rules.dart';

/// Versão do app enviada no registro do aparelho e no push.
const appVersion = '0.2.0';

/// Situação do sync para a tela.
@immutable
class SyncSummary {
  const SyncSummary({
    this.pending = 0,
    this.pendingUploads = 0,
    this.pendingVisitIds = const {},
    this.notices = const [],
    this.lastSyncAt,
    this.syncing = false,
    this.error,
  });

  /// Ações ainda não enviadas.
  final int pending;

  /// Fotos e assinaturas cujo arquivo ainda não chegou ao servidor.
  final int pendingUploads;
  final Set<String> pendingVisitIds;

  /// Avisos não lidos (recusas, visitas canceladas ou transferidas).
  final List<Notice> notices;
  final DateTime? lastSyncAt;
  final bool syncing;

  /// Última falha do sync (sem conexão, servidor fora); some no próximo sucesso.
  final GatewayException? error;
}

/// Fonte de verdade do app do técnico: o banco local da empresa (docs/06
/// §5.1). As telas leem daqui e as ações gravam aqui (mudança otimista + fila
/// numa transação só); o [sync] envia a fila e baixa o recorte quando há rede.
class FieldStore {
  FieldStore(this.db, this._gateway, {DateTime Function()? clock, String? platform})
    : _clock = clock ?? DateTime.now,
      _platform = platform ?? _currentPlatform();

  final FieldDatabase db;
  final Gateway _gateway;
  final DateTime Function() _clock;
  final String _platform;

  static const _batch = 100;
  static const _uuid = Uuid();

  final _summary = StreamController<SyncSummary>.broadcast();
  var _current = const SyncSummary();
  Future<void>? _running;
  var _closed = false;

  // ------------------------------------------------------------------ leitura

  /// Visitas do recorte, como a tela deve mostrar (com as ações pendentes).
  Stream<List<Visit>> watchVisits() =>
      (db.select(db.localVisits)..orderBy([(v) => OrderingTerm(expression: v.scheduledStart)])).watch().map(
        (rows) => [for (final r in rows) _visit(r.json)],
      );

  Stream<Visit?> watchVisit(UuidValue id) => (db.select(
    db.localVisits,
  )..where((v) => v.id.equals(id.uuid))).watchSingleOrNull().map((r) => r == null ? null : _visit(r.json));

  Stream<WorkOrder?> watchWorkOrder(UuidValue id) =>
      (db.select(db.localWorkOrders)..where((w) => w.id.equals(id.uuid))).watchSingleOrNull().map(
        (r) => r == null ? null : WorkOrder.fromJson(jsonDecode(r.json) as Map<String, dynamic>),
      );

  /// Checklist da visita (nulo se ela não tem), atualizado a cada resposta,
  /// envio ou sync.
  Stream<VisitChecklistState?> watchChecklist(UuidValue visitId) async* {
    yield await checklist(visitId);
    yield* db
        .tableUpdates(TableUpdateQuery.onAllTables([db.localChecklists, db.checklistDrafts, db.pendingMutations]))
        .asyncMap((_) => checklist(visitId));
  }

  /// Fotos e assinatura capturadas na visita, na ordem da captura.
  Stream<List<LocalAttachment>> watchAttachments(UuidValue visitId) =>
      (db.select(db.localAttachments)
            ..where((a) => a.visitId.equals(visitId.uuid))
            ..orderBy([(a) => OrderingTerm(expression: a.capturedAt)]))
          .watch();

  Future<VisitChecklistState?> checklist(UuidValue visitId) async {
    final row = await (db.select(db.localChecklists)..where((c) => c.visitId.equals(visitId.uuid))).getSingleOrNull();
    if (row == null) return null;
    final server = VisitChecklist.fromJson(jsonDecode(row.json) as Map<String, dynamic>);
    final draft = await _draft(visitId.uuid);
    final pending = await (db.select(
      db.pendingMutations,
    )..where((m) => m.entityId.equals(visitId.uuid) & m.type.equals(checklistSubmitType))).get();
    final Map<String, ChecklistAnswer> answers;
    final bool submitted;
    if (draft != null) {
      answers = _decodeAnswers(draft.answers);
      submitted = draft.submitted;
    } else {
      answers = {for (final a in server.response?.answers ?? const <ChecklistAnswer>[]) a.itemKey: a};
      submitted = server.response?.status == 'submitted';
    }
    return VisitChecklistState(
      template: server.template,
      answers: answers,
      submitted: submitted,
      pending: pending.isNotEmpty,
    );
  }

  /// Situação do sync; emite a atual logo ao ouvir.
  Stream<SyncSummary> watchSummary() async* {
    await _refreshSummary();
    yield _current;
    yield* _summary.stream;
  }

  SyncSummary get summary => _current;

  // ------------------------------------------------------------------ ações do técnico

  /// Aplica a ação na visita local e a põe na fila, numa transação só; depois
  /// tenta enviar. Ação inválida lança [GatewayException] e nada muda.
  Future<Visit> act(Visit visit, String type, VisitMutationPayload payload) async {
    final now = await _serverNow();
    final stamped = payload.copyWith(occurredAt: payload.occurredAt ?? now);
    if (type == VisitMutation.finish && stamped.finish?.outcome == 'resolved') {
      final checklist = await this.checklist(visit.id);
      if (checklist != null && !checklist.submitted) {
        throw const GatewayException('Envie o checklist antes de concluir a visita.', code: 'CHECKLIST_REQUIRED');
      }
      final row = await (db.select(db.localVisits)..where((v) => v.id.equals(visit.id.uuid))).getSingleOrNull();
      final photos =
          await (db.select(db.localAttachments)..where(
                (a) => a.visitId.equals(visit.id.uuid) & a.kind.equals('photo') & a.status.isNotValue(attachmentFailed),
              ))
              .get();
      if (row != null) {
        if (missingEvidence(_visit(row.json), [for (final p in photos) p.photoStage]) case final missing?) {
          throw GatewayException(missing, code: 'EVIDENCE_REQUIRED');
        }
      }
    }
    final updated = await db.transaction(() async {
      final row = await (db.select(db.localVisits)..where((v) => v.id.equals(visit.id.uuid))).getSingleOrNull();
      if (row == null) throw const GatewayException('Esta visita não está mais na sua agenda.', code: 'NOT_FOUND');
      final current = _visit(row.json);
      if (VisitMutation.activating.contains(type)) {
        final others =
            await (db.select(db.localVisits)..where(
                  (v) => v.id.equals(visit.id.uuid).not() & v.status.isIn(const ['en_route', 'on_site', 'paused']),
                ))
                .get();
        if (others.isNotEmpty) {
          throw const GatewayException(
            'Você tem outra visita em andamento; finalize ou pause antes.',
            code: 'ANOTHER_VISIT_ACTIVE',
          );
        }
      }
      final next = applyVisitMutation(current, type, stamped, now);
      await db
          .into(db.pendingMutations)
          .insert(
            PendingMutationsCompanion.insert(
              mutationId: _uuid.v7(),
              type: type,
              entityId: visit.id.uuid,
              payload: jsonEncode(stamped.toJson()),
              clientTimestamp: _clock().toUtc(),
            ),
          );
      await _saveDisplayed(visit.id.uuid, next);
      return next;
    });
    await _refreshSummary();
    unawaited(sync().catchError((_) {}));
    return updated;
  }

  /// Guarda uma resposta do checklist no aparelho (valor vazio apaga). Mexer
  /// depois do envio volta o checklist a rascunho: é preciso enviar de novo.
  Future<void> saveChecklistAnswer(UuidValue visitId, ChecklistAnswer answer) async {
    await db.transaction(() async {
      final current = await checklist(visitId);
      if (current == null) return;
      final answers = Map.of(current.answers);
      if (answer.value.trim().isEmpty && (answer.note?.trim().isEmpty ?? true)) {
        answers.remove(answer.itemKey);
      } else {
        answers[answer.itemKey] = answer;
      }
      await _writeDraft(visitId.uuid, current.template.id.uuid, answers, submitted: false);
    });
  }

  /// Confere o checklist e põe o envio na fila. Com erro, lança
  /// [GatewayException] com a mensagem de cada item em `fieldErrors`.
  Future<void> submitChecklist(Visit visit) async {
    await db.transaction(() async {
      final current = await checklist(visit.id);
      if (current == null) {
        throw const GatewayException('Esta visita não tem checklist.', code: 'NOT_FOUND');
      }
      final shown = await (db.select(db.localVisits)..where((v) => v.id.equals(visit.id.uuid))).getSingleOrNull();
      if (shown == null || !const {'on_site', 'paused'}.contains(_visit(shown.json).status)) {
        throw const GatewayException(
          'O checklist é enviado durante a visita, após o check-in.',
          code: 'CHECK_IN_REQUIRED',
        );
      }
      final (errors, answers) = checkChecklist(current.template, current.answers);
      if (errors.isNotEmpty) {
        final missing = current.missing.length;
        throw GatewayException(
          missing > 0 ? 'Responda os $missing itens obrigatórios que faltam.' : 'Confira as respostas marcadas.',
          code: 'VALIDATION_FAILED',
          fieldErrors: errors,
        );
      }
      await _writeDraft(visit.id.uuid, current.template.id.uuid, {
        for (final a in answers) a.itemKey: a,
      }, submitted: true);
      await db
          .into(db.pendingMutations)
          .insert(
            PendingMutationsCompanion.insert(
              mutationId: _uuid.v7(),
              type: checklistSubmitType,
              entityId: visit.id.uuid,
              payload: jsonEncode(
                ChecklistSubmitPayload(checklistTemplateId: current.template.id, answers: answers).toJson(),
              ),
              clientTimestamp: _clock().toUtc(),
            ),
          );
    });
    await _refreshSummary();
    unawaited(sync().catchError((_) {}));
  }

  /// Guarda a foto no aparelho e põe o registro na fila; o arquivo vai
  /// depois, quando houver sinal (docs/06 §6.10).
  Future<void> addPhoto(Visit visit, String stage, Uint8List bytes) async {
    final now = await _serverNow();
    await db.transaction(() async {
      await _requireOnSite(visit.id.uuid, allowFinished: true);
      final png = bytes.length > 4 && bytes[0] == 0x89 && bytes[1] == 0x50 && bytes[2] == 0x4E && bytes[3] == 0x47;
      await _addAttachment(visit, 'photo', png ? 'image/png' : 'image/jpeg', bytes, now, stage: stage);
    });
    await _refreshSummary();
    unawaited(sync().catchError((_) {}));
  }

  /// Guarda a assinatura (PNG) e quem assinou; vale na tela na hora.
  Future<Visit> captureSignature(
    Visit visit,
    Uint8List png, {
    required String signerName,
    String? signerDocument,
    required String signerRole,
  }) async {
    final name = signerName.trim();
    if (name.isEmpty) {
      throw const GatewayException(
        'Informe o nome de quem assinou.',
        code: 'VALIDATION_FAILED',
        fieldErrors: {'signerName': 'Informe o nome.'},
      );
    }
    final now = await _serverNow();
    final updated = await db.transaction(() async {
      await _requireOnSite(visit.id.uuid, allowFinished: true);
      final id = await _addAttachment(visit, 'signature', 'image/png', png, now);
      final document = signerDocument?.trim();
      await _enqueue(
        signatureCaptureType,
        visit.id.uuid,
        SignatureCapturePayload(
          attachmentId: UuidValue.fromString(id),
          signerName: name,
          signerDocument: document == null || document.isEmpty ? null : document,
          signerRole: signerRole,
          signedAt: now,
        ).toJson(),
      );
      await _rebuild(visit.id.uuid);
      final row = await (db.select(db.localVisits)..where((v) => v.id.equals(visit.id.uuid))).getSingle();
      return _visit(row.json);
    });
    await _refreshSummary();
    unawaited(sync().catchError((_) {}));
    return updated;
  }

  Future<void> markNoticesRead() async {
    await (db.update(db.notices)..where((n) => n.read.equals(false))).write(const NoticesCompanion(read: Value(true)));
    await _refreshSummary();
  }

  // ------------------------------------------------------------------ sync

  /// Envia a fila e baixa o recorte (docs/06 §6.1: push antes do pull). Uma
  /// rodada por vez; chamadas durante uma rodada esperam a mesma. Sem rede, a
  /// fila fica e o erro vai para [summary]. Sessão perdida é relançada.
  Future<void> sync() => _running ??= _sync().whenComplete(() => _running = null);

  Future<void> _sync() async {
    if (_closed) return;
    _emit(syncing: true);
    try {
      final deviceId = await _deviceId();
      await _push(deviceId);
      await _upload();
      await _pull(deviceId);
      await _setState('last_sync_at', _clock().toUtc().toIso8601String());
      _emit(syncing: false, clearError: true);
    } on SessionLost {
      _emit(syncing: false);
      rethrow;
    } on GatewayException catch (e) {
      _emit(syncing: false, error: e);
      if (e.code == 'FORBIDDEN') rethrow;
    }
    await _refreshSummary();
  }

  Future<UuidValue> _deviceId() async {
    var id = await _state('device_id');
    if (id == null) {
      id = _uuid.v7();
      await _setState('device_id', id);
    }
    final deviceId = UuidValue.fromString(id);
    if (await _state('device_registered') != appVersion) {
      await _gateway.registerDevice(
        DeviceRegistration(deviceId: deviceId, platform: _platform, appVersion: appVersion),
      );
      await _setState('device_registered', appVersion);
    }
    return deviceId;
  }

  Future<void> _push(UuidValue deviceId) async {
    while (true) {
      final batch =
          await (db.select(db.pendingMutations)
                ..orderBy([(m) => OrderingTerm(expression: m.seq)])
                ..limit(_batch))
              .get();
      if (batch.isEmpty) return;
      await (db.update(db.pendingMutations)..where((m) => m.seq.isIn([for (final m in batch) m.seq]))).write(
        PendingMutationsCompanion.custom(attempts: db.pendingMutations.attempts + const Constant(1)),
      );
      final results = await _gateway.push(
        SyncPushRequest(
          deviceId: deviceId,
          appVersion: appVersion,
          mutations: [
            for (final m in batch)
              SyncMutation(
                mutationId: UuidValue.fromString(m.mutationId),
                type: m.type,
                entityId: UuidValue.fromString(m.entityId),
                clientTimestamp: m.clientTimestamp,
                payload: m.payload,
              ),
          ],
        ),
      );
      await db.transaction(() async {
        final touched = <String>{};
        for (final r in results) {
          final sent = batch.where((m) => m.mutationId == r.mutationId.uuid).firstOrNull;
          if (sent == null) continue;
          touched.add(sent.entityId);
          await (db.delete(db.pendingMutations)..where((m) => m.mutationId.equals(sent.mutationId))).go();
          if (r.visit case final visit?) await _saveServer(visit);
          if (r.checklist case final checklist?) await _saveChecklist(checklist);
          final refused = r.status == 'rejected' || r.status == 'conflict';
          if (refused) await _notice(sent.entityId, r);
          if (sent.type == checklistSubmitType) await _settleDraft(sent.entityId, refused: refused);
          if (sent.type == attachmentRegisterType) {
            final id = (jsonDecode(sent.payload) as Map<String, dynamic>)['attachmentId'] as String;
            await (db.update(db.localAttachments)..where((a) => a.id.equals(id))).write(
              LocalAttachmentsCompanion(
                status: Value(refused ? attachmentFailed : attachmentRegistered),
                lastError: Value(refused ? r.errorMessage : null),
              ),
            );
          }
        }
        for (final id in touched) {
          await _rebuild(id);
        }
      });
      await _refreshSummary();
      // Resposta parcial: o resto vai no próximo ciclo.
      if (results.length < batch.length) return;
    }
  }

  Future<void> _pull(UuidValue deviceId) async {
    final page = await _gateway.pull(deviceId);
    final offset = page.serverTime.difference(_clock().toUtc()).inMilliseconds;
    await db.transaction(() async {
      await _setState('server_offset_ms', '$offset');
      final inScope = {for (final v in page.visits) v.id.uuid};
      final pendingIds = {for (final m in await db.select(db.pendingMutations).get()) m.entityId};
      for (final old in await db.select(db.localVisits).get()) {
        if (inScope.contains(old.id) || pendingIds.contains(old.id)) continue;
        final shown = _visit(old.json);
        if (!const {'finished', 'cancelled'}.contains(shown.status) && !_beforeScope(shown, page.scopeFrom)) {
          await _addNotice(old.id, 'A visita da OS ${shown.workOrderNumber} saiu da sua agenda pelo despacho.');
        }
        await (db.delete(db.localVisits)..where((v) => v.id.equals(old.id))).go();
      }
      for (final v in page.visits) {
        await _saveServer(v);
        await _rebuild(v.id.uuid);
      }
      await db.delete(db.localChecklists).go();
      for (final c in page.checklists) {
        await _saveChecklist(c);
      }
      final visitIds = {for (final v in await db.select(db.localVisits).get()) v.id};
      await (db.delete(db.localAttachments)..where(
            (a) => a.visitId.isNotIn(visitIds) & a.status.isIn(const [attachmentUploaded, attachmentFailed]),
          ))
          .go();
      for (final d in await db.select(db.checklistDrafts).get()) {
        if (!visitIds.contains(d.visitId)) {
          await (db.delete(db.checklistDrafts)..where((x) => x.visitId.equals(d.visitId))).go();
        } else {
          await _settleDraft(d.visitId, refused: false);
        }
      }
      await db.delete(db.localWorkOrders).go();
      await db.batch((b) {
        b.insertAll(db.localWorkOrders, [
          for (final w in page.workOrders) LocalWorkOrdersCompanion.insert(id: w.id.uuid, json: jsonEncode(w.toJson())),
        ]);
      });
    });
  }

  bool _beforeScope(Visit v, DateTime scopeFrom) => v.scheduledStart.isBefore(scopeFrom);

  // ------------------------------------------------------------------ internos

  /// Grava o estado do servidor (insere se a visita ainda não existir).
  Future<void> _saveServer(Visit visit) async {
    final json = jsonEncode(visit.toJson());
    await db
        .into(db.localVisits)
        .insertOnConflictUpdate(
          LocalVisitsCompanion.insert(
            id: visit.id.uuid,
            workOrderId: visit.workOrderId.uuid,
            scheduledStart: visit.scheduledStart,
            status: visit.status,
            serverJson: json,
            json: json,
          ),
        );
  }

  Future<void> _saveDisplayed(String id, Visit visit) =>
      (db.update(db.localVisits)..where((v) => v.id.equals(id))).write(
        LocalVisitsCompanion(status: Value(visit.status), json: Value(jsonEncode(visit.toJson()))),
      );

  /// Estado mostrado = o do servidor + as ações pendentes, na ordem. Uma que
  /// não se aplica mais fica na fila: o servidor dará a palavra final.
  Future<void> _rebuild(String id) async {
    final row = await (db.select(db.localVisits)..where((v) => v.id.equals(id))).getSingleOrNull();
    if (row == null) return;
    var visit = _visit(row.serverJson);
    final pending =
        await (db.select(db.pendingMutations)
              ..where((m) => m.entityId.equals(id))
              ..orderBy([(m) => OrderingTerm(expression: m.seq)]))
            .get();
    final now = _clock();
    for (final m in pending) {
      if (m.type == signatureCaptureType) {
        visit = applySignature(
          visit,
          SignatureCapturePayload.fromJson(jsonDecode(m.payload) as Map<String, dynamic>),
        );
        continue;
      }
      if (!m.type.startsWith('visit.')) continue;
      try {
        visit = applyVisitMutation(
          visit,
          m.type,
          VisitMutationPayload.fromJson(jsonDecode(m.payload) as Map<String, dynamic>),
          now,
        );
      } on GatewayException {
        // Fica como está; a resposta do servidor resolve.
      }
    }
    await _saveDisplayed(id, visit);
  }

  /// Envia os arquivos dos anexos já registrados (fila de uploads, docs/06
  /// §6.10). Sem rede, para no primeiro erro; recusa do servidor fica
  /// anotada no anexo e o próximo sync tenta de novo.
  Future<void> _upload() async {
    final ready =
        await (db.select(db.localAttachments)
              ..where((a) => a.status.equals(attachmentRegistered))
              ..orderBy([(a) => OrderingTerm(expression: a.capturedAt)]))
            .get();
    for (final a in ready) {
      final id = UuidValue.fromString(a.id);
      try {
        try {
          final target = await _gateway.attachmentUploadUrl(id);
          await _gateway.uploadFile(target, a.bytes);
        } on GatewayException catch (e) {
          if (e.code != 'ALREADY_UPLOADED') rethrow;
        }
        await _gateway.confirmAttachmentUpload(id);
        await (db.update(db.localAttachments)..where((x) => x.id.equals(a.id))).write(
          const LocalAttachmentsCompanion(status: Value(attachmentUploaded), lastError: Value(null)),
        );
      } on SessionLost {
        rethrow;
      } on GatewayException catch (e) {
        await (db.update(db.localAttachments)..where((x) => x.id.equals(a.id))).write(
          LocalAttachmentsCompanion.custom(
            uploadAttempts: db.localAttachments.uploadAttempts + const Constant(1),
            lastError: Variable(e.message),
          ),
        );
        if (e.code == null) return; // sem conexão: tenta no próximo sync
      }
    }
    await _refreshSummary();
  }

  Future<String> _addAttachment(
    Visit visit,
    String kind,
    String contentType,
    Uint8List bytes,
    DateTime now, {
    String? stage,
  }) async {
    final id = _uuid.v7();
    await db
        .into(db.localAttachments)
        .insert(
          LocalAttachmentsCompanion.insert(
            id: id,
            visitId: visit.id.uuid,
            kind: kind,
            photoStage: Value(stage),
            contentType: contentType,
            bytes: bytes,
            capturedAt: now,
            status: attachmentQueued,
          ),
        );
    await _enqueue(
      attachmentRegisterType,
      visit.id.uuid,
      AttachmentRegisterPayload(
        attachmentId: UuidValue.fromString(id),
        kind: kind,
        photoStage: stage,
        contentType: contentType,
        sizeBytes: bytes.length,
        sha256: sha256.convert(bytes).toString(),
        capturedAt: now,
      ).toJson(),
    );
    return id;
  }

  Future<void> _enqueue(String type, String visitId, Map<String, dynamic> payload) => db
      .into(db.pendingMutations)
      .insert(
        PendingMutationsCompanion.insert(
          mutationId: _uuid.v7(),
          type: type,
          entityId: visitId,
          payload: jsonEncode(payload),
          clientTimestamp: _clock().toUtc(),
        ),
      );

  /// Fotos e assinatura só com a visita em execução (ou finalizada há pouco).
  Future<void> _requireOnSite(String visitId, {bool allowFinished = false}) async {
    final row = await (db.select(db.localVisits)..where((v) => v.id.equals(visitId))).getSingleOrNull();
    final status = row == null ? null : _visit(row.json).status;
    if (!const {'on_site', 'paused'}.contains(status) && !(allowFinished && status == 'finished')) {
      throw const GatewayException(
        'Fotos e assinatura são registradas durante a visita, após o check-in.',
        code: 'CHECK_IN_REQUIRED',
      );
    }
  }

  Future<void> _saveChecklist(VisitChecklist c) => db
      .into(db.localChecklists)
      .insertOnConflictUpdate(LocalChecklistsCompanion.insert(visitId: c.visitId.uuid, json: jsonEncode(c.toJson())));

  Future<ChecklistDraft?> _draft(String visitId) =>
      (db.select(db.checklistDrafts)..where((d) => d.visitId.equals(visitId))).getSingleOrNull();

  Future<void> _writeDraft(
    String visitId,
    String templateId,
    Map<String, ChecklistAnswer> answers, {
    required bool submitted,
  }) => db
      .into(db.checklistDrafts)
      .insertOnConflictUpdate(
        ChecklistDraftsCompanion.insert(
          visitId: visitId,
          templateId: templateId,
          answers: jsonEncode([for (final a in answers.values) a.toJson()]),
          submitted: Value(submitted),
          updatedAt: _clock().toUtc(),
        ),
      );

  /// Depois da resposta do servidor a um envio: recusado, o rascunho volta a
  /// ser editável; aceito (e sem outro envio na fila), o rascunho sai e vale
  /// o que o servidor guardou.
  Future<void> _settleDraft(String visitId, {required bool refused}) async {
    final draft = await _draft(visitId);
    if (draft == null) return;
    final queued = await (db.select(
      db.pendingMutations,
    )..where((m) => m.entityId.equals(visitId) & m.type.equals(checklistSubmitType))).get();
    if (queued.isNotEmpty) return;
    if (refused) {
      await (db.update(db.checklistDrafts)..where((d) => d.visitId.equals(visitId))).write(
        const ChecklistDraftsCompanion(submitted: Value(false)),
      );
    } else if (draft.submitted) {
      await (db.delete(db.checklistDrafts)..where((d) => d.visitId.equals(visitId))).go();
    }
  }

  static Map<String, ChecklistAnswer> _decodeAnswers(String json) => {
    for (final a in [
      for (final e in jsonDecode(json) as List<dynamic>) ChecklistAnswer.fromJson(e as Map<String, dynamic>),
    ])
      a.itemKey: a,
  };

  Future<void> _notice(String visitId, SyncMutationResult r) async {
    final number = r.visit?.workOrderNumber;
    final prefix = number == null ? '' : 'OS $number: ';
    final what = r.status == 'conflict' ? 'não foi aplicada' : 'foi recusada';
    await _addNotice(visitId, '$prefix${r.errorMessage ?? 'uma ação $what pelo servidor.'}');
  }

  Future<void> _addNotice(String? visitId, String message) => db
      .into(db.notices)
      .insert(
        NoticesCompanion.insert(createdAt: _clock().toUtc(), message: message, visitId: Value(visitId)),
      );

  Future<DateTime> _serverNow() async {
    final offset = int.tryParse(await _state('server_offset_ms') ?? '') ?? 0;
    return _clock().toUtc().add(Duration(milliseconds: offset));
  }

  Future<String?> _state(String key) async =>
      (await (db.select(db.syncState)..where((s) => s.key.equals(key))).getSingleOrNull())?.value;

  Future<void> _setState(String key, String value) =>
      db.into(db.syncState).insertOnConflictUpdate(SyncStateCompanion.insert(key: key, value: value));

  Future<void> _refreshSummary() async {
    if (_closed) return;
    final pending = await db.select(db.pendingMutations).get();
    final uploads = await (db.select(
      db.localAttachments,
    )..where((a) => a.status.isIn(const [attachmentQueued, attachmentRegistered]))).get();
    final notices =
        await (db.select(db.notices)
              ..where((n) => n.read.equals(false))
              ..orderBy([(n) => OrderingTerm(expression: n.id, mode: OrderingMode.desc)]))
            .get();
    final last = await _state('last_sync_at');
    _current = SyncSummary(
      pending: pending.length,
      pendingUploads: uploads.length,
      pendingVisitIds: {for (final m in pending) m.entityId, for (final a in uploads) a.visitId},
      notices: notices,
      lastSyncAt: last == null ? null : DateTime.parse(last),
      syncing: _current.syncing,
      error: _current.error,
    );
    _summary.add(_current);
  }

  void _emit({required bool syncing, GatewayException? error, bool clearError = false}) {
    if (_closed) return;
    _current = SyncSummary(
      pending: _current.pending,
      pendingUploads: _current.pendingUploads,
      pendingVisitIds: _current.pendingVisitIds,
      notices: _current.notices,
      lastSyncAt: _current.lastSyncAt,
      syncing: syncing,
      error: clearError ? null : (error ?? _current.error),
    );
    _summary.add(_current);
  }

  Future<void> close() async {
    _closed = true;
    await _running?.catchError((_) {});
    await _summary.close();
    await db.close();
  }

  static Visit _visit(String json) => Visit.fromJson(jsonDecode(json) as Map<String, dynamic>);

  static String _currentPlatform() {
    if (kIsWeb) return 'web';
    return defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android';
  }
}
