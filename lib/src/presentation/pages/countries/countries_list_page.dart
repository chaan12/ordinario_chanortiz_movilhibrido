import 'package:flutter/material.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/presentation/controllers/countries_controller.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/presentation/controllers/favorites_controller.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/datasources/local/favorites_local_datasource.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/datasources/local/deleted_countries_local_datasource.dart';
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
  late FavoritesController favController;

  final deletedDataSource = DeletedCountriesLocalDataSource();
  List<String> deletedCountries = [];

  final Color accentColor = const Color(0xFFF2994A);
  final Color darkGlassColor = const Color(0xFF1A2A33).withValues(alpha: 0.95);

  @override
  void initState() {
    super.initState();
    controller = CountriesController(
      GetAllCountriesUseCase(CountryRepositoryImpl(CountriesApiDataSource())),
    );
    favController = FavoritesController(FavoritesLocalDataSource());
    favController.loadFavorites();
    controller.loadCountries();
    Future.microtask(() async {
      deletedCountries = await deletedDataSource.getDeleted();
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller.dispose();
    favController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Destinos del mundo',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
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

          // 2. CONTENIDO PRINCIPAL
          SafeArea(
            child: Column(
              children: [
                // --- BARRA DE BÚSQUEDA Y FILTROS ---
                _buildSearchAndFilterHeader(),

                // --- LISTA DE PAÍSES ---
                Expanded(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([controller, favController]),
                    builder: (context, _) {
                      if (controller.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(color: accentColor),
                        );
                      }

                      if (controller.errorMessage != null) {
                        return _buildErrorView();
                      }

                      if (controller.filteredCountries.isEmpty) {
                        return _buildEmptyView();
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 10,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: controller.filteredCountries.length,
                        itemBuilder: (context, index) {
                          final country = controller.filteredCountries[index];
                          if (deletedCountries.contains(country.cca2)) {
                            return const SizedBox.shrink();
                          }
                          return _buildCountryItem(country);
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- HEADER PERSONALIZADO ---
  Widget _buildSearchAndFilterHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // Buscador
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
            ),
            child: TextField(
              onChanged: (value) => controller.updateSearch(value),
              style: const TextStyle(color: Colors.white),
              cursorColor: accentColor,
              decoration: InputDecoration(
                hintText: "Buscar destino...",
                hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                prefixIcon: Icon(Icons.search, color: accentColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Botones de Acción
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.tune_rounded,
                  label: "Filtros",
                  onTap: () => _openFiltersModal(context),
                  // Activo si hay algún filtro seleccionado
                  isActive:
                      controller.selectedRegions.isNotEmpty ||
                      controller.selectedLanguages.isNotEmpty ||
                      controller.selectedCurrencies.isNotEmpty,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildActionButton(
                  icon: Icons.sort_rounded,
                  label: "Ordenar",
                  onTap: () => _openSortModal(context),
                  isActive: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 45,
        decoration: BoxDecoration(
          color: isActive
              ? accentColor.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isActive ? accentColor : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? accentColor : Colors.white70,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isActive ? accentColor : Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --- ITEM DE PAÍS ---
  Widget _buildCountryItem(dynamic country) {
    bool isFav = favController.isFavorite(country.cca2);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CountryDetailsPage(cca2: country.cca2),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Hero(
                  tag: country.cca2,
                  child: Container(
                    width: 60,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(country.flagPng),
                        fit: BoxFit.cover,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        country.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.public, size: 12, color: accentColor),
                          const SizedBox(width: 4),
                          Text(
                            country.region,
                            style: TextStyle(color: accentColor, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.redAccent : Colors.white38,
                  ),
                  onPressed: () => favController.toggleFavorite(country.cca2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- MODAL DE FILTROS CORREGIDO ---
  void _openFiltersModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F2027),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      isScrollControlled: true,
      builder: (_) {
        // StatefulBuilder nos da un 'setModalState' único para el modal
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
              height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      margin: const EdgeInsets.only(bottom: 20),
                    ),
                  ),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Refinar Búsqueda",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Listo",
                          style: TextStyle(color: accentColor),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white10),

                  Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        // AQUÍ PASAMOS setModalState DENTRO DEL CALLBACK
                        _buildFilterSection(
                          "Región",
                          ["Africa", "Americas", "Asia", "Europe", "Oceania"],
                          controller.selectedRegions,
                          (option) {
                            setModalState(() {
                              controller.toggleRegion(option);
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildFilterSection(
                          "Idioma (ISO)",
                          ["eng", "spa", "fra", "ara", "zho", "rus", "deu"],
                          controller.selectedLanguages,
                          (option) {
                            setModalState(() {
                              controller.toggleLanguage(option);
                            });
                          },
                        ),
                        const SizedBox(height: 20),
                        _buildFilterSection(
                          "Moneda",
                          ["USD", "EUR", "MXN", "GBP", "JPY"],
                          controller.selectedCurrencies,
                          (option) {
                            setModalState(() {
                              controller.toggleCurrency(option);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- WIDGET REUTILIZABLE CON CALLBACK ---
  Widget _buildFilterSection(
    String title,
    List<String> options,
    List<String> selectedList,
    Function(String) onToggle, // Nuevo parámetro para manejar la acción
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedList.contains(option);
            return GestureDetector(
              onTap: () {
                // Llamamos a la función que contiene el setModalState
                onToggle(option);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? accentColor.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? accentColor
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // --- MODAL DE ORDENAMIENTO ---
  void _openSortModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0F2027),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Ordenar Resultados",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildSortOption("Nombre (A - Z)", "name", Icons.arrow_downward),
              _buildSortOption(
                "Nombre (Z - A)",
                "name_desc",
                Icons.arrow_upward,
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSortOption(String text, String value, IconData icon) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.white70, size: 20),
      ),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white24),
      onTap: () {
        controller.setOrder(value);
        Navigator.pop(context);
      },
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 60,
            color: Colors.white.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 10),
          const Text(
            'No se encontraron destinos',
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, color: Colors.redAccent, size: 50),
          const SizedBox(height: 10),
          Text(
            controller.errorMessage!,
            style: const TextStyle(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
