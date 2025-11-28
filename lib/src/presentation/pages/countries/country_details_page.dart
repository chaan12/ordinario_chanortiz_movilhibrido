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

  final Color accentColor = const Color(0xFFF2994A);
  final Color darkBackgroundColor = const Color(0xFF0F2027);

  @override
  void initState() {
    super.initState();

    controller = CountryDetailsController(
      GetCountryDetailsUseCase(CountryRepositoryImpl(CountriesApiDataSource())),
    );

    controller.loadCountryDetails(widget.cca2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Ficha de País",
          style: TextStyle(color: Colors.white),
        ),
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
            animation: controller,
            builder: (context, _) {
              if (controller.isLoading) {
                return Center(
                  child: CircularProgressIndicator(color: accentColor),
                );
              }

              if (controller.errorMessage != null) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white54,
                        size: 50,
                      ),
                      Text(
                        controller.errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (controller.country == null) {
                return const Center(
                  child: Text(
                    "No hay datos",
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }

              final c = controller.country!;

              final languagesText = c.languages.values
                  .map((e) => e.toString())
                  .join(", ");

              final googleMapsLink = c.mapUrl;

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 140, 20, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // BANDERA
                    Container(
                      height: 160,
                      width: 260,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                        image: DecorationImage(
                          image: NetworkImage(c.flagPng),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Text(
                      c.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.5,
                      ),
                    ),

                    Text(
                      "${c.region} • ${c.subregion}",
                      style: TextStyle(
                        fontSize: 16,
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 30),

                    // TARJETA INFO
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  Icons.location_city,
                                  "Capital",
                                  c.capital,
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.white24,
                              ),
                              Expanded(
                                child: _buildInfoItem(
                                  Icons.groups,
                                  "Población",
                                  c.population.toString(),
                                ),
                              ),
                            ],
                          ),

                          const Divider(color: Colors.white24, height: 30),

                          Row(
                            children: [
                              Expanded(
                                child: _buildInfoItem(
                                  Icons.landscape,
                                  "Área",
                                  "${c.area} km²",
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.white24,
                              ),
                              Expanded(
                                child: _buildInfoItem(
                                  Icons.monetization_on_outlined,
                                  "Moneda",
                                  c.currencies.keys.join(", ")
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    _buildDetailRow(Icons.translate, "Idiomas", languagesText),
                    _buildDetailRow(
                      Icons.schedule,
                      "Zonas Horarias",
                      c.timezones.join("\n"),
                    ),

                    const SizedBox(height: 30),

                    // MAPAS
                    if (googleMapsLink.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: accentColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.map, color: accentColor),
                                const SizedBox(width: 10),
                                Text(
                                  "Ver en Google Maps",
                                  style: TextStyle(
                                    color: accentColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              googleMapsLink,
                              style: const TextStyle(
                                color: Colors.white38,
                                fontSize: 10,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String? value) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 8),
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Colors.white38,
            fontSize: 10,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value ?? "N/A",
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    if (value.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: accentColor, size: 20),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  value,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
