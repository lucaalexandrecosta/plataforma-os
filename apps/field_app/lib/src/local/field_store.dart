import 'dart:async';
import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:uuid/uuid.dart';

import '../api/gateway.dart';
import 'database.dart';
import 'visit_rules.dart';

/// Versão do app enviada no registro do aparelho e no push.
const appVersion = '0.2.0';

/// Situação do sync para a tela.
@immutable
class SyncSummary {
  const SyncSummary({
    this.pending = 0,
    this.pendingVisitIds = const {},
    this.notices = const [],
    this.lastSyncAt,
    this.syncing = false,
    this.error,
  });

  /// Ações ainda não enviadas.
  final int pending;
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
          if (r.status == 'rejected' || r.status == 'conflict') {
            await _notice(sent.entityId, r);
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
    final notices =
        await (db.select(db.notices)
              ..where((n) => n.read.equals(false))
              ..orderBy([(n) => OrderingTerm(expression: n.id, mode: OrderingMode.desc)]))
            .get();
    final last = await _state('last_sync_at');
    _current = SyncSummary(
      pending: pending.length,
      pendingVisitIds: {for (final m in pending) m.entityId},
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
