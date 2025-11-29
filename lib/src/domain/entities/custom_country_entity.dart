class CustomCountryEntity {
  final String name;
  final String region;
  final String flagUrl;

  final String code;
  final String language;
  final String currency;

  CustomCountryEntity({
    required this.name,
    required this.region,
    required this.flagUrl,
    this.code = "N/A",
    this.language = "N/A",
    this.currency = "N/A",
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "region": region,
      "flagUrl": flagUrl,
      "code": code,
      "language": language,
      "currency": currency,
    };
  }

  factory CustomCountryEntity.fromJson(Map<String, dynamic> json) {
    return CustomCountryEntity(
      name: json["name"],
      region: json["region"],
      flagUrl: json["flagUrl"],
      code: json["code"] ?? "N/A",
      language: json["language"] ?? "N/A",
      currency: json["currency"] ?? "N/A",
    );
  }
}
