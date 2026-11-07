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
import '../../../platform/errors/models/error_category.dart' as _i19dk5at;
import '../../../platform/errors/models/field_error.dart' as _i647assy;

abstract class ApiException implements _is.SerializableException, _is.SerializableModel, _is.ProtocolSerialization {
  ApiException._({
    required this.code,
    required this.category,
    required this.detail,
    required this.traceId,
    this.fieldErrors,
    this.currentVersion,
    this.retryAfterSeconds,
    this.meta,
  });

  factory ApiException({
    required String code,
    required _i19dk5at.ErrorCategory category,
    required String detail,
    required String traceId,
    List<_i647assy.FieldError>? fieldErrors,
    int? currentVersion,
    int? retryAfterSeconds,
    Map<String, String>? meta,
  }) = _ApiExceptionImpl;

  factory ApiException.fromJson(Map<String, dynamic> jsonSerialization) {
    return ApiException(
      code: jsonSerialization['code'] as String,
      category: _i19dk5at.ErrorCategory.fromJson((jsonSerialization['category'] as String)),
      detail: jsonSerialization['detail'] as String,
      traceId: jsonSerialization['traceId'] as String,
      fieldErrors: jsonSerialization['fieldErrors'] == null
          ? null
          : _isma42go.Protocol().deserialize<List<_i647assy.FieldError>>(jsonSerialization['fieldErrors']),
      currentVersion: jsonSerialization['currentVersion'] as int?,
      retryAfterSeconds: jsonSerialization['retryAfterSeconds'] as int?,
      meta: jsonSerialization['meta'] == null
          ? null
          : _isma42go.Protocol().deserialize<Map<String, String>>(jsonSerialization['meta']),
    );
  }

  String code;

  _i19dk5at.ErrorCategory category;

  String detail;

  String traceId;

  List<_i647assy.FieldError>? fieldErrors;

  int? currentVersion;

  int? retryAfterSeconds;

  Map<String, String>? meta;

  /// Returns a shallow copy of this [ApiException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ApiException copyWith({
    String? code,
    _i19dk5at.ErrorCategory? category,
    String? detail,
    String? traceId,
    List<_i647assy.FieldError>? fieldErrors = const _is.$UndefinedList<_i647assy.FieldError>(),
    int? currentVersion,
    int? retryAfterSeconds,
    Map<String, String>? meta = const _is.$UndefinedMap<String, String>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ApiException',
      'code': code,
      'category': category.toJson(),
      'detail': detail,
      'traceId': traceId,
      if (fieldErrors != null) 'fieldErrors': fieldErrors?.toJson(valueToJson: (v) => v.toJson()),
      if (currentVersion != null) 'currentVersion': currentVersion,
      if (retryAfterSeconds != null) 'retryAfterSeconds': retryAfterSeconds,
      if (meta != null) 'meta': meta?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ApiException',
      'code': code,
      'category': category.toJson(),
      'detail': detail,
      'traceId': traceId,
      if (fieldErrors != null) 'fieldErrors': fieldErrors?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (currentVersion != null) 'currentVersion': currentVersion,
      if (retryAfterSeconds != null) 'retryAfterSeconds': retryAfterSeconds,
      if (meta != null) 'meta': meta?.toJson(),
    };
  }

  @override
  String toString() {
    return 'ApiException(code: $code, category: $category, detail: $detail, traceId: $traceId, fieldErrors: $fieldErrors, currentVersion: $currentVersion, retryAfterSeconds: $retryAfterSeconds, meta: $meta)';
  }
}

class _Undefined {}

class _ApiExceptionImpl extends ApiException {
  _ApiExceptionImpl({
    required String code,
    required _i19dk5at.ErrorCategory category,
    required String detail,
    required String traceId,
    List<_i647assy.FieldError>? fieldErrors,
    int? currentVersion,
    int? retryAfterSeconds,
    Map<String, String>? meta,
  }) : super._(
         code: code,
         category: category,
         detail: detail,
         traceId: traceId,
         fieldErrors: fieldErrors,
         currentVersion: currentVersion,
         retryAfterSeconds: retryAfterSeconds,
         meta: meta,
       );

  /// Returns a shallow copy of this [ApiException]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ApiException copyWith({
    String? code,
    _i19dk5at.ErrorCategory? category,
    String? detail,
    String? traceId,
    List<_i647assy.FieldError>? fieldErrors = const _is.$UndefinedList<_i647assy.FieldError>(),
    Object? currentVersion = _Undefined,
    Object? retryAfterSeconds = _Undefined,
    Map<String, String>? meta = const _is.$UndefinedMap<String, String>(),
  }) {
    return ApiException(
      code: code ?? this.code,
      category: category ?? this.category,
      detail: detail ?? this.detail,
      traceId: traceId ?? this.traceId,
      fieldErrors: fieldErrors is _is.UndefinedSentinel
          ? this.fieldErrors?.map((e0) => e0.copyWith()).toList()
          : fieldErrors,
      currentVersion: currentVersion is int? ? currentVersion : this.currentVersion,
      retryAfterSeconds: retryAfterSeconds is int? ? retryAfterSeconds : this.retryAfterSeconds,
      meta: meta is _is.UndefinedSentinel
          ? this.meta?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0,
              ),
            )
          : meta,
    );
  }
}
