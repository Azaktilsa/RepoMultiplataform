// pdf_saver_io.dart
import 'dart:typed_data';
import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

Future<void> savePdfIO(Uint8List bytes) async {
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/resultado.pdf';
  final file = File(filePath);
  await file.writeAsBytes(bytes);
  await OpenFile.open(filePath);
}
