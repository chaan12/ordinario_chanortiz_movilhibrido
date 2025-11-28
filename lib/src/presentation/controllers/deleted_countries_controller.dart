import 'package:flutter/material.dart';
import '../../data/datasources/local/deleted_countries_local_datasource.dart';

class DeletedCountriesController extends ChangeNotifier {
  final DeletedCountriesLocalDataSource dataSource;

  DeletedCountriesController(this.dataSource);

  List<String> deleted = [];
  bool isLoading = false;

  Future<void> load() async {
    isLoading = true;
    notifyListeners();

    deleted = await dataSource.getDeleted();

    isLoading = false;
    notifyListeners();
  }

  Future<void> toggle(String cca2) async {
    await dataSource.toggleDeleted(cca2);
    await load();
  }

  bool isDeleted(String cca2) {
    return deleted.contains(cca2);
  }
}
