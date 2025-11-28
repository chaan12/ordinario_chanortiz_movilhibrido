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

  List<String> deletedCountries = [];

  final Color accentColor = const Color(0xFFF2994A);

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
          "Dashboard Global",
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
                    const Color(0xFF0F2027).withOpacity(0.8),
                    const Color(0xFF203A43).withOpacity(0.9),
                    const Color(0xFF2C5364).withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),

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

                return ListView(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 120),
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildSectionTitle("Resumen General"),
                    _buildHeroCard(
                      label: "Total de Países",
                      value: "$totalCountries",
                      icon: Icons.public,
                    ),
                    const SizedBox(height: 20),

                    _buildSectionTitle("Métricas Detalladas"),
                    GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 15,
                      mainAxisSpacing: 15,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 1.1,
                      children: [
                        _buildSmallStatCard(
                          icon: Icons.map,
                          value: "$totalRegions",
                          label: "Regiones",
                          color: Colors.blueAccent,
                        ),
                        _buildSmallStatCard(
                          icon: Icons.translate,
                          value: "$totalLanguages",
                          label: "Idiomas",
                          color: Colors.purpleAccent,
                        ),
                        _buildSmallStatCard(
                          icon: Icons.favorite,
                          value: "$totalFavorites",
                          label: "Favoritos",
                          color: Colors.pinkAccent,
                        ),
                        _buildSmallStatCard(
                          icon: Icons.delete_outline,
                          value: "$totalDeleted",
                          label: "Eliminados",
                          color: Colors.orangeAccent,
                          isWarning: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),

                    _buildSectionTitle("Acciones Administrativas"),
                    _buildWideActionCard(
                      icon: Icons.settings_backup_restore,
                      title: "Gestión de Eliminación",
                      subtitle: "Restaurar o eliminar países permanentemente",
                      onTap: () {
                        Navigator.pushNamed(context, "/delete_country");
                      },
                    ),
                  ],
                );
              },
            ),
          ),

          Positioned(
            bottom: 30,
            left: 20,
            right: 20,
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
                gradient: LinearGradient(
                  colors: [Colors.red.shade900, Colors.red.shade700],
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(15),
                  onTap: () {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      "/login",
                      (route) => false,
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.logout, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        "CERRAR SESIÓN",
                        style: TextStyle(
                          color: Colors.white,
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
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 5),
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
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(color: Colors.white70, fontSize: 16),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: accentColor.withOpacity(0.2),
              shape: BoxShape.circle,
              border: Border.all(color: accentColor.withOpacity(0.5)),
            ),
            child: Icon(icon, color: accentColor, size: 35),
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
    bool isWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isWarning ? Colors.redAccent : color, size: 28),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.white38,
                  size: 14,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
