// ignore_for_file: deprecated_member_use

import 'dart:typed_data';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Utils/Pdf/pdf_saver_stub.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Widgets/resultado_data.dart';

Future<void> exportarAPDF(List<ResultadoData> data) async {
  final font = pw.Font.ttf(
    await rootBundle.load('assets/fonts/static/NotoSans-Regular.ttf'),
  );

  final pdf = pw.Document();

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Table.fromTextArray(
          headers: ['Campo', 'Valor'],
          data: data.map((e) => [e.campo, e.valor]).toList(),
          headerStyle: pw.TextStyle(font: font, fontWeight: pw.FontWeight.bold),
          cellStyle: pw.TextStyle(font: font),
          cellAlignment: pw.Alignment.centerLeft,
        );
      },
    ),
  );

  final Uint8List bytes = await pdf.save();
  await savePdf(
      bytes); // ← esta función se resuelve automáticamente según la plataforma
}
