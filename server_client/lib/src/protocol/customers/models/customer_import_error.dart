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

abstract class CustomerImportError implements _isc.SerializableModel, _isc.ProtocolSerialization {
  CustomerImportError._({
    required this.line,
    required this.column,
    required this.message,
  });

  factory CustomerImportError({
    required int line,
    required String column,
    required String message,
  }) = _CustomerImportErrorImpl;

  factory CustomerImportError.fromJson(Map<String, dynamic> jsonSerialization) {
    return CustomerImportError(
      line: jsonSerialization['line'] as int,
      column: jsonSerialization['column'] as String,
      message: jsonSerialization['message'] as String,
    );
  }

  int line;

  String column;

  String message;

  /// Returns a shallow copy of this [CustomerImportError]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  CustomerImportError copyWith({
    int? line,
    String? column,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'CustomerImportError',
      'line': line,
      'column': column,
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'CustomerImportError',
      'line': line,
      'column': column,
      'message': message,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _CustomerImportErrorImpl extends CustomerImportError {
  _CustomerImportErrorImpl({
    required int line,
    required String column,
    required String message,
  }) : super._(
         line: line,
         column: column,
         message: message,
       );

  /// Returns a shallow copy of this [CustomerImportError]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  CustomerImportError copyWith({
    int? line,
    String? column,
    String? message,
  }) {
    return CustomerImportError(
      line: line ?? this.line,
      column: column ?? this.column,
      message: message ?? this.message,
    );
  }
}
