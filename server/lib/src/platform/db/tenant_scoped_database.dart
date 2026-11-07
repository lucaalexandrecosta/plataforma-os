// As assinaturas espelham exatamente a interface `Database` do Serverpod 4.1.1,
// que usa tipos genéricos crus (TableRow, Column, Expression...).
// ignore_for_file: strict_raw_type
import 'package:serverpod/serverpod.dart';

import '../context/request_context.dart';

/// `databaseInterceptor` do Serverpod 4 (docs/02 §5.2, ADR-019, spike S1).
///
/// Ponto único que garante o tenant: toda operação de banco da sessão — ORM,
/// SQL próprio e transações explícitas — roda dentro de uma transação cuja
/// primeira instrução é
///
/// ```sql
/// SELECT set_config('app.tenant_id', $1, true), set_config('app.user_id', $2, true),
///        set_config('app.actor_type', $3, true), set_config('app.correlation_id', $4, true)
/// ```
///
/// `set_config(..., true)` vale só até o COMMIT/ROLLBACK, então nenhuma
/// variável sobrevive no pool do Serverpod nem num pool em modo transação
/// (RDS Proxy, PgBouncer). A RLS FORCE continua como segunda barreira: sem
/// `app.tenant_id`, nenhuma linha de tenant é visível.
///
/// Sessões de endpoint, stream e rota web sem [RequestContext] são recusadas
/// ([MissingRequestContextError]). Sessões internas do próprio Serverpod
/// (logs, future calls, health check) passam direto quando não têm contexto;
/// os laços do worker anexam `RequestContext.system` antes de usar o banco.
Database tenantScopedDatabaseInterceptor(Session session, Database inner) => TenantScopedDatabase(session, inner);

final class TenantScopedDatabase implements Database {
  TenantScopedDatabase(this._session, this._inner);

  final Session _session;
  final Database _inner;

  /// Contexto já aplicado em cada transação (evita repetir o set_config).
  static final _applied = Expando<RequestContext>('appliedRequestContext');

  static const _setConfigSql =
      'SELECT set_config(\'app.tenant_id\', @tenantId, true), '
      'set_config(\'app.user_id\', @userId, true), '
      'set_config(\'app.actor_type\', @actorType, true), '
      'set_config(\'app.correlation_id\', @correlationId, true)';

  bool get _isFrameworkSession => _session is InternalSession || _session is FutureCallSession;

  /// Contexto da operação, ou `null` quando é uma sessão interna do Serverpod
  /// sem contexto (passa direto, sem transação extra).
  RequestContext? _contextFor(String operation) {
    final ctx = _session.contextOrNull;
    if (ctx == null && !_isFrameworkSession) {
      throw MissingRequestContextError(operation);
    }
    return ctx;
  }

  Future<void> _apply(Transaction tx, RequestContext ctx) async {
    if (identical(_applied[tx], ctx)) return;
    final vars = ctx.sessionVariables;
    await _inner.unsafeQuery(
      _setConfigSql,
      transaction: tx,
      parameters: QueryParameters.named({
        'tenantId': vars['app.tenant_id'],
        'userId': vars['app.user_id'],
        'actorType': vars['app.actor_type'],
        'correlationId': vars['app.correlation_id'],
      }),
    );
    _applied[tx] = ctx;
  }

  /// Executa [body] numa transação com o contexto aplicado: reaproveita a
  /// transação recebida (ou a da sessão, no `serverpod_test`) e só abre uma
  /// nova quando não há nenhuma.
  Future<R> _scoped<R>(String operation, Transaction? transaction, Future<R> Function(Transaction? tx) body) async {
    final ctx = _contextFor(operation);
    if (ctx == null) return body(transaction);
    // ignore: invalid_use_of_visible_for_testing_member
    final existing = transaction ?? _session.transaction;
    if (existing != null) {
      await _apply(existing, ctx);
      return body(existing);
    }
    return _inner.transaction((tx) async {
      await _apply(tx, ctx);
      return body(tx);
    });
  }

  // ------------------------------------------------------------------ propriedades

  @override
  DatabaseDialect get dialect => _inner.dialect;

  @override
  DatabaseSerializationManager get serializationManager => _inner.serializationManager;

  @override
  DatabaseAnalyzer get analyzer => _inner.analyzer;

  // ------------------------------------------------------------------ transações

  @override
  Future<R> transaction<R>(TransactionFunction<R> transactionFunction, {TransactionSettings? settings}) {
    final ctx = _contextFor('transaction');
    if (ctx == null) return _inner.transaction(transactionFunction, settings: settings);
    return _inner.transaction((tx) async {
      await _apply(tx, ctx);
      return transactionFunction(tx);
    }, settings: settings);
  }

  @override
  Future<bool> testConnection() => _inner.testConnection();

  // ------------------------------------------------------------------ leitura

  @override
  Future<List<T>> find<T extends TableRow>({
    Expression? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Column>? orderByList,
    Transaction? transaction,
    Include? include,
    LockMode? lockMode,
    LockBehavior? lockBehavior,
  }) => _scoped(
    'find',
    transaction,
    (tx) => _inner.find<T>(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      transaction: tx,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    ),
  );

  @override
  Future<T?> findFirstRow<T extends TableRow>({
    Expression? where,
    int? offset,
    Column? orderBy,
    List<Column>? orderByList,
    Transaction? transaction,
    Include? include,
    LockMode? lockMode,
    LockBehavior? lockBehavior,
  }) => _scoped(
    'findFirstRow',
    transaction,
    (tx) => _inner.findFirstRow<T>(
      where: where,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      transaction: tx,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    ),
  );

  @override
  Future<T?> findById<T extends TableRow>(
    Object id, {
    Transaction? transaction,
    Include? include,
    LockMode? lockMode,
    LockBehavior? lockBehavior,
  }) => _scoped(
    'findById',
    transaction,
    (tx) => _inner.findById<T>(
      id,
      transaction: tx,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    ),
  );

  @override
  Future<int> count<T extends TableRow>({
    Expression? where,
    int? limit,
    bool useCache = true,
    Transaction? transaction,
  }) => _scoped(
    'count',
    transaction,
    (tx) => _inner.count<T>(where: where, limit: limit, useCache: useCache, transaction: tx),
  );

  @override
  Future<void> lockRows<T extends TableRow>({
    required Expression where,
    required LockMode lockMode,
    required Transaction transaction,
    LockBehavior lockBehavior = LockBehavior.wait,
  }) => _scoped(
    'lockRows',
    transaction,
    (tx) => _inner.lockRows<T>(
      where: where,
      lockMode: lockMode,
      transaction: tx!,
      lockBehavior: lockBehavior,
    ),
  );

  // ------------------------------------------------------------------ escrita

  @override
  Future<List<T>> insert<T extends TableRow>(
    List<T> rows, {
    Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) => _scoped(
    'insert',
    transaction,
    (tx) => _inner.insert<T>(
      rows,
      transaction: tx,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    ),
  );

  @override
  Future<T> insertRow<T extends TableRow>(T row, {Transaction? transaction}) =>
      _scoped('insertRow', transaction, (tx) => _inner.insertRow<T>(row, transaction: tx));

  @override
  Future<List<T>> update<T extends TableRow>(
    List<T> rows, {
    List<Column>? columns,
    Transaction? transaction,
    bool noReturn = false,
  }) => _scoped(
    'update',
    transaction,
    (tx) => _inner.update<T>(rows, columns: columns, transaction: tx, noReturn: noReturn),
  );

  @override
  Future<T> updateRow<T extends TableRow>(T row, {List<Column>? columns, Transaction? transaction}) =>
      _scoped('updateRow', transaction, (tx) => _inner.updateRow<T>(row, columns: columns, transaction: tx));

  @override
  Future<T?> updateById<T extends TableRow>(
    Object id, {
    required List<ColumnValue> columnValues,
    Transaction? transaction,
  }) =>
      _scoped('updateById', transaction, (tx) => _inner.updateById<T>(id, columnValues: columnValues, transaction: tx));

  @override
  Future<List<T>> updateWhere<T extends TableRow>({
    required List<ColumnValue> columnValues,
    required Expression where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Column>? orderByList,
    Transaction? transaction,
    bool noReturn = false,
  }) => _scoped(
    'updateWhere',
    transaction,
    (tx) => _inner.updateWhere<T>(
      columnValues: columnValues,
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      transaction: tx,
      noReturn: noReturn,
    ),
  );

  @override
  Future<List<T>> upsert<T extends TableRow>(
    List<T> rows, {
    required List<Column> conflictColumns,
    List<Column>? updateColumns,
    Expression? updateWhere,
    Transaction? transaction,
    bool noReturn = false,
  }) => _scoped(
    'upsert',
    transaction,
    (tx) => _inner.upsert<T>(
      rows,
      conflictColumns: conflictColumns,
      updateColumns: updateColumns,
      updateWhere: updateWhere,
      transaction: tx,
      noReturn: noReturn,
    ),
  );

  @override
  Future<T?> upsertRow<T extends TableRow>(
    T row, {
    required List<Column> conflictColumns,
    List<Column>? updateColumns,
    Expression? updateWhere,
    Transaction? transaction,
  }) => _scoped(
    'upsertRow',
    transaction,
    (tx) => _inner.upsertRow<T>(
      row,
      conflictColumns: conflictColumns,
      updateColumns: updateColumns,
      updateWhere: updateWhere,
      transaction: tx,
    ),
  );

  @override
  Future<List<T>> delete<T extends TableRow>(
    List<T> rows, {
    Column? orderBy,
    List<Column>? orderByList,
    Transaction? transaction,
    bool noReturn = false,
  }) => _scoped(
    'delete',
    transaction,
    (tx) => _inner.delete<T>(
      rows,
      orderBy: orderBy,
      orderByList: orderByList,
      transaction: tx,
      noReturn: noReturn,
    ),
  );

  @override
  Future<T> deleteRow<T extends TableRow>(T row, {Transaction? transaction}) =>
      _scoped('deleteRow', transaction, (tx) => _inner.deleteRow<T>(row, transaction: tx));

  @override
  Future<List<T>> deleteWhere<T extends TableRow>({
    required Expression where,
    Column? orderBy,
    List<Column>? orderByList,
    Transaction? transaction,
    bool noReturn = false,
  }) => _scoped(
    'deleteWhere',
    transaction,
    (tx) => _inner.deleteWhere<T>(
      where: where,
      orderBy: orderBy,
      orderByList: orderByList,
      transaction: tx,
      noReturn: noReturn,
    ),
  );

  // ------------------------------------------------------------------ SQL próprio

  @override
  Future<DatabaseResult> unsafeQuery(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    QueryParameters? parameters,
  }) => _scoped(
    'unsafeQuery',
    transaction,
    (tx) => _inner.unsafeQuery(
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: tx,
      parameters: parameters,
    ),
  );

  @override
  Future<int> unsafeExecute(
    String query, {
    int? timeoutInSeconds,
    Transaction? transaction,
    QueryParameters? parameters,
  }) => _scoped(
    'unsafeExecute',
    transaction,
    (tx) => _inner.unsafeExecute(
      query,
      timeoutInSeconds: timeoutInSeconds,
      transaction: tx,
      parameters: parameters,
    ),
  );

  @override
  Future<DatabaseResult> unsafeSimpleQuery(String query, {int? timeoutInSeconds, Transaction? transaction}) => _scoped(
    'unsafeSimpleQuery',
    transaction,
    (tx) => _inner.unsafeSimpleQuery(query, timeoutInSeconds: timeoutInSeconds, transaction: tx),
  );

  @override
  Future<int> unsafeSimpleExecute(String query, {int? timeoutInSeconds, Transaction? transaction}) => _scoped(
    'unsafeSimpleExecute',
    transaction,
    (tx) => _inner.unsafeSimpleExecute(query, timeoutInSeconds: timeoutInSeconds, transaction: tx),
  );

  // ------------------------------------------------------------------ streams
  // watch/unsafeWatch não aceitam transação (e no PostgreSQL o Serverpod 4.1
  // ainda não os suporta). Sem como aplicar o tenant, ficam bloqueados para
  // sessões com contexto: o tempo real usa o streaming do Serverpod com avisos
  // de invalidação (docs/02 §4.2.5), nunca leitura contínua do banco.

  @override
  Stream<List<T>> watch<T extends TableRow>({
    Expression? where,
    int? limit,
    int? offset,
    Column? orderBy,
    List<Column>? orderByList,
    Include? include,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<Table>? alsoTriggerOnTables,
  }) {
    if (_contextFor('watch') != null) {
      throw UnsupportedError('watch não é permitido em sessões com tenant (sem transação para aplicar o contexto).');
    }
    return _inner.watch<T>(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      include: include,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  @override
  Stream<DatabaseResult> unsafeWatch(
    String query, {
    QueryParameters? parameters,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<String>? triggerOnTables,
  }) {
    if (_contextFor('unsafeWatch') != null) {
      throw UnsupportedError('unsafeWatch não é permitido em sessões com tenant.');
    }
    return _inner.unsafeWatch(query, parameters: parameters, throttle: throttle, triggerOnTables: triggerOnTables);
  }
}
