import '../../../domain/entities/country_entity.dart';
import '../../../domain/repositories/country_repository.dart';

class GetCountryDetailsUseCase {
  final CountryRepository repository;

  GetCountryDetailsUseCase(this.repository);

  Future<CountryEntity> call(String cca2) async {
    return await repository.getCountryDetails(cca2);
  }
}
