import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/dtos/order_request_dto.dart';
import 'package:restaurant_app/models/product.dart';
import 'package:restaurant_app/screens/add_product_screen.dart';
import 'package:restaurant_app/screens/client_orders_screen.dart';
import 'package:restaurant_app/screens/home_screen.dart';
import 'package:restaurant_app/screens/orders_history_screen.dart';
import 'package:restaurant_app/screens/products_screen.dart';
import 'package:restaurant_app/screens/profile_screen.dart';
import 'package:restaurant_app/services/message_service.dart';
import 'package:restaurant_app/services/order_service.dart';
import 'package:restaurant_app/services/user_service.dart';
import 'package:restaurant_app/widgets/admin_navbar_widget.dart';
import 'package:restaurant_app/widgets/client_navbar_widget.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/services/cart_service.dart';

class LayoutScreen extends StatefulWidget {
  final MessageService messageService;
  final int? pageIndex;
  const LayoutScreen({super.key, required this.messageService, this.pageIndex});
  @override
  _LayoutScreenState createState() => _LayoutScreenState();
}

class _LayoutScreenState extends State<LayoutScreen> {
  late int _currentIndex;
  bool _isLoading = false;
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.pageIndex ?? 0;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    _currentIndex = (args is int) ? args : 0;
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirmation"),
          content: Text("Do you want to logout ?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.messageService.showSuccess("logout successful !");
                Navigator.pushReplacementNamed(context, '/');
              },
              child: Text("confirm"),
            ),
          ],
        );
      },
    );
  }

  void _saveOrder() async {
    setState(() {
      _isLoading = true;
    });
    final CartService _cartService = Provider.of<CartService>(
      context,
      listen: false,
    );
    final OrderService _orderService = OrderService();
    final UserService _userService = UserService();
    final total = _cartService.cartItems.fold(
      0.0,
      (sum, item) => sum + item.price * item.quantity,
    );
    final List<Map<String, dynamic>> formattedProducts =
        _cartService.cartItems.map((product) {
          return {"product": product.id, "quantity": product.quantity};
        }).toList();
    final OrderRequestDto _orderRequestDto = OrderRequestDto(
      id: null,
      user: _userService.getId(),
      products: formattedProducts,
      total: total,
    );
    final response = await _orderService.createOrder(_orderRequestDto);

    if (response != null) {
      setState(() {
        _isLoading = false;
      });
      _cartService.clearCart();
      widget.messageService.showSuccess("Your order was confirmed !");
    } else {
      setState(() {
        _isLoading = false;
      });
      widget.messageService.showError("Order confirmation failed !");
    }
  }

  @override
  Widget build(BuildContext context) {
    final userService = UserService();
    final isAdmin = userService.isAdmin;
    final screens =
        isAdmin
            ? [
              HomePage(),
              ProductsPage(messageService: widget.messageService),
              AddProduct(messageService: widget.messageService),
              OrdersHistoryScreen(),
              ProfileScreen(messageService: widget.messageService),
            ]
            : [
              // HomePage(),
              ProductsPage(messageService: widget.messageService),
              ClientOrdersScreen(),
              ProfileScreen(messageService: widget.messageService),
            ];
    return Scaffold(
      backgroundColor: CupertinoColors.systemYellow,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        actions: [IconButton(onPressed: _logout, icon: Icon(Icons.logout))],
        leading:
            isAdmin
                ? null
                : Builder(
                  builder:
                      (context) => Consumer<CartService>(
                        builder:
                            (context, cartService, child) => Stack(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.shopping_cart),
                                  onPressed: () {
                                    Scaffold.of(context).openDrawer();
                                  },
                                ),
                                Positioned(
                                  right: 6,
                                  top: 6,
                                  child: Container(
                                    padding: EdgeInsets.all(2),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    constraints: BoxConstraints(
                                      minWidth: 16,
                                      minHeight: 16,
                                    ),
                                    child: Text(
                                      '${cartService.itemCount}', // ✅ écoute les changements
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      ),
                ),
      ),
      drawer:
          isAdmin
              ? null
              : Drawer(
                child: Consumer<CartService>(
                  builder: (context, cartService, child) {
                    final total = cartService.cartItems.fold(
                      0.0,
                      (sum, item) => sum + item.price * item.quantity,
                    );

                    return Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.zero,
                            children: [
                              DrawerHeader(
                                decoration: BoxDecoration(color: Colors.yellow),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Your order',
                                      style: TextStyle(fontSize: 24),
                                    ),
                                    Stack(
                                      children: [
                                        Icon(Icons.shopping_cart),
                                        if (cartService.itemCount > 0)
                                          Positioned(
                                            right: 0,
                                            child: CircleAvatar(
                                              radius: 8,
                                              backgroundColor: Colors.red,
                                              child: Text(
                                                '${cartService.itemCount}',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              ...cartService.cartItems.map(
                                (item) => ListTile(
                                  title: Text(item.name),
                                  subtitle: Text("${item.price} DH"),
                                  leading: Text("1"),
                                  trailing: Text("${item.quantity} unity"),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.yellow.shade100,
                            border: Border(
                              top: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Total:",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "${total.toStringAsFixed(2)} DH",
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Scaffold.of(context).closeDrawer();
                                _saveOrder();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    "Confirm my order",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(Icons.check),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                      ],
                    );
                  },
                ),
              ),
      body: screens[_currentIndex],
      bottomNavigationBar:
          isAdmin
              ? AdminNavigationBar(
                selectedIndex: _currentIndex,
                onItemTapped: _onItemTapped,
              )
              : NavBar(currentIndex: _currentIndex, onTap: _onItemTapped),
    );
  }
}
