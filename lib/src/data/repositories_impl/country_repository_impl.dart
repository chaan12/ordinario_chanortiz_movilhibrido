import 'package:ordinario_chanortiz_movilhibrido/src/domain/entities/country_entity.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/domain/repositories/country_repository.dart';

import '../datasources/remote/countries_api_datasource.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountriesApiDataSource dataSource;

  CountryRepositoryImpl(this.dataSource);

  @override
  Future<List<CountryEntity>> getAllCountries() async {
    return await dataSource.getAllCountries();
  }

  @override
  Future<CountryEntity> getCountryDetails(String cca2) async {
    return await dataSource.getCountryDetails(cca2);
  }

  @override
  Future<List<CountryEntity>> searchCountries(String query) async {
    final allCountries = await dataSource.getAllCountries();

    return allCountries
        .where(
          (country) => country.name.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<List<CountryEntity>> filterCountries(String region) async {
    final allCountries = await dataSource.getAllCountries();

    return allCountries.where((country) => country.region == region).toList();
  }

  @override
  Future<List<CountryEntity>> sortCountries(String criteria) async {
    final allCountries = await dataSource.getAllCountries();

    if (criteria == "name_asc") {
      allCountries.sort((a, b) => a.name.compareTo(b.name));
    } else if (criteria == "name_desc") {
      allCountries.sort((a, b) => b.name.compareTo(a.name));
    }

    return allCountries;
  }
}
