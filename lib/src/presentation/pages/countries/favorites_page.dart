import 'package:flutter/material.dart';
import '../../../data/datasources/local/favorites_local_datasource.dart';
import '../../../data/datasources/remote/countries_api_datasource.dart';
import '../../../data/repositories_impl/country_repository_impl.dart';
import '../../../domain/usecases/countries/get_all_countries_usecase.dart';
import '../../../data/datasources/local/custom_countries_local_datasource.dart';
import '../../../data/models/custom_country_model.dart';
import '../../../domain/entities/country_entity.dart';
import '../../controllers/favorites_controller.dart';
import '../../controllers/countries_controller.dart';
import 'country_details_page.dart';
import 'custom_country_details_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late FavoritesController favController;
  late CountriesController countriesController;

  late CustomCountriesLocalDataSource customDataSource;
  List<CustomCountryModel> customCountries = [];

  final Color accentColor = const Color(0xFFF2994A);
  final Color darkBackgroundColor = const Color(0xFF0F2027);

  @override
  void initState() {
    super.initState();

    favController = FavoritesController(FavoritesLocalDataSource());
    countriesController = CountriesController(
      GetAllCountriesUseCase(CountryRepositoryImpl(CountriesApiDataSource())),
    );

    favController.loadFavorites();
    countriesController.loadCountries();

    customDataSource = CustomCountriesLocalDataSource();
    _loadCustomCountries();
  }

  Future<void> _loadCustomCountries() async {
    customCountries = await customDataSource.getCountries();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Mi colección',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=2072&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    darkBackgroundColor.withValues(alpha: 0.8),
                    const Color(0xFF203A43).withValues(alpha: 0.9),
                    const Color(0xFF2C5364).withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),
          AnimatedBuilder(
            animation: Listenable.merge([favController, countriesController]),
            builder: (context, _) {
              final favorites = favController.favorites;
              final countries = countriesController.allCountries;

              if (favorites.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 60,
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Aún no tienes favoritos",
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                    ],
                  ),
                );
              }

              final favoriteApiCountries = countries.where((c) => favorites.contains(c.cca2)).toList();
              final favoriteCustomCountries = customCountries.where((c) => favorites.contains(c.id)).toList();

              // Combine both
              final allFavoriteCountries = [...favoriteApiCountries, ...favoriteCustomCountries];

              // Si los países aún no cargan → loading real
              if (countries.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              // Si ya cargaron y no hay favoritos → mensaje amigable
              if (allFavoriteCountries.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite_border,
                        size: 60,
                        color: Colors.white54,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Aún no tienes favoritos",
                        style: TextStyle(fontSize: 18, color: Colors.white70),
                      ),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.fromLTRB(20, 140, 20, 20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                  childAspectRatio: 0.8,
                ),
                itemCount: allFavoriteCountries.length,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = allFavoriteCountries[index];

                  return GestureDetector(
                    onTap: () {
                      if (item is CustomCountryModel) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CustomCountryDetailsPage(country: item),
                          ),
                        );
                      } else if (item is CountryEntity) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CountryDetailsPage(cca2: item.cca2),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            flex: 3,
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(19),
                                    ),
                                    image: DecorationImage(
                                      // CORRECCIÓN AQUÍ: flagPng en lugar de flag
                                      image: NetworkImage(item is CustomCountryModel ? item.flagUrl : (item as CountryEntity).flagPng),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 8,
                                  right: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(alpha: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.favorite,
                                      color: accentColor,
                                      size: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    item is CustomCountryModel ? item.name : (item as CountryEntity).name,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item is CustomCountryModel ? item.region : (item as CountryEntity).region,
                                    style: TextStyle(
                                      color: accentColor,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
