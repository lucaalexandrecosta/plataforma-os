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
import '../../customers/models/customer_kind.dart' as _itewe25f;
import '../../platform/models/record_source.dart' as _i1c87mer;

abstract class CustomerFilter implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerFilter._({
    this.q,
    this.isActive,
    this.kind,
    this.source,
  });

  factory CustomerFilter({
    String? q,
    bool? isActive,
    _itewe25f.CustomerKind? kind,
    _i1c87mer.RecordSource? source,
  }) = _CustomerFilterImpl;

  factory CustomerFilter.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerFilter(
      q: jsonSerialization['q'] as String?,
      isActive: jsonSerialization['isActive'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      kind: jsonSerialization['kind'] == null
          ? null
          : _itewe25f.CustomerKind.fromJson((jsonSerialization['kind'] as String)),
      source: jsonSerialization['source'] == null
          ? null
          : _i1c87mer.RecordSource.fromJson((jsonSerialization['source'] as String)),
    );
  }

  String? q;

  bool? isActive;

  _itewe25f.CustomerKind? kind;

  _i1c87mer.RecordSource? source;

  /// Returns a shallow copy of this [CustomerFilter]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerFilter copyWith({
    String? q,
    bool? isActive,
    _itewe25f.CustomerKind? kind,
    _i1c87mer.RecordSource? source,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerFilter',
      if (q != null) 'q': q,
      if (isActive != null) 'isActive': isActive,
      if (kind != null) 'kind': kind?.toJson(),
      if (source != null) 'source': source?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerFilter',
      if (q != null) 'q': q,
      if (isActive != null) 'isActive': isActive,
      if (kind != null) 'kind': kind?.toJson(),
      if (source != null) 'source': source?.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerFilterImpl extends CustomerFilter {
  _CustomerFilterImpl({
    String? q,
    bool? isActive,
    _itewe25f.CustomerKind? kind,
    _i1c87mer.RecordSource? source,
  }) : super._(
         q: q,
         isActive: isActive,
         kind: kind,
         source: source,
       );

  /// Returns a shallow copy of this [CustomerFilter]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CustomerFilter copyWith({
    Object? q = _Undefined,
    Object? isActive = _Undefined,
    Object? kind = _Undefined,
    Object? source = _Undefined,
  }) {
    return CustomerFilter(
      q: q is String? ? q : this.q,
      isActive: isActive is bool? ? isActive : this.isActive,
      kind: kind is _itewe25f.CustomerKind? ? kind : this.kind,
      source: source is _i1c87mer.RecordSource? ? source : this.source,
    );
  }
}
