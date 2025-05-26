// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant_app/dtos/login_dto.dart';
import 'package:restaurant_app/services/auth_service.dart';
import 'package:restaurant_app/services/message_service.dart';
import 'package:restaurant_app/services/user_service.dart';

class LoginScreen extends StatefulWidget {
  final MessageService messageService;
  const LoginScreen({super.key, required this.messageService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isLoading = false;
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserService userService = UserService();

  final List users = [];
  void _login() async {
    setState(() {
      _isLoading = true;
    });
    final AuthService _authService = AuthService();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final LoginDto loginDto = LoginDto(email: email, password: password);
    final user = await _authService.login(loginDto);

    if (user != null) {
      setState(() {
        _isLoading = false;
      });
      Navigator.pushReplacementNamed(context, '/home');
      widget.messageService.showSuccess("You're logged in ${user.name}");
    } else {
      setState(() {
        _isLoading = false;
      });
      widget.messageService.showError("Invalid authentication !");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemYellow,
      appBar: AppBar(
        title: Text("Login Page"),
        backgroundColor: Colors.yellowAccent,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Image.asset(
                              "assets/images/Login_Register/Login_Icon.png",
                              height: 100,
                              width: 100,
                            ),
                            SizedBox(height: 20),
                            TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: "Enter your Email : ",
                                labelText: "Email : ",
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Email is required';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 10),
                            PasswordField(controller: _passwordController),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: () {
                                _login();
                                //todo!
                                // if (_formKey.currentState!.validate()) {
                                //   _auth
                                //       .signInWithEmailAndPassword(
                                //     email: _emailController.text,
                                //     password: _passwordController.text,
                                //   )
                                //       .then((value) {
                                //     Navigator.pushReplacement(
                                //       context,
                                //       MaterialPageRoute(
                                //         builder: (context) => ProductsPage(),
                                //       ),
                                //     );
                                //   }).catchError((error) {
                                //     ScaffoldMessenger.of(context).showSnackBar(
                                //       SnackBar(content: Text(error.toString())),
                                //     );
                                //   });
                                // }
                              },
                              child: Text('Sign In!'),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text("Not a member , Sign UP!"),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({super.key, required this.controller});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isObscured = !_isObscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscured,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
          onPressed: _togglePasswordVisibility,
        ),
        hintText: "Enter your password:",
        labelText: "Password :",
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: const Color.fromARGB(255, 0, 0, 0)),
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Password is required';
        } else if (value.length < 6) {
          return 'Password should be at least 6 characters';
        }
        return null;
      },
    );
  }
}
