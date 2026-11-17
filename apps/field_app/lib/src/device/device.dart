import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../api/gateway.dart';
import 'qr_scanner_page.dart';

/// Posição do aparelho para o check-in.
typedef DevicePosition = ({double latitude, double longitude, double accuracyM});

/// Recursos do aparelho (GPS e câmera). Os testes trocam por um falso com
/// `deviceProvider.overrideWithValue`.
abstract interface class Device {
  /// Posição atual. Erros (sem permissão, GPS desligado, demora) vêm como
  /// [GatewayException] com a mensagem para a pessoa.
  Future<DevicePosition> position();

  /// Abre o leitor e devolve o conteúdo do QR, ou nulo se a pessoa voltar.
  Future<String?> scanQr(BuildContext context);
}

final deviceProvider = Provider<Device>((ref) => const PhoneDevice());

class PhoneDevice implements Device {
  const PhoneDevice();

  @override
  Future<DevicePosition> position() async {
    if (!await Geolocator.isLocationServiceEnabled()) {
      throw const GatewayException('A localização do aparelho está desligada. Ligue o GPS e tente de novo.');
    }
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      throw const GatewayException('Sem permissão de localização. Use o QR da etiqueta ou o check-in manual.');
    }
    try {
      final p = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, timeLimit: Duration(seconds: 20)),
      );
      return (latitude: p.latitude, longitude: p.longitude, accuracyM: p.accuracy);
    } on Exception {
      throw const GatewayException('Não consegui a posição do GPS. Tente de novo em local aberto.');
    }
  }

  @override
  Future<String?> scanQr(BuildContext context) =>
      Navigator.of(context).push<String>(MaterialPageRoute(builder: (_) => const QrScannerPage()));
}
