import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:azaktilza/env_loader.dart';

class Dato_Logic {
  static bool _usuarioModificoRendimiento = false;
  static final NumberFormat numberFormatter = NumberFormat("#,##0.##", "en_US");

  static int getRendimiento({
    required int entero,
    required List<Map<String, dynamic>> rendimientoData,
    required TextEditingController rendimientoController,
  }) {
    final matchingElement = rendimientoData.firstWhere(
      (element) =>
          element.containsKey('Gramos') &&
          element['Gramos'] != null &&
          int.tryParse(element['Gramos'].toString()) == entero,
      orElse: () => <String, dynamic>{},
    );

    if (matchingElement.isEmpty) return 0;

    final rendimiento =
        int.tryParse(matchingElement['Rendimiento'].toString()) ?? 0;

    // ✅ Solo actualizar si el usuario no lo modificó manualmente
    if (rendimientoController.text.isEmpty || !_usuarioModificoRendimiento) {
      rendimientoController.text = rendimiento.toString();
    }

    return rendimiento;
  }

  static String calculateKgXHa({
    required TextEditingController consumoController,
    required TextEditingController hectareasController,
    required TextEditingController kgXHaController,
  }) {
    final consumo = double.tryParse(consumoController.text.replaceAll(',', ''));
    final hectareas =
        double.tryParse(hectareasController.text.replaceAll(',', ''));
    final result = (consumo != null && hectareas != null)
        ? (consumo / hectareas).toStringAsFixed(2)
        : 'N/A';
    kgXHaController.text = result;
    return result;
  }

  static String calculateLibrasXHa({
    required TextEditingController rendimientoController,
    required TextEditingController kgXHaController,
    required TextEditingController librasXHaController,
  }) {
    final kgXHa = double.tryParse(kgXHaController.text.replaceAll(',', ''));
    final rendimiento =
        double.tryParse(rendimientoController.text.replaceAll(',', ''));
    final result = (kgXHa != null && rendimiento != null)
        ? numberFormatter.format(kgXHa * (rendimiento / 100) * 100)
        : 'N/A';
    librasXHaController.text = result;
    return result;
  }

  static String calculateLibrasTotal({
    required TextEditingController hectareasController,
    required TextEditingController librasXHaController,
    required TextEditingController librasTotalController,
  }) {
    final hectareas =
        double.tryParse(hectareasController.text.replaceAll(',', ''));
    final librasXHa =
        double.tryParse(librasXHaController.text.replaceAll(',', ''));
    final result = (hectareas != null && librasXHa != null)
        ? numberFormatter.format(hectareas * librasXHa)
        : 'N/A';
    librasTotalController.text = result;
    return result;
  }

  static String calculateError2({
    required TextEditingController librasTotalController,
    required TextEditingController error2Controller,
  }) {
    final librasTotal =
        double.tryParse(librasTotalController.text.replaceAll(',', ''));
    final result = (librasTotal != null)
        ? numberFormatter.format(librasTotal * 0.98)
        : 'N/A';
    error2Controller.text = result;
    return result;
  }

  static String calculateAnimalesM({
    required TextEditingController librasXHaController,
    required TextEditingController pesoController,
    required TextEditingController animalesMController,
  }) {
    final librasXHa =
        double.tryParse(librasXHaController.text.replaceAll(',', ''));
    final peso = double.tryParse(pesoController.text.replaceAll(',', ''));
    final result = (librasXHa != null && peso != null)
        ? (((librasXHa * 454) / peso) / 10000).toStringAsFixed(2)
        : 'N/A';
    animalesMController.text = result;
    return result;
  }

  static Future<List<Map<String, dynamic>>> fetchDataFromRef(
      DatabaseReference ref) async {
    final snapshot = await ref.get();
    if (snapshot.exists) {
      if (snapshot.value is List) {
        return (snapshot.value as List)
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } else if (snapshot.value is Map) {
        return (snapshot.value as Map)
            .values
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      }
    }
    return [];
  }

  static Future<void> uploadResultsToFirebase({
    required double peso,
    required double consumo,
    required String selectedPiscinas,
    required String selectedHectareas,
    required int rendimiento,
    required String finca,
  }) async {
    final kgXHa = peso > 0 && double.tryParse(selectedHectareas) != null
        ? consumo / double.parse(selectedHectareas)
        : 0.0;
    final librasXHa = kgXHa * (rendimiento / 100) * 100;
    final librasTotal = double.parse(selectedHectareas) * librasXHa;
    final error2 = librasTotal * 0.98;
    final animalesM = ((librasXHa * 454) / peso) / 10000;

    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('yyyy-MM-dd HH').format(now);

    final newData = {
      'Piscinas': selectedPiscinas,
      'Hectareas': selectedHectareas,
      'FechaHora': formattedDate,
      'Peso': peso,
      'Consumo': consumo,
      'Gramos': peso,
      'KGXHA': kgXHa,
      'Rendimiento': rendimiento,
      'LibrasTotal': librasTotal,
      'Error2': error2,
      'LibrasXHA': librasXHa,
      'AnimalesM': animalesM,
      'Finca': finca,
    };

    final DatabaseReference resultRef;
    if (kIsWeb) {
      // Sube los datos calculados a la base de datos de Firebase
      resultRef = FirebaseDatabase.instance
          .ref('${EnvLoader.get('RESULT_DATO_BASE')}/$finca');
    } else {
      // Sube los datos calculados a la base de datos de Firebase
      resultRef = FirebaseDatabase.instance
          .ref('${dotenv.env['RESULT_DATO_BASE']}/$finca');
    }
    await resultRef.push().set(newData);
  }
}
