import 'package:flutter/material.dart';
import '../countries/countries_list_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    print("HOME PAGE CARGADA");
    return Scaffold(
      appBar: AppBar(title: const Text("Inicio - Usuario")),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Text(
                "Bienvenido Usuario",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade50,
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.home, size: 28),
                      SizedBox(height: 4),
                      Text("Inicio"),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    print("ABRIENDO LISTA DE PAISES");
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CountriesListPage()),
                    );
                  },
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.public, size: 28),
                      SizedBox(height: 4),
                      Text("Países"),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite, size: 28),
                      SizedBox(height: 4),
                      Text("Favoritos"),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
