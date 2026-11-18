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
import '../../catalog/models/checklist_item.dart' as _im7lyw5t;

abstract class ChecklistTemplateInput implements _is.SerializableModel, _is.ProtocolSerialization {
  ChecklistTemplateInput._({
    required this.code,
    required this.name,
    this.description,
    required this.items,
  });

  factory ChecklistTemplateInput({
    required String code,
    required String name,
    String? description,
    required List<_im7lyw5t.ChecklistItem> items,
  }) = _ChecklistTemplateInputImpl;

  factory ChecklistTemplateInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChecklistTemplateInput(
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      items: _isma42go.Protocol().deserialize<List<_im7lyw5t.ChecklistItem>>(jsonSerialization['items']),
    );
  }

  String code;

  String name;

  String? description;

  List<_im7lyw5t.ChecklistItem> items;

  /// Returns a shallow copy of this [ChecklistTemplateInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ChecklistTemplateInput copyWith({
    String? code,
    String? name,
    String? description,
    List<_im7lyw5t.ChecklistItem>? items,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChecklistTemplateInput',
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      'items': items.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChecklistTemplateInput',
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChecklistTemplateInputImpl extends ChecklistTemplateInput {
  _ChecklistTemplateInputImpl({
    required String code,
    required String name,
    String? description,
    required List<_im7lyw5t.ChecklistItem> items,
  }) : super._(
         code: code,
         name: name,
         description: description,
         items: items,
       );

  /// Returns a shallow copy of this [ChecklistTemplateInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ChecklistTemplateInput copyWith({
    String? code,
    String? name,
    Object? description = _Undefined,
    List<_im7lyw5t.ChecklistItem>? items,
  }) {
    return ChecklistTemplateInput(
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
    );
  }
}
