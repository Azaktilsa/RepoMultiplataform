// poblacion_controller.dart

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:azaktilza/env_loader.dart';

class PoblacionController {
  final TextEditingController hectareasController = TextEditingController();
  final TextEditingController piscinasController = TextEditingController();
  final TextEditingController cantidadSiembraController =
      TextEditingController();
  final TextEditingController densidadSiembraController =
      TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController fechaPoblacionController =
      TextEditingController();
  final TextEditingController lancesController = TextEditingController();
  final TextEditingController resultCamaronesController =
      TextEditingController();
  final TextEditingController resultBactimetriaController =
      TextEditingController();
  final TextEditingController camaronesXLancesController =
      TextEditingController();
  final TextEditingController diametroAtarrayaController =
      TextEditingController();
  final TextEditingController batimentriaController = TextEditingController();
  final TextEditingController nCamaronesXMetroSinAguaController =
      TextEditingController();
  final TextEditingController nCamaronesXMetroConAguaController =
      TextEditingController();
  final TextEditingController camPromediosController = TextEditingController();
  final TextEditingController poblacionActualController =
      TextEditingController();
  final TextEditingController sobrevivenciaController = TextEditingController();
  final TextEditingController pesoDeCamaronController = TextEditingController();
  final TextEditingController librasEstimadasController =
      TextEditingController();
  late final String typeFinca;

  List<TextEditingController> camaronesControllers = [];
  List<TextEditingController> bactimetriaControllers = [];

  late final DatabaseReference typefincaRef;
  late final DatabaseReference baseRef;

  PoblacionController() {
    typefincaRef = FirebaseDatabase.instance.ref(EnvLoader.get('${typeFinca}_ROWS')!);
    baseRef = FirebaseDatabase.instance.ref(EnvLoader.get('${typeFinca}_')!);
  }

  Future<List<Map<String, dynamic>>> fetchTerrenos() async {
    try {
      final event = await baseRef.once();
      final data = event.snapshot.value;
      List<Map<String, dynamic>> fetched = [];

      if (data is Map && data.containsKey('rows')) {
        final rows = data['rows'];
        if (rows is List) {
          fetched = rows
              .map((row) => {
                    'name':
                        'Hect: ${row['Hectareas']}, Pisc: ${row['Piscinas']}',
                    'Hectareas': row['Hectareas'],
                    'Piscinas': row['Piscinas'],
                  })
              .toList();
        } else if (rows is Map) {
          rows.forEach((key, value) {
            fetched.add({
              'name': 'Row $key',
              'Hectareas': value['Hectareas'],
              'Piscinas': value['Piscinas'],
            });
          });
        }
      }

      return fetched;
    } catch (e) {
      print('Error al obtener terrenos: $e');
      return [];
    }
  }

  void calcularDensidadSiembra() {
    double hectareas = double.tryParse(hectareasController.text) ?? 0.0;
    double cantidad = double.tryParse(cantidadSiembraController.text) ?? 0.0;
    double densidad = hectareas != 0 ? cantidad / hectareas : 0.0;
    densidadSiembraController.text = densidad.toStringAsFixed(1);
  }

  void calcularResultados() {
    final hectareas = double.tryParse(hectareasController.text) ?? 0.0;
    final cantidadSiembra =
        double.tryParse(cantidadSiembraController.text) ?? 0.0;
    final pesoGr = double.tryParse(pesoController.text) ?? 0.0;
    final diametroAtarraya =
        double.tryParse(diametroAtarrayaController.text) ?? 1.0;

    final sumCam = camaronesControllers.fold(
        0, (prev, ctrl) => prev + (int.tryParse(ctrl.text) ?? 0));
    final sumBacti = bactimetriaControllers.fold(
        0, (prev, ctrl) => prev + (int.tryParse(ctrl.text) ?? 0));

    final numLances = int.tryParse(lancesController.text) ?? 1;
    final promedioCam = numLances > 0 ? sumCam / numLances : 0.0;
    final promedioBacti = numLances > 0 ? sumBacti / numLances : 0.0;

    final batimetria = promedioBacti / 100;
    final camXMetroSinAgua = promedioCam / diametroAtarraya;
    final camXMetroConAgua = camXMetroSinAgua * batimetria;
    final camPromedio = (camXMetroSinAgua + camXMetroConAgua) / 2;
    final poblacionActual = hectareas * 10000 * camPromedio;
    final sobrevivencia =
        cantidadSiembra > 0 ? poblacionActual * 100 / cantidadSiembra : 0.0;
    final librasEstimadas = hectareas * 10000 * camXMetroSinAgua * pesoGr / 454;

    // Actualiza campos
    resultCamaronesController.text = sumCam.toString();
    camaronesXLancesController.text = promedioCam.toStringAsFixed(1);
    resultBactimetriaController.text = promedioBacti.toStringAsFixed(1);
    batimentriaController.text = batimetria.toStringAsFixed(1);
    nCamaronesXMetroSinAguaController.text =
        camXMetroSinAgua.toStringAsFixed(1);
    nCamaronesXMetroConAguaController.text =
        camXMetroConAgua.toStringAsFixed(2);
    camPromediosController.text = camPromedio.toStringAsFixed(2);
    poblacionActualController.text = poblacionActual.toStringAsFixed(2);
    sobrevivenciaController.text = sobrevivencia.toStringAsFixed(2);
    pesoDeCamaronController.text = pesoGr.toStringAsFixed(1);
    librasEstimadasController.text = librasEstimadas.toStringAsFixed(2);
  }

  Future<void> saveTutorialFlag(bool shown) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("tutorial_mostrado_${typeFinca}_POBLACION", shown);
  }

  Future<bool> wasTutorialShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("tutorial_mostrado_${typeFinca}_POBLACION") ?? false;
  }

  void dispose() {
    hectareasController.dispose();
    piscinasController.dispose();
    cantidadSiembraController.dispose();
    densidadSiembraController.dispose();
    pesoController.dispose();
    fechaPoblacionController.dispose();
    lancesController.dispose();
    resultCamaronesController.dispose();
    resultBactimetriaController.dispose();
    camaronesXLancesController.dispose();
    diametroAtarrayaController.dispose();
    batimentriaController.dispose();
    nCamaronesXMetroSinAguaController.dispose();
    nCamaronesXMetroConAguaController.dispose();
    camPromediosController.dispose();
    poblacionActualController.dispose();
    sobrevivenciaController.dispose();
    pesoDeCamaronController.dispose();
    librasEstimadasController.dispose();
    for (var c in camaronesControllers) {
      c.dispose();
    }
    for (var c in bactimetriaControllers) {
      c.dispose();
    }
  }
}
