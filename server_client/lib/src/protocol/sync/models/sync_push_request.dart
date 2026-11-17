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
import 'package:plataforma_os_client/src/protocol/protocol.dart' as _inlzmlpe;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import '../../sync/models/sync_mutation.dart' as _ifzilqje;

abstract class SyncPushRequest implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SyncPushRequest._({
    required this.deviceId,
    required this.appVersion,
    required this.mutations,
  });

  factory SyncPushRequest({
    required _isc.UuidValue deviceId,
    required String appVersion,
    required List<_ifzilqje.SyncMutation> mutations,
  }) = _SyncPushRequestImpl;

  factory SyncPushRequest.fromJson(Map<String, dynamic> jsonSerialization) {
    return SyncPushRequest(
      deviceId: _isc.UuidValueJsonExtension.fromJson(jsonSerialization['deviceId']),
      appVersion: jsonSerialization['appVersion'] as String,
      mutations: _inlzmlpe.Protocol().deserialize<List<_ifzilqje.SyncMutation>>(jsonSerialization['mutations']),
    );
  }

  _isc.UuidValue deviceId;

  String appVersion;

  List<_ifzilqje.SyncMutation> mutations;

  /// Returns a shallow copy of this [SyncPushRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SyncPushRequest copyWith({
    _isc.UuidValue? deviceId,
    String? appVersion,
    List<_ifzilqje.SyncMutation>? mutations,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SyncPushRequest',
      'deviceId': deviceId.toJson(),
      'appVersion': appVersion,
      'mutations': mutations.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SyncPushRequest',
      'deviceId': deviceId.toJson(),
      'appVersion': appVersion,
      'mutations': mutations.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _SyncPushRequestImpl extends SyncPushRequest {
  _SyncPushRequestImpl({
    required _isc.UuidValue deviceId,
    required String appVersion,
    required List<_ifzilqje.SyncMutation> mutations,
  }) : super._(
         deviceId: deviceId,
         appVersion: appVersion,
         mutations: mutations,
       );

  /// Returns a shallow copy of this [SyncPushRequest]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  SyncPushRequest copyWith({
    _isc.UuidValue? deviceId,
    String? appVersion,
    List<_ifzilqje.SyncMutation>? mutations,
  }) {
    return SyncPushRequest(
      deviceId: deviceId ?? this.deviceId,
      appVersion: appVersion ?? this.appVersion,
      mutations: mutations ?? this.mutations.map((e0) => e0.copyWith()).toList(),
    );
  }
}
