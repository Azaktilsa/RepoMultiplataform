import 'package:flutter/material.dart';
import 'package:azaktilza/Presentation/Utils/getBackgroundColor.dart';
import 'package:azaktilza/Presentation/Utils/gradient_colors.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'resultado_data_source.dart';

class TablaDinamicaResultado extends StatelessWidget {
  final ResultadoDataGridSource dataSource;
  final String typeFinca;

  const TablaDinamicaResultado({
    super.key,
    required this.dataSource,
    required this.typeFinca,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getGradientColors(typeFinca),
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8.0,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Material(
          color: getBackgroundColor(typeFinca).withOpacity(0.9),
          child: SfDataGrid(
            source: dataSource,
            allowSorting: true,
            allowFiltering: true,
            allowEditing: false,
            columnWidthMode: ColumnWidthMode.fill,
            gridLinesVisibility: GridLinesVisibility.both,
            headerGridLinesVisibility: GridLinesVisibility.horizontal,
            columns: [
              GridColumn(
                columnName: 'campo',
                label: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12.0),
                  child: const Text(
                    'Campo',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
              GridColumn(
                columnName: 'valor',
                label: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(12.0),
                  child: const Text(
                    'Valor',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.blueGrey,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
