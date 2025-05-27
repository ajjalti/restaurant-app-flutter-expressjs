import 'package:flutter/material.dart';
import 'package:restaurant_app/services/message_service.dart';
import 'package:restaurant_app/services/product_service.dart';
import 'package:restaurant_app/widgets/product_card_widget.dart';

class ProductsPage extends StatefulWidget {
  final MessageService messageService;
  const ProductsPage({super.key, required this.messageService});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  late dynamic products = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  void loadProducts() async {
    final ProductService _productService = ProductService();
    final loadedProducts = await _productService.getAllProducts();

    if (loadedProducts != null) {
      setState(() {
        products = loadedProducts;
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
      widget.messageService.showError("Échec du chargement des produits.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  SizedBox(height: 25),
                  Text(
                    "Our Meals",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 25),
                  Expanded(
                    child: GridView.builder(
                      padding: EdgeInsets.all(10),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 colonnes
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return ProductCardWidget(product: products[index]);
                      },
                    ),
                  ),
                ],
              ),
    );
  }
}
