import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/country_model.dart';

class CountriesApiDataSource {
  final String baseUrl =
      'https://restcountries.com/v3.1/all?fields=name,flags,region,cca2';

  Future<List<CountryModel>> getAllCountries() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((item) => CountryModel.fromJson(item)).toList();
    }

    return [];
  }

  Future<CountryModel> getCountryDetails(String cca2) async {
    final url = Uri.parse(
      'https://restcountries.com/v3.1/alpha/$cca2'
      '?fields=name,flags,region,subregion,capital,population,area,'
      'languages,currencies,timezones,maps',
    );

    print("URL DETALLES: $url");
    final response = await http.get(url);
    print("STATUS DETALLES: ${response.statusCode}");
    print("BODY DETALLES: ${response.body}");

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonData = json.decode(response.body);
      return CountryModel.fromJson(jsonData);
    }

    throw Exception('Error loading country details');
  }
}
