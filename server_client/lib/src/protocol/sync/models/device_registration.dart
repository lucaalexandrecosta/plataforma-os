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

abstract class DeviceRegistration implements _isc.SerializableModel, _isc.ProtocolSerialization {
  DeviceRegistration._({
    required this.deviceId,
    required this.platform,
    this.appVersion,
    this.osVersion,
    this.deviceModel,
  });

  factory DeviceRegistration({
    required _isc.UuidValue deviceId,
    required String platform,
    String? appVersion,
    String? osVersion,
    String? deviceModel,
  }) = _DeviceRegistrationImpl;

  factory DeviceRegistration.fromJson(Map<String, dynamic> jsonSerialization) {
    return DeviceRegistration(
      deviceId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['deviceId']),
      platform: jsonSerialization['platform'] as String,
      appVersion: jsonSerialization['appVersion'] as String?,
      osVersion: jsonSerialization['osVersion'] as String?,
      deviceModel: jsonSerialization['deviceModel'] as String?,
    );
  }

  _isc.UuidValue deviceId;

  String platform;

  String? appVersion;

  String? osVersion;

  String? deviceModel;

  /// Returns a shallow copy of this [DeviceRegistration]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  DeviceRegistration copyWith({
    _isc.UuidValue? deviceId,
    String? platform,
    String? appVersion,
    String? osVersion,
    String? deviceModel,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'DeviceRegistration',
      'deviceId': deviceId.toJson(),
      'platform': platform,
      if (appVersion != null) 'appVersion': appVersion,
      if (osVersion != null) 'osVersion': osVersion,
      if (deviceModel != null) 'deviceModel': deviceModel,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'DeviceRegistration',
      'deviceId': deviceId.toJson(),
      'platform': platform,
      if (appVersion != null) 'appVersion': appVersion,
      if (osVersion != null) 'osVersion': osVersion,
      if (deviceModel != null) 'deviceModel': deviceModel,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _DeviceRegistrationImpl extends DeviceRegistration {
  _DeviceRegistrationImpl({
    required _isc.UuidValue deviceId,
    required String platform,
    String? appVersion,
    String? osVersion,
    String? deviceModel,
  }) : super._(
         deviceId: deviceId,
         platform: platform,
         appVersion: appVersion,
         osVersion: osVersion,
         deviceModel: deviceModel,
       );

  /// Returns a shallow copy of this [DeviceRegistration]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  DeviceRegistration copyWith({
    _isc.UuidValue? deviceId,
    String? platform,
    Object? appVersion = _Undefined,
    Object? osVersion = _Undefined,
    Object? deviceModel = _Undefined,
  }) {
    return DeviceRegistration(
      deviceId: deviceId ?? this.deviceId,
      platform: platform ?? this.platform,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      osVersion: osVersion is String? ? osVersion : this.osVersion,
      deviceModel: deviceModel is String? ? deviceModel : this.deviceModel,
    );
  }
}
