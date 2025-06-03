// ignore_for_file: unused_local_variable

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/EXCANCRIGRU/EXCANCRIGRU_Calculate_Screen.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/EXCANCRIGRU/Edit_Calculate_EXCANCRIGRU.dart';
import 'package:azaktilza/env_loader.dart';

class Resumen_Calculate_EXCANCRIGRU extends StatefulWidget {
  const Resumen_Calculate_EXCANCRIGRU({Key? key}) : super(key: key);

  @override
  _Resumen_Calculate_EXCANCRIGRU_State createState() =>
      _Resumen_Calculate_EXCANCRIGRU_State();
}

class _Resumen_Calculate_EXCANCRIGRU_State
    extends State<Resumen_Calculate_EXCANCRIGRU> {
  static final NumberFormat numberFormatter = NumberFormat("#,##0.##", "en_US");

  final String _selectedFinca = 'EXCANCRIGRU';
  late final basePath;

  DateTime _selectedDate = DateTime.now();
  Map<dynamic, dynamic>? _fetchedData;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      basePath = EnvLoader.get('RESULT_ALIMENTATION')!;
    } else {
      basePath = dotenv.env['RESULT_ALIMENTATION']!;
    }
    _fetchDataForDate(_selectedDate);

    final DatabaseReference dbRef =
        FirebaseDatabase.instance.ref('$basePath/$_selectedFinca');
    dbRef.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists) {
        _fetchDataForDate(_selectedDate);
      } else {
        setState(() {
          print('No hay datos para esta fecha, $_fetchedData');
          _fetchedData = null;
        });
      }
    });
    _dateController = TextEditingController(
      text: DateFormat('dd/MM/yyyy').format(_selectedDate),
    );
  }

  Future<void> _fetchDataForDate(DateTime date) async {
    try {
      String formattedDate = DateFormat('dd/MM/yyyy').format(date);

      final DatabaseReference dbRef =
          FirebaseDatabase.instance.ref('$basePath/$_selectedFinca');

      final snapshot = await dbRef
          .orderByChild('Fechadesiembra')
          .equalTo(formattedDate)
          .get();

      if (snapshot.exists && snapshot.value is Map) {
        setState(() {
          _fetchedData = snapshot.value as Map<dynamic, dynamic>;
        });
      } else {
        setState(() {
          print('No hay datos para esta fecha, $_fetchedData');
          _fetchedData = null;
        });
      }
    } catch (e) {
      debugPrint('Error al obtener datos: $e');
      setState(() {
        _fetchedData = null;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2023),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
      _fetchDataForDate(picked);
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Fecha de Siembra (dd/mm/yyyy)',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _dateController,
                        keyboardType: TextInputType.datetime,
                        decoration: InputDecoration(
                          hintText: 'Selecciona o escribe una fecha',
                          prefixIcon: IconButton(
                            icon: const Icon(
                              Icons.calendar_today,
                              color: Color(0xFF7E3500),
                            ),
                            onPressed: () => _selectDate(context),
                          ),
                          filled: true,
                          fillColor: const Color(0xFFF3ECE7),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 12,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF7E3500),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Color(0xFF7E3500),
                              width: 2,
                            ),
                          ),
                        ),
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.search, color: Color(0xFF7E3500)),
                      onPressed: () {
                        try {
                          final inputDate = DateFormat('dd/MM/yyyy')
                              .parse(_dateController.text);
                          setState(() {
                            _selectedDate = inputDate;
                          });
                          _fetchDataForDate(inputDate);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Formato de fecha inválido. Usa dd/MM/yyyy.')),
                          );
                        }
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
          Expanded(
            child: _fetchedData == null
                ? const Center(
                    child: Column(
                      children: [
                        SizedBox(height: 100),
                        CircleAvatar(
                          backgroundColor: Color(0xfff3ece7),
                          radius: 80,
                          backgroundImage:
                              AssetImage('assets/images/logoOscuro3.jpeg')
                                  as ImageProvider,
                        ),
                        SizedBox(height: 20),
                        Text(
                          'No hay datos para esta fecha',
                          style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 126, 53, 0),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(12.0),
                    children: _fetchedData!.entries.map((entry) {
                      final id = entry.key;
                      final data = entry.value;

                      if (data is! Map) return const SizedBox();

                      return GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  Edit_Calculate_EXCANCRIGRU(id: id),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 241, 238, 235),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromARGB(80, 0, 0, 0),
                                  offset: Offset(-10, 10),
                                  blurRadius: 10,
                                ),
                                BoxShadow(
                                  color: Color.fromARGB(147, 202, 202, 202),
                                  offset: Offset(10, -10),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Información del Cultivo',
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey[900],
                                        ),
                                      ),
                                      Flexible(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              data['bloqueado'] == true
                                                  ? Icons.lock
                                                  : Icons.edit,
                                              color: data['bloqueado'] == true
                                                  ? const Color.fromARGB(
                                                      255, 126, 53, 0)
                                                  : Colors.green,
                                              size: 20,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              data['bloqueado'] == true
                                                  ? 'Bloqueado'
                                                  : 'Editable',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: data['bloqueado'] == true
                                                    ? const Color.fromARGB(
                                                        255, 126, 53, 0)
                                                    : Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Desde ${data['Fechadesiembra'] ?? '-'} hasta ${data['Fechademuestreo'] ?? '-'}',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  const Divider(height: 24, thickness: 1.2),
                                  _infoRow('Hectáreas', data['Hectareas']),
                                  _infoRow('Piscinas', data['Piscinas']),
                                  _infoRow('Edad del cultivo',
                                      data['Edaddelcultivo']),
                                  _infoRow('Crecimiento actual g/día',
                                      data['Crecimientoactualgdia']),
                                  _infoRow(
                                      'Peso anterior', data['Pesoanterior']),
                                  _infoRow('Alimento actual (kg)',
                                      data['Alimentoactualkg']),
                                  _infoRow('Densidad consumo (ind/m²)',
                                      data['Densidadconsumoim2']),
                                  _infoRow('Densidad biólogo (ind/m²)',
                                      data['Densidadbiologoindm2']),
                                  _infoRow('Densidad por Atarraya',
                                      data['DensidadporAtarraya']),
                                  _infoRow('Recomendación semana',
                                      data['Recomendationsemana']),
                                  _infoRow('Número AA', data['numeroAA']),
                                  _infoRow('LBS tolva actual campo',
                                      data['LBStolvaactualcampo']),
                                  _infoRow('Aireadores', data['Aireadores']),
                                  _infoRow('Libras por aireador',
                                      data['LibrastotalesporAireador']),
                                  _infoRow('Libras totales campo',
                                      data['Librastotalescampo']),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
      floatingActionButton: Tooltip(
        message: "Agregar nueva alimentación",
        height: 50,
        padding: const EdgeInsets.all(8.0),
        preferBelow: true,
        textStyle: const TextStyle(fontSize: 20),
        showDuration: const Duration(seconds: 2),
        waitDuration: const Duration(seconds: 1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: const LinearGradient(colors: <Color>[
            Color.fromARGB(255, 241, 238, 235),
            Color.fromARGB(255, 241, 238, 235),
          ]),
          boxShadow: const [
            BoxShadow(
              offset: Offset(-10, 10),
              color: Color.fromARGB(80, 0, 0, 0),
              blurRadius: 10,
            ),
            BoxShadow(
                offset: Offset(10, -10),
                color: Color.fromARGB(147, 202, 202, 202),
                blurRadius: 10),
          ],
        ),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Calculate_EXCANCRIGRU_Screen(),
              ),
            );
          },
          backgroundColor: const Color.fromARGB(255, 126, 53, 0),
          child: const Icon(
            Icons.add,
            color: Color(0xfff3ece7),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, dynamic value) {
    String displayValue;

    if (value == null) {
      displayValue = '-';
    } else if (value is num) {
      displayValue = numberFormatter.format(value);
    } else {
      // Intenta convertir si es un número en String
      final parsed = num.tryParse(value.toString().replaceAll(',', ''));
      if (parsed != null) {
        displayValue = numberFormatter.format(parsed);
      } else {
        displayValue = value.toString();
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          Text(
            displayValue,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
