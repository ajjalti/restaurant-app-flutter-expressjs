import 'package:flutter/material.dart';

class MessageService {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;

  MessageService(this.scaffoldMessengerKey);

  void showSuccess(String message) {
    _showSnackBar(message, Colors.green);
  }

  void showError(String message) {
    _showSnackBar(message, Colors.red);
  }

  void _showSnackBar(String message, Color color) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: color,
      duration: Duration(seconds: 3),
    );
    scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
  }
}
