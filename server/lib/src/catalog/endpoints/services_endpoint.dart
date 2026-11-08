import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/catalog_service_service.dart';

/// `services` (docs/08 §3.1): serviços faturáveis. Escrita: `catalog.manage`;
/// leitura: papéis internos.
class ServicesEndpoint extends StaffEndpoint {
  Future<CatalogServicePage> list(Session session, CatalogServiceFilter? filter, PageRequest? page) =>
      CatalogServices.list(session, filter, page);

  Future<CatalogService> get(Session session, UuidValue id) => CatalogServices.get(session, id);

  Future<CatalogService> create(Session session, CatalogServiceInput input) => CatalogServices.create(session, input);

  Future<CatalogService> update(Session session, UuidValue id, CatalogServicePatch patch, int expectedVersion) =>
      CatalogServices.update(session, id, patch, expectedVersion);

  Future<CatalogService> deactivate(Session session, UuidValue id, String reason, int expectedVersion) =>
      CatalogServices.deactivate(session, id, reason, expectedVersion);

  Future<CatalogService> reactivate(Session session, UuidValue id, int expectedVersion) =>
      CatalogServices.reactivate(session, id, expectedVersion);
}
