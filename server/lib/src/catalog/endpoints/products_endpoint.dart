import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/endpoints/endpoint_bases.dart';
import '../internal/products.dart';

/// `products.*` — modelos de equipamento para o cadastro de bens.
class ProductsEndpoint extends StaffEndpoint {
  /// Equipamentos ativos; [search] procura no código e no nome.
  Future<List<ProductSummary>> list(Session session, {String? search}) => Products.list(session, search: search);

  Future<ProductSummary> create(Session session, ProductInput input) => Products.create(session, input);
}
