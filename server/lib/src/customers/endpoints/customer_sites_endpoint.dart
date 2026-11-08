import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/customer_site_service.dart';

/// `customerSites` (docs/08 §3.1). Escrita: `customers.manage`; leitura:
/// papéis internos. Falta `geocode` (provedor de geocodificação a escolher).
class CustomerSitesEndpoint extends StaffEndpoint {
  Future<CustomerSitePage> list(Session session, CustomerSiteFilter? filter, PageRequest? page) =>
      CustomerSiteService.list(session, filter, page);

  Future<CustomerSite> get(Session session, UuidValue id) => CustomerSiteService.get(session, id);

  Future<CustomerSite> create(Session session, CustomerSiteInput input) => CustomerSiteService.create(session, input);

  Future<CustomerSite> update(Session session, UuidValue id, CustomerSitePatch patch, int expectedVersion) =>
      CustomerSiteService.update(session, id, patch, expectedVersion);

  Future<CustomerSite> deactivate(Session session, UuidValue id, String reason, int expectedVersion) =>
      CustomerSiteService.deactivate(session, id, reason, expectedVersion);

  Future<CustomerSite> reactivate(Session session, UuidValue id, int expectedVersion) =>
      CustomerSiteService.reactivate(session, id, expectedVersion);
}
