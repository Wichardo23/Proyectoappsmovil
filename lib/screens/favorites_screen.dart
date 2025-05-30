import 'package:flutter/material.dart';
import 'comidas_favoritas_screen.dart';
import 'ejercicios_favoritos_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final Map<String, dynamic> user;
  const FavoritesScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text(
                "❤️ Tus Favoritos",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView(
                  children: [
                    _favoriteCard(context, "Ejercicios", Icons.fitness_center),
                    _favoriteCard(context, "Comidas", Icons.restaurant),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _favoriteCard(BuildContext context, String title, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      child: ListTile(
        leading: Icon(icon, color: Colors.amber, size: 32),
        title: Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey),
        onTap: () async {
          final usuario = user['usuario'];
          if (title == "Ejercicios") {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EjerciciosFavoritosScreen(user: user)),
            );
          } else if (title == "Comidas") {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ComidasFavoritasScreen(user: user),
              ),
            );
          }
        },
      ),
    );
  }
}