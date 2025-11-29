import 'package:flutter/material.dart';
import '../../data/datasources/local/custom_countries_local_datasource.dart';
import '../../data/models/custom_country_model.dart';

class CustomCountriesController extends ChangeNotifier {
  final CustomCountriesLocalDataSource dataSource;

  List<CustomCountryModel> customCountries = [];

  CustomCountriesController(this.dataSource);

  Future<void> loadCountries() async {
    customCountries = await dataSource.getCountries();
    notifyListeners();
  }

  Future<void> addCountry({
    required String name,
    required String region,
    required String flagUrl,
    required String capital,
    required int population,
    required double area,
    required List<String> languages,
    required List<String> currencies,
  }) async {
    final newCountry = CustomCountryModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      region: region,
      flagUrl: flagUrl,
      capital: capital,
      population: population,
      area: area,
      languages: languages,
      currencies: currencies,
    );

    await dataSource.saveCountry(newCountry);
    await loadCountries();
  }

  Future<void> deleteCountry(String id) async {
    await dataSource.deleteCountry(id);
    await loadCountries();
  }
}
