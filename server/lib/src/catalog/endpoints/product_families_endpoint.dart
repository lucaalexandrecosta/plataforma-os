import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/product_family_service.dart';

/// `productFamilies`: árvore de famílias de produto. Escrita: `catalog.manage`
/// (TA); leitura: papéis internos.
class ProductFamiliesEndpoint extends StaffEndpoint {
  Future<ProductFamilyPage> list(Session session, ProductFamilyFilter? filter, PageRequest? page) =>
      ProductFamilyService.list(session, filter, page);

  Future<ProductFamily> get(Session session, UuidValue id) => ProductFamilyService.get(session, id);

  Future<ProductFamily> create(Session session, ProductFamilyInput input) =>
      ProductFamilyService.create(session, input);

  Future<ProductFamily> update(Session session, UuidValue id, ProductFamilyPatch patch, int expectedVersion) =>
      ProductFamilyService.update(session, id, patch, expectedVersion);

  Future<ProductFamily> deactivate(Session session, UuidValue id, String reason, int expectedVersion) =>
      ProductFamilyService.deactivate(session, id, reason, expectedVersion);

  Future<ProductFamily> reactivate(Session session, UuidValue id, int expectedVersion) =>
      ProductFamilyService.reactivate(session, id, expectedVersion);
}
