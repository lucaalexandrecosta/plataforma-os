import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../../customers/customers.dart';
import '../../generated/protocol.dart';
import '../../platform/authz/grants.dart';
import '../../platform/context/request_context.dart';
import '../../platform/errors/api_errors.dart';
import '../../platform/imports/import_spec.dart';
import '../../platform/paging/paging.dart';
import 'tabular.dart';

/// Importação por planilha (docs/06 §3; docs/08 §3.10 `imports.*`):
/// modelo → prévia (simulação com erros por linha) → confirmação → relatório.
///
/// MVP: o arquivo vai no próprio pedido (até [maxFileBytes]) e a aplicação é
/// síncrona, numa transação. Planilhas maiores e o processamento em job do
/// worker entram com o upload direto ao S3 (docs/08 §2.13).
abstract final class ImportService {
  static const maxFileBytes = 700 * 1024;
  static const _storage = 'private';
  static const _permission = 'imports.run';
  static const _previewErrors = 200;

  static final Map<ImportEntityType, ImportSpec> _specs = {
    for (final s in <ImportSpec>[CustomersImport(), CustomerSitesImport(), CustomerContactsImport()]) s.entity: s,
  };

  static ImportSpec _spec(Session session, ImportEntityType entity) =>
      _specs[entity] ?? (throw ApiErrors.businessRule(session, 'Importação de "${entity.name}" ainda não disponível.'));

  static List<ImportEntityType> get available => _specs.keys.toList();

  // --- modelo ----------------------------------------------------------------

  static Future<ImportTemplate> template(Session session, ImportEntityType entity) async {
    await session.requirePermission(_permission);
    final spec = _spec(session, entity);
    final header = spec.columns.map((c) => c.key).join(';');
    final example = spec.columns.map((c) => _csvCell(c.example)).join(';');
    final csv = '﻿$header\r\n$example\r\n';
    return ImportTemplate(
      entityType: entity,
      title: spec.title,
      description: spec.description,
      columns: [for (final c in spec.columns) c.toInfo()],
      fileName: 'modelo_${entity.name}.csv',
      csv: ByteData.sublistView(Uint8List.fromList(utf8.encode(csv))),
    );
  }

  // --- prévia ----------------------------------------------------------------

  static Future<ImportPreview> preview(
    Session session,
    ImportEntityType entity,
    String fileName,
    ByteData content,
  ) async {
    await session.requirePermission(_permission);
    final spec = _spec(session, entity);
    final bytes = content.buffer.asUint8List(content.offsetInBytes, content.lengthInBytes);
    if (bytes.isEmpty) throw ApiErrors.businessRule(session, 'O arquivo está vazio.', path: 'file');
    if (bytes.length > maxFileBytes) {
      throw ApiErrors.businessRule(
        session,
        'Arquivo acima de ${maxFileBytes ~/ 1024} KB. Divida a planilha em partes menores.',
        path: 'file',
      );
    }
    final safeName = _safeFileName(fileName);
    if (!RegExp(r'\.(csv|xlsx|txt)$', caseSensitive: false).hasMatch(safeName)) {
      throw ApiErrors.businessRule(session, 'Envie um arquivo .xlsx ou .csv.', path: 'file');
    }

    final ctx = session.context;
    final runId = const Uuid().v7obj();
    final key = 't/${ctx.tenantId!.uuid}/imports/${runId.uuid}/$safeName';
    await session.storage.storeFile(storageId: _storage, path: key, byteData: content);

    final now = DateTime.now().toUtc();
    var run = await ImportRun.db.insertRow(
      session,
      ImportRun(
        id: runId,
        tenantId: ctx.tenantId!,
        entityType: entity,
        mode: SyncRunMode.file_import,
        trigger: SyncRunTrigger.file_upload,
        dryRun: false,
        status: SyncRunStatus.queued,
        fileStorageKey: key,
        fileName: safeName,
        fileSha256: sha256.convert(bytes).toString(),
        requestedBy: ctx.userId,
        createdAt: now,
        updatedAt: now,
        version: 1,
      ),
    );

    final parsed = _parse(bytes, safeName, spec);
    if (parsed.error != null || parsed.missing.isNotEmpty) {
      final message =
          parsed.error ?? 'Colunas obrigatórias ausentes: ${parsed.missing.map((k) => _label(spec, k)).join(', ')}.';
      run = await _finish(session, run, SyncRunStatus.failed, errorMessage: message);
      return ImportPreview(
        run: await _info(session, run),
        recognizedColumns: parsed.recognized,
        unknownColumns: parsed.unknown,
        missingColumns: parsed.missing,
        errors: const [],
      );
    }

    final plan = await spec.plan(session, parsed.records);
    final stats = _stats(plan);
    await _saveStats(session, run.id, stats);
    final errors = [
      for (final p in plan)
        if (p.action == ImportAction.error) ImportRowError(rowNumber: p.rowNumber, key: p.key, messages: p.messages),
    ];
    if (errors.isNotEmpty) run = await _storeReport(session, run, parsed, plan);
    final fresh = await ImportRun.db.findById(session, run.id) ?? run;
    return ImportPreview(
      run: await _info(session, fresh),
      recognizedColumns: parsed.recognized,
      unknownColumns: parsed.unknown,
      missingColumns: const [],
      errors: errors.take(_previewErrors).toList(),
    );
  }

  // --- confirmação -----------------------------------------------------------

  static Future<ImportRunInfo> confirm(Session session, UuidValue runId, int expectedVersion) async {
    await session.requirePermission(_permission);
    final initial = await ImportRun.db.findById(session, runId) ?? (throw ApiErrors.notFound(session));
    final spec = _spec(session, initial.entityType);
    final file = await session.storage.retrieveFile(storageId: _storage, path: initial.fileStorageKey!);
    final bytes = file.buffer.asUint8List(file.offsetInBytes, file.lengthInBytes);
    final parsed = _parse(bytes, initial.fileName ?? 'arquivo.csv', spec);

    final result = await session.db.transaction((tx) async {
      final run =
          await ImportRun.db.findById(session, runId, transaction: tx, lockMode: LockMode.forUpdate) ??
          (throw ApiErrors.notFound(session));
      if (run.version != expectedVersion) throw ApiErrors.versionMismatch(session, run.version);
      if (run.status != SyncRunStatus.queued) {
        throw ApiErrors.invalidTransition(session, 'Esta importação já foi ${_statusLabel(run.status)}.');
      }
      final started = DateTime.now().toUtc();
      // O banco pode ter mudado desde a prévia: planeja de novo, na transação.
      final plan = await spec.plan(session, parsed.records, transaction: tx);
      final applied = await spec.apply(session, tx, plan, runId: run.id);
      final stats = _stats(plan, created: applied.created, updated: applied.updated);
      final status = stats.errorRows == 0
          ? SyncRunStatus.succeeded
          : (applied.created + applied.updated + stats.unchanged == 0
                ? SyncRunStatus.failed
                : SyncRunStatus.partially_succeeded);
      await ImportRun.db.updateWhere(
        session,
        columnValues: (t) => [
          t.status(status),
          t.startedAt(started),
          t.finishedAt(DateTime.now().toUtc()),
          if (status == SyncRunStatus.failed) t.errorMessage('Nenhuma linha válida para aplicar.'),
        ],
        where: (t) => t.id.equals(run.id),
        transaction: tx,
      );
      await _saveStats(session, run.id, stats, transaction: tx);
      return (run: run, plan: plan);
    });

    var run = (await ImportRun.db.findById(session, runId))!;
    if (result.plan.any((p) => p.action == ImportAction.error)) {
      run = await _storeReport(session, run, parsed, result.plan);
    }
    return _info(session, run);
  }

  static Future<ImportRunInfo> cancel(Session session, UuidValue runId, int expectedVersion) async {
    await session.requirePermission(_permission);
    final run = await ImportRun.db.findById(session, runId) ?? (throw ApiErrors.notFound(session));
    if (run.version != expectedVersion) throw ApiErrors.versionMismatch(session, run.version);
    if (run.status != SyncRunStatus.queued) {
      throw ApiErrors.invalidTransition(session, 'Esta importação já foi ${_statusLabel(run.status)}.');
    }
    return _info(session, await _finish(session, run, SyncRunStatus.cancelled));
  }

  // --- consulta --------------------------------------------------------------

  static Future<ImportRunPage> list(Session session, ImportEntityType? entity, PageRequest? page) async {
    await session.requirePermission(_permission);
    final plan = Paging.plan(
      session,
      page == null ? PageRequest(descending: true) : (page..descending ??= true),
      resource: 'imports',
      sortable: const {'createdAt'},
      defaultSort: 'createdAt',
      filterFingerprint: {'entity': entity?.name},
    );
    final after = plan.after;
    final rows = await ImportRun.db.find(
      session,
      where: (t) {
        Expression<dynamic> e = t.mode.equals(SyncRunMode.file_import);
        if (entity != null) e = e & t.entityType.equals(entity);
        if (after != null) {
          final v = DateTime.parse(after.sortValue);
          e = e & ((t.createdAt < v) | (t.createdAt.equals(v) & (t.id < after.id)));
        }
        return e;
      },
      orderByList: (t) => [t.createdAt.desc(), t.id.desc()],
      limit: plan.fetchLimit,
    );
    final hasMore = rows.length > plan.limit;
    final items = hasMore ? rows.sublist(0, plan.limit) : rows;
    return ImportRunPage(
      items: [for (final r in items) await _info(session, r)],
      hasMore: hasMore,
      nextCursor: hasMore
          ? Paging.encode(plan, sortValue: items.last.createdAt.toUtc().toIso8601String(), id: items.last.id)
          : null,
    );
  }

  static Future<ImportRunInfo> get(Session session, UuidValue runId) async {
    await session.requirePermission(_permission);
    return _info(session, await ImportRun.db.findById(session, runId) ?? (throw ApiErrors.notFound(session)));
  }

  /// Planilha das linhas com erro: as colunas originais + "erros", para
  /// corrigir e reenviar.
  static Future<ByteData> errorReport(Session session, UuidValue runId) async {
    await session.requirePermission(_permission);
    final run = await ImportRun.db.findById(session, runId) ?? (throw ApiErrors.notFound(session));
    final key = run.reportStorageKey;
    if (key == null) throw ApiErrors.notFound(session, 'Esta importação não tem linhas com erro.');
    return session.storage.retrieveFile(storageId: _storage, path: key);
  }

  // ---------------------------------------------------------------------------

  static _Parsed _parse(Uint8List bytes, String fileName, ImportSpec spec) {
    final SheetTable table;
    try {
      table = Tabular.read(fileName, bytes);
    } on TabularFormatException catch (e) {
      return _Parsed.failed(e.message);
    }
    final byHeader = <String, String>{};
    for (final c in spec.columns) {
      byHeader[ImportCells.normalizeHeader(c.key)] = c.key;
      byHeader[ImportCells.normalizeHeader(c.label)] = c.key;
      for (final a in c.aliases) {
        byHeader[ImportCells.normalizeHeader(a)] = c.key;
      }
    }
    final mapping = <int, String>{};
    final unknown = <String>[];
    for (var i = 0; i < table.header.length; i++) {
      final h = table.header[i];
      if (h.isEmpty) continue;
      final key = byHeader[ImportCells.normalizeHeader(h)];
      if (key == null || mapping.containsValue(key)) {
        unknown.add(h);
      } else {
        mapping[i] = key;
      }
    }
    final recognized = mapping.values.toList();
    final missing = [
      for (final c in spec.columns)
        if (c.isRequired && !recognized.contains(c.key)) c.key,
    ];
    final records = <ImportRecord>[];
    for (var r = 0; r < table.rows.length; r++) {
      final row = table.rows[r];
      final values = <String, String>{};
      mapping.forEach((i, key) {
        if (i < row.length && row[i].isNotEmpty) values[key] = row[i];
      });
      if (values.isNotEmpty) records.add(ImportRecord(r + 2, values));
    }
    return _Parsed(table, mapping, records, recognized, unknown, missing);
  }

  static ImportStats _stats(List<ImportRowPlan> plan, {int? created, int? updated}) => ImportStats(
    totalRows: plan.length,
    toCreate: plan.where((p) => p.action == ImportAction.create).length,
    toUpdate: plan.where((p) => p.action == ImportAction.update).length,
    unchanged: plan.where((p) => p.action == ImportAction.unchanged).length,
    errorRows: plan.where((p) => p.action == ImportAction.error).length,
    created: created,
    updated: updated,
  );

  static Future<void> _saveStats(Session session, UuidValue id, ImportStats stats, {Transaction? transaction}) =>
      session.db.unsafeExecute(
        'UPDATE app.sync_runs SET stats = @stats::jsonb WHERE id = @id::uuid',
        parameters: QueryParameters.named({'id': id.uuid, 'stats': jsonEncode(stats.toJson())}),
        transaction: transaction,
      );

  static Future<ImportStats> _loadStats(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      'SELECT stats::text FROM app.sync_runs WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    final raw = rows.isEmpty ? null : rows.first.first as String?;
    final json = raw == null ? const <String, dynamic>{} : jsonDecode(raw) as Map<String, dynamic>;
    return json.containsKey('totalRows')
        ? ImportStats.fromJson(json)
        : ImportStats(totalRows: 0, toCreate: 0, toUpdate: 0, unchanged: 0, errorRows: 0);
  }

  static Future<ImportRunInfo> _info(Session session, ImportRun run) async => ImportRunInfo(
    id: run.id,
    entityType: run.entityType,
    status: run.status,
    fileName: run.fileName,
    stats: await _loadStats(session, run.id),
    hasErrorReport: run.reportStorageKey != null,
    errorMessage: run.errorMessage,
    createdAt: run.createdAt,
    finishedAt: run.finishedAt,
    version: run.version,
  );

  static Future<ImportRun> _finish(Session session, ImportRun run, SyncRunStatus status, {String? errorMessage}) async {
    final rows = await ImportRun.db.updateWhere(
      session,
      columnValues: (t) => [
        t.status(status),
        t.finishedAt(DateTime.now().toUtc()),
        if (errorMessage != null) t.errorMessage(errorMessage),
      ],
      where: (t) => t.id.equals(run.id),
    );
    return rows.single;
  }

  static Future<ImportRun> _storeReport(
    Session session,
    ImportRun run,
    _Parsed parsed,
    List<ImportRowPlan> plan,
  ) async {
    final errorsByRow = {
      for (final p in plan)
        if (p.action == ImportAction.error) p.rowNumber: p.messages.join(' | '),
    };
    final buffer = StringBuffer('﻿')
      ..write(['linha', ...parsed.table!.header, 'erros'].map(_csvCell).join(';'))
      ..write('\r\n');
    for (var r = 0; r < parsed.table!.rows.length; r++) {
      final message = errorsByRow[r + 2];
      if (message == null) continue;
      buffer
        ..write(['${r + 2}', ...parsed.table!.rows[r], message].map(_csvCell).join(';'))
        ..write('\r\n');
    }
    final key = '${run.fileStorageKey!.substring(0, run.fileStorageKey!.lastIndexOf('/'))}/erros.csv';
    await session.storage.storeFile(
      storageId: _storage,
      path: key,
      byteData: ByteData.sublistView(Uint8List.fromList(utf8.encode(buffer.toString()))),
    );
    final rows = await ImportRun.db.updateWhere(
      session,
      columnValues: (t) => [t.reportStorageKey(key)],
      where: (t) => t.id.equals(run.id),
    );
    return rows.single;
  }

  static String _csvCell(String v) => v.contains(RegExp(r'[;"\r\n]')) ? '"${v.replaceAll('"', '""')}"' : v;

  static String _safeFileName(String name) {
    final base = name.split(RegExp(r'[\\/]')).last.trim();
    final cleaned = base.replaceAll(RegExp(r'[^A-Za-z0-9._ -]'), '_');
    final limited = cleaned.length > 120 ? cleaned.substring(cleaned.length - 120) : cleaned;
    return limited.isEmpty ? 'arquivo.csv' : limited;
  }

  static String _label(ImportSpec spec, String key) => spec.columns
      .firstWhere(
        (c) => c.key == key,
        orElse: () => ImportColumn(key, key, help: '', example: ''),
      )
      .label;

  static String _statusLabel(SyncRunStatus s) => switch (s) {
    SyncRunStatus.queued => 'preparada',
    SyncRunStatus.running => 'iniciada',
    SyncRunStatus.succeeded || SyncRunStatus.partially_succeeded => 'aplicada',
    SyncRunStatus.failed => 'encerrada com falha',
    SyncRunStatus.cancelled => 'cancelada',
  };
}

final class _Parsed {
  const _Parsed(this.table, this.mapping, this.records, this.recognized, this.unknown, this.missing) : error = null;

  const _Parsed.failed(this.error)
    : table = null,
      mapping = const {},
      records = const [],
      recognized = const [],
      unknown = const [],
      missing = const [];

  final SheetTable? table;
  final Map<int, String> mapping;
  final List<ImportRecord> records;
  final List<String> recognized;
  final List<String> unknown;
  final List<String> missing;
  final String? error;
}
