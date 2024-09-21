// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:ip_port_finder/service/handshake_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _ipController = TextEditingController();
  final TextEditingController _portController = TextEditingController();
  final List<String> _foundIPs = [];
  bool _isScanning = false;

  Future<void> _scan(String baseIp, int port) async {
    setState(() {
      _isScanning = true;
      _foundIPs.clear();
    });

    List<String> octets = baseIp.split('.');
    if (octets.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid IP address format. Please use x.x.x.x"),
        ),
      );
      setState(() {
        _isScanning = false;
      });
      return;
    }

    List<Future<void>> futures = [];

    for (int i = 1; i <= 254; i++) {
      String currentIp = '${octets[0]}.${octets[1]}.${octets[2]}.$i';
      if (currentIp != baseIp) {
        futures.add(_tryConnect(currentIp, port));
      }
    }

    await Future.wait(futures);
    setState(() {
      _isScanning = false;
    });
  }

  Future<void> _tryConnect(String ip, int port) async {
    try {
      Socket socket =
          await Socket.connect(ip, port, timeout: const Duration(seconds: 1));
      print("Connected to $ip:$port");

      HandshakeService handshakeService = HandshakeService();
      bool success = await handshakeService.performHandshake(socket);

      if (success) {
        setState(() {
          _foundIPs.add(ip);
        });
      }

      socket.close();
    } catch (e) {
      //print("Could not connect to $ip:$port");
    }
  }

  void _startScan() {
    String ip = _ipController.text;
    String port = _portController.text;

    if (ip.isEmpty || port.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter both IP and Port")),
      );
      return;
    }

    _scan(ip, int.parse(port));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IP Scanner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _ipController,
              decoration: const InputDecoration(
                  labelText: 'Enter Base IP Address (e.g., 192.168.1.1)'),
            ),
            TextField(
              controller: _portController,
              decoration: const InputDecoration(labelText: 'Enter Port Number'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _startScan,
              child: const Text('Scan'),
            ),
            const SizedBox(height: 20),
            if (_isScanning)
              const CircularProgressIndicator()
            else
              Expanded(
                child: _foundIPs.isNotEmpty
                    ? ListView.builder(
                        itemCount: _foundIPs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title:
                                Text('Open port found in ${_foundIPs[index]}'),
                          );
                        },
                      )
                    : const Center(child: Text("No open ports available.")),
              ),
          ],
        ),
      ),
    );
  }
}
