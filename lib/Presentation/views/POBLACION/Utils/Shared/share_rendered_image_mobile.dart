import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Widgets/resultado_data.dart';

class ShareRenderedImage {
  static Future<void> renderAndShare({
    required BuildContext context,
    required List<ResultadoData> data,
    required String typefinca,
    String? title,
  }) async {
    try {
      final Uint8List pngBytes = await _generateImage(data, typefinca, title);
      final dir = await getTemporaryDirectory();
      final file = io.File('${dir.path}/reporte_camanovillo.png');
      await file.writeAsBytes(pngBytes);
      await Share.shareXFiles([XFile(file.path)], text: title ?? 'Resumen');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al compartir (móvil): $e')),
      );
    }
  }

  static Future<Uint8List> _generateImage(List<ResultadoData> data, String typefinca, String? title) async {
    const double width = 800;
    const double rowHeight = 60;
    const double headerHeight = 150;
    final double contentHeight = (data.length + 1) * rowHeight;
    final double totalHeight = headerHeight + contentHeight;

    final String resolvedTitle = title ?? 'Resumen de Datos $typefinca';

    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    canvas.drawRect(Rect.fromLTWH(0, 0, width, totalHeight),
        Paint()..color = Colors.white);

    final ByteData logoData = await rootBundle.load('assets/images/logoOscuro3.jpeg');
    final Uint8List logoBytes = logoData.buffer.asUint8List();
    final ui.Codec codec = await ui.instantiateImageCodec(logoBytes, targetHeight: 80);
    final ui.FrameInfo frame = await codec.getNextFrame();
    final ui.Image logoImage = frame.image;
    canvas.drawImage(logoImage, const Offset(20, 20), Paint());

    final paragraphStyle = ui.ParagraphStyle(textAlign: TextAlign.center);
    final titleStyle = ui.TextStyle(color: Colors.black, fontSize: 32, fontWeight: FontWeight.bold);
    final builder = ui.ParagraphBuilder(paragraphStyle)
      ..pushStyle(titleStyle)
      ..addText(resolvedTitle);
    final paragraph = builder.build()
      ..layout(const ui.ParagraphConstraints(width: width));
    canvas.drawParagraph(paragraph, const Offset(0, 40));

    final headerTextStyle = ui.TextStyle(color: Colors.black, fontSize: 26, fontWeight: FontWeight.bold);
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

    final picture = recorder.endRecording();
    final img = await picture.toImage(width.toInt(), totalHeight.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
