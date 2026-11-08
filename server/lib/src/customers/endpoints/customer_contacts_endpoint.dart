import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/customer_contact_service.dart';

/// `customerContacts` (docs/08 §3.1). Escrita: `customers.manage`; leitura:
/// papéis internos. Faltam `invite` (com as notificações) e `revokeSessions`
/// (com o login do contato por OTP).
class CustomerContactsEndpoint extends StaffEndpoint {
  Future<CustomerContactPage> list(Session session, CustomerContactFilter? filter, PageRequest? page) =>
      CustomerContactService.list(session, filter, page);

  Future<CustomerContact> get(Session session, UuidValue id) => CustomerContactService.get(session, id);

  Future<CustomerContact> create(Session session, CustomerContactInput input) =>
      CustomerContactService.create(session, input);

  Future<CustomerContact> update(Session session, UuidValue id, CustomerContactPatch patch, int expectedVersion) =>
      CustomerContactService.update(session, id, patch, expectedVersion);

  Future<CustomerContact> approve(Session session, UuidValue id, int expectedVersion) =>
      CustomerContactService.approve(session, id, expectedVersion);

  Future<CustomerContact> block(Session session, UuidValue id, String reason, int expectedVersion) =>
      CustomerContactService.block(session, id, reason, expectedVersion);

  Future<CustomerContact> unblock(Session session, UuidValue id, int expectedVersion) =>
      CustomerContactService.unblock(session, id, expectedVersion);

  Future<CustomerContact> deactivate(Session session, UuidValue id, String reason, int expectedVersion) =>
      CustomerContactService.deactivate(session, id, reason, expectedVersion);

  Future<CustomerContact> reactivate(Session session, UuidValue id, int expectedVersion) =>
      CustomerContactService.reactivate(session, id, expectedVersion);
}
