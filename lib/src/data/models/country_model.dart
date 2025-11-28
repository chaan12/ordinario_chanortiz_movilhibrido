class CountryModel {
  final String? cca2;

  final Map<String, dynamic>? name;
  final String? region;

  final Map<String, dynamic>? flags;

  final String? subregion;
  final List<String> capital;

  final int population;
  final double area;

  final List<String> timezones;

  final Map<String, dynamic>? maps;
  final Map<String, dynamic>? languages;
  final Map<String, dynamic>? currencies;

  CountryModel({
    required this.cca2,
    required this.name,
    required this.region,
    required this.flags,
    required this.subregion,
    required this.capital,
    required this.population,
    required this.area,
    required this.timezones,
    required this.maps,
    required this.languages,
    required this.currencies,
  });

  factory CountryModel.fromApiJson(Map<String, dynamic> json) {
    return CountryModel(
      cca2: json['cca2'],
      name: json['name'],
      region: json['region'],
      flags: json['flags'],

      subregion: json['subregion'] ?? '',

      capital: json['capital'] != null
          ? List<String>.from(json['capital'])
          : [],

      population: json['population'] ?? 0,

      area: json['area'] != null
          ? (json['area'] is int
                ? (json['area'] as int).toDouble()
                : json['area'])
          : 0.0,

      timezones: json['timezones'] != null
          ? List<String>.from(json['timezones'])
          : [],

      maps: json['maps'],
      languages: json['languages'],
      currencies: json['currencies'],
    );
  }
}
