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

abstract class VisitCheckIn implements _is.SerializableModel, _is.ProtocolSerialization {
  VisitCheckIn._({
    required this.method,
    this.scannedCode,
    this.latitude,
    this.longitude,
    this.accuracyM,
    this.justification,
  });

  factory VisitCheckIn({
    required String method,
    String? scannedCode,
    double? latitude,
    double? longitude,
    double? accuracyM,
    String? justification,
  }) = _VisitCheckInImpl;

  factory VisitCheckIn.fromJson(Map<String, dynamic> jsonSerialization) {
    return VisitCheckIn(
      method: jsonSerialization['method'] as String,
      scannedCode: jsonSerialization['scannedCode'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
      accuracyM: (jsonSerialization['accuracyM'] as num?)?.toDouble(),
      justification: jsonSerialization['justification'] as String?,
    );
  }

  String method;

  String? scannedCode;

  double? latitude;

  double? longitude;

  double? accuracyM;

  String? justification;

  /// Returns a shallow copy of this [VisitCheckIn]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  VisitCheckIn copyWith({
    String? method,
    String? scannedCode,
    double? latitude,
    double? longitude,
    double? accuracyM,
    String? justification,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VisitCheckIn',
      'method': method,
      if (scannedCode != null) 'scannedCode': scannedCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracyM != null) 'accuracyM': accuracyM,
      if (justification != null) 'justification': justification,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VisitCheckIn',
      'method': method,
      if (scannedCode != null) 'scannedCode': scannedCode,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracyM != null) 'accuracyM': accuracyM,
      if (justification != null) 'justification': justification,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VisitCheckInImpl extends VisitCheckIn {
  _VisitCheckInImpl({
    required String method,
    String? scannedCode,
    double? latitude,
    double? longitude,
    double? accuracyM,
    String? justification,
  }) : super._(
         method: method,
         scannedCode: scannedCode,
         latitude: latitude,
         longitude: longitude,
         accuracyM: accuracyM,
         justification: justification,
       );

  /// Returns a shallow copy of this [VisitCheckIn]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  VisitCheckIn copyWith({
    String? method,
    Object? scannedCode = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
    Object? accuracyM = _Undefined,
    Object? justification = _Undefined,
  }) {
    return VisitCheckIn(
      method: method ?? this.method,
      scannedCode: scannedCode is String? ? scannedCode : this.scannedCode,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
      accuracyM: accuracyM is double? ? accuracyM : this.accuracyM,
      justification: justification is String? ? justification : this.justification,
    );
  }
}
