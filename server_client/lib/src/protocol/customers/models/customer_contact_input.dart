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
import '../../customers/models/contact_role.dart' as _itul20yk;
import '../../customers/models/notification_channel.dart' as _ibtcv0am;

abstract class CustomerContactInput implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerContactInput._({
    this.id,
    required this.customerId,
    this.customerSiteId,
    required this.name,
    this.email,
    this.phone,
    this.jobTitle,
    this.contactRole,
    this.canOpenRequests,
    this.preferredChannel,
  });

  factory CustomerContactInput({
    _isc.UuidValue? id,
    required _isc.UuidValue customerId,
    _isc.UuidValue? customerSiteId,
    required String name,
    String? email,
    String? phone,
    String? jobTitle,
    _itul20yk.ContactRole? contactRole,
    bool? canOpenRequests,
    _ibtcv0am.NotificationChannel? preferredChannel,
  }) = _CustomerContactInputImpl;

  factory CustomerContactInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerContactInput(
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      customerId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['customerId']),
      customerSiteId: jsonSerialization['customerSiteId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['customerSiteId']),
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      jobTitle: jsonSerialization['jobTitle'] as String?,
      contactRole: jsonSerialization['contactRole'] == null
          ? null
          : _itul20yk.ContactRole.fromJson((jsonSerialization['contactRole'] as String)),
      canOpenRequests: jsonSerialization['canOpenRequests'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['canOpenRequests']),
      preferredChannel: jsonSerialization['preferredChannel'] == null
          ? null
          : _ibtcv0am.NotificationChannel.fromJson((jsonSerialization['preferredChannel'] as String)),
    );
  }

  _isc.UuidValue? id;

  _isc.UuidValue customerId;

  _isc.UuidValue? customerSiteId;

  String name;

  String? email;

  String? phone;

  String? jobTitle;

  _itul20yk.ContactRole? contactRole;

  bool? canOpenRequests;

  _ibtcv0am.NotificationChannel? preferredChannel;

  /// Returns a shallow copy of this [CustomerContactInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerContactInput copyWith({
    _isc.UuidValue? id = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? customerId,
    _isc.UuidValue? customerSiteId = const _isc.$UndefinedUuidValue(),
    String? name,
    String? email,
    String? phone,
    String? jobTitle,
    _itul20yk.ContactRole? contactRole,
    bool? canOpenRequests,
    _ibtcv0am.NotificationChannel? preferredChannel,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerContactInput',
      if (id != null) 'id': id?.toJson(),
      'customerId': customerId.toJson(),
      if (customerSiteId != null) 'customerSiteId': customerSiteId?.toJson(),
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (jobTitle != null) 'jobTitle': jobTitle,
      if (contactRole != null) 'contactRole': contactRole?.toJson(),
      if (canOpenRequests != null) 'canOpenRequests': canOpenRequests,
      if (preferredChannel != null) 'preferredChannel': preferredChannel?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerContactInput',
      if (id != null) 'id': id?.toJson(),
      'customerId': customerId.toJson(),
      if (customerSiteId != null) 'customerSiteId': customerSiteId?.toJson(),
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (jobTitle != null) 'jobTitle': jobTitle,
      if (contactRole != null) 'contactRole': contactRole?.toJson(),
      if (canOpenRequests != null) 'canOpenRequests': canOpenRequests,
      if (preferredChannel != null) 'preferredChannel': preferredChannel?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerContactInputImpl extends CustomerContactInput {
  _CustomerContactInputImpl({
    _isc.UuidValue? id,
    required _isc.UuidValue customerId,
    _isc.UuidValue? customerSiteId,
    required String name,
    String? email,
    String? phone,
    String? jobTitle,
    _itul20yk.ContactRole? contactRole,
    bool? canOpenRequests,
    _ibtcv0am.NotificationChannel? preferredChannel,
  }) : super._(
         id: id,
         customerId: customerId,
         customerSiteId: customerSiteId,
         name: name,
         email: email,
         phone: phone,
         jobTitle: jobTitle,
         contactRole: contactRole,
         canOpenRequests: canOpenRequests,
         preferredChannel: preferredChannel,
       );

  /// Returns a shallow copy of this [CustomerContactInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CustomerContactInput copyWith({
    _isc.UuidValue? id = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? customerId,
    _isc.UuidValue? customerSiteId = const _isc.$UndefinedUuidValue(),
    String? name,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? jobTitle = _Undefined,
    Object? contactRole = _Undefined,
    Object? canOpenRequests = _Undefined,
    Object? preferredChannel = _Undefined,
  }) {
    return CustomerContactInput(
      id: id is _isc.UndefinedSentinel ? this.id : id,
      customerId: customerId ?? this.customerId,
      customerSiteId: customerSiteId is _isc.UndefinedSentinel ? this.customerSiteId : customerSiteId,
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      jobTitle: jobTitle is String? ? jobTitle : this.jobTitle,
      contactRole: contactRole is _itul20yk.ContactRole? ? contactRole : this.contactRole,
      canOpenRequests: canOpenRequests is bool? ? canOpenRequests : this.canOpenRequests,
      preferredChannel: preferredChannel is _ibtcv0am.NotificationChannel? ? preferredChannel : this.preferredChannel,
    );
  }
}
