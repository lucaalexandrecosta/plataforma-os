import 'package:plataforma_os_server/src/customers/internal/customer_rules.dart';
import 'package:plataforma_os_server/src/generated/protocol.dart';
import 'package:plataforma_os_server/src/platform/paging/paging.dart';
import 'package:serverpod/serverpod.dart';
import 'package:test/test.dart';

CustomerDraft draft(CustomerInput i) => CustomerDraft.fromInput(i);

void main() {
  group('CustomerRules', () {
    test('padrões: empresa com CNPJ, cliente standard, sem pular triagem', () {
      final d = draft(CustomerInput(name: 'X'));
      expect(d.personType, PersonType.company);
      expect(d.documentType, DocumentType.cnpj);
      expect(d.kind, CustomerKind.standard);
      expect(d.skipTriage, isFalse);
      expect(draft(CustomerInput(name: 'X', personType: PersonType.individual)).documentType, DocumentType.cpf);
    });

    test('normaliza espaços, documento, e-mail, telefone e IE', () {
      final r = CustomerRules.validate(
        draft(
          CustomerInput(
            name: '  ACME  ',
            code: ' C-01 ',
            documentNumber: '11.222.333/0001-81',
            email: ' A@B.COM ',
            phone: '51 3333-4444',
            stateRegistration: 'isento',
            tradeName: '   ',
          ),
        ),
      );
      expect(r.errors, isEmpty);
      final d = r.draft!;
      expect(d.name, 'ACME');
      expect(d.code, 'C-01');
      expect(d.documentNumber, '11222333000181');
      expect(d.email, 'a@b.com');
      expect(d.phone, '+555133334444');
      expect(d.stateRegistration, 'ISENTO');
      expect(d.tradeName, isNull, reason: 'texto em branco vira nulo');
    });

    test('documento: obrigatório por tipo, proibido em none, livre em foreign', () {
      List<String> paths(CustomerInput i) => [for (final e in CustomerRules.validate(draft(i)).errors) e.path];
      expect(paths(CustomerInput(name: 'X')), ['documentNumber']);
      expect(paths(CustomerInput(name: 'X', documentType: DocumentType.none, documentNumber: '1')), ['documentNumber']);
      expect(paths(CustomerInput(name: 'X', documentType: DocumentType.foreign, documentNumber: 'P-123/AR')), isEmpty);
      expect(
        paths(CustomerInput(name: 'X', personType: PersonType.individual, documentNumber: '529.982.247-25')),
        isEmpty,
      );
      expect(
        paths(
          CustomerInput(
            name: 'X',
            personType: PersonType.individual,
            documentType: DocumentType.cnpj,
            documentNumber: '11222333000181',
          ),
        ),
        ['documentType'],
      );
    });

    test('patch: nulo mantém, clear apaga, valor troca', () {
      final base = draft(CustomerInput(name: 'A', tradeName: 'T', notes: 'N', documentType: DocumentType.none));
      final next = base.apply(CustomerPatch(name: 'B', clear: [CustomerField.tradeName]));
      expect(next.name, 'B');
      expect(next.tradeName, isNull);
      expect(next.notes, 'N');
    });

    test('campos mestres do ERP espelham o trigger do banco (sem extensões locais)', () {
      expect(customerMasterFields, isNot(contains('notes')));
      expect(customerMasterFields, isNot(contains('kind')));
      expect(customerMasterFields, isNot(contains('skipTriage')));
      expect(customerMasterFields, containsAll(['name', 'documentNumber', 'email', 'phone']));
    });
  });

  group('Paging', () {
    setUpAll(() => Paging.configure('chave-de-teste-com-mais-de-32-caracteres!'));

    // Session não é usada nos caminhos felizes; nos de erro, o teste só confere que lança.
    PagePlan plan(PageRequest? p, {Map<String, Object?> f = const {'q': 'x'}}) => Paging.plan(
      _NoSession(),
      p,
      resource: 'customers',
      sortable: {'name', 'createdAt'},
      defaultSort: 'name',
      filterFingerprint: f,
    );

    test('cursor ida e volta para a mesma listagem', () {
      final p = plan(PageRequest(limit: 10));
      final id = UuidValue.withValidation('0197f000-0001-7300-8000-000000000001');
      final cursor = Paging.encode(p, sortValue: 'Padaria', id: id);
      final next = plan(PageRequest(limit: 10, cursor: cursor));
      expect(next.after!.sortValue, 'Padaria');
      expect(next.after!.id, id);
      expect(next.fetchLimit, 11);
    });

    test('padrões e limites', () {
      final p = plan(null);
      expect(p.limit, Paging.defaultLimit);
      expect(p.sort, 'name');
      expect(p.descending, isFalse);
    });

    test('cursor de outro filtro, ordenação ou adulterado é recusado', () {
      final p = plan(PageRequest());
      final cursor = Paging.encode(
        p,
        sortValue: 'A',
        id: UuidValue.withValidation('0197f000-0001-7300-8000-000000000001'),
      );
      expect(() => plan(PageRequest(cursor: cursor), f: {'q': 'y'}), throwsA(anything));
      expect(() => plan(PageRequest(cursor: cursor, descending: true)), throwsA(anything));
      expect(() => plan(PageRequest(cursor: 'x$cursor')), throwsA(anything));
      expect(() => plan(PageRequest(cursor: 'lixo')), throwsA(anything));
    });
  });
}

/// As fábricas de erro só leem `sessionId`; nos testes de caminho de erro basta
/// que algo seja lançado.
class _NoSession implements Session {
  @override
  dynamic noSuchMethod(Invocation invocation) => throw UnsupportedError('sessão de teste');
}
