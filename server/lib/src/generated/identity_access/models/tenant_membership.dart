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
import '../../identity_access/models/membership_status.dart' as _it4aomi2;

abstract class TenantMembership implements _is.TableRow<_is.UuidValue>, _is.ProtocolSerialization {
  TenantMembership._({
    _is.UuidValue? id,
    required this.tenantId,
    required this.userId,
    required this.status,
    this.lastAccessAt,
    required this.version,
  }) : id = id ?? const _is.Uuid().v7obj();

  factory TenantMembership({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required _is.UuidValue userId,
    required _it4aomi2.MembershipStatus status,
    DateTime? lastAccessAt,
    required int version,
  }) = _TenantMembershipImpl;

  factory TenantMembership.fromJson(Map<String, dynamic> jsonSerialization) {
    return TenantMembership(
      id: jsonSerialization['id'] == null ? null : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      userId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      status: _it4aomi2.MembershipStatus.fromJson((jsonSerialization['status'] as String)),
      lastAccessAt: jsonSerialization['lastAccessAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastAccessAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = TenantMembershipTable();

  static const db = TenantMembershipRepository._();

  @override
  _is.UuidValue id;

  _is.UuidValue tenantId;

  _is.UuidValue userId;

  _it4aomi2.MembershipStatus status;

  DateTime? lastAccessAt;

  int version;

  @override
  _is.Table<_is.UuidValue> get table => t;

  /// Returns a shallow copy of this [TenantMembership]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TenantMembership copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    _is.UuidValue? userId,
    _it4aomi2.MembershipStatus? status,
    DateTime? lastAccessAt = const _is.$UndefinedDateTime(),
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TenantMembership',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'userId': userId.toJson(),
      'status': status.toJson(),
      if (lastAccessAt != null) 'lastAccessAt': lastAccessAt?.toJson(),
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TenantMembership',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'userId': userId.toJson(),
      'status': status.toJson(),
      if (lastAccessAt != null) 'lastAccessAt': lastAccessAt?.toJson(),
      'version': version,
    };
  }

  static TenantMembershipInclude include() {
    return TenantMembershipInclude._();
  }

  static TenantMembershipIncludeList includeList({
    _is.WhereExpressionBuilder<TenantMembershipTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TenantMembershipTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipTable>? orderByList,
    TenantMembershipInclude? include,
  }) {
    return TenantMembershipIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TenantMembership.t),
      orderByList: orderByList?.call(TenantMembership.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TenantMembershipImpl extends TenantMembership {
  _TenantMembershipImpl({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required _is.UuidValue userId,
    required _it4aomi2.MembershipStatus status,
    DateTime? lastAccessAt,
    required int version,
  }) : super._(
         id: id,
         tenantId: tenantId,
         userId: userId,
         status: status,
         lastAccessAt: lastAccessAt,
         version: version,
       );

  /// Returns a shallow copy of this [TenantMembership]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TenantMembership copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    _is.UuidValue? userId,
    _it4aomi2.MembershipStatus? status,
    DateTime? lastAccessAt = const _is.$UndefinedDateTime(),
    int? version,
  }) {
    return TenantMembership(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      lastAccessAt: lastAccessAt is _is.UndefinedSentinel ? this.lastAccessAt : lastAccessAt,
      version: version ?? this.version,
    );
  }
}

class TenantMembershipUpdateTable extends _is.UpdateTable<TenantMembershipTable> {
  TenantMembershipUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> tenantId(_is.UuidValue value) => _is.ColumnValue(
    table.tenantId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<_it4aomi2.MembershipStatus, _it4aomi2.MembershipStatus> status(_it4aomi2.MembershipStatus value) =>
      _is.ColumnValue(
        table.status,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastAccessAt(DateTime? value) => _is.ColumnValue(
    table.lastAccessAt,
    value,
  );

  _is.ColumnValue<int, int> version(int value) => _is.ColumnValue(
    table.version,
    value,
  );
}

class TenantMembershipTable extends _is.Table<_is.UuidValue> {
  TenantMembershipTable({super.tableRelation}) : super(tableName: 'tenant_memberships') {
    updateTable = TenantMembershipUpdateTable(this);
    tenantId = _is.ColumnUuid(
      'tenant_id',
      this,
      fieldName: 'tenantId',
    );
    userId = _is.ColumnUuid(
      'user_id',
      this,
      fieldName: 'userId',
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    lastAccessAt = _is.ColumnDateTime(
      'last_access_at',
      this,
      fieldName: 'lastAccessAt',
    );
    version = _is.ColumnInt(
      'version',
      this,
    );
  }

  late final TenantMembershipUpdateTable updateTable;

  late final _is.ColumnUuid tenantId;

  late final _is.ColumnUuid userId;

  late final _is.ColumnEnum<_it4aomi2.MembershipStatus> status;

  late final _is.ColumnDateTime lastAccessAt;

  late final _is.ColumnInt version;

  @override
  List<_is.Column> get columns => [
    id,
    tenantId,
    userId,
    status,
    lastAccessAt,
    version,
  ];
}

class TenantMembershipInclude extends _is.IncludeObject {
  TenantMembershipInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue> get table => TenantMembership.t;
}

class TenantMembershipIncludeList extends _is.IncludeList {
  TenantMembershipIncludeList._({
    _is.WhereExpressionBuilder<TenantMembershipTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TenantMembership.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue> get table => TenantMembership.t;
}

class TenantMembershipRepository {
  const TenantMembershipRepository._();

  /// Returns a list of [TenantMembership]s matching the given query parameters.
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
  Future<List<TenantMembership>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TenantMembershipTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TenantMembershipTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TenantMembership>(
      where: where?.call(TenantMembership.t),
      orderBy: orderBy?.call(TenantMembership.t),
      orderByList: orderByList?.call(TenantMembership.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [TenantMembership]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `TenantMembership.t`.
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
  _ida.Stream<List<TenantMembership>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TenantMembershipTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TenantMembershipTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<TenantMembership>(
      where: where?.call(TenantMembership.t),
      orderBy: orderBy?.call(TenantMembership.t),
      orderByList: orderByList?.call(TenantMembership.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [TenantMembership] matching the given query parameters.
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
  Future<TenantMembership?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TenantMembershipTable>? where,
    int? offset,
    _is.OrderByBuilder<TenantMembershipTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TenantMembership>(
      where: where?.call(TenantMembership.t),
      orderBy: orderBy?.call(TenantMembership.t),
      orderByList: orderByList?.call(TenantMembership.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TenantMembership] by its [id] or null if no such row exists.
  Future<TenantMembership?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TenantMembership>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TenantMembership]s in the list and returns the inserted rows.
  ///
  /// The returned [TenantMembership]s will have their `id` fields set.
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
  Future<List<TenantMembership>> insert(
    _is.DatabaseSession session,
    List<TenantMembership> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TenantMembership>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TenantMembership] and returns the inserted row.
  ///
  /// The returned [TenantMembership] will have its `id` field set.
  Future<TenantMembership> insertRow(
    _is.DatabaseSession session,
    TenantMembership row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TenantMembership>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TenantMembership]s in the list and returns the resulting rows.
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
  /// The returned [TenantMembership]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TenantMembership>> upsert(
    _is.DatabaseSession session,
    List<TenantMembership> rows, {
    required _is.ColumnSelections<TenantMembershipTable> conflictColumns,
    _is.ColumnSelections<TenantMembershipTable>? updateColumns,
    _is.WhereExpressionBuilder<TenantMembershipTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TenantMembership>(
      rows,
      conflictColumns: conflictColumns(TenantMembership.t),
      updateColumns: updateColumns?.call(TenantMembership.t),
      updateWhere: updateWhere?.call(TenantMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TenantMembership] and returns the resulting row.
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
  /// The returned [TenantMembership] will have its `id` field set.
  Future<TenantMembership?> upsertRow(
    _is.DatabaseSession session,
    TenantMembership row, {
    required _is.ColumnSelections<TenantMembershipTable> conflictColumns,
    _is.ColumnSelections<TenantMembershipTable>? updateColumns,
    _is.WhereExpressionBuilder<TenantMembershipTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TenantMembership>(
      row,
      conflictColumns: conflictColumns(TenantMembership.t),
      updateColumns: updateColumns?.call(TenantMembership.t),
      updateWhere: updateWhere?.call(TenantMembership.t),
      transaction: transaction,
    );
  }

  /// Updates all [TenantMembership]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TenantMembership>> update(
    _is.DatabaseSession session,
    List<TenantMembership> rows, {
    _is.ColumnSelections<TenantMembershipTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TenantMembership>(
      rows,
      columns: columns?.call(TenantMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TenantMembership]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TenantMembership> updateRow(
    _is.DatabaseSession session,
    TenantMembership row, {
    _is.ColumnSelections<TenantMembershipTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TenantMembership>(
      row,
      columns: columns?.call(TenantMembership.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TenantMembership] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TenantMembership?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TenantMembershipUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TenantMembership>(
      id,
      columnValues: columnValues(TenantMembership.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TenantMembership]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TenantMembership>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TenantMembershipUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TenantMembershipTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TenantMembershipTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TenantMembership>(
      columnValues: columnValues(TenantMembership.t.updateTable),
      where: where(TenantMembership.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TenantMembership.t),
      orderByList: orderByList?.call(TenantMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TenantMembership]s in the list and returns the deleted rows.
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
  Future<List<TenantMembership>> delete(
    _is.DatabaseSession session,
    List<TenantMembership> rows, {
    _is.OrderByBuilder<TenantMembershipTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TenantMembership>(
      rows,
      orderBy: orderBy?.call(TenantMembership.t),
      orderByList: orderByList?.call(TenantMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TenantMembership].
  Future<TenantMembership> deleteRow(
    _is.DatabaseSession session,
    TenantMembership row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TenantMembership>(
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
  Future<List<TenantMembership>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TenantMembershipTable> where,
    _is.OrderByBuilder<TenantMembershipTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TenantMembership>(
      where: where(TenantMembership.t),
      orderBy: orderBy?.call(TenantMembership.t),
      orderByList: orderByList?.call(TenantMembership.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TenantMembershipTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TenantMembership>(
      where: where?.call(TenantMembership.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TenantMembership] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TenantMembershipTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TenantMembership>(
      where: where(TenantMembership.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
