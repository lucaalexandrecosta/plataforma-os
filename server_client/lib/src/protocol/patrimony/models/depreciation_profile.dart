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

abstract class DepreciationProfile implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DepreciationProfile._({
    required this.assetId,
    required this.method,
    required this.annualRate,
    required this.startDate,
    required this.startRule,
    this.depreciableCost,
    this.effectiveCost,
    required this.residualValue,
    this.totalCapacity,
    this.monthlyProduction,
    this.notes,
    required this.version,
  });

  factory DepreciationProfile({
    required _isc.UuidValue assetId,
    required String method,
    required String annualRate,
    required DateTime startDate,
    required String startRule,
    int? depreciableCost,
    int? effectiveCost,
    required int residualValue,
    String? totalCapacity,
    String? monthlyProduction,
    String? notes,
    required int version,
  }) = _DepreciationProfileImpl;

  factory DepreciationProfile.fromJson(Map<String, dynamic> jsonSerialization) {
    return DepreciationProfile(
      assetId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['assetId']),
      method: jsonSerialization['method'] as String,
      annualRate: jsonSerialization['annualRate'] as String,
      startDate: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['startDate']),
      startRule: jsonSerialization['startRule'] as String,
      depreciableCost: jsonSerialization['depreciableCost'] as int?,
      effectiveCost: jsonSerialization['effectiveCost'] as int?,
      residualValue: jsonSerialization['residualValue'] as int,
      totalCapacity: jsonSerialization['totalCapacity'] as String?,
      monthlyProduction: jsonSerialization['monthlyProduction'] as String?,
      notes: jsonSerialization['notes'] as String?,
      version: jsonSerialization['version'] as int,
    );
  }

  _isc.UuidValue assetId;

  String method;

  String annualRate;

  DateTime startDate;

  String startRule;

  int? depreciableCost;

  int? effectiveCost;

  int residualValue;

  String? totalCapacity;

  String? monthlyProduction;

  String? notes;

  int version;

  /// Returns a shallow copy of this [DepreciationProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DepreciationProfile copyWith({
    _isc.UuidValue? assetId,
    String? method,
    String? annualRate,
    DateTime? startDate,
    String? startRule,
    int? depreciableCost,
    int? effectiveCost,
    int? residualValue,
    String? totalCapacity,
    String? monthlyProduction,
    String? notes,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DepreciationProfile',
      'assetId': assetId.toJson(),
      'method': method,
      'annualRate': annualRate,
      'startDate': startDate.toJson(),
      'startRule': startRule,
      if (depreciableCost != null) 'depreciableCost': depreciableCost,
      if (effectiveCost != null) 'effectiveCost': effectiveCost,
      'residualValue': residualValue,
      if (totalCapacity != null) 'totalCapacity': totalCapacity,
      if (monthlyProduction != null) 'monthlyProduction': monthlyProduction,
      if (notes != null) 'notes': notes,
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DepreciationProfile',
      'assetId': assetId.toJson(),
      'method': method,
      'annualRate': annualRate,
      'startDate': startDate.toJson(),
      'startRule': startRule,
      if (depreciableCost != null) 'depreciableCost': depreciableCost,
      if (effectiveCost != null) 'effectiveCost': effectiveCost,
      'residualValue': residualValue,
      if (totalCapacity != null) 'totalCapacity': totalCapacity,
      if (monthlyProduction != null) 'monthlyProduction': monthlyProduction,
      if (notes != null) 'notes': notes,
      'version': version,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DepreciationProfileImpl extends DepreciationProfile {
  _DepreciationProfileImpl({
    required _isc.UuidValue assetId,
    required String method,
    required String annualRate,
    required DateTime startDate,
    required String startRule,
    int? depreciableCost,
    int? effectiveCost,
    required int residualValue,
    String? totalCapacity,
    String? monthlyProduction,
    String? notes,
    required int version,
  }) : super._(
         assetId: assetId,
         method: method,
         annualRate: annualRate,
         startDate: startDate,
         startRule: startRule,
         depreciableCost: depreciableCost,
         effectiveCost: effectiveCost,
         residualValue: residualValue,
         totalCapacity: totalCapacity,
         monthlyProduction: monthlyProduction,
         notes: notes,
         version: version,
       );

  /// Returns a shallow copy of this [DepreciationProfile]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DepreciationProfile copyWith({
    _isc.UuidValue? assetId,
    String? method,
    String? annualRate,
    DateTime? startDate,
    String? startRule,
    Object? depreciableCost = _Undefined,
    Object? effectiveCost = _Undefined,
    int? residualValue,
    Object? totalCapacity = _Undefined,
    Object? monthlyProduction = _Undefined,
    Object? notes = _Undefined,
    int? version,
  }) {
    return DepreciationProfile(
      assetId: assetId ?? this.assetId,
      method: method ?? this.method,
      annualRate: annualRate ?? this.annualRate,
      startDate: startDate ?? this.startDate,
      startRule: startRule ?? this.startRule,
      depreciableCost: depreciableCost is int? ? depreciableCost : this.depreciableCost,
      effectiveCost: effectiveCost is int? ? effectiveCost : this.effectiveCost,
      residualValue: residualValue ?? this.residualValue,
      totalCapacity: totalCapacity is String? ? totalCapacity : this.totalCapacity,
      monthlyProduction: monthlyProduction is String? ? monthlyProduction : this.monthlyProduction,
      notes: notes is String? ? notes : this.notes,
      version: version ?? this.version,
    );
  }
}
