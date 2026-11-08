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
import 'package:plataforma_os_server/src/generated/protocol.dart' as _isma42go;
import 'package:serverpod/serverpod.dart' as _is;
import '../../customers/models/customer_site.dart' as _i956y87h;

abstract class CustomerSitePage implements _is.SerializableModel, _is.ProtocolSerialization {
  CustomerSitePage._({
    required this.items,
    this.nextCursor,
    required this.hasMore,
    this.total,
    this.totalIsEstimate,
  });

  factory CustomerSitePage({
    required List<_i956y87h.CustomerSite> items,
    String? nextCursor,
    required bool hasMore,
    int? total,
    bool? totalIsEstimate,
  }) = _CustomerSitePageImpl;

  factory CustomerSitePage.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerSitePage(
      items: _isma42go.Protocol().deserialize<List<_i956y87h.CustomerSite>>(jsonSerialization['items']),
      nextCursor: jsonSerialization['nextCursor'] as String?,
      hasMore: _is.BoolJsonExtension.fromJson(jsonSerialization['hasMore']),
      total: jsonSerialization['total'] as int?,
      totalIsEstimate: jsonSerialization['totalIsEstimate'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['totalIsEstimate']),
    );
  }

  List<_i956y87h.CustomerSite> items;

  String? nextCursor;

  bool hasMore;

  int? total;

  bool? totalIsEstimate;

  /// Returns a shallow copy of this [CustomerSitePage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  CustomerSitePage copyWith({
    List<_i956y87h.CustomerSite>? items,
    String? nextCursor,
    bool? hasMore,
    int? total,
    bool? totalIsEstimate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerSitePage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      if (nextCursor != null) 'nextCursor': nextCursor,
      'hasMore': hasMore,
      if (total != null) 'total': total,
      if (totalIsEstimate != null) 'totalIsEstimate': totalIsEstimate,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerSitePage',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (nextCursor != null) 'nextCursor': nextCursor,
      'hasMore': hasMore,
      if (total != null) 'total': total,
      if (totalIsEstimate != null) 'totalIsEstimate': totalIsEstimate,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerSitePageImpl extends CustomerSitePage {
  _CustomerSitePageImpl({
    required List<_i956y87h.CustomerSite> items,
    String? nextCursor,
    required bool hasMore,
    int? total,
    bool? totalIsEstimate,
  }) : super._(
         items: items,
         nextCursor: nextCursor,
         hasMore: hasMore,
         total: total,
         totalIsEstimate: totalIsEstimate,
       );

  /// Returns a shallow copy of this [CustomerSitePage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  CustomerSitePage copyWith({
    List<_i956y87h.CustomerSite>? items,
    Object? nextCursor = _Undefined,
    bool? hasMore,
    Object? total = _Undefined,
    Object? totalIsEstimate = _Undefined,
  }) {
    return CustomerSitePage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      nextCursor: nextCursor is String? ? nextCursor : this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      total: total is int? ? total : this.total,
      totalIsEstimate: totalIsEstimate is bool? ? totalIsEstimate : this.totalIsEstimate,
    );
  }
}
