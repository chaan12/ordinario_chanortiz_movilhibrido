import '../../domain/entities/user_entity.dart';

class UserSession {
  static UserEntity? user;

  static void setUser(UserEntity newUser) {
    user = newUser;
  }

  static void clear() {
    user = null;
  }

  static bool get isLoggedIn => user != null;
}
