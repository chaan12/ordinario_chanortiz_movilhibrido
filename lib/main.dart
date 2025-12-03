import 'package:flutter/material.dart';
import 'src/presentation/pages/home/home_page.dart';
import 'src/presentation/pages/login/login_page.dart';
import 'src/presentation/pages/user/user_profile_page.dart';
import 'src/presentation/pages/admin/delete_country_page.dart';
import 'src/data/datasources/local/favorites_local_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FavoritesLocalDataSource().clearFavorites();
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
        '/delete_country': (_) => const DeleteCountryPage(),
      },
    );
  }
}
