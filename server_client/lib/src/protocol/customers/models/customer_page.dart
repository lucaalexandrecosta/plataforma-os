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
import '../../customers/models/customer.dart' as _io59v3a6;

abstract class CustomerPage implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerPage._({
    required this.items,
    this.nextCursor,
    required this.hasMore,
    this.total,
    this.totalIsEstimate,
  });

  factory CustomerPage({
    required List<_io59v3a6.Customer> items,
    String? nextCursor,
    required bool hasMore,
    int? total,
    bool? totalIsEstimate,
  }) = _CustomerPageImpl;

  factory CustomerPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerPage(
      items: _inlzmlpe.Protocol().deserialize<List<_io59v3a6.Customer>>(jsonSerialization['items']),
      nextCursor: jsonSerialization['nextCursor'] as String?,
      hasMore: _isc.BoolJsonExtension.fromJson(jsonSerialization['hasMore']),
      total: jsonSerialization['total'] as int?,
      totalIsEstimate: jsonSerialization['totalIsEstimate'] == null
          ? null
          : _isc.BoolJsonExtension.fromJson(jsonSerialization['totalIsEstimate']),
    );
  }

  List<_io59v3a6.Customer> items;

  String? nextCursor;

  bool hasMore;

  int? total;

  bool? totalIsEstimate;

  /// Returns a shallow copy of this [CustomerPage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerPage copyWith({
    List<_io59v3a6.Customer>? items,
    String? nextCursor,
    bool? hasMore,
    int? total,
    bool? totalIsEstimate,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerPage',
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
      '__className__': 'CustomerPage',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (nextCursor != null) 'nextCursor': nextCursor,
      'hasMore': hasMore,
      if (total != null) 'total': total,
      if (totalIsEstimate != null) 'totalIsEstimate': totalIsEstimate,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerPageImpl extends CustomerPage {
  _CustomerPageImpl({
    required List<_io59v3a6.Customer> items,
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

  /// Returns a shallow copy of this [CustomerPage]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CustomerPage copyWith({
    List<_io59v3a6.Customer>? items,
    Object? nextCursor = _Undefined,
    bool? hasMore,
    Object? total = _Undefined,
    Object? totalIsEstimate = _Undefined,
  }) {
    return CustomerPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      nextCursor: nextCursor is String? ? nextCursor : this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
      total: total is int? ? total : this.total,
      totalIsEstimate: totalIsEstimate is bool? ? totalIsEstimate : this.totalIsEstimate,
    );
  }
}
