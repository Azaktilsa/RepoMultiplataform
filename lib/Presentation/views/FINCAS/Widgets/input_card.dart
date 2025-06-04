import 'package:flutter/material.dart';
import 'package:azaktilza/Presentation/Utils/gradient_colors.dart';

class InputCard extends StatelessWidget {
  final TextEditingController pesoController;
  final TextEditingController consumoController;
  final Key pesoKey;
  final Key consumoKey;
  final String typeFinca;

  const InputCard({
    super.key,
    required this.pesoController,
    required this.consumoController,
    required this.pesoKey,
    required this.consumoKey,
    required this.typeFinca,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Center(
          child: Text(
            "Ingresar los datos:",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5,
            margin: const EdgeInsets.all(10),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
                bottomLeft: Radius.circular(40.0),
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: getGradientColors(typeFinca),
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                ),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(-10, 10),
                    color: Color.fromARGB(80, 0, 0, 0),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    offset: Offset(10, -10),
                    color: Color.fromARGB(147, 202, 202, 202),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
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
                    _buildInputRow("Peso:", "Ingrese el Peso...",
                        pesoController, pesoKey, 'Peso en gramos (g)'),
                    _buildInputRow("Consumo:", "Ingrese el Consumo...",
                        consumoController, consumoKey, 'Consumo en gramos (g)'),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TableRow _buildInputRow(String label, String hint,
      TextEditingController controller, Key key, String tooltip) {
    return TableRow(
      children: [
        TableCell(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  key: key,
                  child: TextField(
                    controller: controller,
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    decoration: InputDecoration(
                      hintText: hint,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 126, 53, 0)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Color.fromARGB(255, 126, 53, 0)),
                      ),
                    ),
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
                const SizedBox(width: 5),
                Tooltip(
                  message: tooltip,
                  child: const Icon(
                    Icons.info,
                    color: Color.fromARGB(255, 176, 74, 11),
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
