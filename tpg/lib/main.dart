// Group members: 222078921 Rethabile Mosoeu; 225094388 Zenande Silinga; 224008297 Ubabalwe Ndima; 225024254 Phiwe Bunu; 223086483 Buko Manqana.
// ============================================================
// TPG226C GROUP PROJECT - SMARTMART RETAIL INVENTORY APP
// ============================================================

import 'package:flutter/material.dart';

import 'screens/product_list_screen.dart';
import 'services/product_file_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SmartMartApp());
}

class SmartMartApp extends StatelessWidget {
  const SmartMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SmartMart Inventory',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7FB),
      ),
      home: const AppLoader(),
    );
  }
}

class AppLoader extends StatefulWidget {
  const AppLoader({super.key});

  @override
  State<AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<AppLoader> {
  final ProductFileService _fileService = ProductFileService();
  late Future<void> _startup;

  @override
  void initState() {
    super.initState();
    _startup = _prepareApp();
  }

  Future<void> _prepareApp() async {
    await _fileService.init();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _startup,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Unable to prepare the inventory file.\n\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        return ProductListScreen(fileService: _fileService);
      },
    );
  }
}
