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
import '../../customers/models/customer_kind.dart' as _itewe25f;
import '../../customers/models/document_type.dart' as _ij2uuldm;
import '../../customers/models/person_type.dart' as _iiezq3l7;
import '../../platform/models/record_source.dart' as _i1c87mer;

abstract class Customer implements _is.TableRow<_is.UuidValue>, _is.ProtocolSerialization {
  Customer._({
    _is.UuidValue? id,
    required this.tenantId,
    this.code,
    required this.name,
    this.tradeName,
    required this.personType,
    required this.documentType,
    this.documentNumber,
    this.stateRegistration,
    this.email,
    this.phone,
    this.notes,
    required this.kind,
    this.primarySalesRepId,
    required this.skipTriage,
    required this.isActive,
    this.deactivatedAt,
    required this.source,
    this.externalSystem,
    this.externalId,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : id = id ?? const _is.Uuid().v7obj();

  factory Customer({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    String? code,
    required String name,
    String? tradeName,
    required _iiezq3l7.PersonType personType,
    required _ij2uuldm.DocumentType documentType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    required _itewe25f.CustomerKind kind,
    _is.UuidValue? primarySalesRepId,
    required bool skipTriage,
    required bool isActive,
    DateTime? deactivatedAt,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _CustomerImpl;

  factory Customer.fromJson(Map<String, dynamic> jsonSerialization) {
    return Customer(
      id: jsonSerialization['id'] == null ? null : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String,
      tradeName: jsonSerialization['tradeName'] as String?,
      personType: _iiezq3l7.PersonType.fromJson((jsonSerialization['personType'] as String)),
      documentType: _ij2uuldm.DocumentType.fromJson((jsonSerialization['documentType'] as String)),
      documentNumber: jsonSerialization['documentNumber'] as String?,
      stateRegistration: jsonSerialization['stateRegistration'] as String?,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      notes: jsonSerialization['notes'] as String?,
      kind: _itewe25f.CustomerKind.fromJson((jsonSerialization['kind'] as String)),
      primarySalesRepId: jsonSerialization['primarySalesRepId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['primarySalesRepId']),
      skipTriage: _is.BoolJsonExtension.fromJson(jsonSerialization['skipTriage']),
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      deactivatedAt: jsonSerialization['deactivatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['deactivatedAt']),
      source: _i1c87mer.RecordSource.fromJson((jsonSerialization['source'] as String)),
      externalSystem: jsonSerialization['externalSystem'] as String?,
      externalId: jsonSerialization['externalId'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = CustomerTable();

  static const db = CustomerRepository._();

  @override
  _is.UuidValue id;

  _is.UuidValue tenantId;

  String? code;

  String name;

  String? tradeName;

  _iiezq3l7.PersonType personType;

  _ij2uuldm.DocumentType documentType;

  String? documentNumber;

  String? stateRegistration;

  String? email;

  String? phone;

  String? notes;

  _itewe25f.CustomerKind kind;

  _is.UuidValue? primarySalesRepId;

  bool skipTriage;

  bool isActive;

  DateTime? deactivatedAt;

  _i1c87mer.RecordSource source;

  String? externalSystem;

  String? externalId;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  @override
  _is.Table<_is.UuidValue> get table => t;

  /// Returns a shallow copy of this [Customer]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  Customer copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    String? code,
    String? name,
    String? tradeName,
    _iiezq3l7.PersonType? personType,
    _ij2uuldm.DocumentType? documentType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    _itewe25f.CustomerKind? kind,
    _is.UuidValue? primarySalesRepId = const _is.$UndefinedUuidValue(),
    bool? skipTriage,
    bool? isActive,
    DateTime? deactivatedAt = const _is.$UndefinedDateTime(),
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
      '__className__': 'Customer',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      if (code != null) 'code': code,
      'name': name,
      if (tradeName != null) 'tradeName': tradeName,
      'personType': personType.toJson(),
      'documentType': documentType.toJson(),
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (stateRegistration != null) 'stateRegistration': stateRegistration,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      'kind': kind.toJson(),
      if (primarySalesRepId != null) 'primarySalesRepId': primarySalesRepId?.toJson(),
      'skipTriage': skipTriage,
      'isActive': isActive,
      if (deactivatedAt != null) 'deactivatedAt': deactivatedAt?.toJson(),
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
      '__className__': 'Customer',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      if (code != null) 'code': code,
      'name': name,
      if (tradeName != null) 'tradeName': tradeName,
      'personType': personType.toJson(),
      'documentType': documentType.toJson(),
      if (documentNumber != null) 'documentNumber': documentNumber,
      if (stateRegistration != null) 'stateRegistration': stateRegistration,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (notes != null) 'notes': notes,
      'kind': kind.toJson(),
      if (primarySalesRepId != null) 'primarySalesRepId': primarySalesRepId?.toJson(),
      'skipTriage': skipTriage,
      'isActive': isActive,
      if (deactivatedAt != null) 'deactivatedAt': deactivatedAt?.toJson(),
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  static CustomerInclude include() {
    return CustomerInclude._();
  }

  static CustomerIncludeList includeList({
    _is.WhereExpressionBuilder<CustomerTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerTable>? orderBy,
    _is.OrderByListBuilder<CustomerTable>? orderByList,
    CustomerInclude? include,
  }) {
    return CustomerIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Customer.t),
      orderByList: orderByList?.call(Customer.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerImpl extends Customer {
  _CustomerImpl({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    String? code,
    required String name,
    String? tradeName,
    required _iiezq3l7.PersonType personType,
    required _ij2uuldm.DocumentType documentType,
    String? documentNumber,
    String? stateRegistration,
    String? email,
    String? phone,
    String? notes,
    required _itewe25f.CustomerKind kind,
    _is.UuidValue? primarySalesRepId,
    required bool skipTriage,
    required bool isActive,
    DateTime? deactivatedAt,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) : super._(
         id: id,
         tenantId: tenantId,
         code: code,
         name: name,
         tradeName: tradeName,
         personType: personType,
         documentType: documentType,
         documentNumber: documentNumber,
         stateRegistration: stateRegistration,
         email: email,
         phone: phone,
         notes: notes,
         kind: kind,
         primarySalesRepId: primarySalesRepId,
         skipTriage: skipTriage,
         isActive: isActive,
         deactivatedAt: deactivatedAt,
         source: source,
         externalSystem: externalSystem,
         externalId: externalId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [Customer]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  Customer copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    Object? code = _Undefined,
    String? name,
    Object? tradeName = _Undefined,
    _iiezq3l7.PersonType? personType,
    _ij2uuldm.DocumentType? documentType,
    Object? documentNumber = _Undefined,
    Object? stateRegistration = _Undefined,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? notes = _Undefined,
    _itewe25f.CustomerKind? kind,
    _is.UuidValue? primarySalesRepId = const _is.$UndefinedUuidValue(),
    bool? skipTriage,
    bool? isActive,
    DateTime? deactivatedAt = const _is.$UndefinedDateTime(),
    _i1c87mer.RecordSource? source,
    Object? externalSystem = _Undefined,
    Object? externalId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return Customer(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      code: code is String? ? code : this.code,
      name: name ?? this.name,
      tradeName: tradeName is String? ? tradeName : this.tradeName,
      personType: personType ?? this.personType,
      documentType: documentType ?? this.documentType,
      documentNumber: documentNumber is String? ? documentNumber : this.documentNumber,
      stateRegistration: stateRegistration is String? ? stateRegistration : this.stateRegistration,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      notes: notes is String? ? notes : this.notes,
      kind: kind ?? this.kind,
      primarySalesRepId: primarySalesRepId is _is.UndefinedSentinel ? this.primarySalesRepId : primarySalesRepId,
      skipTriage: skipTriage ?? this.skipTriage,
      isActive: isActive ?? this.isActive,
      deactivatedAt: deactivatedAt is _is.UndefinedSentinel ? this.deactivatedAt : deactivatedAt,
      source: source ?? this.source,
      externalSystem: externalSystem is String? ? externalSystem : this.externalSystem,
      externalId: externalId is String? ? externalId : this.externalId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      version: version ?? this.version,
    );
  }
}

class CustomerUpdateTable extends _is.UpdateTable<CustomerTable> {
  CustomerUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> tenantId(_is.UuidValue value) => _is.ColumnValue(
    table.tenantId,
    value,
  );

  _is.ColumnValue<String, String> code(String? value) => _is.ColumnValue(
    table.code,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> tradeName(String? value) => _is.ColumnValue(
    table.tradeName,
    value,
  );

  _is.ColumnValue<_iiezq3l7.PersonType, _iiezq3l7.PersonType> personType(_iiezq3l7.PersonType value) => _is.ColumnValue(
    table.personType,
    value,
  );

  _is.ColumnValue<_ij2uuldm.DocumentType, _ij2uuldm.DocumentType> documentType(_ij2uuldm.DocumentType value) =>
      _is.ColumnValue(
        table.documentType,
        value,
      );

  _is.ColumnValue<String, String> documentNumber(String? value) => _is.ColumnValue(
    table.documentNumber,
    value,
  );

  _is.ColumnValue<String, String> stateRegistration(String? value) => _is.ColumnValue(
    table.stateRegistration,
    value,
  );

  _is.ColumnValue<String, String> email(String? value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> phone(String? value) => _is.ColumnValue(
    table.phone,
    value,
  );

  _is.ColumnValue<String, String> notes(String? value) => _is.ColumnValue(
    table.notes,
    value,
  );

  _is.ColumnValue<_itewe25f.CustomerKind, _itewe25f.CustomerKind> kind(_itewe25f.CustomerKind value) => _is.ColumnValue(
    table.kind,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> primarySalesRepId(_is.UuidValue? value) => _is.ColumnValue(
    table.primarySalesRepId,
    value,
  );

  _is.ColumnValue<bool, bool> skipTriage(bool value) => _is.ColumnValue(
    table.skipTriage,
    value,
  );

  _is.ColumnValue<bool, bool> isActive(bool value) => _is.ColumnValue(
    table.isActive,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> deactivatedAt(DateTime? value) => _is.ColumnValue(
    table.deactivatedAt,
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

class CustomerTable extends _is.Table<_is.UuidValue> {
  CustomerTable({super.tableRelation}) : super(tableName: 'customers') {
    updateTable = CustomerUpdateTable(this);
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
    tradeName = _is.ColumnString(
      'trade_name',
      this,
      fieldName: 'tradeName',
    );
    personType = _is.ColumnEnum(
      'person_type',
      this,
      _is.EnumSerialization.byName,
      fieldName: 'personType',
    );
    documentType = _is.ColumnEnum(
      'document_type',
      this,
      _is.EnumSerialization.byName,
      fieldName: 'documentType',
    );
    documentNumber = _is.ColumnString(
      'document_number',
      this,
      fieldName: 'documentNumber',
    );
    stateRegistration = _is.ColumnString(
      'state_registration',
      this,
      fieldName: 'stateRegistration',
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    phone = _is.ColumnString(
      'phone',
      this,
    );
    notes = _is.ColumnString(
      'notes',
      this,
    );
    kind = _is.ColumnEnum(
      'kind',
      this,
      _is.EnumSerialization.byName,
    );
    primarySalesRepId = _is.ColumnUuid(
      'primary_sales_rep_id',
      this,
      fieldName: 'primarySalesRepId',
    );
    skipTriage = _is.ColumnBool(
      'skip_triage',
      this,
      fieldName: 'skipTriage',
    );
    isActive = _is.ColumnBool(
      'is_active',
      this,
      fieldName: 'isActive',
    );
    deactivatedAt = _is.ColumnDateTime(
      'deactivated_at',
      this,
      fieldName: 'deactivatedAt',
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

  late final CustomerUpdateTable updateTable;

  late final _is.ColumnUuid tenantId;

  late final _is.ColumnString code;

  late final _is.ColumnString name;

  late final _is.ColumnString tradeName;

  late final _is.ColumnEnum<_iiezq3l7.PersonType> personType;

  late final _is.ColumnEnum<_ij2uuldm.DocumentType> documentType;

  late final _is.ColumnString documentNumber;

  late final _is.ColumnString stateRegistration;

  late final _is.ColumnString email;

  late final _is.ColumnString phone;

  late final _is.ColumnString notes;

  late final _is.ColumnEnum<_itewe25f.CustomerKind> kind;

  late final _is.ColumnUuid primarySalesRepId;

  late final _is.ColumnBool skipTriage;

  late final _is.ColumnBool isActive;

  late final _is.ColumnDateTime deactivatedAt;

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
    code,
    name,
    tradeName,
    personType,
    documentType,
    documentNumber,
    stateRegistration,
    email,
    phone,
    notes,
    kind,
    primarySalesRepId,
    skipTriage,
    isActive,
    deactivatedAt,
    source,
    externalSystem,
    externalId,
    createdAt,
    updatedAt,
    version,
  ];
}

class CustomerInclude extends _is.IncludeObject {
  CustomerInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue> get table => Customer.t;
}

class CustomerIncludeList extends _is.IncludeList {
  CustomerIncludeList._({
    _is.WhereExpressionBuilder<CustomerTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Customer.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue> get table => Customer.t;
}

class CustomerRepository {
  const CustomerRepository._();

  /// Returns a list of [Customer]s matching the given query parameters.
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
  Future<List<Customer>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerTable>? orderBy,
    _is.OrderByListBuilder<CustomerTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<Customer>(
      where: where?.call(Customer.t),
      orderBy: orderBy?.call(Customer.t),
      orderByList: orderByList?.call(Customer.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [Customer]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `Customer.t`.
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
  _ida.Stream<List<Customer>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerTable>? orderBy,
    _is.OrderByListBuilder<CustomerTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<Customer>(
      where: where?.call(Customer.t),
      orderBy: orderBy?.call(Customer.t),
      orderByList: orderByList?.call(Customer.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [Customer] matching the given query parameters.
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
  Future<Customer?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerTable>? where,
    int? offset,
    _is.OrderByBuilder<CustomerTable>? orderBy,
    _is.OrderByListBuilder<CustomerTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<Customer>(
      where: where?.call(Customer.t),
      orderBy: orderBy?.call(Customer.t),
      orderByList: orderByList?.call(Customer.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [Customer] by its [id] or null if no such row exists.
  Future<Customer?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<Customer>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [Customer]s in the list and returns the inserted rows.
  ///
  /// The returned [Customer]s will have their `id` fields set.
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
  Future<List<Customer>> insert(
    _is.DatabaseSession session,
    List<Customer> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<Customer>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [Customer] and returns the inserted row.
  ///
  /// The returned [Customer] will have its `id` field set.
  Future<Customer> insertRow(
    _is.DatabaseSession session,
    Customer row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<Customer>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [Customer]s in the list and returns the resulting rows.
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
  /// The returned [Customer]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Customer>> upsert(
    _is.DatabaseSession session,
    List<Customer> rows, {
    required _is.ColumnSelections<CustomerTable> conflictColumns,
    _is.ColumnSelections<CustomerTable>? updateColumns,
    _is.WhereExpressionBuilder<CustomerTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<Customer>(
      rows,
      conflictColumns: conflictColumns(Customer.t),
      updateColumns: updateColumns?.call(Customer.t),
      updateWhere: updateWhere?.call(Customer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [Customer] and returns the resulting row.
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
  /// The returned [Customer] will have its `id` field set.
  Future<Customer?> upsertRow(
    _is.DatabaseSession session,
    Customer row, {
    required _is.ColumnSelections<CustomerTable> conflictColumns,
    _is.ColumnSelections<CustomerTable>? updateColumns,
    _is.WhereExpressionBuilder<CustomerTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<Customer>(
      row,
      conflictColumns: conflictColumns(Customer.t),
      updateColumns: updateColumns?.call(Customer.t),
      updateWhere: updateWhere?.call(Customer.t),
      transaction: transaction,
    );
  }

  /// Updates all [Customer]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Customer>> update(
    _is.DatabaseSession session,
    List<Customer> rows, {
    _is.ColumnSelections<CustomerTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<Customer>(
      rows,
      columns: columns?.call(Customer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [Customer]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Customer> updateRow(
    _is.DatabaseSession session,
    Customer row, {
    _is.ColumnSelections<CustomerTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<Customer>(
      row,
      columns: columns?.call(Customer.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Customer] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<Customer?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CustomerUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<Customer>(
      id,
      columnValues: columnValues(Customer.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [Customer]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<Customer>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CustomerUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CustomerTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerTable>? orderBy,
    _is.OrderByListBuilder<CustomerTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<Customer>(
      columnValues: columnValues(Customer.t.updateTable),
      where: where(Customer.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Customer.t),
      orderByList: orderByList?.call(Customer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [Customer]s in the list and returns the deleted rows.
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
  Future<List<Customer>> delete(
    _is.DatabaseSession session,
    List<Customer> rows, {
    _is.OrderByBuilder<CustomerTable>? orderBy,
    _is.OrderByListBuilder<CustomerTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<Customer>(
      rows,
      orderBy: orderBy?.call(Customer.t),
      orderByList: orderByList?.call(Customer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [Customer].
  Future<Customer> deleteRow(
    _is.DatabaseSession session,
    Customer row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Customer>(
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
  Future<List<Customer>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CustomerTable> where,
    _is.OrderByBuilder<CustomerTable>? orderBy,
    _is.OrderByListBuilder<CustomerTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<Customer>(
      where: where(Customer.t),
      orderBy: orderBy?.call(Customer.t),
      orderByList: orderByList?.call(Customer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<Customer>(
      where: where?.call(Customer.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [Customer] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CustomerTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<Customer>(
      where: where(Customer.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
