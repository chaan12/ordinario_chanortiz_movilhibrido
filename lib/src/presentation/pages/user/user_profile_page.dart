import 'package:flutter/material.dart';
import '../../../data/session/user_session.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  final Color accentColor = const Color(0xFFF2994A);
  final Color darkBackgroundColor = const Color(0xFF0F2027);

  @override
  Widget build(BuildContext context) {
    final user = UserSession.user;

    // Manejo de estado nulo con el mismo fondo para consistencia
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
        // Padding superior para librar AppBar e inferior para librar el Navbar flotante
        padding: const EdgeInsets.fromLTRB(20, 110, 20, 160),
        child: Column(
          children: [
            // --- HEADER: FOTO Y NOMBRE ---
            Stack(
              alignment: Alignment.center,
              children: [
                // Brillo detrás de la foto
                Container(
                  width: 130,
                  height: 130,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accentColor.withOpacity(0.4),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                ),
                // Foto
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: accentColor, width: 3),
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(user.image),
                    onBackgroundImageError: (_, __) => const Icon(Icons.person),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Nombre
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
            
            // Username y Rol (Badge)
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
                    color: accentColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: accentColor.withOpacity(0.5)),
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

            // --- SECCIÓN 1: DATOS DE CONTACTO ---
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

            // --- SECCIÓN 2: DATOS PERSONALES ---
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

            // --- SECCIÓN 3: UBICACIÓN ---
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
            
            // Botón de Cerrar Sesión (Opcional, pero común en perfil)
            const SizedBox(height: 30),
            TextButton.icon(
              onPressed: () {
                UserSession.clear(); // 🔥 Cerrar sesión

                // Navegación limpia: elimina historial y vuelve al Login
                Navigator.pushNamedAndRemoveUntil(
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

  // --- WIDGETS AUXILIARES ---

  Widget _buildScaffold({required Widget body}) {
    return Scaffold(
      backgroundColor: darkBackgroundColor,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Pasaporte Digital",
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
          // Fondo
          Positioned.fill(
            child: Image.network(
              'https://images.unsplash.com/photo-1451187580459-43490279c0fa?q=80&w=2072&auto=format&fit=crop',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    darkBackgroundColor.withOpacity(0.8),
                    const Color(0xFF203A43).withOpacity(0.9),
                    const Color(0xFF2C5364).withOpacity(0.95),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center, // Alineado al centro verticalmente
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
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
      child: Divider(color: Colors.white.withOpacity(0.1), height: 1),
    );
  }
} 