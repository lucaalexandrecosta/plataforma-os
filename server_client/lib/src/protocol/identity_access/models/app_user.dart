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

abstract class AppUser implements _isc.SerializableModel, _isc.ProtocolSerialization {
  AppUser._({
    _isc.UuidValue? id,
    required this.userType,
    required this.fullName,
    this.email,
    required this.status,
    required this.locale,
    required this.version,
  }) : id = id ?? const _isc.Uuid().v7obj();

  factory AppUser({
    _isc.UuidValue? id,
    required String userType,
    required String fullName,
    String? email,
    required String status,
    required String locale,
    required int version,
  }) = _AppUserImpl;

  factory AppUser.fromJson(Map<String, dynamic> jsonSerialization) {
    return AppUser(
      id: jsonSerialization['id'] == null ? null : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      userType: jsonSerialization['userType'] as String,
      fullName: jsonSerialization['fullName'] as String,
      email: jsonSerialization['email'] as String?,
      status: jsonSerialization['status'] as String,
      locale: jsonSerialization['locale'] as String,
      version: jsonSerialization['version'] as int,
    );
  }

  /// The id of the object.
  _isc.UuidValue id;

  String userType;

  String fullName;

  String? email;

  String status;

  String locale;

  int version;

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  AppUser copyWith({
    _isc.UuidValue? id,
    String? userType,
    String? fullName,
    String? email,
    String? status,
    String? locale,
    int? version,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'AppUser',
      'id': id.toJson(),
      'userType': userType,
      'fullName': fullName,
      if (email != null) 'email': email,
      'status': status,
      'locale': locale,
      'version': version,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'AppUser',
      'id': id.toJson(),
      'userType': userType,
      'fullName': fullName,
      if (email != null) 'email': email,
      'status': status,
      'locale': locale,
      'version': version,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AppUserImpl extends AppUser {
  _AppUserImpl({
    _isc.UuidValue? id,
    required String userType,
    required String fullName,
    String? email,
    required String status,
    required String locale,
    required int version,
  }) : super._(
         id: id,
         userType: userType,
         fullName: fullName,
         email: email,
         status: status,
         locale: locale,
         version: version,
       );

  /// Returns a shallow copy of this [AppUser]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  AppUser copyWith({
    _isc.UuidValue? id,
    String? userType,
    String? fullName,
    Object? email = _Undefined,
    String? status,
    String? locale,
    int? version,
  }) {
    return AppUser(
      id: id ?? this.id,
      userType: userType ?? this.userType,
      fullName: fullName ?? this.fullName,
      email: email is String? ? email : this.email,
      status: status ?? this.status,
      locale: locale ?? this.locale,
      version: version ?? this.version,
    );
  }
}
