// detalles_terreno_card.dart

import 'package:flutter/material.dart';
import 'package:azaktilza/Presentation/Utils/gradient_colors.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Widgets/custom_text_fields.dart';

class DetallesTerrenoCard extends StatelessWidget {
  final TextEditingController hectareasController;
  final TextEditingController piscinasController;
  final TextEditingController cantidadSiembraController;
  final TextEditingController densidadSiembraController;
  final TextEditingController pesoController;
  final TextEditingController fechaPoblacionController;
  final String typeFinca;
  final void Function(DateTime)? onFechaSeleccionada;

  const DetallesTerrenoCard({
    super.key,
    required this.hectareasController,
    required this.piscinasController,
    required this.cantidadSiembraController,
    required this.densidadSiembraController,
    required this.pesoController,
    required this.fechaPoblacionController,
    this.onFechaSeleccionada,
    required this.typeFinca,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: getGradientColors(typeFinca),
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
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
          child: Column(
            children: [
              const Text(
                'Detalles de terreno',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color.fromARGB(255, 77, 77, 77),
                ),
              ),
              const SizedBox(height: 10.0),
              _buildRow('Piscinas:', piscinasController, readOnly: true),
              _buildRow('Hectareas:', hectareasController, readOnly: true),
              _buildColumn('Cantidad de Siembra', cantidadSiembraController),
              _buildColumn('Densidad de Siembra', densidadSiembraController,
                  readOnly: true),
              _buildColumn('Peso en gramos', pesoController),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Fecha de Población',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromARGB(255, 77, 77, 77),
                      ),
                    ),
                    TextField(
                      controller: fechaPoblacionController,
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: 'dd-MM-yyyy',
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 126, 53, 0),
                          ),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(255, 126, 53, 0),
                          ),
                        ),
                      ),
                      onTap: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          fechaPoblacionController.text =
                              '${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year}';
                          if (onFechaSeleccionada != null) {
                            onFechaSeleccionada!(pickedDate);
                          }
                        }
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 77, 77, 77),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: CustomTextFieldContent(
              label: '0.00',
              controller: controller,
              keyboardType: TextInputType.number,
              isReadOnly: readOnly,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildColumn(String label, TextEditingController controller,
      {bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Color.fromARGB(255, 77, 77, 77),
            ),
          ),
          CustomTextFieldContent(
            label: '0.00',
            controller: controller,
            keyboardType: TextInputType.number,
            isReadOnly: readOnly,
          ),
        ],
      ),
    );
  }
}
