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

abstract class CustomerSiteFilter implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerSiteFilter._({
    this.customerId,
    this.q,
    this.isActive,
  });

  factory CustomerSiteFilter({
    _isc.UuidValue? customerId,
    String? q,
    bool? isActive,
  }) = _CustomerSiteFilterImpl;

  factory CustomerSiteFilter.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerSiteFilter(
      customerId: jsonSerialization['customerId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['customerId']),
      q: jsonSerialization['q'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  _isc.UuidValue? customerId;

  String? q;

  bool? isActive;

  /// Returns a shallow copy of this [CustomerSiteFilter]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerSiteFilter copyWith({
    _isc.UuidValue? customerId = const _isc.$UndefinedUuidValue(),
    String? q,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerSiteFilter',
      if (customerId != null) 'customerId': customerId?.toJson(),
      if (q != null) 'q': q,
      if (isActive != null) 'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerSiteFilter',
      if (customerId != null) 'customerId': customerId?.toJson(),
      if (q != null) 'q': q,
      if (isActive != null) 'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerSiteFilterImpl extends CustomerSiteFilter {
  _CustomerSiteFilterImpl({
    _isc.UuidValue? customerId,
    String? q,
    bool? isActive,
  }) : super._(
         customerId: customerId,
         q: q,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [CustomerSiteFilter]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CustomerSiteFilter copyWith({
    _isc.UuidValue? customerId = const _isc.$UndefinedUuidValue(),
    Object? q = _Undefined,
    Object? isActive = _Undefined,
  }) {
    return CustomerSiteFilter(
      customerId: customerId is _isc.UndefinedSentinel ? this.customerId : customerId,
      q: q is String? ? q : this.q,
      isActive: isActive is bool? ? isActive : this.isActive,
    );
  }
}
