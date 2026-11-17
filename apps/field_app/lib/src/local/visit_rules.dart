import 'package:plataforma_os_client/plataforma_os_client.dart';

import '../api/gateway.dart';

/// Tipos de mutação de visita do sync (docs/06 §6.7).
abstract final class VisitMutation {
  static const startTravel = 'visit.start_travel';
  static const checkIn = 'visit.check_in';
  static const pause = 'visit.pause';
  static const resume = 'visit.resume';
  static const finish = 'visit.finish';

  /// Ações que deixam a visita em andamento (uma por técnico).
  static const activating = {startTravel, checkIn, resume};
}

/// Aplica no aparelho a ação do técnico sobre a visita, com as mesmas regras
/// do servidor (`Visits` no server), para a tela mudar na hora, mesmo sem
/// sinal. O servidor decide de novo quando a ação chega; se recusar, a visita
/// volta ao estado dele e o técnico recebe um aviso.
///
/// Lança [GatewayException] com a mensagem do servidor quando a ação não vale.
Visit applyVisitMutation(Visit visit, String type, VisitMutationPayload payload, DateTime now) {
  final at = (payload.occurredAt ?? now).toUtc();
  Never refuse(String message, {String code = 'INVALID_TRANSITION', Map<String, String> fields = const {}}) =>
      throw GatewayException(message, code: code, fieldErrors: fields);
  void require(Set<String> allowed, String message) {
    if (!allowed.contains(visit.status)) refuse(message);
  }

  String startedWorkOrder() =>
      const {'open', 'scheduled', 'on_hold'}.contains(visit.workOrderStatus) ? 'in_progress' : visit.workOrderStatus;

  switch (type) {
    case VisitMutation.startTravel:
      require(const {'scheduled'}, 'O deslocamento só começa em visita agendada.');
      return visit.copyWith(status: 'en_route', travelStartedAt: at, workOrderStatus: startedWorkOrder());

    case VisitMutation.checkIn:
      require(const {'scheduled', 'en_route'}, 'Check-in só em visita agendada ou em deslocamento.');
      final input = payload.checkIn;
      if (input == null) refuse('Dados do check-in ausentes.', code: 'VALIDATION_FAILED');
      final justification = _clean(input.justification);
      switch (input.method) {
        case 'qr':
          if (_clean(input.scannedCode) == null) {
            refuse('Leia a etiqueta do bem.', code: 'VALIDATION_FAILED', fields: {'scannedCode': 'Leia a etiqueta.'});
          }
        case 'gps':
          if (input.latitude == null || input.longitude == null) {
            refuse('Sem a posição do GPS.', code: 'VALIDATION_FAILED');
          }
          if (visit.requireQrCheckIn && justification == null) {
            const message = 'Esta OS pede a leitura do QR; justifique o check-in por GPS.';
            refuse(message, code: 'VALIDATION_FAILED', fields: {'justification': message});
          }
        case 'manual':
          if (justification == null) {
            const message = 'Justifique o check-in manual.';
            refuse(message, code: 'VALIDATION_FAILED', fields: {'justification': message});
          }
        default:
          refuse('Método de check-in inválido.', code: 'VALIDATION_FAILED');
      }
      return visit.copyWith(
        status: 'on_site',
        checkedInAt: at,
        checkInMethod: input.method,
        checkInJustification: justification,
        workOrderStatus: startedWorkOrder(),
      );

    case VisitMutation.pause:
      require(const {'on_site'}, 'Só visita em execução pode ser pausada.');
      return visit.copyWith(status: 'paused');

    case VisitMutation.resume:
      require(const {'paused'}, 'Só visita pausada pode ser retomada.');
      return visit.copyWith(status: 'on_site');

    case VisitMutation.finish:
      final input = payload.finish;
      if (input == null) refuse('Dados da finalização ausentes.', code: 'VALIDATION_FAILED');
      final checkedIn = const {'on_site', 'paused'}.contains(visit.status);
      if (!checkedIn) {
        if (!const {'scheduled', 'en_route'}.contains(visit.status)) refuse('Esta visita já terminou.');
        if (!const {'customer_absent', 'not_executed'}.contains(input.outcome)) {
          refuse(
            'Sem check-in a visita só termina como "cliente ausente" ou "não executada".',
            code: 'CHECK_IN_REQUIRED',
          );
        }
      }
      final notes = _clean(input.notes);
      if (input.outcome == 'resolved' && notes == null) {
        refuse('Descreva o que foi feito.', code: 'VALIDATION_FAILED', fields: {'notes': 'Descreva o que foi feito.'});
      }
      final workOrderStatus = switch (input.outcome) {
        'resolved' => 'completed',
        'needs_return' || 'customer_absent' => 'on_hold',
        'not_executed' => 'open',
        _ => refuse('Resultado da visita inválido.', code: 'VALIDATION_FAILED'),
      };
      return visit.copyWith(
        status: 'finished',
        finishedAt: at,
        outcome: input.outcome,
        outcomeNotes: notes,
        workOrderStatus: workOrderStatus,
      );

    default:
      refuse('Ação desconhecida: $type.', code: 'UNKNOWN_TYPE');
  }
}

String? _clean(String? text) {
  final t = text?.trim();
  return t == null || t.isEmpty ? null : t;
}
