/// Cliente gerado da plataforma-os. Os apps só falam com o servidor por aqui
/// (docs/02 §6.1: proibido HTTP direto para os endpoints).
///
/// Reexporta o `serverpod_client` (UuidValue, Uuid, ClientAuthKeyProvider,
/// exceções do transporte) para os apps dependerem de um pacote só.
library;

export 'package:serverpod_client/serverpod_client.dart';

export 'src/protocol/client.dart';
export 'src/protocol/protocol.dart';
