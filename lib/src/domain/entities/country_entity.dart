class CountryEntity {
  final String cca2;
  final String name;
  final String region;
  final String subregion;
  final String capital;
  final int population;
  final double area;
  final List<String> timezones;

  final String flagPng;
  final String flagSvg;

  final String mapUrl;

  final Map<String, dynamic> languages;
  final Map<String, dynamic> currencies;

  CountryEntity({
    required this.cca2,
    required this.name,
    required this.region,
    required this.subregion,
    required this.capital,
    required this.population,
    required this.area,
    required this.timezones,
    required this.flagPng,
    required this.flagSvg,
    required this.mapUrl,
    required this.languages,
    required this.currencies,
  });
}
