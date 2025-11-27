import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth/login_usecase.dart';

class LoginController {
  final LoginUseCase loginUseCase;

  UserEntity? currentUser;
  bool isLoading = false;
  String? errorMessage;

  LoginController(this.loginUseCase);

  Future<String?> login(String username, String password) async {
    isLoading = true;
    errorMessage = null;

    final user = await loginUseCase(username, password);

    isLoading = false;

    if (user == null) {
      errorMessage = "Usuario o contraseña incorrectos";
      return null;
    }

    currentUser = user;
    return user.role;
  }

  void logout() {
    currentUser = null;
  }
}
