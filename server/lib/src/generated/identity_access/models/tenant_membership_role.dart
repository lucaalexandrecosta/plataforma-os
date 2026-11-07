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

abstract class TenantMembershipRole implements _is.TableRow<_is.UuidValue>, _is.ProtocolSerialization {
  TenantMembershipRole._({
    _is.UuidValue? id,
    required this.tenantId,
    required this.membershipId,
    required this.roleCode,
  }) : id = id ?? const _is.Uuid().v7obj();

  factory TenantMembershipRole({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required _is.UuidValue membershipId,
    required String roleCode,
  }) = _TenantMembershipRoleImpl;

  factory TenantMembershipRole.fromJson(Map<String, dynamic> jsonSerialization) {
    return TenantMembershipRole(
      id: jsonSerialization['id'] == null ? null : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      membershipId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['membershipId']),
      roleCode: jsonSerialization['roleCode'] as String,
    );
  }

  static final t = TenantMembershipRoleTable();

  static const db = TenantMembershipRoleRepository._();

  @override
  _is.UuidValue id;

  _is.UuidValue tenantId;

  _is.UuidValue membershipId;

  String roleCode;

  @override
  _is.Table<_is.UuidValue> get table => t;

  /// Returns a shallow copy of this [TenantMembershipRole]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  TenantMembershipRole copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    _is.UuidValue? membershipId,
    String? roleCode,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'TenantMembershipRole',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'membershipId': membershipId.toJson(),
      'roleCode': roleCode,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'TenantMembershipRole',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'membershipId': membershipId.toJson(),
      'roleCode': roleCode,
    };
  }

  static TenantMembershipRoleInclude include() {
    return TenantMembershipRoleInclude._();
  }

  static TenantMembershipRoleIncludeList includeList({
    _is.WhereExpressionBuilder<TenantMembershipRoleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TenantMembershipRoleTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipRoleTable>? orderByList,
    TenantMembershipRoleInclude? include,
  }) {
    return TenantMembershipRoleIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TenantMembershipRole.t),
      orderByList: orderByList?.call(TenantMembershipRole.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _TenantMembershipRoleImpl extends TenantMembershipRole {
  _TenantMembershipRoleImpl({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required _is.UuidValue membershipId,
    required String roleCode,
  }) : super._(
         id: id,
         tenantId: tenantId,
         membershipId: membershipId,
         roleCode: roleCode,
       );

  /// Returns a shallow copy of this [TenantMembershipRole]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  TenantMembershipRole copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    _is.UuidValue? membershipId,
    String? roleCode,
  }) {
    return TenantMembershipRole(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      membershipId: membershipId ?? this.membershipId,
      roleCode: roleCode ?? this.roleCode,
    );
  }
}

class TenantMembershipRoleUpdateTable extends _is.UpdateTable<TenantMembershipRoleTable> {
  TenantMembershipRoleUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> tenantId(_is.UuidValue value) => _is.ColumnValue(
    table.tenantId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> membershipId(_is.UuidValue value) => _is.ColumnValue(
    table.membershipId,
    value,
  );

  _is.ColumnValue<String, String> roleCode(String value) => _is.ColumnValue(
    table.roleCode,
    value,
  );
}

class TenantMembershipRoleTable extends _is.Table<_is.UuidValue> {
  TenantMembershipRoleTable({super.tableRelation}) : super(tableName: 'tenant_membership_roles') {
    updateTable = TenantMembershipRoleUpdateTable(this);
    tenantId = _is.ColumnUuid(
      'tenant_id',
      this,
      fieldName: 'tenantId',
    );
    membershipId = _is.ColumnUuid(
      'membership_id',
      this,
      fieldName: 'membershipId',
    );
    roleCode = _is.ColumnString(
      'role_code',
      this,
      fieldName: 'roleCode',
    );
  }

  late final TenantMembershipRoleUpdateTable updateTable;

  late final _is.ColumnUuid tenantId;

  late final _is.ColumnUuid membershipId;

  late final _is.ColumnString roleCode;

  @override
  List<_is.Column> get columns => [
    id,
    tenantId,
    membershipId,
    roleCode,
  ];
}

class TenantMembershipRoleInclude extends _is.IncludeObject {
  TenantMembershipRoleInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue> get table => TenantMembershipRole.t;
}

class TenantMembershipRoleIncludeList extends _is.IncludeList {
  TenantMembershipRoleIncludeList._({
    _is.WhereExpressionBuilder<TenantMembershipRoleTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(TenantMembershipRole.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue> get table => TenantMembershipRole.t;
}

class TenantMembershipRoleRepository {
  const TenantMembershipRoleRepository._();

  /// Returns a list of [TenantMembershipRole]s matching the given query parameters.
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
  Future<List<TenantMembershipRole>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TenantMembershipRoleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TenantMembershipRoleTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipRoleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<TenantMembershipRole>(
      where: where?.call(TenantMembershipRole.t),
      orderBy: orderBy?.call(TenantMembershipRole.t),
      orderByList: orderByList?.call(TenantMembershipRole.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [TenantMembershipRole]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `TenantMembershipRole.t`.
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
  _ida.Stream<List<TenantMembershipRole>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TenantMembershipRoleTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TenantMembershipRoleTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipRoleTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<TenantMembershipRole>(
      where: where?.call(TenantMembershipRole.t),
      orderBy: orderBy?.call(TenantMembershipRole.t),
      orderByList: orderByList?.call(TenantMembershipRole.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [TenantMembershipRole] matching the given query parameters.
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
  Future<TenantMembershipRole?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TenantMembershipRoleTable>? where,
    int? offset,
    _is.OrderByBuilder<TenantMembershipRoleTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipRoleTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<TenantMembershipRole>(
      where: where?.call(TenantMembershipRole.t),
      orderBy: orderBy?.call(TenantMembershipRole.t),
      orderByList: orderByList?.call(TenantMembershipRole.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [TenantMembershipRole] by its [id] or null if no such row exists.
  Future<TenantMembershipRole?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<TenantMembershipRole>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [TenantMembershipRole]s in the list and returns the inserted rows.
  ///
  /// The returned [TenantMembershipRole]s will have their `id` fields set.
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
  Future<List<TenantMembershipRole>> insert(
    _is.DatabaseSession session,
    List<TenantMembershipRole> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<TenantMembershipRole>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [TenantMembershipRole] and returns the inserted row.
  ///
  /// The returned [TenantMembershipRole] will have its `id` field set.
  Future<TenantMembershipRole> insertRow(
    _is.DatabaseSession session,
    TenantMembershipRole row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<TenantMembershipRole>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [TenantMembershipRole]s in the list and returns the resulting rows.
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
  /// The returned [TenantMembershipRole]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TenantMembershipRole>> upsert(
    _is.DatabaseSession session,
    List<TenantMembershipRole> rows, {
    required _is.ColumnSelections<TenantMembershipRoleTable> conflictColumns,
    _is.ColumnSelections<TenantMembershipRoleTable>? updateColumns,
    _is.WhereExpressionBuilder<TenantMembershipRoleTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<TenantMembershipRole>(
      rows,
      conflictColumns: conflictColumns(TenantMembershipRole.t),
      updateColumns: updateColumns?.call(TenantMembershipRole.t),
      updateWhere: updateWhere?.call(TenantMembershipRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [TenantMembershipRole] and returns the resulting row.
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
  /// The returned [TenantMembershipRole] will have its `id` field set.
  Future<TenantMembershipRole?> upsertRow(
    _is.DatabaseSession session,
    TenantMembershipRole row, {
    required _is.ColumnSelections<TenantMembershipRoleTable> conflictColumns,
    _is.ColumnSelections<TenantMembershipRoleTable>? updateColumns,
    _is.WhereExpressionBuilder<TenantMembershipRoleTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<TenantMembershipRole>(
      row,
      conflictColumns: conflictColumns(TenantMembershipRole.t),
      updateColumns: updateColumns?.call(TenantMembershipRole.t),
      updateWhere: updateWhere?.call(TenantMembershipRole.t),
      transaction: transaction,
    );
  }

  /// Updates all [TenantMembershipRole]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TenantMembershipRole>> update(
    _is.DatabaseSession session,
    List<TenantMembershipRole> rows, {
    _is.ColumnSelections<TenantMembershipRoleTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<TenantMembershipRole>(
      rows,
      columns: columns?.call(TenantMembershipRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [TenantMembershipRole]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<TenantMembershipRole> updateRow(
    _is.DatabaseSession session,
    TenantMembershipRole row, {
    _is.ColumnSelections<TenantMembershipRoleTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<TenantMembershipRole>(
      row,
      columns: columns?.call(TenantMembershipRole.t),
      transaction: transaction,
    );
  }

  /// Updates a single [TenantMembershipRole] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<TenantMembershipRole?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<TenantMembershipRoleUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<TenantMembershipRole>(
      id,
      columnValues: columnValues(TenantMembershipRole.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [TenantMembershipRole]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<TenantMembershipRole>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<TenantMembershipRoleUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<TenantMembershipRoleTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<TenantMembershipRoleTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipRoleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<TenantMembershipRole>(
      columnValues: columnValues(TenantMembershipRole.t.updateTable),
      where: where(TenantMembershipRole.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(TenantMembershipRole.t),
      orderByList: orderByList?.call(TenantMembershipRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [TenantMembershipRole]s in the list and returns the deleted rows.
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
  Future<List<TenantMembershipRole>> delete(
    _is.DatabaseSession session,
    List<TenantMembershipRole> rows, {
    _is.OrderByBuilder<TenantMembershipRoleTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipRoleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<TenantMembershipRole>(
      rows,
      orderBy: orderBy?.call(TenantMembershipRole.t),
      orderByList: orderByList?.call(TenantMembershipRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [TenantMembershipRole].
  Future<TenantMembershipRole> deleteRow(
    _is.DatabaseSession session,
    TenantMembershipRole row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<TenantMembershipRole>(
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
  Future<List<TenantMembershipRole>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TenantMembershipRoleTable> where,
    _is.OrderByBuilder<TenantMembershipRoleTable>? orderBy,
    _is.OrderByListBuilder<TenantMembershipRoleTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<TenantMembershipRole>(
      where: where(TenantMembershipRole.t),
      orderBy: orderBy?.call(TenantMembershipRole.t),
      orderByList: orderByList?.call(TenantMembershipRole.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<TenantMembershipRoleTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<TenantMembershipRole>(
      where: where?.call(TenantMembershipRole.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [TenantMembershipRole] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<TenantMembershipRoleTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<TenantMembershipRole>(
      where: where(TenantMembershipRole.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
