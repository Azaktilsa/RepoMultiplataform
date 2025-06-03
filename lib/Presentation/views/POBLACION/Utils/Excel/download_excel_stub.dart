import 'dart:typed_data';

export 'download_excel_stub_io.dart'
    if (dart.library.html) 'web_download.dart'
    if (dart.library.io) 'io_download.dart';

Future<void> downloadExcel(Uint8List bytes, String fileName) {
  throw UnsupportedError('downloadExcel is not supported on this platform.');
}
