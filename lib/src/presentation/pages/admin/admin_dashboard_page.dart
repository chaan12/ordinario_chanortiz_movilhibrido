import 'package:flutter/material.dart';

import '../../controllers/countries_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../../../data/datasources/remote/countries_api_datasource.dart';
import '../../../data/datasources/local/favorites_local_datasource.dart';
import '../../../domain/usecases/countries/get_all_countries_usecase.dart';
import '../../../data/repositories_impl/country_repository_impl.dart';
import '../../controllers/custom_countries_controller.dart';
import '../../../data/datasources/local/custom_countries_local_datasource.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late CountriesController countriesController;
  late FavoritesController favoritesController;
  late CustomCountriesController customController;

  final Color accentColor = const Color(0xFFF2994A);

  @override
  void initState() {
    super.initState();
    countriesController = CountriesController(
      GetAllCountriesUseCase(CountryRepositoryImpl(CountriesApiDataSource())),
    );
    favoritesController = FavoritesController(FavoritesLocalDataSource());
    customController = CustomCountriesController(
      CustomCountriesLocalDataSource(),
    );

    countriesController.loadCountries();
    favoritesController.loadFavorites();
    customController.loadCountries();
  }

  int countLanguages() {
    final all = countriesController.allCountries;
    final langs = <String>{};
    for (var c in all) {
      // ignore: avoid_function_literals_in_foreach_calls
      c.languages.values.forEach((lang) => langs.add(lang));
    }
    return langs.length;
  }

  int countRegions() {
    final all = countriesController.allCountries;
    final regs = <String>{};
    for (var c in all) {
      regs.add(c.region);
    }
    return regs.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Dashboard global",
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
          // 1. FONDO
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
                    const Color(0xFF0F2027).withValues(alpha: 0.8),
                    const Color(0xFF203A43).withValues(alpha: 0.9),
                    const Color(0xFF2C5364).withValues(alpha: 0.95),
                  ],
                ),
              ),
            ),
          ),

          // 2. CONTENIDO
          SafeArea(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                countriesController,
                favoritesController,
                customController,
              ]),
              builder: (context, _) {
                final totalCountries = countriesController.allCountries.length;
                final totalCreated = customController.customCountries.length;
                final totalFavorites = favoritesController.favorites.length;
                final totalLanguages = countLanguages();
                final totalRegions = countRegions();

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildSectionTitle("Vista General"),
                    _buildHeroCard(
                      label: "Total de Países",
                      value: "$totalCountries",
                      icon: Icons.public,
                    ),
                    const SizedBox(height: 25),

                    _buildSectionTitle("Métricas del Sistema"),

                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      // AQUÍ ESTÁ EL ARREGLO DEL OVERFLOW:
                      // 0.85 hace las tarjetas más altas verticalmente
                      childAspectRatio: 0.85,
                      children: [
                        _buildSmallStatCard(
                          icon: Icons.add_location_alt,
                          value: "$totalCreated",
                          label: "Creados manualmente",
                          color: Colors.greenAccent,
                        ),
                        _buildSmallStatCard(
                          icon: Icons.map,
                          value: "$totalRegions",
                          label: "Regiones globales",
                          color: Colors.blueAccent,
                        ),
                        _buildSmallStatCard(
                          icon: Icons.translate,
                          value: "$totalLanguages",
                          label: "Idiomas registrados",
                          color: Colors.purpleAccent,
                        ),
                        _buildSmallStatCard(
                          icon: Icons.favorite,
                          value: "$totalFavorites",
                          label: "Favoritos totales",
                          color: Colors.pinkAccent,
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    _buildLogoutButton(context),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGETS DE UI ---

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 5),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: accentColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildHeroCard({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 42,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
              border: Border.all(color: accentColor.withValues(alpha: 0.3)),
              boxShadow: [
                BoxShadow(color: accentColor.withValues(alpha: 0.2), blurRadius: 15),
              ],
            ),
            child: Icon(icon, color: accentColor, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),

          // FittedBox ayuda a que el número no desborde si es muy grande
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.redAccent.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/login",
              (route) => false,
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
              gradient: LinearGradient(
                colors: [
                  Colors.red.withValues(alpha: 0.2),
                  Colors.red.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.logout_rounded, color: Colors.redAccent),
                SizedBox(width: 12),
                Text(
                  "Cerrar Sesión",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
