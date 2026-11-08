import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../errors/api_errors.dart';

/// Paginação por chave (keyset) com cursor opaco e assinado (docs/08 §2.6).
///
/// O cursor carrega a chave de ordenação e o `id` do último item, mais um
/// resumo dos filtros e da ordenação. É `base64url(json).base64url(hmac)`:
/// adulterado, de outra listagem ou de outra combinação de filtros →
/// `CURSOR_MISMATCH`. Não é segredo (só ids e valores que o usuário já viu),
/// mas a assinatura impede montar cursores para varrer o índice.
abstract final class Paging {
  static const defaultLimit = 50;
  static const maxLimit = 200;
  static const totalCap = 10000;

  static Hmac? _hmac;

  /// Chamado na inicialização com o segredo `cursorSigningKey`.
  static void configure(String secret) {
    if (secret.length < 32) throw StateError('cursorSigningKey precisa de pelo menos 32 caracteres.');
    _hmac = Hmac(sha256, utf8.encode(secret));
  }

  static Hmac get _mac => _hmac ?? (throw StateError('Paging.configure não foi chamado.'));

  /// Resolve limite e ordenação contra a lista de campos permitidos do recurso.
  static PagePlan plan(
    Session session,
    PageRequest? page, {
    required String resource,
    required Set<String> sortable,
    required String defaultSort,
    required Map<String, Object?> filterFingerprint,
  }) {
    final limit = page?.limit ?? defaultLimit;
    if (limit < 1 || limit > maxLimit) {
      throw ApiErrors.invalidFilter(session, 'O limite da página deve estar entre 1 e $maxLimit.');
    }
    final sort = page?.sort ?? defaultSort;
    if (!sortable.contains(sort)) {
      throw ApiErrors.invalidFilter(session, 'Ordenação "$sort" não permitida. Use: ${sortable.join(', ')}.');
    }
    final descending = page?.descending ?? false;
    final scope = _scope(resource, sort, descending, filterFingerprint);
    PageCursor? after;
    final raw = page?.cursor;
    if (raw != null && raw.isNotEmpty) {
      after = _decode(raw, scope) ?? (throw ApiErrors.cursorMismatch(session));
    }
    return PagePlan(
      limit: limit,
      sort: sort,
      descending: descending,
      after: after,
      includeTotal: page?.includeTotal ?? false,
      scope: scope,
    );
  }

  static String encode(PagePlan plan, {required String sortValue, required UuidValue id}) {
    final body = utf8.encode(jsonEncode({'s': plan.scope, 'k': sortValue, 'i': id.uuid}));
    final sig = _mac.convert(body).bytes.sublist(0, 16);
    return '${_b64(body)}.${_b64(sig)}';
  }

  static PageCursor? _decode(String raw, String scope) {
    final parts = raw.split('.');
    if (parts.length != 2) return null;
    try {
      final body = base64Url.decode(base64Url.normalize(parts[0]));
      final sig = base64Url.decode(base64Url.normalize(parts[1]));
      final expected = _mac.convert(body).bytes.sublist(0, 16);
      if (!_constantTimeEquals(sig, expected)) return null;
      final json = jsonDecode(utf8.decode(body)) as Map<String, Object?>;
      if (json['s'] != scope) return null;
      return PageCursor(sortValue: json['k']! as String, id: UuidValue.withValidation(json['i']! as String));
    } on Object {
      return null;
    }
  }

  // Resumo estável (ordem das chaves fixa) do que define a listagem.
  static String _scope(String resource, String sort, bool descending, Map<String, Object?> filters) {
    final keys = filters.keys.toList()..sort();
    final canonical = jsonEncode([
      resource,
      sort,
      descending,
      for (final k in keys) [k, filters[k]],
    ]);
    return _b64(sha256.convert(utf8.encode(canonical)).bytes.sublist(0, 12));
  }

  static String _b64(List<int> bytes) => base64Url.encode(bytes).replaceAll('=', '');

  static bool _constantTimeEquals(List<int> a, List<int> b) {
    if (a.length != b.length) return false;
    var diff = 0;
    for (var i = 0; i < a.length; i++) {
      diff |= a[i] ^ b[i];
    }
    return diff == 0;
  }
}

final class PageCursor {
  const PageCursor({required this.sortValue, required this.id});
  final String sortValue;
  final UuidValue id;
}

final class PagePlan {
  const PagePlan({
    required this.limit,
    required this.sort,
    required this.descending,
    required this.after,
    required this.includeTotal,
    required this.scope,
  });

  final int limit;
  final String sort;
  final bool descending;
  final PageCursor? after;
  final bool includeTotal;
  final String scope;

  /// Busca `limit + 1` para saber se há próxima página sem `COUNT`.
  int get fetchLimit => limit + 1;
}

/// Escapa `%`, `_` e `\` para `ILIKE` com o padrão `%termo%`.
String likeContains(String term) => '%${term.replaceAll(r'\', r'\\').replaceAll('%', r'\%').replaceAll('_', r'\_')}%';
