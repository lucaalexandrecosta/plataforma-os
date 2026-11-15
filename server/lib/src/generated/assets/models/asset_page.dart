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
import '../../assets/models/asset.dart' as _irmhhex7;

abstract class AssetPage implements _is.SerializableModel, _is.ProtocolSerialization {
  AssetPage._({
    required this.items,
    required this.total,
  });

  factory AssetPage({
    required List<_irmhhex7.Asset> items,
    required int total,
  }) = _AssetPageImpl;

  factory AssetPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return AssetPage(
      items: _isma42go.Protocol().deserialize<List<_irmhhex7.Asset>>(jsonSerialization['items']),
      total: jsonSerialization['total'] as int,
    );
  }

  List<_irmhhex7.Asset> items;

  int total;

  /// Returns a shallow copy of this [AssetPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AssetPage copyWith({
    List<_irmhhex7.Asset>? items,
    int? total,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AssetPage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      'total': total,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AssetPage',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'total': total,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _AssetPageImpl extends AssetPage {
  _AssetPageImpl({
    required List<_irmhhex7.Asset> items,
    required int total,
  }) : super._(
         items: items,
         total: total,
       );

  /// Returns a shallow copy of this [AssetPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AssetPage copyWith({
    List<_irmhhex7.Asset>? items,
    int? total,
  }) {
    return AssetPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      total: total ?? this.total,
    );
  }
}
