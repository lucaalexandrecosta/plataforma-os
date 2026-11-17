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

abstract class VisitInput implements _is.SerializableModel, _is.ProtocolSerialization {
  VisitInput._({
    required this.technicianId,
    required this.scheduledStart,
    required this.scheduledEnd,
  });

  factory VisitInput({
    required _is.UuidValue technicianId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
  }) = _VisitInputImpl;

  factory VisitInput.fromJson(Map<String, dynamic> jsonSerialization) {
    return VisitInput(
      technicianId: _is.UuidValueJsonExtension.fromJson(jsonSerialization['technicianId']),
      scheduledStart: _is.DateTimeJsonExtension.fromJson(jsonSerialization['scheduledStart']),
      scheduledEnd: _is.DateTimeJsonExtension.fromJson(jsonSerialization['scheduledEnd']),
    );
  }

  _is.UuidValue technicianId;

  DateTime scheduledStart;

  DateTime scheduledEnd;

  /// Returns a shallow copy of this [VisitInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  VisitInput copyWith({
    _is.UuidValue? technicianId,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'VisitInput',
      'technicianId': technicianId.toJson(),
      'scheduledStart': scheduledStart.toJson(),
      'scheduledEnd': scheduledEnd.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'VisitInput',
      'technicianId': technicianId.toJson(),
      'scheduledStart': scheduledStart.toJson(),
      'scheduledEnd': scheduledEnd.toJson(),
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _VisitInputImpl extends VisitInput {
  _VisitInputImpl({
    required _is.UuidValue technicianId,
    required DateTime scheduledStart,
    required DateTime scheduledEnd,
  }) : super._(
         technicianId: technicianId,
         scheduledStart: scheduledStart,
         scheduledEnd: scheduledEnd,
       );

  /// Returns a shallow copy of this [VisitInput]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  VisitInput copyWith({
    _is.UuidValue? technicianId,
    DateTime? scheduledStart,
    DateTime? scheduledEnd,
  }) {
    return VisitInput(
      technicianId: technicianId ?? this.technicianId,
      scheduledStart: scheduledStart ?? this.scheduledStart,
      scheduledEnd: scheduledEnd ?? this.scheduledEnd,
    );
  }
}
