import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:restaurant_app/layout/layout_screen.dart';
import 'package:restaurant_app/screens/add_product_screen.dart';
import 'package:restaurant_app/screens/login_screen.dart';
import 'package:restaurant_app/screens/products_screen.dart';
import 'package:restaurant_app/screens/profile_screen.dart';
import 'package:restaurant_app/screens/register_screen.dart';
import 'package:restaurant_app/services/cart_service.dart';
import 'package:restaurant_app/services/message_service.dart';

final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Erreur lors du chargement du fichier .env : $e");
  }
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartService())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final MessageService messageService = MessageService(scaffoldMessengerKey);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: scaffoldMessengerKey,
      title: 'restaurant-app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(messageService: messageService),
        '/home': (context) => LayoutScreen(messageService: messageService),
        '/register':
            (context) => RegisterScreen(messageService: messageService),
        '/products': (context) => ProductsPage(messageService: messageService),
        '/addProduct': (context) => AddProduct(messageService: messageService),
        '/profile': (context) => ProfileScreen(messageService: messageService),
      },
    );
  }
}
