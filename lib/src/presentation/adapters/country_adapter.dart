
import '../../data/models/country_model.dart';
import '../../domain/entities/country_entity.dart';

class CountryAdapter {
  static CountryEntity fromModel(CountryModel model) {
    return CountryEntity(
      cca2: model.cca2 ?? '',
      name: model.name?["common"] ?? "Sin nombre",
      region: model.region ?? "Desconocido",
      subregion: model.subregion ?? "Desconocido",

      capital: model.capital.isNotEmpty ? model.capital.first : "Sin capital",
      population: model.population,
      area: model.area,
      timezones: model.timezones,

      // Flags
      flagPng: model.flags?["png"] ?? "",
      flagSvg: model.flags?["svg"] ?? "",

      // Mapas
      mapUrl: model.maps?["googleMaps"] ?? "",

      // Otros
      languages: model.languages ?? {},
      currencies: model.currencies ?? {},
    );
  }
}