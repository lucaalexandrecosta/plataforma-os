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

abstract class CustomerContact implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerContact._({
    required this.id,
    required this.customerId,
    this.customerSiteId,
    this.customerSiteName,
    required this.name,
    this.email,
    this.phone,
    this.jobTitle,
    required this.contactRole,
    required this.status,
    required this.canOpenRequests,
    this.preferredChannel,
    required this.isActive,
    required this.source,
    required this.version,
  });

  factory CustomerContact({
    required _isc.UuidValue id,
    required _isc.UuidValue customerId,
    _isc.UuidValue? customerSiteId,
    String? customerSiteName,
    required String name,
    String? email,
    String? phone,
    String? jobTitle,
    required String contactRole,
    required String status,
    required bool canOpenRequests,
    String? preferredChannel,
    required bool isActive,
    required String source,
    required int version,
  }) = _CustomerContactImpl;

  factory CustomerContact.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerContact(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      customerId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['customerId']),
      customerSiteId: jsonSerialization['customerSiteId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['customerSiteId']),
      customerSiteName: jsonSerialization['customerSiteName'] as String?,
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      jobTitle: jsonSerialization['jobTitle'] as String?,
      contactRole: jsonSerialization['contactRole'] as String,
      status: jsonSerialization['status'] as String,
      canOpenRequests: _isc.BoolJsonExtension.fromJson(jsonSerialization['canOpenRequests']),
      preferredChannel: jsonSerialization['preferredChannel'] as String?,
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      source: jsonSerialization['source'] as String,
      version: jsonSerialization['version'] as int,
    );
  }

  _isc.UuidValue id;

  _isc.UuidValue customerId;

  _isc.UuidValue? customerSiteId;

  String? customerSiteName;

  String name;

  String? email;

  String? phone;

  String? jobTitle;

  String contactRole;

  String status;

  bool canOpenRequests;

  String? preferredChannel;

  bool isActive;

  String source;

  int version;

  /// Returns a shallow copy of this [CustomerContact]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerContact copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? customerId,
    _isc.UuidValue? customerSiteId = const _isc.$UndefinedUuidValue(),
    String? customerSiteName,
    String? name,
    String? email,
    String? phone,
    String? jobTitle,
    String? contactRole,
    String? status,
    bool? canOpenRequests,
    String? preferredChannel,
    bool? isActive,
    String? source,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerContact',
      'id': id.toJson(),
      'customerId': customerId.toJson(),
      if (customerSiteId != null) 'customerSiteId': customerSiteId?.toJson(),
      if (customerSiteName != null) 'customerSiteName': customerSiteName,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (jobTitle != null) 'jobTitle': jobTitle,
      'contactRole': contactRole,
      'status': status,
      'canOpenRequests': canOpenRequests,
      if (preferredChannel != null) 'preferredChannel': preferredChannel,
      'isActive': isActive,
      'source': source,
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerContact',
      'id': id.toJson(),
      'customerId': customerId.toJson(),
      if (customerSiteId != null) 'customerSiteId': customerSiteId?.toJson(),
      if (customerSiteName != null) 'customerSiteName': customerSiteName,
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (jobTitle != null) 'jobTitle': jobTitle,
      'contactRole': contactRole,
      'status': status,
      'canOpenRequests': canOpenRequests,
      if (preferredChannel != null) 'preferredChannel': preferredChannel,
      'isActive': isActive,
      'source': source,
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
    required _isc.UuidValue id,
    required _isc.UuidValue customerId,
    _isc.UuidValue? customerSiteId,
    String? customerSiteName,
    required String name,
    String? email,
    String? phone,
    String? jobTitle,
    required String contactRole,
    required String status,
    required bool canOpenRequests,
    String? preferredChannel,
    required bool isActive,
    required String source,
    required int version,
  }) : super._(
         id: id,
         customerId: customerId,
         customerSiteId: customerSiteId,
         customerSiteName: customerSiteName,
         name: name,
         email: email,
         phone: phone,
         jobTitle: jobTitle,
         contactRole: contactRole,
         status: status,
         canOpenRequests: canOpenRequests,
         preferredChannel: preferredChannel,
         isActive: isActive,
         source: source,
         version: version,
       );

  /// Returns a shallow copy of this [CustomerContact]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CustomerContact copyWith({
    _isc.UuidValue? id,
    _isc.UuidValue? customerId,
    _isc.UuidValue? customerSiteId = const _isc.$UndefinedUuidValue(),
    Object? customerSiteName = _Undefined,
    String? name,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? jobTitle = _Undefined,
    String? contactRole,
    String? status,
    bool? canOpenRequests,
    Object? preferredChannel = _Undefined,
    bool? isActive,
    String? source,
    int? version,
  }) {
    return CustomerContact(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerSiteId: customerSiteId is _isc.UndefinedSentinel ? this.customerSiteId : customerSiteId,
      customerSiteName: customerSiteName is String? ? customerSiteName : this.customerSiteName,
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      jobTitle: jobTitle is String? ? jobTitle : this.jobTitle,
      contactRole: contactRole ?? this.contactRole,
      status: status ?? this.status,
      canOpenRequests: canOpenRequests ?? this.canOpenRequests,
      preferredChannel: preferredChannel is String? ? preferredChannel : this.preferredChannel,
      isActive: isActive ?? this.isActive,
      source: source ?? this.source,
      version: version ?? this.version,
    );
  }
}
