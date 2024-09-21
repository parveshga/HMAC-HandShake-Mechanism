import 'package:flutter/material.dart';
import 'package:ip_port_finder/screen/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomeScreen(),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:ip_port_finder/service/portscanner_service.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatefulWidget {
//   const MyApp({super.key});

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   final PortScannerService _portScannerService = PortScannerService();

//   @override
//   void initState() {
//     super.initState();
//     _startPortScanning();
//   }

//   Future<void> _startPortScanning() async {
//     String subnet = '192.168.30';
//     int port = 3333;

//     await _portScannerService.scanSubnet(subnet, port);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: Text('Port Scanner with Handshake'),
//         ),
//         body: const Center(
//           child: Text('s'),
//         ),
//       ),
//     );
//   }
// }
