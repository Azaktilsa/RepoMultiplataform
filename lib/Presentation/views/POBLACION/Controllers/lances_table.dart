// lances_table.dart

import 'package:flutter/material.dart';

class LancesTable extends StatelessWidget {
  final List<TextEditingController> camaronesControllers;
  final List<TextEditingController> bactimetriaControllers;
  final VoidCallback onUpdate;

  const LancesTable({
    super.key,
    required this.camaronesControllers,
    required this.bactimetriaControllers,
    required this.onUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final rows = <TableRow>[
      const TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Lances',
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
              'Camarones',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Bactimetría',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
      ...List.generate(camaronesControllers.length, (i) {
        return TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${i + 1}',
                  style: TextStyle(color: Colors.blueGrey[800])),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: camaronesControllers[i],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 126, 53, 0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 126, 53, 0)),
                  ),
                ),
                style: const TextStyle(color: Colors.black87),
                onChanged: (_) => onUpdate(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: bactimetriaControllers[i],
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 126, 53, 0)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 126, 53, 0)),
                  ),
                ),
                style: const TextStyle(color: Colors.black87),
                onChanged: (_) => onUpdate(),
              ),
            ),
          ],
        );
      }),
    ];

    return Table(
      border: TableBorder.all(color: Colors.transparent),
      children: rows,
    );
  }
}
