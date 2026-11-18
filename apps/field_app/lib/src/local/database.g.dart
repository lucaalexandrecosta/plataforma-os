// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LocalVisitsTable extends LocalVisits with TableInfo<$LocalVisitsTable, LocalVisit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalVisitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _workOrderIdMeta = const VerificationMeta(
    'workOrderId',
  );
  @override
  late final GeneratedColumn<String> workOrderId = GeneratedColumn<String>(
    'work_order_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledStartMeta = const VerificationMeta(
    'scheduledStart',
  );
  @override
  late final GeneratedColumn<DateTime> scheduledStart = GeneratedColumn<DateTime>(
    'scheduled_start',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _serverJsonMeta = const VerificationMeta(
    'serverJson',
  );
  @override
  late final GeneratedColumn<String> serverJson = GeneratedColumn<String>(
    'server_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    workOrderId,
    scheduledStart,
    status,
    serverJson,
    json,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_visits';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalVisit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('work_order_id')) {
      context.handle(
        _workOrderIdMeta,
        workOrderId.isAcceptableOrUnknown(
          data['work_order_id']!,
          _workOrderIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_workOrderIdMeta);
    }
    if (data.containsKey('scheduled_start')) {
      context.handle(
        _scheduledStartMeta,
        scheduledStart.isAcceptableOrUnknown(
          data['scheduled_start']!,
          _scheduledStartMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledStartMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('server_json')) {
      context.handle(
        _serverJsonMeta,
        serverJson.isAcceptableOrUnknown(data['server_json']!, _serverJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_serverJsonMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalVisit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalVisit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      workOrderId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}work_order_id'],
      )!,
      scheduledStart: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}scheduled_start'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      serverJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}server_json'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
    );
  }

  @override
  $LocalVisitsTable createAlias(String alias) {
    return $LocalVisitsTable(attachedDatabase, alias);
  }
}

class LocalVisit extends DataClass implements Insertable<LocalVisit> {
  final String id;
  final String workOrderId;
  final DateTime scheduledStart;
  final String status;
  final String serverJson;
  final String json;
  const LocalVisit({
    required this.id,
    required this.workOrderId,
    required this.scheduledStart,
    required this.status,
    required this.serverJson,
    required this.json,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['work_order_id'] = Variable<String>(workOrderId);
    map['scheduled_start'] = Variable<DateTime>(scheduledStart);
    map['status'] = Variable<String>(status);
    map['server_json'] = Variable<String>(serverJson);
    map['json'] = Variable<String>(json);
    return map;
  }

  LocalVisitsCompanion toCompanion(bool nullToAbsent) {
    return LocalVisitsCompanion(
      id: Value(id),
      workOrderId: Value(workOrderId),
      scheduledStart: Value(scheduledStart),
      status: Value(status),
      serverJson: Value(serverJson),
      json: Value(json),
    );
  }

  factory LocalVisit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalVisit(
      id: serializer.fromJson<String>(json['id']),
      workOrderId: serializer.fromJson<String>(json['workOrderId']),
      scheduledStart: serializer.fromJson<DateTime>(json['scheduledStart']),
      status: serializer.fromJson<String>(json['status']),
      serverJson: serializer.fromJson<String>(json['serverJson']),
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'workOrderId': serializer.toJson<String>(workOrderId),
      'scheduledStart': serializer.toJson<DateTime>(scheduledStart),
      'status': serializer.toJson<String>(status),
      'serverJson': serializer.toJson<String>(serverJson),
      'json': serializer.toJson<String>(json),
    };
  }

  LocalVisit copyWith({
    String? id,
    String? workOrderId,
    DateTime? scheduledStart,
    String? status,
    String? serverJson,
    String? json,
  }) => LocalVisit(
    id: id ?? this.id,
    workOrderId: workOrderId ?? this.workOrderId,
    scheduledStart: scheduledStart ?? this.scheduledStart,
    status: status ?? this.status,
    serverJson: serverJson ?? this.serverJson,
    json: json ?? this.json,
  );
  LocalVisit copyWithCompanion(LocalVisitsCompanion data) {
    return LocalVisit(
      id: data.id.present ? data.id.value : this.id,
      workOrderId: data.workOrderId.present ? data.workOrderId.value : this.workOrderId,
      scheduledStart: data.scheduledStart.present ? data.scheduledStart.value : this.scheduledStart,
      status: data.status.present ? data.status.value : this.status,
      serverJson: data.serverJson.present ? data.serverJson.value : this.serverJson,
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalVisit(')
          ..write('id: $id, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('status: $status, ')
          ..write('serverJson: $serverJson, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, workOrderId, scheduledStart, status, serverJson, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalVisit &&
          other.id == this.id &&
          other.workOrderId == this.workOrderId &&
          other.scheduledStart == this.scheduledStart &&
          other.status == this.status &&
          other.serverJson == this.serverJson &&
          other.json == this.json);
}

class LocalVisitsCompanion extends UpdateCompanion<LocalVisit> {
  final Value<String> id;
  final Value<String> workOrderId;
  final Value<DateTime> scheduledStart;
  final Value<String> status;
  final Value<String> serverJson;
  final Value<String> json;
  final Value<int> rowid;
  const LocalVisitsCompanion({
    this.id = const Value.absent(),
    this.workOrderId = const Value.absent(),
    this.scheduledStart = const Value.absent(),
    this.status = const Value.absent(),
    this.serverJson = const Value.absent(),
    this.json = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalVisitsCompanion.insert({
    required String id,
    required String workOrderId,
    required DateTime scheduledStart,
    required String status,
    required String serverJson,
    required String json,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       workOrderId = Value(workOrderId),
       scheduledStart = Value(scheduledStart),
       status = Value(status),
       serverJson = Value(serverJson),
       json = Value(json);
  static Insertable<LocalVisit> custom({
    Expression<String>? id,
    Expression<String>? workOrderId,
    Expression<DateTime>? scheduledStart,
    Expression<String>? status,
    Expression<String>? serverJson,
    Expression<String>? json,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (workOrderId != null) 'work_order_id': workOrderId,
      if (scheduledStart != null) 'scheduled_start': scheduledStart,
      if (status != null) 'status': status,
      if (serverJson != null) 'server_json': serverJson,
      if (json != null) 'json': json,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalVisitsCompanion copyWith({
    Value<String>? id,
    Value<String>? workOrderId,
    Value<DateTime>? scheduledStart,
    Value<String>? status,
    Value<String>? serverJson,
    Value<String>? json,
    Value<int>? rowid,
  }) {
    return LocalVisitsCompanion(
      id: id ?? this.id,
      workOrderId: workOrderId ?? this.workOrderId,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      status: status ?? this.status,
      serverJson: serverJson ?? this.serverJson,
      json: json ?? this.json,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (workOrderId.present) {
      map['work_order_id'] = Variable<String>(workOrderId.value);
    }
    if (scheduledStart.present) {
      map['scheduled_start'] = Variable<DateTime>(scheduledStart.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (serverJson.present) {
      map['server_json'] = Variable<String>(serverJson.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalVisitsCompanion(')
          ..write('id: $id, ')
          ..write('workOrderId: $workOrderId, ')
          ..write('scheduledStart: $scheduledStart, ')
          ..write('status: $status, ')
          ..write('serverJson: $serverJson, ')
          ..write('json: $json, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalWorkOrdersTable extends LocalWorkOrders with TableInfo<$LocalWorkOrdersTable, LocalWorkOrder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalWorkOrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, json];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_work_orders';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalWorkOrder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalWorkOrder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalWorkOrder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
    );
  }

  @override
  $LocalWorkOrdersTable createAlias(String alias) {
    return $LocalWorkOrdersTable(attachedDatabase, alias);
  }
}

class LocalWorkOrder extends DataClass implements Insertable<LocalWorkOrder> {
  final String id;
  final String json;
  const LocalWorkOrder({required this.id, required this.json});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['json'] = Variable<String>(json);
    return map;
  }

  LocalWorkOrdersCompanion toCompanion(bool nullToAbsent) {
    return LocalWorkOrdersCompanion(id: Value(id), json: Value(json));
  }

  factory LocalWorkOrder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalWorkOrder(
      id: serializer.fromJson<String>(json['id']),
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'json': serializer.toJson<String>(json),
    };
  }

  LocalWorkOrder copyWith({String? id, String? json}) => LocalWorkOrder(id: id ?? this.id, json: json ?? this.json);
  LocalWorkOrder copyWithCompanion(LocalWorkOrdersCompanion data) {
    return LocalWorkOrder(
      id: data.id.present ? data.id.value : this.id,
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalWorkOrder(')
          ..write('id: $id, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is LocalWorkOrder && other.id == this.id && other.json == this.json);
}

class LocalWorkOrdersCompanion extends UpdateCompanion<LocalWorkOrder> {
  final Value<String> id;
  final Value<String> json;
  final Value<int> rowid;
  const LocalWorkOrdersCompanion({
    this.id = const Value.absent(),
    this.json = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalWorkOrdersCompanion.insert({
    required String id,
    required String json,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       json = Value(json);
  static Insertable<LocalWorkOrder> custom({
    Expression<String>? id,
    Expression<String>? json,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (json != null) 'json': json,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalWorkOrdersCompanion copyWith({
    Value<String>? id,
    Value<String>? json,
    Value<int>? rowid,
  }) {
    return LocalWorkOrdersCompanion(
      id: id ?? this.id,
      json: json ?? this.json,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalWorkOrdersCompanion(')
          ..write('id: $id, ')
          ..write('json: $json, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PendingMutationsTable extends PendingMutations with TableInfo<$PendingMutationsTable, PendingMutation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PendingMutationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _seqMeta = const VerificationMeta('seq');
  @override
  late final GeneratedColumn<int> seq = GeneratedColumn<int>(
    'seq',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _mutationIdMeta = const VerificationMeta(
    'mutationId',
  );
  @override
  late final GeneratedColumn<String> mutationId = GeneratedColumn<String>(
    'mutation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _clientTimestampMeta = const VerificationMeta(
    'clientTimestamp',
  );
  @override
  late final GeneratedColumn<DateTime> clientTimestamp = GeneratedColumn<DateTime>(
    'client_timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _attemptsMeta = const VerificationMeta(
    'attempts',
  );
  @override
  late final GeneratedColumn<int> attempts = GeneratedColumn<int>(
    'attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    seq,
    mutationId,
    type,
    entityId,
    payload,
    clientTimestamp,
    attempts,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pending_mutations';
  @override
  VerificationContext validateIntegrity(
    Insertable<PendingMutation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('seq')) {
      context.handle(
        _seqMeta,
        seq.isAcceptableOrUnknown(data['seq']!, _seqMeta),
      );
    }
    if (data.containsKey('mutation_id')) {
      context.handle(
        _mutationIdMeta,
        mutationId.isAcceptableOrUnknown(data['mutation_id']!, _mutationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_mutationIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    } else if (isInserting) {
      context.missing(_payloadMeta);
    }
    if (data.containsKey('client_timestamp')) {
      context.handle(
        _clientTimestampMeta,
        clientTimestamp.isAcceptableOrUnknown(
          data['client_timestamp']!,
          _clientTimestampMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_clientTimestampMeta);
    }
    if (data.containsKey('attempts')) {
      context.handle(
        _attemptsMeta,
        attempts.isAcceptableOrUnknown(data['attempts']!, _attemptsMeta),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {seq};
  @override
  PendingMutation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PendingMutation(
      seq: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}seq'],
      )!,
      mutationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mutation_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      )!,
      clientTimestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_timestamp'],
      )!,
      attempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $PendingMutationsTable createAlias(String alias) {
    return $PendingMutationsTable(attachedDatabase, alias);
  }
}

class PendingMutation extends DataClass implements Insertable<PendingMutation> {
  final int seq;
  final String mutationId;
  final String type;
  final String entityId;
  final String payload;
  final DateTime clientTimestamp;
  final int attempts;
  final String? lastError;
  const PendingMutation({
    required this.seq,
    required this.mutationId,
    required this.type,
    required this.entityId,
    required this.payload,
    required this.clientTimestamp,
    required this.attempts,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['seq'] = Variable<int>(seq);
    map['mutation_id'] = Variable<String>(mutationId);
    map['type'] = Variable<String>(type);
    map['entity_id'] = Variable<String>(entityId);
    map['payload'] = Variable<String>(payload);
    map['client_timestamp'] = Variable<DateTime>(clientTimestamp);
    map['attempts'] = Variable<int>(attempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  PendingMutationsCompanion toCompanion(bool nullToAbsent) {
    return PendingMutationsCompanion(
      seq: Value(seq),
      mutationId: Value(mutationId),
      type: Value(type),
      entityId: Value(entityId),
      payload: Value(payload),
      clientTimestamp: Value(clientTimestamp),
      attempts: Value(attempts),
      lastError: lastError == null && nullToAbsent ? const Value.absent() : Value(lastError),
    );
  }

  factory PendingMutation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PendingMutation(
      seq: serializer.fromJson<int>(json['seq']),
      mutationId: serializer.fromJson<String>(json['mutationId']),
      type: serializer.fromJson<String>(json['type']),
      entityId: serializer.fromJson<String>(json['entityId']),
      payload: serializer.fromJson<String>(json['payload']),
      clientTimestamp: serializer.fromJson<DateTime>(json['clientTimestamp']),
      attempts: serializer.fromJson<int>(json['attempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'seq': serializer.toJson<int>(seq),
      'mutationId': serializer.toJson<String>(mutationId),
      'type': serializer.toJson<String>(type),
      'entityId': serializer.toJson<String>(entityId),
      'payload': serializer.toJson<String>(payload),
      'clientTimestamp': serializer.toJson<DateTime>(clientTimestamp),
      'attempts': serializer.toJson<int>(attempts),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  PendingMutation copyWith({
    int? seq,
    String? mutationId,
    String? type,
    String? entityId,
    String? payload,
    DateTime? clientTimestamp,
    int? attempts,
    Value<String?> lastError = const Value.absent(),
  }) => PendingMutation(
    seq: seq ?? this.seq,
    mutationId: mutationId ?? this.mutationId,
    type: type ?? this.type,
    entityId: entityId ?? this.entityId,
    payload: payload ?? this.payload,
    clientTimestamp: clientTimestamp ?? this.clientTimestamp,
    attempts: attempts ?? this.attempts,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  PendingMutation copyWithCompanion(PendingMutationsCompanion data) {
    return PendingMutation(
      seq: data.seq.present ? data.seq.value : this.seq,
      mutationId: data.mutationId.present ? data.mutationId.value : this.mutationId,
      type: data.type.present ? data.type.value : this.type,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payload: data.payload.present ? data.payload.value : this.payload,
      clientTimestamp: data.clientTimestamp.present ? data.clientTimestamp.value : this.clientTimestamp,
      attempts: data.attempts.present ? data.attempts.value : this.attempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PendingMutation(')
          ..write('seq: $seq, ')
          ..write('mutationId: $mutationId, ')
          ..write('type: $type, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('clientTimestamp: $clientTimestamp, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    seq,
    mutationId,
    type,
    entityId,
    payload,
    clientTimestamp,
    attempts,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PendingMutation &&
          other.seq == this.seq &&
          other.mutationId == this.mutationId &&
          other.type == this.type &&
          other.entityId == this.entityId &&
          other.payload == this.payload &&
          other.clientTimestamp == this.clientTimestamp &&
          other.attempts == this.attempts &&
          other.lastError == this.lastError);
}

class PendingMutationsCompanion extends UpdateCompanion<PendingMutation> {
  final Value<int> seq;
  final Value<String> mutationId;
  final Value<String> type;
  final Value<String> entityId;
  final Value<String> payload;
  final Value<DateTime> clientTimestamp;
  final Value<int> attempts;
  final Value<String?> lastError;
  const PendingMutationsCompanion({
    this.seq = const Value.absent(),
    this.mutationId = const Value.absent(),
    this.type = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payload = const Value.absent(),
    this.clientTimestamp = const Value.absent(),
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
  });
  PendingMutationsCompanion.insert({
    this.seq = const Value.absent(),
    required String mutationId,
    required String type,
    required String entityId,
    required String payload,
    required DateTime clientTimestamp,
    this.attempts = const Value.absent(),
    this.lastError = const Value.absent(),
  }) : mutationId = Value(mutationId),
       type = Value(type),
       entityId = Value(entityId),
       payload = Value(payload),
       clientTimestamp = Value(clientTimestamp);
  static Insertable<PendingMutation> custom({
    Expression<int>? seq,
    Expression<String>? mutationId,
    Expression<String>? type,
    Expression<String>? entityId,
    Expression<String>? payload,
    Expression<DateTime>? clientTimestamp,
    Expression<int>? attempts,
    Expression<String>? lastError,
  }) {
    return RawValuesInsertable({
      if (seq != null) 'seq': seq,
      if (mutationId != null) 'mutation_id': mutationId,
      if (type != null) 'type': type,
      if (entityId != null) 'entity_id': entityId,
      if (payload != null) 'payload': payload,
      if (clientTimestamp != null) 'client_timestamp': clientTimestamp,
      if (attempts != null) 'attempts': attempts,
      if (lastError != null) 'last_error': lastError,
    });
  }

  PendingMutationsCompanion copyWith({
    Value<int>? seq,
    Value<String>? mutationId,
    Value<String>? type,
    Value<String>? entityId,
    Value<String>? payload,
    Value<DateTime>? clientTimestamp,
    Value<int>? attempts,
    Value<String?>? lastError,
  }) {
    return PendingMutationsCompanion(
      seq: seq ?? this.seq,
      mutationId: mutationId ?? this.mutationId,
      type: type ?? this.type,
      entityId: entityId ?? this.entityId,
      payload: payload ?? this.payload,
      clientTimestamp: clientTimestamp ?? this.clientTimestamp,
      attempts: attempts ?? this.attempts,
      lastError: lastError ?? this.lastError,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (seq.present) {
      map['seq'] = Variable<int>(seq.value);
    }
    if (mutationId.present) {
      map['mutation_id'] = Variable<String>(mutationId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (clientTimestamp.present) {
      map['client_timestamp'] = Variable<DateTime>(clientTimestamp.value);
    }
    if (attempts.present) {
      map['attempts'] = Variable<int>(attempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PendingMutationsCompanion(')
          ..write('seq: $seq, ')
          ..write('mutationId: $mutationId, ')
          ..write('type: $type, ')
          ..write('entityId: $entityId, ')
          ..write('payload: $payload, ')
          ..write('clientTimestamp: $clientTimestamp, ')
          ..write('attempts: $attempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }
}

class $NoticesTable extends Notices with TableInfo<$NoticesTable, Notice> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NoticesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<String> visitId = GeneratedColumn<String>(
    'visit_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _messageMeta = const VerificationMeta(
    'message',
  );
  @override
  late final GeneratedColumn<String> message = GeneratedColumn<String>(
    'message',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readMeta = const VerificationMeta('read');
  @override
  late final GeneratedColumn<bool> read = GeneratedColumn<bool>(
    'read',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("read" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, createdAt, visitId, message, read];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notices';
  @override
  VerificationContext validateIntegrity(
    Insertable<Notice> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    }
    if (data.containsKey('message')) {
      context.handle(
        _messageMeta,
        message.isAcceptableOrUnknown(data['message']!, _messageMeta),
      );
    } else if (isInserting) {
      context.missing(_messageMeta);
    }
    if (data.containsKey('read')) {
      context.handle(
        _readMeta,
        read.isAcceptableOrUnknown(data['read']!, _readMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Notice map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Notice(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_id'],
      ),
      message: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message'],
      )!,
      read: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}read'],
      )!,
    );
  }

  @override
  $NoticesTable createAlias(String alias) {
    return $NoticesTable(attachedDatabase, alias);
  }
}

class Notice extends DataClass implements Insertable<Notice> {
  final int id;
  final DateTime createdAt;
  final String? visitId;
  final String message;
  final bool read;
  const Notice({
    required this.id,
    required this.createdAt,
    this.visitId,
    required this.message,
    required this.read,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || visitId != null) {
      map['visit_id'] = Variable<String>(visitId);
    }
    map['message'] = Variable<String>(message);
    map['read'] = Variable<bool>(read);
    return map;
  }

  NoticesCompanion toCompanion(bool nullToAbsent) {
    return NoticesCompanion(
      id: Value(id),
      createdAt: Value(createdAt),
      visitId: visitId == null && nullToAbsent ? const Value.absent() : Value(visitId),
      message: Value(message),
      read: Value(read),
    );
  }

  factory Notice.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Notice(
      id: serializer.fromJson<int>(json['id']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      visitId: serializer.fromJson<String?>(json['visitId']),
      message: serializer.fromJson<String>(json['message']),
      read: serializer.fromJson<bool>(json['read']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'visitId': serializer.toJson<String?>(visitId),
      'message': serializer.toJson<String>(message),
      'read': serializer.toJson<bool>(read),
    };
  }

  Notice copyWith({
    int? id,
    DateTime? createdAt,
    Value<String?> visitId = const Value.absent(),
    String? message,
    bool? read,
  }) => Notice(
    id: id ?? this.id,
    createdAt: createdAt ?? this.createdAt,
    visitId: visitId.present ? visitId.value : this.visitId,
    message: message ?? this.message,
    read: read ?? this.read,
  );
  Notice copyWithCompanion(NoticesCompanion data) {
    return Notice(
      id: data.id.present ? data.id.value : this.id,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      message: data.message.present ? data.message.value : this.message,
      read: data.read.present ? data.read.value : this.read,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Notice(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('visitId: $visitId, ')
          ..write('message: $message, ')
          ..write('read: $read')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, createdAt, visitId, message, read);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Notice &&
          other.id == this.id &&
          other.createdAt == this.createdAt &&
          other.visitId == this.visitId &&
          other.message == this.message &&
          other.read == this.read);
}

class NoticesCompanion extends UpdateCompanion<Notice> {
  final Value<int> id;
  final Value<DateTime> createdAt;
  final Value<String?> visitId;
  final Value<String> message;
  final Value<bool> read;
  const NoticesCompanion({
    this.id = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.visitId = const Value.absent(),
    this.message = const Value.absent(),
    this.read = const Value.absent(),
  });
  NoticesCompanion.insert({
    this.id = const Value.absent(),
    required DateTime createdAt,
    this.visitId = const Value.absent(),
    required String message,
    this.read = const Value.absent(),
  }) : createdAt = Value(createdAt),
       message = Value(message);
  static Insertable<Notice> custom({
    Expression<int>? id,
    Expression<DateTime>? createdAt,
    Expression<String>? visitId,
    Expression<String>? message,
    Expression<bool>? read,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (createdAt != null) 'created_at': createdAt,
      if (visitId != null) 'visit_id': visitId,
      if (message != null) 'message': message,
      if (read != null) 'read': read,
    });
  }

  NoticesCompanion copyWith({
    Value<int>? id,
    Value<DateTime>? createdAt,
    Value<String?>? visitId,
    Value<String>? message,
    Value<bool>? read,
  }) {
    return NoticesCompanion(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      visitId: visitId ?? this.visitId,
      message: message ?? this.message,
      read: read ?? this.read,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<String>(visitId.value);
    }
    if (message.present) {
      map['message'] = Variable<String>(message.value);
    }
    if (read.present) {
      map['read'] = Variable<bool>(read.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NoticesCompanion(')
          ..write('id: $id, ')
          ..write('createdAt: $createdAt, ')
          ..write('visitId: $visitId, ')
          ..write('message: $message, ')
          ..write('read: $read')
          ..write(')'))
        .toString();
  }
}

class $SyncStateTable extends SyncState with TableInfo<$SyncStateTable, SyncStateData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStateTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_state';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncStateData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SyncStateData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncStateData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $SyncStateTable createAlias(String alias) {
    return $SyncStateTable(attachedDatabase, alias);
  }
}

class SyncStateData extends DataClass implements Insertable<SyncStateData> {
  final String key;
  final String value;
  const SyncStateData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  SyncStateCompanion toCompanion(bool nullToAbsent) {
    return SyncStateCompanion(key: Value(key), value: Value(value));
  }

  factory SyncStateData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncStateData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SyncStateData copyWith({String? key, String? value}) =>
      SyncStateData(key: key ?? this.key, value: value ?? this.value);
  SyncStateData copyWithCompanion(SyncStateCompanion data) {
    return SyncStateData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SyncStateData && other.key == this.key && other.value == this.value);
}

class SyncStateCompanion extends UpdateCompanion<SyncStateData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const SyncStateCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStateCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SyncStateData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStateCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return SyncStateCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStateCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalChecklistsTable extends LocalChecklists with TableInfo<$LocalChecklistsTable, LocalChecklist> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalChecklistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<String> visitId = GeneratedColumn<String>(
    'visit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _jsonMeta = const VerificationMeta('json');
  @override
  late final GeneratedColumn<String> json = GeneratedColumn<String>(
    'json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [visitId, json];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_checklists';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalChecklist> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitIdMeta);
    }
    if (data.containsKey('json')) {
      context.handle(
        _jsonMeta,
        json.isAcceptableOrUnknown(data['json']!, _jsonMeta),
      );
    } else if (isInserting) {
      context.missing(_jsonMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {visitId};
  @override
  LocalChecklist map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalChecklist(
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_id'],
      )!,
      json: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}json'],
      )!,
    );
  }

  @override
  $LocalChecklistsTable createAlias(String alias) {
    return $LocalChecklistsTable(attachedDatabase, alias);
  }
}

class LocalChecklist extends DataClass implements Insertable<LocalChecklist> {
  final String visitId;
  final String json;
  const LocalChecklist({required this.visitId, required this.json});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['visit_id'] = Variable<String>(visitId);
    map['json'] = Variable<String>(json);
    return map;
  }

  LocalChecklistsCompanion toCompanion(bool nullToAbsent) {
    return LocalChecklistsCompanion(visitId: Value(visitId), json: Value(json));
  }

  factory LocalChecklist.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalChecklist(
      visitId: serializer.fromJson<String>(json['visitId']),
      json: serializer.fromJson<String>(json['json']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'visitId': serializer.toJson<String>(visitId),
      'json': serializer.toJson<String>(json),
    };
  }

  LocalChecklist copyWith({String? visitId, String? json}) =>
      LocalChecklist(visitId: visitId ?? this.visitId, json: json ?? this.json);
  LocalChecklist copyWithCompanion(LocalChecklistsCompanion data) {
    return LocalChecklist(
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      json: data.json.present ? data.json.value : this.json,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalChecklist(')
          ..write('visitId: $visitId, ')
          ..write('json: $json')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(visitId, json);
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is LocalChecklist && other.visitId == this.visitId && other.json == this.json);
}

class LocalChecklistsCompanion extends UpdateCompanion<LocalChecklist> {
  final Value<String> visitId;
  final Value<String> json;
  final Value<int> rowid;
  const LocalChecklistsCompanion({
    this.visitId = const Value.absent(),
    this.json = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalChecklistsCompanion.insert({
    required String visitId,
    required String json,
    this.rowid = const Value.absent(),
  }) : visitId = Value(visitId),
       json = Value(json);
  static Insertable<LocalChecklist> custom({
    Expression<String>? visitId,
    Expression<String>? json,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (visitId != null) 'visit_id': visitId,
      if (json != null) 'json': json,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalChecklistsCompanion copyWith({
    Value<String>? visitId,
    Value<String>? json,
    Value<int>? rowid,
  }) {
    return LocalChecklistsCompanion(
      visitId: visitId ?? this.visitId,
      json: json ?? this.json,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (visitId.present) {
      map['visit_id'] = Variable<String>(visitId.value);
    }
    if (json.present) {
      map['json'] = Variable<String>(json.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalChecklistsCompanion(')
          ..write('visitId: $visitId, ')
          ..write('json: $json, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ChecklistDraftsTable extends ChecklistDrafts with TableInfo<$ChecklistDraftsTable, ChecklistDraft> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ChecklistDraftsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<String> visitId = GeneratedColumn<String>(
    'visit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _answersMeta = const VerificationMeta(
    'answers',
  );
  @override
  late final GeneratedColumn<String> answers = GeneratedColumn<String>(
    'answers',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _submittedMeta = const VerificationMeta(
    'submitted',
  );
  @override
  late final GeneratedColumn<bool> submitted = GeneratedColumn<bool>(
    'submitted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("submitted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    visitId,
    templateId,
    answers,
    submitted,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'checklist_drafts';
  @override
  VerificationContext validateIntegrity(
    Insertable<ChecklistDraft> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitIdMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('answers')) {
      context.handle(
        _answersMeta,
        answers.isAcceptableOrUnknown(data['answers']!, _answersMeta),
      );
    } else if (isInserting) {
      context.missing(_answersMeta);
    }
    if (data.containsKey('submitted')) {
      context.handle(
        _submittedMeta,
        submitted.isAcceptableOrUnknown(data['submitted']!, _submittedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {visitId};
  @override
  ChecklistDraft map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ChecklistDraft(
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      answers: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}answers'],
      )!,
      submitted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}submitted'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ChecklistDraftsTable createAlias(String alias) {
    return $ChecklistDraftsTable(attachedDatabase, alias);
  }
}

class ChecklistDraft extends DataClass implements Insertable<ChecklistDraft> {
  final String visitId;
  final String templateId;
  final String answers;
  final bool submitted;
  final DateTime updatedAt;
  const ChecklistDraft({
    required this.visitId,
    required this.templateId,
    required this.answers,
    required this.submitted,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['visit_id'] = Variable<String>(visitId);
    map['template_id'] = Variable<String>(templateId);
    map['answers'] = Variable<String>(answers);
    map['submitted'] = Variable<bool>(submitted);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ChecklistDraftsCompanion toCompanion(bool nullToAbsent) {
    return ChecklistDraftsCompanion(
      visitId: Value(visitId),
      templateId: Value(templateId),
      answers: Value(answers),
      submitted: Value(submitted),
      updatedAt: Value(updatedAt),
    );
  }

  factory ChecklistDraft.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ChecklistDraft(
      visitId: serializer.fromJson<String>(json['visitId']),
      templateId: serializer.fromJson<String>(json['templateId']),
      answers: serializer.fromJson<String>(json['answers']),
      submitted: serializer.fromJson<bool>(json['submitted']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'visitId': serializer.toJson<String>(visitId),
      'templateId': serializer.toJson<String>(templateId),
      'answers': serializer.toJson<String>(answers),
      'submitted': serializer.toJson<bool>(submitted),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ChecklistDraft copyWith({
    String? visitId,
    String? templateId,
    String? answers,
    bool? submitted,
    DateTime? updatedAt,
  }) => ChecklistDraft(
    visitId: visitId ?? this.visitId,
    templateId: templateId ?? this.templateId,
    answers: answers ?? this.answers,
    submitted: submitted ?? this.submitted,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ChecklistDraft copyWithCompanion(ChecklistDraftsCompanion data) {
    return ChecklistDraft(
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      templateId: data.templateId.present ? data.templateId.value : this.templateId,
      answers: data.answers.present ? data.answers.value : this.answers,
      submitted: data.submitted.present ? data.submitted.value : this.submitted,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistDraft(')
          ..write('visitId: $visitId, ')
          ..write('templateId: $templateId, ')
          ..write('answers: $answers, ')
          ..write('submitted: $submitted, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(visitId, templateId, answers, submitted, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ChecklistDraft &&
          other.visitId == this.visitId &&
          other.templateId == this.templateId &&
          other.answers == this.answers &&
          other.submitted == this.submitted &&
          other.updatedAt == this.updatedAt);
}

class ChecklistDraftsCompanion extends UpdateCompanion<ChecklistDraft> {
  final Value<String> visitId;
  final Value<String> templateId;
  final Value<String> answers;
  final Value<bool> submitted;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ChecklistDraftsCompanion({
    this.visitId = const Value.absent(),
    this.templateId = const Value.absent(),
    this.answers = const Value.absent(),
    this.submitted = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ChecklistDraftsCompanion.insert({
    required String visitId,
    required String templateId,
    required String answers,
    this.submitted = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : visitId = Value(visitId),
       templateId = Value(templateId),
       answers = Value(answers),
       updatedAt = Value(updatedAt);
  static Insertable<ChecklistDraft> custom({
    Expression<String>? visitId,
    Expression<String>? templateId,
    Expression<String>? answers,
    Expression<bool>? submitted,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (visitId != null) 'visit_id': visitId,
      if (templateId != null) 'template_id': templateId,
      if (answers != null) 'answers': answers,
      if (submitted != null) 'submitted': submitted,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ChecklistDraftsCompanion copyWith({
    Value<String>? visitId,
    Value<String>? templateId,
    Value<String>? answers,
    Value<bool>? submitted,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ChecklistDraftsCompanion(
      visitId: visitId ?? this.visitId,
      templateId: templateId ?? this.templateId,
      answers: answers ?? this.answers,
      submitted: submitted ?? this.submitted,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (visitId.present) {
      map['visit_id'] = Variable<String>(visitId.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (answers.present) {
      map['answers'] = Variable<String>(answers.value);
    }
    if (submitted.present) {
      map['submitted'] = Variable<bool>(submitted.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ChecklistDraftsCompanion(')
          ..write('visitId: $visitId, ')
          ..write('templateId: $templateId, ')
          ..write('answers: $answers, ')
          ..write('submitted: $submitted, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $LocalAttachmentsTable extends LocalAttachments with TableInfo<$LocalAttachmentsTable, LocalAttachment> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocalAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _visitIdMeta = const VerificationMeta(
    'visitId',
  );
  @override
  late final GeneratedColumn<String> visitId = GeneratedColumn<String>(
    'visit_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _kindMeta = const VerificationMeta('kind');
  @override
  late final GeneratedColumn<String> kind = GeneratedColumn<String>(
    'kind',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _photoStageMeta = const VerificationMeta(
    'photoStage',
  );
  @override
  late final GeneratedColumn<String> photoStage = GeneratedColumn<String>(
    'photo_stage',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bytesMeta = const VerificationMeta('bytes');
  @override
  late final GeneratedColumn<Uint8List> bytes = GeneratedColumn<Uint8List>(
    'bytes',
    aliasedName,
    false,
    type: DriftSqlType.blob,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _uploadAttemptsMeta = const VerificationMeta(
    'uploadAttempts',
  );
  @override
  late final GeneratedColumn<int> uploadAttempts = GeneratedColumn<int>(
    'upload_attempts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastErrorMeta = const VerificationMeta(
    'lastError',
  );
  @override
  late final GeneratedColumn<String> lastError = GeneratedColumn<String>(
    'last_error',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    visitId,
    kind,
    photoStage,
    contentType,
    bytes,
    capturedAt,
    status,
    uploadAttempts,
    lastError,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'local_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocalAttachment> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('visit_id')) {
      context.handle(
        _visitIdMeta,
        visitId.isAcceptableOrUnknown(data['visit_id']!, _visitIdMeta),
      );
    } else if (isInserting) {
      context.missing(_visitIdMeta);
    }
    if (data.containsKey('kind')) {
      context.handle(
        _kindMeta,
        kind.isAcceptableOrUnknown(data['kind']!, _kindMeta),
      );
    } else if (isInserting) {
      context.missing(_kindMeta);
    }
    if (data.containsKey('photo_stage')) {
      context.handle(
        _photoStageMeta,
        photoStage.isAcceptableOrUnknown(data['photo_stage']!, _photoStageMeta),
      );
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_contentTypeMeta);
    }
    if (data.containsKey('bytes')) {
      context.handle(
        _bytesMeta,
        bytes.isAcceptableOrUnknown(data['bytes']!, _bytesMeta),
      );
    } else if (isInserting) {
      context.missing(_bytesMeta);
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('upload_attempts')) {
      context.handle(
        _uploadAttemptsMeta,
        uploadAttempts.isAcceptableOrUnknown(
          data['upload_attempts']!,
          _uploadAttemptsMeta,
        ),
      );
    }
    if (data.containsKey('last_error')) {
      context.handle(
        _lastErrorMeta,
        lastError.isAcceptableOrUnknown(data['last_error']!, _lastErrorMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocalAttachment map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocalAttachment(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      visitId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}visit_id'],
      )!,
      kind: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}kind'],
      )!,
      photoStage: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_stage'],
      ),
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      bytes: attachedDatabase.typeMapping.read(
        DriftSqlType.blob,
        data['${effectivePrefix}bytes'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      uploadAttempts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}upload_attempts'],
      )!,
      lastError: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}last_error'],
      ),
    );
  }

  @override
  $LocalAttachmentsTable createAlias(String alias) {
    return $LocalAttachmentsTable(attachedDatabase, alias);
  }
}

class LocalAttachment extends DataClass implements Insertable<LocalAttachment> {
  final String id;
  final String visitId;
  final String kind;
  final String? photoStage;
  final String contentType;
  final Uint8List bytes;
  final DateTime capturedAt;
  final String status;
  final int uploadAttempts;
  final String? lastError;
  const LocalAttachment({
    required this.id,
    required this.visitId,
    required this.kind,
    this.photoStage,
    required this.contentType,
    required this.bytes,
    required this.capturedAt,
    required this.status,
    required this.uploadAttempts,
    this.lastError,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['visit_id'] = Variable<String>(visitId);
    map['kind'] = Variable<String>(kind);
    if (!nullToAbsent || photoStage != null) {
      map['photo_stage'] = Variable<String>(photoStage);
    }
    map['content_type'] = Variable<String>(contentType);
    map['bytes'] = Variable<Uint8List>(bytes);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    map['status'] = Variable<String>(status);
    map['upload_attempts'] = Variable<int>(uploadAttempts);
    if (!nullToAbsent || lastError != null) {
      map['last_error'] = Variable<String>(lastError);
    }
    return map;
  }

  LocalAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return LocalAttachmentsCompanion(
      id: Value(id),
      visitId: Value(visitId),
      kind: Value(kind),
      photoStage: photoStage == null && nullToAbsent ? const Value.absent() : Value(photoStage),
      contentType: Value(contentType),
      bytes: Value(bytes),
      capturedAt: Value(capturedAt),
      status: Value(status),
      uploadAttempts: Value(uploadAttempts),
      lastError: lastError == null && nullToAbsent ? const Value.absent() : Value(lastError),
    );
  }

  factory LocalAttachment.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocalAttachment(
      id: serializer.fromJson<String>(json['id']),
      visitId: serializer.fromJson<String>(json['visitId']),
      kind: serializer.fromJson<String>(json['kind']),
      photoStage: serializer.fromJson<String?>(json['photoStage']),
      contentType: serializer.fromJson<String>(json['contentType']),
      bytes: serializer.fromJson<Uint8List>(json['bytes']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      status: serializer.fromJson<String>(json['status']),
      uploadAttempts: serializer.fromJson<int>(json['uploadAttempts']),
      lastError: serializer.fromJson<String?>(json['lastError']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'visitId': serializer.toJson<String>(visitId),
      'kind': serializer.toJson<String>(kind),
      'photoStage': serializer.toJson<String?>(photoStage),
      'contentType': serializer.toJson<String>(contentType),
      'bytes': serializer.toJson<Uint8List>(bytes),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'status': serializer.toJson<String>(status),
      'uploadAttempts': serializer.toJson<int>(uploadAttempts),
      'lastError': serializer.toJson<String?>(lastError),
    };
  }

  LocalAttachment copyWith({
    String? id,
    String? visitId,
    String? kind,
    Value<String?> photoStage = const Value.absent(),
    String? contentType,
    Uint8List? bytes,
    DateTime? capturedAt,
    String? status,
    int? uploadAttempts,
    Value<String?> lastError = const Value.absent(),
  }) => LocalAttachment(
    id: id ?? this.id,
    visitId: visitId ?? this.visitId,
    kind: kind ?? this.kind,
    photoStage: photoStage.present ? photoStage.value : this.photoStage,
    contentType: contentType ?? this.contentType,
    bytes: bytes ?? this.bytes,
    capturedAt: capturedAt ?? this.capturedAt,
    status: status ?? this.status,
    uploadAttempts: uploadAttempts ?? this.uploadAttempts,
    lastError: lastError.present ? lastError.value : this.lastError,
  );
  LocalAttachment copyWithCompanion(LocalAttachmentsCompanion data) {
    return LocalAttachment(
      id: data.id.present ? data.id.value : this.id,
      visitId: data.visitId.present ? data.visitId.value : this.visitId,
      kind: data.kind.present ? data.kind.value : this.kind,
      photoStage: data.photoStage.present ? data.photoStage.value : this.photoStage,
      contentType: data.contentType.present ? data.contentType.value : this.contentType,
      bytes: data.bytes.present ? data.bytes.value : this.bytes,
      capturedAt: data.capturedAt.present ? data.capturedAt.value : this.capturedAt,
      status: data.status.present ? data.status.value : this.status,
      uploadAttempts: data.uploadAttempts.present ? data.uploadAttempts.value : this.uploadAttempts,
      lastError: data.lastError.present ? data.lastError.value : this.lastError,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocalAttachment(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('kind: $kind, ')
          ..write('photoStage: $photoStage, ')
          ..write('contentType: $contentType, ')
          ..write('bytes: $bytes, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('status: $status, ')
          ..write('uploadAttempts: $uploadAttempts, ')
          ..write('lastError: $lastError')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    visitId,
    kind,
    photoStage,
    contentType,
    $driftBlobEquality.hash(bytes),
    capturedAt,
    status,
    uploadAttempts,
    lastError,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocalAttachment &&
          other.id == this.id &&
          other.visitId == this.visitId &&
          other.kind == this.kind &&
          other.photoStage == this.photoStage &&
          other.contentType == this.contentType &&
          $driftBlobEquality.equals(other.bytes, this.bytes) &&
          other.capturedAt == this.capturedAt &&
          other.status == this.status &&
          other.uploadAttempts == this.uploadAttempts &&
          other.lastError == this.lastError);
}

class LocalAttachmentsCompanion extends UpdateCompanion<LocalAttachment> {
  final Value<String> id;
  final Value<String> visitId;
  final Value<String> kind;
  final Value<String?> photoStage;
  final Value<String> contentType;
  final Value<Uint8List> bytes;
  final Value<DateTime> capturedAt;
  final Value<String> status;
  final Value<int> uploadAttempts;
  final Value<String?> lastError;
  final Value<int> rowid;
  const LocalAttachmentsCompanion({
    this.id = const Value.absent(),
    this.visitId = const Value.absent(),
    this.kind = const Value.absent(),
    this.photoStage = const Value.absent(),
    this.contentType = const Value.absent(),
    this.bytes = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.status = const Value.absent(),
    this.uploadAttempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  LocalAttachmentsCompanion.insert({
    required String id,
    required String visitId,
    required String kind,
    this.photoStage = const Value.absent(),
    required String contentType,
    required Uint8List bytes,
    required DateTime capturedAt,
    required String status,
    this.uploadAttempts = const Value.absent(),
    this.lastError = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       visitId = Value(visitId),
       kind = Value(kind),
       contentType = Value(contentType),
       bytes = Value(bytes),
       capturedAt = Value(capturedAt),
       status = Value(status);
  static Insertable<LocalAttachment> custom({
    Expression<String>? id,
    Expression<String>? visitId,
    Expression<String>? kind,
    Expression<String>? photoStage,
    Expression<String>? contentType,
    Expression<Uint8List>? bytes,
    Expression<DateTime>? capturedAt,
    Expression<String>? status,
    Expression<int>? uploadAttempts,
    Expression<String>? lastError,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (visitId != null) 'visit_id': visitId,
      if (kind != null) 'kind': kind,
      if (photoStage != null) 'photo_stage': photoStage,
      if (contentType != null) 'content_type': contentType,
      if (bytes != null) 'bytes': bytes,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (status != null) 'status': status,
      if (uploadAttempts != null) 'upload_attempts': uploadAttempts,
      if (lastError != null) 'last_error': lastError,
      if (rowid != null) 'rowid': rowid,
    });
  }

  LocalAttachmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? visitId,
    Value<String>? kind,
    Value<String?>? photoStage,
    Value<String>? contentType,
    Value<Uint8List>? bytes,
    Value<DateTime>? capturedAt,
    Value<String>? status,
    Value<int>? uploadAttempts,
    Value<String?>? lastError,
    Value<int>? rowid,
  }) {
    return LocalAttachmentsCompanion(
      id: id ?? this.id,
      visitId: visitId ?? this.visitId,
      kind: kind ?? this.kind,
      photoStage: photoStage ?? this.photoStage,
      contentType: contentType ?? this.contentType,
      bytes: bytes ?? this.bytes,
      capturedAt: capturedAt ?? this.capturedAt,
      status: status ?? this.status,
      uploadAttempts: uploadAttempts ?? this.uploadAttempts,
      lastError: lastError ?? this.lastError,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (visitId.present) {
      map['visit_id'] = Variable<String>(visitId.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(kind.value);
    }
    if (photoStage.present) {
      map['photo_stage'] = Variable<String>(photoStage.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (bytes.present) {
      map['bytes'] = Variable<Uint8List>(bytes.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (uploadAttempts.present) {
      map['upload_attempts'] = Variable<int>(uploadAttempts.value);
    }
    if (lastError.present) {
      map['last_error'] = Variable<String>(lastError.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocalAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('visitId: $visitId, ')
          ..write('kind: $kind, ')
          ..write('photoStage: $photoStage, ')
          ..write('contentType: $contentType, ')
          ..write('bytes: $bytes, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('status: $status, ')
          ..write('uploadAttempts: $uploadAttempts, ')
          ..write('lastError: $lastError, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$FieldDatabase extends GeneratedDatabase {
  _$FieldDatabase(QueryExecutor e) : super(e);
  $FieldDatabaseManager get managers => $FieldDatabaseManager(this);
  late final $LocalVisitsTable localVisits = $LocalVisitsTable(this);
  late final $LocalWorkOrdersTable localWorkOrders = $LocalWorkOrdersTable(
    this,
  );
  late final $PendingMutationsTable pendingMutations = $PendingMutationsTable(
    this,
  );
  late final $NoticesTable notices = $NoticesTable(this);
  late final $SyncStateTable syncState = $SyncStateTable(this);
  late final $LocalChecklistsTable localChecklists = $LocalChecklistsTable(
    this,
  );
  late final $ChecklistDraftsTable checklistDrafts = $ChecklistDraftsTable(
    this,
  );
  late final $LocalAttachmentsTable localAttachments = $LocalAttachmentsTable(
    this,
  );
  @override
  Iterable<TableInfo<Table, Object?>> get allTables => allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    localVisits,
    localWorkOrders,
    pendingMutations,
    notices,
    syncState,
    localChecklists,
    checklistDrafts,
    localAttachments,
  ];
}

typedef $$LocalVisitsTableCreateCompanionBuilder =
    LocalVisitsCompanion Function({
      required String id,
      required String workOrderId,
      required DateTime scheduledStart,
      required String status,
      required String serverJson,
      required String json,
      Value<int> rowid,
    });
typedef $$LocalVisitsTableUpdateCompanionBuilder =
    LocalVisitsCompanion Function({
      Value<String> id,
      Value<String> workOrderId,
      Value<DateTime> scheduledStart,
      Value<String> status,
      Value<String> serverJson,
      Value<String> json,
      Value<int> rowid,
    });

class $$LocalVisitsTableFilterComposer extends Composer<_$FieldDatabase, $LocalVisitsTable> {
  $$LocalVisitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get workOrderId => $composableBuilder(
    column: $table.workOrderId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get serverJson => $composableBuilder(
    column: $table.serverJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalVisitsTableOrderingComposer extends Composer<_$FieldDatabase, $LocalVisitsTable> {
  $$LocalVisitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get workOrderId => $composableBuilder(
    column: $table.workOrderId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get serverJson => $composableBuilder(
    column: $table.serverJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalVisitsTableAnnotationComposer extends Composer<_$FieldDatabase, $LocalVisitsTable> {
  $$LocalVisitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get workOrderId => $composableBuilder(
    column: $table.workOrderId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get scheduledStart => $composableBuilder(
    column: $table.scheduledStart,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status => $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get serverJson => $composableBuilder(
    column: $table.serverJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get json => $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$LocalVisitsTableTableManager
    extends
        RootTableManager<
          _$FieldDatabase,
          $LocalVisitsTable,
          LocalVisit,
          $$LocalVisitsTableFilterComposer,
          $$LocalVisitsTableOrderingComposer,
          $$LocalVisitsTableAnnotationComposer,
          $$LocalVisitsTableCreateCompanionBuilder,
          $$LocalVisitsTableUpdateCompanionBuilder,
          (
            LocalVisit,
            BaseReferences<_$FieldDatabase, $LocalVisitsTable, LocalVisit>,
          ),
          LocalVisit,
          PrefetchHooks Function()
        > {
  $$LocalVisitsTableTableManager(_$FieldDatabase db, $LocalVisitsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$LocalVisitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$LocalVisitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$LocalVisitsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> workOrderId = const Value.absent(),
                Value<DateTime> scheduledStart = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> serverJson = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalVisitsCompanion(
                id: id,
                workOrderId: workOrderId,
                scheduledStart: scheduledStart,
                status: status,
                serverJson: serverJson,
                json: json,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String workOrderId,
                required DateTime scheduledStart,
                required String status,
                required String serverJson,
                required String json,
                Value<int> rowid = const Value.absent(),
              }) => LocalVisitsCompanion.insert(
                id: id,
                workOrderId: workOrderId,
                scheduledStart: scheduledStart,
                status: status,
                serverJson: serverJson,
                json: json,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalVisitsTable, LocalVisit>(table),
                  BaseReferences<_$FieldDatabase, $LocalVisitsTable, LocalVisit>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalVisitsTableProcessedTableManager =
    ProcessedTableManager<
      _$FieldDatabase,
      $LocalVisitsTable,
      LocalVisit,
      $$LocalVisitsTableFilterComposer,
      $$LocalVisitsTableOrderingComposer,
      $$LocalVisitsTableAnnotationComposer,
      $$LocalVisitsTableCreateCompanionBuilder,
      $$LocalVisitsTableUpdateCompanionBuilder,
      (
        LocalVisit,
        BaseReferences<_$FieldDatabase, $LocalVisitsTable, LocalVisit>,
      ),
      LocalVisit,
      PrefetchHooks Function()
    >;
typedef $$LocalWorkOrdersTableCreateCompanionBuilder =
    LocalWorkOrdersCompanion Function({
      required String id,
      required String json,
      Value<int> rowid,
    });
typedef $$LocalWorkOrdersTableUpdateCompanionBuilder =
    LocalWorkOrdersCompanion Function({
      Value<String> id,
      Value<String> json,
      Value<int> rowid,
    });

class $$LocalWorkOrdersTableFilterComposer extends Composer<_$FieldDatabase, $LocalWorkOrdersTable> {
  $$LocalWorkOrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalWorkOrdersTableOrderingComposer extends Composer<_$FieldDatabase, $LocalWorkOrdersTable> {
  $$LocalWorkOrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalWorkOrdersTableAnnotationComposer extends Composer<_$FieldDatabase, $LocalWorkOrdersTable> {
  $$LocalWorkOrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get json => $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$LocalWorkOrdersTableTableManager
    extends
        RootTableManager<
          _$FieldDatabase,
          $LocalWorkOrdersTable,
          LocalWorkOrder,
          $$LocalWorkOrdersTableFilterComposer,
          $$LocalWorkOrdersTableOrderingComposer,
          $$LocalWorkOrdersTableAnnotationComposer,
          $$LocalWorkOrdersTableCreateCompanionBuilder,
          $$LocalWorkOrdersTableUpdateCompanionBuilder,
          (
            LocalWorkOrder,
            BaseReferences<_$FieldDatabase, $LocalWorkOrdersTable, LocalWorkOrder>,
          ),
          LocalWorkOrder,
          PrefetchHooks Function()
        > {
  $$LocalWorkOrdersTableTableManager(
    _$FieldDatabase db,
    $LocalWorkOrdersTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$LocalWorkOrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$LocalWorkOrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$LocalWorkOrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalWorkOrdersCompanion(id: id, json: json, rowid: rowid),
          createCompanionCallback:
              ({
                required String id,
                required String json,
                Value<int> rowid = const Value.absent(),
              }) => LocalWorkOrdersCompanion.insert(
                id: id,
                json: json,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalWorkOrdersTable, LocalWorkOrder>(table),
                  BaseReferences<_$FieldDatabase, $LocalWorkOrdersTable, LocalWorkOrder>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalWorkOrdersTableProcessedTableManager =
    ProcessedTableManager<
      _$FieldDatabase,
      $LocalWorkOrdersTable,
      LocalWorkOrder,
      $$LocalWorkOrdersTableFilterComposer,
      $$LocalWorkOrdersTableOrderingComposer,
      $$LocalWorkOrdersTableAnnotationComposer,
      $$LocalWorkOrdersTableCreateCompanionBuilder,
      $$LocalWorkOrdersTableUpdateCompanionBuilder,
      (
        LocalWorkOrder,
        BaseReferences<_$FieldDatabase, $LocalWorkOrdersTable, LocalWorkOrder>,
      ),
      LocalWorkOrder,
      PrefetchHooks Function()
    >;
typedef $$PendingMutationsTableCreateCompanionBuilder =
    PendingMutationsCompanion Function({
      Value<int> seq,
      required String mutationId,
      required String type,
      required String entityId,
      required String payload,
      required DateTime clientTimestamp,
      Value<int> attempts,
      Value<String?> lastError,
    });
typedef $$PendingMutationsTableUpdateCompanionBuilder =
    PendingMutationsCompanion Function({
      Value<int> seq,
      Value<String> mutationId,
      Value<String> type,
      Value<String> entityId,
      Value<String> payload,
      Value<DateTime> clientTimestamp,
      Value<int> attempts,
      Value<String?> lastError,
    });

class $$PendingMutationsTableFilterComposer extends Composer<_$FieldDatabase, $PendingMutationsTable> {
  $$PendingMutationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mutationId => $composableBuilder(
    column: $table.mutationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientTimestamp => $composableBuilder(
    column: $table.clientTimestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PendingMutationsTableOrderingComposer extends Composer<_$FieldDatabase, $PendingMutationsTable> {
  $$PendingMutationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get seq => $composableBuilder(
    column: $table.seq,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mutationId => $composableBuilder(
    column: $table.mutationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientTimestamp => $composableBuilder(
    column: $table.clientTimestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get attempts => $composableBuilder(
    column: $table.attempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PendingMutationsTableAnnotationComposer extends Composer<_$FieldDatabase, $PendingMutationsTable> {
  $$PendingMutationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get seq => $composableBuilder(column: $table.seq, builder: (column) => column);

  GeneratedColumn<String> get mutationId => $composableBuilder(
    column: $table.mutationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type => $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get entityId => $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payload => $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get clientTimestamp => $composableBuilder(
    column: $table.clientTimestamp,
    builder: (column) => column,
  );

  GeneratedColumn<int> get attempts => $composableBuilder(column: $table.attempts, builder: (column) => column);

  GeneratedColumn<String> get lastError => $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$PendingMutationsTableTableManager
    extends
        RootTableManager<
          _$FieldDatabase,
          $PendingMutationsTable,
          PendingMutation,
          $$PendingMutationsTableFilterComposer,
          $$PendingMutationsTableOrderingComposer,
          $$PendingMutationsTableAnnotationComposer,
          $$PendingMutationsTableCreateCompanionBuilder,
          $$PendingMutationsTableUpdateCompanionBuilder,
          (
            PendingMutation,
            BaseReferences<_$FieldDatabase, $PendingMutationsTable, PendingMutation>,
          ),
          PendingMutation,
          PrefetchHooks Function()
        > {
  $$PendingMutationsTableTableManager(
    _$FieldDatabase db,
    $PendingMutationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$PendingMutationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$PendingMutationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$PendingMutationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                Value<String> mutationId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> payload = const Value.absent(),
                Value<DateTime> clientTimestamp = const Value.absent(),
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => PendingMutationsCompanion(
                seq: seq,
                mutationId: mutationId,
                type: type,
                entityId: entityId,
                payload: payload,
                clientTimestamp: clientTimestamp,
                attempts: attempts,
                lastError: lastError,
              ),
          createCompanionCallback:
              ({
                Value<int> seq = const Value.absent(),
                required String mutationId,
                required String type,
                required String entityId,
                required String payload,
                required DateTime clientTimestamp,
                Value<int> attempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
              }) => PendingMutationsCompanion.insert(
                seq: seq,
                mutationId: mutationId,
                type: type,
                entityId: entityId,
                payload: payload,
                clientTimestamp: clientTimestamp,
                attempts: attempts,
                lastError: lastError,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$PendingMutationsTable, PendingMutation>(table),
                  BaseReferences<_$FieldDatabase, $PendingMutationsTable, PendingMutation>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PendingMutationsTableProcessedTableManager =
    ProcessedTableManager<
      _$FieldDatabase,
      $PendingMutationsTable,
      PendingMutation,
      $$PendingMutationsTableFilterComposer,
      $$PendingMutationsTableOrderingComposer,
      $$PendingMutationsTableAnnotationComposer,
      $$PendingMutationsTableCreateCompanionBuilder,
      $$PendingMutationsTableUpdateCompanionBuilder,
      (
        PendingMutation,
        BaseReferences<_$FieldDatabase, $PendingMutationsTable, PendingMutation>,
      ),
      PendingMutation,
      PrefetchHooks Function()
    >;
typedef $$NoticesTableCreateCompanionBuilder =
    NoticesCompanion Function({
      Value<int> id,
      required DateTime createdAt,
      Value<String?> visitId,
      required String message,
      Value<bool> read,
    });
typedef $$NoticesTableUpdateCompanionBuilder =
    NoticesCompanion Function({
      Value<int> id,
      Value<DateTime> createdAt,
      Value<String?> visitId,
      Value<String> message,
      Value<bool> read,
    });

class $$NoticesTableFilterComposer extends Composer<_$FieldDatabase, $NoticesTable> {
  $$NoticesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NoticesTableOrderingComposer extends Composer<_$FieldDatabase, $NoticesTable> {
  $$NoticesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get message => $composableBuilder(
    column: $table.message,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get read => $composableBuilder(
    column: $table.read,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NoticesTableAnnotationComposer extends Composer<_$FieldDatabase, $NoticesTable> {
  $$NoticesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt => $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get visitId => $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<String> get message => $composableBuilder(column: $table.message, builder: (column) => column);

  GeneratedColumn<bool> get read => $composableBuilder(column: $table.read, builder: (column) => column);
}

class $$NoticesTableTableManager
    extends
        RootTableManager<
          _$FieldDatabase,
          $NoticesTable,
          Notice,
          $$NoticesTableFilterComposer,
          $$NoticesTableOrderingComposer,
          $$NoticesTableAnnotationComposer,
          $$NoticesTableCreateCompanionBuilder,
          $$NoticesTableUpdateCompanionBuilder,
          (Notice, BaseReferences<_$FieldDatabase, $NoticesTable, Notice>),
          Notice,
          PrefetchHooks Function()
        > {
  $$NoticesTableTableManager(_$FieldDatabase db, $NoticesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$NoticesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$NoticesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$NoticesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String?> visitId = const Value.absent(),
                Value<String> message = const Value.absent(),
                Value<bool> read = const Value.absent(),
              }) => NoticesCompanion(
                id: id,
                createdAt: createdAt,
                visitId: visitId,
                message: message,
                read: read,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required DateTime createdAt,
                Value<String?> visitId = const Value.absent(),
                required String message,
                Value<bool> read = const Value.absent(),
              }) => NoticesCompanion.insert(
                id: id,
                createdAt: createdAt,
                visitId: visitId,
                message: message,
                read: read,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$NoticesTable, Notice>(table),
                  BaseReferences<_$FieldDatabase, $NoticesTable, Notice>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NoticesTableProcessedTableManager =
    ProcessedTableManager<
      _$FieldDatabase,
      $NoticesTable,
      Notice,
      $$NoticesTableFilterComposer,
      $$NoticesTableOrderingComposer,
      $$NoticesTableAnnotationComposer,
      $$NoticesTableCreateCompanionBuilder,
      $$NoticesTableUpdateCompanionBuilder,
      (Notice, BaseReferences<_$FieldDatabase, $NoticesTable, Notice>),
      Notice,
      PrefetchHooks Function()
    >;
typedef $$SyncStateTableCreateCompanionBuilder =
    SyncStateCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$SyncStateTableUpdateCompanionBuilder =
    SyncStateCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$SyncStateTableFilterComposer extends Composer<_$FieldDatabase, $SyncStateTable> {
  $$SyncStateTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStateTableOrderingComposer extends Composer<_$FieldDatabase, $SyncStateTable> {
  $$SyncStateTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStateTableAnnotationComposer extends Composer<_$FieldDatabase, $SyncStateTable> {
  $$SyncStateTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key => $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value => $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$SyncStateTableTableManager
    extends
        RootTableManager<
          _$FieldDatabase,
          $SyncStateTable,
          SyncStateData,
          $$SyncStateTableFilterComposer,
          $$SyncStateTableOrderingComposer,
          $$SyncStateTableAnnotationComposer,
          $$SyncStateTableCreateCompanionBuilder,
          $$SyncStateTableUpdateCompanionBuilder,
          (
            SyncStateData,
            BaseReferences<_$FieldDatabase, $SyncStateTable, SyncStateData>,
          ),
          SyncStateData,
          PrefetchHooks Function()
        > {
  $$SyncStateTableTableManager(_$FieldDatabase db, $SyncStateTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$SyncStateTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$SyncStateTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$SyncStateTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => SyncStateCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SyncStateTable, SyncStateData>(table),
                  BaseReferences<_$FieldDatabase, $SyncStateTable, SyncStateData>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStateTableProcessedTableManager =
    ProcessedTableManager<
      _$FieldDatabase,
      $SyncStateTable,
      SyncStateData,
      $$SyncStateTableFilterComposer,
      $$SyncStateTableOrderingComposer,
      $$SyncStateTableAnnotationComposer,
      $$SyncStateTableCreateCompanionBuilder,
      $$SyncStateTableUpdateCompanionBuilder,
      (
        SyncStateData,
        BaseReferences<_$FieldDatabase, $SyncStateTable, SyncStateData>,
      ),
      SyncStateData,
      PrefetchHooks Function()
    >;
typedef $$LocalChecklistsTableCreateCompanionBuilder =
    LocalChecklistsCompanion Function({
      required String visitId,
      required String json,
      Value<int> rowid,
    });
typedef $$LocalChecklistsTableUpdateCompanionBuilder =
    LocalChecklistsCompanion Function({
      Value<String> visitId,
      Value<String> json,
      Value<int> rowid,
    });

class $$LocalChecklistsTableFilterComposer extends Composer<_$FieldDatabase, $LocalChecklistsTable> {
  $$LocalChecklistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalChecklistsTableOrderingComposer extends Composer<_$FieldDatabase, $LocalChecklistsTable> {
  $$LocalChecklistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get json => $composableBuilder(
    column: $table.json,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalChecklistsTableAnnotationComposer extends Composer<_$FieldDatabase, $LocalChecklistsTable> {
  $$LocalChecklistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get visitId => $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<String> get json => $composableBuilder(column: $table.json, builder: (column) => column);
}

class $$LocalChecklistsTableTableManager
    extends
        RootTableManager<
          _$FieldDatabase,
          $LocalChecklistsTable,
          LocalChecklist,
          $$LocalChecklistsTableFilterComposer,
          $$LocalChecklistsTableOrderingComposer,
          $$LocalChecklistsTableAnnotationComposer,
          $$LocalChecklistsTableCreateCompanionBuilder,
          $$LocalChecklistsTableUpdateCompanionBuilder,
          (
            LocalChecklist,
            BaseReferences<_$FieldDatabase, $LocalChecklistsTable, LocalChecklist>,
          ),
          LocalChecklist,
          PrefetchHooks Function()
        > {
  $$LocalChecklistsTableTableManager(
    _$FieldDatabase db,
    $LocalChecklistsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$LocalChecklistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$LocalChecklistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$LocalChecklistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> visitId = const Value.absent(),
                Value<String> json = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalChecklistsCompanion(
                visitId: visitId,
                json: json,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String visitId,
                required String json,
                Value<int> rowid = const Value.absent(),
              }) => LocalChecklistsCompanion.insert(
                visitId: visitId,
                json: json,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalChecklistsTable, LocalChecklist>(table),
                  BaseReferences<_$FieldDatabase, $LocalChecklistsTable, LocalChecklist>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalChecklistsTableProcessedTableManager =
    ProcessedTableManager<
      _$FieldDatabase,
      $LocalChecklistsTable,
      LocalChecklist,
      $$LocalChecklistsTableFilterComposer,
      $$LocalChecklistsTableOrderingComposer,
      $$LocalChecklistsTableAnnotationComposer,
      $$LocalChecklistsTableCreateCompanionBuilder,
      $$LocalChecklistsTableUpdateCompanionBuilder,
      (
        LocalChecklist,
        BaseReferences<_$FieldDatabase, $LocalChecklistsTable, LocalChecklist>,
      ),
      LocalChecklist,
      PrefetchHooks Function()
    >;
typedef $$ChecklistDraftsTableCreateCompanionBuilder =
    ChecklistDraftsCompanion Function({
      required String visitId,
      required String templateId,
      required String answers,
      Value<bool> submitted,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ChecklistDraftsTableUpdateCompanionBuilder =
    ChecklistDraftsCompanion Function({
      Value<String> visitId,
      Value<String> templateId,
      Value<String> answers,
      Value<bool> submitted,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$ChecklistDraftsTableFilterComposer extends Composer<_$FieldDatabase, $ChecklistDraftsTable> {
  $$ChecklistDraftsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get answers => $composableBuilder(
    column: $table.answers,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get submitted => $composableBuilder(
    column: $table.submitted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ChecklistDraftsTableOrderingComposer extends Composer<_$FieldDatabase, $ChecklistDraftsTable> {
  $$ChecklistDraftsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get answers => $composableBuilder(
    column: $table.answers,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get submitted => $composableBuilder(
    column: $table.submitted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ChecklistDraftsTableAnnotationComposer extends Composer<_$FieldDatabase, $ChecklistDraftsTable> {
  $$ChecklistDraftsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get visitId => $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get answers => $composableBuilder(column: $table.answers, builder: (column) => column);

  GeneratedColumn<bool> get submitted => $composableBuilder(column: $table.submitted, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt => $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$ChecklistDraftsTableTableManager
    extends
        RootTableManager<
          _$FieldDatabase,
          $ChecklistDraftsTable,
          ChecklistDraft,
          $$ChecklistDraftsTableFilterComposer,
          $$ChecklistDraftsTableOrderingComposer,
          $$ChecklistDraftsTableAnnotationComposer,
          $$ChecklistDraftsTableCreateCompanionBuilder,
          $$ChecklistDraftsTableUpdateCompanionBuilder,
          (
            ChecklistDraft,
            BaseReferences<_$FieldDatabase, $ChecklistDraftsTable, ChecklistDraft>,
          ),
          ChecklistDraft,
          PrefetchHooks Function()
        > {
  $$ChecklistDraftsTableTableManager(
    _$FieldDatabase db,
    $ChecklistDraftsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$ChecklistDraftsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$ChecklistDraftsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$ChecklistDraftsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> visitId = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<String> answers = const Value.absent(),
                Value<bool> submitted = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ChecklistDraftsCompanion(
                visitId: visitId,
                templateId: templateId,
                answers: answers,
                submitted: submitted,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String visitId,
                required String templateId,
                required String answers,
                Value<bool> submitted = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ChecklistDraftsCompanion.insert(
                visitId: visitId,
                templateId: templateId,
                answers: answers,
                submitted: submitted,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ChecklistDraftsTable, ChecklistDraft>(table),
                  BaseReferences<_$FieldDatabase, $ChecklistDraftsTable, ChecklistDraft>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ChecklistDraftsTableProcessedTableManager =
    ProcessedTableManager<
      _$FieldDatabase,
      $ChecklistDraftsTable,
      ChecklistDraft,
      $$ChecklistDraftsTableFilterComposer,
      $$ChecklistDraftsTableOrderingComposer,
      $$ChecklistDraftsTableAnnotationComposer,
      $$ChecklistDraftsTableCreateCompanionBuilder,
      $$ChecklistDraftsTableUpdateCompanionBuilder,
      (
        ChecklistDraft,
        BaseReferences<_$FieldDatabase, $ChecklistDraftsTable, ChecklistDraft>,
      ),
      ChecklistDraft,
      PrefetchHooks Function()
    >;
typedef $$LocalAttachmentsTableCreateCompanionBuilder =
    LocalAttachmentsCompanion Function({
      required String id,
      required String visitId,
      required String kind,
      Value<String?> photoStage,
      required String contentType,
      required Uint8List bytes,
      required DateTime capturedAt,
      required String status,
      Value<int> uploadAttempts,
      Value<String?> lastError,
      Value<int> rowid,
    });
typedef $$LocalAttachmentsTableUpdateCompanionBuilder =
    LocalAttachmentsCompanion Function({
      Value<String> id,
      Value<String> visitId,
      Value<String> kind,
      Value<String?> photoStage,
      Value<String> contentType,
      Value<Uint8List> bytes,
      Value<DateTime> capturedAt,
      Value<String> status,
      Value<int> uploadAttempts,
      Value<String?> lastError,
      Value<int> rowid,
    });

class $$LocalAttachmentsTableFilterComposer extends Composer<_$FieldDatabase, $LocalAttachmentsTable> {
  $$LocalAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoStage => $composableBuilder(
    column: $table.photoStage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get uploadAttempts => $composableBuilder(
    column: $table.uploadAttempts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocalAttachmentsTableOrderingComposer extends Composer<_$FieldDatabase, $LocalAttachmentsTable> {
  $$LocalAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get visitId => $composableBuilder(
    column: $table.visitId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoStage => $composableBuilder(
    column: $table.photoStage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<Uint8List> get bytes => $composableBuilder(
    column: $table.bytes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get uploadAttempts => $composableBuilder(
    column: $table.uploadAttempts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lastError => $composableBuilder(
    column: $table.lastError,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocalAttachmentsTableAnnotationComposer extends Composer<_$FieldDatabase, $LocalAttachmentsTable> {
  $$LocalAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id => $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get visitId => $composableBuilder(column: $table.visitId, builder: (column) => column);

  GeneratedColumn<String> get kind => $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get photoStage => $composableBuilder(
    column: $table.photoStage,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<Uint8List> get bytes => $composableBuilder(column: $table.bytes, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status => $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<int> get uploadAttempts => $composableBuilder(
    column: $table.uploadAttempts,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lastError => $composableBuilder(column: $table.lastError, builder: (column) => column);
}

class $$LocalAttachmentsTableTableManager
    extends
        RootTableManager<
          _$FieldDatabase,
          $LocalAttachmentsTable,
          LocalAttachment,
          $$LocalAttachmentsTableFilterComposer,
          $$LocalAttachmentsTableOrderingComposer,
          $$LocalAttachmentsTableAnnotationComposer,
          $$LocalAttachmentsTableCreateCompanionBuilder,
          $$LocalAttachmentsTableUpdateCompanionBuilder,
          (
            LocalAttachment,
            BaseReferences<_$FieldDatabase, $LocalAttachmentsTable, LocalAttachment>,
          ),
          LocalAttachment,
          PrefetchHooks Function()
        > {
  $$LocalAttachmentsTableTableManager(
    _$FieldDatabase db,
    $LocalAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () => $$LocalAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () => $$LocalAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () => $$LocalAttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> visitId = const Value.absent(),
                Value<String> kind = const Value.absent(),
                Value<String?> photoStage = const Value.absent(),
                Value<String> contentType = const Value.absent(),
                Value<Uint8List> bytes = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<int> uploadAttempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAttachmentsCompanion(
                id: id,
                visitId: visitId,
                kind: kind,
                photoStage: photoStage,
                contentType: contentType,
                bytes: bytes,
                capturedAt: capturedAt,
                status: status,
                uploadAttempts: uploadAttempts,
                lastError: lastError,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String visitId,
                required String kind,
                Value<String?> photoStage = const Value.absent(),
                required String contentType,
                required Uint8List bytes,
                required DateTime capturedAt,
                required String status,
                Value<int> uploadAttempts = const Value.absent(),
                Value<String?> lastError = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => LocalAttachmentsCompanion.insert(
                id: id,
                visitId: visitId,
                kind: kind,
                photoStage: photoStage,
                contentType: contentType,
                bytes: bytes,
                capturedAt: capturedAt,
                status: status,
                uploadAttempts: uploadAttempts,
                lastError: lastError,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LocalAttachmentsTable, LocalAttachment>(table),
                  BaseReferences<_$FieldDatabase, $LocalAttachmentsTable, LocalAttachment>(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocalAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$FieldDatabase,
      $LocalAttachmentsTable,
      LocalAttachment,
      $$LocalAttachmentsTableFilterComposer,
      $$LocalAttachmentsTableOrderingComposer,
      $$LocalAttachmentsTableAnnotationComposer,
      $$LocalAttachmentsTableCreateCompanionBuilder,
      $$LocalAttachmentsTableUpdateCompanionBuilder,
      (
        LocalAttachment,
        BaseReferences<_$FieldDatabase, $LocalAttachmentsTable, LocalAttachment>,
      ),
      LocalAttachment,
      PrefetchHooks Function()
    >;

class $FieldDatabaseManager {
  final _$FieldDatabase _db;
  $FieldDatabaseManager(this._db);
  $$LocalVisitsTableTableManager get localVisits => $$LocalVisitsTableTableManager(_db, _db.localVisits);
  $$LocalWorkOrdersTableTableManager get localWorkOrders =>
      $$LocalWorkOrdersTableTableManager(_db, _db.localWorkOrders);
  $$PendingMutationsTableTableManager get pendingMutations =>
      $$PendingMutationsTableTableManager(_db, _db.pendingMutations);
  $$NoticesTableTableManager get notices => $$NoticesTableTableManager(_db, _db.notices);
  $$SyncStateTableTableManager get syncState => $$SyncStateTableTableManager(_db, _db.syncState);
  $$LocalChecklistsTableTableManager get localChecklists =>
      $$LocalChecklistsTableTableManager(_db, _db.localChecklists);
  $$ChecklistDraftsTableTableManager get checklistDrafts =>
      $$ChecklistDraftsTableTableManager(_db, _db.checklistDrafts);
  $$LocalAttachmentsTableTableManager get localAttachments =>
      $$LocalAttachmentsTableTableManager(_db, _db.localAttachments);
}
