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

abstract class ProductInput implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProductInput._({
    required this.code,
    required this.name,
    this.description,
  });

  factory ProductInput({
    required String code,
    required String name,
    String? description,
  }) = _ProductInputImpl;

  factory ProductInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProductInput(
      code: jsonSerialization['code'] as String,
      name: jsonSerialization['name'] as String,
      description: jsonSerialization['description'] as String?,
    );
  }

  String code;

  String name;

  String? description;

  /// Returns a shallow copy of this [ProductInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProductInput copyWith({
    String? code,
    String? name,
    String? description,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProductInput',
      'code': code,
      'name': name,
      if (description != null) 'description': description,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProductInput',
      'code': code,
      'name': name,
      if (description != null) 'description': description,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductInputImpl extends ProductInput {
  _ProductInputImpl({
    required String code,
    required String name,
    String? description,
  }) : super._(
         code: code,
         name: name,
         description: description,
       );

  /// Returns a shallow copy of this [ProductInput]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProductInput copyWith({
    String? code,
    String? name,
    Object? description = _Undefined,
  }) {
    return ProductInput(
      code: code ?? this.code,
      name: name ?? this.name,
      description: description is String? ? description : this.description,
    );
  }
}
