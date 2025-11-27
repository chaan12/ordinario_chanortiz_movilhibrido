import '../../entities/country_entity.dart';
import '../../repositories/country_repository.dart';

class GetAllCountriesUseCase {
  final CountryRepository repository;

  GetAllCountriesUseCase(this.repository);

  Future<List<CountryEntity>> call() {
    return repository.getAllCountries();
  }
}
