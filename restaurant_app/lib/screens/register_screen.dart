// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:restaurant_app/dtos/register_dto.dart';
import 'package:restaurant_app/services/auth_service.dart';
import 'package:restaurant_app/services/message_service.dart';
import 'package:restaurant_app/services/user_service.dart';

class RegisterScreen extends StatefulWidget {
  final MessageService messageService;
  const RegisterScreen({super.key, required this.messageService});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final AuthService _authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _register() async {
    final UserService userService = UserService();
    final isValid = _formKey.currentState?.validate();
    if (isValid == false) {
      widget.messageService.showError("Invalid form fields informations !");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final RegisterDto registerDto = RegisterDto(
      name: name,
      email: email,
      password: password,
    );
    final user = await _authService.register(registerDto);
    print(user);
    if (user != null) {
      setState(() {
        _isLoading = false;
      });
      widget.messageService.showSuccess("Registration success !");
      Navigator.pop(context);
    } else {
      setState(() {
        _isLoading = false;
      });
      widget.messageService.showError(
        "Registration fail, please try again later !",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemYellow,
      appBar: AppBar(
        title: Text("Register Page"),
        backgroundColor: Colors.yellowAccent,
      ),
      body:
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : Center(
                child: SingleChildScrollView(
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
                                'Welcome',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 20),
                              TextFormField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  hintText: "Enter your full name",
                                  labelText: "Full Name",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  hintText: "Enter your Email",
                                  labelText: "Email",
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Email is required';
                                  } else if (!value.contains('@')) {
                                    return 'Enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(height: 10),
                              PasswordField(
                                passwordController: _passwordController,
                                confirmPasswordController:
                                    _confirmPasswordController,
                              ),
                              SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () async {
                                  _register();
                                  //todo!
                                  // if (isValid == true) {
                                  //   try {
                                  //     await _auth.createUserWithEmailAndPassword(
                                  //       email: _emailController.text.trim(),
                                  //       password: _passwordController.text.trim(),
                                  //     );
                                  //     // Go to login page
                                  //     Navigator.pushReplacement(
                                  //       context,
                                  //       MaterialPageRoute(
                                  //           builder: (_) => const LoginScreen()),
                                  //     );
                                  //   } on FirebaseAuthException catch (e) {
                                  //     ScaffoldMessenger.of(context).showSnackBar(
                                  //       SnackBar(
                                  //           content: Text(
                                  //               e.message ?? 'Registration failed')),
                                  //     );
                                  //   }
                                  // }
                                },
                                child: Text('Sign Up!'),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Container(
                          padding: EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("Or continue with:"),
                              TextButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.facebook),
                                label: Text('Facebook'),
                              ),
                              TextButton.icon(
                                onPressed: () {},
                                icon: Icon(Icons.mail_outline),
                                label: Text('Gmail'),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(height: 25),
                        // Icon(Icons.add_box_outlined),
                        // SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Already a member? Sign IN!"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
    );
  }
}

class PasswordField extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const PasswordField({
    super.key,
    required this.passwordController,
    required this.confirmPasswordController,
  });

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
    return Column(
      children: [
        TextFormField(
          controller: widget.passwordController,
          obscureText: _isObscured,
          decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off),
              onPressed: _togglePasswordVisibility,
            ),
            hintText: "Enter your password:",
            labelText: "Password:",
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Color.fromARGB(255, 0, 0, 0)),
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Password is required';
            } else if (value.length < 6) {
              return 'Password must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }
}
