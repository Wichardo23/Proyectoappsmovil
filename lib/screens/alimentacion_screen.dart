import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/comidas_global.dart';
import '../db/database_helper.dart';
import 'dart:convert';

class AlimentacionScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const AlimentacionScreen({super.key, required this.user});

  @override
  State<AlimentacionScreen> createState() => _AlimentacionScreenState();
}

class _AlimentacionScreenState extends State<AlimentacionScreen> {
  final List<String> _favoritos = [];
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    final usuario = widget.user['usuario'];
    _favoritos.clear();

    // Solo carga favoritos del usuario desde SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final favsString = prefs.getString('favoritos_comidas_$usuario');
    if (favsString != null) {
      final favsList = List<int>.from(jsonDecode(favsString));
      for (var favIndex in favsList) {
        if (favIndex >= 0 && favIndex < comidasGlobal.length) {
          final nombre = comidasGlobal[favIndex]['nombre'];
          if (!_favoritos.contains(nombre)) {
            _favoritos.add(nombre);
          }
        }
      }
    }
    setState(() {});
  }

  void _toggleFavorito(String nombreComida) async {
    setState(() {
      if (_favoritos.contains(nombreComida)) {
        _favoritos.remove(nombreComida);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Se eliminó de favoritos')),
        );
      } else {
        _favoritos.add(nombreComida);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Añadido a favoritos')),
        );
      }
    });

    // Guarda en base de datos (si lo usas)
    final usuario = widget.user['usuario'];
    if (usuario == null || usuario.toString().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: usuario no válido ($usuario)')),
      );
      return;
    }
    await dbHelper.updateComidasFavoritas(
      usuario,
      _favoritos.toList(),
    );

    // Guarda los favoritos del usuario en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final indicesFavoritos = comidasGlobal
        .asMap()
        .entries
        .where((entry) => _favoritos.contains(entry.value['nombre']))
        .map((entry) => entry.key)
        .toList();
    prefs.setString('favoritos_comidas_$usuario', jsonEncode(indicesFavoritos));

    await _cargarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Alimentación',
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
        itemCount: comidasGlobal.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final comida = comidasGlobal[index];
          final esFavorito = _favoritos.contains(comida['nombre']);
          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            elevation: 4,
            child: ExpansionTile(
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      comida['nombre'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      esFavorito ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                    onPressed: () => _toggleFavorito(comida['nombre']),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6.0),
                child: Text(
                  'Objetivo: ${comida['objetivo']}\n'
                  'Calorías: ${comida['calorias']} kcal\n'
                  'Proteína: ${comida['proteina']} g   '
                  'Grasa: ${comida['grasa']} g   '
                  'Carbohidratos: ${comida['carbohidratos']} g',
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Ingredientes:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      ...List<Widget>.from(
                        (comida['ingredientes'] as List<String>).map(
                          (ing) => Text('• $ing'),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
