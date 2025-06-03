import 'package:flutter/material.dart';
import 'package:azaktilza/Presentation/Utils/gradient_colors.dart';
import 'custom_table_row.dart';

class ResultCard extends StatelessWidget {
  final bool showResults;
  final TextEditingController hectareasController;
  final TextEditingController piscinasController;
  final TextEditingController gramosController;
  final TextEditingController rendimientoController;
  final TextEditingController kgXHaController;
  final TextEditingController librasTotalController;
  final TextEditingController error2Controller;
  final TextEditingController librasXHaController;
  final TextEditingController animalesMController;
  final String typeFinca;

  const ResultCard({
    super.key,
    required this.showResults,
    required this.hectareasController,
    required this.piscinasController,
    required this.gramosController,
    required this.rendimientoController,
    required this.kgXHaController,
    required this.librasTotalController,
    required this.error2Controller,
    required this.librasXHaController,
    required this.animalesMController,
    required this.typeFinca,
  });

  @override
  Widget build(BuildContext context) {
    if (!showResults) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          const Text(
            'Resultados:',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 8,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: getGradientColors(typeFinca),
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(10, 10),
                      color: Color.fromARGB(80, 0, 0, 0),
                      blurRadius: 10,
                    ),
                    BoxShadow(
                      offset: Offset(-10, -10),
                      color: Color.fromARGB(147, 202, 202, 202),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Table(
                    border: const TableBorder(
                      horizontalInside: BorderSide(color: Colors.transparent),
                      verticalInside: BorderSide(color: Colors.transparent),
                    ),
                    columnWidths: const {
                      0: FixedColumnWidth(120.0),
                      1: FlexColumnWidth(),
                    },
                    children: [
                      CustomTableRow(
                        label: 'Hectareas',
                        controller: hectareasController,
                        unit: 'ha',
                      ),
                      CustomTableRow(
                        label: 'Piscinas',
                        controller: piscinasController,
                        unit: 'Pisc',
                      ),
                      CustomTableRow(
                        label: 'Gramos',
                        controller: gramosController,
                        unit: 'g',
                      ),
                      CustomTableRow(
                        label: 'Rendimiento',
                        controller: rendimientoController,
                        unit: 'R',
                      ),
                      CustomTableRow(
                        label: 'KGXHA',
                        controller: kgXHaController,
                        unit: 'kg/ha',
                      ),
                      CustomTableRow(
                        label: 'LibrasTotal',
                        controller: librasTotalController,
                        unit: 'lb',
                        readOnly: true,
                      ),
                      CustomTableRow(
                        label: 'Error 2%',
                        controller: error2Controller,
                        unit: '%',
                        readOnly: true,
                      ),
                      CustomTableRow(
                        label: 'LibrasXHA',
                        controller: librasXHaController,
                        unit: 'lb/ha',
                        readOnly: true,
                      ),
                      CustomTableRow(
                        label: 'AnimalesM',
                        controller: animalesMController,
                        readOnly: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
