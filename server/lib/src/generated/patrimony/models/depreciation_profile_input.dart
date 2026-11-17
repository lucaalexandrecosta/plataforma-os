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

abstract class DepreciationProfileInput implements _is.SerializableModel, _is.ProtocolSerialization {
  DepreciationProfileInput._({
    required this.method,
    required this.annualRate,
    required this.startDate,
    this.startRule,
    this.depreciableCost,
    this.residualValue,
    this.totalCapacity,
    this.monthlyProduction,
    this.notes,
  });

  factory DepreciationProfileInput({
    required String method,
    required String annualRate,
    required DateTime startDate,
    String? startRule,
    int? depreciableCost,
    int? residualValue,
    String? totalCapacity,
    String? monthlyProduction,
    String? notes,
  }) = _DepreciationProfileInputImpl;

  factory DepreciationProfileInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return DepreciationProfileInput(
      method: jsonSerialization['method'] as String,
      annualRate: jsonSerialization['annualRate'] as String,
      startDate: _is.DateTimeJsonExtension.fromJson(jsonSerialization['startDate']),
      startRule: jsonSerialization['startRule'] as String?,
      depreciableCost: jsonSerialization['depreciableCost'] as int?,
      residualValue: jsonSerialization['residualValue'] as int?,
      totalCapacity: jsonSerialization['totalCapacity'] as String?,
      monthlyProduction: jsonSerialization['monthlyProduction'] as String?,
      notes: jsonSerialization['notes'] as String?,
    );
  }

  String method;

  String annualRate;

  DateTime startDate;

  String? startRule;

  int? depreciableCost;

  int? residualValue;

  String? totalCapacity;

  String? monthlyProduction;

  String? notes;

  /// Returns a shallow copy of this [DepreciationProfileInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DepreciationProfileInput copyWith({
    String? method,
    String? annualRate,
    DateTime? startDate,
    String? startRule,
    int? depreciableCost,
    int? residualValue,
    String? totalCapacity,
    String? monthlyProduction,
    String? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DepreciationProfileInput',
      'method': method,
      'annualRate': annualRate,
      'startDate': startDate.toJson(),
      if (startRule != null) 'startRule': startRule,
      if (depreciableCost != null) 'depreciableCost': depreciableCost,
      if (residualValue != null) 'residualValue': residualValue,
      if (totalCapacity != null) 'totalCapacity': totalCapacity,
      if (monthlyProduction != null) 'monthlyProduction': monthlyProduction,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DepreciationProfileInput',
      'method': method,
      'annualRate': annualRate,
      'startDate': startDate.toJson(),
      if (startRule != null) 'startRule': startRule,
      if (depreciableCost != null) 'depreciableCost': depreciableCost,
      if (residualValue != null) 'residualValue': residualValue,
      if (totalCapacity != null) 'totalCapacity': totalCapacity,
      if (monthlyProduction != null) 'monthlyProduction': monthlyProduction,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DepreciationProfileInputImpl extends DepreciationProfileInput {
  _DepreciationProfileInputImpl({
    required String method,
    required String annualRate,
    required DateTime startDate,
    String? startRule,
    int? depreciableCost,
    int? residualValue,
    String? totalCapacity,
    String? monthlyProduction,
    String? notes,
  }) : super._(
         method: method,
         annualRate: annualRate,
         startDate: startDate,
         startRule: startRule,
         depreciableCost: depreciableCost,
         residualValue: residualValue,
         totalCapacity: totalCapacity,
         monthlyProduction: monthlyProduction,
         notes: notes,
       );

  /// Returns a shallow copy of this [DepreciationProfileInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DepreciationProfileInput copyWith({
    String? method,
    String? annualRate,
    DateTime? startDate,
    Object? startRule = _Undefined,
    Object? depreciableCost = _Undefined,
    Object? residualValue = _Undefined,
    Object? totalCapacity = _Undefined,
    Object? monthlyProduction = _Undefined,
    Object? notes = _Undefined,
  }) {
    return DepreciationProfileInput(
      method: method ?? this.method,
      annualRate: annualRate ?? this.annualRate,
      startDate: startDate ?? this.startDate,
      startRule: startRule is String? ? startRule : this.startRule,
      depreciableCost: depreciableCost is int? ? depreciableCost : this.depreciableCost,
      residualValue: residualValue is int? ? residualValue : this.residualValue,
      totalCapacity: totalCapacity is String? ? totalCapacity : this.totalCapacity,
      monthlyProduction: monthlyProduction is String? ? monthlyProduction : this.monthlyProduction,
      notes: notes is String? ? notes : this.notes,
    );
  }
}
