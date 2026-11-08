// Cadastro de clientes de ponta a ponta (docs/08 §3.1): padrão de cadastro,
// isolamento entre tenants, permissões lidas do banco, concorrência otimista,
// paginação por cursor assinado, outbox e auditoria na mesma transação.
//
// Pré-requisitos: os do tenant_isolation_e2e_test.dart.
@Tags(['e2e'])
library;

import 'package:plataforma_os_client/plataforma_os_client.dart';
import 'package:plataforma_os_server/src/platform/auth/access_token_service.dart';
import 'package:plataforma_os_server/src/platform/auth/token_claims.dart';
import 'package:plataforma_os_server/src/platform/context/request_context.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:test/test.dart';

import 'support.dart';

void main() {
  late AccessTokenService tokens;
  late Client asAna; // tenant_admin em A
  late Client asBruno; // dispatcher em A
  late Client asCarla; // tenant_admin em B
  late Client asDavi; // manager em A (só leitura)
  late pg.Connection db;
  // Prefixo único por execução: o banco de teste acumula dados entre rodadas.
  final run = DateTime.now().toUtc().millisecondsSinceEpoch.toRadixString(36).toUpperCase();

  setUpAll(() async {
    tokens = loadTestTokens();
    asAna = clientAs(tokens, ana);
    asBruno = clientAs(tokens, bruno);
    asCarla = clientAs(tokens, carla);
    asDavi = clientAs(tokens, daviA);
    db = await openTestDb();
  });
  tearDownAll(() => db.close());

  Matcher apiError(String code) => throwsA(isA<ApiException>().having((e) => e.code, 'code', code));
  Matcher fieldErrors(String code, List<String> paths) => throwsA(
    isA<ApiException>()
        .having((e) => e.code, 'code', code)
        .having((e) => e.fieldErrors?.map((f) => f.path).toSet(), 'paths', containsAll(paths)),
  );

  Future<Customer> newCustomer(Client c, String suffix, {String? code}) => c.customers.create(
    CustomerInput(name: 'E2E $run $suffix', code: code, documentType: DocumentType.none),
  );

  test('cria normalizando documento, telefone e e-mail; o banco preenche versão e datas', () async {
    final id = const Uuid().v7obj();
    final created = await asAna.customers.create(
      CustomerInput(
        id: id,
        code: 'E2E-$run-1',
        name: '  Sorveteria Polo Norte Ltda  ',
        tradeName: 'Polo Norte',
        documentNumber: '11.222.333/0001-81',
        email: 'Compras@PoloNorte.TEST',
        phone: '(51) 99999-0001',
      ),
    );
    expect(created.id, id, reason: 'aceita o UUID v7 gerado pelo app');
    expect(created.tenantId, tenantA, reason: 'tenant vem do token, nunca do corpo');
    expect(created.name, 'Sorveteria Polo Norte Ltda');
    expect(created.documentType, DocumentType.cnpj);
    expect(created.documentNumber, '11222333000181');
    expect(created.email, 'compras@polonorte.test');
    expect(created.phone, '+5551999990001');
    expect(created.kind, CustomerKind.standard);
    expect(created.source, RecordSource.local);
    expect(created.version, 1);
    expect(created.createdAt.isUtc, isTrue);
    expect(
      DateTime.now().toUtc().difference(created.createdAt).inMinutes.abs(),
      lessThan(5),
      reason: 'timestamptz em UTC',
    );

    final fetched = await asAna.customers.get(id);
    expect(fetched.name, created.name);
    expect(fetched.createdAt, created.createdAt);

    // Outbox e auditoria gravados na mesma transação, com o ator e o tenant certos.
    final outbox = await db.execute(
      pg.Sql.named(
        "SELECT event_type, aggregate_version, payload->>'source', tenant_id::text "
        '  FROM app.outbox_messages WHERE aggregate_id = @id::uuid ORDER BY occurred_at',
      ),
      parameters: {'id': id.uuid},
    );
    expect(outbox.map((r) => r[0]), ['customer.created']);
    expect(outbox.single[1], 1);
    expect(outbox.single[2], 'local');
    expect(outbox.single[3], tenantA.uuid);
    final audit = await db.execute(
      pg.Sql.named('SELECT action, actor_user_id::text FROM app.audit_logs WHERE entity_id = @id::uuid'),
      parameters: {'id': id.uuid},
    );
    expect(audit.single[0], 'customers.insert');
    expect(audit.single[1], ana.user.uuid, reason: 'created_by/auditoria pelo app.user_id do interceptor');
  });

  test('CNPJ alfanumérico (desde 07/2026) é aceito e normalizado', () async {
    final c = await asAna.customers.create(
      CustomerInput(name: 'E2E $run alfanumérico', documentNumber: '12.abc.345/01de-35'),
    );
    expect(c.documentNumber, '12ABC34501DE35');
  });

  test('validação devolve todos os campos com erro de uma vez', () async {
    await expectLater(
      asAna.customers.create(
        CustomerInput(name: ' ', documentNumber: '11.222.333/0001-80', email: 'sem-arroba', phone: '1234'),
      ),
      fieldErrors('VALIDATION_FAILED', ['name', 'documentNumber', 'email', 'phone']),
    );
    await expectLater(
      asAna.customers.create(
        CustomerInput(name: 'E2E $run pf', personType: PersonType.individual, documentType: DocumentType.cnpj),
      ),
      fieldErrors('VALIDATION_FAILED', ['documentType']),
    );
  });

  test('código repetido no mesmo tenant: DUPLICATE; em outro tenant pode', () async {
    await newCustomer(asAna, 'dup1', code: 'DUP-$run');
    await expectLater(newCustomer(asBruno, 'dup2', code: 'DUP-$run'), fieldErrors('DUPLICATE', ['code']));
    final inB = await newCustomer(asCarla, 'dupB', code: 'DUP-$run');
    expect(inB.tenantId, tenantB);
  });

  test('isolamento: outro tenant recebe NOT_FOUND e não vê na lista nem na busca', () async {
    final a = await newCustomer(asAna, 'isolado');
    await expectLater(asCarla.customers.get(a.id), apiError('NOT_FOUND'));
    await expectLater(asCarla.customers.update(a.id, CustomerPatch(name: 'hack'), 1), apiError('NOT_FOUND'));
    await expectLater(asCarla.customers.deactivate(a.id, 'hack', 1), apiError('NOT_FOUND'));
    final page = await asCarla.customers.list(CustomerFilter(q: 'E2E $run isolado'), null);
    expect(page.items, isEmpty);
    expect((await asAna.customers.get(a.id)).name, 'E2E $run isolado', reason: 'nada mudou em A');
  });

  test('permissões vêm do banco: manager lê, mas não escreve', () async {
    final a = await newCustomer(asAna, 'leitura');
    expect((await asDavi.customers.get(a.id)).id, a.id);
    await expectLater(newCustomer(asDavi, 'manager'), apiError('FORBIDDEN'));
    await expectLater(asDavi.customers.update(a.id, CustomerPatch(notes: 'x'), a.version), apiError('FORBIDDEN'));
  });

  test('token com papel forjado não ganha permissão: o papel é relido do banco', () async {
    final forged = clientWithToken(
      tokens
          .issue(
            kind: TokenKind.staff,
            userId: daviA.user,
            tenantId: tenantA,
            actorType: ActorType.user,
            sessionId: 'e2e-forjado',
            membershipId: daviA.membership,
            roles: ['tenant_admin'], // o vínculo real é manager
          )
          .token,
    );
    await expectLater(newCustomer(forged, 'forjado'), apiError('FORBIDDEN'));
  });

  test('update com expectedVersion: versão sobe; versão velha → VERSION_MISMATCH', () async {
    final c = await newCustomer(asAna, 'versao');
    final v2 = await asAna.customers.update(c.id, CustomerPatch(notes: 'Portão azul', tradeName: 'Versão'), 1);
    expect(v2.version, 2);
    expect(v2.notes, 'Portão azul');
    await expectLater(
      asBruno.customers.update(c.id, CustomerPatch(notes: 'outra'), 1),
      throwsA(
        isA<ApiException>()
            .having((e) => e.code, 'code', 'VERSION_MISMATCH')
            .having((e) => e.currentVersion, 'currentVersion', 2),
      ),
    );
    // Patch sem mudança real não gasta versão nem gera evento.
    final same = await asAna.customers.update(c.id, CustomerPatch(notes: 'Portão azul'), 2);
    expect(same.version, 2);
    // clear apaga campos opcionais.
    final cleared = await asAna.customers.update(c.id, CustomerPatch(clear: [CustomerField.tradeName]), 2);
    expect(cleared.tradeName, isNull);
    expect(cleared.notes, 'Portão azul');
    expect(cleared.version, 3);

    final events = await db.execute(
      pg.Sql.named(
        "SELECT event_type, aggregate_version, payload->'changed_fields' FROM app.outbox_messages "
        ' WHERE aggregate_id = @id::uuid ORDER BY aggregate_version',
      ),
      parameters: {'id': c.id.uuid},
    );
    expect(events.map((r) => r[0]), ['customer.created', 'customer.updated', 'customer.updated']);
    expect(events[1][2], containsAll(['notes', 'tradeName']));
  });

  test('inativar exige motivo; lista filtra por ativo; reativar volta', () async {
    final c = await newCustomer(asAna, 'inativo');
    await expectLater(asAna.customers.deactivate(c.id, '  ', 1), fieldErrors('VALIDATION_FAILED', ['reason']));
    final off = await asAna.customers.deactivate(c.id, 'Fechou a loja', 1);
    expect(off.isActive, isFalse);
    expect(off.deactivatedAt, isNotNull);
    final active = await asAna.customers.list(CustomerFilter(q: 'E2E $run inativo', isActive: true), null);
    expect(active.items, isEmpty);
    final on = await asAna.customers.reactivate(c.id, off.version);
    expect(on.isActive, isTrue);
    expect(on.deactivatedAt, isNull);
    final reason = await db.execute(
      pg.Sql.named(
        "SELECT payload->>'reason' FROM app.outbox_messages WHERE aggregate_id = @id::uuid "
        "AND event_type = 'customer.deactivated'",
      ),
      parameters: {'id': c.id.uuid},
    );
    expect(reason.single[0], 'Fechou a loja');
  });

  test('paginação por cursor: páginas sem repetição, na ordem, e cursor protegido', () async {
    for (final s in ['p-c', 'p-a', 'p-e', 'p-b', 'p-d']) {
      await newCustomer(asAna, s);
    }
    final filter = CustomerFilter(q: 'E2E $run p-');
    final seen = <String>[];
    String? cursor;
    var pages = 0;
    do {
      final page = await asAna.customers.list(filter, PageRequest(limit: 2, cursor: cursor, includeTotal: pages == 0));
      if (pages == 0) expect(page.total, 5);
      seen.addAll(page.items.map((c) => c.name));
      cursor = page.nextCursor;
      expect(page.hasMore, cursor != null);
      pages++;
    } while (cursor != null);
    expect(pages, 3);
    expect(seen, [
      for (final s in ['p-a', 'p-b', 'p-c', 'p-d', 'p-e']) 'E2E $run $s',
    ]);

    // Ordem decrescente por data de criação.
    final desc = await asAna.customers.list(filter, PageRequest(sort: 'createdAt', descending: true, limit: 5));
    expect(desc.items.first.name, 'E2E $run p-d');

    final first = await asAna.customers.list(filter, PageRequest(limit: 2));
    final good = first.nextCursor!;
    final tampered = '${good.substring(0, good.indexOf('.') - 2)}AA${good.substring(good.indexOf('.'))}';
    await expectLater(
      asAna.customers.list(filter, PageRequest(limit: 2, cursor: tampered)),
      apiError('CURSOR_MISMATCH'),
    );
    await expectLater(
      asAna.customers.list(CustomerFilter(q: 'E2E $run p-', isActive: true), PageRequest(limit: 2, cursor: good)),
      apiError('CURSOR_MISMATCH'),
      reason: 'cursor vale só para a mesma combinação de filtros',
    );
    await expectLater(asAna.customers.list(filter, PageRequest(sort: 'documentNumber')), apiError('INVALID_FILTER'));
    await expectLater(asAna.customers.list(filter, PageRequest(limit: 500)), apiError('INVALID_FILTER'));
  });

  test('busca por documento sem máscara e por código', () async {
    final c = await asAna.customers.create(
      CustomerInput(
        name: 'E2E $run doc',
        code: 'DOC-$run',
        documentNumber: '529.982.247-25',
        personType: PersonType.individual,
      ),
    );
    expect(
      (await asAna.customers.list(CustomerFilter(q: '529.982.247-25'), null)).items.map((x) => x.id),
      contains(c.id),
    );
    expect((await asAna.customers.list(CustomerFilter(q: 'doc-$run'), null)).items.map((x) => x.id), [c.id]);
  });
}
