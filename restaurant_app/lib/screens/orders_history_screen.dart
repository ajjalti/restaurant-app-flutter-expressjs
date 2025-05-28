import 'package:flutter/material.dart';
import 'package:restaurant_app/models/order.dart';
import 'package:restaurant_app/services/order_service.dart';

class OrdersHistoryScreen extends StatefulWidget {
  OrdersHistoryScreen({super.key});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  late List<dynamic> orders = [];
  final OrderService _orderService = OrderService();
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  void loadOrders() async {
    final data = await _orderService.getAllOrders();
    print(data);
    setState(() {
      orders = data;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: 25),
          Text(
            "Orders history list",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    print(order);
                    return ListTile(
                      leading: Icon(Icons.receipt_long_outlined),
                      title: Text("Commande n°${order?.id}"),
                      subtitle: Text(
                        "Date : ${order?.date.toLocal().toString().split(' ')[0]}",
                      ),
                      trailing: Text(
                        "${order?.totalAmount.toStringAsFixed(2)} DH",
                      ),
                      onTap: () {
                        // Action quand on clique sur une commande
                        // Navigator.push(...) pour aller à une page de détails
                      },
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
