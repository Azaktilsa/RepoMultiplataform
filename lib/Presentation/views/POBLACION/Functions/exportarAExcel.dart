// ignore_for_file: unused_local_variable
import 'package:azaktilza/Presentation/views/POBLACION/Utils/Excel/download_excel_stub.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Widgets/resultado_data.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'package:flutter/foundation.dart'; // para kIsWeb

Future<void> exportarAExcel(List<ResultadoData> data) async {
  final xlsio.Workbook workbook = xlsio.Workbook();
  final xlsio.Worksheet sheet = workbook.worksheets[0];

  sheet.getRangeByName('A1').setText('Campo');
  sheet.getRangeByName('B1').setText('Valor');

  for (int i = 0; i < data.length; i++) {
    sheet.getRangeByIndex(i + 2, 1).setText(data[i].campo);
    sheet.getRangeByIndex(i + 2, 2).setText(data[i].valor);
  }

  final List<int> bytes = workbook.saveAsStream();
  workbook.dispose();

  await downloadExcel(Uint8List.fromList(bytes), 'resultado.xlsx');
}
