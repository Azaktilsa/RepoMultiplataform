import 'package:flutter/material.dart';

class PiscinaCard extends StatelessWidget {
  final Color color;
  final Map<String, dynamic> result;

  const PiscinaCard({Key? key, required this.color, required this.result})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40.0),
          bottomRight: Radius.circular(40.0),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(40.0),
            bottomRight: Radius.circular(40.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Piscina: ${result['Piscina']}',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text('FechaHora: ${result['FechaHora'] ?? "N/A"}'),
              const SizedBox(height: 4),
              Text('Hectareas: ${result['Hectareas'] ?? "N/A"}'),
              const SizedBox(height: 4),
              Text('Consumo: ${result['Consumo'].toStringAsFixed(2)}'),
            ],
          ),
        ),
      ),
    );
  }
}
