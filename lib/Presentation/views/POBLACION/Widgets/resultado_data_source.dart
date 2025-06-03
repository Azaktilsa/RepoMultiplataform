import 'package:flutter/material.dart';
import 'package:azaktilza/Presentation/Utils/getBackgroundColor.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'resultado_data.dart';

class ResultadoDataGridSource extends DataGridSource {
  ResultadoDataGridSource(List<ResultadoData> data, this.typeFinca) {
    _rows = data
        .map<DataGridRow>((item) => DataGridRow(cells: [
              DataGridCell<String>(columnName: 'campo', value: item.campo),
              DataGridCell<String>(columnName: 'valor', value: item.valor),
            ]))
        .toList();
  }

  List<DataGridRow> _rows = [];
  final String typeFinca;

  @override
  List<DataGridRow> get rows => _rows;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    final int rowIndex = _rows.indexOf(row);
    final Color backgroundColor = rowIndex % 2 == 0
        ? getBackgroundColor(typeFinca).withOpacity(0.95)
        : getBackgroundColor(typeFinca).withOpacity(0.1);

    return DataGridRowAdapter(
      color: backgroundColor,
      cells: row.getCells().map<Widget>((cell) {
        return Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
          child: Text(
            cell.value.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        );
      }).toList(),
    );
  }
}
