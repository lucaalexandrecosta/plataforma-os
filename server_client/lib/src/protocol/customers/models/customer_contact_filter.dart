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
import '../../customers/models/contact_status.dart' as _iaj79viq;

abstract class CustomerContactFilter implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerContactFilter._({
    this.customerId,
    this.customerSiteId,
    this.q,
    this.status,
    this.isActive,
  });

  factory CustomerContactFilter({
    _isc.UuidValue? customerId,
    _isc.UuidValue? customerSiteId,
    String? q,
    _iaj79viq.ContactStatus? status,
    bool? isActive,
  }) = _CustomerContactFilterImpl;

  factory CustomerContactFilter.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerContactFilter(
      customerId: jsonSerialization['customerId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['customerId']),
      customerSiteId: jsonSerialization['customerSiteId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['customerSiteId']),
      q: jsonSerialization['q'] as String?,
      status: jsonSerialization['status'] == null
          ? null
          : _iaj79viq.ContactStatus.fromJson((jsonSerialization['status'] as String)),
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  _isc.UuidValue? customerId;

  _isc.UuidValue? customerSiteId;

  String? q;

  _iaj79viq.ContactStatus? status;

  bool? isActive;

  /// Returns a shallow copy of this [CustomerContactFilter]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerContactFilter copyWith({
    _isc.UuidValue? customerId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? customerSiteId = const _isc.$UndefinedUuidValue(),
    String? q,
    _iaj79viq.ContactStatus? status,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerContactFilter',
      if (customerId != null) 'customerId': customerId?.toJson(),
      if (customerSiteId != null) 'customerSiteId': customerSiteId?.toJson(),
      if (q != null) 'q': q,
      if (status != null) 'status': status?.toJson(),
      if (isActive != null) 'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerContactFilter',
      if (customerId != null) 'customerId': customerId?.toJson(),
      if (customerSiteId != null) 'customerSiteId': customerSiteId?.toJson(),
      if (q != null) 'q': q,
      if (status != null) 'status': status?.toJson(),
      if (isActive != null) 'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerContactFilterImpl extends CustomerContactFilter {
  _CustomerContactFilterImpl({
    _isc.UuidValue? customerId,
    _isc.UuidValue? customerSiteId,
    String? q,
    _iaj79viq.ContactStatus? status,
    bool? isActive,
  }) : super._(
         customerId: customerId,
         customerSiteId: customerSiteId,
         q: q,
         status: status,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [CustomerContactFilter]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CustomerContactFilter copyWith({
    _isc.UuidValue? customerId = const _isc.$UndefinedUuidValue(),
    _isc.UuidValue? customerSiteId = const _isc.$UndefinedUuidValue(),
    Object? q = _Undefined,
    Object? status = _Undefined,
    Object? isActive = _Undefined,
  }) {
    return CustomerContactFilter(
      customerId: customerId is _isc.UndefinedSentinel ? this.customerId : customerId,
      customerSiteId: customerSiteId is _isc.UndefinedSentinel ? this.customerSiteId : customerSiteId,
      q: q is String? ? q : this.q,
      status: status is _iaj79viq.ContactStatus? ? status : this.status,
      isActive: isActive is bool? ? isActive : this.isActive,
    );
  }
}
