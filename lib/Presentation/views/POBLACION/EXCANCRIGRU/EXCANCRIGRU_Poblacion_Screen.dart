// ignore_for_file: non_constant_identifier_names, unused_local_variable

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:azaktilza/Presentation/Utils/getBackgroundColor.dart';
import 'package:azaktilza/Presentation/Utils/gradient_colors.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Functions/exportarAExcel.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Functions/exportarAPDF.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Functions/share_exported_file.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Widgets/resultado_data.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Widgets/resultado_data_source.dart';
import 'package:azaktilza/Presentation/views/POBLACION/Widgets/tabla_dinamica_resultado.dart';
import 'package:azaktilza/env_loader.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Poblacion_EXCANCRIGRU_Screen extends StatefulWidget {
  const Poblacion_EXCANCRIGRU_Screen({Key? key}) : super(key: key);

  @override
  _Poblacion_EXCANCRIGRU_Screen_State createState() =>
      _Poblacion_EXCANCRIGRU_Screen_State();
}

class _Poblacion_EXCANCRIGRU_Screen_State
    extends State<Poblacion_EXCANCRIGRU_Screen> {
  late final DatabaseReference _EXCANCRIGRURef;

  late final DatabaseReference _EXCANCRIGRUBaseRef;

  List<Map<String, dynamic>> terrenos = [];
  Map<String, dynamic>? selectedTerreno;
  TextEditingController hectareasController = TextEditingController();
  TextEditingController piscinasController = TextEditingController();
  TextEditingController cantidadSiembraController = TextEditingController();
  TextEditingController densidadSiembraController = TextEditingController();
  TextEditingController pesoController = TextEditingController();
  TextEditingController fechaPoblacionController = TextEditingController();
  TextEditingController lancesController = TextEditingController();
  TextEditingController ResultController = TextEditingController();
  final TextEditingController resultCamaronesController =
      TextEditingController();
  final TextEditingController resultBactimetriaController =
      TextEditingController();
  List<TextEditingController> camaronesControllers = [];
  List<TextEditingController> bactimetriaControllers = [];

  List<TableRow> tableRows = [];
  List<TableRow> tableRowsResult = [];
  bool isTableVisible = false;
  bool isTableVisibleResult = false;

  // Variables para el DropdownButton
  List<String> _hectareasPiscinas = [];
  String _selectedFinca = 'EXCANCRIGRU';
  int _currentPage = 0;
  final int _itemsPerPage = 6;
  Timer? _timerPOBLACIONEXCANCRIGRU;

  // Define los controladores adicionales en tu clase de widget
  TextEditingController camaronesXLancesController = TextEditingController();
  TextEditingController diametroAtarrayaController = TextEditingController();
  TextEditingController batimentriaController = TextEditingController();
  TextEditingController nCamaronesXMetroSinAguaController =
      TextEditingController();
  TextEditingController nCamaronesXMetroConAguaController =
      TextEditingController();
  TextEditingController camPromediosController = TextEditingController();
  TextEditingController poblacionActualController = TextEditingController();
  TextEditingController sobrevivenciaController = TextEditingController();
  TextEditingController pesoDeCamaronController = TextEditingController();
  TextEditingController librasEstimadasController = TextEditingController();

  late ResultadoDataGridSource _dataSource;
  late List<ResultadoData> _data;

  final NumberFormat numberFormatter = NumberFormat("#,##0.##", "en_US");

  void _formaterPoblation() {
    final parsed =
        double.tryParse(cantidadSiembraController.text.replaceAll(',', ''));
    if (parsed != null) {
      cantidadSiembraController.text = numberFormatter.format(parsed);
    }
  }

  void _fetchTerrenos() async {
    try {
      DatabaseEvent event = await _EXCANCRIGRUBaseRef.once();
      var terrenoData = event.snapshot.value;

      List<Map<String, dynamic>> fetchedTerrenos = [];

      if (terrenoData is Map && terrenoData.containsKey('rows')) {
        var rows = terrenoData['rows'];
        if (rows is List && rows.isNotEmpty) {
          fetchedTerrenos = rows
              .map((row) => {
                    'name':
                        'Hect: ${row['Hectareas']}, Pisc: ${row['Piscinas']}',
                    'Hectareas': row['Hectareas'],
                    'Piscinas': row['Piscinas']
                  })
              .toList();
        } else if (rows is Map && rows.isNotEmpty) {
          rows.forEach((key, value) {
            fetchedTerrenos.add({
              'name': 'Row $key',
              'Hectareas': value['Hectareas'],
              'Piscinas': value['Piscinas'],
            });
          });
        }
      }

      setState(() {
        terrenos = fetchedTerrenos;
      });
    } catch (e) {
      print('Error fetching terrenos data: $e');
    }
  }

  void _updateCalculatedFields() {
    double hectareas =
        double.tryParse(hectareasController.text.replaceAll(',', '')) ?? 0.0;
    double cantidadSiembra =
        double.tryParse(cantidadSiembraController.text.replaceAll(',', '')) ??
            0.0;
    numberFormatter.format(cantidadSiembra);

    double densidadSiembra =
        hectareas != 0.0 ? cantidadSiembra / hectareas : 0.0;
    densidadSiembraController.text = numberFormatter.format(densidadSiembra);
  }

  void _updateTableRows() {
    int numberOfLances = int.tryParse(lancesController.text) ?? 0;
    List<TextEditingController> newCamaronesControllers =
        List.generate(numberOfLances, (index) => TextEditingController());
    List<TextEditingController> newBactimetriaControllers =
        List.generate(numberOfLances, (index) => TextEditingController());

    List<TableRow> rows = [
      const TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Lances',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 14)),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Camarones',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 12)),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('Bactimetria',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                    fontSize: 12)),
          ),
        ],
      )
    ];

    for (int i = 0; i < numberOfLances; i++) {
      rows.add(
        TableRow(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                '${i + 1}',
                style: TextStyle(color: Colors.blueGrey[800]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: newCamaronesControllers[i],
                decoration: const InputDecoration(
                  fillColor: Colors.transparent,
                  labelText: '',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 126, 53, 0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 126, 53, 0),
                    ),
                  ),
                ),
                style: const TextStyle(color: Colors.black87),
                keyboardType: TextInputType.number,
                onChanged: (value) => _updateCamaronesSum(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: newBactimetriaControllers[i],
                decoration: const InputDecoration(
                  labelText: '',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 126, 53, 0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 126, 53, 0),
                    ),
                  ),
                ),
                style: const TextStyle(color: Colors.black87),
                keyboardType: TextInputType.number,
                onChanged: (value) => _updateBactimetriaSum(),
              ),
            ),
          ],
        ),
      );
    }

    setState(() {
      tableRows = rows;
      isTableVisible = numberOfLances > 0;
      camaronesControllers = newCamaronesControllers;
      bactimetriaControllers = newBactimetriaControllers;
    });
  }

  void _updateCamaronesSum() {}

  void _updateBactimetriaSum() {
    // Función auxiliar para limpiar comas y convertir a número
    double getCleanDouble(TextEditingController controller) {
      return double.tryParse(controller.text.replaceAll(',', '')) ?? 0.0;
    }

    int getCleanInt(TextEditingController controller) {
      return int.tryParse(controller.text.replaceAll(',', '')) ?? 0;
    }

    // Promedio Camarones
    int sumCam = camaronesControllers.fold(0, (prev, ctrl) {
      return prev + getCleanInt(ctrl);
    });
    resultCamaronesController.text = numberFormatter.format(sumCam);

    // Camarones X Lance
    int numberOfLancesSumCam = getCleanInt(lancesController);
    double CamaXLances =
        numberOfLancesSumCam > 0 ? sumCam / numberOfLancesSumCam : 0.0;
    camaronesXLancesController.text = numberFormatter.format(CamaXLances);

    // Promedio Bactimetría
    int sumBact = bactimetriaControllers.fold(0, (prev, ctrl) {
      return prev + getCleanInt(ctrl);
    });
    int numberOfLances = getCleanInt(lancesController);
    double result = numberOfLances > 0 ? sumBact / numberOfLances : 0.0;
    resultBactimetriaController.text = numberFormatter.format(result);

    // Diámetro Atarraya
    int DiAtarraya = getCleanInt(diametroAtarrayaController);
    if (DiAtarraya == 0) DiAtarraya = 1;

    // Batimetría
    double batimetriaResul = result / 100;
    batimentriaController.text = numberFormatter.format(batimetriaResul);

    // CAM X METRO SIN AGUA
    double camaronxmetroResult =
        DiAtarraya > 0 ? CamaXLances / DiAtarraya : 0.0;
    nCamaronesXMetroSinAguaController.text =
        numberFormatter.format(camaronxmetroResult);

    // CAM X METRO CON AGUA
    double camaronxConAguaResult = camaronxmetroResult * batimetriaResul;
    nCamaronesXMetroConAguaController.text =
        numberFormatter.format(camaronxConAguaResult);

    // CAM Promedio
    double CAMpromedio = (camaronxmetroResult + camaronxConAguaResult) / 2;
    camPromediosController.text = numberFormatter.format(CAMpromedio);

    // Población Actual
    double hectareas = getCleanDouble(hectareasController);
    double PoblacionActual = hectareas > 0 && CAMpromedio > 0
        ? 10000 * hectareas * CAMpromedio
        : 0.0;
    poblacionActualController.text = numberFormatter.format(PoblacionActual);

    // Sobrevivencia
    double cantidadSiembra = getCleanDouble(cantidadSiembraController);
    double resultSobreVivencia =
        cantidadSiembra > 0 ? PoblacionActual * 100 / cantidadSiembra : 0.0;
    sobrevivenciaController.text = numberFormatter.format(resultSobreVivencia);

    // Peso de Camarón
    double pesoGR = getCleanDouble(pesoController);
    pesoDeCamaronController.text = numberFormatter.format(pesoGR);

    // Libras Estimadas
    double resultLibrasEst = hectareas > 0
        ? hectareas * 10000 * camaronxmetroResult * pesoGR / 454
        : 0.0;
    librasEstimadasController.text = numberFormatter.format(resultLibrasEst);

    // Aplicar formateo final a Cantidad de Siembra
    _formaterPoblation();
  }

  List<ResultadoData> _generarDatos() {
    return [
      ResultadoData("Finca", _selectedFinca),
      ResultadoData("Hectáreas", hectareasController.text),
      ResultadoData("Piscinas", piscinasController.text),
      ResultadoData("Cantidad de Siembra", cantidadSiembraController.text),
      ResultadoData("Densidad de Siembra", densidadSiembraController.text),
      ResultadoData("Peso", pesoController.text),
      ResultadoData("Fecha de Población", fechaPoblacionController.text),
      ResultadoData("Diámetro de Atarraya", diametroAtarrayaController.text),
      ResultadoData("Total Bactimetría", resultBactimetriaController.text),
      ResultadoData("Total camarones", resultCamaronesController.text),
      ResultadoData("Número de Lances", lancesController.text),
      ResultadoData("Camarones x Lances", camaronesXLancesController.text),
      ResultadoData("Batimetría", batimentriaController.text),
      ResultadoData("N Camarones x Metro Sin Agua",
          nCamaronesXMetroSinAguaController.text),
      ResultadoData("N Camarones x Metro Con Agua",
          nCamaronesXMetroConAguaController.text),
      ResultadoData("Cam Promedios", camPromediosController.text),
      ResultadoData("Población Actual", poblacionActualController.text),
      ResultadoData("Sobrevivencia", sobrevivenciaController.text),
      ResultadoData("Peso de Camarón", pesoDeCamaronController.text),
      ResultadoData("Libras Estimadas", librasEstimadasController.text),
    ];
  }

  void _updateTableRowsResult() {
    final DatabaseReference resultRef;

    if (kIsWeb) {
      resultRef = FirebaseDatabase.instance
          .ref('${EnvLoader.get('POBLACION')}/$_selectedFinca');
    } else {
      resultRef = FirebaseDatabase.instance
          .ref('${dotenv.env['POBLACION']}/$_selectedFinca');
    }

    // Generar un nuevo ID único para la entrada
    final newEntryRef = resultRef.push();

    // Verificación de campos obligatorios
    if (selectedTerreno == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, seleccione un terreno.',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 43, 43),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    } else if (cantidadSiembraController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, complete el campo Cantidad de Siembra.',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 43, 43),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    } else if (pesoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, complete el campo Peso.',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 43, 43),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    } else if (fechaPoblacionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, complete el campo Fecha de Población.',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 43, 43),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    } else if (lancesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, complete el campo Número de Lances.',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 43, 43),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    } else if (diametroAtarrayaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, complete el campo Diámetro de Atarraya.',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 43, 43),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    } else if (resultCamaronesController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, complete el campo Total Camarones.',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 43, 43),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    } else if (resultBactimetriaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor, complete el campo Total Bactimetría.',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 43, 43),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      return;
    }

    List<TableRow> rowsresult = [
      const TableRow(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Datos',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 14),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Resultado',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54,
                  fontSize: 14),
            ),
          ),
        ],
      ),
    ];

    List<String> dataLabelsResult = [
      "Total camarones",
      "Numero de Lances",
      "Camarones X Lances",
      "Batimentria",
      "N Camarones X Metro Sin Agua",
      "N Camarones X Metro Con Agua",
      "Cam Promedios",
      "Población Actual",
      "Sobrevivencia",
      "Peso de Camarón",
      "Libras Estimadas",
    ];

    // Define una lista de controladores para los campos adicionales
    List<TextEditingController> controllers = [
      resultCamaronesController,
      lancesController,
      camaronesXLancesController,
      batimentriaController,
      nCamaronesXMetroSinAguaController,
      nCamaronesXMetroConAguaController,
      camPromediosController,
      poblacionActualController,
      sobrevivenciaController,
      pesoDeCamaronController,
      librasEstimadasController,
    ];

    // ÍNDICES de campos que deben llevar formateo numérico con comas:
    final Set<int> camposConFormato = {0, 2, 3, 4, 5, 6, 7, 8, 9, 10};

    int numberOfLancesResult = dataLabelsResult.length;
    print(numberOfLancesResult);

    for (int i = 0; i < dataLabelsResult.length; i++) {
      rowsresult.add(
        TableRow(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Text(
                  dataLabelsResult[i],
                  style: TextStyle(
                    color: Colors.blueGrey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 350.0,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: controllers[i],
                    inputFormatters: camposConFormato.contains(i)
                        ? [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d+\.?\d{0,2}')),
                            NumberFormatter(),
                          ]
                        : [],
                    decoration: const InputDecoration(
                      labelText: '',
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 126, 53, 0),
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 126, 53, 0),
                        ),
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                    ),
                    style: const TextStyle(color: Colors.black87),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    setState(() {
      _data = _generarDatos();
      _dataSource = ResultadoDataGridSource(_data, _selectedFinca);
      tableRowsResult = rowsresult;
      isTableVisibleResult = dataLabelsResult.isNotEmpty;
    });

    // Desplazamiento con animación hacia la tabla
    Future.delayed(const Duration(milliseconds: 300), () {
      if (isTableVisibleResult) {
        _scrollControllerEXCANCRIGRU.animateTo(
          _scrollControllerEXCANCRIGRU.position.maxScrollExtent,
          duration: const Duration(seconds: 1),
          curve: Curves.easeInOut,
        );
      }
    });

    // Crear el mapa con los datos
    Map<String, dynamic> data = {
      "Finca": _selectedFinca,
      "Hectareas": hectareasController.text,
      "Piscinas": piscinasController.text,
      "CantidadSiembra": cantidadSiembraController.text,
      "DensidadSiembra": densidadSiembraController.text,
      "Peso": pesoController.text,
      "FechaPoblacion": fechaPoblacionController.text,
      "DiametroAtarraya": diametroAtarrayaController.text,
      "TotalBactimetria": resultBactimetriaController.text,
      "Totalcamarones": resultCamaronesController.text,
      "NumerodeLances": lancesController.text,
      "CamaronesXLances": camaronesXLancesController.text,
      "Batimentria": batimentriaController.text,
      "NCamaronesXMetroSinAgua": nCamaronesXMetroSinAguaController.text,
      "NCamaronesXMetroConAgua": nCamaronesXMetroConAguaController.text,
      "CamPromedios": camPromediosController.text,
      "PoblaciónActual": poblacionActualController.text,
      "Sobrevivencia": sobrevivenciaController.text,
      "PesodeCamarón": pesoDeCamaronController.text,
      "LibrasEstimadas": librasEstimadasController.text,
    };

    // Guardar en Firebase
    newEntryRef.set(data).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Datos guardados exitosamente.',
            style: TextStyle(
              color: Colors.green,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Error al guardar: $error',
            style: const TextStyle(
              color: Color.fromARGB(255, 255, 43, 43),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    });
  }

// coach mark
  final ScrollController _scrollControllerEXCANCRIGRU = ScrollController();
  final GlobalKey _SelectPiscPOBLACIONEXCANCRIGRU = GlobalKey();
  final GlobalKey _BeforePoblacion = GlobalKey();
  final GlobalKey _AfterPoblacion = GlobalKey();
  final GlobalKey _DiametroAtarrayaPOBLACIONEXCANCRIGRU = GlobalKey();
  final GlobalKey _NumberLancesEXCANCRIGRU = GlobalKey();
  final GlobalKey _ResultFinalPoblacionEXCANCRIGRU = GlobalKey();
  final GlobalKey _resetTutorialPoblation = GlobalKey();
  TutorialCoachMark? tutorialCoachMarkPOBLACIONEXCANCRIGRU;

  @override
  void dispose() {
    hectareasController.dispose();
    piscinasController.dispose();
    pesoController.dispose();
    lancesController.dispose();
    _timerPOBLACIONEXCANCRIGRU?.cancel(); // Cancela el timer si está activo
    tutorialCoachMarkPOBLACIONEXCANCRIGRU?.finish();
    super.dispose();
  }

  String get tutorial_mostrado_EXCANCRIGRU_POBLACION =>
      "tutorial_mostrado_EXCANCRIGRU_POBLACION";

  // Verifica si el tutorial ya fue mostrado
  Future<bool> _shouldShowTutorialPOBLACIONEXCANCRIGRU() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(tutorial_mostrado_EXCANCRIGRU_POBLACION) ??
        true; // Si no existe, se muestra
  }

// Guarda que el tutorial ya se mostró
  Future<void> _setTutorialShownPOBLACIONEXCANCRIGRU() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorial_mostrado_EXCANCRIGRU_POBLACION, false);
  }

// Restablece el tutorial desde ajustes si el usuario lo quiere repetir
  Future<void> resetTutorialPOBLACIONEXCANCRIGRU() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorial_mostrado_EXCANCRIGRU_POBLACION, true);
  }

  // Muestra el tutorial solo si no se ha mostrado antes
  void showTutorialPOBLACIONEXCANCRIGRU() async {
    if (await _shouldShowTutorialPOBLACIONEXCANCRIGRU()) {
      tutorialCoachMarkPOBLACIONEXCANCRIGRU = TutorialCoachMark(
        targets: _initTargetsPOBLACIONEXCANCRIGRU,
        colorShadow: Colors.black87,
        paddingFocus: 0.01,
        showSkipInLastTarget: true,
        initialFocus: 0,
        useSafeArea: true,
        textSkip: "Saltar",
        focusAnimationDuration: const Duration(milliseconds: 500),
        unFocusAnimationDuration: const Duration(milliseconds: 500),
        pulseAnimationDuration: const Duration(milliseconds: 500),
        pulseEnable: true,
        onFinish: () {
          _setTutorialShownPOBLACIONEXCANCRIGRU(); // Guarda que ya se mostró
        },
        onClickTarget: (target) {
          print("Clicked on target: ${target.identify}");
        },
        onClickOverlay: (target) {
          print("Overlay clicked");
        },
      )..show(context: context);
    }
  }

  final List<TargetFocus> _initTargetsPOBLACIONEXCANCRIGRU = [];

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _EXCANCRIGRURef =
          FirebaseDatabase.instance.ref(EnvLoader.get('EXCANCRIGRU_ROWS')!);
      _EXCANCRIGRUBaseRef =
          FirebaseDatabase.instance.ref(EnvLoader.get('EXCANCRIGRU_')!);
    } else {
      _EXCANCRIGRURef =
          FirebaseDatabase.instance.ref(dotenv.env['EXCANCRIGRU_ROWS']!);
      _EXCANCRIGRUBaseRef =
          FirebaseDatabase.instance.ref(dotenv.env['EXCANCRIGRU_']!);
    }
    _initTargetsPOBLACIONEXCANCRIGRU.add(
      TargetFocus(
        identify: "SelectPiscina",
        keyTarget: _SelectPiscPOBLACIONEXCANCRIGRU,
        alignSkip: Alignment.bottomRight,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Configura tu terreno",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Selecciona las hectáreas y la cantidad de alimento en gramos para obtener el mejor rendimiento.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsPOBLACIONEXCANCRIGRU.add(
      TargetFocus(
        identify: "Before",
        keyTarget: _BeforePoblacion,
        alignSkip: Alignment.bottomRight,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Retroceder Pagina",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Da click para retroceder a la página anterior. "
                    "Si no deseas retroceder, puedes omitir este paso.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsPOBLACIONEXCANCRIGRU.add(
      TargetFocus(
        identify: "After",
        keyTarget: _AfterPoblacion,
        alignSkip: Alignment.bottomRight,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Avanzar Pagina",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Da click para avanzar a la página siguiente. "
                    "Si no deseas avanzar, puedes omitir este paso.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsPOBLACIONEXCANCRIGRU.add(
      TargetFocus(
        identify: "NumberLancesEXCANCRIGRU",
        keyTarget: _NumberLancesEXCANCRIGRU,
        alignSkip: Alignment.bottomRight,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Número de Lances",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Ingresa el número de lances realizados para calcular el promedio de camarones y la batimetría.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsPOBLACIONEXCANCRIGRU.add(
      TargetFocus(
        identify: "DiametroAtarraya",
        keyTarget: _DiametroAtarrayaPOBLACIONEXCANCRIGRU,
        alignSkip: Alignment.bottomRight,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Diametro de Atarraya",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Ingresa el diámetro de la atarraya en metros para calcular la cantidad de camarones por metro.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsPOBLACIONEXCANCRIGRU.add(
      TargetFocus(
        identify: "Resultadofinal",
        keyTarget: _ResultFinalPoblacionEXCANCRIGRU,
        alignSkip: Alignment.topRight,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 30),
                Text(
                  "Calcular",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Aquí puedes ver el resultado final de la siembra,'
                    'dando click en el botón "Calcular".',
                    style: TextStyle(
                      color: Color(0xfff3ece7),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsPOBLACIONEXCANCRIGRU.add(
      TargetFocus(
        identify: "Restartutorial",
        keyTarget: _resetTutorialPoblation,
        alignSkip: Alignment.topCenter,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Menú de Ajustes",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Este botón te permite mostrar opciones como exportar a pdf, "
                    "exportar a excel, compartir resultados y restablecer el tutorial.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
    // Asegurar que el tutorial se inicie después de que el widget esté construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timerPOBLACIONEXCANCRIGRU = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          showTutorialPOBLACIONEXCANCRIGRU();
        }
      });
    });
    _loadHectareasPiscinas(_selectedFinca);
    _fetchTerrenos();
    hectareasController.addListener(_updateCalculatedFields);
    piscinasController.addListener(_updateCalculatedFields);
    cantidadSiembraController.addListener(_updateCalculatedFields);
    lancesController.addListener(_updateTableRows);
    ResultController.addListener(_updateTableRowsResult);
    _data = _generarDatos();
    _dataSource = ResultadoDataGridSource(_data, _selectedFinca);
  }

  void _loadHectareasPiscinas(String finca) async {
    final snapshot = await _EXCANCRIGRURef.get();
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

  bool datosCompletos() {
    return _data.isNotEmpty && _data.every((d) => d.estaCompleto());
  }

  @override
  Widget build(BuildContext context) {
    String typeFinca = _selectedFinca;
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: SingleChildScrollView(
        controller: _scrollControllerEXCANCRIGRU,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildHectSelect(
                      _hectareasPiscinas,
                      '${hectareasController.text} - ${piscinasController.text}',
                      'Seleccione Hectáreas y Piscinas',
                      'hectareas',
                      typeFinca),
                ),
                if (selectedTerreno != null)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      elevation: 8,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: getGradientColors(typeFinca),
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromARGB(80, 0, 0, 0),
                              offset: Offset(5, 5),
                              blurRadius: 5,
                            ),
                            BoxShadow(
                              color: Color.fromARGB(147, 202, 202, 202),
                              offset: Offset(-5, -5),
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              const Text(
                                'Detalles de terreno',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 77, 77, 77),
                                ),
                              ),
                              const SizedBox(height: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        const Text(
                                          'Piscinas:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 77, 77, 77),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: CustomTextFieldContent(
                                            label: '0.00',
                                            controller: piscinasController,
                                            keyboardType: TextInputType.number,
                                            isReadOnly: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Hectareas:',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color:
                                                Color.fromARGB(255, 77, 77, 77),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: CustomTextFieldContent(
                                            label: '0.00',
                                            controller: hectareasController,
                                            keyboardType: TextInputType.number,
                                            isReadOnly: true,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Cantidad de Siembra',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 77, 77, 77),
                                          ),
                                        ),
                                        CustomTextFieldContent(
                                          label: '0.00',
                                          controller: cantidadSiembraController,
                                          keyboardType: TextInputType.number,
                                          isReadOnly: false,
                                          onEditingComplete: () {
                                            final parsed = double.tryParse(
                                                cantidadSiembraController.text
                                                    .replaceAll(",", ""));
                                            if (parsed != null) {
                                              cantidadSiembraController.text =
                                                  numberFormatter
                                                      .format(parsed);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Densidad de Siembra',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 77, 77, 77),
                                          ),
                                        ),
                                        CustomTextFieldContent(
                                          label: '0.00',
                                          controller: densidadSiembraController,
                                          keyboardType: TextInputType.number,
                                          isReadOnly: true,
                                          onEditingComplete: () {
                                            final parsed = double.tryParse(
                                                densidadSiembraController.text
                                                    .replaceAll(",", ""));
                                            if (parsed != null) {
                                              densidadSiembraController.text =
                                                  numberFormatter
                                                      .format(parsed);
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Peso en gramos',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 77, 77, 77),
                                          ),
                                        ),
                                        CustomTextFieldContent(
                                          label: ' ',
                                          controller: pesoController,
                                          keyboardType: TextInputType.number,
                                          isReadOnly: false,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          'Fecha de Población',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color:
                                                Color.fromARGB(255, 77, 77, 77),
                                          ),
                                        ),
                                        TextField(
                                          controller: fechaPoblacionController,
                                          decoration: const InputDecoration(
                                            labelText: 'dd-MM-yyyy',
                                            enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 126, 53, 0),
                                              ),
                                            ),
                                            focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 126, 53, 0),
                                              ),
                                            ),
                                          ),
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101),
                                            );
                                            if (pickedDate != null) {
                                              String formattedDate =
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(pickedDate);
                                              setState(() {
                                                fechaPoblacionController.text =
                                                    formattedDate;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Número de Lances:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 77, 77, 77),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomTextFieldLances(
                        typeFinca: typeFinca,
                        label: '0.00',
                        controller: lancesController,
                        keyboardType: TextInputType.number,
                        isReadOnly: false,
                      ),
                    ],
                  ),
                ),
                if (isTableVisible)
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                      elevation: 8,
                      margin: const EdgeInsets.symmetric(vertical: 6.0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: getGradientColors(typeFinca),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(20),
                          ),
                          boxShadow: const [
                            BoxShadow(
                              offset: Offset(-10, 10),
                              color: Color.fromARGB(80, 0, 0, 0),
                              blurRadius: 10,
                            ),
                            BoxShadow(
                                offset: Offset(10, -10),
                                color: Color.fromARGB(150, 255, 255, 255),
                                blurRadius: 10),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                'Detalles de Lances',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(183, 18, 24, 26)),
                              ),
                              const SizedBox(height: 10.0),
                              if (isTableVisible)
                                Table(
                                  border: TableBorder.all(
                                    color: Colors.transparent,
                                  ),
                                  children: tableRows,
                                ),
                              const SizedBox(height: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Resultados:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 77, 77, 77),
                                    ),
                                  ),
                                  CustomTextField(
                                    label: '',
                                    controller: resultCamaronesController,
                                    keyboardType: TextInputType.number,
                                    isReadOnly: true,
                                    onEditingComplete: () {
                                      final parsed = double.tryParse(
                                          resultCamaronesController.text
                                              .replaceAll(",", ""));
                                      if (parsed != null) {
                                        resultCamaronesController.text =
                                            numberFormatter.format(parsed);
                                      }
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Resultado Bactimetria:',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 77, 77, 77),
                                    ),
                                  ),
                                  CustomTextField(
                                    label: '',
                                    controller: resultBactimetriaController,
                                    keyboardType: TextInputType.number,
                                    isReadOnly: true,
                                    onEditingComplete: () {
                                      final parsed = double.tryParse(
                                          resultBactimetriaController.text
                                              .replaceAll(",", ""));
                                      if (parsed != null) {
                                        resultBactimetriaController.text =
                                            numberFormatter.format(parsed);
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Diametro Atarraya:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Color.fromARGB(255, 77, 77, 77),
                        ),
                      ),
                      const SizedBox(height: 10),
                      CustomTextFieldDiametro(
                        controller: diametroAtarrayaController,
                        label: '0.00',
                        keyboardType: TextInputType.number,
                        isReadOnly: false,
                        typeFinca: typeFinca,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  key: _ResultFinalPoblacionEXCANCRIGRU,
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      _updateTableRowsResult();
                    },
                    borderRadius: BorderRadius.circular(
                        10), // Para que el efecto de toque respete la forma
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 16), // Padding interno
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color.fromARGB(255, 126, 53, 0),
                            Color.fromARGB(255, 126, 53, 0),
                          ],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(-10, 10),
                            color: Color.fromARGB(80, 0, 0, 0),
                            blurRadius: 10,
                          ),
                          BoxShadow(
                            offset: Offset(10, -10),
                            color: Color.fromARGB(150, 255, 255, 255),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Calcular',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xfff3ece7),
                            ),
                          ),
                          SizedBox(width: 10.0),
                          Icon(
                            Icons.calculate_rounded,
                            color: Color(0xfff3ece7),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                if (isTableVisibleResult)
                  TablaDinamicaResultado(
                    dataSource: _dataSource,
                    typeFinca: typeFinca,
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: SpeedDial(
        key: _resetTutorialPoblation,
        icon: Icons.more_vert,
        activeIcon: Icons.close,
        iconTheme: const IconThemeData(
          color: Color(0xfff3ece7),
        ),
        backgroundColor: const Color.fromARGB(255, 126, 53, 0),
        overlayOpacity: 0.5,
        spacing: 10,
        spaceBetweenChildren: 10,
        children: [
          SpeedDialChild(
            child: const Icon(
              Icons.share,
              color: Color(0xfff3ece7),
            ),
            backgroundColor: const Color.fromARGB(255, 126, 53, 0),
            label: 'Compartir en redes sociales',
            onTap: () {
              if (!datosCompletos()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Primero debes rellenar todos los datos y hacer clic en el botón "Calcular".'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              ShareRenderedImage.renderAndShare(
                context: context,
                data: _data, // Esta es la lista de ResultadoData
                typefinca: typeFinca,
                title: 'Resumen de resultados de $typeFinca',
              );
            },
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.picture_as_pdf,
              color: Color(0xfff3ece7),
            ),
            backgroundColor: const Color.fromARGB(255, 126, 53, 0),
            label: 'Exportar en PDF',
            onTap: () {
              if (!datosCompletos()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Primero debes rellenar todos los datos y hacer clic en el botón "Calcular".'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }

              exportarAPDF(_data);
            },
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.table_chart,
              color: Color(0xfff3ece7),
            ),
            backgroundColor: const Color.fromARGB(255, 126, 53, 0),
            label: 'Exportar en Excel',
            onTap: () {
              if (!datosCompletos()) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Primero debes rellenar todos los datos y hacer clic en el botón "Calcular".'),
                    duration: Duration(seconds: 2),
                  ),
                );
                return;
              }
              exportarAExcel(_data);
            },
          ),
          SpeedDialChild(
            child: const Icon(
              Icons.refresh,
              color: Color(0xfff3ece7),
            ),
            backgroundColor: const Color.fromARGB(255, 126, 53, 0),
            label: 'Reactivar tutorial',
            onTap: () async {
              await resetTutorialPOBLACIONEXCANCRIGRU();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      "Tutorial restablecido. Para verlo, solo tienes que ir a otra interfaz y luego volver aquí."),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
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

  Widget _buildHectSelect(List<String> itemsHect, String selectedItemHect,
      String titleHect, String categoryHect, String typeFinca) {
    int startIndex = _currentPage * _itemsPerPage;
    int endIndex = (_currentPage + 1) * _itemsPerPage;

    // Limita el rango de elementos para mostrar solo 8 por página
    List<String> pagedItems = itemsHect.sublist(
        startIndex, endIndex > itemsHect.length ? itemsHect.length : endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key: _SelectPiscPOBLACIONEXCANCRIGRU,
          titleHect,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 5),
        Wrap(
          spacing: 10.0,
          children: pagedItems.map((itemHect) {
            // 🔹 Usamos `pagedItems` aquí
            final isSelectedHect = hectareasController.text.trim() ==
                    itemHect.split(" - ")[0].replaceAll("Hect: ", "").trim() &&
                piscinasController.text.trim() ==
                    itemHect.split(" - ")[1].replaceAll("Pisc: ", "").trim();
            return FilterChip(
              shadowColor: Colors.black,
              selectedShadowColor: Colors.black,
              elevation: 5,
              label: Text(
                itemHect,
                style: TextStyle(
                  color: isSelectedHect ? Colors.white : Colors.black,
                ),
              ),
              selected: isSelectedHect,
              onSelected: (isSelected) {
                _onSelect(categoryHect, itemHect, isSelected);
              },
              selectedColor: const Color.fromARGB(255, 126, 53, 0),
              backgroundColor: getBackgroundColor(typeFinca),
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),

        // Controles de paginación
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              key: _BeforePoblacion,
              onPressed: _currentPage > 0 ? _previousPage : null,
              style: ButtonStyle(
                  backgroundColor: _currentPage > 0
                      ? WidgetStateProperty.all<Color>(
                          const Color.fromARGB(255, 126, 53, 0))
                      : null),
              child: const Text(
                "Atrás",
                style: TextStyle(
                  color: Color(0xfff3ece7),
                ),
              ),
            ),
            Text(
              "Pg. ${_currentPage + 1}",
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            ElevatedButton(
              key: _AfterPoblacion,
              onPressed: (_currentPage + 1) * _itemsPerPage < itemsHect.length
                  ? _nextPage
                  : null,
              style: ButtonStyle(
                  backgroundColor:
                      (_currentPage + 1) * _itemsPerPage < itemsHect.length
                          ? WidgetStateProperty.all<Color>(
                              const Color.fromARGB(255, 126, 53, 0))
                          : null),
              child: const Text(
                "Siguiente",
                style: TextStyle(
                  color: Color(0xfff3ece7),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onSelect(String category, String item, bool isSelected) {
    setState(() {
      if (category == "finca") {
        _selectedFinca = isSelected ? item : _selectedFinca;
        _loadHectareasPiscinas(_selectedFinca);
      } else if (category == "hectareas") {
        List<String> parts = item.split(" - ");
        if (parts.length == 2) {
          hectareasController.text = parts[0].replaceAll("Hect: ", "").trim();
          piscinasController.text = parts[1].replaceAll(RegExp(r'[^0-9.]'), '');
          selectedTerreno = {
            "Hectareas": hectareasController.text,
            "Piscinas": piscinasController.text,
          };
          print("Nuevo terreno seleccionado: $selectedTerreno");
        }
      }
    });
  }

  Widget CustomTextFieldLances({
    required TextEditingController controller,
    required String label,
    required TextInputType keyboardType,
    required bool isReadOnly,
    IconButton? icon,
    required String typeFinca,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getGradientColors(typeFinca),
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(80, 0, 0, 0),
            offset: Offset(5, 5),
            blurRadius: 5,
          ),
          BoxShadow(
            color: Color.fromARGB(147, 202, 202, 202),
            offset: Offset(-5, -5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          key: _NumberLancesEXCANCRIGRU,
          controller: controller,
          keyboardType: keyboardType,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            icon: icon,
            hintText: '$label...',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 126, 53, 0),
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 126, 53, 0),
              ),
            ),
          ),
          style: const TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget CustomTextFieldDiametro(
      {required TextEditingController controller,
      required String label,
      required TextInputType keyboardType,
      required bool isReadOnly,
      IconButton? icon,
      required String typeFinca}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: getGradientColors(typeFinca),
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(80, 0, 0, 0),
            offset: Offset(5, 5),
            blurRadius: 5,
          ),
          BoxShadow(
            color: Color.fromARGB(147, 202, 202, 202),
            offset: Offset(-5, -5),
            blurRadius: 5,
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextField(
          key: _DiametroAtarrayaPOBLACIONEXCANCRIGRU,
          controller: controller,
          keyboardType: keyboardType,
          readOnly: isReadOnly,
          decoration: InputDecoration(
            icon: icon,
            hintText: '$label...',
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 126, 53, 0),
              ),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromARGB(255, 126, 53, 0),
              ),
            ),
          ),
          style: const TextStyle(
            color: Colors.black87,
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool isReadOnly;
  final IconButton? icon;
  final VoidCallback? onEditingComplete;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.isReadOnly = true,
    this.icon,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: isReadOnly,
      onEditingComplete: onEditingComplete,
      decoration: InputDecoration(
        icon: icon,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 126, 53, 0),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 126, 53, 0),
          ),
        ),
      ),
      style: const TextStyle(
        color: Colors.black87,
      ),
    );
  }
}

class CustomTextFieldContent extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType keyboardType;
  final bool isReadOnly;
  final IconButton? icon;
  final VoidCallback? onEditingComplete;

  const CustomTextFieldContent({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType = TextInputType.text,
    this.isReadOnly = true,
    this.icon,
    this.onEditingComplete,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      readOnly: isReadOnly,
      onEditingComplete:
          onEditingComplete, // Provide a valid callback function here
      decoration: InputDecoration(
        icon: icon,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 126, 53, 0),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color.fromARGB(255, 126, 53, 0),
          ),
        ),
      ),
      style: const TextStyle(color: Colors.black87),
    );
  }
}

class PanelItem {
  final String name;
  final double hectareas;
  final double piscinas;
  bool isExpanded;

  PanelItem({
    required this.name,
    required this.hectareas,
    required this.piscinas,
    this.isExpanded = false,
  });
}

class NumberFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat("#,##0.##", "en_US");

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text.replaceAll(',', '');

    double? value = double.tryParse(newText);
    if (value == null) return newValue;

    String formatted = _formatter.format(value);

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
