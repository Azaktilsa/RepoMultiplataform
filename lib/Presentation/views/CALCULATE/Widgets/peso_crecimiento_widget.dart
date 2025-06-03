import 'package:flutter/material.dart';
import 'custom_textfield.dart.dart';

class PesoCrecimientoWidget extends StatelessWidget {
  final TextEditingController crecimactualgdiaController;

  final TextEditingController incrementogrController;
  final TextEditingController pesoproyectadogdiaController;
  final TextEditingController crecimientoesperadosemController;

  final TextEditingController sacosactualesController;
  final TextEditingController kg100milController;
  final TextEditingController densidadconsumoim2Controller;

  final TextEditingController diferenciacampobiologoController;

  const PesoCrecimientoWidget({
    super.key,
    required this.crecimactualgdiaController,
    required this.incrementogrController,
    required this.pesoproyectadogdiaController,
    required this.crecimientoesperadosemController,
    required this.sacosactualesController,
    required this.kg100milController,
    required this.densidadconsumoim2Controller,
    required this.diferenciacampobiologoController,
  });

  Widget buildField(String title, TextEditingController controller,
      {bool isReadOnly = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 2),
        CustomTextField(
          controller: controller,
          label: '0.00',
          keyboardType: TextInputType.number,
          isReadOnly: isReadOnly,
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildField('Crecimiento actual g/día', crecimactualgdiaController),
        buildField('Incremento gr', incrementogrController),
        buildField('Peso proyectado g/día', pesoproyectadogdiaController),
        buildField(
            'Crecimiento Esperado g/sem', crecimientoesperadosemController),
        buildField('Sacos Actuales', sacosactualesController),
        buildField('Kg/100 mil', kg100milController, isReadOnly: true),
        buildField('Densidad por consumo i/m2', densidadconsumoim2Controller,
            isReadOnly: true),
        buildField(
            'Diferencia campo vs biologo', diferenciacampobiologoController),
      ],
    );
  }
}
