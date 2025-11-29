import 'package:flutter/material.dart';
import '../../domain/usecases/countries/get_all_countries_usecase.dart';
import '../../domain/entities/country_entity.dart';

class CountriesController extends ChangeNotifier {
  final GetAllCountriesUseCase useCase;

  CountriesController(this.useCase);

  bool isLoading = false;
  String? errorMessage;

  List<CountryEntity> allCountries = [];
  List<CountryEntity> filteredCountries = []; 

  String searchQuery = "";
  List<String> selectedRegions = [];
  List<String> selectedLanguages = [];
  List<String> selectedCurrencies = [];

  String orderBy = "name";

  Future<void> loadCountries() async {
    isLoading = true;
    notifyListeners();

    try {
      allCountries = await useCase();
      filteredCountries = List.from(allCountries);
      isLoading = false;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
    }
  }

  void updateSearch(String value) {
    searchQuery = value.toLowerCase();
    applyFilters();
  }

  void toggleRegion(String region) {
    selectedRegions.contains(region)
        ? selectedRegions.remove(region)
        : selectedRegions.add(region);

    applyFilters();
  }

  void toggleLanguage(String lang) {
    selectedLanguages.contains(lang)
        ? selectedLanguages.remove(lang)
        : selectedLanguages.add(lang);

    applyFilters();
  }

  void toggleCurrency(String currency) {
    selectedCurrencies.contains(currency)
        ? selectedCurrencies.remove(currency)
        : selectedCurrencies.add(currency);

    applyFilters();
  }

  void setOrder(String type) {
    orderBy = type;
    applyFilters();
  }

  void applyFilters() {
    filteredCountries = allCountries.where((country) {
      final matchesSearch =
          country.name.toLowerCase().contains(searchQuery);

      final matchesRegion =
          selectedRegions.isEmpty ||
          selectedRegions.contains(country.region);

      final matchesLanguages =
          selectedLanguages.isEmpty ||
          selectedLanguages.any(
            (lang) => country.languages.keys.contains(lang),
          );

      final matchesCurrencies =
          selectedCurrencies.isEmpty ||
          selectedCurrencies.any(
            (cur) => country.currencies.keys.contains(cur),
          );
      final result = matchesSearch &&
          matchesRegion &&
          matchesLanguages &&
          matchesCurrencies;

      return result;
    }).toList();

    if (orderBy == "name") {
      filteredCountries.sort((a, b) => a.name.compareTo(b.name));
    } else if (orderBy == "name_desc") {
      filteredCountries.sort((a, b) => b.name.compareTo(a.name));
    }

    notifyListeners();
  }
  Map<String, int> getCountriesPerRegion() {
    final Map<String, int> result = {
      "Africa": 0,
      "Americas": 0,
      "Asia": 0,
      "Europe": 0,
      "Oceania": 0,
      "Other": 0,
    };

    for (final c in allCountries) {
      final region = c.region;
      if (result.containsKey(region)) {
        result[region] = result[region]! + 1;
      } else {
        result["Other"] = result["Other"]! + 1;
      }
    }

    return result;
  }

  Map<String, int> getLanguagesPerRegion() {
    final Map<String, Set<String>> langsPerRegion = {
      "Africa": {},
      "Americas": {},
      "Asia": {},
      "Europe": {},
      "Oceania": {},
      "Other": {},
    };

    for (final c in allCountries) {
      final region = langsPerRegion.containsKey(c.region) ? c.region : "Other";
      c.languages.forEach((code, name) {
        langsPerRegion[region]!.add(code);
      });
    }

    return langsPerRegion.map((key, value) => MapEntry(key, value.length));
  }

  Map<String, int> getTopLanguages({int top = 5}) {
    final Map<String, int> count = {};

    for (final c in allCountries) {
      c.languages.forEach((code, name) {
        count[code] = (count[code] ?? 0) + 1;
      });
    }

    final entries = count.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topEntries = entries.take(top);
    return {for (var e in topEntries) e.key: e.value};
  }

  Map<String, int> getTopCurrencies({int top = 5}) {
    final Map<String, int> count = {};

    for (final c in allCountries) {
      c.currencies.forEach((code, name) {
        count[code] = (count[code] ?? 0) + 1;
      });
    }

    final entries = count.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final topEntries = entries.take(top);
    return {for (var e in topEntries) e.key: e.value};
  }
}
