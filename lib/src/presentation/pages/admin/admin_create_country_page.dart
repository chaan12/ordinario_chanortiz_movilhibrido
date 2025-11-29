import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../presentation/controllers/custom_countries_controller.dart';
import '../../../data/datasources/local/custom_countries_local_datasource.dart';

class AdminCreateCountryPage extends StatefulWidget {
  const AdminCreateCountryPage({super.key});

  @override
  State<AdminCreateCountryPage> createState() => _AdminCreateCountryPageState();
}

class _AdminCreateCountryPageState extends State<AdminCreateCountryPage> {
  final nameController = TextEditingController();
  final capitalController = TextEditingController();
  final flagController = TextEditingController();
  final populationController = TextEditingController();
  final areaController = TextEditingController();
  final langController = TextEditingController();
  final currencyController = TextEditingController();

  String? selectedRegion;
  final List<String> languages = [];
  final List<String> currencies = [];

  late CustomCountriesController controller;

  final List<String> regions = [
    "Africa",
    "Americas",
    "Asia",
    "Europe",
    "Oceania",
    "Polar",
  ];

  final Color accentColor = const Color(0xFFF2994A);
  final Color darkBackgroundColor = const Color(0xFF0F2027);

  @override
  void initState() {
    super.initState();
    controller = CustomCountriesController(CustomCountriesLocalDataSource());
  }


  void _addLanguage() {
    final text = langController.text.trim();
    if (text.isNotEmpty && !languages.contains(text)) {
      setState(() => languages.add(text));
      langController.clear();
    }
  }

  void _addCurrency() {
    final text = currencyController.text.trim();
    if (text.isNotEmpty && !currencies.contains(text)) {
      setState(() => currencies.add(text));
      currencyController.clear();
    }
  }

  void _saveCountry() async {
    final name = nameController.text.trim();
    final flagUrl = flagController.text.trim();
    final capital = capitalController.text.trim();
    final population = int.tryParse(populationController.text.trim()) ?? 0;
    final area = double.tryParse(areaController.text.trim()) ?? 0.0;

    if (name.isEmpty ||
        selectedRegion == null ||
        capital.isEmpty ||
        flagUrl.isEmpty ||
        population == 0 ||
        area == 0 ||
        languages.isEmpty ||
        currencies.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            "Por favor, completa todos los campos requeridos.",
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    await controller.addCountry(
      name: name,
      region: selectedRegion!,
      flagUrl: flagUrl,
      capital: capital,
      population: population,
      area: area,
      languages: List.from(languages),
      currencies: List.from(currencies),
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text("¡País creado exitosamente!"),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    setState(() {
      nameController.clear();
      capitalController.clear();
      flagController.clear();
      populationController.clear();
      areaController.clear();
      languages.clear();
      currencies.clear();
      selectedRegion = null;
    });

    Navigator.pushReplacementNamed(
      context,
      "/admin_home",
      arguments: {"page": 2},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacementNamed(
              context,
              "/admin_home",
              arguments: {"page": 2},
            );
          },
        ),
        title: const Text(
          "Crear país",
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 600;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 100),
                  child: Column(
                    children: [
                      _buildSectionTitle("Datos Generales"),
                      if (isWide)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: _buildGlassTextField(
                                "Nombre Oficial",
                                nameController,
                                Icons.public,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(child: _buildGlassDropdown()),
                          ],
                        )
                      else ...[
                        _buildGlassTextField(
                          "Nombre Oficial",
                          nameController,
                          Icons.public,
                        ),
                        const SizedBox(height: 15),
                        _buildGlassDropdown(),
                      ],

                      const SizedBox(height: 15),

                      if (isWide)
                        Row(
                          children: [
                            Expanded(
                              child: _buildGlassTextField(
                                "Capital",
                                capitalController,
                                Icons.location_city,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildGlassTextField(
                                "URL Bandera",
                                flagController,
                                Icons.flag,
                              ),
                            ),
                          ],
                        )
                      else ...[
                        _buildGlassTextField(
                          "Capital",
                          capitalController,
                          Icons.location_city,
                        ),
                        const SizedBox(height: 15),
                        _buildGlassTextField(
                          "URL Bandera",
                          flagController,
                          Icons.flag,
                        ),
                      ],

                      const SizedBox(height: 25),

                      _buildSectionTitle("Estadísticas"),
                      if (isWide)
                        Row(
                          children: [
                            Expanded(
                              child: _buildGlassTextField(
                                "Población",
                                populationController,
                                Icons.groups,
                                isNumber: true,
                              ),
                            ),
                            const SizedBox(width: 15),
                            Expanded(
                              child: _buildGlassTextField(
                                "Área (km²)",
                                areaController,
                                Icons.landscape,
                                isNumber: true,
                              ),
                            ),
                          ],
                        )
                      else ...[
                        _buildGlassTextField(
                          "Población",
                          populationController,
                          Icons.groups,
                          isNumber: true,
                        ),
                        const SizedBox(height: 15),
                        _buildGlassTextField(
                          "Área (km²)",
                          areaController,
                          Icons.landscape,
                          isNumber: true,
                        ),
                      ],

                      const SizedBox(height: 25),

                      _buildSectionTitle("Detalles Culturales"),
                      _buildListInput(
                        label: "Idiomas Oficiales",
                        controller: langController,
                        onAdd: _addLanguage,
                        items: languages,
                        icon: Icons.translate,
                      ),
                      const SizedBox(height: 20),
                      _buildListInput(
                        label: "Monedas",
                        controller: currencyController,
                        onAdd: _addCurrency,
                        items: currencies,
                        icon: Icons.monetization_on,
                      ),

                      const SizedBox(height: 40),

                      _buildSaveButton(),
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
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15, left: 5),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: TextStyle(
            color: accentColor,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassTextField(
    String label,
    TextEditingController controller,
    IconData icon, {
    bool isNumber = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.white),
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        inputFormatters: isNumber
            ? [FilteringTextInputFormatter.digitsOnly]
            : [],
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
          prefixIcon: Icon(icon, color: Colors.white54),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedRegion,
          dropdownColor: const Color(0xFF203A43),
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          hint: Row(
            children: const [
              Icon(Icons.map, color: Colors.white54),
              SizedBox(width: 12),
              Text(
                "Seleccionar Región",
                style: TextStyle(color: Colors.white60),
              ),
            ],
          ),
          isExpanded: true,
          items: regions
              .map(
                (r) => DropdownMenuItem(
                  value: r,
                  child: Text(r, style: const TextStyle(color: Colors.white)),
                ),
              )
              .toList(),
          onChanged: (value) => setState(() => selectedRegion = value),
        ),
      ),
    );
  }

  Widget _buildListInput({
    required String label,
    required TextEditingController controller,
    required VoidCallback onAdd,
    required List<String> items,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: TextField(
                  controller: controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Agregar $label...",
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    prefixIcon: Icon(icon, color: Colors.white54),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                  onSubmitted: (_) => onAdd(),
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              onTap: onAdd,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: accentColor.withValues(alpha: 0.5)),
                ),
                child: Icon(Icons.add, color: accentColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: items
              .map(
                (e) => Chip(
                  label: Text(e),
                  backgroundColor: accentColor.withValues(alpha: 0.2),
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                  deleteIcon: const Icon(
                    Icons.close,
                    size: 16,
                    color: Colors.white70,
                  ),
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  onDeleted: () => setState(() => items.remove(e)),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(colors: [accentColor, Colors.orangeAccent]),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.4),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _saveCountry,
          borderRadius: BorderRadius.circular(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.save_as_rounded, color: Colors.white),
              SizedBox(width: 10),
              Text(
                "REGISTRAR PAÍS",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
