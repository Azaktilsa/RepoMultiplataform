import 'package:flutter/material.dart';
import 'custom_textfield.dart.dart';

class FechasWidget extends StatelessWidget {
  final TextEditingController pesosiembraController;
  final TextEditingController fechaSiembraController;
  final TextEditingController fechaMuestreoController;
  final TextEditingController edadCultivoController;
  final TextEditingController pesoanteriorController;
  final TextEditingController densidadbiologoindm2Controller;
  final TextEditingController densidadatarrayaController;
  final TextEditingController pesoactualgdiaController;
  final TextEditingController alimentoactualkgController;
  final Function(BuildContext, TextEditingController) seleccionarFecha;
  final Function(TextEditingController) validarYActualizarFecha;
  final VoidCallback calcularEdadCultivo;
  final Widget tipoBalanceadoWidget;
  final TextEditingController acumuladoActualLBSController;
  final TextEditingController numeroAAController;
  final List<String> itemsMarcaAA;
  final String selectedMarcaAA;
  final Widget Function(List<String>, String, String) buildMarcaAASelect;
  final TextEditingController hAireadoresMecanicosController;

  const FechasWidget({
    super.key,
    required this.pesosiembraController,
    required this.fechaSiembraController,
    required this.fechaMuestreoController,
    required this.edadCultivoController,
    required this.seleccionarFecha,
    required this.validarYActualizarFecha,
    required this.calcularEdadCultivo,
    required this.pesoanteriorController,
    required this.pesoactualgdiaController,
    required this.alimentoactualkgController,
    required this.densidadbiologoindm2Controller,
    required this.densidadatarrayaController,
    required this.tipoBalanceadoWidget,
    required this.acumuladoActualLBSController,
    required this.numeroAAController,
    required this.itemsMarcaAA,
    required this.selectedMarcaAA,
    required this.buildMarcaAASelect,
    required this.hAireadoresMecanicosController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fecha de siembra ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 2),
          _buildFechaTextField(
            context,
            controller: fechaSiembraController,
            label: 'Fecha de siembra (dd/MM/yyyy)',
            onIconPressed: () =>
                seleccionarFecha(context, fechaSiembraController),
            onChanged: () => validarYActualizarFecha(fechaSiembraController),
          ),
          const SizedBox(height: 10),
          const Text(
            'Fecha de muestreo',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 2),
          _buildFechaTextField(
            context,
            controller: fechaMuestreoController,
            label: 'Fecha de muestreo (dd/MM/yyyy)',
            onIconPressed: () =>
                seleccionarFecha(context, fechaMuestreoController),
            onChanged: () => validarYActualizarFecha(fechaMuestreoController),
          ),
          const SizedBox(height: 10),
          const Text(
            'Edad del Cultivo',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 2),
          TextField(
            controller: edadCultivoController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: const Icon(
                  Icons.hourglass_bottom_rounded,
                  color: Color.fromARGB(255, 126, 53, 0),
                ),
                onPressed: calcularEdadCultivo,
              ),
            ),
            readOnly: true,
          ),
          const SizedBox(height: 10),
          buildField('Peso Siembra', pesosiembraController),
          buildField('Peso Anterior', pesoanteriorController),
          buildField('Peso actual g/día', pesoactualgdiaController),
          buildField('Alimento actual kg', alimentoactualkgController),
          buildField(
              'Densidad Biologo (Ind/m2)', densidadbiologoindm2Controller),
          buildField('Densidad por Atarraya', densidadatarrayaController),
          const SizedBox(height: 20),
          tipoBalanceadoWidget,
          const _LabelText('Acumulado actual LBS'),
          CustomTextField(
            controller: acumuladoActualLBSController,
            label: '0.00',
            keyboardType: TextInputType.number,
            isReadOnly: false,
          ),
          const SizedBox(height: 10),
          const _LabelText('Número AA'),
          CustomTextField(
            controller: numeroAAController,
            label: '0.00',
            keyboardType: TextInputType.number,
            isReadOnly: false,
          ),
          const SizedBox(height: 10),
          buildMarcaAASelect(
            itemsMarcaAA,
            selectedMarcaAA,
            "Marca AA:",
          ),
          const SizedBox(height: 10),
          const _LabelText(
            '# Aireadores Mecanicos',
          ),
          CustomTextField(
            controller: hAireadoresMecanicosController,
            label: '0.00',
            keyboardType: TextInputType.number,
            isReadOnly: false,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildFechaTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required VoidCallback onIconPressed,
    required VoidCallback onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: const Color(0xfff4f4f4),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(80, 0, 0, 0),
            offset: Offset(5, 5),
            blurRadius: 5,
          ),
          BoxShadow(
            color: Color.fromARGB(147, 202, 202, 202),
            offset: Offset(-5, -5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 126, 53, 0),
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 126, 53, 0),
              ),
            ),
            suffixIcon: IconButton(
              icon: const Icon(
                Icons.calendar_today,
                color: Color.fromARGB(255, 126, 53, 0),
              ),
              onPressed: onIconPressed,
            ),
          ),
          keyboardType: TextInputType.datetime,
          onChanged: (_) => onChanged(),
        ),
      ),
    );
  }

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
}

class _LabelText extends StatelessWidget {
  final String text;

  const _LabelText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, top: 10),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 22,
        ),
      ),
    );
  }
}
