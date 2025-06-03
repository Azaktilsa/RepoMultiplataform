// Widget para tabla: Totales Recomendaciones

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:azaktilza/Presentation/Utils/gradient_colors.dart';

class TotalesRecomendacionesTable extends StatelessWidget {
  final Map<String, String> data;
  final String typeFinca;
  const TotalesRecomendacionesTable(
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
                  "📦 Totales y Recomendaciones",
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
                    _buildRow("Tipo Balanceado", data['TipoBalanceado'],
                        Colors.indigo.shade300,
                        isHeader: true),
                    _spacerRow(),
                    _buildRow("Acumulado Actual LBS",
                        data['AcumuladoactualLBS'], Colors.indigo.shade300,
                        isHeader: false),
                    _spacerRow(),
                    _buildRow("LBS/ha Consumo", data['LBShaconsumo'],
                        Colors.indigo.shade300,
                        isHeader: true),
                    _spacerRow(),
                    _buildRow("LBS/ha Actual Campo", data['LBShaactualcampo'],
                        Colors.indigo.shade300,
                        isHeader: false),
                    _spacerRow(),
                    _buildRow(
                      "FCA Campo",
                      data['FCACampo'],
                      Colors.indigo.shade300,
                      isHeader: true,
                    ),
                    _spacerRow(),
                    _buildRow("FCA Consumo", data['FCAConsumo'],
                        Colors.indigo.shade300,
                        isHeader: false),
                    _spacerRow(),
                    _buildRow("Rendimiento Lbs/Saco",
                        data['RendimientoLbsSaco'], Colors.indigo.shade300,
                        isHeader: true),
                    _spacerRow(),
                    _buildRow("Libras Totales Campo",
                        data['Librastotalescampo'], Colors.indigo.shade300,
                        isHeader: false),
                    _spacerRow(),
                    _buildRow("Libras Totales Consumo",
                        data['Librastotalesconsumo'], Colors.indigo.shade300,
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
