import 'package:flutter/material.dart';

import '../../domain/entities/country_entity.dart';
import '../../domain/usecases/countries/get_country_details_usecase.dart';

class CountryDetailsController extends ChangeNotifier {
  final GetCountryDetailsUseCase getDetailsUseCase;

  CountryDetailsController(this.getDetailsUseCase);

  CountryEntity? country;
  bool isLoading = false;
  String? errorMessage;

  Future<void> loadCountryDetails(String cca2) async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      country = await getDetailsUseCase(cca2);
    } catch (e) {
      errorMessage = 'Error al cargar detalles';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
