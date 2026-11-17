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

abstract class AssetWithdrawInput implements _is.SerializableModel, _is.ProtocolSerialization {
  AssetWithdrawInput._({
    required this.reason,
    this.endedAt,
    this.notes,
  });

  factory AssetWithdrawInput({
    required String reason,
    DateTime? endedAt,
    String? notes,
  }) = _AssetWithdrawInputImpl;

  factory AssetWithdrawInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return AssetWithdrawInput(
      reason: jsonSerialization['reason'] as String,
      endedAt: jsonSerialization['endedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['endedAt']),
      notes: jsonSerialization['notes'] as String?,
    );
  }

  String reason;

  DateTime? endedAt;

  String? notes;

  /// Returns a shallow copy of this [AssetWithdrawInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AssetWithdrawInput copyWith({
    String? reason,
    DateTime? endedAt = const _is.$UndefinedDateTime(),
    String? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AssetWithdrawInput',
      'reason': reason,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      if (notes != null) 'notes': notes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AssetWithdrawInput',
      'reason': reason,
      if (endedAt != null) 'endedAt': endedAt?.toJson(),
      if (notes != null) 'notes': notes,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AssetWithdrawInputImpl extends AssetWithdrawInput {
  _AssetWithdrawInputImpl({
    required String reason,
    DateTime? endedAt,
    String? notes,
  }) : super._(
         reason: reason,
         endedAt: endedAt,
         notes: notes,
       );

  /// Returns a shallow copy of this [AssetWithdrawInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AssetWithdrawInput copyWith({
    String? reason,
    DateTime? endedAt = const _is.$UndefinedDateTime(),
    Object? notes = _Undefined,
  }) {
    return AssetWithdrawInput(
      reason: reason ?? this.reason,
      endedAt: endedAt is _is.UndefinedSentinel ? this.endedAt : endedAt,
      notes: notes is String? ? notes : this.notes,
    );
  }
}
