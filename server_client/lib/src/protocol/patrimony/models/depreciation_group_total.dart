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

abstract class DepreciationGroupTotal implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DepreciationGroupTotal._({
    this.id,
    this.name,
    required this.assetCount,
    required this.cost,
    required this.monthlyAmount,
    required this.accumulated,
    required this.netBookValue,
  });

  factory DepreciationGroupTotal({
    _isc.UuidValue? id,
    String? name,
    required int assetCount,
    required int cost,
    required int monthlyAmount,
    required int accumulated,
    required int netBookValue,
  }) = _DepreciationGroupTotalImpl;

  factory DepreciationGroupTotal.fromJson(Map<String, dynamic> jsonSerialization) {
    return DepreciationGroupTotal(
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String?,
      assetCount: jsonSerialization['assetCount'] as int,
      cost: jsonSerialization['cost'] as int,
      monthlyAmount: jsonSerialization['monthlyAmount'] as int,
      accumulated: jsonSerialization['accumulated'] as int,
      netBookValue: jsonSerialization['netBookValue'] as int,
    );
  }

  _isc.UuidValue? id;

  String? name;

  int assetCount;

  int cost;

  int monthlyAmount;

  int accumulated;

  int netBookValue;

  /// Returns a shallow copy of this [DepreciationGroupTotal]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DepreciationGroupTotal copyWith({
    _isc.UuidValue? id = const _isc.$UndefinedUuidValue(),
    String? name,
    int? assetCount,
    int? cost,
    int? monthlyAmount,
    int? accumulated,
    int? netBookValue,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DepreciationGroupTotal',
      if (id != null) 'id': id?.toJson(),
      if (name != null) 'name': name,
      'assetCount': assetCount,
      'cost': cost,
      'monthlyAmount': monthlyAmount,
      'accumulated': accumulated,
      'netBookValue': netBookValue,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DepreciationGroupTotal',
      if (id != null) 'id': id?.toJson(),
      if (name != null) 'name': name,
      'assetCount': assetCount,
      'cost': cost,
      'monthlyAmount': monthlyAmount,
      'accumulated': accumulated,
      'netBookValue': netBookValue,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DepreciationGroupTotalImpl extends DepreciationGroupTotal {
  _DepreciationGroupTotalImpl({
    _isc.UuidValue? id,
    String? name,
    required int assetCount,
    required int cost,
    required int monthlyAmount,
    required int accumulated,
    required int netBookValue,
  }) : super._(
         id: id,
         name: name,
         assetCount: assetCount,
         cost: cost,
         monthlyAmount: monthlyAmount,
         accumulated: accumulated,
         netBookValue: netBookValue,
       );

  /// Returns a shallow copy of this [DepreciationGroupTotal]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DepreciationGroupTotal copyWith({
    _isc.UuidValue? id = const _isc.$UndefinedUuidValue(),
    Object? name = _Undefined,
    int? assetCount,
    int? cost,
    int? monthlyAmount,
    int? accumulated,
    int? netBookValue,
  }) {
    return DepreciationGroupTotal(
      id: id is _isc.UndefinedSentinel ? this.id : id,
      name: name is String? ? name : this.name,
      assetCount: assetCount ?? this.assetCount,
      cost: cost ?? this.cost,
      monthlyAmount: monthlyAmount ?? this.monthlyAmount,
      accumulated: accumulated ?? this.accumulated,
      netBookValue: netBookValue ?? this.netBookValue,
    );
  }
}
