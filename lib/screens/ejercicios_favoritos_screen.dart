import 'package:flutter/material.dart';
import 'dart:convert';
import '../db/database_helper.dart';

class EjerciciosFavoritosScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const EjerciciosFavoritosScreen({super.key, required this.user});

  @override
  State<EjerciciosFavoritosScreen> createState() => _EjerciciosFavoritosScreenState();
}

class _EjerciciosFavoritosScreenState extends State<EjerciciosFavoritosScreen> {
  List<String> favoritos = [];
  late Map<String, dynamic> editableUser;

  @override
  void initState() {
    super.initState();
    editableUser = Map<String, dynamic>.from(widget.user);
    _cargarFavoritos();
  }

  Future<void> _cargarFavoritos() async {
    final db = await DatabaseHelper().database;
    final userList = await db.query(
      'users',
      where: 'usuario = ?',
      whereArgs: [editableUser['usuario']],
    );
    if (userList.isNotEmpty) {
      final userData = userList.first;
      print('userData: $userData');
      final favs = userData['ejercicios_favoritos'] != null &&
              userData['ejercicios_favoritos'].toString().isNotEmpty
          ? (jsonDecode(userData['ejercicios_favoritos'].toString()) as List)
              .map<String>((e) => e.toString())
              .toList()
          : <String>[];
      setState(() {
        favoritos = favs;
      });
      print('Favoritos cargados: $favoritos');
    }
  }

  Future<void> _eliminarFavorito(int index) async {
    final ejercicio = favoritos[index];
    favoritos.removeAt(index);

    // Actualiza en la base de datos del usuario usando 'usuario'
    await DatabaseHelper()
        .updateEjerciciosFavoritos(editableUser['usuario'], favoritos);

    setState(() {});
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ejercicio eliminado de favoritos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ejercicios Favoritos',
            style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.indigo[900],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: favoritos.isEmpty
          ? const Center(
              child: Text(
                'No tienes ejercicios favoritos aún.',
                style: TextStyle(fontSize: 20),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: favoritos.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final ejercicio = favoritos[index];
                return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  elevation: 4,
                  child: ListTile(
                    title: Text(ejercicio,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      tooltip: 'Eliminar de favoritos',
                      onPressed: () => _eliminarFavorito(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
