// resultados_table.dart

import 'package:flutter/material.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/Widgets/custom_textfield.dart.dart';

class ResultadosTable extends StatelessWidget {
  final Map<String, TextEditingController> data;

  const ResultadosTable({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final rows = <TableRow>[
      const TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Datos',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Resultado',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
      ...data.entries.map((entry) {
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Text(
                entry.key,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black87),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: CustomTextField(
                controller: entry.value,
                label: '',
                keyboardType: TextInputType.number,
                isReadOnly: true,
              ),
            ),
          ],
        );
      })
    ];

    return Table(
      border: TableBorder.all(color: Colors.transparent),
      children: rows,
    );
  }
}
