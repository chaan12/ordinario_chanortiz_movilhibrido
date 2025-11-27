import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/login_api_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final LoginApiDataSource dataSource;

  AuthRepositoryImpl(this.dataSource);

  @override
  Future<UserEntity?> login(String username, String password) {
    return dataSource.login(username, password);
  }

  @override
  Future<void> logout() async {}
}
