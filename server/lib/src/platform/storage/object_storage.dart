import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';

/// Object storage S3-compatível (docs/09 §1; RustFS no ambiente local): o
/// binário dos anexos nunca passa pelo servidor na ida. O aparelho e o
/// navegador enviam e baixam por URLs pré-assinadas (docs/06 §6.10).
///
/// Configuração (config/passwords.yaml em dev/teste, cofre em produção):
/// `s3Endpoint` (ex.: http://localhost:9000), `s3Bucket`, `s3AccessKey`,
/// `s3SecretKey`, `s3Region` (padrão us-east-1) e, se os aparelhos enxergam
/// o storage por outro endereço, `s3PublicEndpoint`. Sem `s3Endpoint` o
/// registro dos anexos funciona, mas envio e download respondem
/// STORAGE_UNAVAILABLE.
abstract final class Storage {
  static ObjectStorage? _instance;

  static ObjectStorage? get instance => _instance;

  static void configure(Serverpod pod) {
    final endpoint = pod.getPassword('s3Endpoint');
    if (endpoint == null || endpoint.isEmpty) {
      _instance = null;
      return;
    }
    String required(String key) =>
        pod.getPassword(key) ?? (throw StateError('Segredo "$key" ausente para o object storage.'));
    _instance = S3ObjectStorage(
      endpoint: Uri.parse(endpoint),
      publicEndpoint: switch (pod.getPassword('s3PublicEndpoint')) {
        final p? when p.isNotEmpty => Uri.parse(p),
        _ => null,
      },
      bucket: required('s3Bucket'),
      accessKey: required('s3AccessKey'),
      secretKey: required('s3SecretKey'),
      region: pod.getPassword('s3Region') ?? 'us-east-1',
      createBucket: pod.runMode == ServerpodRunMode.development || pod.runMode == ServerpodRunMode.test,
    );
  }

  /// Troca o storage (testes).
  static void use(ObjectStorage? storage) => _instance = storage;
}

abstract interface class ObjectStorage {
  /// URL para o cliente enviar o objeto com PUT, com o `Content-Type` fixado.
  Future<Uri> uploadUrl(String key, String contentType, {Duration expires});

  /// URL para o cliente baixar o objeto com GET.
  Future<Uri> downloadUrl(String key, {Duration expires});

  /// Conteúdo do objeto, ou `null` se ele não existe.
  Future<Uint8List?> read(String key);
}

/// Cliente mínimo de S3: só URLs pré-assinadas (SigV4, estilo path).
class S3ObjectStorage implements ObjectStorage {
  S3ObjectStorage({
    required this.endpoint,
    required this.bucket,
    required this.accessKey,
    required this.secretKey,
    this.region = 'us-east-1',
    this.publicEndpoint,
    this.createBucket = false,
    http.Client? client,
    DateTime Function()? clock,
  }) : _client = client ?? http.Client(),
       _clock = clock ?? DateTime.now;

  final Uri endpoint;
  final Uri? publicEndpoint;
  final String bucket;
  final String accessKey;
  final String secretKey;
  final String region;

  /// Cria o bucket no primeiro uso (dev e teste; em produção ele vem da infra).
  final bool createBucket;
  final http.Client _client;
  final DateTime Function() _clock;
  Future<void>? _bucketReady;

  @override
  Future<Uri> uploadUrl(String key, String contentType, {Duration expires = const Duration(minutes: 15)}) async {
    await _ensureBucket();
    return presign('PUT', key, expires: expires, contentType: contentType, base: publicEndpoint ?? endpoint);
  }

  @override
  Future<Uri> downloadUrl(String key, {Duration expires = const Duration(minutes: 15)}) async =>
      presign('GET', key, expires: expires, base: publicEndpoint ?? endpoint);

  @override
  Future<Uint8List?> read(String key) async {
    final response = await _client.get(presign('GET', key, expires: const Duration(minutes: 5)));
    if (response.statusCode == 404) return null;
    if (response.statusCode != 200) {
      throw StateError('Object storage respondeu ${response.statusCode} ao ler $key.');
    }
    return response.bodyBytes;
  }

  Future<void> _ensureBucket() {
    if (!createBucket) return Future.value();
    return _bucketReady ??= () async {
      final response = await _client.put(presign('PUT', null, expires: const Duration(minutes: 1)));
      // 409: já existe (BucketAlreadyOwnedByYou).
      if (response.statusCode != 200 && response.statusCode != 409) {
        _bucketReady = null;
        throw StateError('Object storage respondeu ${response.statusCode} ao criar o bucket.');
      }
    }();
  }

  /// URL pré-assinada (SigV4 por query string, payload não assinado). Com
  /// [contentType], o cabeçalho entra na assinatura e o cliente tem de mandar
  /// o mesmo. [key] nulo = o próprio bucket.
  Uri presign(String method, String? key, {required Duration expires, String? contentType, Uri? base}) {
    final target = base ?? endpoint;
    final now = _clock().toUtc();
    final date = _two(now.year, 4) + _two(now.month) + _two(now.day);
    final amzDate = '${date}T${_two(now.hour)}${_two(now.minute)}${_two(now.second)}Z';
    final scope = '$date/$region/s3/aws4_request';
    final basePath = target.path.replaceAll(RegExp(r'/+$'), '');
    final path = [basePath, bucket, ...?key?.split('/')].map(_encode).join('/').replaceAll('%2F', '/');
    final canonicalPath = path.startsWith('/') ? path : '/$path';
    final host = target.hasPort && !_defaultPort(target) ? '${target.host}:${target.port}' : target.host;
    final headers = <String, String>{'host': host, 'content-type': ?contentType};
    final signedHeaders = (headers.keys.toList()..sort()).join(';');
    final query = <String, String>{
      'X-Amz-Algorithm': 'AWS4-HMAC-SHA256',
      'X-Amz-Credential': '$accessKey/$scope',
      'X-Amz-Date': amzDate,
      'X-Amz-Expires': '${expires.inSeconds}',
      'X-Amz-SignedHeaders': signedHeaders,
    };
    String canonicalQuery(Map<String, String> q) =>
        (q.keys.toList()..sort()).map((k) => '${_encode(k)}=${_encode(q[k]!)}').join('&');
    final canonicalRequest = [
      method,
      canonicalPath,
      canonicalQuery(query),
      for (final k in headers.keys.toList()..sort()) '$k:${headers[k]!.trim()}',
      '',
      signedHeaders,
      'UNSIGNED-PAYLOAD',
    ].join('\n');
    final stringToSign = [
      'AWS4-HMAC-SHA256',
      amzDate,
      scope,
      sha256.convert(utf8.encode(canonicalRequest)).toString(),
    ].join('\n');
    List<int> hmac(List<int> key, String data) => Hmac(sha256, key).convert(utf8.encode(data)).bytes;
    final signingKey = hmac(hmac(hmac(hmac(utf8.encode('AWS4$secretKey'), date), region), 's3'), 'aws4_request');
    final signature = Hmac(sha256, signingKey).convert(utf8.encode(stringToSign)).toString();
    final origin = '${target.scheme}://$host';
    return Uri.parse('$origin$canonicalPath?${canonicalQuery({...query, 'X-Amz-Signature': signature})}');
  }

  static bool _defaultPort(Uri u) => (u.scheme == 'http' && u.port == 80) || (u.scheme == 'https' && u.port == 443);

  static String _two(int n, [int width = 2]) => n.toString().padLeft(width, '0');

  /// Codificação do SigV4: tudo menos A-Z a-z 0-9 - _ . ~ vira %XX.
  static String _encode(String s) {
    final out = StringBuffer();
    for (final b in utf8.encode(s)) {
      final c = String.fromCharCode(b);
      if (RegExp(r'[A-Za-z0-9\-_.~]').hasMatch(c)) {
        out.write(c);
      } else {
        out.write('%${b.toRadixString(16).toUpperCase().padLeft(2, '0')}');
      }
    }
    return out.toString();
  }
}
