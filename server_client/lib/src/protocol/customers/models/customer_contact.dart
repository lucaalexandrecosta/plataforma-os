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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../customers/models/contact_origin.dart' as _ivbafdqe;
import '../../customers/models/contact_role.dart' as _itul20yk;
import '../../customers/models/contact_status.dart' as _iaj79viq;
import '../../customers/models/notification_channel.dart' as _ibtcv0am;
import '../../platform/models/record_source.dart' as _i1c87mer;

abstract class CustomerContact implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerContact._({
    _isc.UuidValue? id,
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
  }) : id = id ?? const _isc.Uuid().v7obj();

  factory CustomerContact({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required _isc.UuidValue customerId,
    _isc.UuidValue? customerSiteId,
    _isc.UuidValue? userId,
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
    _isc.UuidValue? approvedBy,
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
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      tenantId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['tenantId']),
      customerId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['customerId']),
      customerSiteId: jsonSerialization['customerSiteId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['customerSiteId']),
      userId: jsonSerialization['userId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['userId']),
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      phoneE164: jsonSerialization['phoneE164'] as String?,
      jobTitle: jsonSerialization['jobTitle'] as String?,
      contactRole: _itul20yk.ContactRole.fromJson((jsonSerialization['contactRole'] as String)),
      status: _iaj79viq.ContactStatus.fromJson((jsonSerialization['status'] as String)),
      origin: _ivbafdqe.ContactOrigin.fromJson((jsonSerialization['origin'] as String)),
      canOpenRequests: _isc.BoolJsonExtension.fromJson(jsonSerialization['canOpenRequests']),
      preferredChannel: jsonSerialization['preferredChannel'] == null
          ? null
          : _ibtcv0am.NotificationChannel.fromJson((jsonSerialization['preferredChannel'] as String)),
      whatsappOptInAt: jsonSerialization['whatsappOptInAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['whatsappOptInAt']),
      approvedAt: jsonSerialization['approvedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['approvedAt']),
      approvedBy: jsonSerialization['approvedBy'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['approvedBy']),
      blockedReason: jsonSerialization['blockedReason'] as String?,
      lastLoginAt: jsonSerialization['lastLoginAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['lastLoginAt']),
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      source: _i1c87mer.RecordSource.fromJson((jsonSerialization['source'] as String)),
      externalSystem: jsonSerialization['externalSystem'] as String?,
      externalId: jsonSerialization['externalId'] as String?,
      createdAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      version: jsonSerialization['version'] as int,
    );
  }

  /// The id of the object.
  _isc.UuidValue id;

  _isc.UuidValue tenantId;

  _isc.UuidValue customerId;

  _isc.UuidValue? customerSiteId;

  _isc.UuidValue? userId;

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

  _isc.UuidValue? approvedBy;

  String? blockedReason;

  DateTime? lastLoginAt;

  bool isActive;

  _i1c87mer.RecordSource source;

  String? externalSystem;

  String? externalId;

  DateTime createdAt;

  DateTime updatedAt;

  int version;

  /// Returns a shallow copy of this [CustomerContact]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerContact copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    _isc.UuidValue? customerId,
    _isc.UuidValue? customerSiteId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? userId = const _isc.$UndefinedUuidValue(),
    String? name,
    String? email,
    String? phoneE164,
    String? jobTitle,
    _itul20yk.ContactRole? contactRole,
    _iaj79viq.ContactStatus? status,
    _ivbafdqe.ContactOrigin? origin,
    bool? canOpenRequests,
    _ibtcv0am.NotificationChannel? preferredChannel,
    DateTime? whatsappOptInAt = const _isc.$UndefinedDateTime(),
    DateTime? approvedAt = const _isc.$UndefinedDateTime(),
    _isc.UuidValue? approvedBy = const _isc.$UndefinedUuidValue(),
    String? blockedReason,
    DateTime? lastLoginAt = const _isc.$UndefinedDateTime(),
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerContactImpl extends CustomerContact {
  _CustomerContactImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue tenantId,
    required _isc.UuidValue customerId,
    _isc.UuidValue? customerSiteId,
    _isc.UuidValue? userId,
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
    _isc.UuidValue? approvedBy,
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
  @_isc.useResult
  @override
  CustomerContact copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? tenantId,
    _isc.UuidValue? customerId,
    _isc.UuidValue? customerSiteId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? userId = const _isc.$UndefinedUuidValue(),
    String? name,
    Object? email = _Undefined,
    Object? phoneE164 = _Undefined,
    Object? jobTitle = _Undefined,
    _itul20yk.ContactRole? contactRole,
    _iaj79viq.ContactStatus? status,
    _ivbafdqe.ContactOrigin? origin,
    bool? canOpenRequests,
    Object? preferredChannel = _Undefined,
    DateTime? whatsappOptInAt = const _isc.$UndefinedDateTime(),
    DateTime? approvedAt = const _isc.$UndefinedDateTime(),
    _isc.UuidValue? approvedBy = const _isc.$UndefinedUuidValue(),
    Object? blockedReason = _Undefined,
    DateTime? lastLoginAt = const _isc.$UndefinedDateTime(),
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
      customerSiteId: customerSiteId is _isc.UndefinedSentinel ? this.customerSiteId : customerSiteId,
      userId: userId is _isc.UndefinedSentinel ? this.userId : userId,
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      phoneE164: phoneE164 is String? ? phoneE164 : this.phoneE164,
      jobTitle: jobTitle is String? ? jobTitle : this.jobTitle,
      contactRole: contactRole ?? this.contactRole,
      status: status ?? this.status,
      origin: origin ?? this.origin,
      canOpenRequests: canOpenRequests ?? this.canOpenRequests,
      preferredChannel: preferredChannel is _ibtcv0am.NotificationChannel? ? preferredChannel : this.preferredChannel,
      whatsappOptInAt: whatsappOptInAt is _isc.UndefinedSentinel ? this.whatsappOptInAt : whatsappOptInAt,
      approvedAt: approvedAt is _isc.UndefinedSentinel ? this.approvedAt : approvedAt,
      approvedBy: approvedBy is _isc.UndefinedSentinel ? this.approvedBy : approvedBy,
      blockedReason: blockedReason is String? ? blockedReason : this.blockedReason,
      lastLoginAt: lastLoginAt is _isc.UndefinedSentinel ? this.lastLoginAt : lastLoginAt,
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
