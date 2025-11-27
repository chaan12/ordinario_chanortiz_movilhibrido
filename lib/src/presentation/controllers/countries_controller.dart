import 'package:flutter/material.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/domain/entities/country_entity.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/domain/usecases/countries/get_all_countries_usecase.dart';

class CountriesController extends ChangeNotifier {
  final GetAllCountriesUseCase getAllCountriesUseCase;

  CountriesController(this.getAllCountriesUseCase);

  List<CountryEntity> countries = [];
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadCountries() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      countries = await getAllCountriesUseCase();
    } catch (e) {
      errorMessage = 'Error al cargar países';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
