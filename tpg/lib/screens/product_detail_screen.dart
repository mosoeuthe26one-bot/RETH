// Group members: 222078921 Rethabile Mosoeu; 225094388 Zenande Silinga; 224008297 Ubabalwe Ndima; 225024254 Phiwe Bunu; 223086483 Buko Manqana.
// ============================================================
// TPG226C GROUP PROJECT - SMARTMART RETAIL INVENTORY APP
// ============================================================

import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_file_service.dart';
import 'product_form_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final ProductFileService fileService;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.fileService,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late Product _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  Future<void> _editProduct() async {
    // The form returns the saved Product, so this screen shows the new
    // values even if the product code was changed.
    final updated = await Navigator.push<Product>(
      context,
      MaterialPageRoute(
        builder: (_) => ProductFormScreen(
          fileService: widget.fileService,
          product: _product,
        ),
      ),
    );

    if (!mounted) return;
    if (updated != null) {
      setState(() => _product = updated);
    }
  }

  Future<void> _deleteProduct() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete product?'),
        content: Text('Remove ${_product.productName} from the inventory?'),
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

    if (confirmed != true) return;

    try {
      final products = await widget.fileService.loadProducts();
      products.removeWhere((p) => p.productCode == _product.productCode);
      await widget.fileService.saveProducts(products);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not delete product: $e')),
      );
      return;
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  Color _statusColor() {
    switch (_product.status) {
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
      appBar: AppBar(title: const Text('Product Details')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              clipBehavior: Clip.antiAlias,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 65,
                      backgroundImage: AssetImage(_product.image),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _product.productName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _statusColor().withAlpha(31),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _product.status,
                        style: TextStyle(
                          color: _statusColor(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _detailRow('Product Code', _product.productCode),
                    const Divider(),
                    _detailRow('Category', _product.category),
                    const Divider(),
                    _detailRow('Unit Price', 'R${_product.price.toStringAsFixed(2)}'),
                    const Divider(),
                    _detailRow('Quantity in Stock', '${_product.quantity}'),
                    const Divider(),
                    _detailRow('Status', _product.status),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _deleteProduct,
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Delete'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _editProduct,
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 16),
        Flexible(child: Text(value, textAlign: TextAlign.right)),
      ],
    );
  }
}
