import 'package:flutter/material.dart';
import 'package:restaurant_app/services/message_service.dart';
import 'package:restaurant_app/services/user_service.dart';

class ProfileScreen extends StatelessWidget {
  final MessageService messageService;
  const ProfileScreen({super.key, required this.messageService});

  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey[300],
              child: Icon(
                Icons.person,
                size: 50,
                color: Colors.white, // or any color you prefer
              ),
            ),
            SizedBox(height: 20),
            Text(
              "${userService.getRole()}",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            Text("${userService.getName()}", style: TextStyle(fontSize: 22)),
            Text(
              "${userService.getEmail()}",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
