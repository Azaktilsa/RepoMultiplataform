// ignore_for_file: unused_local_variable

import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Widgets/resultado_data.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class ShareRenderedImage {
  static Future<void> renderAndShare({
    required BuildContext context,
    required List<ResultadoData> data,
    required String typefinca,
    String? title,
  }) async {
    try {
      final Uint8List pngBytes = await _generateImage(data, typefinca, title);
      final blob = html.Blob([pngBytes]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", "reporte_camanovillo.png")
        ..click();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al compartir (web): $e')),
      );
    }
  }

  static Future<Uint8List> _generateImage(
      List<ResultadoData> data, String typefinca, String? title) async {
    const double width = 800;
    const double rowHeight = 60;
    const double headerHeight = 150;
    final double contentHeight = (data.length + 1) * rowHeight;
    final double totalHeight = headerHeight + contentHeight;

    final String resolvedTitle = title ?? 'Resumen de Datos $typefinca';

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);

    // Fondo blanco
    canvas.drawRect(
        Rect.fromLTWH(0, 0, width, totalHeight), Paint()..color = Colors.white);

    // Cargar logo
    final ByteData logoData =
        await rootBundle.load('assets/images/logoOscuro3.jpeg');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final ui.Codec codec =
        await ui.instantiateImageCodec(logoBytes, targetHeight: 80);
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ui.Image logoImage = frame.image;

    // Dibujar logo en la esquina izquierda
    // Título centrado
    final paragraphStyle = ui.ParagraphStyle(textAlign: TextAlign.center);
    final titleStyle = ui.TextStyle(
        color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold);
    final builder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(titleStyle)
      ..addText(resolvedTitle);
    final paragraph = builder.build()
      ..layout(const ui.ParagraphConstraints(width: width));
    canvas.drawParagraph(paragraph, const Offset(0, 40));

    // Encabezados
    final headerTextStyle = ui.TextStyle(
        color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold);
    final cellTextStyle = ui.TextStyle(color: Colors.black87, fontSize: 24);
    double yOffset = headerHeight;

    final headers = ['Campo', 'Valor'];
    double xOffset = 20;
    for (final header in headers) {
      final builder = ui.ParagraphBuilder(paragraphStyle)
        ..pushStyle(headerTextStyle)
        ..addText(header);
      final paragraph = builder.build()
        ..layout(const ui.ParagraphConstraints(width: 350));
      canvas.drawParagraph(paragraph, Offset(xOffset, yOffset));
      xOffset += 380;
    }

    // Dibujar datos
    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final y = headerHeight + ((i + 1) * rowHeight);
      final values = [item.campo, item.valor];
      double x = 20;

      for (final value in values) {
        final builder = ui.ParagraphBuilder(paragraphStyle)
          ..pushStyle(cellTextStyle)
          ..addText(value);
        final paragraph = builder.build()
          ..layout(const ui.ParagraphConstraints(width: 350));
        canvas.drawParagraph(paragraph, Offset(x, y));
        x += 380;
      }
    }

    // Finalizar imagen
    final picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), totalHeight.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    // DESCARGAR en Web
    final blob = html.Blob([pngBytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "reporte_camanovillo.png")
      ..click();
    html.Url.revokeObjectUrl(url);

    // Fallback in case something goes wrong and no return occurs
    throw Exception('Failed to generate image');
  }
}
