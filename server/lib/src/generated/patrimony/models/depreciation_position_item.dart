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

abstract class DepreciationPositionItem implements _is.SerializableModel, _is.ProtocolSerialization {
  DepreciationPositionItem._({
    required this.assetId,
    required this.assetLabel,
    required this.productName,
    this.branchId,
    this.branchName,
    this.costCenterId,
    this.costCenterName,
    required this.cost,
    required this.monthlyAmount,
    required this.accumulated,
    required this.netBookValue,
  });

  factory DepreciationPositionItem({
    required _is.UuidValue assetId,
    required String assetLabel,
    required String productName,
    _is.UuidValue? branchId,
    String? branchName,
    _is.UuidValue? costCenterId,
    String? costCenterName,
    required int cost,
    required int monthlyAmount,
    required int accumulated,
    required int netBookValue,
  }) = _DepreciationPositionItemImpl;

  factory DepreciationPositionItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return DepreciationPositionItem(
      assetId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['assetId']),
      assetLabel: jsonSerialization['assetLabel'] as String,
      productName: jsonSerialization['productName'] as String,
      branchId: jsonSerialization['branchId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['branchId']),
      branchName: jsonSerialization['branchName'] as String?,
      costCenterId: jsonSerialization['costCenterId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['costCenterId']),
      costCenterName: jsonSerialization['costCenterName'] as String?,
      cost: jsonSerialization['cost'] as int,
      monthlyAmount: jsonSerialization['monthlyAmount'] as int,
      accumulated: jsonSerialization['accumulated'] as int,
      netBookValue: jsonSerialization['netBookValue'] as int,
    );
  }

  _is.UuidValue assetId;

  String assetLabel;

  String productName;

  _is.UuidValue? branchId;

  String? branchName;

  _is.UuidValue? costCenterId;

  String? costCenterName;

  int cost;

  int monthlyAmount;

  int accumulated;

  int netBookValue;

  /// Returns a shallow copy of this [DepreciationPositionItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DepreciationPositionItem copyWith({
    _is.UuidValue? assetId,
    String? assetLabel,
    String? productName,
    _is.UuidValue? branchId = const _is.$UndefinedUuidValue(),
    String? branchName,
    _is.UuidValue? costCenterId = const _is.$UndefinedUuidValue(),
    String? costCenterName,
    int? cost,
    int? monthlyAmount,
    int? accumulated,
    int? netBookValue,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DepreciationPositionItem',
      'assetId': assetId.toJson(),
      'assetLabel': assetLabel,
      'productName': productName,
      if (branchId != null) 'branchId': branchId?.toJson(),
      if (branchName != null) 'branchName': branchName,
      if (costCenterId != null) 'costCenterId': costCenterId?.toJson(),
      if (costCenterName != null) 'costCenterName': costCenterName,
      'cost': cost,
      'monthlyAmount': monthlyAmount,
      'accumulated': accumulated,
      'netBookValue': netBookValue,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DepreciationPositionItem',
      'assetId': assetId.toJson(),
      'assetLabel': assetLabel,
      'productName': productName,
      if (branchId != null) 'branchId': branchId?.toJson(),
      if (branchName != null) 'branchName': branchName,
      if (costCenterId != null) 'costCenterId': costCenterId?.toJson(),
      if (costCenterName != null) 'costCenterName': costCenterName,
      'cost': cost,
      'monthlyAmount': monthlyAmount,
      'accumulated': accumulated,
      'netBookValue': netBookValue,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DepreciationPositionItemImpl extends DepreciationPositionItem {
  _DepreciationPositionItemImpl({
    required _is.UuidValue assetId,
    required String assetLabel,
    required String productName,
    _is.UuidValue? branchId,
    String? branchName,
    _is.UuidValue? costCenterId,
    String? costCenterName,
    required int cost,
    required int monthlyAmount,
    required int accumulated,
    required int netBookValue,
  }) : super._(
         assetId: assetId,
         assetLabel: assetLabel,
         productName: productName,
         branchId: branchId,
         branchName: branchName,
         costCenterId: costCenterId,
         costCenterName: costCenterName,
         cost: cost,
         monthlyAmount: monthlyAmount,
         accumulated: accumulated,
         netBookValue: netBookValue,
       );

  /// Returns a shallow copy of this [DepreciationPositionItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DepreciationPositionItem copyWith({
    _is.UuidValue? assetId,
    String? assetLabel,
    String? productName,
    _is.UuidValue? branchId = const _is.$UndefinedUuidValue(),
    Object? branchName = _Undefined,
    _is.UuidValue? costCenterId = const _is.$UndefinedUuidValue(),
    Object? costCenterName = _Undefined,
    int? cost,
    int? monthlyAmount,
    int? accumulated,
    int? netBookValue,
  }) {
    return DepreciationPositionItem(
      assetId: assetId ?? this.assetId,
      assetLabel: assetLabel ?? this.assetLabel,
      productName: productName ?? this.productName,
      branchId: branchId is _is.UndefinedSentinel ? this.branchId : branchId,
      branchName: branchName is String? ? branchName : this.branchName,
      costCenterId: costCenterId is _is.UndefinedSentinel ? this.costCenterId : costCenterId,
      costCenterName: costCenterName is String? ? costCenterName : this.costCenterName,
      cost: cost ?? this.cost,
      monthlyAmount: monthlyAmount ?? this.monthlyAmount,
      accumulated: accumulated ?? this.accumulated,
      netBookValue: netBookValue ?? this.netBookValue,
    );
  }
}
