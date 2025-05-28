import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:restaurant_app/dtos/order_request_dto.dart';
import 'package:restaurant_app/models/order.dart';
import 'package:restaurant_app/services/invoice_service.dart';
import 'package:restaurant_app/services/user_service.dart';
import 'package:http/http.dart' as http;

class OrderService {
  final String baseUrl = "${dotenv.env['API_BASE_URL']}/api/orders";
  Future<OrderRequestDto?> createOrder(OrderRequestDto orderRequestDto) async {
    final UserService userService = UserService();
    final String? token = await userService.getToken();
    final uri = Uri.parse('$baseUrl');
    final response = await http.post(
      uri,
      body: jsonEncode(orderRequestDto.toJson()),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body);
      final responseDto = OrderRequestDto.fromJson(json);
      final InvoiceService invoiceService = InvoiceService(baseUrl: baseUrl);
      invoiceService.downloadAndOpenInvoice(responseDto.id);
      return responseDto;
    } else {
      print('Erreur register: ${response.body}');
      return null;
    }
  }

  Future<dynamic> getAllOrders() async {
    final UserService userService = UserService();
    final String? token = await userService.getToken();
    final uri = Uri.parse('$baseUrl');
    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      // data.forEach((e) => print(e.toString()));
      // return [];
      return data.map((json) => Order.fromJson(json)).toList();
    } else {
      return [];
    }
  }
}
