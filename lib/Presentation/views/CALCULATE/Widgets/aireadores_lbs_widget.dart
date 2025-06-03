import 'package:flutter/material.dart';
import 'custom_textfield.dart.dart';

class AireadoresLBSWidget extends StatelessWidget {

  final TextEditingController librasTotalesPorAireadorController;
  final TextEditingController hpHaController;
  final TextEditingController recomendacionLbshaController;
  final TextEditingController librasTotalesCampoController;
  final TextEditingController librasTotalesConsumoController;

  const AireadoresLBSWidget({
    super.key,

    required this.librasTotalesPorAireadorController,
    required this.hpHaController,
    required this.recomendacionLbshaController,
    required this.librasTotalesCampoController,
    required this.librasTotalesConsumoController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        margin: const EdgeInsets.only(top: 2),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const Text(
              'Libras totales por Aireador',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            CustomTextField(
              controller: librasTotalesPorAireadorController,
              label: '0.00',
              keyboardType: TextInputType.number,
              isReadOnly: false,
            ),
            const SizedBox(height: 10),
            const Text(
              'Hp/Ha',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            CustomTextField(
              controller: hpHaController,
              label: '0.00',
              keyboardType: TextInputType.number,
              isReadOnly: false,
            ),
            const SizedBox(height: 10),
            const Text(
              'Recomendación Lbs/ha capacidad de carga',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            CustomTextField(
              controller: recomendacionLbshaController,
              label: '0.00',
              keyboardType: TextInputType.number,
              isReadOnly: false,
            ),
            const SizedBox(height: 10),
            const Text(
              'Libras totales campo',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            CustomTextField(
              controller: librasTotalesCampoController,
              label: '0.00',
              keyboardType: TextInputType.number,
              isReadOnly: false,
            ),
            const SizedBox(height: 10),
            const Text(
              'libras totales consumo',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
            ),
            CustomTextField(
              controller: librasTotalesConsumoController,
              label: '0.00',
              keyboardType: TextInputType.number,
              isReadOnly: false,
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
