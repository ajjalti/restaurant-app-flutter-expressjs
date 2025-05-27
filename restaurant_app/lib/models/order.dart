import 'product.dart'; // Assure-toi d'importer le modèle Product

class Order {
  final String id;
  final List<Product> products;
  final double totalAmount;
  final DateTime date;
  final String status;

  Order({
    required this.id,
    required this.products,
    required this.totalAmount,
    required this.date,
    required this.status,
  });

  // Convertir un JSON en Order
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      products:
          (json['products'] as List)
              .map((item) => Product.fromJson(item as Map<String, dynamic>))
              .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
      status: json['status'] as String,
    );
  }
}
