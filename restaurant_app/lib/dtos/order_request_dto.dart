class OrderRequestDto {
  final String? id;
  final String? user;
  final List products;
  final dynamic total;

  OrderRequestDto({
    required this.id,
    required this.user,
    required this.products,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {"user": user, "products": products, "total": total};
  }

  factory OrderRequestDto.fromJson(Map<String, dynamic> json) {
    return OrderRequestDto(
      id: json['_id'],
      user: json['user'],
      products: json['products'],
      total: json['total'],
    );
  }
}
