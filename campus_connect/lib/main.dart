import 'package:flutter/material.dart';

void main() {
  runApp(const CampusConnectApp());
}

class CampusConnectApp extends StatelessWidget {
  const CampusConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Connect'),
      ),
      body: Container(
        alignment: Alignment.center,color: Colors.blueGrey,
        child: Text('Campus Connect', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 28),
      ),
      )
    );
  }
}