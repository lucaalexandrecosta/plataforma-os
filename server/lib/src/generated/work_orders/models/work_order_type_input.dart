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

abstract class WorkOrderTypeInput implements _is.SerializableModel, _is.ProtocolSerialization {
  WorkOrderTypeInput._({
    required this.code,
    required this.name,
    required this.category,
    required this.defaultPriority,
    required this.requiresAsset,
    required this.isActive,
    this.defaultChecklistTemplateId,
    this.requirePhotos,
    this.requireSignature,
  });

  factory WorkOrderTypeInput({
    required String code,
    required String name,
    required String category,
    required String defaultPriority,
    required bool requiresAsset,
    required bool isActive,
    _is.UuidValue? defaultChecklistTemplateId,
    bool? requirePhotos,
    bool? requireSignature,
  }) = _WorkOrderTypeInputImpl;

  factory WorkOrderTypeInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkOrderTypeInput(
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      category: jsonSerialization['category'] as String,
      defaultPriority: jsonSerialization['defaultPriority'] as String,
      requiresAsset: _is.BoolJsonExtension.fromJson(jsonSerialization['requiresAsset']),
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      defaultChecklistTemplateId: jsonSerialization['defaultChecklistTemplateId'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['defaultChecklistTemplateId']),
      requirePhotos: jsonSerialization['requirePhotos'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['requirePhotos']),
      requireSignature: jsonSerialization['requireSignature'] == null
          ? null
          : _is.BoolJsonExtension.fromJson(jsonSerialization['requireSignature']),
    );
  }

  String code;

  String name;

  String category;

  String defaultPriority;

  bool requiresAsset;

  bool isActive;

  _is.UuidValue? defaultChecklistTemplateId;

  bool? requirePhotos;

  bool? requireSignature;

  /// Returns a shallow copy of this [WorkOrderTypeInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  WorkOrderTypeInput copyWith({
    String? code,
    String? name,
    String? category,
    String? defaultPriority,
    bool? requiresAsset,
    bool? isActive,
    _is.UuidValue? defaultChecklistTemplateId = const _is.$UndefinedUuidValue(),
    bool? requirePhotos,
    bool? requireSignature,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'WorkOrderTypeInput',
      'code': code,
      'name': name,
      'category': category,
      'defaultPriority': defaultPriority,
      'requiresAsset': requiresAsset,
      'isActive': isActive,
      if (defaultChecklistTemplateId != null) 'defaultChecklistTemplateId': defaultChecklistTemplateId?.toJson(),
      if (requirePhotos != null) 'requirePhotos': requirePhotos,
      if (requireSignature != null) 'requireSignature': requireSignature,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'WorkOrderTypeInput',
      'code': code,
      'name': name,
      'category': category,
      'defaultPriority': defaultPriority,
      'requiresAsset': requiresAsset,
      'isActive': isActive,
      if (defaultChecklistTemplateId != null) 'defaultChecklistTemplateId': defaultChecklistTemplateId?.toJson(),
      if (requirePhotos != null) 'requirePhotos': requirePhotos,
      if (requireSignature != null) 'requireSignature': requireSignature,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _WorkOrderTypeInputImpl extends WorkOrderTypeInput {
  _WorkOrderTypeInputImpl({
    required String code,
    required String name,
    required String category,
    required String defaultPriority,
    required bool requiresAsset,
    required bool isActive,
    _is.UuidValue? defaultChecklistTemplateId,
    bool? requirePhotos,
    bool? requireSignature,
  }) : super._(
         code: code,
         name: name,
         category: category,
         defaultPriority: defaultPriority,
         requiresAsset: requiresAsset,
         isActive: isActive,
         defaultChecklistTemplateId: defaultChecklistTemplateId,
         requirePhotos: requirePhotos,
         requireSignature: requireSignature,
       );

  /// Returns a shallow copy of this [WorkOrderTypeInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  WorkOrderTypeInput copyWith({
    String? code,
    String? name,
    String? category,
    String? defaultPriority,
    bool? requiresAsset,
    bool? isActive,
    _is.UuidValue? defaultChecklistTemplateId = const _is.$UndefinedUuidValue(),
    Object? requirePhotos = _Undefined,
    Object? requireSignature = _Undefined,
  }) {
    return WorkOrderTypeInput(
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      defaultPriority: defaultPriority ?? this.defaultPriority,
      requiresAsset: requiresAsset ?? this.requiresAsset,
      isActive: isActive ?? this.isActive,
      defaultChecklistTemplateId: defaultChecklistTemplateId is _is.UndefinedSentinel
          ? this.defaultChecklistTemplateId
          : defaultChecklistTemplateId,
      requirePhotos: requirePhotos is bool? ? requirePhotos : this.requirePhotos,
      requireSignature: requireSignature is bool? ? requireSignature : this.requireSignature,
    );
  }
}
