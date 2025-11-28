import 'package:flutter/material.dart';
import '../../domain/usecases/countries/get_all_countries_usecase.dart';
import '../../domain/entities/country_entity.dart';

class CountriesController extends ChangeNotifier {
  final GetAllCountriesUseCase useCase;

  CountriesController(this.useCase);

  bool isLoading = false;
  String? errorMessage;

  List<CountryEntity> allCountries = []; // lista original completa
  List<CountryEntity> filteredCountries = []; // lista filtrada

  // -----------------------------
  // FILTROS ACTIVOS
  // -----------------------------
  String searchQuery = "";
  List<String> selectedRegions = [];
  List<String> selectedLanguages = [];
  List<String> selectedCurrencies = [];

  String orderBy = "name"; // name | area

  // -----------------------------
  // CARGAR PAISES
  // -----------------------------
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

  // -----------------------------
  // BÚSQUEDA POR NOMBRE
  // -----------------------------
  void updateSearch(String value) {
    searchQuery = value.toLowerCase();
    applyFilters();
  }

  // -----------------------------
  // FILTROS
  // -----------------------------
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

  // -----------------------------
  // ORDENAR
  // -----------------------------
  void setOrder(String type) {
    orderBy = type;
    applyFilters();
  }

  // -----------------------------
  // APLICAR TODO
  // -----------------------------
  void applyFilters() {
    print("🔍 APLICANDO FILTROS...");
    print("   🔎 searchQuery = $searchQuery");
    print("   🌍 regiones = $selectedRegions");
    print("   🗣️ idiomas = $selectedLanguages");
    print("   💰 monedas = $selectedCurrencies");
    print("   🎛️ orden = $orderBy");

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

    print("📏 PRE-ORDEN (primeros 5):");
    for (var c in filteredCountries.take(5)) {
      print("   - ${c.name} | área=${c.area}");
    }

    if (orderBy == "name") {
      filteredCountries.sort((a, b) => a.name.compareTo(b.name));
    } else if (orderBy == "name_desc") {
      filteredCountries.sort((a, b) => b.name.compareTo(a.name));
    }

    print("📏 POST-ORDEN (primeros 5):");
    for (var c in filteredCountries.take(5)) {
      print("   - ${c.name} | área=${c.area}");
    }

    notifyListeners();
  }
}
