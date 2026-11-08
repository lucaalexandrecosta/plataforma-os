/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _ida;
import 'package:serverpod/serverpod.dart' as _is;
import '../../imports/models/import_entity_type.dart' as _incxtnh4;
import '../../imports/models/sync_run_mode.dart' as _ihge5bzx;
import '../../imports/models/sync_run_status.dart' as _iuo8pohf;
import '../../imports/models/sync_run_trigger.dart' as _igklebcn;

abstract class ImportRun implements _is.TableRow<_is.UuidValue>, _is.ProtocolSerialization {
  ImportRun._({
    _is.UuidValue? id,
    required this.tenantId,
    required this.entityType,
    required this.mode,
    required this.trigger,
    required this.dryRun,
    required this.status,
    this.fileStorageKey,
    this.fileName,
    this.fileSha256,
    this.reportStorageKey,
    this.errorMessage,
    this.startedAt,
    this.finishedAt,
    this.requestedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : id = id ?? const _is.Uuid().v7obj();

  factory ImportRun({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required _incxtnh4.ImportEntityType entityType,
    required _ihge5bzx.SyncRunMode mode,
    required _igklebcn.SyncRunTrigger trigger,
    required bool dryRun,
    required _iuo8pohf.SyncRunStatus status,
    String? fileStorageKey,
    String? fileName,
    String? fileSha256,
    String? reportStorageKey,
    String? errorMessage,
    DateTime? startedAt,
    DateTime? finishedAt,
    _is.UuidValue? requestedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _ImportRunImpl;

  factory ImportRun.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportRun(
      id: jsonSerialization['id'] == null ? null : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      entityType: _incxtnh4.ImportEntityType.fromJson((jsonSerialization['entityType'] as String)),
      mode: _ihge5bzx.SyncRunMode.fromJson((jsonSerialization['mode'] as String)),
      trigger: _igklebcn.SyncRunTrigger.fromJson((jsonSerialization['trigger'] as String)),
      dryRun: _is.BoolJsonExtension.fromJson(jsonSerialization['dryRun']),
      status: _iuo8pohf.SyncRunStatus.fromJson((jsonSerialization['status'] as String)),
      fileStorageKey: jsonSerialization['fileStorageKey'] as String?,
      fileName: jsonSerialization['fileName'] as String?,
      fileSha256: jsonSerialization['fileSha256'] as String?,
      reportStorageKey: jsonSerialization['reportStorageKey'] as String?,
      errorMessage: jsonSerialization['errorMessage'] as String?,
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      finishedAt: jsonSerialization['finishedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['finishedAt']),
      requestedBy: jsonSerialization['requestedBy'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['requestedBy']),
      createdAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = ImportRunTable();

  static const db = ImportRunRepository._();

  @override
  _is.UuidValue id;

  _is.UuidValue tenantId;

  _incxtnh4.ImportEntityType entityType;

  _ihge5bzx.SyncRunMode mode;

  _igklebcn.SyncRunTrigger trigger;

  bool dryRun;

  _iuo8pohf.SyncRunStatus status;

  String? fileStorageKey;

  String? fileName;

  String? fileSha256;

  String? reportStorageKey;

  String? errorMessage;

  DateTime? startedAt;

  DateTime? finishedAt;

  _is.UuidValue? requestedBy;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  @override
  _is.Table<_is.UuidValue> get table => t;

  /// Returns a shallow copy of this [ImportRun]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ImportRun copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    _incxtnh4.ImportEntityType? entityType,
    _ihge5bzx.SyncRunMode? mode,
    _igklebcn.SyncRunTrigger? trigger,
    bool? dryRun,
    _iuo8pohf.SyncRunStatus? status,
    String? fileStorageKey,
    String? fileName,
    String? fileSha256,
    String? reportStorageKey,
    String? errorMessage,
    DateTime? startedAt = const _is.$UndefinedDateTime(),
    DateTime? finishedAt = const _is.$UndefinedDateTime(),
    _is.UuidValue? requestedBy = const _is.$UndefinedUuidValue(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportRun',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'entityType': entityType.toJson(),
      'mode': mode.toJson(),
      'trigger': trigger.toJson(),
      'dryRun': dryRun,
      'status': status.toJson(),
      if (fileStorageKey != null) 'fileStorageKey': fileStorageKey,
      if (fileName != null) 'fileName': fileName,
      if (fileSha256 != null) 'fileSha256': fileSha256,
      if (reportStorageKey != null) 'reportStorageKey': reportStorageKey,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      if (requestedBy != null) 'requestedBy': requestedBy?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportRun',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'entityType': entityType.toJson(),
      'mode': mode.toJson(),
      'trigger': trigger.toJson(),
      'dryRun': dryRun,
      'status': status.toJson(),
      if (fileStorageKey != null) 'fileStorageKey': fileStorageKey,
      if (fileName != null) 'fileName': fileName,
      if (fileSha256 != null) 'fileSha256': fileSha256,
      if (reportStorageKey != null) 'reportStorageKey': reportStorageKey,
      if (errorMessage != null) 'errorMessage': errorMessage,
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (finishedAt != null) 'finishedAt': finishedAt?.toJson(),
      if (requestedBy != null) 'requestedBy': requestedBy?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  static ImportRunInclude include() {
    return ImportRunInclude._();
  }

  static ImportRunIncludeList includeList({
    _is.WhereExpressionBuilder<ImportRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ImportRunTable>? orderBy,
    _is.OrderByListBuilder<ImportRunTable>? orderByList,
    ImportRunInclude? include,
  }) {
    return ImportRunIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ImportRun.t),
      orderByList: orderByList?.call(ImportRun.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImportRunImpl extends ImportRun {
  _ImportRunImpl({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required _incxtnh4.ImportEntityType entityType,
    required _ihge5bzx.SyncRunMode mode,
    required _igklebcn.SyncRunTrigger trigger,
    required bool dryRun,
    required _iuo8pohf.SyncRunStatus status,
    String? fileStorageKey,
    String? fileName,
    String? fileSha256,
    String? reportStorageKey,
    String? errorMessage,
    DateTime? startedAt,
    DateTime? finishedAt,
    _is.UuidValue? requestedBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         tenantId: tenantId,
         entityType: entityType,
         mode: mode,
         trigger: trigger,
         dryRun: dryRun,
         status: status,
         fileStorageKey: fileStorageKey,
         fileName: fileName,
         fileSha256: fileSha256,
         reportStorageKey: reportStorageKey,
         errorMessage: errorMessage,
         startedAt: startedAt,
         finishedAt: finishedAt,
         requestedBy: requestedBy,
         createdAt: createdAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [ImportRun]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ImportRun copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    _incxtnh4.ImportEntityType? entityType,
    _ihge5bzx.SyncRunMode? mode,
    _igklebcn.SyncRunTrigger? trigger,
    bool? dryRun,
    _iuo8pohf.SyncRunStatus? status,
    Object? fileStorageKey = _Undefined,
    Object? fileName = _Undefined,
    Object? fileSha256 = _Undefined,
    Object? reportStorageKey = _Undefined,
    Object? errorMessage = _Undefined,
    DateTime? startedAt = const _is.$UndefinedDateTime(),
    DateTime? finishedAt = const _is.$UndefinedDateTime(),
    _is.UuidValue? requestedBy = const _is.$UndefinedUuidValue(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return ImportRun(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      entityType: entityType ?? this.entityType,
      mode: mode ?? this.mode,
      trigger: trigger ?? this.trigger,
      dryRun: dryRun ?? this.dryRun,
      status: status ?? this.status,
      fileStorageKey: fileStorageKey is String? ? fileStorageKey : this.fileStorageKey,
      fileName: fileName is String? ? fileName : this.fileName,
      fileSha256: fileSha256 is String? ? fileSha256 : this.fileSha256,
      reportStorageKey: reportStorageKey is String? ? reportStorageKey : this.reportStorageKey,
      errorMessage: errorMessage is String? ? errorMessage : this.errorMessage,
      startedAt: startedAt is _is.UndefinedSentinel ? this.startedAt : startedAt,
      finishedAt: finishedAt is _is.UndefinedSentinel ? this.finishedAt : finishedAt,
      requestedBy: requestedBy is _is.UndefinedSentinel ? this.requestedBy : requestedBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}

class ImportRunUpdateTable extends _is.UpdateTable<ImportRunTable> {
  ImportRunUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> tenantId(_is.UuidValue value) => _is.ColumnValue(
    table.tenantId,
    value,
  );

  _is.ColumnValue<_incxtnh4.ImportEntityType, _incxtnh4.ImportEntityType> entityType(
    _incxtnh4.ImportEntityType value,
  ) => _is.ColumnValue(
    table.entityType,
    value,
  );

  _is.ColumnValue<_ihge5bzx.SyncRunMode, _ihge5bzx.SyncRunMode> mode(_ihge5bzx.SyncRunMode value) => _is.ColumnValue(
    table.mode,
    value,
  );

  _is.ColumnValue<_igklebcn.SyncRunTrigger, _igklebcn.SyncRunTrigger> trigger(_igklebcn.SyncRunTrigger value) =>
      _is.ColumnValue(
        table.trigger,
        value,
      );

  _is.ColumnValue<bool, bool> dryRun(bool value) => _is.ColumnValue(
    table.dryRun,
    value,
  );

  _is.ColumnValue<_iuo8pohf.SyncRunStatus, _iuo8pohf.SyncRunStatus> status(_iuo8pohf.SyncRunStatus value) =>
      _is.ColumnValue(
        table.status,
        value,
      );

  _is.ColumnValue<String, String> fileStorageKey(String? value) => _is.ColumnValue(
    table.fileStorageKey,
    value,
  );

  _is.ColumnValue<String, String> fileName(String? value) => _is.ColumnValue(
    table.fileName,
    value,
  );

  _is.ColumnValue<String, String> fileSha256(String? value) => _is.ColumnValue(
    table.fileSha256,
    value,
  );

  _is.ColumnValue<String, String> reportStorageKey(String? value) => _is.ColumnValue(
    table.reportStorageKey,
    value,
  );

  _is.ColumnValue<String, String> errorMessage(String? value) => _is.ColumnValue(
    table.errorMessage,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> startedAt(DateTime? value) => _is.ColumnValue(
    table.startedAt,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> finishedAt(DateTime? value) => _is.ColumnValue(
    table.finishedAt,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> requestedBy(_is.UuidValue? value) => _is.ColumnValue(
    table.requestedBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) => _is.ColumnValue(
    table.createdAt,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) => _is.ColumnValue(
    table.updatedAt,
    value,
  );

  _is.ColumnValue<int, int> version(int value) => _is.ColumnValue(
    table.version,
    value,
  );
}

class ImportRunTable extends _is.Table<_is.UuidValue> {
  ImportRunTable({super.tableRelation}) : super(tableName: 'sync_runs') {
    updateTable = ImportRunUpdateTable(this);
    tenantId = _is.ColumnUuid(
      'tenant_id',
      this,
      fieldName: 'tenantId',
    );
    entityType = _is.ColumnEnum(
      'entity_type',
      this,
      _is.EnumSerialization.byName,
      fieldName: 'entityType',
    );
    mode = _is.ColumnEnum(
      'mode',
      this,
      _is.EnumSerialization.byName,
    );
    trigger = _is.ColumnEnum(
      'trigger',
      this,
      _is.EnumSerialization.byName,
    );
    dryRun = _is.ColumnBool(
      'dry_run',
      this,
      fieldName: 'dryRun',
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    fileStorageKey = _is.ColumnString(
      'file_storage_key',
      this,
      fieldName: 'fileStorageKey',
    );
    fileName = _is.ColumnString(
      'file_name',
      this,
      fieldName: 'fileName',
    );
    fileSha256 = _is.ColumnString(
      'file_sha256',
      this,
      fieldName: 'fileSha256',
    );
    reportStorageKey = _is.ColumnString(
      'report_storage_key',
      this,
      fieldName: 'reportStorageKey',
    );
    errorMessage = _is.ColumnString(
      'error_message',
      this,
      fieldName: 'errorMessage',
    );
    startedAt = _is.ColumnDateTime(
      'started_at',
      this,
      fieldName: 'startedAt',
    );
    finishedAt = _is.ColumnDateTime(
      'finished_at',
      this,
      fieldName: 'finishedAt',
    );
    requestedBy = _is.ColumnUuid(
      'requested_by',
      this,
      fieldName: 'requestedBy',
    );
    createdAt = _is.ColumnDateTime(
      'created_at',
      this,
      fieldName: 'createdAt',
    );
    updatedAt = _is.ColumnDateTime(
      'updated_at',
      this,
      fieldName: 'updatedAt',
    );
    version = _is.ColumnInt(
      'version',
      this,
    );
  }

  late final ImportRunUpdateTable updateTable;

  late final _is.ColumnUuid tenantId;

  late final _is.ColumnEnum<_incxtnh4.ImportEntityType> entityType;

  late final _is.ColumnEnum<_ihge5bzx.SyncRunMode> mode;

  late final _is.ColumnEnum<_igklebcn.SyncRunTrigger> trigger;

  late final _is.ColumnBool dryRun;

  late final _is.ColumnEnum<_iuo8pohf.SyncRunStatus> status;

  late final _is.ColumnString fileStorageKey;

  late final _is.ColumnString fileName;

  late final _is.ColumnString fileSha256;

  late final _is.ColumnString reportStorageKey;

  late final _is.ColumnString errorMessage;

  late final _is.ColumnDateTime startedAt;

  late final _is.ColumnDateTime finishedAt;

  late final _is.ColumnUuid requestedBy;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnInt version;

  @override
  List<_is.Column> get columns => [
    id,
    tenantId,
    entityType,
    mode,
    trigger,
    dryRun,
    status,
    fileStorageKey,
    fileName,
    fileSha256,
    reportStorageKey,
    errorMessage,
    startedAt,
    finishedAt,
    requestedBy,
    createdAt,
    updatedAt,
    version,
  ];
}

class ImportRunInclude extends _is.IncludeObject {
  ImportRunInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue> get table => ImportRun.t;
}

class ImportRunIncludeList extends _is.IncludeList {
  ImportRunIncludeList._({
    _is.WhereExpressionBuilder<ImportRunTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ImportRun.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue> get table => ImportRun.t;
}

class ImportRunRepository {
  const ImportRunRepository._();

  /// Returns a list of [ImportRun]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<ImportRun>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ImportRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ImportRunTable>? orderBy,
    _is.OrderByListBuilder<ImportRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ImportRun>(
      where: where?.call(ImportRun.t),
      orderBy: orderBy?.call(ImportRun.t),
      orderByList: orderByList?.call(ImportRun.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ImportRun]s matching the given query parameters every time the
  /// source tables are modified.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// Use [throttle] to specify the minimum interval between queries. It can
  /// also be set to `null`, in which case the stream will only be throttled
  /// when its subscription is paused.
  ///
  /// Source tables are collected from the queried table, [where], [orderBy],
  /// [orderByList], and the [include] graph. [alsoTriggerOnTables] is added
  /// to that set. Pass [Table] instances such as `ImportRun.t`.
  ///
  /// Raw [Expression] SQL is not inspected. Tables referenced only in raw
  /// SQL must be passed via [alsoTriggerOnTables].
  ///
  /// The stream always reads committed state and never joins an ambient
  /// [Transaction]. Emissions for a write fire after that write commits.
  ///
  /// Currently only supported on SQLite. Calling this method on PostgreSQL
  /// throws an [UnsupportedError].
  ///
  /// ```dart
  /// var subscription = Persons.db.watch(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// ).listen((persons) {
  ///   // Handle the latest matching rows.
  /// });
  /// ```
  _ida.Stream<List<ImportRun>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ImportRunTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ImportRunTable>? orderBy,
    _is.OrderByListBuilder<ImportRunTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ImportRun>(
      where: where?.call(ImportRun.t),
      orderBy: orderBy?.call(ImportRun.t),
      orderByList: orderByList?.call(ImportRun.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ImportRun] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<ImportRun?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ImportRunTable>? where,
    int? offset,
    _is.OrderByBuilder<ImportRunTable>? orderBy,
    _is.OrderByListBuilder<ImportRunTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ImportRun>(
      where: where?.call(ImportRun.t),
      orderBy: orderBy?.call(ImportRun.t),
      orderByList: orderByList?.call(ImportRun.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ImportRun] by its [id] or null if no such row exists.
  Future<ImportRun?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ImportRun>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ImportRun]s in the list and returns the inserted rows.
  ///
  /// The returned [ImportRun]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ImportRun>> insert(
    _is.DatabaseSession session,
    List<ImportRun> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ImportRun>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ImportRun] and returns the inserted row.
  ///
  /// The returned [ImportRun] will have its `id` field set.
  Future<ImportRun> insertRow(
    _is.DatabaseSession session,
    ImportRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ImportRun>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ImportRun]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [ImportRun]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ImportRun>> upsert(
    _is.DatabaseSession session,
    List<ImportRun> rows, {
    required _is.ColumnSelections<ImportRunTable> conflictColumns,
    _is.ColumnSelections<ImportRunTable>? updateColumns,
    _is.WhereExpressionBuilder<ImportRunTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ImportRun>(
      rows,
      conflictColumns: conflictColumns(ImportRun.t),
      updateColumns: updateColumns?.call(ImportRun.t),
      updateWhere: updateWhere?.call(ImportRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ImportRun] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [ImportRun] will have its `id` field set.
  Future<ImportRun?> upsertRow(
    _is.DatabaseSession session,
    ImportRun row, {
    required _is.ColumnSelections<ImportRunTable> conflictColumns,
    _is.ColumnSelections<ImportRunTable>? updateColumns,
    _is.WhereExpressionBuilder<ImportRunTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ImportRun>(
      row,
      conflictColumns: conflictColumns(ImportRun.t),
      updateColumns: updateColumns?.call(ImportRun.t),
      updateWhere: updateWhere?.call(ImportRun.t),
      transaction: transaction,
    );
  }

  /// Updates all [ImportRun]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ImportRun>> update(
    _is.DatabaseSession session,
    List<ImportRun> rows, {
    _is.ColumnSelections<ImportRunTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ImportRun>(
      rows,
      columns: columns?.call(ImportRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ImportRun]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ImportRun> updateRow(
    _is.DatabaseSession session,
    ImportRun row, {
    _is.ColumnSelections<ImportRunTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ImportRun>(
      row,
      columns: columns?.call(ImportRun.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ImportRun] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ImportRun?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ImportRunUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ImportRun>(
      id,
      columnValues: columnValues(ImportRun.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ImportRun]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ImportRun>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ImportRunUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ImportRunTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ImportRunTable>? orderBy,
    _is.OrderByListBuilder<ImportRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ImportRun>(
      columnValues: columnValues(ImportRun.t.updateTable),
      where: where(ImportRun.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ImportRun.t),
      orderByList: orderByList?.call(ImportRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ImportRun]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ImportRun>> delete(
    _is.DatabaseSession session,
    List<ImportRun> rows, {
    _is.OrderByBuilder<ImportRunTable>? orderBy,
    _is.OrderByListBuilder<ImportRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ImportRun>(
      rows,
      orderBy: orderBy?.call(ImportRun.t),
      orderByList: orderByList?.call(ImportRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ImportRun].
  Future<ImportRun> deleteRow(
    _is.DatabaseSession session,
    ImportRun row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ImportRun>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ImportRun>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ImportRunTable> where,
    _is.OrderByBuilder<ImportRunTable>? orderBy,
    _is.OrderByListBuilder<ImportRunTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ImportRun>(
      where: where(ImportRun.t),
      orderBy: orderBy?.call(ImportRun.t),
      orderByList: orderByList?.call(ImportRun.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ImportRunTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ImportRun>(
      where: where?.call(ImportRun.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ImportRun] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ImportRunTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ImportRun>(
      where: where(ImportRun.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
