// Group members: 222078921 Rethabile Mosoeu; 225094388 Zenande Silinga; 224008297 Ubabalwe Ndima; 225024254 Phiwe Bunu; 223086483 Buko Manqana.
// ============================================================
// TPG226C GROUP PROJECT - SMARTMART RETAIL INVENTORY APP
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/product.dart';
import '../services/product_file_service.dart';

class ProductFormScreen extends StatefulWidget {
  final ProductFileService fileService;
  final Product? product;

  const ProductFormScreen({
    super.key,
    required this.fileService,
    this.product,
  });

  bool get isEditing => product != null;

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _codeController;
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _quantityController;

  final List<String> _categories = const [
    'Beverages',
    'Groceries',
    'Bakery',
    'Dairy',
    'Household',
    'Personal Care',
    'Electronics',
    'Other',
  ];

  final List<String> _statuses = const [
    'Available',
    'Low Stock',
    'Out of Stock',
  ];

  String _category = 'Beverages';
  String _status = 'Available';
  String _image = Product.imageForCategory('Beverages');
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final product = widget.product;

    _codeController = TextEditingController(text: product?.productCode ?? '');
    _nameController = TextEditingController(text: product?.productName ?? '');
    _priceController = TextEditingController(
      text: product == null ? '' : product.price.toStringAsFixed(2),
    );
    _quantityController = TextEditingController(
      text: product == null ? '' : product.quantity.toString(),
    );

    if (product != null) {
      _category = _categories.contains(product.category)
          ? product.category
          : 'Other';
      _status = _statuses.contains(product.status)
          ? product.status
          : 'Available';
      _image = Product.imageForCategory(_category);
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      final products = await widget.fileService.loadProducts();
      final code = _codeController.text.trim();

      final duplicate = products.any(
        (product) =>
            product.productCode.toLowerCase() == code.toLowerCase() &&
            product.productCode.toLowerCase() !=
                (widget.product?.productCode.toLowerCase() ?? ''),
      );

      if (duplicate) {
        if (mounted) {
          setState(() => _saving = false);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Product code already exists.')),
          );
        }
        return;
      }

      final newProduct = Product(
        productCode: code,
        productName: _nameController.text.trim(),
        category: _category,
        price: double.parse(_priceController.text.trim().replaceAll(',', '.')),
        quantity: int.parse(_quantityController.text.trim()),
        image: Product.imageForCategory(_category),
        status: _status,
      );

      if (widget.isEditing) {
        final index = products.indexWhere(
          (product) => product.productCode == widget.product!.productCode,
        );
        if (index != -1) {
          products[index] = newProduct;
        }
      } else {
        products.add(newProduct);
      }

      await widget.fileService.saveProducts(products);

      if (!mounted) return;
      Navigator.pop(context, newProduct);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not save product: $e')),
      );
    }
  }

  String? _validateCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product code is required.';
    }
    if (value.contains(',')) return 'Product code may not contain commas.';
    return null;
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Product name is required.';
    }
    // products.txt is comma-separated, so a comma would corrupt the record.
    if (value.contains(',')) return 'Product name may not contain commas.';
    return null;
  }

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) return 'Unit price is required.';
    final price = double.tryParse(value.trim().replaceAll(',', '.'));
    if (price == null) return 'Enter a valid number.';
    if (price <= 0) return 'Price must be greater than zero.';
    return null;
  }

  String? _validateQuantity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Quantity is required.';
    }
    final quantity = int.tryParse(value.trim());
    if (quantity == null) return 'Enter a whole number.';
    if (quantity < 0) return 'Quantity may not be negative.';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 48,
                      backgroundImage: AssetImage(_image),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.isEditing
                          ? 'Update the product details'
                          : 'Enter the new product details',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Product image is chosen from the category',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _codeController,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Product Code',
                hintText: 'e.g. PRD006',
                prefixIcon: Icon(Icons.qr_code_2),
                border: OutlineInputBorder(),
              ),
              validator: _validateCode,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Product Name',
                prefixIcon: Icon(Icons.inventory_2_outlined),
                border: OutlineInputBorder(),
              ),
              validator: _validateName,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _category,
              decoration: const InputDecoration(
                labelText: 'Category',
                prefixIcon: Icon(Icons.category_outlined),
                border: OutlineInputBorder(),
              ),
              items: _categories
                  .map((category) => DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _category = value;
                    _image = Product.imageForCategory(value);
                  });
                }
              },
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _priceController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              decoration: const InputDecoration(
                labelText: 'Unit Price',
                prefixText: 'R ',
                prefixIcon: Icon(Icons.payments_outlined),
                border: OutlineInputBorder(),
              ),
              validator: _validatePrice,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _quantityController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Quantity in Stock',
                prefixIcon: Icon(Icons.numbers),
                border: OutlineInputBorder(),
              ),
              validator: _validateQuantity,
            ),
            const SizedBox(height: 14),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(
                labelText: 'Status',
                prefixIcon: Icon(Icons.flag_outlined),
                border: OutlineInputBorder(),
              ),
              items: _statuses
                  .map((status) => DropdownMenuItem(
                        value: status,
                        child: Text(status),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _saving ? null : () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _saving ? null : _saveProduct,
                    icon: _saving
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.save),
                    label: Text(_saving ? 'Saving...' : 'Save'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
