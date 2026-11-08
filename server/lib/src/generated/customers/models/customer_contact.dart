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
import '../../customers/models/contact_origin.dart' as _ivbafdqe;
import '../../customers/models/contact_role.dart' as _itul20yk;
import '../../customers/models/contact_status.dart' as _iaj79viq;
import '../../customers/models/notification_channel.dart' as _ibtcv0am;
import '../../platform/models/record_source.dart' as _i1c87mer;

abstract class CustomerContact implements _is.TableRow<_is.UuidValue>, _is.ProtocolSerialization {
  CustomerContact._({
    _is.UuidValue? id,
    required this.tenantId,
    required this.customerId,
    this.customerSiteId,
    this.userId,
    required this.name,
    this.email,
    this.phoneE164,
    this.jobTitle,
    required this.contactRole,
    required this.status,
    required this.origin,
    required this.canOpenRequests,
    this.preferredChannel,
    this.whatsappOptInAt,
    this.approvedAt,
    this.approvedBy,
    this.blockedReason,
    this.lastLoginAt,
    required this.isActive,
    required this.source,
    this.externalSystem,
    this.externalId,
    required this.createdAt,
    required this.updatedAt,
    required this.version,
  }) : id = id ?? const _is.Uuid().v7obj();

  factory CustomerContact({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required _is.UuidValue customerId,
    _is.UuidValue? customerSiteId,
    _is.UuidValue? userId,
    required String name,
    String? email,
    String? phoneE164,
    String? jobTitle,
    required _itul20yk.ContactRole contactRole,
    required _iaj79viq.ContactStatus status,
    required _ivbafdqe.ContactOrigin origin,
    required bool canOpenRequests,
    _ibtcv0am.NotificationChannel? preferredChannel,
    DateTime? whatsappOptInAt,
    DateTime? approvedAt,
    _is.UuidValue? approvedBy,
    String? blockedReason,
    DateTime? lastLoginAt,
    required bool isActive,
    required _i1c87mer.RecordSource source,
    String? externalSystem,
    String? externalId,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int version,
  }) = _CustomerContactImpl;

  factory CustomerContact.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerContact(
      id: jsonSerialization['id'] == null ? null : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      customerId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['customerId']),
      customerSiteId: jsonSerialization['customerSiteId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['customerSiteId']),
      userId: jsonSerialization['userId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      phoneE164: jsonSerialization['phoneE164'] as String?,
      jobTitle: jsonSerialization['jobTitle'] as String?,
      contactRole: _itul20yk.ContactRole.fromJson((jsonSerialization['contactRole'] as String)),
      status: _iaj79viq.ContactStatus.fromJson((jsonSerialization['status'] as String)),
      origin: _ivbafdqe.ContactOrigin.fromJson((jsonSerialization['origin'] as String)),
      canOpenRequests: _is.BoolJsonExtension.fromJson(jsonSerialization['canOpenRequests']),
      preferredChannel: jsonSerialization['preferredChannel'] == null
          ? null
          : _ibtcv0am.NotificationChannel.fromJson((jsonSerialization['preferredChannel'] as String)),
      whatsappOptInAt: jsonSerialization['whatsappOptInAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['whatsappOptInAt']),
      approvedAt: jsonSerialization['approvedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['approvedAt']),
      approvedBy: jsonSerialization['approvedBy'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['approvedBy']),
      blockedReason: jsonSerialization['blockedReason'] as String?,
      lastLoginAt: jsonSerialization['lastLoginAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['lastLoginAt']),
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      source: _i1c87mer.RecordSource.fromJson((jsonSerialization['source'] as String)),
      externalSystem: jsonSerialization['externalSystem'] as String?,
      externalId: jsonSerialization['externalId'] as String?,
      createdAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  static final t = CustomerContactTable();

  static const db = CustomerContactRepository._();

  @override
  _is.UuidValue id;

  _is.UuidValue tenantId;

  _is.UuidValue customerId;

  _is.UuidValue? customerSiteId;

  _is.UuidValue? userId;

  String name;

  String? email;

  String? phoneE164;

  String? jobTitle;

  _itul20yk.ContactRole contactRole;

  _iaj79viq.ContactStatus status;

  _ivbafdqe.ContactOrigin origin;

  bool canOpenRequests;

  _ibtcv0am.NotificationChannel? preferredChannel;

  DateTime? whatsappOptInAt;

  DateTime? approvedAt;

  _is.UuidValue? approvedBy;

  String? blockedReason;

  DateTime? lastLoginAt;

  bool isActive;

  _i1c87mer.RecordSource source;

  String? externalSystem;

  String? externalId;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  @override
  _is.Table<_is.UuidValue> get table => t;

  /// Returns a shallow copy of this [CustomerContact]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CustomerContact copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    _is.UuidValue? customerId,
    _is.UuidValue? customerSiteId = const _is.$UndefinedUuidValue(),
    _is.UuidValue? userId = const _is.$UndefinedUuidValue(),
    String? name,
    String? email,
    String? phoneE164,
    String? jobTitle,
    _itul20yk.ContactRole? contactRole,
    _iaj79viq.ContactStatus? status,
    _ivbafdqe.ContactOrigin? origin,
    bool? canOpenRequests,
    _ibtcv0am.NotificationChannel? preferredChannel,
    DateTime? whatsappOptInAt = const _is.$UndefinedDateTime(),
    DateTime? approvedAt = const _is.$UndefinedDateTime(),
    _is.UuidValue? approvedBy = const _is.$UndefinedUuidValue(),
    String? blockedReason,
    DateTime? lastLoginAt = const _is.$UndefinedDateTime(),
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
      '__className__': 'CustomerContact',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'customerId': customerId.toJson(),
      if (customerSiteId != null) 'customerSiteId': customerSiteId?.toJson(),
      if (userId != null) 'userId': userId?.toJson(),
      'name': name,
      if (email != null) 'email': email,
      if (phoneE164 != null) 'phoneE164': phoneE164,
      if (jobTitle != null) 'jobTitle': jobTitle,
      'contactRole': contactRole.toJson(),
      'status': status.toJson(),
      'origin': origin.toJson(),
      'canOpenRequests': canOpenRequests,
      if (preferredChannel != null) 'preferredChannel': preferredChannel?.toJson(),
      if (whatsappOptInAt != null) 'whatsappOptInAt': whatsappOptInAt?.toJson(),
      if (approvedAt != null) 'approvedAt': approvedAt?.toJson(),
      if (approvedBy != null) 'approvedBy': approvedBy?.toJson(),
      if (blockedReason != null) 'blockedReason': blockedReason,
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
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
      '__className__': 'CustomerContact',
      'id': id.toJson(),
      'tenantId': tenantId.toJson(),
      'customerId': customerId.toJson(),
      if (customerSiteId != null) 'customerSiteId': customerSiteId?.toJson(),
      if (userId != null) 'userId': userId?.toJson(),
      'name': name,
      if (email != null) 'email': email,
      if (phoneE164 != null) 'phoneE164': phoneE164,
      if (jobTitle != null) 'jobTitle': jobTitle,
      'contactRole': contactRole.toJson(),
      'status': status.toJson(),
      'origin': origin.toJson(),
      'canOpenRequests': canOpenRequests,
      if (preferredChannel != null) 'preferredChannel': preferredChannel?.toJson(),
      if (whatsappOptInAt != null) 'whatsappOptInAt': whatsappOptInAt?.toJson(),
      if (approvedAt != null) 'approvedAt': approvedAt?.toJson(),
      if (approvedBy != null) 'approvedBy': approvedBy?.toJson(),
      if (blockedReason != null) 'blockedReason': blockedReason,
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt?.toJson(),
      'isActive': isActive,
      'source': source.toJson(),
      if (externalSystem != null) 'externalSystem': externalSystem,
      if (externalId != null) 'externalId': externalId,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      'version': version,
    };
  }

  static CustomerContactInclude include() {
    return CustomerContactInclude._();
  }

  static CustomerContactIncludeList includeList({
    _is.WhereExpressionBuilder<CustomerContactTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerContactTable>? orderBy,
    _is.OrderByListBuilder<CustomerContactTable>? orderByList,
    CustomerContactInclude? include,
  }) {
    return CustomerContactIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomerContact.t),
      orderByList: orderByList?.call(CustomerContact.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerContactImpl extends CustomerContact {
  _CustomerContactImpl({
    _is.UuidValue? id,
    required _is.UuidValue tenantId,
    required _is.UuidValue customerId,
    _is.UuidValue? customerSiteId,
    _is.UuidValue? userId,
    required String name,
    String? email,
    String? phoneE164,
    String? jobTitle,
    required _itul20yk.ContactRole contactRole,
    required _iaj79viq.ContactStatus status,
    required _ivbafdqe.ContactOrigin origin,
    required bool canOpenRequests,
    _ibtcv0am.NotificationChannel? preferredChannel,
    DateTime? whatsappOptInAt,
    DateTime? approvedAt,
    _is.UuidValue? approvedBy,
    String? blockedReason,
    DateTime? lastLoginAt,
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
         customerSiteId: customerSiteId,
         userId: userId,
         name: name,
         email: email,
         phoneE164: phoneE164,
         jobTitle: jobTitle,
         contactRole: contactRole,
         status: status,
         origin: origin,
         canOpenRequests: canOpenRequests,
         preferredChannel: preferredChannel,
         whatsappOptInAt: whatsappOptInAt,
         approvedAt: approvedAt,
         approvedBy: approvedBy,
         blockedReason: blockedReason,
         lastLoginAt: lastLoginAt,
         isActive: isActive,
         source: source,
         externalSystem: externalSystem,
         externalId: externalId,
         createdAt: createdAt,
         updatedAt: updatedAt,
         version: version,
       );

  /// Returns a shallow copy of this [CustomerContact]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CustomerContact copyWith({
    _is.UuidValue? id,
    _is.UuidValue? tenantId,
    _is.UuidValue? customerId,
    _is.UuidValue? customerSiteId = const _is.$UndefinedUuidValue(),
    _is.UuidValue? userId = const _is.$UndefinedUuidValue(),
    String? name,
    Object? email = _Undefined,
    Object? phoneE164 = _Undefined,
    Object? jobTitle = _Undefined,
    _itul20yk.ContactRole? contactRole,
    _iaj79viq.ContactStatus? status,
    _ivbafdqe.ContactOrigin? origin,
    bool? canOpenRequests,
    Object? preferredChannel = _Undefined,
    DateTime? whatsappOptInAt = const _is.$UndefinedDateTime(),
    DateTime? approvedAt = const _is.$UndefinedDateTime(),
    _is.UuidValue? approvedBy = const _is.$UndefinedUuidValue(),
    Object? blockedReason = _Undefined,
    DateTime? lastLoginAt = const _is.$UndefinedDateTime(),
    bool? isActive,
    _i1c87mer.RecordSource? source,
    Object? externalSystem = _Undefined,
    Object? externalId = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? version,
  }) {
    return CustomerContact(
      id: id ?? this.id,
      tenantId: tenantId ?? this.tenantId,
      customerId: customerId ?? this.customerId,
      customerSiteId: customerSiteId is _is.UndefinedSentinel ? this.customerSiteId : customerSiteId,
      userId: userId is _is.UndefinedSentinel ? this.userId : userId,
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      phoneE164: phoneE164 is String? ? phoneE164 : this.phoneE164,
      jobTitle: jobTitle is String? ? jobTitle : this.jobTitle,
      contactRole: contactRole ?? this.contactRole,
      status: status ?? this.status,
      origin: origin ?? this.origin,
      canOpenRequests: canOpenRequests ?? this.canOpenRequests,
      preferredChannel: preferredChannel is _ibtcv0am.NotificationChannel? ? preferredChannel : this.preferredChannel,
      whatsappOptInAt: whatsappOptInAt is _is.UndefinedSentinel ? this.whatsappOptInAt : whatsappOptInAt,
      approvedAt: approvedAt is _is.UndefinedSentinel ? this.approvedAt : approvedAt,
      approvedBy: approvedBy is _is.UndefinedSentinel ? this.approvedBy : approvedBy,
      blockedReason: blockedReason is String? ? blockedReason : this.blockedReason,
      lastLoginAt: lastLoginAt is _is.UndefinedSentinel ? this.lastLoginAt : lastLoginAt,
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

class CustomerContactUpdateTable extends _is.UpdateTable<CustomerContactTable> {
  CustomerContactUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> tenantId(_is.UuidValue value) => _is.ColumnValue(
    table.tenantId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> customerId(_is.UuidValue value) => _is.ColumnValue(
    table.customerId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> customerSiteId(_is.UuidValue? value) => _is.ColumnValue(
    table.customerSiteId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> userId(_is.UuidValue? value) => _is.ColumnValue(
    table.userId,
    value,
  );

  _is.ColumnValue<String, String> name(String value) => _is.ColumnValue(
    table.name,
    value,
  );

  _is.ColumnValue<String, String> email(String? value) => _is.ColumnValue(
    table.email,
    value,
  );

  _is.ColumnValue<String, String> phoneE164(String? value) => _is.ColumnValue(
    table.phoneE164,
    value,
  );

  _is.ColumnValue<String, String> jobTitle(String? value) => _is.ColumnValue(
    table.jobTitle,
    value,
  );

  _is.ColumnValue<_itul20yk.ContactRole, _itul20yk.ContactRole> contactRole(_itul20yk.ContactRole value) =>
      _is.ColumnValue(
        table.contactRole,
        value,
      );

  _is.ColumnValue<_iaj79viq.ContactStatus, _iaj79viq.ContactStatus> status(_iaj79viq.ContactStatus value) =>
      _is.ColumnValue(
        table.status,
        value,
      );

  _is.ColumnValue<_ivbafdqe.ContactOrigin, _ivbafdqe.ContactOrigin> origin(_ivbafdqe.ContactOrigin value) =>
      _is.ColumnValue(
        table.origin,
        value,
      );

  _is.ColumnValue<bool, bool> canOpenRequests(bool value) => _is.ColumnValue(
    table.canOpenRequests,
    value,
  );

  _is.ColumnValue<_ibtcv0am.NotificationChannel, _ibtcv0am.NotificationChannel> preferredChannel(
    _ibtcv0am.NotificationChannel? value,
  ) => _is.ColumnValue(
    table.preferredChannel,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> whatsappOptInAt(DateTime? value) => _is.ColumnValue(
    table.whatsappOptInAt,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> approvedAt(DateTime? value) => _is.ColumnValue(
    table.approvedAt,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> approvedBy(_is.UuidValue? value) => _is.ColumnValue(
    table.approvedBy,
    value,
  );

  _is.ColumnValue<String, String> blockedReason(String? value) => _is.ColumnValue(
    table.blockedReason,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> lastLoginAt(DateTime? value) => _is.ColumnValue(
    table.lastLoginAt,
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

class CustomerContactTable extends _is.Table<_is.UuidValue> {
  CustomerContactTable({super.tableRelation}) : super(tableName: 'customer_contacts') {
    updateTable = CustomerContactUpdateTable(this);
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
    customerSiteId = _is.ColumnUuid(
      'customer_site_id',
      this,
      fieldName: 'customerSiteId',
    );
    userId = _is.ColumnUuid(
      'user_id',
      this,
      fieldName: 'userId',
    );
    name = _is.ColumnString(
      'name',
      this,
    );
    email = _is.ColumnString(
      'email',
      this,
    );
    phoneE164 = _is.ColumnString(
      'phone_e164',
      this,
      fieldName: 'phoneE164',
    );
    jobTitle = _is.ColumnString(
      'job_title',
      this,
      fieldName: 'jobTitle',
    );
    contactRole = _is.ColumnEnum(
      'contact_role',
      this,
      _is.EnumSerialization.byName,
      fieldName: 'contactRole',
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    origin = _is.ColumnEnum(
      'origin',
      this,
      _is.EnumSerialization.byName,
    );
    canOpenRequests = _is.ColumnBool(
      'can_open_requests',
      this,
      fieldName: 'canOpenRequests',
    );
    preferredChannel = _is.ColumnEnum(
      'preferred_channel',
      this,
      _is.EnumSerialization.byName,
      fieldName: 'preferredChannel',
    );
    whatsappOptInAt = _is.ColumnDateTime(
      'whatsapp_opt_in_at',
      this,
      fieldName: 'whatsappOptInAt',
    );
    approvedAt = _is.ColumnDateTime(
      'approved_at',
      this,
      fieldName: 'approvedAt',
    );
    approvedBy = _is.ColumnUuid(
      'approved_by',
      this,
      fieldName: 'approvedBy',
    );
    blockedReason = _is.ColumnString(
      'blocked_reason',
      this,
      fieldName: 'blockedReason',
    );
    lastLoginAt = _is.ColumnDateTime(
      'last_login_at',
      this,
      fieldName: 'lastLoginAt',
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

  late final CustomerContactUpdateTable updateTable;

  late final _is.ColumnUuid tenantId;

  late final _is.ColumnUuid customerId;

  late final _is.ColumnUuid customerSiteId;

  late final _is.ColumnUuid userId;

  late final _is.ColumnString name;

  late final _is.ColumnString email;

  late final _is.ColumnString phoneE164;

  late final _is.ColumnString jobTitle;

  late final _is.ColumnEnum<_itul20yk.ContactRole> contactRole;

  late final _is.ColumnEnum<_iaj79viq.ContactStatus> status;

  late final _is.ColumnEnum<_ivbafdqe.ContactOrigin> origin;

  late final _is.ColumnBool canOpenRequests;

  late final _is.ColumnEnum<_ibtcv0am.NotificationChannel> preferredChannel;

  late final _is.ColumnDateTime whatsappOptInAt;

  late final _is.ColumnDateTime approvedAt;

  late final _is.ColumnUuid approvedBy;

  late final _is.ColumnString blockedReason;

  late final _is.ColumnDateTime lastLoginAt;

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
    customerSiteId,
    userId,
    name,
    email,
    phoneE164,
    jobTitle,
    contactRole,
    status,
    origin,
    canOpenRequests,
    preferredChannel,
    whatsappOptInAt,
    approvedAt,
    approvedBy,
    blockedReason,
    lastLoginAt,
    isActive,
    source,
    externalSystem,
    externalId,
    createdAt,
    updatedAt,
    version,
  ];
}

class CustomerContactInclude extends _is.IncludeObject {
  CustomerContactInclude._();

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<_is.UuidValue> get table => CustomerContact.t;
}

class CustomerContactIncludeList extends _is.IncludeList {
  CustomerContactIncludeList._({
    _is.WhereExpressionBuilder<CustomerContactTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(CustomerContact.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue> get table => CustomerContact.t;
}

class CustomerContactRepository {
  const CustomerContactRepository._();

  /// Returns a list of [CustomerContact]s matching the given query parameters.
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
  Future<List<CustomerContact>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerContactTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerContactTable>? orderBy,
    _is.OrderByListBuilder<CustomerContactTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<CustomerContact>(
      where: where?.call(CustomerContact.t),
      orderBy: orderBy?.call(CustomerContact.t),
      orderByList: orderByList?.call(CustomerContact.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Emits [CustomerContact]s matching the given query parameters every time the
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
  /// to that set. Pass [Table] instances such as `CustomerContact.t`.
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
  _ida.Stream<List<CustomerContact>> watch(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerContactTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerContactTable>? orderBy,
    _is.OrderByListBuilder<CustomerContactTable>? orderByList,
    Duration? throttle = const Duration(milliseconds: 30),
    Iterable<_is.Table>? alsoTriggerOnTables,
  }) {
    return session.db.watch<CustomerContact>(
      where: where?.call(CustomerContact.t),
      orderBy: orderBy?.call(CustomerContact.t),
      orderByList: orderByList?.call(CustomerContact.t),
      limit: limit,
      offset: offset,
      throttle: throttle,
      alsoTriggerOnTables: alsoTriggerOnTables,
    );
  }

  /// Returns the first matching [CustomerContact] matching the given query parameters.
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
  Future<CustomerContact?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerContactTable>? where,
    int? offset,
    _is.OrderByBuilder<CustomerContactTable>? orderBy,
    _is.OrderByListBuilder<CustomerContactTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<CustomerContact>(
      where: where?.call(CustomerContact.t),
      orderBy: orderBy?.call(CustomerContact.t),
      orderByList: orderByList?.call(CustomerContact.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [CustomerContact] by its [id] or null if no such row exists.
  Future<CustomerContact?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<CustomerContact>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [CustomerContact]s in the list and returns the inserted rows.
  ///
  /// The returned [CustomerContact]s will have their `id` fields set.
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
  Future<List<CustomerContact>> insert(
    _is.DatabaseSession session,
    List<CustomerContact> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<CustomerContact>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [CustomerContact] and returns the inserted row.
  ///
  /// The returned [CustomerContact] will have its `id` field set.
  Future<CustomerContact> insertRow(
    _is.DatabaseSession session,
    CustomerContact row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<CustomerContact>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [CustomerContact]s in the list and returns the resulting rows.
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
  /// The returned [CustomerContact]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerContact>> upsert(
    _is.DatabaseSession session,
    List<CustomerContact> rows, {
    required _is.ColumnSelections<CustomerContactTable> conflictColumns,
    _is.ColumnSelections<CustomerContactTable>? updateColumns,
    _is.WhereExpressionBuilder<CustomerContactTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<CustomerContact>(
      rows,
      conflictColumns: conflictColumns(CustomerContact.t),
      updateColumns: updateColumns?.call(CustomerContact.t),
      updateWhere: updateWhere?.call(CustomerContact.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [CustomerContact] and returns the resulting row.
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
  /// The returned [CustomerContact] will have its `id` field set.
  Future<CustomerContact?> upsertRow(
    _is.DatabaseSession session,
    CustomerContact row, {
    required _is.ColumnSelections<CustomerContactTable> conflictColumns,
    _is.ColumnSelections<CustomerContactTable>? updateColumns,
    _is.WhereExpressionBuilder<CustomerContactTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<CustomerContact>(
      row,
      conflictColumns: conflictColumns(CustomerContact.t),
      updateColumns: updateColumns?.call(CustomerContact.t),
      updateWhere: updateWhere?.call(CustomerContact.t),
      transaction: transaction,
    );
  }

  /// Updates all [CustomerContact]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerContact>> update(
    _is.DatabaseSession session,
    List<CustomerContact> rows, {
    _is.ColumnSelections<CustomerContactTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<CustomerContact>(
      rows,
      columns: columns?.call(CustomerContact.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [CustomerContact]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<CustomerContact> updateRow(
    _is.DatabaseSession session,
    CustomerContact row, {
    _is.ColumnSelections<CustomerContactTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<CustomerContact>(
      row,
      columns: columns?.call(CustomerContact.t),
      transaction: transaction,
    );
  }

  /// Updates a single [CustomerContact] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<CustomerContact?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<CustomerContactUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<CustomerContact>(
      id,
      columnValues: columnValues(CustomerContact.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [CustomerContact]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<CustomerContact>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<CustomerContactUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<CustomerContactTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<CustomerContactTable>? orderBy,
    _is.OrderByListBuilder<CustomerContactTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<CustomerContact>(
      columnValues: columnValues(CustomerContact.t.updateTable),
      where: where(CustomerContact.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(CustomerContact.t),
      orderByList: orderByList?.call(CustomerContact.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [CustomerContact]s in the list and returns the deleted rows.
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
  Future<List<CustomerContact>> delete(
    _is.DatabaseSession session,
    List<CustomerContact> rows, {
    _is.OrderByBuilder<CustomerContactTable>? orderBy,
    _is.OrderByListBuilder<CustomerContactTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<CustomerContact>(
      rows,
      orderBy: orderBy?.call(CustomerContact.t),
      orderByList: orderByList?.call(CustomerContact.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [CustomerContact].
  Future<CustomerContact> deleteRow(
    _is.DatabaseSession session,
    CustomerContact row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<CustomerContact>(
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
  Future<List<CustomerContact>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CustomerContactTable> where,
    _is.OrderByBuilder<CustomerContactTable>? orderBy,
    _is.OrderByListBuilder<CustomerContactTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<CustomerContact>(
      where: where(CustomerContact.t),
      orderBy: orderBy?.call(CustomerContact.t),
      orderByList: orderByList?.call(CustomerContact.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<CustomerContactTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<CustomerContact>(
      where: where?.call(CustomerContact.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [CustomerContact] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<CustomerContactTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<CustomerContact>(
      where: where(CustomerContact.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
