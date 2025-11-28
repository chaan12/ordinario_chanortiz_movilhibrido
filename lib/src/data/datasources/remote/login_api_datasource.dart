import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../data/models/user_model.dart';
import '../../session/user_session.dart';

class LoginApiDataSource {
  final String baseUrl = 'https://dummyjson.com/users';

  Future<UserModel?> login(String username, String password) async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List users = jsonData['users'];

      for (var user in users) {
        if (user['username'] == username && user['password'] == password) {
          final userModel = UserModel.fromJson(user);

          UserSession.setUser(userModel);

          return userModel;
        }
      }
    }

    return null;
  }
}
