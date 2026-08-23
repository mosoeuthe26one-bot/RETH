import 'package:flutter/material.dart';

void main() {
  runApp(MyApp()); // 1. entry point → mounts the root widget
}

class MyApp extends StatelessWidget {
  // 2. build() describes the UI
  Widget build(BuildContext context) {
    return MaterialApp(
      // 3. theming, routing, root config
      home: Scaffold(
        // 4. screen skeleton
        appBar: AppBar(title: Text('My App'), backgroundColor: Colors.blue),
        body: Center(child: Text('Hello')),
      ),
    );
  }
}
