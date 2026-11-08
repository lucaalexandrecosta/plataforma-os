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

abstract class CustomerSite implements _is.TableRow<_is.UuidValue>, _is.ProtocolSerialization {
  CustomerSite._({
    _is.UuidValue? id,
    required this.tenantId,
    required this.customerId,
    this.code,
    required this.name,
    this.street,
    this.streetNumber,
    this.complement,
    this.district,
    this.city,
    this.state,
    this.postalCode,
    required this.countryCode,
    this.latitude,
    this.longitude,
    this.phone,
    this.accessNotes,
    this.serviceAreaId,
    required this.isActive,
    required this.source,
    this.externalSystem,
    this.externalId,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : id = id ?? const _is.Uuid().v7obj();

  factory CustomerSite({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required _is.UuidValue customerId,
    String? code,
    required String name,
    String? street,
    String? streetNumber,
    String? complement,
    String? district,
    String? city,
    String? state,
    String? postalCode,
    required String countryCode,
    double? latitude,
    double? longitude,
    String? phone,
    String? accessNotes,
    _is.UuidValue? serviceAreaId,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _CustomerSiteImpl;

  factory CustomerSite.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerSite(
      id: jsonSerialization['id'] == null ? null : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      customerId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['customerId']),
      code: jsonSerialization['code'] as String?,
      name: jsonSerialization['name'] as String,
      street: jsonSerialization['street'] as String?,
      streetNumber: jsonSerialization['streetNumber'] as String?,
      complement: jsonSerialization['complement'] as String?,
      district: jsonSerialization['district'] as String?,
      city: jsonSerialization['city'] as String?,
      state: jsonSerialization['state'] as String?,
      postalCode: jsonSerialization['postalCode'] as String?,
      countryCode: jsonSerialization['countryCode'] as String,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      phone: jsonSerialization['phone'] as String?,
      accessNotes: jsonSerialization['accessNotes'] as String?,
      serviceAreaId: jsonSerialization['serviceAreaId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['serviceAreaId']),
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      source: _i1c87mer.RecordSource.fromJson((jsonSerialization['source'] as String)),
      externalSystem: jsonSerialization['externalSystem'] as String?,
      externalId: jsonSerialization['externalId'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = CustomerSiteTable();

  static const db = CustomerSiteRepository._();

  @override
  _is.UuidValue id;

  _is.UuidValue tenantId;

  _is.UuidValue customerId;

  String? code;

  String name;

  String? street;

  String? streetNumber;

  String? complement;

  String? district;

  String? city;

  String? state;

  String? postalCode;

  String countryCode;

  double? latitude;

  double? longitude;

  String? phone;

  String? accessNotes;

  _is.UuidValue? serviceAreaId;

  bool isActive;

  _i1c87mer.RecordSource source;

  String? externalSystem;

  String? externalId;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  @override
  _is.Table<_is.UuidValue> get table => t;

  /// Returns a shallow copy of this [CustomerSite]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CustomerSite copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    _is.UuidValue? customerId,
    String? code,
    String? name,
    String? street,
    String? streetNumber,
    String? complement,
    String? district,
    String? city,
    String? state,
    String? postalCode,
    String? countryCode,
    double? latitude,
    double? longitude,
    String? phone,
    String? accessNotes,
    _is.UuidValue? serviceAreaId = const _is.$UndefinedUuidValue(),
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
      '__className__': 'CustomerSite',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'customerId': customerId.toJson(),
      if (code != null) 'code': code,
      'name': name,
      if (street != null) 'street': street,
      if (streetNumber != null) 'streetNumber': streetNumber,
      if (complement != null) 'complement': complement,
      if (district != null) 'district': district,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (postalCode != null) 'postalCode': postalCode,
      'countryCode': countryCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (phone != null) 'phone': phone,
      if (accessNotes != null) 'accessNotes': accessNotes,
      if (serviceAreaId != null) 'serviceAreaId': serviceAreaId?.toJson(),
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
      '__className__': 'CustomerSite',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'customerId': customerId.toJson(),
      if (code != null) 'code': code,
      'name': name,
      if (street != null) 'street': street,
      if (streetNumber != null) 'streetNumber': streetNumber,
      if (complement != null) 'complement': complement,
      if (district != null) 'district': district,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (postalCode != null) 'postalCode': postalCode,
      'countryCode': countryCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (phone != null) 'phone': phone,
      if (accessNotes != null) 'accessNotes': accessNotes,
      if (serviceAreaId != null) 'serviceAreaId': serviceAreaId?.toJson(),
      'isActive': isActive,
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  static CustomerSiteInclude include() {
    return CustomerSiteInclude._();
  }

  static CustomerSiteIncludeList includeList({
    _is.WhereExpressionBuilder<CustomerSiteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerSiteTable>? orderBy,
    _is.OrderByListBuilder<CustomerSiteTable>? orderByList,
    CustomerSiteInclude? include,
  }) {
    return CustomerSiteIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomerSite.t),
      orderByList: orderByList?.call(CustomerSite.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerSiteImpl extends CustomerSite {
  _CustomerSiteImpl({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required _is.UuidValue customerId,
    String? code,
    required String name,
    String? street,
    String? streetNumber,
    String? complement,
    String? district,
    String? city,
    String? state,
    String? postalCode,
    required String countryCode,
    double? latitude,
    double? longitude,
    String? phone,
    String? accessNotes,
    _is.UuidValue? serviceAreaId,
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
         customerId: customerId,
         code: code,
         name: name,
         street: street,
         streetNumber: streetNumber,
         complement: complement,
         district: district,
         city: city,
         state: state,
         postalCode: postalCode,
         countryCode: countryCode,
         latitude: latitude,
         longitude: longitude,
         phone: phone,
         accessNotes: accessNotes,
         serviceAreaId: serviceAreaId,
         isActive: isActive,
         source: source,
         externalSystem: externalSystem,
         externalId: externalId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [CustomerSite]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CustomerSite copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    _is.UuidValue? customerId,
    Object? code = _Undefined,
    String? name,
    Object? street = _Undefined,
    Object? streetNumber = _Undefined,
    Object? complement = _Undefined,
    Object? district = _Undefined,
    Object? city = _Undefined,
    Object? state = _Undefined,
    Object? postalCode = _Undefined,
    String? countryCode,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? phone = _Undefined,
    Object? accessNotes = _Undefined,
    _is.UuidValue? serviceAreaId = const _is.$UndefinedUuidValue(),
    bool? isActive,
    _i1c87mer.RecordSource? source,
    Object? externalSystem = _Undefined,
    Object? externalId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return CustomerSite(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      customerId: customerId ?? this.customerId,
      code: code is String? ? code : this.code,
      name: name ?? this.name,
      street: street is String? ? street : this.street,
      streetNumber: streetNumber is String? ? streetNumber : this.streetNumber,
      complement: complement is String? ? complement : this.complement,
      district: district is String? ? district : this.district,
      city: city is String? ? city : this.city,
      state: state is String? ? state : this.state,
      postalCode: postalCode is String? ? postalCode : this.postalCode,
      countryCode: countryCode ?? this.countryCode,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      phone: phone is String? ? phone : this.phone,
      accessNotes: accessNotes is String? ? accessNotes : this.accessNotes,
      serviceAreaId: serviceAreaId is _is.UndefinedSentinel ? this.serviceAreaId : serviceAreaId,
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

class CustomerSiteUpdateTable extends _is.UpdateTable<CustomerSiteTable> {
  CustomerSiteUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> tenantId(_is.UuidValue value) => _is.ColumnValue(
    table.tenantId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> customerId(_is.UuidValue value) => _is.ColumnValue(
    table.customerId,
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

  _is.ColumnValue<String, String> street(String? value) => _is.ColumnValue(
    table.street,
    value,
  );

  _is.ColumnValue<String, String> streetNumber(String? value) => _is.ColumnValue(
    table.streetNumber,
    value,
  );

  _is.ColumnValue<String, String> complement(String? value) => _is.ColumnValue(
    table.complement,
    value,
  );

  _is.ColumnValue<String, String> district(String? value) => _is.ColumnValue(
    table.district,
    value,
  );

  _is.ColumnValue<String, String> city(String? value) => _is.ColumnValue(
    table.city,
    value,
  );

  _is.ColumnValue<String, String> state(String? value) => _is.ColumnValue(
    table.state,
    value,
  );

  _is.ColumnValue<String, String> postalCode(String? value) => _is.ColumnValue(
    table.postalCode,
    value,
  );

  _is.ColumnValue<String, String> countryCode(String value) => _is.ColumnValue(
    table.countryCode,
    value,
  );

  _is.ColumnValue<double, double> latitude(double? value) => _is.ColumnValue(
    table.latitude,
    value,
  );

  _is.ColumnValue<double, double> longitude(double? value) => _is.ColumnValue(
    table.longitude,
    value,
  );

  _is.ColumnValue<String, String> phone(String? value) => _is.ColumnValue(
    table.phone,
    value,
  );

  _is.ColumnValue<String, String> accessNotes(String? value) => _is.ColumnValue(
    table.accessNotes,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> serviceAreaId(_is.UuidValue? value) => _is.ColumnValue(
    table.serviceAreaId,
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

class CustomerSiteTable extends _is.Table<_is.UuidValue> {
  CustomerSiteTable({super.tableRelation}) : super(tableName: 'customer_sites') {
    updateTable = CustomerSiteUpdateTable(this);
    tenantId = _is.ColumnUuid(
      'tenant_id',
      this,
      fieldName: 'tenantId',
    );
    customerId = _is.ColumnUuid(
      'customer_id',
      this,
      fieldName: 'customerId',
    );
    code = _is.ColumnString(
      'code',
      this,
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    street = _is.ColumnString(
      'street',
      this,
    );
    streetNumber = _is.ColumnString(
      'street_number',
      this,
      fieldName: 'streetNumber',
    );
    complement = _is.ColumnString(
      'complement',
      this,
    );
    district = _is.ColumnString(
      'district',
      this,
    );
    city = _is.ColumnString(
      'city',
      this,
    );
    state = _is.ColumnString(
      'state',
      this,
    );
    postalCode = _is.ColumnString(
      'postal_code',
      this,
      fieldName: 'postalCode',
    );
    countryCode = _is.ColumnString(
      'country_code',
      this,
      fieldName: 'countryCode',
    );
    latitude = _is.ColumnDouble(
      'latitude',
      this,
    );
    longitude = _is.ColumnDouble(
      'longitude',
      this,
    );
    phone = _is.ColumnString(
      'phone',
      this,
    );
    accessNotes = _is.ColumnString(
      'access_notes',
      this,
      fieldName: 'accessNotes',
    );
    serviceAreaId = _is.ColumnUuid(
      'service_area_id',
      this,
      fieldName: 'serviceAreaId',
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

  late final CustomerSiteUpdateTable updateTable;

  late final _is.ColumnUuid tenantId;

  late final _is.ColumnUuid customerId;

  late final _is.ColumnString code;

  late final _is.ColumnString name;

  late final _is.ColumnString street;

  late final _is.ColumnString streetNumber;

  late final _is.ColumnString complement;

  late final _is.ColumnString district;

  late final _is.ColumnString city;

  late final _is.ColumnString state;

  late final _is.ColumnString postalCode;

  late final _is.ColumnString countryCode;

  late final _is.ColumnDouble latitude;

  late final _is.ColumnDouble longitude;

  late final _is.ColumnString phone;

  late final _is.ColumnString accessNotes;

  late final _is.ColumnUuid serviceAreaId;

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
    customerId,
    code,
    name,
    street,
    streetNumber,
    complement,
    district,
    city,
    state,
    postalCode,
    countryCode,
    latitude,
    longitude,
    phone,
    accessNotes,
    serviceAreaId,
    isActive,
    source,
    externalSystem,
    externalId,
    createdAt,
    updatedAt,
    version,
  ];
}

class CustomerSiteInclude extends _is.IncludeObject {
  CustomerSiteInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue> get table => CustomerSite.t;
}

class CustomerSiteIncludeList extends _is.IncludeList {
  CustomerSiteIncludeList._({
    _is.WhereExpressionBuilder<CustomerSiteTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CustomerSite.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue> get table => CustomerSite.t;
}

class CustomerSiteRepository {
  const CustomerSiteRepository._();

  /// Returns a list of [CustomerSite]s matching the given query parameters.
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
  Future<List<CustomerSite>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerSiteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerSiteTable>? orderBy,
    _is.OrderByListBuilder<CustomerSiteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CustomerSite>(
      where: where?.call(CustomerSite.t),
      orderBy: orderBy?.call(CustomerSite.t),
      orderByList: orderByList?.call(CustomerSite.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [CustomerSite]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `CustomerSite.t`.
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
  _ida.Stream<List<CustomerSite>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerSiteTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerSiteTable>? orderBy,
    _is.OrderByListBuilder<CustomerSiteTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<CustomerSite>(
      where: where?.call(CustomerSite.t),
      orderBy: orderBy?.call(CustomerSite.t),
      orderByList: orderByList?.call(CustomerSite.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [CustomerSite] matching the given query parameters.
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
  Future<CustomerSite?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerSiteTable>? where,
    int? offset,
    _is.OrderByBuilder<CustomerSiteTable>? orderBy,
    _is.OrderByListBuilder<CustomerSiteTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CustomerSite>(
      where: where?.call(CustomerSite.t),
      orderBy: orderBy?.call(CustomerSite.t),
      orderByList: orderByList?.call(CustomerSite.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CustomerSite] by its [id] or null if no such row exists.
  Future<CustomerSite?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CustomerSite>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CustomerSite]s in the list and returns the inserted rows.
  ///
  /// The returned [CustomerSite]s will have their `id` fields set.
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
  Future<List<CustomerSite>> insert(
    _is.DatabaseSession session,
    List<CustomerSite> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CustomerSite>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CustomerSite] and returns the inserted row.
  ///
  /// The returned [CustomerSite] will have its `id` field set.
  Future<CustomerSite> insertRow(
    _is.DatabaseSession session,
    CustomerSite row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CustomerSite>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CustomerSite]s in the list and returns the resulting rows.
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
  /// The returned [CustomerSite]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerSite>> upsert(
    _is.DatabaseSession session,
    List<CustomerSite> rows, {
    required _is.ColumnSelections<CustomerSiteTable> conflictColumns,
    _is.ColumnSelections<CustomerSiteTable>? updateColumns,
    _is.WhereExpressionBuilder<CustomerSiteTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CustomerSite>(
      rows,
      conflictColumns: conflictColumns(CustomerSite.t),
      updateColumns: updateColumns?.call(CustomerSite.t),
      updateWhere: updateWhere?.call(CustomerSite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CustomerSite] and returns the resulting row.
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
  /// The returned [CustomerSite] will have its `id` field set.
  Future<CustomerSite?> upsertRow(
    _is.DatabaseSession session,
    CustomerSite row, {
    required _is.ColumnSelections<CustomerSiteTable> conflictColumns,
    _is.ColumnSelections<CustomerSiteTable>? updateColumns,
    _is.WhereExpressionBuilder<CustomerSiteTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CustomerSite>(
      row,
      conflictColumns: conflictColumns(CustomerSite.t),
      updateColumns: updateColumns?.call(CustomerSite.t),
      updateWhere: updateWhere?.call(CustomerSite.t),
      transaction: transaction,
    );
  }

  /// Updates all [CustomerSite]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerSite>> update(
    _is.DatabaseSession session,
    List<CustomerSite> rows, {
    _is.ColumnSelections<CustomerSiteTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CustomerSite>(
      rows,
      columns: columns?.call(CustomerSite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CustomerSite]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CustomerSite> updateRow(
    _is.DatabaseSession session,
    CustomerSite row, {
    _is.ColumnSelections<CustomerSiteTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CustomerSite>(
      row,
      columns: columns?.call(CustomerSite.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CustomerSite] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CustomerSite?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CustomerSiteUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CustomerSite>(
      id,
      columnValues: columnValues(CustomerSite.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CustomerSite]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerSite>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CustomerSiteUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CustomerSiteTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerSiteTable>? orderBy,
    _is.OrderByListBuilder<CustomerSiteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CustomerSite>(
      columnValues: columnValues(CustomerSite.t.updateTable),
      where: where(CustomerSite.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomerSite.t),
      orderByList: orderByList?.call(CustomerSite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CustomerSite]s in the list and returns the deleted rows.
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
  Future<List<CustomerSite>> delete(
    _is.DatabaseSession session,
    List<CustomerSite> rows, {
    _is.OrderByBuilder<CustomerSiteTable>? orderBy,
    _is.OrderByListBuilder<CustomerSiteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CustomerSite>(
      rows,
      orderBy: orderBy?.call(CustomerSite.t),
      orderByList: orderByList?.call(CustomerSite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CustomerSite].
  Future<CustomerSite> deleteRow(
    _is.DatabaseSession session,
    CustomerSite row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CustomerSite>(
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
  Future<List<CustomerSite>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CustomerSiteTable> where,
    _is.OrderByBuilder<CustomerSiteTable>? orderBy,
    _is.OrderByListBuilder<CustomerSiteTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CustomerSite>(
      where: where(CustomerSite.t),
      orderBy: orderBy?.call(CustomerSite.t),
      orderByList: orderByList?.call(CustomerSite.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerSiteTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CustomerSite>(
      where: where?.call(CustomerSite.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CustomerSite] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CustomerSiteTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CustomerSite>(
      where: where(CustomerSite.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
