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
import '../../imports/models/import_run_info.dart' as _i2kryhup;

abstract class ImportRunPage implements _is.SerializableModel, _is.ProtocolSerialization {
  ImportRunPage._({
    required this.items,
    this.nextCursor,
    required this.hasMore,
  });

  factory ImportRunPage({
    required List<_i2kryhup.ImportRunInfo> items,
    String? nextCursor,
    required bool hasMore,
  }) = _ImportRunPageImpl;

  factory ImportRunPage.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportRunPage(
      items: _isma42go.Protocol().deserialize<List<_i2kryhup.ImportRunInfo>>(jsonSerialization['items']),
      nextCursor: jsonSerialization['nextCursor'] as String?,
      hasMore: _is.BoolJsonExtension.fromJson(jsonSerialization['hasMore']),
    );
  }

  List<_i2kryhup.ImportRunInfo> items;

  String? nextCursor;

  bool hasMore;

  /// Returns a shallow copy of this [ImportRunPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ImportRunPage copyWith({
    List<_i2kryhup.ImportRunInfo>? items,
    String? nextCursor,
    bool? hasMore,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportRunPage',
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      if (nextCursor != null) 'nextCursor': nextCursor,
      'hasMore': hasMore,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportRunPage',
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (nextCursor != null) 'nextCursor': nextCursor,
      'hasMore': hasMore,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImportRunPageImpl extends ImportRunPage {
  _ImportRunPageImpl({
    required List<_i2kryhup.ImportRunInfo> items,
    String? nextCursor,
    required bool hasMore,
  }) : super._(
         items: items,
         nextCursor: nextCursor,
         hasMore: hasMore,
       );

  /// Returns a shallow copy of this [ImportRunPage]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ImportRunPage copyWith({
    List<_i2kryhup.ImportRunInfo>? items,
    Object? nextCursor = _Undefined,
    bool? hasMore,
  }) {
    return ImportRunPage(
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      nextCursor: nextCursor is String? ? nextCursor : this.nextCursor,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}
