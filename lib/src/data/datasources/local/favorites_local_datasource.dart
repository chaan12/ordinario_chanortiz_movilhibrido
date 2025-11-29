// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesLocalDataSource {
  static const String key = "favorite_countries";

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(key) ?? [];
  }

  Future<void> toggleFavorite(String cca2) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(key) ?? [];

    if (favorites.contains(cca2)) {
      favorites.remove(cca2);
    } else {
      favorites.add(cca2);
    }

    await prefs.setStringList(key, favorites);
  }

  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
