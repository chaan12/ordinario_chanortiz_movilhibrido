import '../entities/country_entity.dart';

abstract class CountryRepository {
  Future<List<CountryEntity>> getAllCountries();
  Future<CountryEntity> getCountryDetails(String cca2);

  Future<List<CountryEntity>> searchCountries(String query);
  Future<List<CountryEntity>> filterCountries(String region);
  Future<List<CountryEntity>> sortCountries(String criteria);
}
