import 'package:flutter/material.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/presentation/controllers/countries_controller.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/presentation/controllers/deleted_countries_controller.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/datasources/local/deleted_countries_local_datasource.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/datasources/remote/countries_api_datasource.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/repositories_impl/country_repository_impl.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/domain/usecases/countries/get_all_countries_usecase.dart';

class DeleteCountryPage extends StatefulWidget {
  const DeleteCountryPage({super.key});

  @override
  State<DeleteCountryPage> createState() => _DeleteCountryPageState();
}

class _DeleteCountryPageState extends State<DeleteCountryPage> {
  late CountriesController countriesController;
  late DeletedCountriesController deletedController;
  String searchQuery = "";
  bool showOnlyDeleted = false;

  // Colores del tema
  final Color accentColor = const Color(0xFFF2994A);

  @override
  void initState() {
    super.initState();

    countriesController = CountriesController(
      GetAllCountriesUseCase(CountryRepositoryImpl(CountriesApiDataSource())),
    );

    deletedController = DeletedCountriesController(
      DeletedCountriesLocalDataSource(),
    );

    countriesController.loadCountries();
    deletedController.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Gestión de Eliminación",
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
                    const Color(0xFF0F2027).withOpacity(0.8),
                    const Color(0xFF203A43).withOpacity(0.9),
                    const Color(0xFF2C5364).withOpacity(0.95),
                  ],
                ),
              ),
            ),
          ),

          // 2. CONTENIDO
          SafeArea(
            child: Column(
              children: [
                // --- HEADER: BUSCADOR Y SWITCH ---
                _buildHeader(),

                // --- LISTA ---
                Expanded(
                  child: AnimatedBuilder(
                    animation: Listenable.merge([
                      countriesController,
                      deletedController,
                    ]),
                    builder: (context, _) {
                      if (countriesController.isLoading) {
                        return Center(
                          child: CircularProgressIndicator(color: accentColor),
                        );
                      }

                      // Lógica de filtrado
                      final allCountries = countriesController.allCountries;
                      final filtered = allCountries.where((c) {
                        final matchesSearch = c.name.toLowerCase().contains(
                          searchQuery,
                        );
                        final matchesDeleted = showOnlyDeleted
                            ? deletedController.isDeleted(c.cca2)
                            : true;
                        return matchesSearch && matchesDeleted;
                      }).toList();

                      if (filtered.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.filter_list_off,
                                size: 50,
                                color: Colors.white.withOpacity(0.3),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                "No se encontraron resultados",
                                style: TextStyle(
                                  color: Colors.white54,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        physics: const BouncingScrollPhysics(),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final country = filtered[index];
                          final isDeleted = deletedController.isDeleted(
                            country.cca2,
                          );

                          return _buildListItem(country, isDeleted);
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          // Buscador
          Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
            ),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              cursorColor: accentColor,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: "Buscar para eliminar...",
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: Icon(Icons.search, color: accentColor),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
              ),
            ),
          ),
          const SizedBox(height: 15),
          // Toggle Switch con diseño Glass
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: showOnlyDeleted
                  ? Colors.redAccent.withOpacity(0.1)
                  : Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: showOnlyDeleted
                    ? Colors.redAccent.withOpacity(0.3)
                    : Colors.white.withOpacity(0.1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.delete_sweep,
                      color: showOnlyDeleted
                          ? Colors.redAccent
                          : Colors.white70,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "Mostrar solo eliminados",
                      style: TextStyle(
                        color: showOnlyDeleted
                            ? Colors.redAccent
                            : Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Switch.adaptive(
                  value: showOnlyDeleted,
                  activeColor: Colors.redAccent,
                  activeTrackColor: Colors.redAccent.withOpacity(0.3),
                  inactiveTrackColor: Colors.grey.withOpacity(0.3),
                  onChanged: (value) {
                    setState(() {
                      showOnlyDeleted = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListItem(dynamic country, bool isDeleted) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(
        color: isDeleted
            ? Colors.red.withOpacity(0.1) // Fondo rojo suave si está eliminado
            : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDeleted
              ? Colors.redAccent.withOpacity(0.5)
              : Colors.white.withOpacity(0.15),
          width: isDeleted ? 1.5 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            // Bandera
            Container(
              width: 50,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                image: DecorationImage(
                  image: NetworkImage(country.flagPng), // Usando flagPng
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              // Filtro gris si está eliminado
              child: isDeleted
                  ? Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: Colors.black.withOpacity(0.5),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 15),

            // Textos
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    country.name,
                    style: TextStyle(
                      color: isDeleted ? Colors.white54 : Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: isDeleted
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isDeleted)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          "ELIMINADO",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Botón de Acción
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDeleted
                    ? Colors.green.withOpacity(0.2)
                    : Colors.red.withOpacity(0.2),
              ),
              child: IconButton(
                icon: Icon(
                  isDeleted ? Icons.restore_from_trash : Icons.delete_outline,
                  color: isDeleted ? Colors.greenAccent : Colors.redAccent,
                ),
                tooltip: isDeleted ? "Restaurar" : "Eliminar",
                onPressed: () {
                  deletedController.toggle(country.cca2);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
