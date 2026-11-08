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
import 'package:plataforma_os_client/src/protocol/protocol.dart' as _inlzmlpe;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../customers/models/contact_role.dart' as _itul20yk;
import '../../customers/models/customer_contact_field.dart' as _ie5976kn;
import '../../customers/models/notification_channel.dart' as _ibtcv0am;

abstract class CustomerContactPatch implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerContactPatch._({
    this.customerSiteId,
    this.name,
    this.email,
    this.phone,
    this.jobTitle,
    this.contactRole,
    this.canOpenRequests,
    this.preferredChannel,
    this.clear,
  });

  factory CustomerContactPatch({
    _isc.UuidValue? customerSiteId,
    String? name,
    String? email,
    String? phone,
    String? jobTitle,
    _itul20yk.ContactRole? contactRole,
    bool? canOpenRequests,
    _ibtcv0am.NotificationChannel? preferredChannel,
    List<_ie5976kn.CustomerContactField>? clear,
  }) = _CustomerContactPatchImpl;

  factory CustomerContactPatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerContactPatch(
      customerSiteId: jsonSerialization['customerSiteId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['customerSiteId']),
      name: jsonSerialization['name'] as String?,
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
      clear: jsonSerialization['clear'] == null
          ? null
          : _inlzmlpe.Protocol().deserialize<List<_ie5976kn.CustomerContactField>>(jsonSerialization['clear']),
    );
  }

  _isc.UuidValue? customerSiteId;

  String? name;

  String? email;

  String? phone;

  String? jobTitle;

  _itul20yk.ContactRole? contactRole;

  bool? canOpenRequests;

  _ibtcv0am.NotificationChannel? preferredChannel;

  List<_ie5976kn.CustomerContactField>? clear;

  /// Returns a shallow copy of this [CustomerContactPatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerContactPatch copyWith({
    _isc.UuidValue? customerSiteId = const _isc.$UndefinedUuidValue(),
    String? name,
    String? email,
    String? phone,
    String? jobTitle,
    _itul20yk.ContactRole? contactRole,
    bool? canOpenRequests,
    _ibtcv0am.NotificationChannel? preferredChannel,
    List<_ie5976kn.CustomerContactField>? clear = const _isc.$UndefinedList<_ie5976kn.CustomerContactField>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerContactPatch',
      if (customerSiteId != null) 'customerSiteId': customerSiteId?.toJson(),
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (jobTitle != null) 'jobTitle': jobTitle,
      if (contactRole != null) 'contactRole': contactRole?.toJson(),
      if (canOpenRequests != null) 'canOpenRequests': canOpenRequests,
      if (preferredChannel != null) 'preferredChannel': preferredChannel?.toJson(),
      if (clear != null) 'clear': clear?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerContactPatch',
      if (customerSiteId != null) 'customerSiteId': customerSiteId?.toJson(),
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (jobTitle != null) 'jobTitle': jobTitle,
      if (contactRole != null) 'contactRole': contactRole?.toJson(),
      if (canOpenRequests != null) 'canOpenRequests': canOpenRequests,
      if (preferredChannel != null) 'preferredChannel': preferredChannel?.toJson(),
      if (clear != null) 'clear': clear?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerContactPatchImpl extends CustomerContactPatch {
  _CustomerContactPatchImpl({
    _isc.UuidValue? customerSiteId,
    String? name,
    String? email,
    String? phone,
    String? jobTitle,
    _itul20yk.ContactRole? contactRole,
    bool? canOpenRequests,
    _ibtcv0am.NotificationChannel? preferredChannel,
    List<_ie5976kn.CustomerContactField>? clear,
  }) : super._(
         customerSiteId: customerSiteId,
         name: name,
         email: email,
         phone: phone,
         jobTitle: jobTitle,
         contactRole: contactRole,
         canOpenRequests: canOpenRequests,
         preferredChannel: preferredChannel,
         clear: clear,
       );

  /// Returns a shallow copy of this [CustomerContactPatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CustomerContactPatch copyWith({
    _isc.UuidValue? customerSiteId = const _isc.$UndefinedUuidValue(),
    Object? name = _Undefined,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? jobTitle = _Undefined,
    Object? contactRole = _Undefined,
    Object? canOpenRequests = _Undefined,
    Object? preferredChannel = _Undefined,
    List<_ie5976kn.CustomerContactField>? clear = const _isc.$UndefinedList<_ie5976kn.CustomerContactField>(),
  }) {
    return CustomerContactPatch(
      customerSiteId: customerSiteId is _isc.UndefinedSentinel ? this.customerSiteId : customerSiteId,
      name: name is String? ? name : this.name,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      jobTitle: jobTitle is String? ? jobTitle : this.jobTitle,
      contactRole: contactRole is _itul20yk.ContactRole? ? contactRole : this.contactRole,
      canOpenRequests: canOpenRequests is bool? ? canOpenRequests : this.canOpenRequests,
      preferredChannel: preferredChannel is _ibtcv0am.NotificationChannel? ? preferredChannel : this.preferredChannel,
      clear: clear is _isc.UndefinedSentinel ? this.clear?.map((e0) => e0).toList() : clear,
    );
  }
}
