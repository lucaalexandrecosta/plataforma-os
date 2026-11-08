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
import 'package:plataforma_os_client/src/protocol/protocol.dart' as _inlzmlpe;
import 'package:serverpod_client/serverpod_client.dart' as _isc;

abstract class ImportRowError implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ImportRowError._({
    required this.rowNumber,
    this.key,
    required this.messages,
  });

  factory ImportRowError({
    required int rowNumber,
    String? key,
    required List<String> messages,
  }) = _ImportRowErrorImpl;

  factory ImportRowError.fromJson(Map<String, dynamic> jsonSerialization) {
    return ImportRowError(
      rowNumber: jsonSerialization['rowNumber'] as int,
      key: jsonSerialization['key'] as String?,
      messages: _inlzmlpe.Protocol().deserialize<List<String>>(jsonSerialization['messages']),
    );
  }

  int rowNumber;

  String? key;

  List<String> messages;

  /// Returns a shallow copy of this [ImportRowError]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ImportRowError copyWith({
    int? rowNumber,
    String? key,
    List<String>? messages,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ImportRowError',
      'rowNumber': rowNumber,
      if (key != null) 'key': key,
      'messages': messages.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ImportRowError',
      'rowNumber': rowNumber,
      if (key != null) 'key': key,
      'messages': messages.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ImportRowErrorImpl extends ImportRowError {
  _ImportRowErrorImpl({
    required int rowNumber,
    String? key,
    required List<String> messages,
  }) : super._(
         rowNumber: rowNumber,
         key: key,
         messages: messages,
       );

  /// Returns a shallow copy of this [ImportRowError]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ImportRowError copyWith({
    int? rowNumber,
    Object? key = _Undefined,
    List<String>? messages,
  }) {
    return ImportRowError(
      rowNumber: rowNumber ?? this.rowNumber,
      key: key is String? ? key : this.key,
      messages: messages ?? this.messages.map((e0) => e0).toList(),
    );
  }
}
