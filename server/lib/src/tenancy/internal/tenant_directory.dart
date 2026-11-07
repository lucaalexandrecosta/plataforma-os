import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';

/// Catálogo de tenants. As leituras passam pela RLS de `app.tenants`: o ator
/// só enxerga o tenant ativo e os tenants em que tem vínculo (db/schema.sql
/// §22.3), então "não achei" e "não é seu" são a mesma resposta.
abstract final class TenantDirectory {
  static Future<Tenant?> findBySlug(Session session, String slug) =>
      Tenant.db.findFirstRow(session, where: (t) => t.slug.equals(slug.trim().toLowerCase()));

  static Future<Tenant?> get(Session session, UuidValue id) => Tenant.db.findById(session, id);

  static Future<List<Tenant>> getMany(Session session, Set<UuidValue> ids) => ids.isEmpty
      ? Future.value(const [])
      : Tenant.db.find(session, where: (t) => t.id.inSet(ids), orderBy: (t) => t.displayName);

  static bool isOperational(Tenant tenant) =>
      tenant.status == TenantStatus.trial || tenant.status == TenantStatus.active;

  static TenantSummary summary(Tenant tenant) =>
      TenantSummary(id: tenant.id, slug: tenant.slug, displayName: tenant.displayName, status: tenant.status);
}
