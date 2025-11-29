import 'package:flutter/material.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/datasources/local/favorites_local_datasource.dart';

class FavoritesController extends ChangeNotifier {
  final FavoritesLocalDataSource dataSource;

  FavoritesController(this.dataSource);

  List<String> favorites = [];
  bool isLoading = false;

  Future<void> loadFavorites() async {
    isLoading = true;
    notifyListeners();

    favorites = await dataSource.getFavorites();

    isLoading = false;
    notifyListeners();
  }

  Future<void> toggleFavorite(String cca2) async {
    await dataSource.toggleFavorite(cca2);
    await loadFavorites();
  }

  Future<void> clearFavorites() async {
    await dataSource.clearFavorites();
    favorites = [];
    notifyListeners();
  }

  bool isFavorite(String cca2) {
    return favorites.contains(cca2);
  }
}
