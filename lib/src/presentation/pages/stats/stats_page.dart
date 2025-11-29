import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:ordinario_chanortiz_movilhibrido/src/presentation/controllers/countries_controller.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/presentation/controllers/favorites_controller.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/datasources/local/favorites_local_datasource.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/datasources/remote/countries_api_datasource.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/data/repositories_impl/country_repository_impl.dart';
import 'package:ordinario_chanortiz_movilhibrido/src/domain/usecases/countries/get_all_countries_usecase.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  late CountriesController countriesController;
  late FavoritesController favoritesController;

  final Color accentColor = const Color(0xFFF2994A);
  final Color darkBackgroundColor = const Color(0xFF0F2027);

  final List<Color> chartColors = [
    const Color(0xFFF2994A),
    const Color(0xFF00E5FF),
    const Color(0xFF9D50BB),
    const Color(0xFF00E676),
    const Color(0xFFFF4081),
    const Color(0xFFFFD740),
    const Color(0xFF651FFF),
  ];

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

  @override
  void dispose() {
    countriesController.dispose();
    favoritesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Estadísticas globales",
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

          SafeArea(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                countriesController,
                favoritesController,
              ]),
              builder: (context, _) {
                if (countriesController.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(color: accentColor),
                  );
                }

                if (countriesController.errorMessage != null) {
                  return Center(
                    child: Text(
                      countriesController.errorMessage!,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                final totalCountries = countriesController.allCountries.length;
                final countriesPerRegion = countriesController
                    .getCountriesPerRegion();
                final languagesPerRegion = Map.fromEntries(
                  countriesController.getLanguagesPerRegion().entries.take(7),
                );
                final topLanguages = countriesController.getTopLanguages();
                final topCurrencies = countriesController.getTopCurrencies();

                final favoritesCount = favoritesController.favorites.length;
                final nonFavoritesCount = totalCountries > favoritesCount
                    ? totalCountries - favoritesCount
                    : 0;

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildHeaderSummary(
                        totalCountries: totalCountries,
                        favoritesCount: favoritesCount,
                      ),
                      const SizedBox(height: 25),

                      _buildGlassCard(
                        title: "Distribución por Región",
                        subtitle: "Cantidad de países",
                        child: AspectRatio(
                          aspectRatio: 1.5,
                          child: BarChart(
                            _buildBarChartDataFromMap(countriesPerRegion),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildGlassCard(
                        title: "Idiomas Distintos",
                        subtitle: "Por región geográfica (Top 7)",
                        child: AspectRatio(
                          aspectRatio: 1.5,
                          child: BarChart(
                            _buildBarChartDataFromMap(languagesPerRegion),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      _buildGlassCard(
                        title: "Idiomas Más Hablados",
                        subtitle: "Top 5 a nivel mundial",
                        child: _buildDonutChartWithLegend(topLanguages),
                      ),
                      const SizedBox(height: 20),

                      _buildGlassCard(
                        title: "Monedas Dominantes",
                        subtitle: "Divisas más utilizadas",
                        child: _buildDonutChartWithLegend(topCurrencies),
                      ),
                      const SizedBox(height: 20),

                      _buildGlassCard(
                        title: "Ratio de Favoritos",
                        subtitle: "Tu colección vs El mundo",
                        child: _buildDonutChartWithLegend({
                          "En Colección": favoritesCount,
                          "Por Descubrir": nonFavoritesCount,
                        }, isFavoriteChart: true),
                      ),
                      const SizedBox(height: 30),
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


  Widget _buildGlassCard({
    required String title,
    String? subtitle,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ],
          const SizedBox(height: 25),
          child,
        ],
      ),
    );
  }

  Widget _buildHeaderSummary({
    required int totalCountries,
    required int favoritesCount,
  }) {
    return Row(
      children: [
        Expanded(
          child: _smallStat(
            icon: Icons.public,
            label: "Total Países",
            value: totalCountries.toString(),
            color: Colors.cyanAccent,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: _smallStat(
            icon: Icons.favorite,
            label: "Favoritos",
            value: favoritesCount.toString(),
            color: accentColor,
          ),
        ),
      ],
    );
  }

  Widget _smallStat({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  BarChartData _buildBarChartDataFromMap(Map<String, int> data) {
    final entries = data.entries.toList();
    double maxY = 0;
    for (var e in entries) {
      if (e.value > maxY) maxY = e.value.toDouble();
    }
    maxY += 5;

    return BarChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: maxY / 5,
        getDrawingHorizontalLine: (value) =>
            FlLine(color: Colors.white.withValues(alpha: 0.05), strokeWidth: 1),
      ),
      borderData: FlBorderData(show: false),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: maxY / 5,
            getTitlesWidget: (value, meta) {
              if (value == 0) return const SizedBox.shrink();
              return Text(
                value.toInt().toString(),
                style: const TextStyle(color: Colors.white38, fontSize: 10),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= entries.length)
                // ignore: curly_braces_in_flow_control_structures
                return const SizedBox.shrink();

              final text = entries[index].key.length > 3
                  ? entries[index].key.substring(0, 3).toUpperCase()
                  : entries[index].key.toUpperCase();

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      barGroups: List.generate(entries.length, (index) {
        final e = entries[index];
        final color = chartColors[index % chartColors.length];

        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: e.value.toDouble(),
              width: 14,
              gradient: LinearGradient(
                colors: [color.withValues(alpha: 0.8), color],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(6),
              ),
              backDrawRodData: BackgroundBarChartRodData(
                show: true,
                toY: maxY,
                color: Colors.white.withValues(alpha: 0.02),
              ),
            ),
          ],
        );
      }),
      maxY: maxY,
    );
  }

  Widget _buildDonutChartWithLegend(
    Map<String, int> data, {
    bool isFavoriteChart = false,
  }) {
    if (data.isEmpty) {
      return const Center(
        child: Text("Sin datos", style: TextStyle(color: Colors.white54)),
      );
    }

    final total = data.values.fold<int>(0, (p, c) => p + c);
    final entries = data.entries.toList();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sectionsSpace: 4,
              centerSpaceRadius: 50,
              sections: List.generate(entries.length, (index) {
                final e = entries[index];
                final isSelected = false;
                // ignore: dead_code
                final radius = isSelected ? 60.0 : 50.0;
                Color color;
                if (isFavoriteChart) {
                  color = index == 0
                      ? accentColor
                      : Colors.white.withValues(alpha: 0.1);
                } else {
                  color = chartColors[index % chartColors.length];
                }

                return PieChartSectionData(
                  color: color,
                  value: e.value.toDouble(),
                  title: '${(e.value / total * 100).toStringAsFixed(0)}%',
                  radius: radius,
                  titleStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
                  ),
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 20),

        Wrap(
          spacing: 16,
          runSpacing: 10,
          alignment: WrapAlignment.center,
          children: List.generate(entries.length, (index) {
            final e = entries[index];
            Color color;
            if (isFavoriteChart) {
              color = index == 0 ? accentColor : Colors.white.withValues(alpha: 0.1);
            } else {
              color = chartColors[index % chartColors.length];
            }

            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  e.key,
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                Text(
                  " (${e.value})",
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
