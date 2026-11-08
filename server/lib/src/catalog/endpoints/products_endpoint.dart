import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/product_service.dart';

/// `products` (docs/08 §3.1). Escrita: `catalog.manage`; leitura: papéis
/// internos. Falta `listAssets` (entra com o módulo `assets`).
class ProductsEndpoint extends StaffEndpoint {
  Future<ProductPage> list(Session session, ProductFilter? filter, PageRequest? page) =>
      ProductService.list(session, filter, page);

  Future<Product> get(Session session, UuidValue id) => ProductService.get(session, id);

  Future<Product> create(Session session, ProductInput input) => ProductService.create(session, input);

  Future<Product> update(Session session, UuidValue id, ProductPatch patch, int expectedVersion) =>
      ProductService.update(session, id, patch, expectedVersion);

  Future<Product> deactivate(Session session, UuidValue id, String reason, int expectedVersion) =>
      ProductService.deactivate(session, id, reason, expectedVersion);

  Future<Product> reactivate(Session session, UuidValue id, int expectedVersion) =>
      ProductService.reactivate(session, id, expectedVersion);
}
