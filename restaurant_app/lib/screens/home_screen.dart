import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/services/user_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    final UserService userService = UserService();
    final bool isAdmin = userService.isAdmin;
    return Scaffold(
      backgroundColor: CupertinoColors.systemYellow,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/logo.png", height: 100, width: 100),
            SizedBox(height: 50),
            isAdmin
                ? Text("Welcome back ${userService.getName()}")
                : Text("Savor every bite, anytime, anywhere"),
            SizedBox(height: 50),
            if (!isAdmin)
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    '/home',
                    arguments: 1,
                  );
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.yellowAccent),
                ),
                child: Text("Add your order"),
              ),
          ],
        ),
      ),
    );
  }
}
