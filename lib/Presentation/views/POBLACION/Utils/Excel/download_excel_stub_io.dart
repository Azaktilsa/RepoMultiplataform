// archivo: lib/utils/download_excel_stub_io.dart

import 'dart:typed_data';
import 'io_download.dart';

Future<void> downloadExcel(Uint8List bytes, String fileName) {
  return downloadExcelIO(bytes, fileName);
}
