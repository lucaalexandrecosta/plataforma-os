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

abstract class QrTagBatch implements _isc.SerializableModel, _isc.ProtocolSerialization {
  QrTagBatch._({
    required this.id,
    required this.code,
    required this.quantity,
    this.notes,
    this.printedAt,
    required this.boundCount,
    required this.createdAt,
  });

  factory QrTagBatch({
    required _isc.UuidValue id,
    required String code,
    required int quantity,
    String? notes,
    DateTime? printedAt,
    required int boundCount,
    required DateTime createdAt,
  }) = _QrTagBatchImpl;

  factory QrTagBatch.fromJson(Map<String, dynamic> jsonSerialization) {
    return QrTagBatch(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String,
      quantity: jsonSerialization['quantity'] as int,
      notes: jsonSerialization['notes'] as String?,
      printedAt: jsonSerialization['printedAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['printedAt']),
      boundCount: jsonSerialization['boundCount'] as int,
      createdAt: _isc.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  _isc.UuidValue id;

  String code;

  int quantity;

  String? notes;

  DateTime? printedAt;

  int boundCount;

  DateTime createdAt;

  /// Returns a shallow copy of this [QrTagBatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  QrTagBatch copyWith({
    _isc.UuidValue? id,
    String? code,
    int? quantity,
    String? notes,
    DateTime? printedAt = const _isc.$UndefinedDateTime(),
    int? boundCount,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'QrTagBatch',
      'id': id.toJson(),
      'code': code,
      'quantity': quantity,
      if (notes != null) 'notes': notes,
      if (printedAt != null) 'printedAt': printedAt?.toJson(),
      'boundCount': boundCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'QrTagBatch',
      'id': id.toJson(),
      'code': code,
      'quantity': quantity,
      if (notes != null) 'notes': notes,
      if (printedAt != null) 'printedAt': printedAt?.toJson(),
      'boundCount': boundCount,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _QrTagBatchImpl extends QrTagBatch {
  _QrTagBatchImpl({
    required _isc.UuidValue id,
    required String code,
    required int quantity,
    String? notes,
    DateTime? printedAt,
    required int boundCount,
    required DateTime createdAt,
  }) : super._(
         id: id,
         code: code,
         quantity: quantity,
         notes: notes,
         printedAt: printedAt,
         boundCount: boundCount,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [QrTagBatch]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  QrTagBatch copyWith({
    _isc.UuidValue? id,
    String? code,
    int? quantity,
    Object? notes = _Undefined,
    DateTime? printedAt = const _isc.$UndefinedDateTime(),
    int? boundCount,
    DateTime? createdAt,
  }) {
    return QrTagBatch(
      id: id ?? this.id,
      code: code ?? this.code,
      quantity: quantity ?? this.quantity,
      notes: notes is String? ? notes : this.notes,
      printedAt: printedAt is _isc.UndefinedSentinel ? this.printedAt : printedAt,
      boundCount: boundCount ?? this.boundCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
