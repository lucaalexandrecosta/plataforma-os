import 'package:decimal/decimal.dart';
import 'package:plataforma_os_depreciation/plataforma_os_depreciation.dart';
import 'package:serverpod/serverpod.dart';

import '../../generated/protocol.dart';
import '../../identity_access/identity_access.dart';
import '../../platform/db/sql_values.dart';
import '../../platform/errors/api_errors.dart';

/// Ficha patrimonial e depreciação gerencial. O cálculo é sempre do motor
/// `packages/depreciation` (o mesmo que o backoffice usa para recalcular na
/// tela); o banco guarda os parâmetros e as competências fechadas.
///
/// Só o livro gerencial: o fiscal continua no ERP. Para o motor parar no fim
/// da vida útil gerencial, o livro fiscal entra "já depreciado" (residual =
/// base).
abstract final class Depreciation {
  static const readPermission = 'depreciation.read';
  static const managePermission = 'depreciation.manage';
  static const closePermission = 'depreciation.close';

  static const _methods = {
    'straight_line': ManagerialMethod.straightLine,
    'sum_of_years_digits': ManagerialMethod.sumOfYearsDigits,
    'double_declining_balance': ManagerialMethod.doubleDecliningBalance,
    'units_of_production': ManagerialMethod.unitsOfProduction,
  };
  static const _startRules = {
    'pro_rata_days': StartRule.proRataDays,
    'full_month': StartRule.fullMonth,
    'next_month': StartRule.nextMonth,
  };

  static const _profileSelect =
      'SELECT p.asset_id, p.method, p.annual_rate, p.start_date, p.start_rule, p.depreciable_cost, '
      '       coalesce(p.depreciable_cost, a.acquisition_cost), p.residual_value, p.total_capacity, '
      '       p.monthly_production, p.notes, p.version '
      '  FROM app.asset_depreciation_profiles p '
      '  JOIN app.assets a ON a.tenant_id = p.tenant_id AND a.id = p.asset_id ';

  // ------------------------------------------------------------------ ficha

  static Future<DepreciationProfile?> profile(Session session, UuidValue assetId) async {
    await Authorization.require(session, readPermission);
    await _requireAsset(session, assetId);
    return _findProfile(session, assetId);
  }

  /// Cria ou altera a ficha. [expectedVersion] nulo = criar (falha se já
  /// existir); preenchido = alterar com concorrência otimista.
  static Future<DepreciationProfile> saveProfile(
    Session session,
    UuidValue assetId,
    int? expectedVersion,
    DepreciationProfileInput input,
  ) async {
    await Authorization.require(session, managePermission);
    final acquisitionCost = await _requireAsset(session, assetId);
    final params = _validate(session, input, acquisitionCost);
    if (expectedVersion == null) {
      try {
        await session.db.unsafeExecute(
          'INSERT INTO app.asset_depreciation_profiles (tenant_id, asset_id, method, annual_rate, start_date, '
          '       start_rule, depreciable_cost, residual_value, total_capacity, monthly_production, notes) '
          'VALUES (app.current_tenant_id(), @assetId::uuid, @method, @rate, @startDate::date, @startRule, '
          '        @cost, @residual, @capacity, @production, @notes)',
          parameters: QueryParameters.named({'assetId': assetId.uuid, ...params}),
        );
      } on DatabaseQueryException catch (e) {
        if (isUniqueViolation(e)) {
          throw ApiErrors.conflict(session, 'PROFILE_EXISTS', 'Este bem já tem ficha; recarregue e edite a atual.');
        }
        rethrow;
      }
    } else {
      final current = await _findProfile(session, assetId);
      if (current == null) throw ApiErrors.notFound(session, 'Este bem ainda não tem ficha.');
      final changed = await session.db.unsafeExecute(
        'UPDATE app.asset_depreciation_profiles SET method = @method, annual_rate = @rate, '
        '       start_date = @startDate::date, start_rule = @startRule, depreciable_cost = @cost, '
        '       residual_value = @residual, total_capacity = @capacity, monthly_production = @production, '
        '       notes = @notes '
        ' WHERE asset_id = @assetId::uuid AND version = @version',
        parameters: QueryParameters.named({'assetId': assetId.uuid, 'version': expectedVersion, ...params}),
      );
      if (changed == 0) throw ApiErrors.versionMismatch(session, current.version);
    }
    return (await _findProfile(session, assetId))!;
  }

  /// Memória de cálculo do bem, mês a mês.
  static Future<AssetDepreciation> schedule(Session session, UuidValue assetId) async {
    await Authorization.require(session, readPermission);
    await _requireAsset(session, assetId);
    final rows = await session.db.unsafeQuery(
      '$_calcSelect WHERE p.asset_id = @assetId::uuid',
      parameters: QueryParameters.named({'assetId': assetId.uuid}),
    );
    if (rows.isEmpty) throw ApiErrors.notFound(session, 'Este bem ainda não tem ficha.');
    final calc = _CalcRow(rows.first);
    if (calc.cost == null) {
      throw ApiErrors.businessRule(session, 'COST_REQUIRED', 'Informe o valor de aquisição do bem ou a base da ficha.');
    }
    return AssetDepreciation(
      profile: (await _findProfile(session, assetId))!,
      cost: calc.cost!,
      residualValue: calc.residual,
      lines: [
        for (final m in calc.months())
          DepreciationLine(
            year: m.period.year,
            month: m.period.month,
            amount: _cents(m.managerialAmount),
            accumulated: _cents(m.managerialTotal),
            netBookValue: _cents(m.managerialNetBookValue),
            rule: m.managerialRule,
            disposed: m.disposedThisMonth,
          ),
      ],
    );
  }

  // ------------------------------------------------------------------ posição

  /// Posição da competência por bem, com totais por centro de custo, filial e
  /// geral. Competência fechada é lida do fechamento; aberta é calculada.
  static Future<DepreciationPosition> position(
    Session session, {
    required int year,
    required int month,
    UuidValue? branchId,
    UuidValue? costCenterId,
  }) async {
    await Authorization.require(session, readPermission);
    _checkPeriod(session, year, month);
    final closing = await _closedClosing(session, year, month);
    final all = closing == null
        ? await _computeItems(session, Period(year, month))
        : await _storedItems(session, closing);
    final items = [
      for (final i in all)
        if ((branchId == null || i.branchId == branchId) && (costCenterId == null || i.costCenterId == costCenterId)) i,
    ];
    return DepreciationPosition(
      year: year,
      month: month,
      closed: closing != null,
      items: items,
      byCostCenter: _group(items, (i) => (i.costCenterId, i.costCenterName)),
      byBranch: _group(items, (i) => (i.branchId, i.branchName)),
      total: _sum(null, null, items),
    );
  }

  // ------------------------------------------------------------------ fechamento

  static Future<List<DepreciationClosing>> closings(Session session) async {
    await Authorization.require(session, readPermission);
    final rows = await session.db.unsafeQuery(
      '$_closingSelect ORDER BY c.period_year DESC, c.period_month DESC, c.closed_at DESC',
    );
    return [for (final r in rows) _mapClosing(r)];
  }

  /// Fecha a competência: grava a linha do mês de cada bem com ficha. As
  /// competências fecham em ordem e nunca no futuro.
  static Future<DepreciationClosing> close(Session session, {required int year, required int month}) async {
    await Authorization.require(session, closePermission);
    _checkPeriod(session, year, month);
    final period = Period(year, month);
    final now = DateTime.now().toUtc();
    if (period.key > Period(now.year, now.month).key) {
      throw ApiErrors.businessRule(session, 'PERIOD_IN_FUTURE', 'Não dá para fechar uma competência futura.');
    }
    if (await _closedClosing(session, year, month) != null) {
      throw ApiErrors.businessRule(session, 'ALREADY_CLOSED', 'Esta competência já está fechada.');
    }
    final last = await _lastClosed(session);
    if (last != null && Period(last.year, last.month).key != period.key - 1) {
      final expected = Period.fromKey(Period(last.year, last.month).key + 1);
      throw ApiErrors.businessRule(
        session,
        'PERIOD_OUT_OF_ORDER',
        'Feche as competências em ordem: a próxima é ${expected.month.toString().padLeft(2, '0')}/${expected.year}.',
      );
    }
    final items = await _computeItems(session, period);
    final id = const Uuid().v7obj();
    await session.db.transaction((tx) async {
      await session.db.unsafeExecute(
        'INSERT INTO app.depreciation_closings (id, tenant_id, period_year, period_month, asset_count, total_amount, '
        '                                       closed_by) '
        'VALUES (@id::uuid, app.current_tenant_id(), @year, @month, @count, @total, app.current_user_id())',
        parameters: QueryParameters.named({
          'id': id.uuid,
          'year': year,
          'month': month,
          'count': items.length,
          'total': items.fold<int>(0, (s, i) => s + i.monthlyAmount),
        }),
        transaction: tx,
      );
      if (items.isEmpty) return;
      await session.db.unsafeExecute(
        'INSERT INTO app.depreciation_entries (tenant_id, closing_id, asset_id, branch_id, cost_center_id, '
        '       depreciable_cost, monthly_amount, accumulated, net_book_value) '
        'SELECT app.current_tenant_id(), @id::uuid, x.a, x.b, x.c, x.cost, x.amount, x.acc, x.nbv '
        '  FROM unnest(@assets::uuid[], @branches::uuid[], @centers::uuid[], @costs::bigint[], @amounts::bigint[], '
        '              @accs::bigint[], @nbvs::bigint[]) AS x(a, b, c, cost, amount, acc, nbv)',
        parameters: QueryParameters.named({
          'id': id.uuid,
          'assets': [for (final i in items) i.assetId.uuid],
          'branches': [for (final i in items) i.branchId?.uuid],
          'centers': [for (final i in items) i.costCenterId?.uuid],
          'costs': [for (final i in items) i.cost],
          'amounts': [for (final i in items) i.monthlyAmount],
          'accs': [for (final i in items) i.accumulated],
          'nbvs': [for (final i in items) i.netBookValue],
        }),
        transaction: tx,
      );
    });
    return (await _closingById(session, id))!;
  }

  /// Reabre a última competência fechada (o fechamento fica no histórico como
  /// `reopened`).
  static Future<DepreciationClosing> reopen(
    Session session, {
    required int year,
    required int month,
    required String reason,
  }) async {
    await Authorization.require(session, closePermission);
    final text = cleanText(reason);
    if (text == null) throw ApiErrors.fieldError(session, 'reason', 'REQUIRED', 'Informe o motivo da reabertura.');
    final closing = await _closedClosing(session, year, month);
    if (closing == null) throw ApiErrors.businessRule(session, 'NOT_CLOSED', 'Esta competência não está fechada.');
    final last = (await _lastClosed(session))!;
    if (last.id != closing.id) {
      throw ApiErrors.businessRule(session, 'NOT_LATEST_CLOSING', 'Só a última competência fechada pode ser reaberta.');
    }
    await session.db.unsafeExecute(
      "UPDATE app.depreciation_closings SET status = 'reopened', reopened_at = now(), "
      '       reopened_by = app.current_user_id(), reopen_reason = @reason '
      ' WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': closing.id.uuid, 'reason': text}),
    );
    return (await _closingById(session, closing.id))!;
  }

  // ------------------------------------------------------------------ internos

  static const _calcSelect =
      'SELECT a.id, coalesce(a.asset_tag, a.serial_number), pr.name, a.branch_id, '
      '       coalesce(b.trade_name, b.legal_name), a.cost_center_id, cc.code || \' - \' || cc.name, '
      '       coalesce(p.depreciable_cost, a.acquisition_cost), p.residual_value, p.method, p.annual_rate, '
      '       p.start_date, p.start_rule, p.total_capacity, p.monthly_production, a.retired_at '
      '  FROM app.asset_depreciation_profiles p '
      '  JOIN app.assets a ON a.tenant_id = p.tenant_id AND a.id = p.asset_id '
      '  JOIN app.products pr ON pr.tenant_id = a.tenant_id AND pr.id = a.product_id '
      '  LEFT JOIN app.branches b ON b.tenant_id = a.tenant_id AND b.id = a.branch_id '
      '  LEFT JOIN app.cost_centers cc ON cc.tenant_id = a.tenant_id AND cc.id = a.cost_center_id ';

  static const _closingSelect =
      'SELECT c.id, c.period_year, c.period_month, c.status, c.asset_count, c.total_amount, c.closed_at, '
      '       u.full_name, c.reopened_at, c.reopen_reason '
      '  FROM app.depreciation_closings c LEFT JOIN app.users u ON u.id = c.closed_by ';

  static Future<List<DepreciationPositionItem>> _computeItems(Session session, Period period) async {
    final rows = await session.db.unsafeQuery('$_calcSelect ORDER BY 2, a.id');
    final items = <DepreciationPositionItem>[];
    for (final r in rows) {
      final calc = _CalcRow(r);
      if (calc.cost == null) continue;
      final months = calc.months();
      if (months.isEmpty || period.key < months.first.period.key) continue;
      final last = months.last;
      if (last.disposedThisMonth && period.key > last.period.key) continue;
      final line = period.key > last.period.key ? null : months.firstWhere((m) => m.period == period);
      items.add(
        DepreciationPositionItem(
          assetId: calc.assetId,
          assetLabel: calc.label,
          productName: calc.productName,
          branchId: calc.branchId,
          branchName: calc.branchName,
          costCenterId: calc.costCenterId,
          costCenterName: calc.costCenterName,
          cost: calc.cost!,
          monthlyAmount: line == null ? 0 : _cents(line.managerialAmount),
          accumulated: _cents((line ?? last).managerialTotal),
          netBookValue: _cents((line ?? last).managerialNetBookValue),
        ),
      );
    }
    return items;
  }

  static Future<List<DepreciationPositionItem>> _storedItems(Session session, DepreciationClosing closing) async {
    final rows = await session.db.unsafeQuery(
      'SELECT e.asset_id, coalesce(a.asset_tag, a.serial_number), pr.name, e.branch_id, '
      '       coalesce(b.trade_name, b.legal_name), e.cost_center_id, cc.code || \' - \' || cc.name, '
      '       e.depreciable_cost, e.monthly_amount, e.accumulated, e.net_book_value '
      '  FROM app.depreciation_entries e '
      '  JOIN app.assets a ON a.tenant_id = e.tenant_id AND a.id = e.asset_id '
      '  JOIN app.products pr ON pr.tenant_id = a.tenant_id AND pr.id = a.product_id '
      '  LEFT JOIN app.branches b ON b.tenant_id = e.tenant_id AND b.id = e.branch_id '
      '  LEFT JOIN app.cost_centers cc ON cc.tenant_id = e.tenant_id AND cc.id = e.cost_center_id '
      ' WHERE e.closing_id = @id::uuid ORDER BY 2, e.asset_id',
      parameters: QueryParameters.named({'id': closing.id.uuid}),
    );
    return [
      for (final r in rows)
        DepreciationPositionItem(
          assetId: sqlUuid(r[0]),
          assetLabel: r[1] as String,
          productName: r[2] as String,
          branchId: sqlUuidOrNull(r[3]),
          branchName: r[4] as String?,
          costCenterId: sqlUuidOrNull(r[5]),
          costCenterName: r[6] as String?,
          cost: r[7] as int,
          monthlyAmount: r[8] as int,
          accumulated: r[9] as int,
          netBookValue: r[10] as int,
        ),
    ];
  }

  static List<DepreciationGroupTotal> _group(
    List<DepreciationPositionItem> items,
    (UuidValue?, String?) Function(DepreciationPositionItem) keyOf,
  ) {
    final groups = <UuidValue?, List<DepreciationPositionItem>>{};
    final names = <UuidValue?, String?>{};
    for (final i in items) {
      final (id, name) = keyOf(i);
      groups.putIfAbsent(id, () => []).add(i);
      names[id] = name;
    }
    final totals = [for (final e in groups.entries) _sum(e.key, names[e.key], e.value)];
    totals.sort((a, b) => (a.name ?? '\u{10FFFF}').compareTo(b.name ?? '\u{10FFFF}'));
    return totals;
  }

  static DepreciationGroupTotal _sum(UuidValue? id, String? name, List<DepreciationPositionItem> items) =>
      DepreciationGroupTotal(
        id: id,
        name: name,
        assetCount: items.length,
        cost: items.fold(0, (s, i) => s + i.cost),
        monthlyAmount: items.fold(0, (s, i) => s + i.monthlyAmount),
        accumulated: items.fold(0, (s, i) => s + i.accumulated),
        netBookValue: items.fold(0, (s, i) => s + i.netBookValue),
      );

  /// Valor de aquisição do bem (pode ser nulo); `NOT_FOUND` se não existir.
  static Future<int?> _requireAsset(Session session, UuidValue assetId) async {
    final rows = await session.db.unsafeQuery(
      'SELECT acquisition_cost FROM app.assets WHERE id = @id::uuid',
      parameters: QueryParameters.named({'id': assetId.uuid}),
    );
    if (rows.isEmpty) throw ApiErrors.notFound(session, 'Bem não encontrado.');
    return rows.first[0] as int?;
  }

  static Map<String, Object?> _validate(Session session, DepreciationProfileInput input, int? acquisitionCost) {
    final method = input.method;
    final startRule = cleanText(input.startRule) ?? 'pro_rata_days';
    final rate = _scaled(input.annualRate, 4);
    final capacity = cleanText(input.totalCapacity) == null ? null : _scaled(input.totalCapacity, 3);
    final production = cleanText(input.monthlyProduction) == null ? null : _scaled(input.monthlyProduction, 3);
    final cost = input.depreciableCost ?? acquisitionCost;
    final residual = input.residualValue ?? 0;
    final units = method == 'units_of_production';
    final errors = [
      if (!_methods.containsKey(method)) FieldError(path: 'method', code: 'INVALID', message: 'Método inválido.'),
      if (!_startRules.containsKey(startRule))
        FieldError(path: 'startRule', code: 'INVALID', message: 'Regra do primeiro mês inválida.'),
      if (rate == null || rate < 0 || rate > 1000000)
        FieldError(path: 'annualRate', code: 'INVALID', message: 'Taxa anual de 0 a 100%, até 4 casas.')
      else if (!units && rate == 0)
        FieldError(path: 'annualRate', code: 'REQUIRED', message: 'Informe a taxa anual.'),
      if (units && (capacity == null || capacity <= 0))
        FieldError(path: 'totalCapacity', code: 'REQUIRED', message: 'Informe a capacidade total (até 3 casas).'),
      if (units && (production == null || production < 0))
        FieldError(path: 'monthlyProduction', code: 'REQUIRED', message: 'Informe a produção mensal (até 3 casas).'),
      if (cost == null)
        FieldError(
          path: 'depreciableCost',
          code: 'REQUIRED',
          message: 'O bem não tem valor de aquisição: informe a base da depreciação.',
        )
      else if (cost < 0)
        FieldError(path: 'depreciableCost', code: 'INVALID', message: 'A base não pode ser negativa.'),
      if (residual < 0 || (cost != null && residual > cost))
        FieldError(path: 'residualValue', code: 'INVALID', message: 'O residual vai de zero até a base.'),
    ];
    if (errors.isNotEmpty) throw ApiErrors.validation(session, errors);
    return {
      'method': method,
      'rate': rate,
      'startDate': sqlDateParam(input.startDate),
      'startRule': startRule,
      'cost': input.depreciableCost,
      'residual': residual,
      'capacity': units ? capacity : null,
      'production': units ? production : null,
      'notes': cleanText(input.notes),
    };
  }

  /// "12,5" com [places] casas → inteiro × 10^places; `null` se inválido ou
  /// com casas demais.
  static int? _scaled(String? text, int places) {
    final value = Decimal.tryParse((text ?? '').trim().replaceAll(',', '.'));
    if (value == null) return null;
    final scaled = value * Decimal.ten.pow(places).toDecimal();
    return scaled.isInteger ? scaled.toBigInt().toInt() : null;
  }

  static String _unscaled(int value, int places) =>
      (Decimal.fromInt(value) / Decimal.ten.pow(places).toDecimal()).toDecimal().toString();

  static int _cents(Decimal reais) => (reais * Decimal.fromInt(100)).toBigInt().toInt();

  static void _checkPeriod(Session session, int year, int month) {
    if (month < 1 || month > 12 || year < 1990 || year > 2200) {
      throw ApiErrors.fieldError(session, 'month', 'INVALID', 'Competência inválida.');
    }
  }

  static Future<DepreciationProfile?> _findProfile(Session session, UuidValue assetId) async {
    final rows = await session.db.unsafeQuery(
      '$_profileSelect WHERE p.asset_id = @id::uuid',
      parameters: QueryParameters.named({'id': assetId.uuid}),
    );
    if (rows.isEmpty) return null;
    final r = rows.first;
    return DepreciationProfile(
      assetId: sqlUuid(r[0]),
      method: r[1] as String,
      annualRate: _unscaled(r[2] as int, 4),
      startDate: sqlDateOrNull(r[3])!,
      startRule: r[4] as String,
      depreciableCost: r[5] as int?,
      effectiveCost: r[6] as int?,
      residualValue: r[7] as int,
      totalCapacity: r[8] == null ? null : _unscaled(r[8] as int, 3),
      monthlyProduction: r[9] == null ? null : _unscaled(r[9] as int, 3),
      notes: r[10] as String?,
      version: r[11] as int,
    );
  }

  static Future<DepreciationClosing?> _closedClosing(Session session, int year, int month) async {
    final rows = await session.db.unsafeQuery(
      "$_closingSelect WHERE c.status = 'closed' AND c.period_year = @year AND c.period_month = @month",
      parameters: QueryParameters.named({'year': year, 'month': month}),
    );
    return rows.isEmpty ? null : _mapClosing(rows.first);
  }

  static Future<DepreciationClosing?> _lastClosed(Session session) async {
    final rows = await session.db.unsafeQuery(
      "$_closingSelect WHERE c.status = 'closed' ORDER BY c.period_year DESC, c.period_month DESC LIMIT 1",
    );
    return rows.isEmpty ? null : _mapClosing(rows.first);
  }

  static Future<DepreciationClosing?> _closingById(Session session, UuidValue id) async {
    final rows = await session.db.unsafeQuery(
      '$_closingSelect WHERE c.id = @id::uuid',
      parameters: QueryParameters.named({'id': id.uuid}),
    );
    return rows.isEmpty ? null : _mapClosing(rows.first);
  }

  static DepreciationClosing _mapClosing(List<Object?> r) => DepreciationClosing(
    id: sqlUuid(r[0]),
    year: r[1] as int,
    month: r[2] as int,
    status: r[3] as String,
    assetCount: r[4] as int,
    totalAmount: r[5] as int,
    closedAt: r[6] as DateTime,
    closedByName: r[7] as String?,
    reopenedAt: r[8] as DateTime?,
    reopenReason: r[9] as String?,
  );
}

/// Linha de `_calcSelect` com os parâmetros prontos para o motor.
final class _CalcRow {
  _CalcRow(List<Object?> r)
    : assetId = sqlUuid(r[0]),
      label = r[1] as String,
      productName = r[2] as String,
      branchId = sqlUuidOrNull(r[3]),
      branchName = r[4] as String?,
      costCenterId = sqlUuidOrNull(r[5]),
      costCenterName = r[6] as String?,
      cost = r[7] as int?,
      residual = r[8] as int,
      method = r[9] as String,
      rate = r[10] as int,
      start = sqlDateOrNull(r[11])!,
      startRule = r[12] as String,
      capacity = r[13] as int?,
      production = r[14] as int?,
      retiredAt = r[15] as DateTime?;

  final UuidValue assetId;
  final String label;
  final String productName;
  final UuidValue? branchId;
  final String? branchName;
  final UuidValue? costCenterId;
  final String? costCenterName;
  final int? cost;
  final int residual;
  final String method;
  final int rate;
  final DateTime start;
  final String startRule;
  final int? capacity;
  final int? production;
  final DateTime? retiredAt;

  static Decimal _fromScaled(int value, int places) =>
      (Decimal.fromInt(value) / Decimal.ten.pow(places).toDecimal()).toDecimal(scaleOnInfinitePrecision: places);

  /// Linhas do livro gerencial (o fiscal entra já depreciado).
  List<DepreciationMonth> months() {
    final base = _fromScaled(cost!, 2);
    final retired = retiredAt?.toUtc();
    return calculateDepreciation(
      DepreciableAsset(
        acquisitionCost: base,
        start: CalendarDate(start.year, start.month, start.day),
        disposal: retired == null ? null : CalendarDate(retired.year, retired.month, retired.day),
        startRule: Depreciation._startRules[startRule]!,
        fiscalResidual: base,
        managerialMethod: Depreciation._methods[method]!,
        managerialRate: _fromScaled(rate, 4),
        managerialResidual: _fromScaled(residual, 2),
        totalCapacity: capacity == null ? null : _fromScaled(capacity!, 3),
        monthlyProduction: production == null ? null : _fromScaled(production!, 3),
      ),
    ).months;
  }
}
