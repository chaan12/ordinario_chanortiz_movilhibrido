// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class DeletedCountriesLocalDataSource {
  static const _key = "deleted_countries";

  Future<List<String>> getDeleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  Future<void> toggleDeleted(String cca2) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];

    if (current.contains(cca2)) {
      current.remove(cca2);
    } else {
      current.add(cca2);
    }

    await prefs.setStringList(_key, current);
  }

  Future<bool> isDeleted(String cca2) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? [];
    return current.contains(cca2);
  }
}
