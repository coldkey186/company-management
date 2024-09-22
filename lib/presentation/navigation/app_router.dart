import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/login_page.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        final userId = settings.arguments as String; // Lấy userId từ arguments
        return MaterialPageRoute(
          builder: (_) => HomePage(userId: userId), // Truyền userId vào HomePage
        );
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Page not found!')),
          ),
        );
    }
  }
}
