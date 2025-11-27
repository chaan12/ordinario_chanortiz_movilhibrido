import 'package:flutter/material.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/presentation/controllers/country_details_controller.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/domain/usecases/countries/get_country_details_usecase.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/repositories_impl/country_repository_impl.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/datasources/remote/countries_api_datasource.dart';

class CountryDetailsPage extends StatefulWidget {
  final String cca2;

  const CountryDetailsPage({super.key, required this.cca2});

  @override
  State<CountryDetailsPage> createState() => _CountryDetailsPageState();
}

class _CountryDetailsPageState extends State<CountryDetailsPage> {
  late CountryDetailsController controller;

  @override
  void initState() {
    super.initState();

    controller = CountryDetailsController(
      GetCountryDetailsUseCase(CountryRepositoryImpl(CountriesApiDataSource())),
    );

    controller.loadCountryDetails(widget.cca2);
    print("ABRIENDO DETAILS PARA: ${widget.cca2}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detalles del país")),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            print("DETAILS: CARGANDO...");
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            print("DETAILS ERROR: ${controller.errorMessage}");
            return Center(
              child: Text(
                controller.errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          }

          if (controller.country == null) {
            print("DETAILS: SIN DATOS");
            return const Center(child: Text("No hay datos"));
          }

          print("DETAILS RECIBIDOS: ${controller.country}");
          final c = controller.country!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.network(c.flag, height: 120)),
                const SizedBox(height: 20),
                Text(
                  c.name,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                _info("Región", c.region),
                _info("Subregión", c.subregion),
                _info("Capital", c.capital),
                _info("Población", c.population?.toString()),
                _info("Área", c.area?.toString()),
                _info("Idiomas", c.languages?.join(", ")),
                _info("Monedas", c.currencies?.join(", ")),
                _info("Zonas horarias", c.timezones?.join(", ")),
                _info("Google Maps", c.maps),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _info(String title, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text("$title: $value", style: const TextStyle(fontSize: 18)),
    );
  }
}
