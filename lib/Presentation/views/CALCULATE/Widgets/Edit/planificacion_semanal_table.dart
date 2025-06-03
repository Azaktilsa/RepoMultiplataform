// Widget para tabla: Planificacion Semanal

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:azaktilza/Presentation/Utils/gradient_colors.dart';

class PlanificacionSemanalTable extends StatelessWidget {
  final Map<String, String> data;
  final String typeFinca;
  const PlanificacionSemanalTable(
      {super.key, required this.data, required this.typeFinca});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: getGradientColors(typeFinca),
          ),
          boxShadow: const [
            BoxShadow(
              offset: Offset(-5, 5),
              color: Color.fromARGB(80, 0, 0, 0),
              blurRadius: 20,
            ),
            BoxShadow(
              offset: Offset(5, -5),
              color: Color.fromARGB(80, 0, 0, 0),
              blurRadius: 20,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "📅 Planificación Semanal",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 126, 53, 0),
                  ),
                ),
                const SizedBox(height: 10),
                Table(
                  columnWidths: const {
                    0: FlexColumnWidth(2),
                    1: FlexColumnWidth(3),
                  },
                  children: [
                    _buildRow("Lunes", data['Lunesdia1'], Colors.orange,
                        isHeader: true),
                    _spacerRow(),
                    _buildRow("Martes", data['Martesdia2'], Colors.orange,
                        isHeader: false),
                    _spacerRow(),
                    _buildRow("Miércoles", data['Miercolesdia3'], Colors.orange,
                        isHeader: true),
                    _spacerRow(),
                    _buildRow("Jueves", data['Juevesdia4'], Colors.orange,
                        isHeader: false),
                    _spacerRow(),
                    _buildRow("Viernes", data['Viernesdia5'], Colors.orange,
                        isHeader: true),
                    _spacerRow(),
                    _buildRow("Sábado", data['Sabadodia6'], Colors.orange,
                        isHeader: false),
                    _spacerRow(),
                    _buildRow("Domingo", data['Domingodia7'], Colors.orange,
                        isHeader: true),
                    _spacerRow(),
                    _buildRow("Promedio Semanal", data['Recomendationsemana'],
                        Colors.orange,
                        isHeader: false),
                    _spacerRow(),
                    _buildRow("Acumulado Semanal", data['Acumuladosemanal'],
                        Colors.orange,
                        isHeader: true),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  static final NumberFormat numberFormatter = NumberFormat("#,##0.##", "en_US");

  TableRow _buildRow(String label, String? value, Color color,
      {bool isHeader = false}) {
    String displayValue = value ?? "";

    // Intentamos formatear si es numérico
    if (value != null) {
      final parsed = num.tryParse(value.replaceAll(",", ""));
      if (parsed != null) {
        displayValue = numberFormatter.format(parsed);
      }
    }
    return TableRow(
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(12),
          color: isHeader
              ? color.withOpacity(0.1)
              : const Color.fromARGB(255, 155, 155, 155).withOpacity(0.1),
        ),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  color: isHeader ? color : Colors.black,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(5),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(displayValue),
              ),
            ),
          ),
        ]);
  }

  TableRow _spacerRow() {
    return const TableRow(
      children: [
        SizedBox(height: 5),
        SizedBox(height: 5),
      ],
    );
  }
}
