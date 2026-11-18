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
import 'package:serverpod/serverpod.dart' as _is;

abstract class CustomerContactInput implements _is.SerializableModel, _is.ProtocolSerialization {
  CustomerContactInput._({
    this.customerSiteId,
    required this.name,
    this.email,
    this.phone,
    this.jobTitle,
    required this.contactRole,
    required this.canOpenRequests,
    this.preferredChannel,
    required this.isActive,
  });

  factory CustomerContactInput({
    _is.UuidValue? customerSiteId,
    required String name,
    String? email,
    String? phone,
    String? jobTitle,
    required String contactRole,
    required bool canOpenRequests,
    String? preferredChannel,
    required bool isActive,
  }) = _CustomerContactInputImpl;

  factory CustomerContactInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerContactInput(
      customerSiteId: jsonSerialization['customerSiteId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['customerSiteId']),
      name: jsonSerialization['name'] as String,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      jobTitle: jsonSerialization['jobTitle'] as String?,
      contactRole: jsonSerialization['contactRole'] as String,
      canOpenRequests: _is.BoolJsonExtension.fromJson(jsonSerialization['canOpenRequests']),
      preferredChannel: jsonSerialization['preferredChannel'] as String?,
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  _is.UuidValue? customerSiteId;

  String name;

  String? email;

  String? phone;

  String? jobTitle;

  String contactRole;

  bool canOpenRequests;

  String? preferredChannel;

  bool isActive;

  /// Returns a shallow copy of this [CustomerContactInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CustomerContactInput copyWith({
    _is.UuidValue? customerSiteId = const _is.$UndefinedUuidValue(),
    String? name,
    String? email,
    String? phone,
    String? jobTitle,
    String? contactRole,
    bool? canOpenRequests,
    String? preferredChannel,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerContactInput',
      if (customerSiteId != null) 'customerSiteId': customerSiteId?.toJson(),
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (jobTitle != null) 'jobTitle': jobTitle,
      'contactRole': contactRole,
      'canOpenRequests': canOpenRequests,
      if (preferredChannel != null) 'preferredChannel': preferredChannel,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerContactInput',
      if (customerSiteId != null) 'customerSiteId': customerSiteId?.toJson(),
      'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (jobTitle != null) 'jobTitle': jobTitle,
      'contactRole': contactRole,
      'canOpenRequests': canOpenRequests,
      if (preferredChannel != null) 'preferredChannel': preferredChannel,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerContactInputImpl extends CustomerContactInput {
  _CustomerContactInputImpl({
    _is.UuidValue? customerSiteId,
    required String name,
    String? email,
    String? phone,
    String? jobTitle,
    required String contactRole,
    required bool canOpenRequests,
    String? preferredChannel,
    required bool isActive,
  }) : super._(
         customerSiteId: customerSiteId,
         name: name,
         email: email,
         phone: phone,
         jobTitle: jobTitle,
         contactRole: contactRole,
         canOpenRequests: canOpenRequests,
         preferredChannel: preferredChannel,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [CustomerContactInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CustomerContactInput copyWith({
    _is.UuidValue? customerSiteId = const _is.$UndefinedUuidValue(),
    String? name,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    Object? jobTitle = _Undefined,
    String? contactRole,
    bool? canOpenRequests,
    Object? preferredChannel = _Undefined,
    bool? isActive,
  }) {
    return CustomerContactInput(
      customerSiteId: customerSiteId is _is.UndefinedSentinel ? this.customerSiteId : customerSiteId,
      name: name ?? this.name,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      jobTitle: jobTitle is String? ? jobTitle : this.jobTitle,
      contactRole: contactRole ?? this.contactRole,
      canOpenRequests: canOpenRequests ?? this.canOpenRequests,
      preferredChannel: preferredChannel is String? ? preferredChannel : this.preferredChannel,
      isActive: isActive ?? this.isActive,
    );
  }
}
