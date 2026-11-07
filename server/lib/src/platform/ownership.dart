/// Mapa de propriedade de tabelas por módulo (docs/02 §3.4). Cada módulo é
/// dono das suas tabelas; leituras de outros módulos só por interface pública
/// ou views publicadas. Um teste de arquitetura confere que nenhuma tabela
/// tem dois donos e que toda tabela de tenant tem dono.
final class ModuleOwnership {
  const ModuleOwnership({required this.module, required this.owns, this.reads = const {}});

  final String module;
  final Set<String> owns;

  /// Views publicadas por outros módulos que este pode ler.
  final Set<String> reads;
}
