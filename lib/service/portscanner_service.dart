import 'dart:io';
import 'handshake_service.dart';
import 'dart:async';

class PortScannerService {
  final HandshakeService _handshakeService = HandshakeService();

  Future<void> scanSubnet(String subnet, int port) async {
    final futures = <Future>[];

    for (int i = 1; i <= 254; i++) {
      final ip = "$subnet.$i";
      futures.add(scanIp(ip, port));
    }

    await Future.any(futures);
  }

  Future<void> scanIp(String ip, int port) async {
    try {
      print('Scanning IP: $ip');
      final socket =
          await Socket.connect(ip, port, timeout: const Duration(seconds: 2));

      print('Connected to $ip:$port');

      bool handshakeSuccess = await _handshakeService.performHandshake(socket);

      if (handshakeSuccess) {
        print('Connected and verified: $ip');
        socket.destroy();
        return;
      } else {
        print('Handshake failed for $ip');
        socket.destroy();
      }
    } catch (e) {
      //print('Failed to connect to $ip:$port');
      return;
    }
  }
}
