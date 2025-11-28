import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/country_model.dart';

class CountriesApiDataSource {
  final String baseUrl = "https://restcountries.com/v3.1";

  Future<List<CountryModel>> getAllCountries() async {

    final url = Uri.parse(
      "$baseUrl/all?fields=cca2,name,region,flags,languages,currencies",
    );


    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      return data.map((json) {
        return CountryModel.fromApiJson(json);
      }).toList();
    } else {
      throw Exception("Error cargando países");
    }
  }

  Future<CountryModel> getCountryDetails(String cca2) async {

    final url = Uri.parse(
      "$baseUrl/alpha/$cca2?fields=cca2,name,region,subregion,"
      "flags,capital,population,area,timezones,maps,languages,currencies",
    );


    final response = await http.get(url);

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return CountryModel.fromApiJson(data);
      } catch (e) {
        throw Exception("Error procesando detalles");
      }
    } else {
      throw Exception("Error cargando detalles del país");
    }
  }
}
