import 'package:restaurant_app/enums/order-status-type.dart';

class OrderStatus {
  final String id;
  final OrderStatusType status;

  OrderStatus({required this.id, this.status = OrderStatusType.pending});

  Map<String, dynamic> toJson() {
    return {'id': id, 'status': status};
  }
}
