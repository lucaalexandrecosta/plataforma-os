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

abstract class ImportColumnInfo implements _is.SerializableModel, _is.ProtocolSerialization {
  ImportColumnInfo._({
    required this.key,
    required this.label,
    required this.isRequired,
    required this.help,
    required this.example,
  });

  factory ImportColumnInfo({
    required String key,
    required String label,
    required bool isRequired,
    required String help,
    required String example,
  }) = _ImportColumnInfoImpl;

  factory ImportColumnInfo.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportColumnInfo(
      key: jsonSerialization['key'] as String,
      label: jsonSerialization['label'] as String,
      isRequired: _is.BoolJsonExtension.fromJson(jsonSerialization['isRequired']),
      help: jsonSerialization['help'] as String,
      example: jsonSerialization['example'] as String,
    );
  }

  String key;

  String label;

  bool isRequired;

  String help;

  String example;

  /// Returns a shallow copy of this [ImportColumnInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ImportColumnInfo copyWith({
    String? key,
    String? label,
    bool? isRequired,
    String? help,
    String? example,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportColumnInfo',
      'key': key,
      'label': label,
      'isRequired': isRequired,
      'help': help,
      'example': example,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportColumnInfo',
      'key': key,
      'label': label,
      'isRequired': isRequired,
      'help': help,
      'example': example,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _ImportColumnInfoImpl extends ImportColumnInfo {
  _ImportColumnInfoImpl({
    required String key,
    required String label,
    required bool isRequired,
    required String help,
    required String example,
  }) : super._(
         key: key,
         label: label,
         isRequired: isRequired,
         help: help,
         example: example,
       );

  /// Returns a shallow copy of this [ImportColumnInfo]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ImportColumnInfo copyWith({
    String? key,
    String? label,
    bool? isRequired,
    String? help,
    String? example,
  }) {
    return ImportColumnInfo(
      key: key ?? this.key,
      label: label ?? this.label,
      isRequired: isRequired ?? this.isRequired,
      help: help ?? this.help,
      example: example ?? this.example,
    );
  }
}
