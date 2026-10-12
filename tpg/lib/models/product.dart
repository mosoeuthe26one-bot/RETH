// Group members: 222078921 Rethabile Mosoeu; 225094388 Zenande Silinga; 224008297 Ubabalwe Ndima; 225024254 Phiwe Bunu; 223086483 Buko Manqana.
// ============================================================
// TPG226C GROUP PROJECT - SMARTMART RETAIL INVENTORY APP
// ============================================================

class Product {
  // Product data properties required by the project brief.
  String productCode;
  String productName;
  String category;
  double price;
  int quantity;
  String image; // asset path, e.g. assets/images/dairy.png
  String status;

  Product({
    required this.productCode,
    required this.productName,
    required this.category,
    required this.price,
    required this.quantity,
    required this.image,
    required this.status,
  });

  // Convert a Product object to the required CSV record:
  // ProductCode,ProductName,Category,Price,Quantity,Status
  String toCsv() {
    return '$productCode,$productName,$category,'
        '${price.toStringAsFixed(2)},$quantity,$status';
  }

  // Create a Product object from one CSV record.
  // The image is not stored in the file (the brief fixes the record format),
  // so it is looked up from the category.
  factory Product.fromCsv(String line) {
    final parts = line.split(',');

    if (parts.length != 6) {
      throw const FormatException('Invalid product record.');
    }

    final code = parts[0].trim();
    final name = parts[1].trim();
    final category = parts[2].trim();
    final price = double.parse(parts[3].trim());
    final quantity = int.parse(parts[4].trim());
    final status = parts[5].trim();

    if (code.isEmpty || name.isEmpty) {
      throw const FormatException('Invalid product record.');
    }

    return Product(
      productCode: code,
      productName: name,
      category: category,
      price: price,
      quantity: quantity,
      image: imageForCategory(category),
      status: status,
    );
  }

  // Every category has its own local image in assets/images/.
  static String imageForCategory(String category) {
    switch (category) {
      case 'Beverages':
        return 'assets/images/beverages.png';
      case 'Groceries':
        return 'assets/images/groceries.png';
      case 'Bakery':
        return 'assets/images/bakery.png';
      case 'Dairy':
        return 'assets/images/dairy.png';
      case 'Household':
        return 'assets/images/household.png';
      case 'Personal Care':
        return 'assets/images/personal_care.png';
      case 'Electronics':
        return 'assets/images/electronics.png';
      default:
        return 'assets/images/other.png';
    }
  }
}
