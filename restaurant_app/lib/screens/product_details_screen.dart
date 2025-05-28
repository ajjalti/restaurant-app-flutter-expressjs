import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:restaurant_app/models/product.dart';
import 'package:restaurant_app/services/product_service.dart';
import 'package:restaurant_app/services/user_service.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;
  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final String baseUrl = "${dotenv.env['API_BASE_URL']}";
    final ProductService _productService = ProductService();
    final UserService userService = UserService();
    final bool isAdmin = userService.isAdmin;
    void _deleteProduct() async {
      Navigator.of(context).pop(true);
      Navigator.of(context).pop(true);
      Navigator.pushReplacementNamed(context, '/home', arguments: 1);
      await _productService.deleteById(product.id);
    }

    return Scaffold(
      backgroundColor: Colors.yellow.shade100,
      appBar: AppBar(
        title: Text(product.name),
        backgroundColor: Colors.yellow,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () {
            // Custom action on back
            Navigator.pushReplacementNamed(context, '/home', arguments: 1);
            // or any custom logic
          },
        ),
        actions: [
          if (isAdmin)
            IconButton.outlined(
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text("Delete this product !"),
                        content: Text("Are you sure ?"),
                        actions: [
                          TextButton(
                            child: Text("Cancel"),
                            onPressed: () => Navigator.of(context).pop(false),
                          ),
                          ElevatedButton(
                            onPressed: _deleteProduct,
                            child: Text("Confirm"),
                          ),
                        ],
                      ),
                );

                // if (confirmDelete == true) {

                // }
              },
              icon: Icon(Icons.delete_forever_outlined, color: Colors.red),
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              "${baseUrl}${product.imageUrl}",
              width: double.infinity,
              height: 250,
              fit: BoxFit.cover,
            ),

            // const SizedBox(height: 20),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  product.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 20, left: 20, bottom: 20),
              decoration: const BoxDecoration(
                color: Colors.white,
                // borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Prix
                  Row(
                    children: [
                      Text(
                        "Price: ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${product.price.toStringAsFixed(2)} DH",
                        style: const TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  /// Description
                  Row(
                    children: [
                      const Text(
                        "Description: ",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        product.description,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
