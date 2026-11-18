import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/customer_contacts.dart';
import '../internal/customers.dart';

/// `customers.*` — clientes, unidades e contatos. Leitura para quem mexe com OS ou
/// bens; alteração com `customers.manage`. Erros: `FORBIDDEN`,
/// `VALIDATION_FAILED`, `NOT_FOUND`, `VERSION_MISMATCH`, `ERP_MASTER_READ_ONLY`.
class CustomersEndpoint extends StaffEndpoint {
  /// [search] procura no nome, nome fantasia, código e documento.
  Future<CustomerPage> list(
    Session session, {
    String? search,
    bool? includeInactive,
    int? limit,
    int? offset,
  }) => Customers.list(
    session,
    search: search,
    includeInactive: includeInactive ?? false,
    limit: limit ?? 50,
    offset: offset ?? 0,
  );

  Future<Customer> get(Session session, UuidValue id) => Customers.get(session, id);

  Future<Customer> create(Session session, CustomerInput input) => Customers.create(session, input);

  Future<Customer> update(Session session, UuidValue id, int expectedVersion, CustomerInput input) =>
      Customers.update(session, id, expectedVersion, input);

  /// Unidades do cliente (ativas e inativas).
  Future<List<CustomerSite>> sites(Session session, UuidValue customerId) => Customers.sites(session, customerId);

  Future<CustomerSite> createSite(Session session, UuidValue customerId, CustomerSiteInput input) =>
      Customers.createSite(session, customerId, input);

  Future<CustomerSite> updateSite(Session session, UuidValue id, int expectedVersion, CustomerSiteInput input) =>
      Customers.updateSite(session, id, expectedVersion, input);

  /// Contatos do cliente (ativos e inativos).
  Future<List<CustomerContact>> contacts(Session session, UuidValue customerId) =>
      CustomerContacts.list(session, customerId);

  Future<CustomerContact> createContact(Session session, UuidValue customerId, CustomerContactInput input) =>
      CustomerContacts.create(session, customerId, input);

  Future<CustomerContact> updateContact(
    Session session,
    UuidValue id,
    int expectedVersion,
    CustomerContactInput input,
  ) => CustomerContacts.update(session, id, expectedVersion, input);
}
