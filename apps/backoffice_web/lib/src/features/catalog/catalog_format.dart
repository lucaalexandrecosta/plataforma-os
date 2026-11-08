import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_core/plataforma_os_core.dart';

/// Rótulos e formatos do catálogo.
abstract final class CatalogFormat {
  static String productKind(ProductKind k) => switch (k) {
    ProductKind.equipment => 'Equipamento',
    ProductKind.spare_part => 'Peça',
    ProductKind.consumable => 'Consumível',
    ProductKind.other => 'Outro',
  };

  static String serviceKind(ServiceKind k) => switch (k) {
    ServiceKind.labour => 'Mão de obra',
    ServiceKind.travel => 'Deslocamento',
    ServiceKind.visit => 'Visita',
    ServiceKind.other => 'Outro',
  };

  static String price(int? cents) => cents == null ? '—' : Money.formatBrl(cents);

  /// Centavos → texto editável (`4590,00`), sem "R$" nem milhar.
  static String priceInput(int? cents) {
    if (cents == null) return '';
    return '${cents ~/ 100},${(cents % 100).toString().padLeft(2, '0')}';
  }

  /// `null` se vazio; lança [FormatException] se inválido.
  static int? parsePrice(String text) {
    final t = text.trim();
    return t.isEmpty ? null : Money.parseToCents(t);
  }

  static String minutes(int? m) {
    if (m == null) return '—';
    final h = m ~/ 60;
    final r = m % 60;
    if (h == 0) return '$r min';
    return r == 0 ? '$h h' : '$h h $r min';
  }
}

/// Todas as famílias do tenant, em árvore (são poucas: cabem na memória).
final class FamilyIndex {
  FamilyIndex(List<ProductFamily> all) : byId = {for (final f in all) f.id: f} {
    final children = <UuidValue?, List<ProductFamily>>{};
    for (final f in all) {
      // Pai ausente (não deveria acontecer) vira raiz para não sumir da tela.
      final parent = f.parentId != null && byId.containsKey(f.parentId) ? f.parentId : null;
      (children[parent] ??= []).add(f);
    }
    for (final list in children.values) {
      list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    }
    void walk(UuidValue? parent, int depth) {
      for (final f in children[parent] ?? const <ProductFamily>[]) {
        tree.add((family: f, depth: depth));
        walk(f.id, depth + 1);
      }
    }

    walk(null, 0);
    _children = children;
  }

  static final empty = FamilyIndex(const []);

  final Map<UuidValue, ProductFamily> byId;
  final List<({ProductFamily family, int depth})> tree = [];
  late final Map<UuidValue?, List<ProductFamily>> _children;

  int childCount(UuidValue id) => _children[id]?.length ?? 0;

  /// `Refrigeração › Freezers`.
  String path(UuidValue? id) {
    final names = <String>[];
    var guard = 0;
    for (var cur = id == null ? null : byId[id]; cur != null && guard++ < 10; cur = byId[cur.parentId]) {
      names.insert(0, cur.name);
      if (cur.parentId == null) break;
    }
    return names.join(' › ');
  }

  /// A família e as descendentes (para não oferecer ciclo como "superior").
  Set<UuidValue> subtree(UuidValue id) {
    final out = <UuidValue>{id};
    final stack = [id];
    while (stack.isNotEmpty) {
      for (final c in _children[stack.removeLast()] ?? const <ProductFamily>[]) {
        if (out.add(c.id)) stack.add(c.id);
      }
    }
    return out;
  }

  static Future<FamilyIndex> load(Client api) async {
    final all = <ProductFamily>[];
    String? cursor;
    do {
      final page = await api.productFamilies.list(null, PageRequest(limit: 200, cursor: cursor));
      all.addAll(page.items);
      cursor = page.hasMore ? page.nextCursor : null;
    } while (cursor != null);
    return FamilyIndex(all);
  }
}
