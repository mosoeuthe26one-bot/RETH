// Group members: 222078921 Rethabile Mosoeu; 225094388 Zenande Silinga; 224008297 Ubabalwe Ndima; 225024254 Phiwe Bunu; 223086483 Buko Manqana.
// ============================================================
// TPG226C GROUP PROJECT - SMARTMART RETAIL INVENTORY APP
// ============================================================

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_file_service.dart';
import 'product_detail_screen.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  final ProductFileService fileService;

  const ProductListScreen({super.key, required this.fileService});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final products = await widget.fileService.loadProducts();
      if (!mounted) return;
      setState(() {
        _products = products;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _addProduct() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormScreen(fileService: widget.fileService),
      ),
    );
    await _loadProducts();
  }

  Future<void> _openProduct(Product product) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailScreen(
          product: product,
          fileService: widget.fileService,
        ),
      ),
    );
    await _loadProducts();
  }

  Future<void> _deleteProduct(Product product) async {
    final confirmed = await _showDeleteDialog(product);
    if (!confirmed) return;

    try {
      _products.remove(product);
      await widget.fileService.saveProducts(_products);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete product: $e')),
      );
      await _loadProducts();
      return;
    }

    if (!mounted) return;
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${product.productName} deleted.')),
    );
  }

  void _showFileInfo() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Data file'),
        content: Text(
          'Products are stored in:\n\n${widget.fileService.filePath}\n\n'
          'Format: ProductCode,ProductName,Category,Price,Quantity,Status',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<bool> _showDeleteDialog(Product product) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text(
          'Are you sure you want to delete ${product.productName}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Available':
        return Colors.green;
      case 'Low Stock':
        return Colors.orange;
      case 'Out of Stock':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SmartMart Inventory'),
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: _showFileInfo,
            tooltip: 'Data file',
            icon: const Icon(Icons.info_outline),
          ),
          IconButton(
            onPressed: _loadProducts,
            tooltip: 'Refresh',
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addProduct,
        icon: const Icon(Icons.add),
        label: const Text('Add Product'),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48),
              const SizedBox(height: 12),
              Text(_error!, textAlign: TextAlign.center),
              const SizedBox(height: 12),
              FilledButton(onPressed: _loadProducts, child: const Text('Retry')),
            ],
          ),
        ),
      );
    }

    if (_products.isEmpty) {
      return const Center(
        child: Text('No products yet. Tap Add Product to begin.'),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 100),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          final statusColor = _statusColor(product.status);

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 6,
              ),
              leading: CircleAvatar(
                radius: 28,
                backgroundImage: AssetImage(product.image),
              ),
              title: Text(
                product.productName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${product.productCode}  •  R${product.price.toStringAsFixed(2)}\n'
                'Qty: ${product.quantity}',
              ),
              isThreeLine: true,
              trailing: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 9,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withAlpha(31),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  product.status,
                  style: TextStyle(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
              onTap: () => _openProduct(product),
              onLongPress: () => _deleteProduct(product),
            ),
          );
        },
      ),
    );
  }
}
