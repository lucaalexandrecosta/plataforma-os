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
import '../../patrimony/models/depreciation_line.dart' as _ixmz403m;
import '../../patrimony/models/depreciation_profile.dart' as _iyft1igh;

abstract class AssetDepreciation implements _is.SerializableModel, _is.ProtocolSerialization {
  AssetDepreciation._({
    required this.profile,
    required this.cost,
    required this.residualValue,
    required this.lines,
  });

  factory AssetDepreciation({
    required _iyft1igh.DepreciationProfile profile,
    required int cost,
    required int residualValue,
    required List<_ixmz403m.DepreciationLine> lines,
  }) = _AssetDepreciationImpl;

  factory AssetDepreciation.fromJson(Map<String, dynamic> jsonSerialization) {
    return AssetDepreciation(
      profile: _isma42go.Protocol().deserialize<_iyft1igh.DepreciationProfile>(jsonSerialization['profile']),
      cost: jsonSerialization['cost'] as int,
      residualValue: jsonSerialization['residualValue'] as int,
      lines: _isma42go.Protocol().deserialize<List<_ixmz403m.DepreciationLine>>(jsonSerialization['lines']),
    );
  }

  _iyft1igh.DepreciationProfile profile;

  int cost;

  int residualValue;

  List<_ixmz403m.DepreciationLine> lines;

  /// Returns a shallow copy of this [AssetDepreciation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AssetDepreciation copyWith({
    _iyft1igh.DepreciationProfile? profile,
    int? cost,
    int? residualValue,
    List<_ixmz403m.DepreciationLine>? lines,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AssetDepreciation',
      'profile': profile.toJson(),
      'cost': cost,
      'residualValue': residualValue,
      'lines': lines.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AssetDepreciation',
      'profile': profile.toJsonForProtocol(),
      'cost': cost,
      'residualValue': residualValue,
      'lines': lines.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AssetDepreciationImpl extends AssetDepreciation {
  _AssetDepreciationImpl({
    required _iyft1igh.DepreciationProfile profile,
    required int cost,
    required int residualValue,
    required List<_ixmz403m.DepreciationLine> lines,
  }) : super._(
         profile: profile,
         cost: cost,
         residualValue: residualValue,
         lines: lines,
       );

  /// Returns a shallow copy of this [AssetDepreciation]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AssetDepreciation copyWith({
    _iyft1igh.DepreciationProfile? profile,
    int? cost,
    int? residualValue,
    List<_ixmz403m.DepreciationLine>? lines,
  }) {
    return AssetDepreciation(
      profile: profile ?? this.profile.copyWith(),
      cost: cost ?? this.cost,
      residualValue: residualValue ?? this.residualValue,
      lines: lines ?? this.lines.map((e0) => e0.copyWith()).toList(),
    );
  }
}
