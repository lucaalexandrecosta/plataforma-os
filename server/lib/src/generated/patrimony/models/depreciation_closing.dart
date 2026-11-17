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

abstract class DepreciationClosing implements _is.SerializableModel, _is.ProtocolSerialization {
  DepreciationClosing._({
    required this.id,
    required this.year,
    required this.month,
    required this.status,
    required this.assetCount,
    required this.totalAmount,
    required this.closedAt,
    this.closedByName,
    this.reopenedAt,
    this.reopenReason,
  });

  factory DepreciationClosing({
    required _is.UuidValue id,
    required int year,
    required int month,
    required String status,
    required int assetCount,
    required int totalAmount,
    required DateTime closedAt,
    String? closedByName,
    DateTime? reopenedAt,
    String? reopenReason,
  }) = _DepreciationClosingImpl;

  factory DepreciationClosing.fromJson(Map<String, dynamic> jsonSerialization) {
    return DepreciationClosing(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      year: jsonSerialization['year'] as int,
      month: jsonSerialization['month'] as int,
      status: jsonSerialization['status'] as String,
      assetCount: jsonSerialization['assetCount'] as int,
      totalAmount: jsonSerialization['totalAmount'] as int,
      closedAt: _is.DateTimeJsonExtension.fromJson(jsonSerialization['closedAt']),
      closedByName: jsonSerialization['closedByName'] as String?,
      reopenedAt: jsonSerialization['reopenedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['reopenedAt']),
      reopenReason: jsonSerialization['reopenReason'] as String?,
    );
  }

  _is.UuidValue id;

  int year;

  int month;

  String status;

  int assetCount;

  int totalAmount;

  DateTime closedAt;

  String? closedByName;

  DateTime? reopenedAt;

  String? reopenReason;

  /// Returns a shallow copy of this [DepreciationClosing]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DepreciationClosing copyWith({
    _is.UuidValue? id,
    int? year,
    int? month,
    String? status,
    int? assetCount,
    int? totalAmount,
    DateTime? closedAt,
    String? closedByName,
    DateTime? reopenedAt = const _is.$UndefinedDateTime(),
    String? reopenReason,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DepreciationClosing',
      'id': id.toJson(),
      'year': year,
      'month': month,
      'status': status,
      'assetCount': assetCount,
      'totalAmount': totalAmount,
      'closedAt': closedAt.toJson(),
      if (closedByName != null) 'closedByName': closedByName,
      if (reopenedAt != null) 'reopenedAt': reopenedAt?.toJson(),
      if (reopenReason != null) 'reopenReason': reopenReason,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DepreciationClosing',
      'id': id.toJson(),
      'year': year,
      'month': month,
      'status': status,
      'assetCount': assetCount,
      'totalAmount': totalAmount,
      'closedAt': closedAt.toJson(),
      if (closedByName != null) 'closedByName': closedByName,
      if (reopenedAt != null) 'reopenedAt': reopenedAt?.toJson(),
      if (reopenReason != null) 'reopenReason': reopenReason,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DepreciationClosingImpl extends DepreciationClosing {
  _DepreciationClosingImpl({
    required _is.UuidValue id,
    required int year,
    required int month,
    required String status,
    required int assetCount,
    required int totalAmount,
    required DateTime closedAt,
    String? closedByName,
    DateTime? reopenedAt,
    String? reopenReason,
  }) : super._(
         id: id,
         year: year,
         month: month,
         status: status,
         assetCount: assetCount,
         totalAmount: totalAmount,
         closedAt: closedAt,
         closedByName: closedByName,
         reopenedAt: reopenedAt,
         reopenReason: reopenReason,
       );

  /// Returns a shallow copy of this [DepreciationClosing]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DepreciationClosing copyWith({
    _is.UuidValue? id,
    int? year,
    int? month,
    String? status,
    int? assetCount,
    int? totalAmount,
    DateTime? closedAt,
    Object? closedByName = _Undefined,
    DateTime? reopenedAt = const _is.$UndefinedDateTime(),
    Object? reopenReason = _Undefined,
  }) {
    return DepreciationClosing(
      id: id ?? this.id,
      year: year ?? this.year,
      month: month ?? this.month,
      status: status ?? this.status,
      assetCount: assetCount ?? this.assetCount,
      totalAmount: totalAmount ?? this.totalAmount,
      closedAt: closedAt ?? this.closedAt,
      closedByName: closedByName is String? ? closedByName : this.closedByName,
      reopenedAt: reopenedAt is _is.UndefinedSentinel ? this.reopenedAt : reopenedAt,
      reopenReason: reopenReason is String? ? reopenReason : this.reopenReason,
    );
  }
}
