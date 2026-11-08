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
import '../../catalog/models/service_kind.dart' as _iu1dhgj0;
import '../../platform/models/record_source.dart' as _i1c87mer;

abstract class CatalogServiceFilter implements _is.SerializableModel, _is.ProtocolSerialization {
  CatalogServiceFilter._({
    this.q,
    this.isActive,
    this.serviceKind,
    this.source,
  });

  factory CatalogServiceFilter({
    String? q,
    bool? isActive,
    _iu1dhgj0.ServiceKind? serviceKind,
    _i1c87mer.RecordSource? source,
  }) = _CatalogServiceFilterImpl;

  factory CatalogServiceFilter.fromJson(Map<String, dynamic> jsonSerialization) {
    return CatalogServiceFilter(
      q: jsonSerialization['q'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      serviceKind: jsonSerialization['serviceKind'] == null
          ? null
          : _iu1dhgj0.ServiceKind.fromJson((jsonSerialization['serviceKind'] as String)),
      source: jsonSerialization['source'] == null
          ? null
          : _i1c87mer.RecordSource.fromJson((jsonSerialization['source'] as String)),
    );
  }

  String? q;

  bool? isActive;

  _iu1dhgj0.ServiceKind? serviceKind;

  _i1c87mer.RecordSource? source;

  /// Returns a shallow copy of this [CatalogServiceFilter]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CatalogServiceFilter copyWith({
    String? q,
    bool? isActive,
    _iu1dhgj0.ServiceKind? serviceKind,
    _i1c87mer.RecordSource? source,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CatalogServiceFilter',
      if (q != null) 'q': q,
      if (isActive != null) 'isActive': isActive,
      if (serviceKind != null) 'serviceKind': serviceKind?.toJson(),
      if (source != null) 'source': source?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CatalogServiceFilter',
      if (q != null) 'q': q,
      if (isActive != null) 'isActive': isActive,
      if (serviceKind != null) 'serviceKind': serviceKind?.toJson(),
      if (source != null) 'source': source?.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CatalogServiceFilterImpl extends CatalogServiceFilter {
  _CatalogServiceFilterImpl({
    String? q,
    bool? isActive,
    _iu1dhgj0.ServiceKind? serviceKind,
    _i1c87mer.RecordSource? source,
  }) : super._(
         q: q,
         isActive: isActive,
         serviceKind: serviceKind,
         source: source,
       );

  /// Returns a shallow copy of this [CatalogServiceFilter]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CatalogServiceFilter copyWith({
    Object? q = _Undefined,
    Object? isActive = _Undefined,
    Object? serviceKind = _Undefined,
    Object? source = _Undefined,
  }) {
    return CatalogServiceFilter(
      q: q is String? ? q : this.q,
      isActive: isActive is bool? ? isActive : this.isActive,
      serviceKind: serviceKind is _iu1dhgj0.ServiceKind? ? serviceKind : this.serviceKind,
      source: source is _i1c87mer.RecordSource? ? source : this.source,
    );
  }
}
