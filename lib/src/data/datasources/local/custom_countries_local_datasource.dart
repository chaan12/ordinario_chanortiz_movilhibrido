import 'dart:convert';
// ignore: depend_on_referenced_packages
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/custom_country_model.dart';

class CustomCountriesLocalDataSource {
  static const String storageKey = "custom_countries";

  Future<List<CustomCountryModel>> getCountries() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(storageKey);

    if (jsonString == null) return [];

    final List decodedList = jsonDecode(jsonString);

    return decodedList
        .map((item) => CustomCountryModel.fromJson(item))
        .toList();
  }


  Future<void> saveCountry(CustomCountryModel country) async {
    final prefs = await SharedPreferences.getInstance();

    final countries = await getCountries();
    countries.add(country);

    final encoded = jsonEncode(countries.map((c) => c.toJson()).toList());

    await prefs.setString(storageKey, encoded);
  }

  Future<void> deleteCountry(String id) async {
    final prefs = await SharedPreferences.getInstance();

    final countries = await getCountries();
    final updated = countries.where((c) => c.id != id).toList();

    final encoded = jsonEncode(updated.map((c) => c.toJson()).toList());

    await prefs.setString(storageKey, encoded);
  }
}
