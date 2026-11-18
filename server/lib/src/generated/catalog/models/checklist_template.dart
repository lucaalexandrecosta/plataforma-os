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

abstract class ChecklistTemplate implements _is.SerializableModel, _is.ProtocolSerialization {
  ChecklistTemplate._({
    required this.id,
    required this.code,
    required this.name,
    this.description,
    required this.templateVersion,
    required this.status,
    required this.items,
    this.publishedAt,
    required this.isActive,
    required this.version,
  });

  factory ChecklistTemplate({
    required _is.UuidValue id,
    required String code,
    required String name,
    String? description,
    required int templateVersion,
    required String status,
    required List<_im7lyw5t.ChecklistItem> items,
    DateTime? publishedAt,
    required bool isActive,
    required int version,
  }) = _ChecklistTemplateImpl;

  factory ChecklistTemplate.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChecklistTemplate(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
      templateVersion: jsonSerialization['templateVersion'] as int,
      status: jsonSerialization['status'] as String,
      items: _isma42go.Protocol().deserialize<List<_im7lyw5t.ChecklistItem>>(jsonSerialization['items']),
      publishedAt: jsonSerialization['publishedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['publishedAt']),
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
      version: jsonSerialization['version'] as int,
    );
  }

  _is.UuidValue id;

  String code;

  String name;

  String? description;

  int templateVersion;

  String status;

  List<_im7lyw5t.ChecklistItem> items;

  DateTime? publishedAt;

  bool isActive;

  int version;

  /// Returns a shallow copy of this [ChecklistTemplate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ChecklistTemplate copyWith({
    _is.UuidValue? id,
    String? code,
    String? name,
    String? description,
    int? templateVersion,
    String? status,
    List<_im7lyw5t.ChecklistItem>? items,
    DateTime? publishedAt = const _is.$UndefinedDateTime(),
    bool? isActive,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChecklistTemplate',
      'id': id.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      'templateVersion': templateVersion,
      'status': status,
      'items': items.toJson(valueToJson: (v) => v.toJson()),
      if (publishedAt != null) 'publishedAt': publishedAt?.toJson(),
      'isActive': isActive,
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChecklistTemplate',
      'id': id.toJson(),
      'code': code,
      'name': name,
      if (description != null) 'description': description,
      'templateVersion': templateVersion,
      'status': status,
      'items': items.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (publishedAt != null) 'publishedAt': publishedAt?.toJson(),
      'isActive': isActive,
      'version': version,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChecklistTemplateImpl extends ChecklistTemplate {
  _ChecklistTemplateImpl({
    required _is.UuidValue id,
    required String code,
    required String name,
    String? description,
    required int templateVersion,
    required String status,
    required List<_im7lyw5t.ChecklistItem> items,
    DateTime? publishedAt,
    required bool isActive,
    required int version,
  }) : super._(
         id: id,
         code: code,
         name: name,
         description: description,
         templateVersion: templateVersion,
         status: status,
         items: items,
         publishedAt: publishedAt,
         isActive: isActive,
         version: version,
       );

  /// Returns a shallow copy of this [ChecklistTemplate]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ChecklistTemplate copyWith({
    _is.UuidValue? id,
    String? code,
    String? name,
    Object? description = _Undefined,
    int? templateVersion,
    String? status,
    List<_im7lyw5t.ChecklistItem>? items,
    DateTime? publishedAt = const _is.$UndefinedDateTime(),
    bool? isActive,
    int? version,
  }) {
    return ChecklistTemplate(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
      templateVersion: templateVersion ?? this.templateVersion,
      status: status ?? this.status,
      items: items ?? this.items.map((e0) => e0.copyWith()).toList(),
      publishedAt: publishedAt is _is.UndefinedSentinel ? this.publishedAt : publishedAt,
      isActive: isActive ?? this.isActive,
      version: version ?? this.version,
    );
  }
}
