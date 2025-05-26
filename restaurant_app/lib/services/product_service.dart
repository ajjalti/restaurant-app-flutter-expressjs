import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:restaurant_app/dtos/product_request_dto.dart';
import 'package:restaurant_app/services/user_service.dart';
import '../models/product.dart';
import 'dart:io';
import 'package:path/path.dart';

class ProductService {
  final String baseUrl = "${dotenv.env['API_BASE_URL']}/api/products";

  // 🔍 Lire tous les produits
  Future<List<Product>?> getAllProducts() async {
    final UserService userService = UserService();
    final String? token = await userService.getToken();
    final response = await http.get(
      Uri.parse('$baseUrl'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      return null;
    }
  }

  // ➕ Créer un produit
  Future<Product?> createProduct(
    ProductRequestDto product,
    File imageFile,
  ) async {
    final UserService userService = UserService();
    final String? token = await userService.getToken();
    final uri = Uri.parse('$baseUrl');
    final request = http.MultipartRequest('POST', uri);
    request.fields['name'] = product.name;
    request.fields['description'] = product.description;
    request.fields['price'] = product.price.toString();
    // Ajouter le fichier
    request.files.add(
      await http.MultipartFile.fromPath(
        'image', // clé attendue par ton backend pour le fichier
        imageFile.path,
        filename: basename(imageFile.path),
      ),
    );
    if (token != null) {
      request.headers['Authorization'] = 'Bearer ${token}';
      final streamedResponse = await request.send();
      final responseBody = await streamedResponse.stream.bytesToString();
      if (streamedResponse.statusCode == 200 ||
          streamedResponse.statusCode == 201) {
        return Product.fromJson(jsonDecode(responseBody));
      } else {
        return null;
      }
    } else {
      return null;
    }
  }
}
