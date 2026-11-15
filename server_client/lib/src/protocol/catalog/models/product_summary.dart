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

abstract class ProductSummary implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProductSummary._({
    required this.id,
    required this.code,
    required this.name,
    required this.isActive,
  });

  factory ProductSummary({
    required _isc.UuidValue id,
    required String code,
    required String name,
    required bool isActive,
  }) = _ProductSummaryImpl;

  factory ProductSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductSummary(
      id: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      isActive: _isc.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  _isc.UuidValue id;

  String code;

  String name;

  bool isActive;

  /// Returns a shallow copy of this [ProductSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProductSummary copyWith({
    _isc.UuidValue? id,
    String? code,
    String? name,
    bool? isActive,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductSummary',
      'id': id.toJson(),
      'code': code,
      'name': name,
      'isActive': isActive,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductSummary',
      'id': id.toJson(),
      'code': code,
      'name': name,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _ProductSummaryImpl extends ProductSummary {
  _ProductSummaryImpl({
    required _isc.UuidValue id,
    required String code,
    required String name,
    required bool isActive,
  }) : super._(
         id: id,
         code: code,
         name: name,
         isActive: isActive,
       );

  /// Returns a shallow copy of this [ProductSummary]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProductSummary copyWith({
    _isc.UuidValue? id,
    String? code,
    String? name,
    bool? isActive,
  }) {
    return ProductSummary(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      isActive: isActive ?? this.isActive,
    );
  }
}
