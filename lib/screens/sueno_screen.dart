import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class SuenoScreen extends StatefulWidget {
  final Map<String, dynamic> user; // <-- Agrega el usuario aquí
  const SuenoScreen({super.key, required this.user});

  @override
  State<SuenoScreen> createState() => _SuenoScreenState();
}

class _SuenoScreenState extends State<SuenoScreen> {
  final TextEditingController _horasController = TextEditingController();
  final TextEditingController _objetivoController = TextEditingController();
  List<Map<String, dynamic>> historialSueno = [];
  int objetivoSueno = 8;

  String get _claveHistorial => 'historial_sueno_${widget.user['usuario']}';
  String get _claveObjetivo => 'objetivo_sueno_${widget.user['usuario']}';

  @override
  void initState() {
    super.initState();
    //print('Usuario: ${widget.user['usuario']}');
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    final historialString = prefs.getString(_claveHistorial);
    final objetivo = prefs.getInt(_claveObjetivo);
    if (historialString != null) {
      historialSueno =
          List<Map<String, dynamic>>.from(jsonDecode(historialString));
    }
    if (objetivo != null) {
      objetivoSueno = objetivo;
      _objetivoController.text = objetivoSueno.toString();
    } else {
      _objetivoController.text = objetivoSueno.toString();
    }
    setState(() {});
  }

  Future<void> _guardarDatos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_claveHistorial, jsonEncode(historialSueno));
    await prefs.setInt(_claveObjetivo, objetivoSueno);
  }

  void _agregarRegistro() {
    final horas = double.tryParse(_horasController.text);
    if (horas == null || horas <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ingresa un número válido de horas')),
      );
      return;
    }
    final hoy = DateFormat('dd/MM/yyyy').format(DateTime.now());
    final existente = historialSueno.indexWhere((e) => e['fecha'] == hoy);
    if (existente != -1) {
      historialSueno[existente]['horas'] = horas;
    } else {
      historialSueno.add({'fecha': hoy, 'horas': horas});
    }
    _horasController.clear();
    _guardarDatos();
    setState(() {});
  }

  void _guardarObjetivo() {
    final obj = int.tryParse(_objetivoController.text);
    if (obj == null || obj < 1 || obj > 24) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Objetivo inválido')),
      );
      return;
    }
    objetivoSueno = obj;
    _guardarDatos();
    setState(() {});
  }

  List<Map<String, dynamic>> get _ultimos7Dias {
    final hoy = DateTime.now();
    return List.generate(7, (i) {
      final fecha = hoy.subtract(Duration(days: 6 - i));
      final fechaStr = DateFormat('dd/MM/yyyy').format(fecha);
      final registro = historialSueno.firstWhere(
        (e) => e['fecha'] == fechaStr,
        orElse: () => {'fecha': fechaStr, 'horas': 0.0},
      );
      return {'fecha': fechaStr, 'horas': registro['horas']};
    });
  }

  @override
  Widget build(BuildContext context) {
    final promedio = _ultimos7Dias
            .map((e) => e['horas'] as double)
            .fold(0.0, (a, b) => a + b) /
        7;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sueño',
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Registro de horas de sueño
            const Text('Registra tus horas de sueño de hoy:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _horasController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Horas dormidas',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: _agregarRegistro,
                  child: const Text('Guardar',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 5. Objetivo de sueño
            Row(
              children: [
                const Text('Objetivo: ', style: TextStyle(fontSize: 16)),
                SizedBox(
                  width: 50,
                  child: TextField(
                    controller: _objetivoController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    ),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('horas por noche'),
                const SizedBox(width: 10),
                ElevatedButton(
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.amber),
                  onPressed: _guardarObjetivo,
                  child: const Text('Actualizar',
                      style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 2. Historial de sueño
            const Text('Historial de sueño (últimos 7 días):',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._ultimos7Dias.map((e) => Row(
                  children: [
                    Expanded(child: Text(e['fecha'])),
                    Text('${e['horas']} h',
                        style: TextStyle(
                          color: (e['horas'] as double) >= objetivoSueno
                              ? Colors.green
                              : Colors.red,
                        )),
                  ],
                )),
            const SizedBox(height: 20),

            // 3. Gráfica semanal simple (de texto)
            const Text('Gráfica semanal:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ..._ultimos7Dias.map((e) {
              final horas = e['horas'] as double;
              final barras = '█' * horas.round();
              return Row(
                children: [
                  SizedBox(width: 70, child: Text(e['fecha'])),
                  Text(barras,
                      style:
                          TextStyle(color: Colors.indigo[900], fontSize: 18)),
                  const SizedBox(width: 8),
                  Text('${horas.toStringAsFixed(1)}h'),
                ],
              );
            }),
            const SizedBox(height: 20),

            // 4. Consejos para mejorar el sueño
            const Text('Consejos para dormir mejor:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('• Mantén horarios regulares para dormir y despertar.'),
            const Text('• Evita pantallas antes de dormir.'),
            const Text('• Haz ejercicio regularmente.'),
            const Text('• No consumas cafeína por la tarde.'),
            const Text('• Crea un ambiente cómodo y oscuro para dormir.'),
            const SizedBox(height: 30),
            Text('Promedio semanal: ${promedio.toStringAsFixed(1)} h',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: promedio >= objetivoSueno ? Colors.green : Colors.red,
                )),
          ],
        ),
      ),
    );
  }
}
