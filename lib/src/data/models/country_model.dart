import 'package:ordinario_chanortiz_movilhibrido/src/domain/entities/country_entity.dart';

class CountryModel extends CountryEntity {
  CountryModel({
    required super.name,
    required super.flag,
    required super.region,
    super.subregion,
    super.capital,
    super.population,
    super.area,
    super.languages,
    super.currencies,
    super.timezones,
    super.maps,
    required super.cca2,
  });

  factory CountryModel.fromJson(Map<String, dynamic> json) {
    return CountryModel(
      name: json['name']?['common'] ?? 'Unknown',
      flag: json['flags']?['png'] ?? '',
      region: json['region'] ?? 'Unknown',
      subregion: json['subregion'],
      capital: (json['capital'] != null && json['capital'] is List)
          ? json['capital'][0]
          : null,
      population: json['population'],
      area: json['area'],
      languages: json['languages'] != null
          ? (json['languages'] as Map<String, dynamic>).values.toList()
          : null,
      currencies: json['currencies']?.keys.toList(),
      timezones: json['timezones'] != null
          ? List<String>.from(json['timezones'])
          : null,
      maps: json['maps']?['googleMaps'],
      cca2: json['cca2'] ?? '',
    );
  }
}
