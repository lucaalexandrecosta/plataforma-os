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

abstract class ChecklistAnswer implements _is.SerializableModel, _is.ProtocolSerialization {
  ChecklistAnswer._({
    required this.itemKey,
    required this.value,
    this.note,
  });

  factory ChecklistAnswer({
    required String itemKey,
    required String value,
    String? note,
  }) = _ChecklistAnswerImpl;

  factory ChecklistAnswer.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChecklistAnswer(
      itemKey: jsonSerialization['itemKey'] as String,
      value: jsonSerialization['value'] as String,
      note: jsonSerialization['note'] as String?,
    );
  }

  String itemKey;

  String value;

  String? note;

  /// Returns a shallow copy of this [ChecklistAnswer]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  ChecklistAnswer copyWith({
    String? itemKey,
    String? value,
    String? note,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChecklistAnswer',
      'itemKey': itemKey,
      'value': value,
      if (note != null) 'note': note,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChecklistAnswer',
      'itemKey': itemKey,
      'value': value,
      if (note != null) 'note': note,
    };
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChecklistAnswerImpl extends ChecklistAnswer {
  _ChecklistAnswerImpl({
    required String itemKey,
    required String value,
    String? note,
  }) : super._(
         itemKey: itemKey,
         value: value,
         note: note,
       );

  /// Returns a shallow copy of this [ChecklistAnswer]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  ChecklistAnswer copyWith({
    String? itemKey,
    String? value,
    Object? note = _Undefined,
  }) {
    return ChecklistAnswer(
      itemKey: itemKey ?? this.itemKey,
      value: value ?? this.value,
      note: note is String? ? note : this.note,
    );
  }
}
