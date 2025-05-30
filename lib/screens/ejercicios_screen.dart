import 'package:flutter/material.dart';
import 'ejercicios_grupo_screen.dart';

class EjerciciosScreen extends StatelessWidget {
  final Map<String, dynamic> user;
  const EjerciciosScreen({super.key, required this.user});

  static const Map<String, List<Map<String, String>>> ejerciciosPorGrupo = {
    'Pecho': [
      {
        'nombre': 'Press de banca',
        'imagen': 'benchpress.gif',
        'nota': 'Trabaja el pectoral mayor, tríceps y deltoides anterior.'
      },
      {
        'nombre': 'Press inclinado',
        'imagen': 'inclinebenchpress.gif',
        'nota': 'Enfocado en la parte superior del pecho.'
      },
      {
        'nombre': 'Press inclinado con mancuernas',
        'imagen': 'inclinadomancuernas.gif',
        'nota': 'Aísla el pectoral mayor.'
      },
      {
        'nombre': 'Press plano con mancuernas',
        'imagen': 'planomancuernas.gif',
        'nota': 'Trabaja la parte inferior del pecho.'
      },
      {
        'nombre': 'Fondos en paralelas',
        'imagen': 'fondos.gif',
        'nota': 'Excelente para pecho y tríceps.'
      },
      {
        'nombre': 'Peckdeck',
        'imagen': 'peckdeck.gif',
        'nota': 'Trabaja el pectoral mayor, pectoral menor y deltoides anterior.'
      },
      {
        'nombre': 'Press de pecho en máquina',
        'imagen': 'pressmaquina.gif',
        'nota': 'Trabaja el pectoral mayor, triceps y deltoides anterior.'
      },
    ],
    'Espalda': [
      {
        'nombre': 'Dominadas',
        'imagen': 'dominadas.gif',
        'nota': 'Ejercicio básico para dorsales.'
      },
      {
        'nombre': 'Remo con barra',
        'imagen': 'remobarra.gif',
        'nota': 'Desarrolla el grosor de la espalda.'
      },
      {
        'nombre': 'Jalón al pecho',
        'imagen': 'jalonpecho.gif',
        'nota': 'Enfocado en la amplitud dorsal.'
      },
      {
        'nombre': 'Remo en máquina',
        'imagen': 'remomaquina.gif',
        'nota': 'Aísla la espalda media.'
      },
    ],
    'Brazo': [
      {
        'nombre': 'Curl con barra',
        'imagen': 'curlbarra.gif',
        'nota': 'Ejercicio básico para bíceps.'
      },
      {
        'nombre': 'Curl predicador',
        'imagen': 'predicador.gif',
        'nota': 'Trabaja la cabeza corta del bicep.'
      },
      {
        'nombre': 'Curl martillo',
        'imagen': 'martillos.gif',
        'nota': 'Enfocado en el bicep corto y el braquiorradial.'
      },
      {
        'nombre': 'Curl concentrado',
        'imagen': 'curlconcentrado.gif',
        'nota': 'Aísla el bíceps.'
      },
      {
        'nombre': 'Curl bayesian',
        'imagen': 'bayesian.gif',
        'nota': 'Trabaja la cabeza larga del bicep.'
      },
      {
        'nombre': 'Extensión de tríceps en polea',
        'imagen': 'triceppolea.gif',
        'nota': 'Aísla el tríceps.'
      },
      {
        'nombre': 'Extensión de tríceps en polea trasnuca',
        'imagen': 'triceptrasnuca.gif',
        'nota': 'Trabaja la cabeza larga del trícep.'
      },
      {
        'nombre': 'Press militar en maquina',
        'imagen': 'pressmilitarmaquina.gif',
        'nota': 'Trabaja deltoides y trapecio.'
      },
      {
        'nombre': 'Press militar con mancuernas',
        'imagen': 'pressmilitarmancuerna.gif',
        'nota': 'Trabaja deltoides y trapecio.'
      },
      {
        'nombre': 'Elevaciones laterales',
        'imagen': 'laterales.gif',
        'nota': 'Aísla el deltoides medio.'
      },
      {
        'nombre': 'Elevaciones frontales',
        'imagen': 'frontales.gif',
        'nota': 'Enfocado en el deltoides anterior.'
      },
      {
        'nombre': 'Facepull',
        'imagen': 'facepull.gif',
        'nota': 'Trabaja el deltoides posterior.'
      },
      {
        'nombre': 'Curl de muñeca',
        'imagen': 'curlmuneca.gif',
        'nota': 'Fortalece los flexores del antebrazo.'
      },
      {
        'nombre': 'Curl inverso',
        'imagen': 'curlinverso.gif',
        'nota': 'Trabaja los extensores del antebrazo.'
      },
    ],
    'Piernas y Glúteos': [
      {
        'nombre': 'Sentadilla en smith',
        'imagen': 'sentadillasmith.gif',
        'nota': 'Ejercicio básico para piernas.'
      },
      {
        'nombre': 'Prensa de piernas',
        'imagen': 'prensapiernas.gif',
        'nota': 'Trabaja cuádriceps y glúteos.'
      },
      {
        'nombre': 'Extensión de pierna',
        'imagen': 'extensionpieras.gif',
        'nota': 'Aísla el cuádriceps.'
      },
      {
        'nombre': 'Zancadas',
        'imagen': 'zancadas.gif',
        'nota': 'Trabaja cuádriceps y glúteos.'
      },
      {
        'nombre': 'Sentadilla hack',
        'imagen': 'hacka.gif',
        'nota': 'Trabaja cuádriceps, gluteo mayor y pantorrilas.'
      },
      {
        'nombre': 'Bulgaras',
        'imagen': 'bulgaras.gif',
        'nota': 'Trabaja Cuádriceps femora y gluteo mayor.'
      },
      {
        'nombre': 'Curl femoral',
        'imagen': 'curlfemoral.gif',
        'nota': 'Aísla los isquiotibiales.'
      },
      {
        'nombre': 'Curl femoral sentado',
        'imagen': 'femoralsentado.gif',
        'nota': 'Aísla los isquiotibiales.'
      },
      {
        'nombre': 'Peso muerto rumano',
        'imagen': 'RDL.gif',
        'nota': 'Trabaja isquios y glúteos.'
      },
      {
        'nombre': 'Hip thrust',
        'imagen': 'hiptrust.gif',
        'nota': 'Ejercicio principal para glúteos.'
      },
      {
        'nombre': 'Patada de glúteo',
        'imagen': 'patadagluteo.gif',
        'nota': 'Aísla el glúteo mayor.'
      },
      {
        'nombre': 'Aductores en maquina',
        'imagen': 'aductores.gif',
        'nota': 'Aísla los aductores.'
      },
      {
        'nombre': 'Abductores en maquina',
        'imagen': 'abductores.gif',
        'nota': 'Aísla los abductores.'
      },
      {
        'nombre': 'Pantorrilla en smith',
        'imagen': 'gemelos.gif',
        'nota': 'Aísla la pantorrilla.'
      },
      {
        'nombre': 'Pantorrilla sentado',
        'imagen': 'soleo.gif',
        'nota': 'Trabaja el soleo.'
      },
    ],
  };

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> rutinas = [
      {'nombre': 'Pecho', 'icono': Icons.favorite},
      {'nombre': 'Espalda', 'icono': Icons.swap_vert_circle},
      {'nombre': 'Brazo', 'icono': Icons.fitness_center},
      {'nombre': 'Piernas y Glúteos', 'icono': Icons.directions_run},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ejercicios',
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
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.separated(
          itemCount: rutinas.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final rutina = rutinas[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.indigo[50],
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                leading: Icon(rutina['icono'], color: Colors.amber),
                title: Text(rutina['nombre'],
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                trailing:
                    const Icon(Icons.arrow_forward_ios, color: Colors.grey),
                onTap: () {
                  final grupo = rutina['nombre'] as String;
                  final ejercicios = ejerciciosPorGrupo[grupo] ?? [];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EjerciciosGrupoScreen(
                        grupo: grupo,
                        ejercicios: ejercicios,
                        user: user
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}