import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/technician_sync.dart';

/// `technicianSync.*` — sincronização do app do técnico (docs/06 §6). Erros:
/// `FORBIDDEN`, `VALIDATION_FAILED`, `DEVICE_NOT_REGISTERED`, `DEVICE_BLOCKED`.
/// Recusas de cada mutação vêm no resultado, não como exceção.
class TechnicianSyncEndpoint extends StaffEndpoint {
  /// Registra (ou atualiza) o aparelho; chamar ao entrar na empresa.
  Future<void> registerDevice(Session session, DeviceRegistration input) =>
      TechnicianSync.registerDevice(session, input);

  /// Recorte atual do técnico.
  Future<SyncPullResult> pull(Session session, UuidValue deviceId) => TechnicianSync.pull(session, deviceId);

  /// Aplica as ações feitas no aparelho, na ordem, e devolve um resultado por
  /// ação.
  Future<List<SyncMutationResult>> push(Session session, SyncPushRequest request) =>
      TechnicianSync.push(session, request);
}
