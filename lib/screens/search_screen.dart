import 'package:flutter/material.dart';
import 'ejercicios_screen.dart';
import 'alimentacion_screen.dart';
import 'progreso_screen.dart';
import 'sueno_screen.dart';
import 'suplementos_screen.dart';

class SearchScreen extends StatelessWidget {
  final Map<String, dynamic> user;

  const SearchScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola ${user['usuario']}, ¿Listo/a para iniciar?',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIconButton(
                        context,
                        icon: Icons.fitness_center,
                        label: 'Ejercicios',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EjerciciosScreen(user: user)),
                          );
                        },
                        size: 64,
                      ),
                      const SizedBox(width: 40),
                      _buildIconButton(
                        context,
                        icon: Icons.restaurant_menu,
                        label: 'Comidas',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AlimentacionScreen(user: user),
                            ),
                          );
                        },
                        size: 64,
                      ),
                      const SizedBox(width: 40),
                      _buildIconButton(
                        context,
                        icon: Icons.insert_chart,
                        label: 'Progreso',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProgresoScreen(user: user),
                            ),
                          );
                        },
                        size: 64,
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildIconButton(
                        context,
                        icon: Icons.bedtime,
                        label: 'Sueño',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SuenoScreen(user: user)),
                          );
                        },
                        size: 64,
                      ),
                      const SizedBox(width: 40),
                      _buildIconButton(
                        context,
                        icon: Icons.medical_services,
                        label: 'Suplementos',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const SuplementosScreen()),
                          );
                        },
                        size: 64,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onTap,
      double size = 48}) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.amber, size: size),
          onPressed: onTap,
          iconSize: size,
        ),
        const SizedBox(height: 6),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}
