import 'package:flutter/material.dart';
import 'custom_textfield.dart.dart';

class SemanaDiasWidget extends StatelessWidget {
  final TextEditingController lunesController;
  final TextEditingController martesController;
  final TextEditingController miercolesController;
  final TextEditingController juevesController;
  final TextEditingController viernesController;
  final TextEditingController sabadoController;
  final TextEditingController domingoController;
  final TextEditingController recomendacionController;
  final TextEditingController acumuladoController;

  const SemanaDiasWidget({
    super.key,
    required this.lunesController,
    required this.martesController,
    required this.miercolesController,
    required this.juevesController,
    required this.viernesController,
    required this.sabadoController,
    required this.domingoController,
    required this.recomendacionController,
    required this.acumuladoController,
  });

  Widget _buildRow(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 22,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Flexible(
            child: CustomTextField(
              controller: controller,
              label: '0.00',
              keyboardType: TextInputType.number,
              isReadOnly: false,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow('Lunes Día 1', lunesController),
          _buildRow('Martes Día 2', martesController),
          _buildRow('Miércoles Día 3', miercolesController),
          _buildRow('Jueves Día 4', juevesController),
          _buildRow('Viernes Día 5', viernesController),
          _buildRow('Sábado Día 6', sabadoController),
          _buildRow('Domingo Día 7', domingoController),
          _buildRow(
              'Recomendación promedio de semana', recomendacionController),
          _buildRow('Acumulado Semanal AB', acumuladoController),
        ],
      ),
    );
  }
}
