import 'package:flutter/material.dart';

class BotonesExportacion extends StatelessWidget {
  final VoidCallback onExportExcel;
  final VoidCallback onExportPDF;

  const BotonesExportacion({
    super.key,
    required this.onExportExcel,
    required this.onExportPDF,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton.icon(
          onPressed: onExportExcel,
          icon: const Icon(Icons.file_download),
          label: const Text("Exportar Excel"),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: onExportPDF,
          icon: const Icon(Icons.picture_as_pdf),
          label: const Text("Exportar PDF"),
        ),
      ],
    );
  }
}
