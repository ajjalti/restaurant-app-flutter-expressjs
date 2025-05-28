class Order {
  final String id;
  final dynamic user;
  final List<dynamic> products;
  final double totalAmount;
  final DateTime date;

  Order({
    required this.id,
    required this.user,
    required this.products,
    required this.totalAmount,
    required this.date,
  });

  // Convertir un JSON en Order
  factory Order.fromJson(Map<String, dynamic> json) {
    print(json);
    return Order(
      id: json['_id'] as String,
      user: json['user'],
      products: (json['products'] as List),
      totalAmount: (json['total'] as num).toDouble(),
      date: DateTime.parse(json['createdAt'] as String),
    );
  }
}
