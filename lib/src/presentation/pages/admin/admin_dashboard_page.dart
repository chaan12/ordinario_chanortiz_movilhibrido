import 'package:flutter/material.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/presentation/controllers/countries_controller.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/presentation/controllers/favorites_controller.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/datasources/remote/countries_api_datasource.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/datasources/local/favorites_local_datasource.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/domain/usecases/countries/get_all_countries_usecase.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/repositories_impl/country_repository_impl.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  late CountriesController countriesController;
  late FavoritesController favoritesController;

  // lista local de países "eliminados"
  List<String> deletedCountries = [];

  // Colores del tema
  final Color accentColor = const Color(0xFFF2994A);
  final Color darkGlassColor = const Color(0xFF1A2A33).withOpacity(0.95);

  @override
  void initState() {
    super.initState();
    countriesController = CountriesController(
      GetAllCountriesUseCase(CountryRepositoryImpl(CountriesApiDataSource())),
    );
    favoritesController = FavoritesController(FavoritesLocalDataSource());
    countriesController.loadCountries();
    favoritesController.loadFavorites();
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
          "Centro de Comando",
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
          // 1. FONDO (Imagen + Gradiente)
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
                    const Color(0xFF0F2027).withOpacity(0.8),
                    const Color(0xFF203A43).withOpacity(0.9),
                    const Color(0xFF2C5364).withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),

          // 2. CONTENIDO GRID
          SafeArea(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                countriesController,
                favoritesController,
              ]),
              builder: (context, _) {
                final totalCountries = countriesController.allCountries.length;
                final totalFavorites = favoritesController.favorites.length;
                final totalLanguages = countLanguages();
                final totalRegions = countRegions();
                final totalDeleted = deletedCountries.length;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 10,
                  ),
                  child: GridView(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 15,
                          childAspectRatio: 0.85, // Tarjetas un poco más altas
                        ),
                    children: [
                      _buildStatCard(
                        icon: Icons.public,
                        value: totalCountries.toString(),
                        label: "Países Totales",
                      ),
                      _buildStatCard(
                        icon: Icons.map,
                        value: totalRegions.toString(),
                        label: "Regiones",
                      ),
                      _buildStatCard(
                        icon: Icons.favorite,
                        value: totalFavorites.toString(),
                        label: "Favoritos",
                      ),
                      _buildStatCard(
                        icon: Icons.translate,
                        value: totalLanguages.toString(),
                        label: "Idiomas",
                      ),
                      _buildStatCard(
                        icon: Icons.delete_outline,
                        value: totalDeleted.toString(),
                        label: "Eliminados",
                        isWarning: true,
                      ),
                      _buildActionCard(
                        icon: Icons.remove_circle_outline,
                        label: "Gestión de\nEliminación",
                        onTap: () {
                          // Navegar a tu ruta de eliminar
                          // Navigator.pushNamed(context, "/delete_country");
                          // Ejemplo visual temporal:
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Navegando a eliminar..."),
                              backgroundColor: accentColor,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- TARJETA DE ESTADÍSTICAS (KPI) ---
  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    bool isWarning = false,
  }) {
    final color = isWarning ? Colors.redAccent : accentColor;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icono en círculo
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),

            // Textos
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // --- TARJETA DE ACCIÓN (BOTÓN) ---
  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          // Gradiente sutil para diferenciar que es interactivo
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.redAccent.withOpacity(0.2),
              Colors.redAccent.withOpacity(0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.redAccent.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.redAccent),
              const SizedBox(height: 15),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Icon(Icons.arrow_forward, color: Colors.white54, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
