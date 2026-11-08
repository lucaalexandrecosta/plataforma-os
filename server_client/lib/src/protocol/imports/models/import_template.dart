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
import 'dart:typed_data' as _idt;
import 'package:plataforma_os_client/src/protocol/protocol.dart' as _inlzmlpe;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../imports/models/import_column_info.dart' as _irak8i4f;
import '../../imports/models/import_entity_type.dart' as _incxtnh4;

abstract class ImportTemplate implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ImportTemplate._({
    required this.entityType,
    required this.title,
    required this.description,
    required this.columns,
    required this.fileName,
    required this.csv,
  });

  factory ImportTemplate({
    required _incxtnh4.ImportEntityType entityType,
    required String title,
    required String description,
    required List<_irak8i4f.ImportColumnInfo> columns,
    required String fileName,
    required _idt.ByteData csv,
  }) = _ImportTemplateImpl;

  factory ImportTemplate.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportTemplate(
      entityType: _incxtnh4.ImportEntityType.fromJson((jsonSerialization['entityType'] as String)),
      title: jsonSerialization['title'] as String,
      description: jsonSerialization['description'] as String,
      columns: _inlzmlpe.Protocol().deserialize<List<_irak8i4f.ImportColumnInfo>>(jsonSerialization['columns']),
      fileName: jsonSerialization['fileName'] as String,
      csv: _isc.ByteDataJsonExtension.fromJson(jsonSerialization['csv']),
    );
  }

  _incxtnh4.ImportEntityType entityType;

  String title;

  String description;

  List<_irak8i4f.ImportColumnInfo> columns;

  String fileName;

  _idt.ByteData csv;

  /// Returns a shallow copy of this [ImportTemplate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ImportTemplate copyWith({
    _incxtnh4.ImportEntityType? entityType,
    String? title,
    String? description,
    List<_irak8i4f.ImportColumnInfo>? columns,
    String? fileName,
    _idt.ByteData? csv,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportTemplate',
      'entityType': entityType.toJson(),
      'title': title,
      'description': description,
      'columns': columns.toJson(valueToJson: (v) => v.toJson()),
      'fileName': fileName,
      'csv': csv.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportTemplate',
      'entityType': entityType.toJson(),
      'title': title,
      'description': description,
      'columns': columns.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      'fileName': fileName,
      'csv': csv.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ImportTemplateImpl extends ImportTemplate {
  _ImportTemplateImpl({
    required _incxtnh4.ImportEntityType entityType,
    required String title,
    required String description,
    required List<_irak8i4f.ImportColumnInfo> columns,
    required String fileName,
    required _idt.ByteData csv,
  }) : super._(
         entityType: entityType,
         title: title,
         description: description,
         columns: columns,
         fileName: fileName,
         csv: csv,
       );

  /// Returns a shallow copy of this [ImportTemplate]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ImportTemplate copyWith({
    _incxtnh4.ImportEntityType? entityType,
    String? title,
    String? description,
    List<_irak8i4f.ImportColumnInfo>? columns,
    String? fileName,
    _idt.ByteData? csv,
  }) {
    return ImportTemplate(
      entityType: entityType ?? this.entityType,
      title: title ?? this.title,
      description: description ?? this.description,
      columns: columns ?? this.columns.map((e0) => e0.copyWith()).toList(),
      fileName: fileName ?? this.fileName,
      csv: csv ?? this.csv.clone(),
    );
  }
}
