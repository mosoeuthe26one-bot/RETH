// Group members: 222078921 Rethabile Mosoeu; 225094388 Zenande Silinga; 224008297 Ubabalwe Ndima; 225024254 Phiwe Bunu; 223086483 Buko Manqana.
// ============================================================
// TPG226C GROUP PROJECT - SMARTMART RETAIL INVENTORY APP
// ============================================================

import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/product.dart';
import 'sample_data_service.dart';

class ProductFileService {
  File? _file;

  // Shown on the Product List screen (info button) so you can show the
  // lecturer exactly where products.txt lives.
  String get filePath => _file?.path ?? 'products.txt';

  // products.txt lives in the app's local documents folder, which is
  // writable on Android, iOS and desktop.
  Future<File> _getFile() async {
    if (_file != null) return _file!;

    Directory dir;
    try {
      dir = await getApplicationDocumentsDirectory();
    } catch (_) {
      dir = Directory.current; // fallback so the app never crashes
    }

    _file = File('${dir.path}${Platform.pathSeparator}products.txt');
    return _file!;
  }

  // Called once at startup: if products.txt does not exist, create it and
  // fill it with the five sample products. If it exists it is left alone,
  // so changes (including deleting everything) are preserved.
  Future<void> init() async {
    final file = await _getFile();
    if (!await file.exists()) {
      await file.create(recursive: true);
      await saveProducts(SampleDataService.sampleProducts);
    }
  }

  Future<List<Product>> loadProducts() async {
    try {
      final file = await _getFile();

      if (!await file.exists()) {
        await init();
      }

      final lines = await file.readAsLines();
      final products = <Product>[];

      for (final line in lines) {
        if (line.trim().isEmpty) continue;
        try {
          products.add(Product.fromCsv(line));
        } catch (_) {
          // Ignore malformed records so one bad line does not stop the app.
        }
      }

      return products;
    } catch (e) {
      throw Exception('Could not load products.txt: $e');
    }
  }

  // Rewrites the whole file with the current list of products.
  Future<void> saveProducts(List<Product> products) async {
    try {
      final file = await _getFile();
      final content = products.map((product) => product.toCsv()).join('\n');
      await file.writeAsString(
        content.isEmpty ? '' : '$content\n',
        flush: true,
      );
    } catch (e) {
      throw Exception('Could not save products.txt: $e');
    }
  }
}
