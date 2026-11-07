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

abstract class FieldError implements _is.SerializableModel, _is.ProtocolSerialization {
  FieldError._({
    required this.path,
    required this.code,
    required this.message,
  });

  factory FieldError({
    required String path,
    required String code,
    required String message,
  }) = _FieldErrorImpl;

  factory FieldError.fromJson(Map<String, dynamic> jsonSerialization) {
    return FieldError(
      path: jsonSerialization['path'] as String,
      code: jsonSerialization['code'] as String,
      message: jsonSerialization['message'] as String,
    );
  }

  String path;

  String code;

  String message;

  /// Returns a shallow copy of this [FieldError]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  FieldError copyWith({
    String? path,
    String? code,
    String? message,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'FieldError',
      'path': path,
      'code': code,
      'message': message,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'FieldError',
      'path': path,
      'code': code,
      'message': message,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _FieldErrorImpl extends FieldError {
  _FieldErrorImpl({
    required String path,
    required String code,
    required String message,
  }) : super._(
         path: path,
         code: code,
         message: message,
       );

  /// Returns a shallow copy of this [FieldError]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  FieldError copyWith({
    String? path,
    String? code,
    String? message,
  }) {
    return FieldError(
      path: path ?? this.path,
      code: code ?? this.code,
      message: message ?? this.message,
    );
  }
}
