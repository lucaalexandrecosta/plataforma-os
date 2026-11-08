import 'package:plataforma_os_core/plataforma_os_core.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../platform/context/request_context.dart';
import '../../platform/imports/import_spec.dart';
import '../../platform/outbox/outbox.dart';
import 'customer_contact_service.dart';
import 'customer_rules.dart';
import 'customer_service.dart';
import 'customer_site_service.dart';
import 'site_and_contact_rules.dart';

/// Importações por planilha do módulo `customers`. As linhas passam pelas
/// mesmas regras das telas (`CustomerRules`, `SiteRules`, `ContactRules`).

List<String> _messages(List<FieldError> errors, List<ImportColumn> columns, Map<String, String> pathToColumn) {
  final labels = {for (final c in columns) c.key: c.label};
  return [
    for (final e in errors) '${labels[pathToColumn[e.path] ?? e.path] ?? e.path}: ${e.message}',
  ];
}

Map<String, Object?> _changed(Map<String, Object?> before, Map<String, Object?> after) => {
  for (final e in after.entries)
    if (e.value != before[e.key]) e.key: e.value,
};

Future<List<T>> _findIn<T>(List<String> values, Future<List<T>> Function(Set<String> chunk) query) async {
  final out = <T>[];
  for (var i = 0; i < values.length; i += 1000) {
    out.addAll(await query(values.sublist(i, i + 1000 > values.length ? values.length : i + 1000).toSet()));
  }
  return out;
}

Future<void> _event(
  Session session,
  Transaction tx, {
  required String type,
  required String aggregateType,
  required UuidValue id,
  required int version,
  required UuidValue runId,
  required Map<String, Object?> payload,
}) => Outbox.record(
  session,
  tx,
  eventType: type,
  aggregateType: aggregateType,
  aggregateId: id,
  aggregateVersion: version,
  payload: {...payload, 'origin': 'file_import', 'import_run_id': runId.uuid},
);

// ---------------------------------------------------------------------------
// Clientes
// ---------------------------------------------------------------------------

final class _CustomerCreate {
  const _CustomerCreate(this.draft);
  final CustomerDraft draft;
}

final class _CustomerUpdate {
  const _CustomerUpdate(this.current, this.changed);
  final Customer current;
  final Map<String, Object?> changed;
}

final class CustomersImport extends ImportSpec {
  @override
  ImportEntityType get entity => ImportEntityType.customers;
  @override
  String get title => 'Clientes';
  @override
  String get description =>
      'Cria ou atualiza clientes pelo código. Células vazias não apagam o que já está cadastrado.';

  @override
  final List<ImportColumn> columns = const [
    ImportColumn(
      'codigo',
      'Código',
      isRequired: true,
      help: 'Chave da importação: único na empresa.',
      example: 'C001',
      aliases: ['cod', 'code', 'codigo_cliente'],
    ),
    ImportColumn(
      'razao_social',
      'Razão social / nome',
      isRequired: true,
      help: 'Nome completo ou razão social.',
      example: 'Padaria Pão Quente Ltda',
      aliases: ['nome', 'name', 'cliente'],
    ),
    ImportColumn('nome_fantasia', 'Nome fantasia', help: 'Opcional.', example: 'Pão Quente', aliases: ['fantasia']),
    ImportColumn(
      'tipo_pessoa',
      'Tipo de pessoa',
      help: 'PJ ou PF. Vazio: pelo documento (11 dígitos = PF).',
      example: 'PJ',
      aliases: ['tipo'],
    ),
    ImportColumn(
      'documento',
      'CNPJ / CPF',
      help: 'Com ou sem máscara. Aceita CNPJ alfanumérico.',
      example: '11.222.333/0001-81',
      aliases: ['cnpj', 'cpf', 'cnpj_cpf', 'cpf_cnpj'],
    ),
    ImportColumn(
      'inscricao_estadual',
      'Inscrição estadual',
      help: 'Opcional; ou ISENTO.',
      example: 'ISENTO',
      aliases: ['ie'],
    ),
    ImportColumn(
      'email',
      'E-mail',
      help: 'Contato geral do cliente.',
      example: 'compras@paoquente.com.br',
      aliases: ['e_mail'],
    ),
    ImportColumn('telefone', 'Telefone', help: 'Com DDD.', example: '(51) 3333-4444', aliases: ['fone', 'phone']),
    ImportColumn(
      'observacoes',
      'Observações',
      help: 'Para a equipe e os técnicos.',
      example: 'Entregas só pela manhã',
      aliases: ['obs', 'notes'],
    ),
  ];

  static const _pathToColumn = {
    'code': 'codigo',
    'name': 'razao_social',
    'tradeName': 'nome_fantasia',
    'personType': 'tipo_pessoa',
    'documentType': 'documento',
    'documentNumber': 'documento',
    'stateRegistration': 'inscricao_estadual',
    'email': 'email',
    'phone': 'telefone',
    'notes': 'observacoes',
  };

  static PersonType? _personType(String? v) {
    if (v == null) return null;
    final t = ImportCells.normalizeHeader(v);
    if ({'pj', 'empresa', 'juridica', 'pessoa_juridica', 'j'}.contains(t)) return PersonType.company;
    if ({'pf', 'fisica', 'pessoa_fisica', 'f', 'individual'}.contains(t)) return PersonType.individual;
    throw const FormatException('use PJ ou PF');
  }

  @override
  Future<List<ImportRowPlan>> plan(Session session, List<ImportRecord> records, {Transaction? transaction}) async {
    final codes = [
      for (final r in records)
        if (r['codigo'] != null) r['codigo']!,
    ];
    final existing = {
      for (final c in await _findIn(
        codes,
        (chunk) => Customer.db.find(session, where: (t) => t.code.inSet(chunk), transaction: transaction),
      ))
        c.code!: c,
    };
    final seen = <String>{};
    final plans = <ImportRowPlan>[];

    for (final r in records) {
      final code = r['codigo'];
      if (code == null) {
        plans.add(
          ImportRowPlan(
            rowNumber: r.rowNumber,
            action: ImportAction.error,
            messages: const ['Código: obrigatório (é a chave da importação).'],
          ),
        );
        continue;
      }
      if (!seen.add(code)) {
        plans.add(
          ImportRowPlan(
            rowNumber: r.rowNumber,
            key: code,
            action: ImportAction.error,
            messages: const ['Código repetido na planilha.'],
          ),
        );
        continue;
      }
      try {
        final current = existing[code];
        var personType = _personType(r['tipo_pessoa']);
        final rawDoc = r['documento'];
        DocumentType? documentType;
        if (rawDoc != null) {
          final normalized = BrDocuments.normalize(rawDoc);
          documentType = switch (normalized.length) {
            11 => DocumentType.cpf,
            14 => DocumentType.cnpj,
            _ => throw const FormatException('CNPJ / CPF: deve ter 14 (CNPJ) ou 11 (CPF) caracteres.'),
          };
          personType ??= documentType == DocumentType.cpf ? PersonType.individual : PersonType.company;
        }
        final base = current == null ? null : CustomerDraft.fromCustomer(current);
        final draft = CustomerDraft(
          code: code,
          name: r['razao_social'] ?? base?.name ?? '',
          tradeName: r['nome_fantasia'] ?? base?.tradeName,
          personType: personType ?? base?.personType ?? PersonType.company,
          documentType: documentType ?? base?.documentType ?? DocumentType.none,
          documentNumber: rawDoc ?? base?.documentNumber,
          stateRegistration: r['inscricao_estadual'] ?? base?.stateRegistration,
          email: r['email'] ?? base?.email,
          phone: r['telefone'] ?? base?.phone,
          notes: r['observacoes'] ?? base?.notes,
          kind: base?.kind ?? CustomerKind.standard,
          skipTriage: base?.skipTriage ?? false,
        );
        final v = CustomerRules.validate(draft);
        if (v.errors.isNotEmpty) {
          plans.add(
            ImportRowPlan(
              rowNumber: r.rowNumber,
              key: code,
              action: ImportAction.error,
              messages: _messages(v.errors, columns, _pathToColumn),
            ),
          );
          continue;
        }
        if (current == null) {
          plans.add(
            ImportRowPlan(
              rowNumber: r.rowNumber,
              key: code,
              action: ImportAction.create,
              payload: _CustomerCreate(v.draft!),
            ),
          );
          continue;
        }
        final changed = _changed(base!.toFields(), v.draft!.toFields());
        if (changed.isEmpty) {
          plans.add(ImportRowPlan(rowNumber: r.rowNumber, key: code, action: ImportAction.unchanged));
        } else if (current.source == RecordSource.erp && changed.keys.any(customerMasterFields.contains)) {
          plans.add(
            ImportRowPlan(
              rowNumber: r.rowNumber,
              key: code,
              action: ImportAction.error,
              messages: const ['Cliente vem do ERP: os dados mestres só mudam por lá.'],
            ),
          );
        } else {
          plans.add(
            ImportRowPlan(
              rowNumber: r.rowNumber,
              key: code,
              action: ImportAction.update,
              payload: _CustomerUpdate(current, changed),
            ),
          );
        }
      } on FormatException catch (e) {
        final msg = e.message.contains(':') ? e.message : 'Tipo de pessoa: ${e.message}.';
        plans.add(ImportRowPlan(rowNumber: r.rowNumber, key: code, action: ImportAction.error, messages: [msg]));
      }
    }
    return plans;
  }

  @override
  Future<({int created, int updated})> apply(
    Session session,
    Transaction transaction,
    List<ImportRowPlan> plan, {
    required UuidValue runId,
  }) async {
    final now = DateTime.now().toUtc();
    final tenantId = session.context.tenantId!;
    final toInsert = [
      for (final p in plan)
        if (p.payload case _CustomerCreate(:final draft))
          Customer(
            tenantId: tenantId,
            code: draft.code,
            name: draft.name,
            tradeName: draft.tradeName,
            personType: draft.personType,
            documentType: draft.documentType,
            documentNumber: draft.documentNumber,
            stateRegistration: draft.stateRegistration,
            email: draft.email,
            phone: draft.phone,
            notes: draft.notes,
            kind: draft.kind,
            skipTriage: draft.skipTriage,
            isActive: true,
            source: RecordSource.local,
            createdAt: now,
            updatedAt: now,
            version: 1,
          ),
    ];
    var created = 0;
    for (var i = 0; i < toInsert.length; i += 500) {
      final rows = await Customer.db.insert(
        session,
        toInsert.sublist(i, i + 500 > toInsert.length ? toInsert.length : i + 500),
        transaction: transaction,
      );
      for (final c in rows) {
        await _event(
          session,
          transaction,
          type: 'customer.created',
          aggregateType: 'customer',
          id: c.id,
          version: c.version,
          runId: runId,
          payload: {'customer_id': c.id.uuid, 'source': 'local'},
        );
      }
      created += rows.length;
    }
    var updated = 0;
    for (final p in plan) {
      if (p.payload case _CustomerUpdate(:final current, :final changed)) {
        final rows = await Customer.db.updateWhere(
          session,
          columnValues: (t) => [for (final e in changed.entries) CustomerService.columnValue(t, e.key, e.value)],
          where: (t) => t.id.equals(current.id) & t.version.equals(current.version),
          transaction: transaction,
        );
        if (rows.isEmpty) throw StateError('Cliente ${current.code} mudou durante a importação.');
        await _event(
          session,
          transaction,
          type: 'customer.updated',
          aggregateType: 'customer',
          id: current.id,
          version: rows.single.version,
          runId: runId,
          payload: {
            'customer_id': current.id.uuid,
            'source': current.source.name,
            'changed_fields': changed.keys.toList()..sort(),
          },
        );
        updated++;
      }
    }
    return (created: created, updated: updated);
  }
}

// ---------------------------------------------------------------------------
// Unidades
// ---------------------------------------------------------------------------

final class _SiteCreate {
  const _SiteCreate(this.customerId, this.draft);
  final UuidValue customerId;
  final SiteDraft draft;
}

final class _SiteUpdate {
  const _SiteUpdate(this.current, this.changed);
  final CustomerSite current;
  final Map<String, Object?> changed;
}

final class CustomerSitesImport extends ImportSpec {
  @override
  ImportEntityType get entity => ImportEntityType.customer_sites;
  @override
  String get title => 'Unidades de clientes';
  @override
  String get description =>
      'Cria ou atualiza unidades pelo código do cliente + código da unidade. Importe os clientes antes.';

  @override
  final List<ImportColumn> columns = const [
    ImportColumn(
      'codigo_cliente',
      'Código do cliente',
      isRequired: true,
      help: 'Cliente já cadastrado.',
      example: 'C001',
      aliases: ['cliente', 'cod_cliente'],
    ),
    ImportColumn(
      'codigo_unidade',
      'Código da unidade',
      isRequired: true,
      help: 'Chave da unidade dentro do cliente.',
      example: 'U01',
      aliases: ['cod_unidade', 'unidade_codigo'],
    ),
    ImportColumn(
      'nome_unidade',
      'Nome da unidade',
      isRequired: true,
      help: 'Como a equipe chama o local.',
      example: 'Loja Centro',
      aliases: ['unidade', 'nome'],
    ),
    ImportColumn('cep', 'CEP', help: '8 dígitos, com ou sem hífen.', example: '90020-007', aliases: ['codigo_postal']),
    ImportColumn(
      'logradouro',
      'Logradouro',
      help: 'Rua, avenida…',
      example: 'Rua dos Andradas',
      aliases: ['endereco', 'rua'],
    ),
    ImportColumn('numero', 'Número', help: '', example: '1001', aliases: ['num', 'nro']),
    ImportColumn('complemento', 'Complemento', help: '', example: 'Loja 2'),
    ImportColumn('bairro', 'Bairro', help: '', example: 'Centro Histórico'),
    ImportColumn('cidade', 'Cidade', help: '', example: 'Porto Alegre', aliases: ['municipio']),
    ImportColumn('uf', 'UF', help: 'Sigla do estado.', example: 'RS', aliases: ['estado']),
    ImportColumn(
      'latitude',
      'Latitude',
      help: 'Graus decimais; ponto ou vírgula.',
      example: '-30,0277',
      aliases: ['lat'],
    ),
    ImportColumn(
      'longitude',
      'Longitude',
      help: 'Graus decimais; ponto ou vírgula.',
      example: '-51,2287',
      aliases: ['lng', 'lon', 'long'],
    ),
    ImportColumn('telefone', 'Telefone da unidade', help: 'Com DDD.', example: '(51) 3333-4444', aliases: ['fone']),
    ImportColumn(
      'instrucoes_acesso',
      'Instruções de acesso',
      help: 'Portaria, horários, estacionamento.',
      example: 'Entrada pela doca',
      aliases: ['acesso', 'observacoes'],
    ),
  ];

  static const _pathToColumn = {
    'code': 'codigo_unidade',
    'name': 'nome_unidade',
    'street': 'logradouro',
    'streetNumber': 'numero',
    'complement': 'complemento',
    'district': 'bairro',
    'city': 'cidade',
    'state': 'uf',
    'postalCode': 'cep',
    'latitude': 'latitude',
    'longitude': 'longitude',
    'phone': 'telefone',
    'accessNotes': 'instrucoes_acesso',
  };

  @override
  Future<List<ImportRowPlan>> plan(Session session, List<ImportRecord> records, {Transaction? transaction}) async {
    final customerCodes = {for (final r in records) ?r['codigo_cliente']}.toList();
    final customers = {
      for (final c in await _findIn(
        customerCodes,
        (chunk) => Customer.db.find(session, where: (t) => t.code.inSet(chunk), transaction: transaction),
      ))
        c.code!: c,
    };
    final customerIds = [for (final c in customers.values) c.id.uuid];
    final sites = <String, CustomerSite>{};
    for (final s in await _findIn(
      customerIds,
      (chunk) => CustomerSite.db.find(
        session,
        where: (t) =>
            t.customerId.inSet({for (final id in chunk) UuidValue.withValidation(id)}) & t.code.notEquals(null),
        transaction: transaction,
      ),
    )) {
      sites.putIfAbsent('${s.customerId.uuid}|${s.code}', () => s);
    }

    final seen = <String>{};
    final plans = <ImportRowPlan>[];
    for (final r in records) {
      final customerCode = r['codigo_cliente'];
      final siteCode = r['codigo_unidade'];
      final key = '${customerCode ?? '?'} / ${siteCode ?? '?'}';
      ImportRowPlan error(List<String> m) =>
          ImportRowPlan(rowNumber: r.rowNumber, key: key, action: ImportAction.error, messages: m);
      if (customerCode == null || siteCode == null) {
        plans.add(error(['Código do cliente e código da unidade são obrigatórios.']));
        continue;
      }
      final customer = customers[customerCode];
      if (customer == null) {
        plans.add(error(['Cliente "$customerCode" não encontrado. Importe os clientes antes.']));
        continue;
      }
      if (!customer.isActive) {
        plans.add(error(['Cliente "$customerCode" está inativo.']));
        continue;
      }
      if (!seen.add('$customerCode|$siteCode')) {
        plans.add(error(['Unidade repetida na planilha.']));
        continue;
      }
      try {
        final current = sites['${customer.id.uuid}|$siteCode'];
        final base = current == null ? null : SiteDraft.fromSite(current);
        final lat = ImportCells.decimal(r['latitude']);
        final lng = ImportCells.decimal(r['longitude']);
        final draft = SiteDraft(
          code: siteCode,
          name: r['nome_unidade'] ?? base?.name ?? '',
          street: r['logradouro'] ?? base?.street,
          streetNumber: r['numero'] ?? base?.streetNumber,
          complement: r['complemento'] ?? base?.complement,
          district: r['bairro'] ?? base?.district,
          city: r['cidade'] ?? base?.city,
          state: r['uf'] ?? base?.state,
          postalCode: r['cep'] ?? base?.postalCode,
          countryCode: base?.countryCode ?? 'BR',
          latitude: lat ?? base?.latitude,
          longitude: lng ?? base?.longitude,
          phone: r['telefone'] ?? base?.phone,
          accessNotes: r['instrucoes_acesso'] ?? base?.accessNotes,
        );
        final v = SiteRules.validate(draft);
        if (v.errors.isNotEmpty) {
          plans.add(error(_messages(v.errors, columns, _pathToColumn)));
          continue;
        }
        if (current == null) {
          plans.add(
            ImportRowPlan(
              rowNumber: r.rowNumber,
              key: key,
              action: ImportAction.create,
              payload: _SiteCreate(customer.id, v.value!),
            ),
          );
          continue;
        }
        final changed = _changed(base!.toFields(), v.value!.toFields());
        if (changed.isEmpty) {
          plans.add(ImportRowPlan(rowNumber: r.rowNumber, key: key, action: ImportAction.unchanged));
        } else if (current.source == RecordSource.erp && changed.keys.any(siteMasterFields.contains)) {
          plans.add(error(['Unidade vem do ERP: o endereço só muda por lá.']));
        } else {
          plans.add(
            ImportRowPlan(
              rowNumber: r.rowNumber,
              key: key,
              action: ImportAction.update,
              payload: _SiteUpdate(current, changed),
            ),
          );
        }
      } on FormatException catch (e) {
        plans.add(error(['Latitude/longitude: ${e.message}.']));
      }
    }
    return plans;
  }

  @override
  Future<({int created, int updated})> apply(
    Session session,
    Transaction transaction,
    List<ImportRowPlan> plan, {
    required UuidValue runId,
  }) async {
    final now = DateTime.now().toUtc();
    final tenantId = session.context.tenantId!;
    final toInsert = [
      for (final p in plan)
        if (p.payload case _SiteCreate(:final customerId, :final draft))
          CustomerSite(
            tenantId: tenantId,
            customerId: customerId,
            code: draft.code,
            name: draft.name,
            street: draft.street,
            streetNumber: draft.streetNumber,
            complement: draft.complement,
            district: draft.district,
            city: draft.city,
            state: draft.state,
            postalCode: draft.postalCode,
            countryCode: draft.countryCode,
            latitude: draft.latitude,
            longitude: draft.longitude,
            phone: draft.phone,
            accessNotes: draft.accessNotes,
            isActive: true,
            source: RecordSource.local,
            createdAt: now,
            updatedAt: now,
            version: 1,
          ),
    ];
    var created = 0;
    for (var i = 0; i < toInsert.length; i += 500) {
      final rows = await CustomerSite.db.insert(
        session,
        toInsert.sublist(i, i + 500 > toInsert.length ? toInsert.length : i + 500),
        transaction: transaction,
      );
      for (final s in rows) {
        await _event(
          session,
          transaction,
          type: 'customer_site.created',
          aggregateType: 'customer_site',
          id: s.id,
          version: s.version,
          runId: runId,
          payload: {'customer_site_id': s.id.uuid, 'customer_id': s.customerId.uuid, 'source': 'local'},
        );
      }
      created += rows.length;
    }
    var updated = 0;
    for (final p in plan) {
      if (p.payload case _SiteUpdate(:final current, :final changed)) {
        final rows = await CustomerSite.db.updateWhere(
          session,
          columnValues: (t) => [for (final e in changed.entries) CustomerSiteService.columnValue(t, e.key, e.value)],
          where: (t) => t.id.equals(current.id) & t.version.equals(current.version),
          transaction: transaction,
        );
        if (rows.isEmpty) throw StateError('Unidade ${current.code} mudou durante a importação.');
        await _event(
          session,
          transaction,
          type: 'customer_site.updated',
          aggregateType: 'customer_site',
          id: current.id,
          version: rows.single.version,
          runId: runId,
          payload: {
            'customer_site_id': current.id.uuid,
            'customer_id': current.customerId.uuid,
            'source': current.source.name,
            'changed_fields': changed.keys.toList()..sort(),
          },
        );
        updated++;
      }
    }
    return (created: created, updated: updated);
  }
}

// ---------------------------------------------------------------------------
// Contatos
// ---------------------------------------------------------------------------

final class _ContactCreate {
  const _ContactCreate(this.customerId, this.draft);
  final UuidValue customerId;
  final ContactDraft draft;
}

final class _ContactUpdate {
  const _ContactUpdate(this.current, this.changed);
  final CustomerContact current;
  final Map<String, Object?> changed;
}

final class CustomerContactsImport extends ImportSpec {
  @override
  ImportEntityType get entity => ImportEntityType.customer_contacts;
  @override
  String get title => 'Contatos de clientes';
  @override
  String get description =>
      'Cria ou atualiza contatos pelo cliente + e-mail (ou celular, se não houver e-mail). Importe clientes e unidades antes.';

  @override
  final List<ImportColumn> columns = const [
    ImportColumn(
      'codigo_cliente',
      'Código do cliente',
      isRequired: true,
      help: 'Cliente já cadastrado.',
      example: 'C001',
      aliases: ['cliente', 'cod_cliente'],
    ),
    ImportColumn(
      'nome',
      'Nome',
      isRequired: true,
      help: 'Nome da pessoa.',
      example: 'Maria Souza',
      aliases: ['contato', 'nome_contato'],
    ),
    ImportColumn(
      'celular',
      'Celular (WhatsApp)',
      help: 'Com DDD. Celular ou e-mail é obrigatório.',
      example: '(51) 98888-7777',
      aliases: ['whatsapp', 'telefone', 'fone'],
    ),
    ImportColumn(
      'email',
      'E-mail',
      help: 'Identifica o contato na reimportação.',
      example: 'maria@paoquente.com.br',
      aliases: ['e_mail'],
    ),
    ImportColumn('cargo', 'Cargo', help: '', example: 'Gerente', aliases: ['funcao']),
    ImportColumn(
      'codigo_unidade',
      'Código da unidade',
      help: 'Vazio = todas as unidades do cliente.',
      example: 'U01',
      aliases: ['unidade'],
    ),
    ImportColumn(
      'administrador',
      'Administrador do cliente',
      help: 'sim/não. Gerencia os outros contatos pelo app.',
      example: 'não',
      aliases: ['admin'],
    ),
    ImportColumn(
      'pode_abrir_chamados',
      'Pode abrir chamados',
      help: 'sim/não (padrão: sim).',
      example: 'sim',
      aliases: ['abre_chamados'],
    ),
  ];

  static const _pathToColumn = {
    'name': 'nome',
    'email': 'email',
    'phone': 'celular',
    'jobTitle': 'cargo',
    'customerSiteId': 'codigo_unidade',
  };

  @override
  Future<List<ImportRowPlan>> plan(Session session, List<ImportRecord> records, {Transaction? transaction}) async {
    final customerCodes = {for (final r in records) ?r['codigo_cliente']}.toList();
    final customers = {
      for (final c in await _findIn(
        customerCodes,
        (chunk) => Customer.db.find(session, where: (t) => t.code.inSet(chunk), transaction: transaction),
      ))
        c.code!: c,
    };
    final ids = [for (final c in customers.values) c.id.uuid];
    Set<UuidValue> uuids(Set<String> chunk) => {for (final id in chunk) UuidValue.withValidation(id)};
    final sites = <String, CustomerSite>{
      for (final s in await _findIn(
        ids,
        (chunk) => CustomerSite.db.find(
          session,
          where: (t) => t.customerId.inSet(uuids(chunk)) & t.code.notEquals(null),
          transaction: transaction,
        ),
      ))
        '${s.customerId.uuid}|${s.code}': s,
    };
    final contactsByEmail = <String, CustomerContact>{};
    final contactsByPhone = <String, CustomerContact>{};
    for (final c in await _findIn(
      ids,
      (chunk) =>
          CustomerContact.db.find(session, where: (t) => t.customerId.inSet(uuids(chunk)), transaction: transaction),
    )) {
      if (c.email != null) contactsByEmail.putIfAbsent('${c.customerId.uuid}|${c.email}', () => c);
      if (c.phoneE164 != null) contactsByPhone.putIfAbsent('${c.customerId.uuid}|${c.phoneE164}', () => c);
    }

    final seen = <String>{};
    final plans = <ImportRowPlan>[];
    for (final r in records) {
      final customerCode = r['codigo_cliente'];
      final email = r['email']?.trim().toLowerCase();
      final phone = r['celular'] == null ? null : Phones.toE164(r['celular']!);
      final key = '${customerCode ?? '?'} / ${email ?? r['celular'] ?? r['nome'] ?? '?'}';
      ImportRowPlan error(List<String> m) =>
          ImportRowPlan(rowNumber: r.rowNumber, key: key, action: ImportAction.error, messages: m);
      if (customerCode == null) {
        plans.add(error(['Código do cliente: obrigatório.']));
        continue;
      }
      final customer = customers[customerCode];
      if (customer == null) {
        plans.add(error(['Cliente "$customerCode" não encontrado. Importe os clientes antes.']));
        continue;
      }
      if (!customer.isActive) {
        plans.add(error(['Cliente "$customerCode" está inativo.']));
        continue;
      }
      final identity = email ?? phone;
      if (identity != null && !seen.add('$customerCode|$identity')) {
        plans.add(error(['Contato repetido na planilha (mesmo cliente e mesmo e-mail/celular).']));
        continue;
      }
      try {
        UuidValue? siteId;
        final siteCode = r['codigo_unidade'];
        if (siteCode != null) {
          final site = sites['${customer.id.uuid}|$siteCode'];
          if (site == null) {
            plans.add(error(['Unidade "$siteCode" não encontrada no cliente "$customerCode".']));
            continue;
          }
          siteId = site.id;
        }
        final isAdmin = ImportCells.boolean(r['administrador']);
        final canOpen = ImportCells.boolean(r['pode_abrir_chamados']);
        final current =
            (email == null ? null : contactsByEmail['${customer.id.uuid}|$email']) ??
            (phone == null ? null : contactsByPhone['${customer.id.uuid}|$phone']);
        final base = current == null ? null : ContactDraft.fromContact(current);
        final draft = ContactDraft(
          customerSiteId: siteId ?? base?.customerSiteId,
          name: r['nome'] ?? base?.name ?? '',
          email: r['email'] ?? base?.email,
          phone: r['celular'] ?? base?.phone,
          jobTitle: r['cargo'] ?? base?.jobTitle,
          contactRole: isAdmin == null
              ? (base?.contactRole ?? ContactRole.customer_contact)
              : (isAdmin ? ContactRole.customer_admin : ContactRole.customer_contact),
          canOpenRequests: canOpen ?? base?.canOpenRequests ?? true,
          preferredChannel: base?.preferredChannel,
        );
        final v = ContactRules.validate(draft);
        if (v.errors.isNotEmpty) {
          plans.add(error(_messages(v.errors, columns, _pathToColumn)));
          continue;
        }
        if (current == null) {
          plans.add(
            ImportRowPlan(
              rowNumber: r.rowNumber,
              key: key,
              action: ImportAction.create,
              payload: _ContactCreate(customer.id, v.value!),
            ),
          );
          continue;
        }
        final changed = _changed(base!.toFields(), v.value!.toFields());
        if (changed.isEmpty) {
          plans.add(ImportRowPlan(rowNumber: r.rowNumber, key: key, action: ImportAction.unchanged));
        } else if (current.source == RecordSource.erp && changed.keys.any(contactMasterFields.contains)) {
          plans.add(error(['Contato vem do ERP: nome, e-mail, celular e cargo só mudam por lá.']));
        } else {
          plans.add(
            ImportRowPlan(
              rowNumber: r.rowNumber,
              key: key,
              action: ImportAction.update,
              payload: _ContactUpdate(current, changed),
            ),
          );
        }
      } on FormatException catch (e) {
        plans.add(error(['Administrador / pode abrir chamados: ${e.message}.']));
      }
    }
    return plans;
  }

  @override
  Future<({int created, int updated})> apply(
    Session session,
    Transaction transaction,
    List<ImportRowPlan> plan, {
    required UuidValue runId,
  }) async {
    final now = DateTime.now().toUtc();
    final tenantId = session.context.tenantId!;
    final toInsert = [
      for (final p in plan)
        if (p.payload case _ContactCreate(:final customerId, :final draft))
          CustomerContact(
            tenantId: tenantId,
            customerId: customerId,
            customerSiteId: draft.customerSiteId,
            name: draft.name,
            email: draft.email,
            phoneE164: draft.phone,
            jobTitle: draft.jobTitle,
            contactRole: draft.contactRole,
            status: ContactStatus.active,
            origin: ContactOrigin.file_import,
            canOpenRequests: draft.canOpenRequests,
            preferredChannel: draft.preferredChannel,
            isActive: true,
            source: RecordSource.local,
            createdAt: now,
            updatedAt: now,
            version: 1,
          ),
    ];
    var created = 0;
    for (var i = 0; i < toInsert.length; i += 500) {
      final rows = await CustomerContact.db.insert(
        session,
        toInsert.sublist(i, i + 500 > toInsert.length ? toInsert.length : i + 500),
        transaction: transaction,
      );
      for (final c in rows) {
        await _event(
          session,
          transaction,
          type: 'customer_contact.created',
          aggregateType: 'customer_contact',
          id: c.id,
          version: c.version,
          runId: runId,
          payload: {'contact_id': c.id.uuid, 'customer_id': c.customerId.uuid, 'status': c.status.name},
        );
      }
      created += rows.length;
    }
    var updated = 0;
    for (final p in plan) {
      if (p.payload case _ContactUpdate(:final current, :final changed)) {
        final rows = await CustomerContact.db.updateWhere(
          session,
          columnValues: (t) => [for (final e in changed.entries) CustomerContactService.columnValue(t, e.key, e.value)],
          where: (t) => t.id.equals(current.id) & t.version.equals(current.version),
          transaction: transaction,
        );
        if (rows.isEmpty) throw StateError('Contato ${current.name} mudou durante a importação.');
        await _event(
          session,
          transaction,
          type: 'customer_contact.updated',
          aggregateType: 'customer_contact',
          id: current.id,
          version: rows.single.version,
          runId: runId,
          payload: {
            'contact_id': current.id.uuid,
            'customer_id': current.customerId.uuid,
            'status': current.status.name,
            'changed_fields': changed.keys.toList()..sort(),
          },
        );
        updated++;
      }
    }
    return (created: created, updated: updated);
  }
}
