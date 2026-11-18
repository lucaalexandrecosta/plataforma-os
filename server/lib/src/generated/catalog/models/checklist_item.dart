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

abstract class ChecklistItem implements _is.SerializableModel, _is.ProtocolSerialization {
  ChecklistItem._({
    this.key,
    required this.label,
    required this.type,
    required this.required,
    this.options,
    this.unit,
  });

  factory ChecklistItem({
    String? key,
    required String label,
    required String type,
    required bool required,
    List<String>? options,
    String? unit,
  }) = _ChecklistItemImpl;

  factory ChecklistItem.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChecklistItem(
      key: jsonSerialization['key'] as String?,
      label: jsonSerialization['label'] as String,
      type: jsonSerialization['type'] as String,
      required: _is.BoolJsonExtension.fromJson(jsonSerialization['required']),
      options: jsonSerialization['options'] == null
          ? null
          : _isma42go.Protocol().deserialize<List<String>>(jsonSerialization['options']),
      unit: jsonSerialization['unit'] as String?,
    );
  }

  String? key;

  String label;

  String type;

  bool required;

  List<String>? options;

  String? unit;

  /// Returns a shallow copy of this [ChecklistItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ChecklistItem copyWith({
    String? key,
    String? label,
    String? type,
    bool? required,
    List<String>? options = const _is.$UndefinedList<String>(),
    String? unit,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChecklistItem',
      if (key != null) 'key': key,
      'label': label,
      'type': type,
      'required': required,
      if (options != null) 'options': options?.toJson(),
      if (unit != null) 'unit': unit,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChecklistItem',
      if (key != null) 'key': key,
      'label': label,
      'type': type,
      'required': required,
      if (options != null) 'options': options?.toJson(),
      if (unit != null) 'unit': unit,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChecklistItemImpl extends ChecklistItem {
  _ChecklistItemImpl({
    String? key,
    required String label,
    required String type,
    required bool required,
    List<String>? options,
    String? unit,
  }) : super._(
         key: key,
         label: label,
         type: type,
         required: required,
         options: options,
         unit: unit,
       );

  /// Returns a shallow copy of this [ChecklistItem]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ChecklistItem copyWith({
    Object? key = _Undefined,
    String? label,
    String? type,
    bool? required,
    List<String>? options = const _is.$UndefinedList<String>(),
    Object? unit = _Undefined,
  }) {
    return ChecklistItem(
      key: key is String? ? key : this.key,
      label: label ?? this.label,
      type: type ?? this.type,
      required: required ?? this.required,
      options: options is _is.UndefinedSentinel ? this.options?.map((e0) => e0).toList() : options,
      unit: unit is String? ? unit : this.unit,
    );
  }
}
