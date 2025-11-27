class CountryEntity {
  final String name;
  final String flag;
  final String region;

  final String? subregion;
  final String? capital;
  final int? population;
  final double? area;
  final List<dynamic>? languages;
  final List<String>? currencies;
  final List<String>? timezones;
  final String? maps;

  final String cca2;

  CountryEntity({
    required this.name,
    required this.flag,
    required this.region,
    this.subregion,
    this.capital,
    this.population,
    this.area,
    this.languages,
    this.currencies,
    this.timezones,
    this.maps,
    required this.cca2,
  });
}
