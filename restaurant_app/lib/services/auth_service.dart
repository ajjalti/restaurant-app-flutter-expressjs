import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/dtos/auth_dto.dart';
import 'package:restaurant_app/services/user_service.dart';
import '../models/user.dart';
import '../dtos/login_dto.dart';
import '../dtos/register_dto.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final baseUrl = "${dotenv.env['API_BASE_URL']}/api/auth";

class AuthService {
  Future<dynamic> login(LoginDto loginDto) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(loginDto.toJson()),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      UserService().setId(json['_id']);
      UserService().setRole(json['role']);
      UserService().setToken(json['token']);
      UserService().setName(json['name']);
      UserService().setEmail(json['email']);
      return true;
    } else {
      return null;
    }
  }

  Future<dynamic> register(RegisterDto registerDto) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(registerDto.toJson()),
    );

    if (response.statusCode == 201 || response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return User.fromJson(json);
    } else {
      print('Erreur register: ${response.body}');
      return null;
    }
  }
}
