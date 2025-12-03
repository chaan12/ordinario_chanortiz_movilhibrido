import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/datasources/local/favorites_local_datasource.dart';

class FavoritesController extends ChangeNotifier {
  final FavoritesLocalDataSource dataSource;

  List<String> favorites = [];
  bool isLoading = false;

  FavoritesController(this.dataSource) {
    _autoLoad();
  }

  void _autoLoad() {
    scheduleMicrotask(() {
      loadFavorites();
    });
  }

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
