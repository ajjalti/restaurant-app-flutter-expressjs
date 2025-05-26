// lib/services/cart_service.dart
import 'package:flutter/material.dart';
import 'package:restaurant_app/models/product.dart';

class CartService extends ChangeNotifier {
  final List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  void addProduct(Product product) {
    final index = _cartItems.indexWhere((item) => item.id == product.id);
    if (index != -1) {
      _cartItems[index].quantity += 1;
    } else {
      _cartItems.add(product);
    }
    notifyListeners();
  }

  void removeProduct(Product product) {
    _cartItems.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  int get itemCount => _cartItems.length;
}
