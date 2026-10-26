import 'package:flutter/material.dart';
void main() => runApp(const ProductApp());

class Product {
	const Product({
		required this.code,
		required this.name,
		required this.category,
		required this.price,
		required this.quantity,
		required this.status,
	});

	final String code;
	final String name;
	final String category;
	final double price;
	final int quantity;
	final String status;
}

Color statusColor(String status) {
	switch (status) {
		case 'Available':
			return Colors.green;
		case 'Low Stock':
			return Colors.orange;
		default:
			return Colors.red;
	}
}

class ProductApp extends StatelessWidget {
	const ProductApp({super.key});

	@override
	Widget build(BuildContext context) {
		return MaterialApp(
			title: 'Product Inventory',
			theme: ThemeData(
				colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
				useMaterial3: true,
			),
			home: const ProductPage(),
		);
	}
}

class ProductPage extends StatefulWidget {
	const ProductPage({super.key});

	@override
	State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
	final _codeController = TextEditingController();
	final _nameController = TextEditingController();
	final _priceController = TextEditingController();
	final _quantityController = TextEditingController();
	final List<Product> _products = [];
	final List<String> _categories = ['General', 'Electronics', 'Clothing'];
	final List<String> _statuses = ['Available', 'Low Stock', 'Out of Stock'];
	String _category = 'General';
	String _status = 'Available';

	@override
	void dispose() {
		_codeController.dispose();
		_nameController.dispose();
		_priceController.dispose();
		_quantityController.dispose();
		super.dispose();
	}

	void _showMessage(String text) {
		ScaffoldMessenger.of(context).showSnackBar(
			SnackBar(content: Text(text)),
		);
	}

	void _addProduct() {
		final code = _codeController.text.trim();
		final name = _nameController.text.trim();
		final price = double.tryParse(_priceController.text.trim());
		final quantity = int.tryParse(_quantityController.text.trim());

		if (code.isEmpty || name.isEmpty) {
			_showMessage('Product code and name are required.');
			return;
		}
		if (price == null || !price.isFinite || price <= 0) {
			_showMessage('Price must be a number greater than zero.');
			return;
		}
		if (quantity == null || quantity < 0) {
			_showMessage('Quantity must be a whole number, zero or more.');
			return;
		}

		setState(() {
			_products.add(
				Product(
					code: code,
					name: name,
					category: _category,
					price: price,
					quantity: quantity,
					status: _status,
				),
			);
			_codeController.clear();
			_nameController.clear();
			_priceController.clear();
			_quantityController.clear();
			_category = _categories.first;
			_status = _statuses.first;
		});
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			appBar: AppBar(title: const Text('Product Inventory')),
			body: ListView(
				padding: const EdgeInsets.all(16),
				children: [
					TextField(
						controller: _codeController,
						decoration: const InputDecoration(labelText: 'Product code'),
					),
					TextField(
						controller: _nameController,
						decoration: const InputDecoration(labelText: 'Product name'),
					),
					TextField(
						controller: _priceController,
						keyboardType: const TextInputType.numberWithOptions(decimal: true),
						decoration: const InputDecoration(labelText: 'Price'),
					),
					TextField(
						controller: _quantityController,
						keyboardType: TextInputType.number,
						decoration: const InputDecoration(labelText: 'Quantity'),
					),
					DropdownButtonFormField<String>(
						value: _category,
						decoration: const InputDecoration(labelText: 'Category'),
						items: _categories
								.map((value) => DropdownMenuItem(value: value, child: Text(value)))
								.toList(),
						onChanged: (value) {
							if (value != null) setState(() => _category = value);
						},
					),
					DropdownButtonFormField<String>(
						value: _status,
						decoration: const InputDecoration(labelText: 'Status'),
						items: _statuses
								.map((value) => DropdownMenuItem(value: value, child: Text(value)))
								.toList(),
						onChanged: (value) {
							if (value != null) setState(() => _status = value);
						},
					),
					const SizedBox(height: 16),
					FilledButton(onPressed: _addProduct, child: const Text('Add product')),
					const SizedBox(height: 16),
					if (_products.isEmpty)
						const Center(child: Text('No products added yet.'))
					else
						..._products.map(
							(product) => Card(
								child: ListTile(
									title: Text(product.name),
									subtitle: Text(
										'${product.code} • ${product.category} • '
										'\$${product.price.toStringAsFixed(2)} • '
										'Qty: ${product.quantity}',
									),
									trailing: Text(
										product.status,
										style: TextStyle(
											color: statusColor(product.status),
											fontWeight: FontWeight.bold,
										),
									),
								),
							),
						),
				],
			),
		);
	}
}
