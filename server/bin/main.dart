import 'package:plataforma_os_server/server.dart';

/// Entrada do executável. Argumentos do Serverpod: `--mode`
/// (development | staging | production | test), `--role`
/// (serverless | monolith | maintenance) e `--apply-migrations`.
Future<void> main(List<String> args) => run(args);
