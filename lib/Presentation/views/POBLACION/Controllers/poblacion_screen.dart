// poblacion_screen.dart

import 'package:flutter/material.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Controllers/detalles_terreno_card.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Controllers/lances_table.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Controllers/poblacion_controller.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Controllers/resultados_table.dart';

class PoblacionScreen extends StatefulWidget {
  const PoblacionScreen({super.key});

  @override
  State<PoblacionScreen> createState() => _PoblacionScreenState();
}

class _PoblacionScreenState extends State<PoblacionScreen> {
  late final String typeFinca;
  final controller = PoblacionController();

  @override
  void initState() {
    super.initState();
    controller.hectareasController
        .addListener(controller.calcularDensidadSiembra);
    controller.cantidadSiembraController
        .addListener(controller.calcularDensidadSiembra);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _generarLances() {
    int n = int.tryParse(controller.lancesController.text) ?? 0;
    setState(() {
      controller.camaronesControllers =
          List.generate(n, (_) => TextEditingController());
      controller.bactimetriaControllers =
          List.generate(n, (_) => TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DetallesTerrenoCard(
              hectareasController: controller.hectareasController,
              piscinasController: controller.piscinasController,
              cantidadSiembraController: controller.cantidadSiembraController,
              densidadSiembraController: controller.densidadSiembraController,
              pesoController: controller.pesoController,
              fechaPoblacionController: controller.fechaPoblacionController,
              typeFinca: controller.typeFinca,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.lancesController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Número de Lances',
              ),
              onChanged: (_) => _generarLances(),
            ),
            const SizedBox(height: 16),
            if (controller.camaronesControllers.isNotEmpty)
              LancesTable(
                camaronesControllers: controller.camaronesControllers,
                bactimetriaControllers: controller.bactimetriaControllers,
                onUpdate: () {
                  setState(() {
                    controller.calcularResultados();
                  });
                },
              ),
            const SizedBox(height: 32),
            if (controller.resultCamaronesController.text.isNotEmpty)
              ResultadosTable(
                data: {
                  "Total camarones": controller.resultCamaronesController,
                  "Numero de Lances": controller.lancesController,
                  "Camarones X Lances": controller.camaronesXLancesController,
                  "Batimetría": controller.batimentriaController,
                  "N Camarones X Metro Sin Agua":
                      controller.nCamaronesXMetroSinAguaController,
                  "N Camarones X Metro Con Agua":
                      controller.nCamaronesXMetroConAguaController,
                  "Cam Promedios": controller.camPromediosController,
                  "Población Actual": controller.poblacionActualController,
                  "Sobrevivencia": controller.sobrevivenciaController,
                  "Peso de Camarón": controller.pesoDeCamaronController,
                  "Libras Estimadas": controller.librasEstimadasController,
                },
              ),
          ],
        ),
      ),
    );
  }
}
