// Group members: 222078921 Rethabile Mosoeu; 225094388 Zenande Silinga; 224008297 Ubabalwe Ndima; 225024254 Phiwe Bunu; 223086483 Buko Manqana.
// ============================================================
// TPG226C GROUP PROJECT - SMARTMART RETAIL INVENTORY APP
// ============================================================

import '../models/product.dart';

// Holds the five sample products required by the brief.
// They are written to products.txt the first time the app runs.
class SampleDataService {
  static final List<Product> sampleProducts = [
    Product(
      productCode: 'PRD001',
      productName: 'Coca-Cola 2L',
      category: 'Beverages',
      price: 24.99,
      quantity: 35,
      image: Product.imageForCategory('Beverages'),
      status: 'Available',
    ),
    Product(
      productCode: 'PRD002',
      productName: 'White Bread',
      category: 'Bakery',
      price: 18.50,
      quantity: 12,
      image: Product.imageForCategory('Bakery'),
      status: 'Available',
    ),
    Product(
      productCode: 'PRD003',
      productName: 'Fresh Milk 2L',
      category: 'Dairy',
      price: 32.99,
      quantity: 4,
      image: Product.imageForCategory('Dairy'),
      status: 'Low Stock',
    ),
    Product(
      productCode: 'PRD004',
      productName: 'Washing Powder 2kg',
      category: 'Household',
      price: 79.99,
      quantity: 0,
      image: Product.imageForCategory('Household'),
      status: 'Out of Stock',
    ),
    Product(
      productCode: 'PRD005',
      productName: 'USB Keyboard',
      category: 'Electronics',
      price: 199.99,
      quantity: 8,
      image: Product.imageForCategory('Electronics'),
      status: 'Available',
    ),
  ];
}
