import 'package:flutter/material.dart';
import '../../../data/session/user_session.dart';
import '../../../data/datasources/local/favorites_local_datasource.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  final Color accentColor = const Color(0xFFF2994A);
  final Color darkBackgroundColor = const Color(0xFF0F2027);

  @override
  Widget build(BuildContext context) {
    final user = UserSession.user;

    if (user == null) {
      return _buildScaffold(
        body: const Center(
          child: Text(
            "Sesión no iniciada",
            style: TextStyle(color: Colors.white70, fontSize: 18),
          ),
        ),
      );
    }

    return _buildScaffold(
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 110, 20, 160),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(user.image),
                    // ignore: unnecessary_underscores
                    onBackgroundImageError: (_, __) => const Icon(Icons.person),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            Text(
              "${user.firstName} ${user.lastName}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "@${user.username}",
                  style: const TextStyle(color: Colors.white54, fontSize: 16),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accentColor.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    user.role.toUpperCase(),
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),

            _buildSectionHeader("Identidad & Contacto"),
            _buildGlassCard(
              children: [
                _buildInfoRow(Icons.email_outlined, "Correo", user.email),
                _buildDivider(),
                _buildInfoRow(Icons.phone_iphone, "Teléfono", user.phone),
                _buildDivider(),
                _buildInfoRow(Icons.fingerprint, "ID Usuario", "#${user.id}"),
              ],
            ),

            const SizedBox(height: 25),

            _buildSectionHeader("Información Personal"),
            _buildGlassCard(
              children: [
                Row(
                  children: [
                    Expanded(child: _buildInfoRow(Icons.cake_outlined, "Edad", "${user.age} años")),
                    Expanded(child: _buildInfoRow(Icons.person_outline, "Género", user.gender)),
                  ],
                ),
                _buildDivider(),
                Row(
                  children: [
                    Expanded(child: _buildInfoRow(Icons.calendar_month, "Nacimiento", user.birthDate)),
                    Expanded(child: _buildInfoRow(Icons.face, "Cabello", user.hair["type"])),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 25),

            _buildSectionHeader("Ubicación Actual"),
            _buildGlassCard(
              children: [
                _buildInfoRow(Icons.public, "País", user.address["country"]),
                _buildDivider(),
                _buildInfoRow(Icons.location_city, "Ciudad", "${user.address["city"]}, ${user.address["state"]}"),
                _buildDivider(),
                _buildInfoRow(Icons.markunread_mailbox_outlined, "Código Postal", user.address["postalCode"]),
              ],
            ),
            
            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: () async {
                final favorites = FavoritesLocalDataSource();
                await favorites.clearFavorites();

                UserSession.clear();

                Navigator.pushNamedAndRemoveUntil(
                  // ignore: use_build_context_synchronously
                  context,
                  '/login',
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout, color: Colors.redAccent),
              label: const Text(
                "Cerrar Sesión",
                style: TextStyle(color: Colors.redAccent),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScaffold({required Widget body}) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Pasaporte digital",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2
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
          body,
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 10),
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

  Widget _buildGlassCard({required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white70, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white38,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Divider(color: Colors.white.withValues(alpha: 0.1), height: 1),
    );
  }
} 