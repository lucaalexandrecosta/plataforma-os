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

abstract class VisitFinish implements _is.SerializableModel, _is.ProtocolSerialization {
  VisitFinish._({
    required this.outcome,
    this.notes,
    this.holdReason,
    this.latitude,
    this.longitude,
  });

  factory VisitFinish({
    required String outcome,
    String? notes,
    String? holdReason,
    double? latitude,
    double? longitude,
  }) = _VisitFinishImpl;

  factory VisitFinish.fromJson(Map<String, dynamic> jsonSerialization) {
    return VisitFinish(
      outcome: jsonSerialization['outcome'] as String,
      notes: jsonSerialization['notes'] as String?,
      holdReason: jsonSerialization['holdReason'] as String?,
      latitude: (jsonSerialization['latitude'] as num?)?.toDouble(),
      longitude: (jsonSerialization['longitude'] as num?)?.toDouble(),
    );
  }

  String outcome;

  String? notes;

  String? holdReason;

  double? latitude;

  double? longitude;

  /// Returns a shallow copy of this [VisitFinish]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  VisitFinish copyWith({
    String? outcome,
    String? notes,
    String? holdReason,
    double? latitude,
    double? longitude,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VisitFinish',
      'outcome': outcome,
      if (notes != null) 'notes': notes,
      if (holdReason != null) 'holdReason': holdReason,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VisitFinish',
      'outcome': outcome,
      if (notes != null) 'notes': notes,
      if (holdReason != null) 'holdReason': holdReason,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _VisitFinishImpl extends VisitFinish {
  _VisitFinishImpl({
    required String outcome,
    String? notes,
    String? holdReason,
    double? latitude,
    double? longitude,
  }) : super._(
         outcome: outcome,
         notes: notes,
         holdReason: holdReason,
         latitude: latitude,
         longitude: longitude,
       );

  /// Returns a shallow copy of this [VisitFinish]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  VisitFinish copyWith({
    String? outcome,
    Object? notes = _Undefined,
    Object? holdReason = _Undefined,
    Object? latitude = _Undefined,
    Object? longitude = _Undefined,
  }) {
    return VisitFinish(
      outcome: outcome ?? this.outcome,
      notes: notes is String? ? notes : this.notes,
      holdReason: holdReason is String? ? holdReason : this.holdReason,
      latitude: latitude is double? ? latitude : this.latitude,
      longitude: longitude is double? ? longitude : this.longitude,
    );
  }
}
