import 'package:flutter/material.dart';
import 'admin_dashboard_page.dart';
import 'admin_create_country_page.dart';
import 'admin_custom_countries_page.dart';
import 'delete_country_page.dart';
import '../../controllers/custom_countries_controller.dart';
import '../../../data/datasources/local/custom_countries_local_datasource.dart';

class AdminHomePage extends StatefulWidget {
  const AdminHomePage({super.key});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int selectedIndex = 0;
  bool isSidebarOpen = false;
  late CustomCountriesController customController;

  final List<Widget> pages = const [
    AdminDashboardPage(),
    AdminCreateCountryPage(),
    AdminCustomCountriesPage(),
    DeleteCountryPage(),
  ];

  final Color sidebarColor = const Color(0xFF0F2027);
  final Color accentColor = const Color(0xFFF2994A);

  final double sidebarOpenWidth = 260;
  final double sidebarClosedWidth = 80;

  void toggleSidebar() {
    setState(() {
      isSidebarOpen = !isSidebarOpen;
    });
  }

  @override
  void initState() {
    super.initState();
    customController = CustomCountriesController(CustomCountriesLocalDataSource());
    customController.loadCountries();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    if (args != null && args["page"] != null) {
      selectedIndex = args["page"];
    }

    customController.loadCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Row(
            children: [
              SizedBox(width: sidebarClosedWidth),
              Expanded(
                child: AnimatedBuilder(
                  animation: customController,
                  builder: (context, _) {
                    return IndexedStack(index: selectedIndex, children: pages);
                  },
                ),
              ),
            ],
          ),

          if (isSidebarOpen)
            Positioned(
              left: sidebarClosedWidth,
              right: 0,
              top: 0,
              bottom: 0,
              child: GestureDetector(
                onTap: toggleSidebar,
                child: Container(color: Colors.black.withValues(alpha: 0.5)),
              ),
            ),

          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: isSidebarOpen ? sidebarOpenWidth : sidebarClosedWidth,
            height: double.infinity,
            decoration: BoxDecoration(
              color: sidebarColor,
              border: Border(
                right: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 20,
                  offset: const Offset(5, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _buildSidebarHeader(),
                const SizedBox(height: 40),
                const Divider(color: Colors.white10, height: 1),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _navButton(0, "Dashboard", Icons.dashboard_rounded),
                        _navButton(1, "Crear País", Icons.add_location_alt_rounded),
                        _navButton(2, "Ver Creados", Icons.list_alt_rounded),
                        _navButton(3, "Papelera", Icons.delete_sweep_rounded),
                      ],
                    ),
                  ),
                ),
                _buildSidebarFooter(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHeader() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const NeverScrollableScrollPhysics(),
      child: Container(
        width: isSidebarOpen ? sidebarOpenWidth : sidebarClosedWidth,
        padding: EdgeInsets.symmetric(horizontal: isSidebarOpen ? 24 : 0),
        child: Row(
          mainAxisAlignment:
              isSidebarOpen ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
          children: [
            if (isSidebarOpen)
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: accentColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.public, color: accentColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "WORLD",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                      Text(
                        "ADMIN PANEL",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 9,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            IconButton(
              onPressed: toggleSidebar,
              icon: Icon(
                isSidebarOpen ? Icons.menu_open : Icons.menu,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton(int index, String label, IconData icon) {
    final bool active = selectedIndex == index;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          setState(() {
            selectedIndex = index;
          });

          if (index == 2 || index == 3) {
            await customController.loadCountries();
          }

          if (isSidebarOpen) toggleSidebar();
        },
        child: Container(
          width: double.infinity,
          height: 55,
          decoration: BoxDecoration(
            color: active ? accentColor.withValues(alpha: 0.15) : Colors.transparent,
            border: Border(
              left: BorderSide(
                color: active ? accentColor : Colors.transparent,
                width: 4,
              ),
            ),
          ),
          child: Row(
            mainAxisAlignment:
                isSidebarOpen ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: [
              SizedBox(width: isSidebarOpen ? 20 : 0),
              Icon(
                icon,
                color: active ? accentColor : Colors.white54,
                size: 24,
              ),
              if (isSidebarOpen) ...[
                const SizedBox(width: 16),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      color: active ? Colors.white : Colors.white70,
                      fontSize: 15,
                      fontWeight: active ? FontWeight.w600 : FontWeight.normal,
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarFooter() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: isSidebarOpen
          ? Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Admin",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "v1.0.0",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.4),
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          : const CircleAvatar(
              radius: 16,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, size: 16, color: Colors.white),
            ),
    );
  }
}
