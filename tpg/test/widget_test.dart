// Group members: 222078921 Rethabile Mosoeu; 225094388 Zenande Silinga; 224008297 Ubabalwe Ndima; 225024254 Phiwe Bunu; 223086483 Buko Manqana.
// Simple unit tests for the Product model (no device or file access needed).
// Run with:  flutter test

import 'package:flutter_test/flutter_test.dart';
import 'package:smartmart_inventory/models/product.dart';

void main() {
  test('Product.fromCsv reads a products.txt record', () {
    final p = Product.fromCsv('PRD003,Fresh Milk 2L,Dairy,32.99,4,Low Stock');

    expect(p.productCode, 'PRD003');
    expect(p.productName, 'Fresh Milk 2L');
    expect(p.category, 'Dairy');
    expect(p.price, 32.99);
    expect(p.quantity, 4);
    expect(p.status, 'Low Stock');
    expect(p.image, 'assets/images/dairy.png');
  });

  test('Product.toCsv writes the required record format', () {
    final p = Product(
      productCode: 'PRD002',
      productName: 'White Bread',
      category: 'Bakery',
      price: 18.5,
      quantity: 12,
      image: Product.imageForCategory('Bakery'),
      status: 'Available',
    );

    expect(p.toCsv(), 'PRD002,White Bread,Bakery,18.50,12,Available');
  });

  test('Product.fromCsv rejects a malformed record', () {
    expect(() => Product.fromCsv('PRD009,Broken'), throwsFormatException);
  });
}
