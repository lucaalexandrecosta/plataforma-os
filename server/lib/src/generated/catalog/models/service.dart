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
import '../../catalog/models/service_kind.dart' as _iu1dhgj0;
import '../../platform/models/record_source.dart' as _i1c87mer;

abstract class CatalogService implements _is.TableRow<_is.UuidValue>, _is.ProtocolSerialization {
  CatalogService._({
    _is.UuidValue? id,
    required this.tenantId,
    required this.code,
    required this.name,
    this.description,
    required this.unitCode,
    this.defaultPrice,
    this.estimatedMinutes,
    required this.serviceKind,
    required this.isActive,
    required this.source,
    this.externalSystem,
    this.externalId,
    this.missingSince,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : id = id ?? const _is.Uuid().v7obj();

  factory CatalogService({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required String code,
    required String name,
    String? description,
    required String unitCode,
    int? defaultPrice,
    int? estimatedMinutes,
    required _iu1dhgj0.ServiceKind serviceKind,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    DateTime? missingSince,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _CatalogServiceImpl;

  factory CatalogService.fromJson(Map<String, dynamic> jsonSerialization) {
    return CatalogService(
      id: jsonSerialization['id'] == null ? null : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      unitCode: jsonSerialization['unitCode'] as String,
      defaultPrice: jsonSerialization['defaultPrice'] as int?,
      estimatedMinutes: jsonSerialization['estimatedMinutes'] as int?,
      serviceKind: _iu1dhgj0.ServiceKind.fromJson((jsonSerialization['serviceKind'] as String)),
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      source: _i1c87mer.RecordSource.fromJson((jsonSerialization['source'] as String)),
      externalSystem: jsonSerialization['externalSystem'] as String?,
      externalId: jsonSerialization['externalId'] as String?,
      missingSince: jsonSerialization['missingSince'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['missingSince']),
      createdAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = CatalogServiceTable();

  static const db = CatalogServiceRepository._();

  @override
  _is.UuidValue id;

  _is.UuidValue tenantId;

  String code;

  String name;

  String? description;

  String unitCode;

  int? defaultPrice;

  int? estimatedMinutes;

  _iu1dhgj0.ServiceKind serviceKind;

  bool isActive;

  _i1c87mer.RecordSource source;

  String? externalSystem;

  String? externalId;

  DateTime? missingSince;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  @override
  _is.Table<_is.UuidValue> get table => t;

  /// Returns a shallow copy of this [CatalogService]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CatalogService copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    String? code,
    String? name,
    String? description,
    String? unitCode,
    int? defaultPrice,
    int? estimatedMinutes,
    _iu1dhgj0.ServiceKind? serviceKind,
    bool? isActive,
    _i1c87mer.RecordSource? source,
    String? externalSystem,
    String? externalId,
    DateTime? missingSince = const _is.$UndefinedDateTime(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CatalogService',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      'unitCode': unitCode,
      if (defaultPrice != null) 'defaultPrice': defaultPrice,
      if (estimatedMinutes != null) 'estimatedMinutes': estimatedMinutes,
      'serviceKind': serviceKind.toJson(),
      'isActive': isActive,
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      if (missingSince != null) 'missingSince': missingSince?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CatalogService',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      'unitCode': unitCode,
      if (defaultPrice != null) 'defaultPrice': defaultPrice,
      if (estimatedMinutes != null) 'estimatedMinutes': estimatedMinutes,
      'serviceKind': serviceKind.toJson(),
      'isActive': isActive,
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      if (missingSince != null) 'missingSince': missingSince?.toJson(),
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  static CatalogServiceInclude include() {
    return CatalogServiceInclude._();
  }

  static CatalogServiceIncludeList includeList({
    _is.WhereExpressionBuilder<CatalogServiceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CatalogServiceTable>? orderBy,
    _is.OrderByListBuilder<CatalogServiceTable>? orderByList,
    CatalogServiceInclude? include,
  }) {
    return CatalogServiceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CatalogService.t),
      orderByList: orderByList?.call(CatalogService.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CatalogServiceImpl extends CatalogService {
  _CatalogServiceImpl({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required String code,
    required String name,
    String? description,
    required String unitCode,
    int? defaultPrice,
    int? estimatedMinutes,
    required _iu1dhgj0.ServiceKind serviceKind,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    DateTime? missingSince,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         tenantId: tenantId,
         code: code,
         name: name,
         description: description,
         unitCode: unitCode,
         defaultPrice: defaultPrice,
         estimatedMinutes: estimatedMinutes,
         serviceKind: serviceKind,
         isActive: isActive,
         source: source,
         externalSystem: externalSystem,
         externalId: externalId,
         missingSince: missingSince,
         createdAt: createdAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [CatalogService]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CatalogService copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    String? code,
    String? name,
    Object? description = _Undefined,
    String? unitCode,
    Object? defaultPrice = _Undefined,
    Object? estimatedMinutes = _Undefined,
    _iu1dhgj0.ServiceKind? serviceKind,
    bool? isActive,
    _i1c87mer.RecordSource? source,
    Object? externalSystem = _Undefined,
    Object? externalId = _Undefined,
    DateTime? missingSince = const _is.$UndefinedDateTime(),
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return CatalogService(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      unitCode: unitCode ?? this.unitCode,
      defaultPrice: defaultPrice is int? ? defaultPrice : this.defaultPrice,
      estimatedMinutes: estimatedMinutes is int? ? estimatedMinutes : this.estimatedMinutes,
      serviceKind: serviceKind ?? this.serviceKind,
      isActive: isActive ?? this.isActive,
      source: source ?? this.source,
      externalSystem: externalSystem is String? ? externalSystem : this.externalSystem,
      externalId: externalId is String? ? externalId : this.externalId,
      missingSince: missingSince is _is.UndefinedSentinel ? this.missingSince : missingSince,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}

class CatalogServiceUpdateTable extends _is.UpdateTable<CatalogServiceTable> {
  CatalogServiceUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> tenantId(_is.UuidValue value) => _is.ColumnValue(
    table.tenantId,
    value,
  );

  _is.ColumnValue<String, String> code(String value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> description(String? value) => _is.ColumnValue(
    table.description,
    value,
  );

  _is.ColumnValue<String, String> unitCode(String value) => _is.ColumnValue(
    table.unitCode,
    value,
  );

  _is.ColumnValue<int, int> defaultPrice(int? value) => _is.ColumnValue(
    table.defaultPrice,
    value,
  );

  _is.ColumnValue<int, int> estimatedMinutes(int? value) => _is.ColumnValue(
    table.estimatedMinutes,
    value,
  );

  _is.ColumnValue<_iu1dhgj0.ServiceKind, _iu1dhgj0.ServiceKind> serviceKind(_iu1dhgj0.ServiceKind value) =>
      _is.ColumnValue(
        table.serviceKind,
        value,
      );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
    table.isActive,
    value,
  );

  _is.ColumnValue<_i1c87mer.RecordSource, _i1c87mer.RecordSource> source(_i1c87mer.RecordSource value) =>
      _is.ColumnValue(
        table.source,
        value,
      );

  _is.ColumnValue<String, String> externalSystem(String? value) => _is.ColumnValue(
    table.externalSystem,
    value,
  );

  _is.ColumnValue<String, String> externalId(String? value) => _is.ColumnValue(
    table.externalId,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> missingSince(DateTime? value) => _is.ColumnValue(
    table.missingSince,
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

class CatalogServiceTable extends _is.Table<_is.UuidValue> {
  CatalogServiceTable({super.tableRelation}) : super(tableName: 'services') {
    updateTable = CatalogServiceUpdateTable(this);
    tenantId = _is.ColumnUuid(
      'tenant_id',
      this,
      fieldName: 'tenantId',
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    description = _is.ColumnString(
      'description',
      this,
    );
    unitCode = _is.ColumnString(
      'unit_code',
      this,
      fieldName: 'unitCode',
    );
    defaultPrice = _is.ColumnInt(
      'default_price',
      this,
      fieldName: 'defaultPrice',
    );
    estimatedMinutes = _is.ColumnInt(
      'estimated_minutes',
      this,
      fieldName: 'estimatedMinutes',
    );
    serviceKind = _is.ColumnEnum(
      'service_kind',
      this,
      _is.EnumSerialization.byName,
      fieldName: 'serviceKind',
    );
    isActive = _is.ColumnBool(
      'is_active',
      this,
      fieldName: 'isActive',
    );
    source = _is.ColumnEnum(
      'source',
      this,
      _is.EnumSerialization.byName,
    );
    externalSystem = _is.ColumnString(
      'external_system',
      this,
      fieldName: 'externalSystem',
    );
    externalId = _is.ColumnString(
      'external_id',
      this,
      fieldName: 'externalId',
    );
    missingSince = _is.ColumnDateTime(
      'missing_since',
      this,
      fieldName: 'missingSince',
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

  late final CatalogServiceUpdateTable updateTable;

  late final _is.ColumnUuid tenantId;

  late final _is.ColumnString code;

  late final _is.ColumnString name;

  late final _is.ColumnString description;

  late final _is.ColumnString unitCode;

  late final _is.ColumnInt defaultPrice;

  late final _is.ColumnInt estimatedMinutes;

  late final _is.ColumnEnum<_iu1dhgj0.ServiceKind> serviceKind;

  late final _is.ColumnBool isActive;

  late final _is.ColumnEnum<_i1c87mer.RecordSource> source;

  late final _is.ColumnString externalSystem;

  late final _is.ColumnString externalId;

  late final _is.ColumnDateTime missingSince;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnInt version;

  @override
  List<_is.Column> get columns => [
    id,
    tenantId,
    code,
    name,
    description,
    unitCode,
    defaultPrice,
    estimatedMinutes,
    serviceKind,
    isActive,
    source,
    externalSystem,
    externalId,
    missingSince,
    createdAt,
    updatedAt,
    version,
  ];
}

class CatalogServiceInclude extends _is.IncludeObject {
  CatalogServiceInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue> get table => CatalogService.t;
}

class CatalogServiceIncludeList extends _is.IncludeList {
  CatalogServiceIncludeList._({
    _is.WhereExpressionBuilder<CatalogServiceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CatalogService.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue> get table => CatalogService.t;
}

class CatalogServiceRepository {
  const CatalogServiceRepository._();

  /// Returns a list of [CatalogService]s matching the given query parameters.
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
  Future<List<CatalogService>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CatalogServiceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CatalogServiceTable>? orderBy,
    _is.OrderByListBuilder<CatalogServiceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CatalogService>(
      where: where?.call(CatalogService.t),
      orderBy: orderBy?.call(CatalogService.t),
      orderByList: orderByList?.call(CatalogService.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [CatalogService]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `CatalogService.t`.
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
  _ida.Stream<List<CatalogService>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CatalogServiceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CatalogServiceTable>? orderBy,
    _is.OrderByListBuilder<CatalogServiceTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<CatalogService>(
      where: where?.call(CatalogService.t),
      orderBy: orderBy?.call(CatalogService.t),
      orderByList: orderByList?.call(CatalogService.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [CatalogService] matching the given query parameters.
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
  Future<CatalogService?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CatalogServiceTable>? where,
    int? offset,
    _is.OrderByBuilder<CatalogServiceTable>? orderBy,
    _is.OrderByListBuilder<CatalogServiceTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CatalogService>(
      where: where?.call(CatalogService.t),
      orderBy: orderBy?.call(CatalogService.t),
      orderByList: orderByList?.call(CatalogService.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CatalogService] by its [id] or null if no such row exists.
  Future<CatalogService?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CatalogService>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CatalogService]s in the list and returns the inserted rows.
  ///
  /// The returned [CatalogService]s will have their `id` fields set.
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
  Future<List<CatalogService>> insert(
    _is.DatabaseSession session,
    List<CatalogService> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CatalogService>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CatalogService] and returns the inserted row.
  ///
  /// The returned [CatalogService] will have its `id` field set.
  Future<CatalogService> insertRow(
    _is.DatabaseSession session,
    CatalogService row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CatalogService>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CatalogService]s in the list and returns the resulting rows.
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
  /// The returned [CatalogService]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CatalogService>> upsert(
    _is.DatabaseSession session,
    List<CatalogService> rows, {
    required _is.ColumnSelections<CatalogServiceTable> conflictColumns,
    _is.ColumnSelections<CatalogServiceTable>? updateColumns,
    _is.WhereExpressionBuilder<CatalogServiceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CatalogService>(
      rows,
      conflictColumns: conflictColumns(CatalogService.t),
      updateColumns: updateColumns?.call(CatalogService.t),
      updateWhere: updateWhere?.call(CatalogService.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CatalogService] and returns the resulting row.
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
  /// The returned [CatalogService] will have its `id` field set.
  Future<CatalogService?> upsertRow(
    _is.DatabaseSession session,
    CatalogService row, {
    required _is.ColumnSelections<CatalogServiceTable> conflictColumns,
    _is.ColumnSelections<CatalogServiceTable>? updateColumns,
    _is.WhereExpressionBuilder<CatalogServiceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CatalogService>(
      row,
      conflictColumns: conflictColumns(CatalogService.t),
      updateColumns: updateColumns?.call(CatalogService.t),
      updateWhere: updateWhere?.call(CatalogService.t),
      transaction: transaction,
    );
  }

  /// Updates all [CatalogService]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CatalogService>> update(
    _is.DatabaseSession session,
    List<CatalogService> rows, {
    _is.ColumnSelections<CatalogServiceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CatalogService>(
      rows,
      columns: columns?.call(CatalogService.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CatalogService]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CatalogService> updateRow(
    _is.DatabaseSession session,
    CatalogService row, {
    _is.ColumnSelections<CatalogServiceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CatalogService>(
      row,
      columns: columns?.call(CatalogService.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CatalogService] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CatalogService?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CatalogServiceUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CatalogService>(
      id,
      columnValues: columnValues(CatalogService.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CatalogService]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CatalogService>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CatalogServiceUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CatalogServiceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CatalogServiceTable>? orderBy,
    _is.OrderByListBuilder<CatalogServiceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CatalogService>(
      columnValues: columnValues(CatalogService.t.updateTable),
      where: where(CatalogService.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CatalogService.t),
      orderByList: orderByList?.call(CatalogService.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CatalogService]s in the list and returns the deleted rows.
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
  Future<List<CatalogService>> delete(
    _is.DatabaseSession session,
    List<CatalogService> rows, {
    _is.OrderByBuilder<CatalogServiceTable>? orderBy,
    _is.OrderByListBuilder<CatalogServiceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CatalogService>(
      rows,
      orderBy: orderBy?.call(CatalogService.t),
      orderByList: orderByList?.call(CatalogService.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CatalogService].
  Future<CatalogService> deleteRow(
    _is.DatabaseSession session,
    CatalogService row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CatalogService>(
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
  Future<List<CatalogService>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CatalogServiceTable> where,
    _is.OrderByBuilder<CatalogServiceTable>? orderBy,
    _is.OrderByListBuilder<CatalogServiceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CatalogService>(
      where: where(CatalogService.t),
      orderBy: orderBy?.call(CatalogService.t),
      orderByList: orderByList?.call(CatalogService.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CatalogServiceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CatalogService>(
      where: where?.call(CatalogService.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CatalogService] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CatalogServiceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CatalogService>(
      where: where(CatalogService.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
