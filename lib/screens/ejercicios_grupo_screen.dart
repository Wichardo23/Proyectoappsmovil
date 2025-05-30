import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../db/database_helper.dart';

class EjerciciosGrupoScreen extends StatefulWidget {
  final String grupo;
  final List<Map<String, String>> ejercicios;
  final Map<String, dynamic> user;

  const EjerciciosGrupoScreen({
    super.key,
    required this.grupo,
    required this.ejercicios,
    required this.user,
  });

  @override
  State<EjerciciosGrupoScreen> createState() => _EjerciciosGrupoScreenState();
}

class _EjerciciosGrupoScreenState extends State<EjerciciosGrupoScreen> {
  Set<String> _favoritos = {};

  String get _claveFavoritos =>
      'favoritos_ejercicios_${widget.user['usuario']}';

  @override
  void initState() {
    super.initState();
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    final db = await DatabaseHelper().database;
    final userList = await db.query(
      'users',
      where: 'usuario = ?',
      whereArgs: [widget.user['usuario']],
    );

    if (userList.isNotEmpty) {
      final userData = userList.first;
      final favString = userData['ejercicios_favoritos'];

      if (favString != null && favString.toString().isNotEmpty) {
        final favList = List<String>.from(jsonDecode(favString.toString()));
        setState(() {
          _favoritos = favList.toSet();
        });

        // Opcional: también actualizar SharedPreferences con este valor
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_claveFavoritos, favString.toString());
      }
    }
  }

  Future<void> _guardarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final favListJson = jsonEncode(_favoritos.toList());

    // Guardar en SharedPreferences
    await prefs.setString(_claveFavoritos, favListJson);

    // Guardar en base de datos local
    final db = await DatabaseHelper().database;

    await db.update(
      'users',
      {'ejercicios_favoritos': favListJson},
      where: 'usuario = ?',
      whereArgs: [widget.user['usuario']],
    );
  }

  void _toggleFavorito(String nombre) {
    setState(() {
      if (_favoritos.contains(nombre)) {
        _favoritos.remove(nombre);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$nombre se eliminó de favoritos')),
        );
      } else {
        _favoritos.add(nombre);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$nombre se agregó a favoritos')),
        );
      }
    });
    _guardarFavoritos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.grupo)),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: widget.ejercicios.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final ejercicio = widget.ejercicios[index];
          final nombre = ejercicio['nombre'] ?? '';
          final esFavorito = _favoritos.contains(nombre);

          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.indigo[50],
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text(nombre),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/ejercicios/${ejercicio['imagen']}',
                        height: 180,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image_not_supported, size: 80),
                      ),
                      const SizedBox(height: 16),
                      Text(ejercicio['nota'] ?? ''),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cerrar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  nombre,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    esFavorito ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: () => _toggleFavorito(nombre),
                  tooltip: esFavorito
                      ? 'Quitar de favoritos'
                      : 'Agregar a favoritos',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
