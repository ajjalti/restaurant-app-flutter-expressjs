import 'package:flutter/material.dart';
import 'package:restaurant_app/enums/order-status-type.dart';
import 'package:restaurant_app/services/order_service.dart';
import 'package:restaurant_app/services/user_service.dart';

class ClientOrdersScreen extends StatefulWidget {
  const ClientOrdersScreen({super.key});

  @override
  State<ClientOrdersScreen> createState() => _ClientOrdersScreenState();
}

class _ClientOrdersScreenState extends State<ClientOrdersScreen> {
  late List<dynamic> orders = [];
  final OrderService _orderService = OrderService();
  final UserService _userService = UserService();

  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  void loadOrders() async {
    final clientId = _userService.getId();
    final data = await _orderService.findAllByClientId(clientId);
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
          const SizedBox(height: 25),
          const Text(
            "My Orders",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Expanded(
                child: ListView.builder(
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final products = order.products;

                    return Card(
                      margin: const EdgeInsets.all(10),
                      elevation: 3,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              leading: const Icon(Icons.receipt_long_outlined),
                              title: Text("n°${order.id}"),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date: ${order.date.toLocal().toString().split(' ')[0]}",
                                  style: TextStyle(fontSize: 14),
                                ),
                                Text(
                                  "${order.status}",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color:
                                        order.status == "Confirmed"
                                            ? Colors.green
                                            : Colors.blue,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Products :",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            ...products.map<Widget>((productItem) {
                              final product = productItem['product'];
                              final quantity = productItem['quantity'];
                              if (product == null)
                                return SizedBox(); // sécurité si null
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 2.0,
                                  horizontal: 8.0,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${product['name']}"),
                                    Text("x$quantity"),
                                    Text("${product['price']} DH"),
                                  ],
                                ),
                              );
                            }).toList(),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "Total :${order.totalAmount.toStringAsFixed(2)} DH",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
