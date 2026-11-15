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

abstract class WorkOrderType implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WorkOrderType._({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.defaultPriority,
    required this.requiresAsset,
    required this.isActive,
    required this.version,
  });

  factory WorkOrderType({
    required _isc.UuidValue id,
    required String code,
    required String name,
    required String category,
    required String defaultPriority,
    required bool requiresAsset,
    required bool isActive,
    required int version,
  }) = _WorkOrderTypeImpl;

  factory WorkOrderType.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkOrderType(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      category: jsonSerialization['category'] as String,
      defaultPriority: jsonSerialization['defaultPriority'] as String,
      requiresAsset: _isc.BoolJsonExtension.fromJson(jsonSerialization['requiresAsset']),
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      version: jsonSerialization['version'] as int,
    );
  }

  _isc.UuidValue id;

  String code;

  String name;

  String category;

  String defaultPriority;

  bool requiresAsset;

  bool isActive;

  int version;

  /// Returns a shallow copy of this [WorkOrderType]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WorkOrderType copyWith({
    _isc.UuidValue? id,
    String? code,
    String? name,
    String? category,
    String? defaultPriority,
    bool? requiresAsset,
    bool? isActive,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkOrderType',
      'id': id.toJson(),
      'code': code,
      'name': name,
      'category': category,
      'defaultPriority': defaultPriority,
      'requiresAsset': requiresAsset,
      'isActive': isActive,
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkOrderType',
      'id': id.toJson(),
      'code': code,
      'name': name,
      'category': category,
      'defaultPriority': defaultPriority,
      'requiresAsset': requiresAsset,
      'isActive': isActive,
      'version': version,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _WorkOrderTypeImpl extends WorkOrderType {
  _WorkOrderTypeImpl({
    required _isc.UuidValue id,
    required String code,
    required String name,
    required String category,
    required String defaultPriority,
    required bool requiresAsset,
    required bool isActive,
    required int version,
  }) : super._(
         id: id,
         code: code,
         name: name,
         category: category,
         defaultPriority: defaultPriority,
         requiresAsset: requiresAsset,
         isActive: isActive,
         version: version,
       );

  /// Returns a shallow copy of this [WorkOrderType]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WorkOrderType copyWith({
    _isc.UuidValue? id,
    String? code,
    String? name,
    String? category,
    String? defaultPriority,
    bool? requiresAsset,
    bool? isActive,
    int? version,
  }) {
    return WorkOrderType(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      defaultPriority: defaultPriority ?? this.defaultPriority,
      requiresAsset: requiresAsset ?? this.requiresAsset,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
    );
  }
}
