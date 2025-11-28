import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/country_model.dart';

class CountriesApiDataSource {
  final String baseUrl = "https://restcountries.com/v3.1";

  Future<List<CountryModel>> getAllCountries() async {
    print("🌍 GET ALL COUNTRIES");

    final url = Uri.parse(
      "$baseUrl/all?fields=cca2,name,region,flags,languages,currencies",
    );

    print("🌍 URL = $url");

    final response = await http.get(url);

    print("🌍 STATUS = ${response.statusCode}");

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      print("📦 ITEMS RECIBIDOS = ${data.length}");

      if (data.isNotEmpty) {
        print("🧪 EJ languages: ${data.first['languages']}");
        print("🧪 EJ currencies: ${data.first['currencies']}");
      }

      return data.map((json) {
        return CountryModel.fromApiJson(json);
      }).toList();
    } else {
      print("❌ ERROR RAW = ${response.body}");
      throw Exception("Error cargando países");
    }
  }

  Future<CountryModel> getCountryDetails(String cca2) async {
    print("🔎 GET COUNTRY DETAILS de: $cca2");

    final url = Uri.parse(
      "$baseUrl/alpha/$cca2?fields=cca2,name,region,subregion,"
      "flags,capital,population,area,timezones,maps,languages,currencies",
    );

    print("🌍 URL DETALLES = $url");

    final response = await http.get(url);

    print("🌍 STATUS = ${response.statusCode}");
    print("🌍 RAW BODY = ${response.body}");

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return CountryModel.fromApiJson(data);
      } catch (e, st) {
        print("❌ ERROR PARSEANDO DETALLES: $e");
        print("📌 STACKTRACE: $st");
        throw Exception("Error procesando detalles");
      }
    } else {
      throw Exception("Error cargando detalles del país");
    }
  }
}
