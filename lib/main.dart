import 'package:flutter/material.dart';
import 'src/presentation/pages/home/home_page.dart';
import 'src/presentation/pages/login/login_page.dart';
import 'src/presentation/pages/user/user_profile_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ordinario Chan Ortiz',
      initialRoute: '/login',

      routes: {
        '/login': (_) => const LoginPage(),
        '/home': (_) => const HomePage(),
        '/profile': (_) => const UserProfilePage(),
      },
    );
  }
}
