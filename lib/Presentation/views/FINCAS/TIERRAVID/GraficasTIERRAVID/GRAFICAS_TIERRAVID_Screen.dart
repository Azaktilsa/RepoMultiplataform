// ignore_for_file: deprecated_member_use

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:azaktilza/Presentation/Utils/gradient_colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:azaktilza/env_loader.dart';
import 'package:intl/intl.dart';

class GRAFICAS_TIERRAVID_Screen extends StatefulWidget {
  const GRAFICAS_TIERRAVID_Screen({Key? key}) : super(key: key);

  @override
  _GRAFICAS_TIERRAVID_ScreenState createState() =>
      _GRAFICAS_TIERRAVID_ScreenState();
}

class _GRAFICAS_TIERRAVID_ScreenState extends State<GRAFICAS_TIERRAVID_Screen> {
  static const String _selectedFinca = 'TIERRAVID';

  late final DatabaseReference _databaseReference;
  final List<Map<String, dynamic>> _result = [];
  bool _showAllMetrics = true;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _databaseReference = FirebaseDatabase.instance
          .ref('${EnvLoader.get('RESULT_DATO_BASE')}/$_selectedFinca');
    } else {
      _databaseReference = FirebaseDatabase.instance
          .ref('${dotenv.env['RESULT_DATO_BASE']}/$_selectedFinca');
    }

    _fetchData();
  }

  void _fetchData() {
    _databaseReference.once().then((DatabaseEvent snapshot) {
      final data = snapshot.snapshot.value;
      if (data == null) return;

      final list = (data as Map).entries.map((entry) {
        final value = entry.value as Map<dynamic, dynamic>;
        return {
          'Piscina': value['Piscinas'] ?? 'Desconocida',
          'Consumo': (value['Consumo'] ?? 0).toDouble(),
          'Rendimiento': (value['Rendimiento'] ?? 0).toDouble(),
          'LibrasTotal': (value['LibrasTotal']?.toDouble() ?? 0.0),
          'KGXHA': (value['KGXHA']?.toDouble() ?? 0.0),
          'Error2': (value['Error2']?.toDouble() ?? 0.0),
          'AnimalesM': (value['AnimalesM']?.toDouble() ?? 0.0),
          'Peso': (value['Peso']?.toDouble() ?? 0.0),
          'Hectareas': (value['Hectareas']?.toString() ?? '0'),
          'FechaHora': value['FechaHora'] != null
              ? DateTime.tryParse(value['FechaHora'].toString())
              : null,
        };
      }).toList();

      // Ordenar por fecha más reciente primero
      list.sort((a, b) {
        final dateA = a['FechaHora'] as DateTime? ?? DateTime(0);
        final dateB = b['FechaHora'] as DateTime? ?? DateTime(0);
        return dateB.compareTo(dateA);
      });

      // Agrupar por piscina y mantener solo el registro más reciente de cada piscina
      final Map<String, Map<String, dynamic>> latestByPiscina = {};
      for (var item in list) {
        final piscina = item['Piscina'];
        if (!latestByPiscina.containsKey(piscina)) {
          latestByPiscina[piscina] = item;
        }
      }

      // Convertir a lista y tomar las primeras 5 piscinas
      final latestPiscinas = latestByPiscina.values.toList();
      final top5Piscinas = latestPiscinas.length > 5
          ? latestPiscinas.sublist(0, 5)
          : latestPiscinas;

      setState(() {
        _result
          ..clear()
          ..addAll(top5Piscinas);
      });
    });
  }

  Widget _buildAllMetricsChart() {
    return Container(
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getGradientColors(_selectedFinca),
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        boxShadow: const [
          BoxShadow(
            offset: Offset(10, 10),
            color: Color.fromARGB(80, 0, 0, 0),
            blurRadius: 10,
          ),
          BoxShadow(
            offset: Offset(-10, -10),
            color: Color.fromARGB(147, 202, 202, 202),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Métricas Completas por Piscina',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(
                    _showAllMetrics
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                  ),
                  onPressed: () {
                    setState(() {
                      _showAllMetrics = !_showAllMetrics;
                    });
                  },
                ),
              ],
            ),
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: SizedBox(
                height: _showAllMetrics ? null : 0,
                child: SfCartesianChart(
                  primaryXAxis: const CategoryAxis(
                    labelRotation: -45,
                    labelIntersectAction: AxisLabelIntersectAction.rotate45,
                  ),
                  primaryYAxis: NumericAxis(
                    numberFormat: NumberFormat.compact(),
                  ),
                  legend: const Legend(
                    isVisible: true,
                    position: LegendPosition.bottom,
                    overflowMode: LegendItemOverflowMode.wrap,
                  ),
                  tooltipBehavior: TooltipBehavior(enable: true),
                  series: [
                    ColumnSeries<Map<String, dynamic>, String>(
                      dataSource: _result,
                      xValueMapper: (data, _) => data['Piscina'],
                      yValueMapper: (data, _) => data['Consumo'],
                      name: 'Consumo',
                      color: Colors.blue[400],
                    ),
                    ColumnSeries<Map<String, dynamic>, String>(
                      dataSource: _result,
                      xValueMapper: (data, _) => data['Piscina'],
                      yValueMapper: (data, _) => data['Rendimiento'],
                      name: 'Rendimiento',
                      color: Colors.green[400],
                    ),
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: _result,
                      xValueMapper: (data, _) => data['Piscina'],
                      yValueMapper: (data, _) => data['LibrasTotal'],
                      name: 'Libras Total',
                      color: Colors.orange[400],
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: _result,
                      xValueMapper: (data, _) => data['Piscina'],
                      yValueMapper: (data, _) => data['KGXHA'],
                      name: 'KGXHA',
                      color: Colors.red[400],
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: _result,
                      xValueMapper: (data, _) => data['Piscina'],
                      yValueMapper: (data, _) => data['Error2'],
                      name: 'Error2',
                      color: Colors.purple[400],
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: _result,
                      xValueMapper: (data, _) => data['Piscina'],
                      yValueMapper: (data, _) => data['AnimalesM'],
                      name: 'AnimalesM',
                      color: Colors.teal[400],
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                    LineSeries<Map<String, dynamic>, String>(
                      dataSource: _result,
                      xValueMapper: (data, _) => data['Piscina'],
                      yValueMapper: (data, _) => data['Peso'],
                      name: 'Peso',
                      color: Colors.indigo[400],
                      markerSettings: const MarkerSettings(isVisible: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    final int crossAxisCount = screenWidth >= 1200
        ? 3
        : screenWidth >= 800
            ? 2
            : 1;

    final List<Widget> chartCards = [
      _buildSfChart(
        title: 'KGXHA por Piscina',
        yKey: 'KGXHA',
        chartType: _ChartType.column,
      ),
      _buildSfChart(
        title: 'Libras Totales por Piscina',
        yKey: 'LibrasTotal',
        chartType: _ChartType.doughnut,
      ),
      _buildSfChart(
        title: 'Peso vs AnimalesM por Fecha',
        yKey: 'Peso',
        secondYKey: 'AnimalesM',
        chartType: _ChartType.area,
      ),
      _buildSfChart(
        title: 'Rendimiento vs Error2 por Piscina',
        yKey: 'Rendimiento',
        secondYKey: 'Error2',
        chartType: _ChartType.stackedBar,
      ),
      _buildSfChart(
        title: 'Peso vs LibrasXHA por Piscina',
        yKey: 'Peso',
        secondYKey: 'LibrasXHA',
        chartType: _ChartType.groupedBar,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: _result.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    _buildAllMetricsChart(),
                    const SizedBox(height: 20),
                    GridView.builder(
                      itemCount: chartCards.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemBuilder: (context, index) => chartCards[index],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildSfChart({
    required String title,
    required String yKey,
    String? secondYKey,
    required _ChartType chartType,
  }) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getGradientColors(_selectedFinca),
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
        boxShadow: const [
          BoxShadow(
            offset: Offset(10, 10),
            color: Color.fromARGB(80, 0, 0, 0),
            blurRadius: 10,
          ),
          BoxShadow(
            offset: Offset(-10, -10),
            color: Color.fromARGB(147, 202, 202, 202),
            blurRadius: 10,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: chartType == _ChartType.doughnut
                    ? SfCircularChart(
                        legend: const Legend(isVisible: true),
                        series: _buildCircularSeries(yKey),
                      )
                    : SfCartesianChart(
                        primaryXAxis: const CategoryAxis(
                          labelRotation: -45,
                          labelIntersectAction:
                              AxisLabelIntersectAction.rotate45,
                        ),
                        legend:
                            Legend(isVisible: chartType != _ChartType.column),
                        series:
                            _buildCartesianSeries(chartType, yKey, secondYKey),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<CartesianSeries<Map<String, dynamic>, String>> _buildCartesianSeries(
    _ChartType type,
    String yKey,
    String? secondYKey,
  ) {
    switch (type) {
      case _ChartType.column:
        return [
          ColumnSeries<Map<String, dynamic>, String>(
              dataSource: _result,
              xValueMapper: (data, _) => data['Piscina'],
              yValueMapper: (data, _) => data[yKey],
              name: yKey),
        ];
      case _ChartType.area:
        return [
          AreaSeries<Map<String, dynamic>, String>(
            dataSource: _result,
            xValueMapper: (data, _) =>
                data['FechaHora']?.toString().split(' ').first ?? '',
            yValueMapper: (data, _) => data[yKey],
            name: yKey,
          ),
          if (secondYKey != null)
            AreaSeries<Map<String, dynamic>, String>(
              dataSource: _result,
              xValueMapper: (data, _) =>
                  data['FechaHora']?.toString().split(' ').first ?? '',
              yValueMapper: (data, _) => data[secondYKey],
              name: secondYKey,
            ),
        ];
      case _ChartType.stackedBar:
        return [
          StackedColumnSeries<Map<String, dynamic>, String>(
            dataSource: _result,
            xValueMapper: (data, _) => data['Piscina'],
            yValueMapper: (data, _) => data[yKey],
            name: yKey,
          ),
          if (secondYKey != null)
            StackedColumnSeries<Map<String, dynamic>, String>(
              dataSource: _result,
              xValueMapper: (data, _) => data['Piscina'],
              yValueMapper: (data, _) => data[secondYKey],
              name: secondYKey,
            ),
        ];
      case _ChartType.groupedBar:
        return [
          ColumnSeries<Map<String, dynamic>, String>(
            dataSource: _result,
            xValueMapper: (data, _) => data['Piscina'],
            yValueMapper: (data, _) => data[yKey],
            name: yKey,
          ),
          if (secondYKey != null)
            ColumnSeries<Map<String, dynamic>, String>(
              dataSource: _result,
              xValueMapper: (data, _) => data['Piscina'],
              yValueMapper: (data, _) => secondYKey == 'LibrasXHA'
                  ? (data['LibrasTotal'] / 11.19)
                  : data[secondYKey],
              name: secondYKey,
            ),
        ];
      default:
        return const [];
    }
  }

  List<CircularSeries<Map<String, dynamic>, String>> _buildCircularSeries(
      String yKey) {
    return [
      DoughnutSeries<Map<String, dynamic>, String>(
        dataSource: _result,
        xValueMapper: (data, _) => data['Piscina'],
        yValueMapper: (data, _) => data[yKey],
        dataLabelSettings: const DataLabelSettings(isVisible: true),
      ),
    ];
  }
}

enum _ChartType { column, doughnut, area, stackedBar, groupedBar }
