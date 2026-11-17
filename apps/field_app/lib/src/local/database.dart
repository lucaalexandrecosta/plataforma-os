import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

/// Visitas do recorte. [serverJson] é o estado que o servidor mandou;
/// [json] é o que a tela mostra: o do servidor com as ações ainda não
/// enviadas reaplicadas por cima (docs/06 §6.3, "local_overlays").
class LocalVisits extends Table {
  TextColumn get id => text()();
  TextColumn get workOrderId => text()();
  DateTimeColumn get scheduledStart => dateTime()();
  TextColumn get status => text()();
  TextColumn get serverJson => text()();
  TextColumn get json => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// OS das visitas do recorte (estado do servidor).
class LocalWorkOrders extends Table {
  TextColumn get id => text()();
  TextColumn get json => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Fila de ações do técnico ainda não confirmadas pelo servidor (outbox no
/// aparelho, docs/06 §6.1). Sai da fila só com applied/duplicate, ou com a
/// recusa já transformada em aviso.
class PendingMutations extends Table {
  IntColumn get seq => integer().autoIncrement()();
  TextColumn get mutationId => text().unique()();
  TextColumn get type => text()();
  TextColumn get entityId => text()();
  TextColumn get payload => text()();
  DateTimeColumn get clientTimestamp => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
}

/// Avisos para o técnico: ações recusadas, visitas canceladas ou transferidas.
class Notices extends Table {
  IntColumn get id => integer().autoIncrement()();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get visitId => text().nullable()();
  TextColumn get message => text()();
  BoolColumn get read => boolean().withDefault(const Constant(false))();
}

/// Chave e valor: id do aparelho, último sync, desvio do relógio.
class SyncState extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Banco local de uma empresa (um arquivo por empresa, docs/04 §2.2).
///
/// Nesta etapa o SQLite não é cifrado; o SQLCipher com a chave no
/// armazenamento seguro (docs/06 §6.12) entra com o login persistente.
@DriftDatabase(tables: [LocalVisits, LocalWorkOrders, PendingMutations, Notices, SyncState])
class FieldDatabase extends _$FieldDatabase {
  FieldDatabase(super.executor);

  /// Abre (ou cria) o arquivo da empresa [tenantSlug] no aparelho.
  factory FieldDatabase.forTenant(String tenantSlug) =>
      FieldDatabase(driftDatabase(name: 'tenant_${tenantSlug.replaceAll(RegExp('[^a-z0-9_-]'), '_')}'));

  @override
  int get schemaVersion => 1;
}
