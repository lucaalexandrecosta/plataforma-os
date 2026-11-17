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
import '../../scheduling/models/visit_check_in.dart' as _io0acepf;
import '../../scheduling/models/visit_finish.dart' as _ir70sx6e;

abstract class VisitMutationPayload implements _isc.SerializableModel, _isc.ProtocolSerialization {
  VisitMutationPayload._({
    this.occurredAt,
    this.checkIn,
    this.finish,
  });

  factory VisitMutationPayload({
    DateTime? occurredAt,
    _io0acepf.VisitCheckIn? checkIn,
    _ir70sx6e.VisitFinish? finish,
  }) = _VisitMutationPayloadImpl;

  factory VisitMutationPayload.fromJson(Map<String, dynamic> jsonSerialization) {
    return VisitMutationPayload(
      occurredAt: jsonSerialization['occurredAt'] == null
          ? null
          : _isc.DateTimeJsonExtension.fromJson(jsonSerialization['occurredAt']),
      checkIn: jsonSerialization['checkIn'] == null
          ? null
          : _inlzmlpe.Protocol().deserialize<_io0acepf.VisitCheckIn>(jsonSerialization['checkIn']),
      finish: jsonSerialization['finish'] == null
          ? null
          : _inlzmlpe.Protocol().deserialize<_ir70sx6e.VisitFinish>(jsonSerialization['finish']),
    );
  }

  DateTime? occurredAt;

  _io0acepf.VisitCheckIn? checkIn;

  _ir70sx6e.VisitFinish? finish;

  /// Returns a shallow copy of this [VisitMutationPayload]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  VisitMutationPayload copyWith({
    DateTime? occurredAt = const _isc.$UndefinedDateTime(),
    _io0acepf.VisitCheckIn? checkIn = const _UndefinedVisitMutationPayload$checkIn(),
    _ir70sx6e.VisitFinish? finish = const _UndefinedVisitMutationPayload$finish(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VisitMutationPayload',
      if (occurredAt != null) 'occurredAt': occurredAt?.toJson(),
      if (checkIn != null) 'checkIn': checkIn?.toJson(),
      if (finish != null) 'finish': finish?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VisitMutationPayload',
      if (occurredAt != null) 'occurredAt': occurredAt?.toJson(),
      if (checkIn != null) 'checkIn': checkIn?.toJsonForProtocol(),
      if (finish != null) 'finish': finish?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _UndefinedVisitMutationPayload$checkIn extends _isc.UndefinedSentinel implements _io0acepf.VisitCheckIn {
  const _UndefinedVisitMutationPayload$checkIn();
}

class _UndefinedVisitMutationPayload$finish extends _isc.UndefinedSentinel implements _ir70sx6e.VisitFinish {
  const _UndefinedVisitMutationPayload$finish();
}

class _VisitMutationPayloadImpl extends VisitMutationPayload {
  _VisitMutationPayloadImpl({
    DateTime? occurredAt,
    _io0acepf.VisitCheckIn? checkIn,
    _ir70sx6e.VisitFinish? finish,
  }) : super._(
         occurredAt: occurredAt,
         checkIn: checkIn,
         finish: finish,
       );

  /// Returns a shallow copy of this [VisitMutationPayload]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  VisitMutationPayload copyWith({
    DateTime? occurredAt = const _isc.$UndefinedDateTime(),
    _io0acepf.VisitCheckIn? checkIn = const _UndefinedVisitMutationPayload$checkIn(),
    _ir70sx6e.VisitFinish? finish = const _UndefinedVisitMutationPayload$finish(),
  }) {
    return VisitMutationPayload(
      occurredAt: occurredAt is _isc.UndefinedSentinel ? this.occurredAt : occurredAt,
      checkIn: checkIn is _isc.UndefinedSentinel ? this.checkIn?.copyWith() : checkIn,
      finish: finish is _isc.UndefinedSentinel ? this.finish?.copyWith() : finish,
    );
  }
}
