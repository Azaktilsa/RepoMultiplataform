// ignore_for_file: unnecessary_null_comparison, unused_local_variable, use_build_context_synchronously, library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:azaktilza/Presentation/views/FINCAS/Controller/Dato_Logic.dart';
import 'package:azaktilza/Presentation/views/FINCAS/Controller/TutorialHelper.dart';
import 'package:azaktilza/Presentation/views/FINCAS/Widgets/calculate_button.dart';
import 'package:azaktilza/Presentation/views/FINCAS/Widgets/hect_select.dart';
import 'package:azaktilza/Presentation/views/FINCAS/Widgets/input_card.dart';
import 'package:azaktilza/Presentation/views/FINCAS/Widgets/result_card.dart';
import 'package:azaktilza/Presentation/views/FINCAS/Widgets/tutorial_targets.dart';
import 'package:azaktilza/env_loader.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class DatoGROVITAL_Screen extends StatefulWidget {
  const DatoGROVITAL_Screen({Key? key}) : super(key: key);

  @override
  _DatoGROVITAL_ScreenState createState() => _DatoGROVITAL_ScreenState();
}

class _DatoGROVITAL_ScreenState extends State<DatoGROVITAL_Screen> {
  String? selectedHectareas;
  String? selectedPiscinas;
  String? selectedGramos;

  List<Map<String, dynamic>> GROVITALData = [];
  List<Map<String, dynamic>> rendimientoData = [];

  List<String> piscinasOptions_GROVITAL = [];
  Map<String, dynamic>? selectedTerreno;

  late final DatabaseReference _GROVITALRef;
  late final DatabaseReference _rendimientoRef;

  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _consumoController = TextEditingController();
  final TextEditingController _piscinasController = TextEditingController();
  final TextEditingController _gramosController = TextEditingController();
  final TextEditingController _HectareasController = TextEditingController();
  // Define un TextEditingController en tu clase de estado
  final TextEditingController _kgXHaController = TextEditingController();
  final TextEditingController _RendimientoController = TextEditingController();
  final TextEditingController _LibrasXHaController = TextEditingController();
  final TextEditingController _LibrasTotalController = TextEditingController();
  final TextEditingController _calculateAnimalesMController =
      TextEditingController();
  final TextEditingController _calculateError2Controller =
      TextEditingController();
  List<String> _hectareasPiscinas = [];
  final String _selectedFinca = 'GROVITAL';
  bool _showResults = false;
  final ScrollController _scrollController_ = ScrollController();
  int _currentPage = 0;
  final int _itemsPerPage = 6;

  // 🔸 Keys para tutorial
  final GlobalKey _SelectPiscDATO = GlobalKey();
  final GlobalKey _BeforeDATO = GlobalKey();
  final GlobalKey _AfterDATO = GlobalKey();
  final GlobalKey _ConsumoDATO = GlobalKey();
  final GlobalKey _PesoAdmin = GlobalKey();
  final GlobalKey _calcularbuttonDATO = GlobalKey();
  final GlobalKey _resetTutorialDATO = GlobalKey();
  final List<TargetFocus> _initTargetsDATO = [];

  void _addListeners() {
    _HectareasController.addListener(_updateCalculations);
    _piscinasController.addListener(_updateCalculations);
    _gramosController.addListener(_updateCalculations);
    _consumoController.addListener(_updateCalculations);
    _pesoController.addListener(_updateCalculations);
  }

  void _updateCalculations() {}

  void _fetchData() async {
    try {
      final GROVITALSnapshot = await _GROVITALRef.get();
      final rendimientoSnapshot = await _rendimientoRef.get();

      if (GROVITALSnapshot.exists) {
        setState(() {
          if (GROVITALSnapshot.value is List) {
            GROVITALData = (GROVITALSnapshot.value as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();
          } else if (GROVITALSnapshot.value is Map) {
            GROVITALData = (GROVITALSnapshot.value as Map)
                .values
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();
          }

          // Rellena las listas de opciones para el Dropdown de Piscinas
          piscinasOptions_GROVITAL =
              GROVITALData.map((e) => e['Piscinas'].toString()).toList();
          if (piscinasOptions_GROVITAL.isNotEmpty) {
            selectedPiscinas = piscinasOptions_GROVITAL.first;
            _updateHectareasForPiscina(selectedPiscinas!);
          }
        });
      }

      if (rendimientoSnapshot.exists) {
        setState(() {
          if (rendimientoSnapshot.value is List) {
            rendimientoData = (rendimientoSnapshot.value as List)
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();
          } else if (rendimientoSnapshot.value is Map) {
            rendimientoData = (rendimientoSnapshot.value as Map)
                .values
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();
          }
        });
      }
    } catch (e) {
      print('Error al cargar datos: $e');
    }
  }

  void _updateHectareasForPiscina(String piscina) {
    final matchingPiscina = GROVITALData.firstWhere(
      (element) => element['Piscinas'].toString() == piscina,
      orElse: () => <String, dynamic>{},
    );

    if (matchingPiscina.isNotEmpty) {
      selectedHectareas = matchingPiscina['Hectareas'].toString();
      _HectareasController.text = selectedHectareas!;
    } else {
      selectedHectareas = null;
      _HectareasController.clear();
    }
    // Aquí llama a las funciones de cálculo
  }

  void _calculateFunction() {
    Dato_Logic.calculateKgXHa(
      consumoController: _consumoController,
      hectareasController: _HectareasController,
      kgXHaController: _kgXHaController,
    );
    Dato_Logic.calculateLibrasXHa(
      rendimientoController: _RendimientoController,
      kgXHaController: _kgXHaController,
      librasXHaController: _LibrasXHaController,
    );
    Dato_Logic.calculateLibrasTotal(
      hectareasController: _HectareasController,
      librasXHaController: _LibrasXHaController,
      librasTotalController: _LibrasTotalController,
    );
    Dato_Logic.calculateError2(
      librasTotalController: _LibrasTotalController,
      error2Controller: _calculateError2Controller,
    );
    Dato_Logic.calculateAnimalesM(
      librasXHaController: _LibrasXHaController,
      pesoController: _pesoController,
      animalesMController: _calculateAnimalesMController,
    );
  }

  void _loadPiscinas() async {
    final data = await Dato_Logic.fetchDataFromRef(_GROVITALRef);
    setState(() {
      _hectareasPiscinas = data.map((row) {
        String hect = row['Hectareas'].toString();
        String pisc =
            row['Piscinas'].toString().replaceAll(RegExp(r'[^\d.]'), '');
        return 'Hect: $hect - Pisc: $pisc';
      }).toList();
    });
  }

  void _onCalculate() {
    // Validar selección de terreno
    if (selectedTerreno == null) {
      _showSnackBar('Por favor, seleccione la Hectárea y Piscina.');
      return;
    }

    // Validar campo de peso
    if (_pesoController.text.isEmpty) {
      _showSnackBar('Por favor, complete el campo Peso.');
      return;
    }

    // Validar campo de consumo
    if (_consumoController.text.isEmpty) {
      _showSnackBar('Por favor, complete el campo Consumo.');
      return;
    }

    // Reemplazar comas por puntos y validar los datos
    final pesoString = _pesoController.text.replaceAll(',', '.');
    final consumoString = _consumoController.text.replaceAll(',', '.');

    final peso = double.tryParse(pesoString);
    final consumo = double.tryParse(consumoString);

    if (peso == null || consumo == null) {
      _showSnackBar('Peso y Consumo deben ser valores numéricos válidos.');
      return;
    }

    final newData = {
      'Peso': peso,
      'Consumo': consumo,
      'Entero': peso.toInt(),
    };
    GROVITALData.add(newData);
    _calculateAndUpload(peso, consumo);
    _calculateFunction();
    setState(() {
      _showResults = !_showResults;
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      if (_showResults) {
        _scrollController_.animateTo(
          _scrollController_.position.maxScrollExtent,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

// Función para mostrar mensajes con SnackBar
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Color.fromARGB(255, 255, 43, 43),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _calculateAndUpload(double peso, double consumo) {
    // Calcula el peso y consumo totales
    double totalPeso = peso;
    double totalConsumo = consumo;

    // Convierte totalPeso a entero sin decimales para la comparación
    final entero = totalPeso.toInt();

    // Obtiene el rendimiento basado en el peso total
    final rendimiento = Dato_Logic.getRendimiento(
      entero: entero,
      rendimientoData: rendimientoData,
      rendimientoController: _RendimientoController,
    );

    // Calcula kgXHa, librasXHa, librasTotal, error2, y animalesM
    final kgXHa =
        (totalConsumo) / (double.tryParse(selectedHectareas ?? '1') ?? 1);
    final librasXHa = kgXHa * (rendimiento / 100) * 100;
    final librasTotal =
        (double.tryParse(selectedHectareas ?? '1') ?? 1) * librasXHa;
    final error2 = librasTotal * 0.98;
    final animalesM = ((librasXHa * 454) / totalPeso) / 10000;

    // Obtén la fecha y hora actual formateada como yyyy-MM-dd HH
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd HH').format(now);

    // Crea un mapa con los datos calculados para subir a Firebase
    final newData = {
      'Piscinas': selectedPiscinas,
      'Hectareas': selectedHectareas,
      'FechaHora': formattedDate,
      'Peso': totalPeso,
      'Consumo': totalConsumo,
      'Gramos': totalPeso,
      'KGXHA': kgXHa,
      'Rendimiento': rendimiento,
      'LibrasTotal': librasTotal,
      'Error2': error2,
      'LibrasXHA': librasXHa,
      'AnimalesM': animalesM,
      'Finca': _selectedFinca,
    };

    late final DatabaseReference resultRef;
    if (kIsWeb) {
      // Sube los datos calculados a la base de datos de Firebase
      resultRef = FirebaseDatabase.instance
          .ref('${EnvLoader.get('RESULT_DATO_BASE')}/$_selectedFinca');
    } else {
      // Sube los datos calculados a la base de datos de Firebase
      resultRef = FirebaseDatabase.instance
          .ref('${dotenv.env['RESULT_DATO_BASE']}/$_selectedFinca');
    }

    resultRef.push().set(newData);

    // Actualiza el estado con los resultados
    setState(() {
      // Aquí actualiza cualquier otra cosa que necesites
    });
  }

  void _loadHectareasPiscinas(String finca) async {
    final snapshot = await _GROVITALRef.get();
    if (snapshot.exists) {
      List<dynamic> rows = List<dynamic>.from(snapshot.value as List);

      setState(() {
        _hectareasPiscinas = rows.map((row) {
          String hectareas = row["Hectareas"].toString().trim();
          String piscinas = row["Piscinas"].toString().trim();
          String piscinasNumero = piscinas.replaceAll(
              RegExp(r'[^0-9.]'), ''); // Extrae solo números y puntos
          return "Hect: $hectareas - Pisc: $piscinasNumero"; // Mostrar sin texto extra
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _GROVITALRef =
          FirebaseDatabase.instance.ref(EnvLoader.get('GROVITAL_ROWS')!);
      _rendimientoRef =
          FirebaseDatabase.instance.ref(EnvLoader.get('RENDIMIENTO_ROWS')!);
    } else {
      _GROVITALRef =
          FirebaseDatabase.instance.ref(dotenv.env['GROVITAL_ROWS']!);
      _rendimientoRef =
          FirebaseDatabase.instance.ref(dotenv.env['RENDIMIENTO_ROWS']!);
    }

    _initTargetsDATO.addAll(buildTutorialTargetsDATO(
      selectPiscinaKey: _SelectPiscDATO,
      beforeKey: _BeforeDATO,
      afterKey: _AfterDATO,
      pesoKey: _PesoAdmin,
      consumoKey: _ConsumoDATO,
      calcularKey: _calcularbuttonDATO,
      resetTutorialKey: _resetTutorialDATO,
    ));

    WidgetsBinding.instance.addPostFrameCallback((_) {
      TutorialHelper.showTutorialIfNeeded(
        context: context,
        targets: _initTargetsDATO,
        tutorialKeyFinca: _selectedFinca,
      );
    });
    _fetchData();
    _loadPiscinas();
    _loadHectareasPiscinas(_selectedFinca);
    _addListeners();
    // Establecer un valor por defecto para `selectedHectareas` si lo deseas
    if (GROVITALData.isNotEmpty) {
      final defaultHectareas =
          '${GROVITALData[0]['Hectareas']}_${GROVITALData[0]['Piscinas']}';
      selectedHectareas = defaultHectareas; // Establecer el valor por defecto
    }
    _HectareasController.addListener(() {
      setState(() {
        selectedHectareas = _HectareasController.text;
      });
    });

    _RendimientoController.addListener(() {
      setState(() {
        _calculateFunction();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final entero = double.tryParse(_pesoController.text)?.toInt() ?? 0;
    _gramosController.text = entero != null ? entero.toString() : 'N/A';

    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: Center(
        child: SingleChildScrollView(
          controller: _scrollController_,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                HectSelectWidget(
                  items: _hectareasPiscinas,
                  currentPage: _currentPage,
                  itemsPerPage: _itemsPerPage,
                  title: 'Seleccione Hectáreas y Piscinas',
                  selectedHectarea: _HectareasController.text,
                  selectedPiscina: _piscinasController.text,
                  onNextPage: _nextPage,
                  onPreviousPage: _previousPage,
                  beforeKey: _BeforeDATO,
                  afterKey: _AfterDATO,
                  labelKey: _SelectPiscDATO,
                  typeBackground: _selectedFinca,
                  onSelect: (tipo, item, isSelected) {
                    final hect =
                        item.split(" - ")[0].replaceAll("Hect: ", "").trim();
                    final pisc =
                        item.split(" - ")[1].replaceAll("Pisc: ", "").trim();

                    _onSelect(pisc, hect);

                    // 👇 Aquí actualizamos selectedTerreno con los datos del terreno correspondiente
                    final terreno = GROVITALData.firstWhere(
                      (element) =>
                          element['Piscinas'].toString().contains(pisc) &&
                          element['Hectareas'].toString().contains(hect),
                      orElse: () => {},
                    );

                    setState(() {
                      selectedTerreno = terreno.isNotEmpty ? terreno : null;
                    });
                  },
                ),
                const SizedBox(height: 10),
                InputCard(
                  pesoController: _pesoController,
                  consumoController: _consumoController,
                  pesoKey: _PesoAdmin,
                  consumoKey: _ConsumoDATO,
                  typeFinca: _selectedFinca,
                ),
                const SizedBox(height: 20),
                CalculateButton(
                  onPressed: _onCalculate,
                  buttonKey: _calcularbuttonDATO,
                ),
                const SizedBox(height: 20),
                if (_showResults)
                  ResultCard(
                    hectareasController: _HectareasController,
                    piscinasController: _piscinasController,
                    gramosController: _gramosController,
                    rendimientoController: _RendimientoController,
                    kgXHaController: _kgXHaController,
                    librasTotalController: _LibrasTotalController,
                    error2Controller: _calculateError2Controller,
                    librasXHaController: _LibrasXHaController,
                    animalesMController: _calculateAnimalesMController,
                    showResults: _showResults,
                    typeFinca: _selectedFinca,
                  ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Tooltip(
        key: _resetTutorialDATO,
        message: "Reactivar tutorial",
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
          onPressed: () async {
            await TutorialHelper.resetTutorial(
              _selectedFinca,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Tutorial restablecido. Para verlo,"
                    " solo tienes que ir a otra interfaz y luego volver aquí."),
                duration: Duration(seconds: 2),
              ),
            );
          },
          backgroundColor:
              const Color.fromARGB(255, 126, 53, 0), // Color del botón
          child: const Icon(
            Icons.refresh,
            color: Color(0xfff3ece7),
          ), // Ícono de reinicio
        ),
      ),
    );
  }

  void _nextPage() {
    setState(() {
      if ((_currentPage + 1) * _itemsPerPage < _hectareasPiscinas.length) {
        _currentPage++;
      }
    });
  }

  void _previousPage() {
    setState(() {
      if (_currentPage > 0) {
        _currentPage--;
      }
    });
  }

  void _onSelect(String piscina, String hectarea) {
    setState(() {
      selectedPiscinas = piscina;
      selectedHectareas = hectarea;
      _piscinasController.text = piscina;
      _HectareasController.text = hectarea;
      selectedTerreno = {
        'Piscinas': piscina,
        'Hectareas': hectarea,
      };
    });
  }
}
