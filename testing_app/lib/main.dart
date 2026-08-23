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
        appBar: AppBar(
          title: Text('My App'),
          backgroundColor: const Color.fromARGB(255, 51, 204, 140),
        ),
        body: Container(
          // Container: wraps child widget with styling (padding, margin, color, decoration)
          // Usage: Container(child: Widget, color: Color, padding: EdgeInsets, etc)
          child: Center(
            // Center: centers its child widget both horizontally and vertically
            // Usage: Center(child: Widget)
            child: Column(
              // Column: arranges children vertically
              // Usage: Column(children: [Widget1, Widget2, ...], mainAxisAlignment: alignment)
              mainAxisAlignment: MainAxisAlignment
                  .center, // 1. Alignment of children along the main axis
              children: [
                Text(
                  'Diploma in IT Hello',
                  textAlign:
                      TextAlign.center, // 1. Alignment inside constraints
                  maxLines: 1, // 2. Maximum line boundary
                  overflow: TextOverflow.ellipsis, // 3. Handling clipping
                  style: TextStyle(
                    // 4. Visual properties object
                    fontSize: 24,
                    color: Colors.indigo,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfilePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Profile')),
      body: Center(child: Text('Profile Page')),
    );
  }
}
