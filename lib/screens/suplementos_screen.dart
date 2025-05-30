import 'package:flutter/material.dart';

class SuplementosScreen extends StatelessWidget {
  const SuplementosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> suplementos = [
      {
        'nombre': 'Proteína',
        'descripcion':
            'Ayuda a la recuperación y crecimiento muscular. Ideal para cubrir requerimientos diarios de proteína.',
        'icono': Icons.fitness_center,
      },
      {
        'nombre': 'Creatina',
        'descripcion':
            'Mejora el rendimiento físico en ejercicios de alta intensidad y favorece el desarrollo muscular.',
        'icono': Icons.flash_on,
      },
      {
        'nombre': 'Pre-entrenos',
        'descripcion':
            'Aumentan la energía, el enfoque y el rendimiento durante el entrenamiento.',
        'icono': Icons.local_fire_department,
      },
      {
        'nombre': 'Omega-3',
        'descripcion':
            'Ácidos grasos esenciales que favorecen la salud cardiovascular y cerebral.',
        'icono': Icons.favorite,
      },
      {
        'nombre': 'Zinc',
        'descripcion':
            'Mineral importante para el sistema inmune, la piel y la síntesis de proteínas.',
        'icono': Icons.shield,
      },
      {
        'nombre': 'Complejo B',
        'descripcion':
            'Grupo de vitaminas que ayudan al metabolismo energético y al sistema nervioso.',
        'icono': Icons.bolt,
      },
      {
        'nombre': 'Vitamina D',
        'descripcion':
            'Esencial para la salud ósea, el sistema inmune y el bienestar general.',
        'icono': Icons.wb_sunny,
      },
      {
        'nombre': 'Magnesio',
        'descripcion':
            'Ayuda a la función muscular, nerviosa y a la recuperación.',
        'icono': Icons.spa,
      },
      {
        'nombre': 'Probióticos',
        'descripcion':
            'Favorecen la salud digestiva y el equilibrio de la flora intestinal.',
        'icono': Icons.biotech,
      },
      {
        'nombre': 'Multivitamínicos',
        'descripcion':
            'Aportan una variedad de vitaminas y minerales para cubrir posibles deficiencias.',
        'icono': Icons.medical_services,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suplementos',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: suplementos.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final suplemento = suplementos[index];
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: ListTile(
              leading: Icon(suplemento['icono'], color: Colors.amber, size: 36),
              title: Text(suplemento['nombre'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(suplemento['descripcion']),
            ),
          );
        },
      ),
    );
  }
}