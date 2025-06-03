import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';

class Medicion_metro extends StatelessWidget {
  const Medicion_metro({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: MeasurementForm(),
      ),
    );
  }
}

class MeasurementForm extends StatefulWidget {
  const MeasurementForm({Key? key}) : super(key: key);

  @override
  _MeasurementFormState createState() => _MeasurementFormState();
}

class _MeasurementFormState extends State<MeasurementForm> {
  List<BarChartGroupData> barGroups = [];
  List<BarChartGroupData> additionalBarGroups = [];

  final List<int> piscinaNumbers = List.generate(20, (index) => index + 1);
  int? selectedPiscina;
  final TextEditingController hectareasController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController consumoController = TextEditingController();
  final TextEditingController gramosController = TextEditingController();
  final TextEditingController enteroController = TextEditingController();
  final TextEditingController rendimientoController = TextEditingController();
  final TextEditingController resultadoController = TextEditingController();
  final TextEditingController resultadoEntero = TextEditingController();

  @override
  void initState() {
    super.initState();
    hectareasController.addListener(calculateAndDisplayResult);
    consumoController.addListener(calculateAndDisplayResult);
  }

  @override
  void dispose() {
    hectareasController.removeListener(calculateAndDisplayResult);
    consumoController.removeListener(calculateAndDisplayResult);
    hectareasController.dispose();
    consumoController.dispose();
    pesoController.dispose();
    gramosController.dispose();
    enteroController.dispose();
    rendimientoController.dispose();
    resultadoController.dispose();
    resultadoEntero.dispose();
    super.dispose();
  }

  void calculateAndDisplayResult() {
    final consumo = double.tryParse(consumoController.text);
    final hectareas = double.tryParse(hectareasController.text);

    if (consumo == null || hectareas == null || consumo == 0) {
      resultadoController.text =
          'Ingrese valores válidos para hectáreas y consumo.';
      return;
    }

    final kgXHa = consumo / hectareas;
    resultadoEntero.text = kgXHa.toString();
    enteroController.text =
        kgXHa.toString(); // Aquí se actualiza enteroController automáticamente
    resultadoController.text = 'KG X HA: $kgXHa\n';

    if (gramosController.text.isNotEmpty &&
        enteroController.text.isNotEmpty &&
        rendimientoController.text.isNotEmpty) {
      final gramos = int.tryParse(gramosController.text) ?? 0;
      final rendimiento = int.tryParse(rendimientoController.text) ?? 0;

      final additionalResult = gramos + kgXHa + rendimiento;
      resultadoController.text += 'Resultado % adicional: $additionalResult\n';

      final LIBRASXHA = kgXHa * (additionalResult / 100) * 100;
      resultadoController.text +=
          'LIBRAS X HA: ${LIBRASXHA.toStringAsFixed(2)}\n';

      final LIBRASTOTAL = LIBRASXHA * hectareas;
      resultadoController.text +=
          'LIBRAS TOTAL : ${LIBRASTOTAL.toStringAsFixed(2)}\n';

      additionalBarGroups = [
        BarChartGroupData(
          x: 0,
          barRods: [
            BarChartRodData(toY: additionalResult, color: Colors.orange)
          ],
        ),
        BarChartGroupData(
          x: 1,
          barRods: [BarChartRodData(toY: LIBRASXHA, color: Colors.purple)],
        ),
        BarChartGroupData(
          x: 2,
          barRods: [BarChartRodData(toY: LIBRASTOTAL, color: Colors.red)],
        ),
      ];
    }

    final librasXHa = kgXHa * 2;
    final librasTotal = librasXHa * 1.5;

    barGroups = [
      BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: kgXHa, color: Colors.lightBlue)],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: librasXHa, color: Colors.lightGreen)],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: librasTotal, color: Colors.pinkAccent)],
      ),
    ];

    setState(() {});
  }

  void resetFields() {
    setState(() {
      selectedPiscina = null;
      hectareasController.clear();
      pesoController.clear();
      consumoController.clear();
      gramosController.clear();
      enteroController.clear();
      rendimientoController.clear();
      resultadoController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildDropdownPiscina(),
                const SizedBox(height: 20),
                buildTextField(hectareasController, 'Hectareas'),
                const SizedBox(height: 20),
                buildTextField(pesoController, 'Peso'),
                const SizedBox(height: 20),
                buildTextField(consumoController, 'Consumo'),
                const SizedBox(height: 20),
                buildTextField(gramosController, 'Gramos'),
                const SizedBox(height: 20),
                buildTextField(enteroController, 'Entero'),
                const SizedBox(height: 20),
                buildTextField(rendimientoController, 'Rendimiento'),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: calculateAndDisplayResult,
                  child: const Text('Calcular'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: resetFields,
                  child: const Text('Resetear Campos'),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: resultadoController,
                  readOnly: true,
                  maxLines: null,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Resultado',
                    border: OutlineInputBorder(),
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 300,
                  child: buildBarChart(barGroups, 'primary'),
                ),
                const SizedBox(height: 20),
                Container(
                  height: 300,
                  child: buildBarChart(additionalBarGroups, 'secondary'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDropdownPiscina() {
    return DropdownButtonFormField<int>(
      decoration: const InputDecoration(
        labelText: 'Piscina',
        border: OutlineInputBorder(),
      ),
      value: selectedPiscina,
      items: piscinaNumbers.map((int value) {
        return DropdownMenuItem<int>(
          value: value,
          child: Text(value.toString()),
        );
      }).toList(),
      onChanged: (int? newValue) {
        setState(() {
          selectedPiscina = newValue;
        });
      },
    );
  }

  Widget buildTextField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget buildBarChart(List<BarChartGroupData> barGroups, String chartType) {
    double maxYValue = barGroups.fold<double>(
      0,
      (previousValue, element) => max(previousValue,
          element.barRods.fold(0, (prev, rod) => max(prev, rod.toY))),
    );

    maxYValue *= 1.1;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: maxYValue,
        barGroups: barGroups,
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (double value, TitleMeta meta) {
                if (chartType == 'primary') {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('KG X HA');
                    case 1:
                      return const Text('LIBRAS X HA');
                    case 2:
                      return const Text('LIBRAS TOTAL');
                    default:
                      return const Text('');
                  }
                } else {
                  switch (value.toInt()) {
                    case 0:
                      return const Text('RESULT%');
                    case 1:
                      return const Text('LIBRAS X HA');
                    case 2:
                      return const Text('L TOTAL ');
                    default:
                      return const Text('');
                  }
                }
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
        ),
      ),
    );
  }
}
