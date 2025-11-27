import 'package:flutter/material.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/presentation/controllers/countries_controller.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/domain/usecases/countries/get_all_countries_usecase.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/repositories_impl/country_repository_impl.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/datasources/remote/countries_api_datasource.dart';
import 'country_details_page.dart';

class CountriesListPage extends StatefulWidget {
  const CountriesListPage({super.key});

  @override
  State<CountriesListPage> createState() => _CountriesListPageState();
}

class _CountriesListPageState extends State<CountriesListPage> {
  late CountriesController controller;

  @override
  void initState() {
    super.initState();
    controller = CountriesController(
      GetAllCountriesUseCase(CountryRepositoryImpl(CountriesApiDataSource())),
    );
    controller.loadCountries();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Países del mundo'), centerTitle: true),
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, _) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage != null) {
            return Center(child: Text(controller.errorMessage!));
          }

          if (controller.countries.isEmpty) {
            return const Center(child: Text('No se encontraron países'));
          }

          return ListView.builder(
            itemCount: controller.countries.length,
            itemBuilder: (context, index) {
              final country = controller.countries[index];

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(country.flag),
                ),
                title: Text(country.name),
                subtitle: Text(country.region),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CountryDetailsPage(cca2: country.cca2),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
