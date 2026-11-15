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

abstract class ProductSummary implements _is.SerializableModel, _is.ProtocolSerialization {
  ProductSummary._({
    required this.id,
    required this.code,
    required this.name,
    required this.isActive,
  });

  factory ProductSummary({
    required _is.UuidValue id,
    required String code,
    required String name,
    required bool isActive,
  }) = _ProductSummaryImpl;

  factory ProductSummary.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductSummary(
      id: _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      isActive: _is.BoolJsonExtension.fromJson(jsonSerialization['isActive']),
    );
  }

  _is.UuidValue id;

  String code;

  String name;

  bool isActive;

  /// Returns a shallow copy of this [ProductSummary]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ProductSummary copyWith({
    _is.UuidValue? id,
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
    return _is.SerializationManager.encode(this);
  }
}

class _ProductSummaryImpl extends ProductSummary {
  _ProductSummaryImpl({
    required _is.UuidValue id,
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
  @_is.useResult
  @override
  ProductSummary copyWith({
    _is.UuidValue? id,
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
