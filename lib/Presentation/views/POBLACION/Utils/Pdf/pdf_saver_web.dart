// pdf_saver_web.dart
import 'dart:html' as html;
import 'dart:typed_data';

Future<void> savePdfWeb(Uint8List bytes) async {
  final blob = html.Blob([bytes]);
  final url = html.Url.createObjectUrlFromBlob(blob);
  html.AnchorElement(href: url)
    ..setAttribute("download", "resultado.pdf")
    ..click();
  html.Url.revokeObjectUrl(url);
}
