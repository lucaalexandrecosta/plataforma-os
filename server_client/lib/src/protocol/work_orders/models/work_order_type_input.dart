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

abstract class WorkOrderTypeInput implements _isc.SerializableModel, _isc.ProtocolSerialization {
  WorkOrderTypeInput._({
    required this.code,
    required this.name,
    required this.category,
    required this.defaultPriority,
    required this.requiresAsset,
    required this.isActive,
  });

  factory WorkOrderTypeInput({
    required String code,
    required String name,
    required String category,
    required String defaultPriority,
    required bool requiresAsset,
    required bool isActive,
  }) = _WorkOrderTypeInputImpl;

  factory WorkOrderTypeInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return WorkOrderTypeInput(
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      category: jsonSerialization['category'] as String,
      defaultPriority: jsonSerialization['defaultPriority'] as String,
      requiresAsset: _isc.BoolJsonExtension.fromJson(jsonSerialization['requiresAsset']),
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  String code;

  String name;

  String category;

  String defaultPriority;

  bool requiresAsset;

  bool isActive;

  /// Returns a shallow copy of this [WorkOrderTypeInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  WorkOrderTypeInput copyWith({
    String? code,
    String? name,
    String? category,
    String? defaultPriority,
    bool? requiresAsset,
    bool? isActive,
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
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _WorkOrderTypeInputImpl extends WorkOrderTypeInput {
  _WorkOrderTypeInputImpl({
    required String code,
    required String name,
    required String category,
    required String defaultPriority,
    required bool requiresAsset,
    required bool isActive,
  }) : super._(
         code: code,
         name: name,
         category: category,
         defaultPriority: defaultPriority,
         requiresAsset: requiresAsset,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [WorkOrderTypeInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  WorkOrderTypeInput copyWith({
    String? code,
    String? name,
    String? category,
    String? defaultPriority,
    bool? requiresAsset,
    bool? isActive,
  }) {
    return WorkOrderTypeInput(
      code: code ?? this.code,
      name: name ?? this.name,
      category: category ?? this.category,
      defaultPriority: defaultPriority ?? this.defaultPriority,
      requiresAsset: requiresAsset ?? this.requiresAsset,
      isActive: isActive ?? this.isActive,
    );
  }
}
