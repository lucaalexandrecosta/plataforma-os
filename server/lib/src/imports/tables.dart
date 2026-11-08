import '../platform/ownership.dart';

/// `sync_runs` serve também à sincronização com o ERP (fase 2, módulo
/// integrations); até lá, só as importações por planilha a usam.
const importsOwnership = ModuleOwnership(module: 'imports', owns: {'sync_runs'});
