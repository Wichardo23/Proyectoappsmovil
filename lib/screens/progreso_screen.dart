import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import 'dart:convert';

class ProgresoScreen extends StatefulWidget {
  final Map<String, dynamic> user;
  const ProgresoScreen({super.key, required this.user});

  @override
  State<ProgresoScreen> createState() => _ProgresoScreenState();
}

class _ProgresoScreenState extends State<ProgresoScreen> {
  late Map<String, dynamic> editableUser;
  List<Map<String, dynamic>> historialProgreso = [];
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    editableUser = Map<String, dynamic>.from(widget.user);
    _loadProgreso();
  }

  Future<void> _loadProgreso() async {
    final db = await DatabaseHelper().database;
    final userList = await db.query(
      'users',
      where: 'usuario = ?',
      whereArgs: [editableUser['usuario']],
    );
    if (userList.isNotEmpty) {
      final userData = userList.first;
      if (userData['progreso'] != null &&
          userData['progreso'].toString().isNotEmpty) {
        final decoded = jsonDecode(userData['progreso'].toString());
        setState(() {
          if (decoded is List) {
            historialProgreso = List<Map<String, dynamic>>.from(decoded);
          } else if (decoded is Map) {
            historialProgreso = [Map<String, dynamic>.from(decoded)];
          } else {
            historialProgreso = [];
          }
        });
      } else {
        setState(() {
          historialProgreso = [];
        });
      }
    }
  }

  Future<void> _guardarProgreso() async {
    final peso = _pesoController.text.trim();
    final altura = _alturaController.text.trim();

    if (peso.isEmpty || altura.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Completa ambos campos')),
      );
      return;
    }

    final nuevoProgreso = {
      'peso': peso,
      'altura': altura,
      'fecha': DateTime.now().toIso8601String(),
    };

    List<Map<String, dynamic>> historial =
        List<Map<String, dynamic>>.from(historialProgreso);
    historial.insert(0, nuevoProgreso);

    await DatabaseHelper().updateProgreso(
      editableUser['usuario'],
      jsonEncode(historial),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('¡Progreso guardado!')),
    );

    setState(() {
      historialProgreso = historial;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ultimo =
        historialProgreso.isNotEmpty ? historialProgreso.first : null;
    final anteriores =
        historialProgreso.length > 1 ? historialProgreso.sublist(1) : [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progreso'),
        backgroundColor: Colors.indigo[900],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Registra tu progreso',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _pesoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Peso (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _alturaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Altura (cm)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: _guardarProgreso,
                  child: const Text('Guardar',
                      style: TextStyle(color: Colors.black)),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Progreso actual:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text('Peso: ${ultimo?['peso'] ?? '-'} kg'),
              Text('Altura: ${ultimo?['altura'] ?? '-'} cm'),
              if (ultimo?['fecha'] != null)
                Text(
                  'Fecha: ${DateTime.tryParse(ultimo!['fecha'])?.toLocal().toString().substring(0, 16) ?? '-'}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              const SizedBox(height: 20),
              if (anteriores.isNotEmpty)
                const Text(
                  'Progresos anteriores:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ...anteriores.map((prog) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Card(
                      child: ListTile(
                        title: Text(
                            'Peso: ${prog['peso']} kg, Altura: ${prog['altura']} cm'),
                        subtitle: prog['fecha'] != null
                            ? Text(
                                'Fecha: ${DateTime.tryParse(prog['fecha'])?.toLocal().toString().substring(0, 16) ?? '-'}')
                            : null,
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
