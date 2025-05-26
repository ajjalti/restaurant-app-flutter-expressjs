import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/models/product.dart';
import 'package:restaurant_app/screens/product_details_screen.dart';
import 'package:restaurant_app/services/cart_service.dart';
import 'package:restaurant_app/services/user_service.dart';

class ProductCardWidget extends StatelessWidget {
  final Product product;
  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final String baseUrl = "${dotenv.env['API_BASE_URL']}";
    final cartService = Provider.of<CartService>(context, listen: false);
    final UserService userService = UserService();
    final bool isAdmin = userService.isAdmin;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsScreen(product: product),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        height: 200,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.3),
              offset: const Offset(4, 4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Image.network(
                "${baseUrl}${product.imageUrl}",
                height: 125,
                width: 125,
              ),
            ),
            if (!isAdmin)
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: const Icon(Icons.add_shopping_cart_outlined),
                  onPressed: () {
                    cartService.addProduct(product);
                  },
                ),
              ),
            Positioned(
              bottom: 10,
              left: 10,
              child: Text(
                product.name, // <-- Nom dynamique
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  "${product.price.toStringAsFixed(0)} DH", // <-- Prix dynamique
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
