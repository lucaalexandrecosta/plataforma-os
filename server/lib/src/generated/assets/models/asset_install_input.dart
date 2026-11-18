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

abstract class AssetInstallInput implements _is.SerializableModel, _is.ProtocolSerialization {
  AssetInstallInput._({
    required this.customerSiteId,
    this.startedAt,
    this.sourceDocumentType,
    this.sourceDocumentNumber,
    this.notes,
  });

  factory AssetInstallInput({
    required _is.UuidValue customerSiteId,
    DateTime? startedAt,
    String? sourceDocumentType,
    String? sourceDocumentNumber,
    String? notes,
  }) = _AssetInstallInputImpl;

  factory AssetInstallInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return AssetInstallInput(
      customerSiteId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['customerSiteId']),
      startedAt: jsonSerialization['startedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['startedAt']),
      sourceDocumentType: jsonSerialization['sourceDocumentType'] as String?,
      sourceDocumentNumber: jsonSerialization['sourceDocumentNumber'] as String?,
      notes: jsonSerialization['notes'] as String?,
    );
  }

  _is.UuidValue customerSiteId;

  DateTime? startedAt;

  String? sourceDocumentType;

  String? sourceDocumentNumber;

  String? notes;

  /// Returns a shallow copy of this [AssetInstallInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  AssetInstallInput copyWith({
    _is.UuidValue? customerSiteId,
    DateTime? startedAt = const _is.$UndefinedDateTime(),
    String? sourceDocumentType,
    String? sourceDocumentNumber,
    String? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AssetInstallInput',
      'customerSiteId': customerSiteId.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (sourceDocumentType != null) 'sourceDocumentType': sourceDocumentType,
      if (sourceDocumentNumber != null) 'sourceDocumentNumber': sourceDocumentNumber,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AssetInstallInput',
      'customerSiteId': customerSiteId.toJson(),
      if (startedAt != null) 'startedAt': startedAt?.toJson(),
      if (sourceDocumentType != null) 'sourceDocumentType': sourceDocumentType,
      if (sourceDocumentNumber != null) 'sourceDocumentNumber': sourceDocumentNumber,
      if (notes != null) 'notes': notes,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AssetInstallInputImpl extends AssetInstallInput {
  _AssetInstallInputImpl({
    required _is.UuidValue customerSiteId,
    DateTime? startedAt,
    String? sourceDocumentType,
    String? sourceDocumentNumber,
    String? notes,
  }) : super._(
         customerSiteId: customerSiteId,
         startedAt: startedAt,
         sourceDocumentType: sourceDocumentType,
         sourceDocumentNumber: sourceDocumentNumber,
         notes: notes,
       );

  /// Returns a shallow copy of this [AssetInstallInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  AssetInstallInput copyWith({
    _is.UuidValue? customerSiteId,
    DateTime? startedAt = const _is.$UndefinedDateTime(),
    Object? sourceDocumentType = _Undefined,
    Object? sourceDocumentNumber = _Undefined,
    Object? notes = _Undefined,
  }) {
    return AssetInstallInput(
      customerSiteId: customerSiteId ?? this.customerSiteId,
      startedAt: startedAt is _is.UndefinedSentinel ? this.startedAt : startedAt,
      sourceDocumentType: sourceDocumentType is String? ? sourceDocumentType : this.sourceDocumentType,
      sourceDocumentNumber: sourceDocumentNumber is String? ? sourceDocumentNumber : this.sourceDocumentNumber,
      notes: notes is String? ? notes : this.notes,
    );
  }
}
