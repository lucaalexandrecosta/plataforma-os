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

abstract class WorkOrderType implements _is.SerializableModel, _is.ProtocolSerialization {
  WorkOrderType._({
    required this.id,
    required this.code,
    required this.name,
    required this.category,
    required this.defaultPriority,
    required this.requiresAsset,
    required this.isActive,
    required this.version,
    this.defaultChecklistTemplateId,
    this.defaultChecklistName,
    bool? requirePhotos,
    bool? requireSignature,
  }) : requirePhotos = requirePhotos ?? false,
       requireSignature = requireSignature ?? false;

  factory WorkOrderType({
    required _is.UuidValue id,
    required String code,
    required String name,
    required String category,
    required String defaultPriority,
    required bool requiresAsset,
    required bool isActive,
    required int version,
    _is.UuidValue? defaultChecklistTemplateId,
    String? defaultChecklistName,
    bool? requirePhotos,
    bool? requireSignature,
  }) = _WorkOrderTypeImpl;

  factory WorkOrderType.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkOrderType(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      category: jsonSerialization['category'] as String,
      defaultPriority: jsonSerialization['defaultPriority'] as String,
      requiresAsset: _is.BoolJsonExtension.fromJson(jsonSerialization['requiresAsset']),
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      version: jsonSerialization['version'] as int,
      defaultChecklistTemplateId: jsonSerialization['defaultChecklistTemplateId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['defaultChecklistTemplateId']),
      defaultChecklistName: jsonSerialization['defaultChecklistName'] as String?,
      requirePhotos: jsonSerialization['requirePhotos'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['requirePhotos']),
      requireSignature: jsonSerialization['requireSignature'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['requireSignature']),
    );
  }

  _is.UuidValue id;

  String code;

  String name;

  String category;

  String defaultPriority;

  bool requiresAsset;

  bool isActive;

  int version;

  _is.UuidValue? defaultChecklistTemplateId;

  String? defaultChecklistName;

  bool requirePhotos;

  bool requireSignature;

  /// Returns a shallow copy of this [WorkOrderType]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WorkOrderType copyWith({
    _is.UuidValue? id,
    String? code,
    String? name,
    String? category,
    String? defaultPriority,
    bool? requiresAsset,
    bool? isActive,
    int? version,
    _is.UuidValue? defaultChecklistTemplateId = const _is.$UndefinedUuidValue(),
    String? defaultChecklistName,
    bool? requirePhotos,
    bool? requireSignature,
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
      if (defaultChecklistTemplateId != null) 'defaultChecklistTemplateId': defaultChecklistTemplateId?.toJson(),
      if (defaultChecklistName != null) 'defaultChecklistName': defaultChecklistName,
      'requirePhotos': requirePhotos,
      'requireSignature': requireSignature,
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
      if (defaultChecklistTemplateId != null) 'defaultChecklistTemplateId': defaultChecklistTemplateId?.toJson(),
      if (defaultChecklistName != null) 'defaultChecklistName': defaultChecklistName,
      'requirePhotos': requirePhotos,
      'requireSignature': requireSignature,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkOrderTypeImpl extends WorkOrderType {
  _WorkOrderTypeImpl({
    required _is.UuidValue id,
    required String code,
    required String name,
    required String category,
    required String defaultPriority,
    required bool requiresAsset,
    required bool isActive,
    required int version,
    _is.UuidValue? defaultChecklistTemplateId,
    String? defaultChecklistName,
    bool? requirePhotos,
    bool? requireSignature,
  }) : super._(
         id: id,
         code: code,
         name: name,
         category: category,
         defaultPriority: defaultPriority,
         requiresAsset: requiresAsset,
         isActive: isActive,
         version: version,
         defaultChecklistTemplateId: defaultChecklistTemplateId,
         defaultChecklistName: defaultChecklistName,
         requirePhotos: requirePhotos,
         requireSignature: requireSignature,
       );

  /// Returns a shallow copy of this [WorkOrderType]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WorkOrderType copyWith({
    _is.UuidValue? id,
    String? code,
    String? name,
    String? category,
    String? defaultPriority,
    bool? requiresAsset,
    bool? isActive,
    int? version,
    _is.UuidValue? defaultChecklistTemplateId = const _is.$UndefinedUuidValue(),
    Object? defaultChecklistName = _Undefined,
    bool? requirePhotos,
    bool? requireSignature,
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
      defaultChecklistTemplateId: defaultChecklistTemplateId is _is.UndefinedSentinel
          ? this.defaultChecklistTemplateId
          : defaultChecklistTemplateId,
      defaultChecklistName: defaultChecklistName is String? ? defaultChecklistName : this.defaultChecklistName,
      requirePhotos: requirePhotos ?? this.requirePhotos,
      requireSignature: requireSignature ?? this.requireSignature,
    );
  }
}
