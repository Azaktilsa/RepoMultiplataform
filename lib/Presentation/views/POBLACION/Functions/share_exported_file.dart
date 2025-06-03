// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Widgets/resultado_data.dart';

class ShareRenderedImage {
  static Future<void> renderAndShare({
    required BuildContext context,
    required List<ResultadoData> data,
    required String typefinca,
    String? title,
  }) async {
    await ShareRenderedImage.renderAndShare(
      context: context,
      data: data,
      typefinca: typefinca,
      title: title,
    );
  }
}
