import 'package:ordinario_chanortiz_movilhibrido/src/data/datasources/remote/countries_api_datasource.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/domain/entities/country_entity.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/domain/repositories/country_repository.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/presentation/adapters/country_adapter.dart';

class CountryRepositoryImpl implements CountryRepository {
  final CountriesApiDataSource dataSource;

  CountryRepositoryImpl(this.dataSource);

  @override
  Future<List<CountryEntity>> getAllCountries() async {
    final models = await dataSource.getAllCountries();
    return models.map((m) => CountryAdapter.fromModel(m)).toList();
  }

  @override
  Future<CountryEntity> getCountryDetails(String cca2) async {
    final model = await dataSource.getCountryDetails(cca2);
    return CountryAdapter.fromModel(model);
  }

  @override
  Future<List<CountryEntity>> searchCountries(String query) async {
    final allCountries = await getAllCountries();
    final normalized = query.toLowerCase();
    return allCountries
        .where((c) => c.name.toLowerCase().contains(normalized))
        .toList();
  }

  @override
  Future<List<CountryEntity>> filterCountries(String region) async {
    final all = await getAllCountries();
    final reg = region.toLowerCase();
    return all.where((c) => c.region.toLowerCase() == reg).toList();
  }

  @override
  Future<List<CountryEntity>> sortCountries(String criteria) async {
    final list = await getAllCountries();
    list.sort((a, b) {
      switch (criteria) {
        case 'name_asc':
          return a.name.compareTo(b.name);
        case 'name_desc':
          return b.name.compareTo(a.name);
        default:
          return 0;
      }
    });
    return list;
  }
}
