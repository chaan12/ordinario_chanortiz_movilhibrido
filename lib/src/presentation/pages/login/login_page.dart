import 'package:flutter/material.dart';
import '../../../presentation/controllers/login_controller.dart';
import '../../../domain/usecases/auth/login_usecase.dart';
import '../../../data/repositories_impl/auth_repository_impl.dart';
import '../../../data/datasources/remote/login_api_datasource.dart';
import '../../../../../main.dart';
import '../home/home_page.dart';
import '../admin/admin_dashboard_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  late LoginController controller;

  @override
  void initState() {
    final datasource = LoginApiDataSource();
    final repository = AuthRepositoryImpl(datasource);
    final usecase = LoginUseCase(repository);
    controller = LoginController(usecase);
    super.initState();
  }

  Future<void> handleLogin() async {
    final role = await controller.login(
      usernameCtrl.text.trim(),
      passwordCtrl.text.trim(),
    );

    if (role == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Usuario o contraseña incorrectos")),
      );
      return;
    }

    if (role == "admin") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AdminDashboardPage()),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Iniciar Sesión",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: usernameCtrl,
                decoration: const InputDecoration(labelText: "Usuario"),
              ),
              TextField(
                controller: passwordCtrl,
                decoration: const InputDecoration(labelText: "Contraseña"),
                obscureText: true,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: handleLogin,
                child: const Text("Entrar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
