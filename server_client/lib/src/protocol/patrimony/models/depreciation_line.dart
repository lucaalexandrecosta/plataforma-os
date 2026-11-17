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

abstract class DepreciationLine implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DepreciationLine._({
    required this.year,
    required this.month,
    required this.amount,
    required this.accumulated,
    required this.netBookValue,
    required this.rule,
    required this.disposed,
  });

  factory DepreciationLine({
    required int year,
    required int month,
    required int amount,
    required int accumulated,
    required int netBookValue,
    required String rule,
    required bool disposed,
  }) = _DepreciationLineImpl;

  factory DepreciationLine.fromJson(Map<String, dynamic> jsonSerialization) {
    return DepreciationLine(
      year: jsonSerialization['year'] as int,
      month: jsonSerialization['month'] as int,
      amount: jsonSerialization['amount'] as int,
      accumulated: jsonSerialization['accumulated'] as int,
      netBookValue: jsonSerialization['netBookValue'] as int,
      rule: jsonSerialization['rule'] as String,
      disposed: _isc.BoolJsonExtension.fromJson(jsonSerialization['disposed']),
    );
  }

  int year;

  int month;

  int amount;

  int accumulated;

  int netBookValue;

  String rule;

  bool disposed;

  /// Returns a shallow copy of this [DepreciationLine]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DepreciationLine copyWith({
    int? year,
    int? month,
    int? amount,
    int? accumulated,
    int? netBookValue,
    String? rule,
    bool? disposed,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DepreciationLine',
      'year': year,
      'month': month,
      'amount': amount,
      'accumulated': accumulated,
      'netBookValue': netBookValue,
      'rule': rule,
      'disposed': disposed,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DepreciationLine',
      'year': year,
      'month': month,
      'amount': amount,
      'accumulated': accumulated,
      'netBookValue': netBookValue,
      'rule': rule,
      'disposed': disposed,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _DepreciationLineImpl extends DepreciationLine {
  _DepreciationLineImpl({
    required int year,
    required int month,
    required int amount,
    required int accumulated,
    required int netBookValue,
    required String rule,
    required bool disposed,
  }) : super._(
         year: year,
         month: month,
         amount: amount,
         accumulated: accumulated,
         netBookValue: netBookValue,
         rule: rule,
         disposed: disposed,
       );

  /// Returns a shallow copy of this [DepreciationLine]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DepreciationLine copyWith({
    int? year,
    int? month,
    int? amount,
    int? accumulated,
    int? netBookValue,
    String? rule,
    bool? disposed,
  }) {
    return DepreciationLine(
      year: year ?? this.year,
      month: month ?? this.month,
      amount: amount ?? this.amount,
      accumulated: accumulated ?? this.accumulated,
      netBookValue: netBookValue ?? this.netBookValue,
      rule: rule ?? this.rule,
      disposed: disposed ?? this.disposed,
    );
  }
}
