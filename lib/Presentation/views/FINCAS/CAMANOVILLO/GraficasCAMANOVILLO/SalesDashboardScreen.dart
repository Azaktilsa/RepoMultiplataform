// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SalesDashboardScreen extends StatefulWidget {
  const SalesDashboardScreen({Key? key}) : super(key: key);

  @override
  _SalesDashboardScreenState createState() => _SalesDashboardScreenState();
}

class _SalesDashboardScreenState extends State<SalesDashboardScreen> {
  // Datos de ventas por ubicación
  final List<Map<String, dynamic>> _locationSales = [
    {'location': 'Austin', 'sales': 280000},
    {'location': 'Berlin', 'sales': 320000},
    {'location': 'London', 'sales': 410000},
    {'location': 'New York', 'sales': 550000},
    {'location': 'Paris', 'sales': 380000},
    {'location': 'San Diego', 'sales': 290000},
  ];

  // Datos de ingresos mensuales por producto
  final List<Map<String, dynamic>> _productRevenue = [
    {'product': 'Fred', 'revenue': 450000},
    {'product': 'Electronics', 'revenue': 580000},
    {'product': 'Golting', 'revenue': 320000},
    {'product': 'Show', 'revenue': 210000},
    {'product': 'Cosmetics', 'revenue': 180000},
  ];

  // Datos de distribución de edad de clientes
  final List<Map<String, dynamic>> _customerAge = [
    {'age': '18-25', 'count': 120000},
    {'age': '26-35', 'count': 350000},
    {'age': '36-45', 'count': 420000},
    {'age': '46-55', 'count': 280000},
    {'age': '56+', 'count': 150000},
  ];

  // Datos de satisfacción por método de compra
  final List<Map<String, dynamic>> _satisfactionData = [
    {
      'method': 'Store',
      'very_dissatisfied': 15,
      'dissatisfied': 20,
      'neutral': 30,
      'satisfied': 25,
      'very_satisfied': 10,
    },
    {
      'method': 'Website',
      'very_dissatisfied': 5,
      'dissatisfied': 10,
      'neutral': 20,
      'satisfied': 40,
      'very_satisfied': 25,
    },
    {
      'method': 'Mobile App',
      'very_dissatisfied': 3,
      'dissatisfied': 7,
      'neutral': 15,
      'satisfied': 45,
      'very_satisfied': 30,
    },
  ];

  // Productos más vendidos por ubicación
  final List<Map<String, dynamic>> _popularItems = [
    {'location': 'Austin', 'product': 'Gloining', 'sales': 45},
    {'location': 'Berlin', 'product': 'Electronics', 'sales': 60},
    {'location': 'London', 'product': 'Feed', 'sales': 55},
    {'location': 'New York', 'product': 'Electronics', 'sales': 70},
    {'location': 'Paris', 'product': 'Books', 'sales': 40},
    {'location': 'San Diego', 'product': 'Gloining', 'sales': 50},
  ];

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    // Determinar número de columnas según el ancho de pantalla
    final int crossAxisCount = screenWidth >= 1200
        ? 3
        : screenWidth >= 800
            ? 2
            : 1;

    final List<Widget> chartCards = [
      _buildTotalSalesChart(),
      _buildMonthlyRevenueChart(),
      _buildCustomerAgeChart(),
      _buildSatisfactionChart(),
      _buildPopularItemsChart(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
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
        ),
      ),
    );
  }

  Widget _buildTotalSalesChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Total Sales in USD by Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            AspectRatio(
              aspectRatio: 1.6,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 600000,
                  barGroups: [
                    for (int i = 0; i < _locationSales.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: _locationSales[i]['sales'].toDouble(),
                            color: _getLocationColor(i),
                            width: 24,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                  ],
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 42,
                        getTitlesWidget: (value, meta) {
                          if (value.toInt() < _locationSales.length) {
                            return Text(
                                _locationSales[value.toInt()]['location']);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          return Text('${(value / 1000).toInt()}K');
                        },
                      ),
                    ),
                  ),
                  gridData: const FlGridData(show: false),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthlyRevenueChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Monthly revenue by product',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(
                  labelFormat: '{value}K',
                  numberFormat: NumberFormat.compact(),
                ),
                series: <CartesianSeries>[
                  ColumnSeries<Map<String, dynamic>, String>(
                    dataSource: _productRevenue,
                    xValueMapper: (data, _) => data['product'],
                    yValueMapper: (data, _) => data['revenue'],
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    color: const Color(0xff4b86b4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomerAgeChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Distribution of Customers Age',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: SfCircularChart(
                legend: Legend(isVisible: true),
                series: <CircularSeries>[
                  PieSeries<Map<String, dynamic>, String>(
                    dataSource: _customerAge,
                    xValueMapper: (data, _) => data['age'],
                    yValueMapper: (data, _) => data['count'],
                    dataLabelSettings: const DataLabelSettings(isVisible: true),
                    explode: true,
                    explodeIndex: 2,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSatisfactionChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Sales Satisfaction Ratings by Purchase Method',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                series: <CartesianSeries>[
                  StackedColumnSeries<Map<String, dynamic>, String>(
                    dataSource: _satisfactionData,
                    xValueMapper: (data, _) => data['method'],
                    yValueMapper: (data, _) => data['very_dissatisfied'],
                    name: 'Very Dissatisfied',
                    color: const Color(0xffd32f2f),
                  ),
                  StackedColumnSeries<Map<String, dynamic>, String>(
                    dataSource: _satisfactionData,
                    xValueMapper: (data, _) => data['method'],
                    yValueMapper: (data, _) => data['dissatisfied'],
                    name: 'Dissatisfied',
                    color: const Color(0xffff7043),
                  ),
                  StackedColumnSeries<Map<String, dynamic>, String>(
                    dataSource: _satisfactionData,
                    xValueMapper: (data, _) => data['method'],
                    yValueMapper: (data, _) => data['neutral'],
                    name: 'Neutral',
                    color: const Color(0xffffeb3b),
                  ),
                  StackedColumnSeries<Map<String, dynamic>, String>(
                    dataSource: _satisfactionData,
                    xValueMapper: (data, _) => data['method'],
                    yValueMapper: (data, _) =>
                        data['satisfied'] ?? data['satisfied'],
                    name: 'Satisfied',
                    color: const Color(0xff4caf50),
                  ),
                  StackedColumnSeries<Map<String, dynamic>, String>(
                    dataSource: _satisfactionData,
                    xValueMapper: (data, _) => data['method'],
                    yValueMapper: (data, _) =>
                        data['very_satisfied'] ?? data['very_satisfied'],
                    name: 'Very Satisfied',
                    color: const Color(0xff2e7d32),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItemsChart() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text(
              'Most common items sold by Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 280,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(),
                primaryYAxis: NumericAxis(),
                series: <CartesianSeries>[
                  ColumnSeries<Map<String, dynamic>, String>(
                    dataSource: _popularItems
                        .where((e) => e['product'] == 'Gloining')
                        .toList(),
                    xValueMapper: (data, _) => data['location'],
                    yValueMapper: (data, _) => data['sales'],
                    name: 'Gloining',
                    color: const Color(0xff4b86b4),
                  ),
                  ColumnSeries<Map<String, dynamic>, String>(
                    dataSource: _popularItems
                        .where((e) => e['product'] == 'Electronics')
                        .toList(),
                    xValueMapper: (data, _) => data['location'],
                    yValueMapper: (data, _) => data['sales'],
                    name: 'Electronics',
                    color: const Color(0xff4b6cb7),
                  ),
                  ColumnSeries<Map<String, dynamic>, String>(
                    dataSource: _popularItems
                        .where((e) => e['product'] == 'Feed')
                        .toList(),
                    xValueMapper: (data, _) => data['location'],
                    yValueMapper: (data, _) => data['sales'],
                    name: 'Feed',
                    color: const Color(0xff6190e8),
                  ),
                  ColumnSeries<Map<String, dynamic>, String>(
                    dataSource: _popularItems
                        .where((e) => e['product'] == 'Books')
                        .toList(),
                    xValueMapper: (data, _) => data['location'],
                    yValueMapper: (data, _) => data['sales'],
                    name: 'Books',
                    color: const Color(0xffa7bfe8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getLocationColor(int index) {
    final colors = [
      const Color(0xff4b86b4),
      const Color(0xff4b6cb7),
      const Color(0xff6190e8),
      const Color(0xffa7bfe8),
      const Color(0xff8a9df2),
      const Color(0xff6a8dd8),
    ];
    return colors[index % colors.length];
  }
}
