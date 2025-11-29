class CustomCountryModel {
  final String id;
  final String name;
  final String region;
  final String flagUrl;
  final String capital;
  final int population;
  final double area;
  final List<String> languages;
  final List<String> currencies;

  CustomCountryModel({
    required this.id,
    required this.name,
    required this.region,
    required this.flagUrl,
    required this.capital,
    required this.population,
    required this.area,
    required this.languages,
    required this.currencies,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'region': region,
      'flagUrl': flagUrl,
      'capital': capital,
      'population': population,
      'area': area,
      'languages': languages,
      'currencies': currencies,
    };
  }

  factory CustomCountryModel.fromJson(Map<String, dynamic> json) {
    return CustomCountryModel(
      id: json['id'],
      name: json['name'],
      region: json['region'],
      flagUrl: json['flagUrl'],
      capital: json['capital'],
      population: json['population'],
      area: json['area'],
      languages: List<String>.from(json['languages']),
      currencies: List<String>.from(json['currencies']),
    );
  }
}
