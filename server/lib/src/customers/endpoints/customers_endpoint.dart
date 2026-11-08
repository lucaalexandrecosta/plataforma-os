import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/customer_service.dart';

/// `customers` (docs/08 §3.1). Escrita: tenant_admin, dispatcher e
/// backoffice_agent (`customers.manage`); leitura: papéis internos.
/// Faltam do padrão: `audit`, `export` e os métodos próprios por cliente
/// (`listSites`, `listContacts`, `listAssets`, `listWorkOrders`).
class CustomersEndpoint extends StaffEndpoint {
  Future<CustomerPage> list(Session session, CustomerFilter? filter, PageRequest? page) =>
      CustomerService.list(session, filter, page);

  Future<Customer> get(Session session, UuidValue id) => CustomerService.get(session, id);

  Future<Customer> create(Session session, CustomerInput input) => CustomerService.create(session, input);

  Future<Customer> update(Session session, UuidValue id, CustomerPatch patch, int expectedVersion) =>
      CustomerService.update(session, id, patch, expectedVersion);

  Future<Customer> deactivate(Session session, UuidValue id, String reason, int expectedVersion) =>
      CustomerService.deactivate(session, id, reason, expectedVersion);

  Future<Customer> reactivate(Session session, UuidValue id, int expectedVersion) =>
      CustomerService.reactivate(session, id, expectedVersion);
}
