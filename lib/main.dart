import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'screens/login_screen.dart';
import 'screens/singup_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'screens/search_screen.dart';
import 'screens/favorites_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/perfil_screen.dart';
import 'screens/ejercicios_screen.dart';
import 'screens/alimentacion_screen.dart';
import 'screens/progreso_screen.dart';
import 'screens/sueno_screen.dart';
import 'screens/suplementos_screen.dart';
import 'screens/change_password.dart';
import 'screens/ejercicios_favoritos_screen.dart';
import 'screens/comidas_favoritas_screen.dart';
import 'screens/ejercicios_grupo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  runApp(const FitRoutineApp());
}

class FitRoutineApp extends StatelessWidget {
  const FitRoutineApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FitRoutine+',
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/main': (context) => const MainNavigationScreen(user: {}),
        '/search': (context) => SearchScreen(user: const {}),
        '/favorites': (context) => const FavoritesScreen(user: {},),
        '/settings': (context) => const SettingsScreen(user: {}),
        '/perfil': (context) => const PerfilScreen(user: {}),
        '/ejercicios': (context) => const EjerciciosScreen(user: {}),
        '/alimentacion': (context) => const AlimentacionScreen(user: {},),
        '/progreso': (context) => const ProgresoScreen(user: {},),
        '/sueno': (context) => const SuenoScreen(user: {},),
        '/suplementos': (context) => const SuplementosScreen(),
        '/change_password': (context) => const ChangePasswordScreen(),
        '/ejercicios_favoritos': (context) => const EjerciciosFavoritosScreen(user: {},),
        '/comidas_favoritas': (context) => const ComidasFavoritasScreen(user: {},),
        '/ejercicios_grupo': (context) => const EjerciciosGrupoScreen(grupo: '', ejercicios: [], user: {}),
      },
    );
  }
}