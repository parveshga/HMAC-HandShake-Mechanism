// import 'dart:convert';
// import 'dart:io';

// class HandshakeService {
//   final String secretKey = "Gemicates";

//   Future<bool> performHandshake(Socket socket) async {
//     try {
//       // Send the secret key to the server for verification
//       socket.write(secretKey);
//       await socket.flush();

//       // Wait for the server to respond with a confirmation
//       final serverResponse = await socket.first;

//       // Decode the server's response
//       final responseString = utf8.decode(serverResponse);

// ignore_for_file: avoid_print

//       if (responseString == 'HANDSHAKE_SUCCESS') {
//         print("Handshake successful.");
//         return true;
//       } else {
//         print("Handshake failed.");
//         return false;
//       }
//     } catch (e) {
//       print("Handshake error: $e");
//       return false;
//     }
//   }
// }
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:crypto/crypto.dart';

class HandshakeService {
  final String secretKey = "Gemicates";
  bool challengeSent = false;

  String signChallenge(String challenge) {
    final hmac = Hmac(sha256, utf8.encode(secretKey));
    final digest = hmac.convert(utf8.encode(challenge));
    print('digest $digest');
    return digest.toString();
  }

  Future<bool> performHandshake(Socket socket) async {
    final Completer<bool> completer = Completer<bool>();
    String receivedData = '';

    socket.listen((data) {
      receivedData += utf8.decode(data).trim();
      print("Received data: $receivedData");

      if (!challengeSent && !receivedData.contains('HANDSHAKE_SUCCESS')) {
        final challenge = receivedData;
        print("Received challenge: $challenge");

        final signedChallenge = signChallenge(challenge);

        socket.write(signedChallenge);
        socket.flush();

        challengeSent = true;
        receivedData = '';
      } else if (challengeSent && receivedData.contains('HANDSHAKE_SUCCESS')) {
        print("Handshake successful.");
        completer.complete(true);
        socket.destroy();
      } else {
        print('HandShake Failed ');
      }
    });
    return completer.future.then((value) {
      return value;
    }).catchError((e) {
      print("Handshake error: $e");
      return false;
    });
  }
}
