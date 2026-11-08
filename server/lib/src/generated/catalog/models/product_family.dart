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
import '../../platform/models/record_source.dart' as _i1c87mer;

abstract class ProductFamily implements _is.TableRow<_is.UuidValue>, _is.ProtocolSerialization {
  ProductFamily._({
    _is.UuidValue? id,
    required this.tenantId,
    this.parentId,
    required this.code,
    required this.name,
    required this.isActive,
    required this.source,
    this.externalSystem,
    this.externalId,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : id = id ?? const _is.Uuid().v7obj();

  factory ProductFamily({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    _is.UuidValue? parentId,
    required String code,
    required String name,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _ProductFamilyImpl;

  factory ProductFamily.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductFamily(
      id: jsonSerialization['id'] == null ? null : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      source: _i1c87mer.RecordSource.fromJson((jsonSerialization['source'] as String)),
      externalSystem: jsonSerialization['externalSystem'] as String?,
      externalId: jsonSerialization['externalId'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = ProductFamilyTable();

  static const db = ProductFamilyRepository._();

  @override
  _is.UuidValue id;

  _is.UuidValue tenantId;

  _is.UuidValue? parentId;

  String code;

  String name;

  bool isActive;

  _i1c87mer.RecordSource source;

  String? externalSystem;

  String? externalId;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  @override
  _is.Table<_is.UuidValue> get table => t;

  /// Returns a shallow copy of this [ProductFamily]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProductFamily copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    _is.UuidValue? parentId = const _is.$UndefinedUuidValue(),
    String? code,
    String? name,
    bool? isActive,
    _i1c87mer.RecordSource? source,
    String? externalSystem,
    String? externalId,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductFamily',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      if (parentId != null) 'parentId': parentId?.toJson(),
      'code': code,
      'name': name,
      'isActive': isActive,
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductFamily',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      if (parentId != null) 'parentId': parentId?.toJson(),
      'code': code,
      'name': name,
      'isActive': isActive,
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  static ProductFamilyInclude include() {
    return ProductFamilyInclude._();
  }

  static ProductFamilyIncludeList includeList({
    _is.WhereExpressionBuilder<ProductFamilyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductFamilyTable>? orderBy,
    _is.OrderByListBuilder<ProductFamilyTable>? orderByList,
    ProductFamilyInclude? include,
  }) {
    return ProductFamilyIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductFamily.t),
      orderByList: orderByList?.call(ProductFamily.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductFamilyImpl extends ProductFamily {
  _ProductFamilyImpl({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    _is.UuidValue? parentId,
    required String code,
    required String name,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         tenantId: tenantId,
         parentId: parentId,
         code: code,
         name: name,
         isActive: isActive,
         source: source,
         externalSystem: externalSystem,
         externalId: externalId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [ProductFamily]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ProductFamily copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    _is.UuidValue? parentId = const _is.$UndefinedUuidValue(),
    String? code,
    String? name,
    bool? isActive,
    _i1c87mer.RecordSource? source,
    Object? externalSystem = _Undefined,
    Object? externalId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return ProductFamily(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      parentId: parentId is _is.UndefinedSentinel ? this.parentId : parentId,
      code: code ?? this.code,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
      source: source ?? this.source,
      externalSystem: externalSystem is String? ? externalSystem : this.externalSystem,
      externalId: externalId is String? ? externalId : this.externalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}

class ProductFamilyUpdateTable extends _is.UpdateTable<ProductFamilyTable> {
  ProductFamilyUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> tenantId(_is.UuidValue value) => _is.ColumnValue(
    table.tenantId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> parentId(_is.UuidValue? value) => _is.ColumnValue(
    table.parentId,
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

class ProductFamilyTable extends _is.Table<_is.UuidValue> {
  ProductFamilyTable({super.tableRelation}) : super(tableName: 'product_families') {
    updateTable = ProductFamilyUpdateTable(this);
    tenantId = _is.ColumnUuid(
      'tenant_id',
      this,
      fieldName: 'tenantId',
    );
    parentId = _is.ColumnUuid(
      'parent_id',
      this,
      fieldName: 'parentId',
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
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

  late final ProductFamilyUpdateTable updateTable;

  late final _is.ColumnUuid tenantId;

  late final _is.ColumnUuid parentId;

  late final _is.ColumnString code;

  late final _is.ColumnString name;

  late final _is.ColumnBool isActive;

  late final _is.ColumnEnum<_i1c87mer.RecordSource> source;

  late final _is.ColumnString externalSystem;

  late final _is.ColumnString externalId;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnInt version;

  @override
  List<_is.Column> get columns => [
    id,
    tenantId,
    parentId,
    code,
    name,
    isActive,
    source,
    externalSystem,
    externalId,
    createdAt,
    updatedAt,
    version,
  ];
}

class ProductFamilyInclude extends _is.IncludeObject {
  ProductFamilyInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue> get table => ProductFamily.t;
}

class ProductFamilyIncludeList extends _is.IncludeList {
  ProductFamilyIncludeList._({
    _is.WhereExpressionBuilder<ProductFamilyTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(ProductFamily.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue> get table => ProductFamily.t;
}

class ProductFamilyRepository {
  const ProductFamilyRepository._();

  /// Returns a list of [ProductFamily]s matching the given query parameters.
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
  Future<List<ProductFamily>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductFamilyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductFamilyTable>? orderBy,
    _is.OrderByListBuilder<ProductFamilyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<ProductFamily>(
      where: where?.call(ProductFamily.t),
      orderBy: orderBy?.call(ProductFamily.t),
      orderByList: orderByList?.call(ProductFamily.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [ProductFamily]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `ProductFamily.t`.
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
  _ida.Stream<List<ProductFamily>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductFamilyTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductFamilyTable>? orderBy,
    _is.OrderByListBuilder<ProductFamilyTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<ProductFamily>(
      where: where?.call(ProductFamily.t),
      orderBy: orderBy?.call(ProductFamily.t),
      orderByList: orderByList?.call(ProductFamily.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [ProductFamily] matching the given query parameters.
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
  Future<ProductFamily?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductFamilyTable>? where,
    int? offset,
    _is.OrderByBuilder<ProductFamilyTable>? orderBy,
    _is.OrderByListBuilder<ProductFamilyTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<ProductFamily>(
      where: where?.call(ProductFamily.t),
      orderBy: orderBy?.call(ProductFamily.t),
      orderByList: orderByList?.call(ProductFamily.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [ProductFamily] by its [id] or null if no such row exists.
  Future<ProductFamily?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<ProductFamily>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [ProductFamily]s in the list and returns the inserted rows.
  ///
  /// The returned [ProductFamily]s will have their `id` fields set.
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
  Future<List<ProductFamily>> insert(
    _is.DatabaseSession session,
    List<ProductFamily> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<ProductFamily>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [ProductFamily] and returns the inserted row.
  ///
  /// The returned [ProductFamily] will have its `id` field set.
  Future<ProductFamily> insertRow(
    _is.DatabaseSession session,
    ProductFamily row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<ProductFamily>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [ProductFamily]s in the list and returns the resulting rows.
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
  /// The returned [ProductFamily]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProductFamily>> upsert(
    _is.DatabaseSession session,
    List<ProductFamily> rows, {
    required _is.ColumnSelections<ProductFamilyTable> conflictColumns,
    _is.ColumnSelections<ProductFamilyTable>? updateColumns,
    _is.WhereExpressionBuilder<ProductFamilyTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<ProductFamily>(
      rows,
      conflictColumns: conflictColumns(ProductFamily.t),
      updateColumns: updateColumns?.call(ProductFamily.t),
      updateWhere: updateWhere?.call(ProductFamily.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [ProductFamily] and returns the resulting row.
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
  /// The returned [ProductFamily] will have its `id` field set.
  Future<ProductFamily?> upsertRow(
    _is.DatabaseSession session,
    ProductFamily row, {
    required _is.ColumnSelections<ProductFamilyTable> conflictColumns,
    _is.ColumnSelections<ProductFamilyTable>? updateColumns,
    _is.WhereExpressionBuilder<ProductFamilyTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<ProductFamily>(
      row,
      conflictColumns: conflictColumns(ProductFamily.t),
      updateColumns: updateColumns?.call(ProductFamily.t),
      updateWhere: updateWhere?.call(ProductFamily.t),
      transaction: transaction,
    );
  }

  /// Updates all [ProductFamily]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProductFamily>> update(
    _is.DatabaseSession session,
    List<ProductFamily> rows, {
    _is.ColumnSelections<ProductFamilyTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<ProductFamily>(
      rows,
      columns: columns?.call(ProductFamily.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [ProductFamily]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<ProductFamily> updateRow(
    _is.DatabaseSession session,
    ProductFamily row, {
    _is.ColumnSelections<ProductFamilyTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<ProductFamily>(
      row,
      columns: columns?.call(ProductFamily.t),
      transaction: transaction,
    );
  }

  /// Updates a single [ProductFamily] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<ProductFamily?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<ProductFamilyUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<ProductFamily>(
      id,
      columnValues: columnValues(ProductFamily.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [ProductFamily]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<ProductFamily>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<ProductFamilyUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<ProductFamilyTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<ProductFamilyTable>? orderBy,
    _is.OrderByListBuilder<ProductFamilyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<ProductFamily>(
      columnValues: columnValues(ProductFamily.t.updateTable),
      where: where(ProductFamily.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(ProductFamily.t),
      orderByList: orderByList?.call(ProductFamily.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [ProductFamily]s in the list and returns the deleted rows.
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
  Future<List<ProductFamily>> delete(
    _is.DatabaseSession session,
    List<ProductFamily> rows, {
    _is.OrderByBuilder<ProductFamilyTable>? orderBy,
    _is.OrderByListBuilder<ProductFamilyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<ProductFamily>(
      rows,
      orderBy: orderBy?.call(ProductFamily.t),
      orderByList: orderByList?.call(ProductFamily.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [ProductFamily].
  Future<ProductFamily> deleteRow(
    _is.DatabaseSession session,
    ProductFamily row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<ProductFamily>(
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
  Future<List<ProductFamily>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProductFamilyTable> where,
    _is.OrderByBuilder<ProductFamilyTable>? orderBy,
    _is.OrderByListBuilder<ProductFamilyTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<ProductFamily>(
      where: where(ProductFamily.t),
      orderBy: orderBy?.call(ProductFamily.t),
      orderByList: orderByList?.call(ProductFamily.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<ProductFamilyTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<ProductFamily>(
      where: where?.call(ProductFamily.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [ProductFamily] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<ProductFamilyTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<ProductFamily>(
      where: where(ProductFamily.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
