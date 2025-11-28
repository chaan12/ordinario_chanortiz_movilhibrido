// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesLocalDataSource {
  final String key = "favorite_countries";

  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key);
    return data ?? [];
  }

  Future<void> toggleFavorite(String cca2) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList(key) ?? [];

    if (favorites.contains(cca2)) {
      favorites.remove(cca2);
    } else {
      favorites.add(cca2);
    }

    await prefs.setStringList(key, favorites);
  }

  Future<bool> isFavorite(String cca2) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(key) ?? [];
    return favorites.contains(cca2);
  }
}
