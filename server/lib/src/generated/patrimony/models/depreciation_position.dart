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
import '../../patrimony/models/depreciation_group_total.dart' as _irmi04wj;
import '../../patrimony/models/depreciation_position_item.dart' as _igw7gtto;

abstract class DepreciationPosition implements _is.SerializableModel, _is.ProtocolSerialization {
  DepreciationPosition._({
    required this.year,
    required this.month,
    required this.closed,
    required this.items,
    required this.byCostCenter,
    required this.byBranch,
    required this.total,
  });

  factory DepreciationPosition({
    required int year,
    required int month,
    required bool closed,
    required List<_igw7gtto.DepreciationPositionItem> items,
    required List<_irmi04wj.DepreciationGroupTotal> byCostCenter,
    required List<_irmi04wj.DepreciationGroupTotal> byBranch,
    required _irmi04wj.DepreciationGroupTotal total,
  }) = _DepreciationPositionImpl;

  factory DepreciationPosition.fromJson(Map<String, dynamic> jsonSerialization) {
    return DepreciationPosition(
      year: jsonSerialization['year'] as int,
      month: jsonSerialization['month'] as int,
      closed: _is.BoolJsonExtension.fromJson(jsonSerialization['closed']),
      items: _isma42go.Protocol().deserialize<List<_igw7gtto.DepreciationPositionItem>>(jsonSerialization['items']),
      byCostCenter: _isma42go.Protocol().deserialize<List<_irmi04wj.DepreciationGroupTotal>>(
        jsonSerialization['byCostCenter'],
      ),
      byBranch: _isma42go.Protocol().deserialize<List<_irmi04wj.DepreciationGroupTotal>>(jsonSerialization['byBranch']),
      total: _isma42go.Protocol().deserialize<_irmi04wj.DepreciationGroupTotal>(jsonSerialization['total']),
    );
  }

  int year;

  int month;

  bool closed;

  List<_igw7gtto.DepreciationPositionItem> items;

  List<_irmi04wj.DepreciationGroupTotal> byCostCenter;

  List<_irmi04wj.DepreciationGroupTotal> byBranch;

  _irmi04wj.DepreciationGroupTotal total;

  /// Returns a shallow copy of this [DepreciationPosition]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  DepreciationPosition copyWith({
    int? year,
    int? month,
    bool? closed,
    List<_igw7gtto.DepreciationPositionItem>? items,
    List<_irmi04wj.DepreciationGroupTotal>? byCostCenter,
    List<_irmi04wj.DepreciationGroupTotal>? byBranch,
    _irmi04wj.DepreciationGroupTotal? total,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DepreciationPosition',
      'year': year,
      'month': month,
      'closed': closed,
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'byCostCenter': byCostCenter.toJson(valueToJson: (v) => v.toJson()),
      'byBranch': byBranch.toJson(valueToJson: (v) => v.toJson()),
      'total': total.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DepreciationPosition',
      'year': year,
      'month': month,
      'closed': closed,
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'byCostCenter': byCostCenter.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'byBranch': byBranch.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'total': total.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _DepreciationPositionImpl extends DepreciationPosition {
  _DepreciationPositionImpl({
    required int year,
    required int month,
    required bool closed,
    required List<_igw7gtto.DepreciationPositionItem> items,
    required List<_irmi04wj.DepreciationGroupTotal> byCostCenter,
    required List<_irmi04wj.DepreciationGroupTotal> byBranch,
    required _irmi04wj.DepreciationGroupTotal total,
  }) : super._(
         year: year,
         month: month,
         closed: closed,
         items: items,
         byCostCenter: byCostCenter,
         byBranch: byBranch,
         total: total,
       );

  /// Returns a shallow copy of this [DepreciationPosition]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  DepreciationPosition copyWith({
    int? year,
    int? month,
    bool? closed,
    List<_igw7gtto.DepreciationPositionItem>? items,
    List<_irmi04wj.DepreciationGroupTotal>? byCostCenter,
    List<_irmi04wj.DepreciationGroupTotal>? byBranch,
    _irmi04wj.DepreciationGroupTotal? total,
  }) {
    return DepreciationPosition(
      year: year ?? this.year,
      month: month ?? this.month,
      closed: closed ?? this.closed,
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      byCostCenter: byCostCenter ?? this.byCostCenter.map((e0) => e0.copyWith()).toList(),
      byBranch: byBranch ?? this.byBranch.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total.copyWith(),
    );
  }
}
