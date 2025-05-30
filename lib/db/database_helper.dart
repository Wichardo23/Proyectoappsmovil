import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:convert';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    Directory databaseDirectory = await getApplicationDocumentsDirectory();
    final path = join(databaseDirectory.path, 'usuarios_F.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          usuario TEXT,
          name TEXT,
          email TEXT UNIQUE,
          password TEXT,
          lastName TEXT,
          phone TEXT,
          dob TEXT,
          profile_image TEXT,
          comidas_favoritas TEXT,      
          ejercicios_favoritos TEXT,   
          progreso TEXT                
        )
      ''');
      },
    );
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> getUser(String usuario, String password) async {
    final db = await database;
    final result = await db.query(
      'users', // Cambia esto si tu tabla tiene otro nombre
      where: 'usuario = ? AND password = ?',
      whereArgs: [usuario, password],
    );
    //print('Resultado de getUser: $result'); // Para depuración
    return result.isNotEmpty ? result.first : null;
  }

  // Método para obtener un usuario por email
  Future<bool> emailExists(String email) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );
    return result.isNotEmpty;
  }

  // Método para obtener un usuario por usuario
  Future<bool> usuarioExists(String usuario) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'usuario = ?',
      whereArgs: [usuario],
    );
    return result.isNotEmpty;
  }

  // Método para actualizar la contraseña
  Future<void> updatePassword(String email, String newPassword) async {
    final db = await database;
    await db.update(
      'users',
      {'password': newPassword},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // Método para actualizar los datos del usuario
  Future<void> updateUserData({
    required String oldEmail,
    required String newName,
    required String newEmail,
    required String newPhone,
  }) async {
    final db = await database;
    await db.update(
      'users',
      {
        'name': newName,
        'email': newEmail,
        'phone': newPhone,
      },
      where: 'email = ?',
      whereArgs: [oldEmail],
    );
  }

  // Actualizar imagen de perfil
  Future<void> updateProfileImage(String email, String imagePath) async {
    final db = await database;
    await db.update(
      'users',
      {'profile_image': imagePath},
      where: 'email = ?',
      whereArgs: [email],
    );
  }

  // Guardar comidas favoritas
  Future<void> updateComidasFavoritas(
      dynamic usuario, List<String> favoritos) async {
    final db = await database;
    await db.update(
      'users',
      {'comidas_favoritas': jsonEncode(favoritos)},
      where: 'usuario = ?',
      whereArgs: [usuario],
    );
  }

  // Guardar ejercicios favoritos
  Future<void> updateEjerciciosFavoritos(
      String usuario, List<String> ejercicios) async {
    final db = await database;
    await db.update(
      'users',
      {'ejercicios_favoritos': jsonEncode(ejercicios)},
      where: 'usuario = ?',
      whereArgs: [usuario],
    );
  }

  // Guardar progreso (puedes usar un mapa o lista según tu modelo)
  Future<void> updateProgreso(
    String usuario, String progresoJson) async {
  final db = await database;
  await db.update(
    'users',
    {'progreso': progresoJson},
    where: 'usuario = ?',
    whereArgs: [usuario],
  );
}
}
