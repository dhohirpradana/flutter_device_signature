import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<String> generateDeviceSignature() async {
    final deviceInfo = DeviceInfoPlugin();
    final info = await deviceInfo.androidInfo;

    final raw =
        '${info.id}-${info.model}-${info.manufacturer}-${info.fingerprint}';
    return sha256.convert(utf8.encode(raw)).toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: generateDeviceSignature(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const MaterialApp(
            home: Scaffold(body: Center(child: CircularProgressIndicator())),
          );
        } else if (snapshot.hasError) {
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Error: ${snapshot.error}')),
            ),
          );
        } else {
          final signature = snapshot.data;
          return MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Device Signature: $signature')),
            ),
          );
        }
      },
    );
  }
}
