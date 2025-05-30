import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../utils/comidas_global.dart';

class ComidasFavoritasScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const ComidasFavoritasScreen({super.key, required this.user});

  @override
  State<ComidasFavoritasScreen> createState() => _ComidasFavoritasScreenState();
}

class _ComidasFavoritasScreenState extends State<ComidasFavoritasScreen> {
  List<Map<String, dynamic>> comidasFavoritas = [];

  @override
  void initState() {
    super.initState();
    _loadComidasFavoritas();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadComidasFavoritas();
  }

  Future<void> _loadComidasFavoritas() async {
    final usuario = widget.user['usuario'];
    final prefs = await SharedPreferences.getInstance();
    final favsString = prefs.getString('favoritos_comidas_$usuario');
    List<Map<String, dynamic>> favoritas = [];
    if (favsString != null) {
      final favsList = (jsonDecode(favsString) as List).cast<int>();
      favoritas = favsList
          .where((i) => i >= 0 && i < comidasGlobal.length)
          .map((i) => comidasGlobal[i])
          .toList();
    }
    setState(() {
      comidasFavoritas = favoritas;
    });
  }

  Future<void> _eliminarDeFavoritos(String nombreComida) async {
    final usuario = widget.user['usuario'];
    final prefs = await SharedPreferences.getInstance();
    final favsString = prefs.getString('favoritos_comidas_$usuario');
    List<int> favsList = [];
    if (favsString != null) {
      favsList = (jsonDecode(favsString) as List).cast<int>();
    }
    // Busca el índice de la comida a eliminar
    final indexToRemove = comidasGlobal.indexWhere((c) => c['nombre'] == nombreComida);
    if (indexToRemove != -1) {
      favsList.remove(indexToRemove);
      await prefs.setString('favoritos_comidas_$usuario', jsonEncode(favsList));
      _loadComidasFavoritas();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Eliminado de favoritos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comidas Favoritas',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: comidasFavoritas.isEmpty
          ? const Center(child: Text('No tienes comidas favoritas aún.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: comidasFavoritas.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final comida = comidasFavoritas[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: ListTile(
                    title: Text(comida['nombre'],
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      'Objetivo: ${comida['objetivo']}\n'
                      'Calorías: ${comida['calorias']} kcal\n'
                      'Proteína: ${comida['proteina']} g   '
                      'Grasa: ${comida['grasa']} g   '
                      'Carbohidratos: ${comida['carbohidratos']} g',
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Eliminar de favoritos',
                      onPressed: () => _eliminarDeFavoritos(comida['nombre']),
                    ),
                  ),
                );
              },
            ),
    );
  }
}