// ignore_for_file: non_constant_identifier_names, unused_field, use_build_context_synchronously, library_private_types_in_public_api

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/Widgets/fechas_widget.dart';
import 'package:azaktilza/env_loader.dart';

class Calculate_TIERRAVID_Screen extends StatefulWidget {
  const Calculate_TIERRAVID_Screen({Key? key}) : super(key: key);

  @override
  _Calculate_TIERRAVID_Screen_State createState() =>
      _Calculate_TIERRAVID_Screen_State();
}

class _Calculate_TIERRAVID_Screen_State
    extends State<Calculate_TIERRAVID_Screen> {
  String _selectedHectPisc = '';
  List<String> _hectareasPiscinas = [];
  String _selectedFinca = 'TIERRAVID';

  String? selectedHectareas;
  String? selectedPiscinas;

  List<Map<String, dynamic>> TIERRAVIDData = [];
  List<Map<String, dynamic>> rendimientoData = [];
  List<String> piscinasOptions_TIERRAVID = [];

  late final DatabaseReference _TIERRAVIDRef;
  late final DatabaseReference _rendimientoRef;
  late final DatabaseReference referenciaTabla3;

  final TextEditingController _HectareasController = TextEditingController();
  final TextEditingController _piscinasController = TextEditingController();
  final TextEditingController _fechaSiembraController = TextEditingController();
  final TextEditingController _fechaMuestreoController =
      TextEditingController();
  final TextEditingController _edadCultivoController = TextEditingController();
  final TextEditingController _crecimactualgdiaController =
      TextEditingController();
  final TextEditingController _pesosiembraController = TextEditingController();
  final TextEditingController _pesoactualgdiaController =
      TextEditingController();

  final TextEditingController _pesoproyectadogdiaController =
      TextEditingController();
  final TextEditingController _crecimientoesperadosemController =
      TextEditingController();

  final TextEditingController _densidadconsumoim2Controller =
      TextEditingController();

  final TextEditingController _alimentoactualkgController =
      TextEditingController();
  final TextEditingController _kg100milController = TextEditingController();
  final TextEditingController _sacosactualesController =
      TextEditingController();
  final TextEditingController _densidadbiologoindm2Controller =
      TextEditingController();
  final TextEditingController _densidadatarrayaController =
      TextEditingController();

  final TextEditingController _LunesDia1Controller = TextEditingController();
  final TextEditingController _MartesDia2Controller = TextEditingController();
  final TextEditingController _MiercolesDia3Controller =
      TextEditingController();
  final TextEditingController _JuevesDia4Controller = TextEditingController();
  final TextEditingController _ViernesDia5Controller = TextEditingController();
  final TextEditingController _SabadoDia6Controller = TextEditingController();
  final TextEditingController _DomingoDia7Controller = TextEditingController();
  final TextEditingController _RecomendationSemanaController =
      TextEditingController();
  final TextEditingController _AcumuladoSemanalController =
      TextEditingController();
  final TextEditingController _NumeroAAController = TextEditingController();
  final TextEditingController _HAireadoresMecanicosController =
      TextEditingController();
  final TextEditingController _AireadoresdieselController =
      TextEditingController();
  final TextEditingController _CapacidadcargaaireaccionController =
      TextEditingController();
  final TextEditingController _RecomendacionLbshaController =
      TextEditingController();
  final TextEditingController _LBSHaActualCampoController =
      TextEditingController();
  final TextEditingController _LBSTOLVASegunConsumoController =
      TextEditingController();
  final TextEditingController _LBSHaConsumoController = TextEditingController();

  final TextEditingController _diferenciacampobiologoController =
      TextEditingController();

  final TextEditingController _pesoanteriorController = TextEditingController();
  final TextEditingController _incrementogrController = TextEditingController();
  final TextEditingController _AcumuladoactualLBSController =
      TextEditingController();
  final TextEditingController _FCACampoController = TextEditingController();
  final TextEditingController _LibrastotalescampoController =
      TextEditingController();
  final TextEditingController _LibrastotalesconsumoController =
      TextEditingController();
  final TextEditingController _HpHaController = TextEditingController();

  final TextEditingController _LibrastotalesporAireadorController =
      TextEditingController();
  final TextEditingController _LBSTOLVAactualCampoController =
      TextEditingController();
  final TextEditingController _FCAConsumoController = TextEditingController();
  final TextEditingController _RendimientoLbsSacoController =
      TextEditingController();

  Map<double, double> referenciaTabla = {}; // Datos de Firebase

  List<String> itemsTipoBalanceado = [
    "Purina 2,0",
    "Aqua 1,2",
    "Optiline",
    "Haid",
    "NW0",
    "NW3-OPTI",
    "N# 1,2-1,6",
    "NW0-NW1",
    "Aq1,2-Aq4",
    "Aq1,2-N3"
  ];

  List<String> itemsMarcaAA = ["AQ1", "eurovaka"];

  String? selectedTipoBalanceado;
  String? selectedMarcaAA;

  late ScrollController _scrollController;
  bool _showResults = false;

  void _onDataChange() {
    setState(() {
      calcularLunesDia1();
      calcularDomingoDia7();
      calcularMartesDia2();
      calcularMiercolesDia3();
      calcularJuevesDia4();
      calcularViernesDia5();
      calcularSabadoDia6();
      calcularRecomendationSemana();
      CalcularAcumuladoSemanal();
      CalcularLBSHaActualCampo();
      CalcularLBSHAConsumo();
      CalcularLBSTOLVAConsumo();
      CalcularAireadoresdiesel();
      CalcularRecomendacionLbsha();
      CalcularCapacidadcargaaireaccion();
    });
  }

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _TIERRAVIDRef =
          FirebaseDatabase.instance.ref(EnvLoader.get('TIERRAVID_ROWS')!);
      _rendimientoRef =
          FirebaseDatabase.instance.ref(EnvLoader.get('RENDIMIENTO_ROWS')!);
      referenciaTabla3 =
          FirebaseDatabase.instance.ref(EnvLoader.get('PESOS_ALIMENTO')!);
    } else {
      _TIERRAVIDRef =
          FirebaseDatabase.instance.ref(dotenv.env['TIERRAVID_ROWS']!);
      _rendimientoRef =
          FirebaseDatabase.instance.ref(dotenv.env['RENDIMIENTO_ROWS']!);
      referenciaTabla3 =
          FirebaseDatabase.instance.ref(dotenv.env['PESOS_ALIMENTO']!);
    }
    _fetchData();
    _fetchDataTabla3();
    // Agregar listener para calcular sacos actuales
    _alimentoactualkgController.addListener(() {
      setState(() {
        _calcularSacosActuales();
        _calcularDensidadConsumo();
        _calcularkg100mil();
      });
    });
    // Listener general para optimizar setState
    void generalListener() {
      _calcularDensidadConsumo();
      diferenciacampobiologo();
      _incrementogr();
      _calcularCrecimientoActual();
      _calcularSacosActuales();
      _calcularkg100mil();
      _onDataChange();
      CalcularRendimientoLbsSaco();
      CalcularLibrastotalescampo();
      CalcularLBSTOLVAACTUAL();
      CalcularLBSTOLVAConsumo();
      librastotalesconsumo();
      LibrastotalesporAireador();
      CalcularHPHA();
      FCACampo();
      FCAConsumo();
    }

    // Agregar el listener a los controladores relevantes
    _alimentoactualkgController.addListener(generalListener);
    _pesoanteriorController.addListener(generalListener);
    _densidadbiologoindm2Controller.addListener(generalListener);
    _pesoactualgdiaController.addListener(generalListener);
    _HectareasController.addListener(generalListener);
    _MartesDia2Controller.addListener(generalListener);
    _MiercolesDia3Controller.addListener(generalListener);
    _JuevesDia4Controller.addListener(generalListener);
    _ViernesDia5Controller.addListener(generalListener);
    _SabadoDia6Controller.addListener(generalListener);
    _NumeroAAController.addListener(generalListener);
    _densidadconsumoim2Controller.addListener(_calcularkg100mil);
    _kg100milController.addListener(_calcularDensidadConsumo);
    _pesoactualgdiaController.addListener(_calcularCrecimientoActual);
    _HAireadoresMecanicosController.addListener(CalcularLBSHaActualCampo);
    _densidadatarrayaController.addListener(generalListener);
    _diferenciacampobiologoController.addListener(generalListener);
    _scrollController = ScrollController();
    _LibrastotalescampoController.addListener(generalListener);
    _LibrastotalesconsumoController.addListener(generalListener);
    _incrementogrController.addListener(generalListener);
    _HpHaController.addListener(generalListener);
    _HAireadoresMecanicosController.addListener(generalListener);
    _LibrastotalesporAireadorController.addListener(generalListener);
    _LBSTOLVAactualCampoController.addListener(generalListener);
    _LBSTOLVASegunConsumoController.addListener(generalListener);
    _AcumuladoactualLBSController.addListener(generalListener);
    _LBSHaConsumoController.addListener(generalListener);
    _LBSHaActualCampoController.addListener(generalListener);
    _FCACampoController.addListener(generalListener);
    _FCAConsumoController.addListener(generalListener);
    _RecomendacionLbshaController.addListener(generalListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _HectareasController.dispose();
    _piscinasController.dispose();
    _fechaSiembraController.dispose();
    _fechaMuestreoController.dispose();
    _edadCultivoController.dispose();
    _crecimactualgdiaController.dispose();
    _pesosiembraController.dispose();
    _pesoactualgdiaController.dispose();
    _pesoproyectadogdiaController.dispose();
    _crecimientoesperadosemController.dispose();
    _densidadconsumoim2Controller.dispose();
    _alimentoactualkgController.dispose();
    _kg100milController.dispose();
    _sacosactualesController.dispose();
    _densidadbiologoindm2Controller.dispose();
    _densidadatarrayaController.dispose();
    _LunesDia1Controller.dispose();
    _MartesDia2Controller.dispose();
    _MiercolesDia3Controller.dispose();
    _JuevesDia4Controller.dispose();
    _ViernesDia5Controller.dispose();
    _SabadoDia6Controller.dispose();
    _DomingoDia7Controller.dispose();
    _RecomendationSemanaController.dispose();
    _AcumuladoSemanalController.dispose();
    _NumeroAAController.dispose();
    _HAireadoresMecanicosController.dispose();
    _AireadoresdieselController.dispose();
    _CapacidadcargaaireaccionController.dispose();
    _RecomendacionLbshaController.dispose();
    _LBSTOLVASegunConsumoController.dispose();
    _LBSHaConsumoController.dispose();
    _LBSHaActualCampoController.dispose();
    _incrementogrController.dispose();
    _pesoanteriorController.dispose();
    _AcumuladoactualLBSController.dispose();
    _FCACampoController.dispose();
    _LibrastotalescampoController.dispose();
    _diferenciacampobiologoController.dispose();
    _LibrastotalesconsumoController.dispose();
    _HpHaController.dispose();
    _LibrastotalesporAireadorController.dispose();
    _LBSTOLVAactualCampoController.dispose();
    _FCAConsumoController.dispose();
    _RendimientoLbsSacoController.dispose();
    super.dispose();
  }

  void _calcularSacosActuales() {
    double alimentoKg =
        double.tryParse(_alimentoactualkgController.text) ?? 0.0;
    double sacos = alimentoKg / 25;

    _sacosactualesController.text =
        sacos.toStringAsFixed(2); // Limita a 2 decimales
  }

  void _calcularEdadCultivo() {
    try {
      setState(() {
        if (_fechaSiembraController.text.trim().isEmpty ||
            _fechaMuestreoController.text.trim().isEmpty) {
          print("⚠️ Error: Una o ambas fechas están vacías.");
          return;
        }

        DateTime fechaSiembra =
            DateFormat('dd/MM/yyyy').parse(_fechaSiembraController.text);
        DateTime fechaMuestreo =
            DateFormat('dd/MM/yyyy').parse(_fechaMuestreoController.text);

        int diferenciaDias = fechaMuestreo.difference(fechaSiembra).inDays;

        if (diferenciaDias < 0) {
          print(
              "⚠️ Error: La fecha de muestreo no puede ser anterior a la de siembra.");
          return;
        }
        int masuno =
            diferenciaDias + 1; // Ajustar para incluir el día de siembra
        _edadCultivoController.text = masuno.toString();
      });
      setState(() {
        _calcularCrecimientoActual(); // 🚀 Disparar automáticamente
      });
    } catch (e) {
      print('⚠️ Error en el cálculo de la edad del cultivo: $e');
    }
  }

  void _incrementogr() {
    double pesoActual = double.tryParse(_pesoactualgdiaController.text) ?? 0;
    double pesoAnterior = double.tryParse(_pesoanteriorController.text) ?? 0;

    if (pesoAnterior == 0) {
      _incrementogrController.text = "0.00";
      return;
    }

    double incremento = pesoActual - pesoAnterior;

    setState(() {
      _incrementogrController.text = incremento.toStringAsFixed(2);
    });
  }

  void _validarYActualizarFecha(TextEditingController controller) {
    String input = controller.text.trim();
    if (RegExp(r'^\d{2}/\d{2}/\d{4}$').hasMatch(input)) {
      try {
        DateTime parsedDate = DateFormat('dd/MM/yyyy').parseStrict(input);
        setState(() {
          controller.text = DateFormat('dd/MM/yyyy').format(parsedDate);
        });
        _calcularEdadCultivo();
      } catch (e) {
        // Si la fecha no es válida, puedes mostrar un mensaje o ignorar el error
        debugPrint("Fecha inválida: $e");
      }
    }
  }

  Future<void> _seleccionarFecha(
      BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
      });

      _calcularEdadCultivo();
    }
  }

  void _fetchData() async {
    try {
      final TIERRAVIDSnapshot = await _TIERRAVIDRef.get();
      final rendimientoSnapshot = await _rendimientoRef.get();

      if (TIERRAVIDSnapshot.exists) {
        setState(() {
          if (TIERRAVIDSnapshot.value is List) {
            TIERRAVIDData = (TIERRAVIDSnapshot.value as List)
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
          } else if (TIERRAVIDSnapshot.value is Map) {
            TIERRAVIDData = (TIERRAVIDSnapshot.value as Map)
                .values
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
          }

          piscinasOptions_TIERRAVID =
              TIERRAVIDData.map((e) => e['Piscinas'].toString()).toList();
          if (piscinasOptions_TIERRAVID.isNotEmpty) {
            selectedPiscinas = piscinasOptions_TIERRAVID.first;
            _updateHectareasForPiscina(selectedPiscinas!);
          }
        });
      }
      if (rendimientoSnapshot.exists) {
        setState(() {
          if (rendimientoSnapshot.value is List) {
            rendimientoData = (rendimientoSnapshot.value as List)
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
          } else if (rendimientoSnapshot.value is Map) {
            rendimientoData = (rendimientoSnapshot.value as Map)
                .values
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList();
          }
        });
      }

      calcularRecomendationSemana();
    } catch (e) {
      print('⚠️ Error al cargar datos: $e');
    }
  }

  void _fetchDataTabla3() async {
    try {
      referenciaTabla3.once().then((DatabaseEvent event) {
        if (event.snapshot.value != null) {
          var rawData = event.snapshot.value;

          referenciaTabla.clear();

          if (rawData is Map<dynamic, dynamic>) {
            rawData.forEach((key, value) {
              double peso = double.tryParse(key.toString()) ?? -1;
              double valor = double.tryParse(value.toString()) ?? 0.0;
              if (peso >= 0) {
                referenciaTabla[peso] = valor;
              }
            });
          } else if (rawData is List) {
            for (int i = 0; i < rawData.length; i++) {
              if (rawData[i] != null) {
                double peso = i.toDouble();
                double valor = double.tryParse(rawData[i].toString()) ?? 0.0;
                referenciaTabla[peso] = valor;
              }
            }
          } else {
            print("⚠️ Formato de datos desconocido en Firebase.");
          }
        } else {
          print("⚠️ No se encontraron datos en Firebase.");
        }
      }).catchError((error) {
        print("❌ Error al cargar datos de Firebase: $error");
      });
    } catch (e) {
      print('⚠️ Error al cargar datos: $e');
    }
  }

  void _updateHectareasForPiscina(String piscina) {
    final matchingPiscina = TIERRAVIDData.firstWhere(
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
  }

  void _calcularCrecimientoActual() {
    double pesoActual = double.tryParse(_pesoactualgdiaController.text) ?? 0;
    double pesoSiembra = double.tryParse(_pesosiembraController.text) ?? 0;
    int edadCultivo = int.tryParse(_edadCultivoController.text) ?? 0;

    double crecimiento = (pesoActual - pesoSiembra) / edadCultivo;

    setState(() {
      _crecimactualgdiaController.text = crecimiento.toStringAsFixed(2);
    });

    _calcularPesoProyectado(pesoActual);
  }

  void _calcularPesoProyectado(double pesoActual) {
    double incremento = 0;

    if (pesoActual > 0.001 && pesoActual < 7) {
      incremento = 2.5;
    } else if (pesoActual >= 7 && pesoActual < 11) {
      incremento = 3;
    } else if (pesoActual >= 11) {
      incremento = 3;
    }

    double pesoProyectado = pesoActual + incremento;

    setState(() {
      _pesoproyectadogdiaController.text = pesoProyectado.toStringAsFixed(2);
    });
    _calcularCrecimientoEsperado(pesoProyectado);
  }

  void _calcularDensidadConsumo() async {
    try {
      // Obtener y validar inputs del usuario
      double alimentoActualKg =
          double.tryParse(_alimentoactualkgController.text) ?? 0.0;
      double hectareas = double.tryParse(_HectareasController.text) ?? 1.0;
      double pesoActualG =
          double.tryParse(_pesoactualgdiaController.text) ?? 1.0;

      print("Peso Actual G: $pesoActualG");
      print("Hectáreas: $hectareas");
      print("Alimento Actual Kg: $alimentoActualKg");

      if (hectareas == 0 || pesoActualG == 0) {
        setState(() {
          _densidadconsumoim2Controller.text = "Datos inválidos";
        });
        return;
      }

      // Obtener los datos de Firebase
      DatabaseEvent event = await referenciaTabla3.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value == null) {
        setState(() {
          _densidadconsumoim2Controller.text = "No hay datos";
        });
        return;
      }

      // Procesar los datos como lista de mapas
      List<Map<String, dynamic>> data = [];
      final rawData = snapshot.value;

      if (rawData is Map) {
        data = rawData.values
            .where((e) => e is Map)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } else if (rawData is List) {
        data = rawData
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } else {
        setState(() {
          _densidadconsumoim2Controller.text = "Formato de datos inválido";
        });
        return;
      }

      // Buscar el peso más cercano sin superar el actual
      double pesoEncontrado = 0.0;
      String bwCosechas = "0%";

      for (var row in data) {
        if (row.containsKey("Pesos") && row.containsKey("BWCosechas")) {
          double? peso = double.tryParse(row["Pesos"].toString());
          if (peso != null && peso <= pesoActualG && peso > pesoEncontrado) {
            pesoEncontrado = peso;
            bwCosechas = row["BWCosechas"].toString();
          }
        }
      }

      // Convertir porcentaje BWCosechas a decimal
      double bwCosechasDecimal =
          double.tryParse(bwCosechas.replaceAll('%', '').trim()) ?? 0.0;
      print("BWCosechas: $bwCosechas");

      if (bwCosechasDecimal == 0) {
        setState(() {
          _densidadconsumoim2Controller.text = "BWCosechas inválido";
        });
        return;
      }

      // Calcular densidad de consumo
      double densidadConsumo = (alimentoActualKg / hectareas) *
          10 /
          (pesoActualG * (bwCosechasDecimal));
      print("Densidad Consumo: $densidadConsumo");

      // Mostrar el resultado
      setState(() {
        _densidadconsumoim2Controller.text = densidadConsumo.toStringAsFixed(2);
      });
    } catch (e) {
      print("Error al calcular densidad: $e");
      setState(() {
        _densidadconsumoim2Controller.text = "Error";
      });
    }
  }

  // Método para calcular el crecimiento esperado en porcentaje
  void diferenciacampobiologo() {
    String consumoText = _densidadconsumoim2Controller.text.trim();
    String biologoText = _densidadbiologoindm2Controller.text.trim();

    double? densidadconsumo = double.tryParse(consumoText);
    double? densidadbiologo = double.tryParse(biologoText);

    if (densidadconsumo != null &&
        densidadbiologo != null &&
        densidadbiologo != 0) {
      double diferencia = ((densidadconsumo / densidadbiologo) - 1) * 100;
      int porcentaje = diferencia.round();

      setState(() {
        _diferenciacampobiologoController.text = porcentaje.toString();
      });
    } else {
      setState(() {
        _diferenciacampobiologoController.text = "0";
      });
    }
  }

  void _calcularCrecimientoEsperado(double pesoProyectado) {
    try {
      double? pesoProyectado =
          double.tryParse(_pesoproyectadogdiaController.text);
      double? pesoActualCampo = double.tryParse(_pesoactualgdiaController.text);

      if (pesoProyectado != null && pesoActualCampo != null) {
        double crecimientoEsperado = pesoProyectado - pesoActualCampo;
        setState(() {
          _crecimientoesperadosemController.text =
              crecimientoEsperado.toStringAsFixed(2);
        });
      } else {
        setState(() {
          _crecimientoesperadosemController.text = "0.00"; // Valor por defecto
        });
      }
    } catch (e) {
      print('⚠️ Error al calcular el crecimiento esperado: $e');
      setState(() {
        _crecimientoesperadosemController.text = "0.00"; // Manejo de errores
      });
    }
  }

  void _calcularkg100mil() {
    double alimentoKg =
        double.tryParse(_alimentoactualkgController.text) ?? 0.0;
    double hect = double.tryParse(_HectareasController.text) ?? 0.0;

    double densidadconsumo =
        double.tryParse(_densidadconsumoim2Controller.text) ?? 0.0;

    double kg100mil = (alimentoKg / hect) / densidadconsumo * 10;

    setState(() {
      _kg100milController.text = kg100mil.toStringAsFixed(2);
    });
  }

  void calcularLunesDia1() async {
    try {
      double pesoActualG =
          double.tryParse(_pesoactualgdiaController.text) ?? 1.0;
      double hectareaje = double.tryParse(_HectareasController.text) ?? 1.0;
      double densidadBiologo =
          double.tryParse(_densidadbiologoindm2Controller.text) ?? 1.0;

      if (pesoActualG == 0 || hectareaje == 0 || densidadBiologo == 0) {
        setState(() {
          _LunesDia1Controller.text = "Datos inválidos";
        });
        return;
      }

      // Obtener los datos de Firebase
      DatabaseEvent event = await referenciaTabla3.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value == null) {
        setState(() {
          _LunesDia1Controller.text = "No hay datos";
        });
        return;
      }

      // Convertir datos a lista de mapas
      List<Map<String, dynamic>> data = [];
      final rawData = snapshot.value;

      if (rawData is Map) {
        data = rawData.values
            .where((e) => e is Map)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } else if (rawData is List) {
        data = rawData
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } else {
        setState(() {
          _LunesDia1Controller.text = "Formato de datos inválido";
        });
        return;
      }

      // Buscar el peso más cercano sin superar el peso actual
      double pesoEncontrado = 0.0;
      String bwCosechas = "0%";

      for (var row in data) {
        if (row.containsKey("Pesos") && row.containsKey("BWCosechas")) {
          double? peso = double.tryParse(row["Pesos"].toString());
          if (peso != null && peso <= pesoActualG && peso > pesoEncontrado) {
            pesoEncontrado = peso;
            bwCosechas = row["BWCosechas"].toString();
          }
        }
      }

      double bwCosechasDecimal =
          double.tryParse(bwCosechas.replaceAll('%', '').trim()) ?? 0.0;
      bwCosechasDecimal /= 100;

      if (bwCosechasDecimal == 0) {
        setState(() {
          _LunesDia1Controller.text = "BWCosechas inválido";
        });
        return;
      }

      // Cálculo
      double LunesDia1 =
          ((pesoActualG / 1000) * ((densidadBiologo * 10000) * hectareaje)) *
              bwCosechasDecimal;

      int resultadoRedondeado = (LunesDia1 / 25).round() * 25;

      setState(() {
        _LunesDia1Controller.text = (LunesDia1.isNaN || LunesDia1.isInfinite)
            ? "25"
            : resultadoRedondeado.toString();
      });
    } catch (e) {
      print("Error al calcular LunesDia1: $e");
      setState(() {
        _LunesDia1Controller.text = "Error";
      });
    }
  }

  void calcularDomingoDia7() async {
    try {
      double pesoProject =
          double.tryParse(_pesoproyectadogdiaController.text) ?? 1.0;
      double hectareaje = double.tryParse(_HectareasController.text) ?? 1.0;
      double densidadBiologo =
          double.tryParse(_densidadbiologoindm2Controller.text) ?? 1.0;

      if (pesoProject == 0 || hectareaje == 0 || densidadBiologo == 0) {
        setState(() {
          _DomingoDia7Controller.text = "Datos inválidos";
        });
        return;
      }

      // Obtener datos de Firebase
      DatabaseEvent event = await referenciaTabla3.once();
      DataSnapshot snapshot = event.snapshot;

      if (snapshot.value == null) {
        setState(() {
          _DomingoDia7Controller.text = "No hay datos";
        });
        return;
      }

      List<Map<String, dynamic>> data = [];
      final rawData = snapshot.value;

      if (rawData is Map) {
        data = rawData.values
            .where((e) => e is Map)
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } else if (rawData is List) {
        data = rawData
            .whereType<Map>()
            .map((e) => Map<String, dynamic>.from(e))
            .toList();
      } else {
        setState(() {
          _DomingoDia7Controller.text = "Formato de datos inválido";
        });
        return;
      }

      // Buscar el peso más cercano sin superar el proyectado
      double pesoEncontrado = 0.0;
      String bwCosechas = "0%";

      for (var row in data) {
        if (row.containsKey("Pesos") && row.containsKey("BWCosechas")) {
          double? peso = double.tryParse(row["Pesos"].toString());
          if (peso != null && peso <= pesoProject && peso > pesoEncontrado) {
            pesoEncontrado = peso;
            bwCosechas = row["BWCosechas"].toString();
          }
        }
      }

      double bwCosechasDecimal =
          double.tryParse(bwCosechas.replaceAll('%', '').trim()) ?? 0.0;
      bwCosechasDecimal /= 100;

      if (bwCosechasDecimal == 0) {
        setState(() {
          _DomingoDia7Controller.text = "BWCosechas inválido";
        });
        return;
      }

      double DomingoDia7 =
          ((pesoProject / 1000) * ((densidadBiologo * 10000) * hectareaje)) *
              bwCosechasDecimal;

      int resultadoRedondeado = (DomingoDia7 / 25).round() * 25;

      setState(() {
        _DomingoDia7Controller.text =
            (DomingoDia7.isNaN || DomingoDia7.isInfinite)
                ? "25"
                : resultadoRedondeado.toString();
      });
    } catch (e) {
      print("Error al calcular DomingoDia7: $e");
      setState(() {
        _DomingoDia7Controller.text = "Error";
      });
    }
  }

  void calcularMartesDia2() {
    try {
      setState(() {
        double lunesdia1c = double.tryParse(_LunesDia1Controller.text) ?? 1.0;
        double domingodia7c =
            double.tryParse(_DomingoDia7Controller.text) ?? 1.0;

        // Calcular el incremento diario
        double incrementoDiario = (domingodia7c - lunesdia1c) / 6;

        // Calcular el valor del martes
        double martesdia2c = lunesdia1c + incrementoDiario;

        // Redondear al múltiplo de 25 más cercano
        double resultadoRedondeado = ((martesdia2c / 25).round()) * 25;

        // Asignar el resultado al controlador
        _MartesDia2Controller.text = resultadoRedondeado.toString();
      });
    } catch (e) {
      setState(() {
        _MartesDia2Controller.text = "Error";
      });
    }
  }

  void calcularMiercolesDia3() {
    try {
      double lunesdia1c = double.tryParse(_LunesDia1Controller.text) ?? 1.0;
      1.0; // Valor de MartesDia
      double domingodia7c = double.tryParse(_DomingoDia7Controller.text) ??
          1.0; // Valor de DomingoDia

      // Calcular el incremento diario
      double incrementoDiario = (domingodia7c - lunesdia1c) / 6 * 2;

      // Calcular el valor del martes
      double martesdia2c = lunesdia1c + incrementoDiario;

      // Redondear al múltiplo de 25 más cercano
      double resultadoRedondeado = ((martesdia2c / 25).round()) * 25;
      setState(() {
        _MiercolesDia3Controller.text = resultadoRedondeado.toString();
      });
    } catch (e) {
      setState(() {
        _MiercolesDia3Controller.text = "Error";
      });
    }
  }

  void calcularJuevesDia4() {
    try {
      double lunesdia1c = double.tryParse(_LunesDia1Controller.text) ?? 1.0;
      1.0; // Valor de MartesDia
      double domingodia7c = double.tryParse(_DomingoDia7Controller.text) ??
          1.0; // Valor de DomingoDia

      // Calcular el incremento diario
      double incrementoDiario = (domingodia7c - lunesdia1c) / 6 * 3;

      // Calcular el valor del martes
      double martesdia2c = lunesdia1c + incrementoDiario;

      // Redondear al múltiplo de 25 más cercano
      double resultadoRedondeado = ((martesdia2c / 25).round()) * 25;
      setState(() {
        _JuevesDia4Controller.text = resultadoRedondeado.toString();
      });
    } catch (e) {
      setState(() {
        _JuevesDia4Controller.text = "Error";
      });
    }
  }

  void calcularViernesDia5() {
    try {
      double lunesdia1c = double.tryParse(_LunesDia1Controller.text) ?? 1.0;
      1.0; // Valor de MartesDia
      double domingodia7c = double.tryParse(_DomingoDia7Controller.text) ??
          1.0; // Valor de DomingoDia

      // Calcular el incremento diario
      double incrementoDiario = (domingodia7c - lunesdia1c) / 6 * 4;

      // Calcular el valor del martes
      double martesdia2c = lunesdia1c + incrementoDiario;

      // Redondear al múltiplo de 25 más cercano
      double resultadoRedondeado = ((martesdia2c / 25).round()) * 25;
      setState(() {
        _ViernesDia5Controller.text = resultadoRedondeado.toString();
      });
    } catch (e) {
      setState(() {
        _ViernesDia5Controller.text = "Error";
      });
    }
  }

  void calcularSabadoDia6() {
    try {
      double lunesdia1c = double.tryParse(_LunesDia1Controller.text) ?? 1.0;
      1.0; // Valor de MartesDia
      double domingodia7c = double.tryParse(_DomingoDia7Controller.text) ??
          1.0; // Valor de DomingoDia

      // Calcular el incremento diario
      double incrementoDiario = (domingodia7c - lunesdia1c) / 6 * 5;

      // Calcular el valor del martes
      double martesdia2c = lunesdia1c + incrementoDiario;

      // Redondear al múltiplo de 25 más cercano
      double resultadoRedondeado = ((martesdia2c / 25).round()) * 25;
      setState(() {
        _SabadoDia6Controller.text = resultadoRedondeado.toString();
      });
    } catch (e) {
      setState(() {
        _SabadoDia6Controller.text = "Error";
      });
    }
  }

  void calcularRecomendationSemana() {
    try {
      double lunesdia1c = double.tryParse(_LunesDia1Controller.text) ??
          1.0; // Valor de LunesDia1
      double martesdia2c = double.tryParse(_MartesDia2Controller.text) ??
          1.0; // Valor de MartesDia2
      double miercolesdia3c = double.tryParse(_MiercolesDia3Controller.text) ??
          1.0; // Valor de MiercolesDia3
      double juevesdia4c = double.tryParse(_JuevesDia4Controller.text) ??
          1.0; // Valor de JuevesDia4
      double viernesdia5c = double.tryParse(_ViernesDia5Controller.text) ?? 1.0;
      double sabadodia6c = double.tryParse(_SabadoDia6Controller.text) ?? 1.0;
      double domingodia7c = double.tryParse(_DomingoDia7Controller.text) ?? 1.0;

      double suma = lunesdia1c +
          martesdia2c +
          miercolesdia3c +
          juevesdia4c +
          viernesdia5c +
          sabadodia6c +
          domingodia7c;
      double recomendationSemana = suma / 7;

      setState(() {
        _RecomendationSemanaController.text =
            recomendationSemana.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _RecomendationSemanaController.text = "Error";
      });
    }
  }

  void CalcularAcumuladoSemanal() {
    try {
      double recomendationSemanal =
          double.tryParse(_RecomendationSemanaController.text) ??
              1.0; // Valor de recomendationSemanal
      double AcumuladoSemanal = recomendationSemanal * 7;

      setState(() {
        _AcumuladoSemanalController.text = AcumuladoSemanal.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _AcumuladoSemanalController.text = "Error";
      });
    }
  }

  void CalcularAireadoresdiesel() {
    try {
      double aireadores =
          double.tryParse(_HAireadoresMecanicosController.text) ?? 1.0;
      double hectareas = double.tryParse(_HectareasController.text) ?? 1.0;
      double Aireadoresdiesel = (aireadores * 3) / hectareas;

      setState(() {
        _AireadoresdieselController.text = Aireadoresdiesel.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _AireadoresdieselController.text = "Error";
      });
    }
  }

  void CalcularCapacidadcargaaireaccion() {
    try {
      double aireadoresDiesel =
          double.tryParse(_AireadoresdieselController.text) ?? 1.0;
      double hectarea = double.tryParse(_HectareasController.text) ?? 1.0;

      double Capacidadcargaaireaccion =
          (aireadoresDiesel * 3000) + (7500 * hectarea);

      setState(() {
        _CapacidadcargaaireaccionController.text =
            Capacidadcargaaireaccion.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _CapacidadcargaaireaccionController.text = "Error";
      });
    }
  }

  void LibrastotalesporAireador() {
    double librastotalescampo =
        double.tryParse(_LibrastotalescampoController.text) ?? 1.0;
    double aireadoresmecanicos =
        double.tryParse(_HAireadoresMecanicosController.text) ?? 1.0;

    double librastotalesporAireador = librastotalescampo / aireadoresmecanicos;
    setState(() {
      _LibrastotalesporAireadorController.text =
          librastotalesporAireador.toStringAsFixed(2);
    });
  }

  void FCACampo() {
    double aculmulado =
        double.tryParse(_AcumuladoactualLBSController.text) ?? 1.0;
    double librastotalescampo =
        double.tryParse(_LibrastotalescampoController.text) ?? 1.0;

    double FCAcampo = aculmulado / librastotalescampo;
    setState(() {
      _FCACampoController.text = FCAcampo.toStringAsFixed(2);
    });
  }

  void FCAConsumo() {
    double aculmulado =
        double.tryParse(_AcumuladoactualLBSController.text) ?? 1.0;
    double librastotalesconsumo =
        double.tryParse(_LibrastotalesconsumoController.text) ?? 1.0;

    double FCAConsumo = aculmulado / librastotalesconsumo;
    setState(() {
      _FCAConsumoController.text = FCAConsumo.toStringAsFixed(2);
    });
  }

  void CalcularRendimientoLbsSaco() {
    double lbsactualcampo =
        double.tryParse(_LBSHaActualCampoController.text) ?? 1.0;
    double hectareaje = double.tryParse(_HectareasController.text) ?? 1.0;
    double alimentoactualcampo =
        double.tryParse(_alimentoactualkgController.text) ?? 1.0;
    double rendimientoLbsSaco =
        (lbsactualcampo * hectareaje) / (alimentoactualcampo / 25);
    setState(() {
      _RendimientoLbsSacoController.text =
          rendimientoLbsSaco.toStringAsFixed(2);
    });
  }

  void CalcularRecomendacionLbsha() {
    try {
      double capacidad = 7000; // Valor de recomendationSemanal
      double hectareaje = double.tryParse(_HectareasController.text) ?? 1.0;
      double recomendacionLbsha = capacidad * hectareaje;

      setState(() {
        _RecomendacionLbshaController.text =
            recomendacionLbsha.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _RecomendacionLbshaController.text = "Error";
      });
    }
  }

  void CalcularLBSHaActualCampo() {
    try {
      double densidadbiologo2 =
          double.tryParse(_densidadbiologoindm2Controller.text) ??
              1.0; // Valor de recomendationSemanal
      double pesoactualcampo =
          double.tryParse(_pesoactualgdiaController.text) ?? 1.0;

      double LBSHaActualCampo = densidadbiologo2 * pesoactualcampo * 22;

      setState(() {
        _LBSHaActualCampoController.text = LBSHaActualCampo.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _LBSHaActualCampoController.text = "Error";
      });
    }
  }

  void CalcularLBSHAConsumo() {
    try {
      double densidadconsumo =
          double.tryParse(_densidadconsumoim2Controller.text) ??
              1.0; // Valor de recomendationSemanal
      double pesoactualgdia =
          double.tryParse(_pesoactualgdiaController.text) ?? 1.0;
      double LBSHAConsumo = densidadconsumo * pesoactualgdia * 22;

      setState(() {
        _LBSHaConsumoController.text = LBSHAConsumo.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _LBSHaConsumoController.text = "Error";
      });
    }
  }

  void CalcularLBSTOLVAACTUAL() {
    double lbsactualcampo =
        double.tryParse(_LBSHaActualCampoController.text) ?? 1.0;
    double aacontroller = double.tryParse(_NumeroAAController.text) ?? 1.0;
    double hectareas = double.tryParse(_HectareasController.text) ?? 1.0;

    double LBSHaActualCampo = (lbsactualcampo * hectareas) / aacontroller;
    setState(() {
      _LBSTOLVAactualCampoController.text = LBSHaActualCampo.toStringAsFixed(2);
    });
  }

  void CalcularLBSTOLVAConsumo() {
    try {
      double aacontroller = double.tryParse(_NumeroAAController.text) ??
          1.0; // Valor de recomendationSemanal
      double LBSHaConsumo =
          double.tryParse(_LBSHaConsumoController.text) ?? 1.0;
      double hectarea = double.tryParse(_HectareasController.text) ?? 1.0;

      double LBSTOLVAConsumo = (LBSHaConsumo * hectarea) / aacontroller;

      setState(() {
        _LBSTOLVASegunConsumoController.text =
            LBSTOLVAConsumo.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _LBSTOLVASegunConsumoController.text = "Error";
      });
    }
  }

  void CalcularLibrastotalescampo() {
    double lbsactualcampo =
        double.tryParse(_LBSHaActualCampoController.text) ?? 1.0;
    double areahectarea = double.tryParse(_HectareasController.text) ?? 1.0;
    double librastotalescampo = lbsactualcampo * areahectarea;
    setState(() {
      _LibrastotalescampoController.text =
          librastotalescampo.toStringAsFixed(2);
    });
  }

  void CalcularHPHA() {
    double aereadormecanicoHP = 16.00;
    double rendimientoestadoymantenimiento = 1;
    double numeroaireadoresmecanicos =
        double.tryParse(_HAireadoresMecanicosController.text) ?? 1.0;
    double hectareaje = double.tryParse(_HectareasController.text) ?? 1.0;

    double HpHaController = (numeroaireadoresmecanicos * aereadormecanicoHP) /
        (hectareaje * rendimientoestadoymantenimiento);

    setState(() {
      _HpHaController.text = HpHaController.toStringAsFixed(2);
    });
  }

  void CalcularFCACampo() {
    try {
      double acumuladoactualfbs =
          double.tryParse(_AcumuladoactualLBSController.text) ?? 1.0;
      double librastotalescampo =
          double.tryParse(_LibrastotalescampoController.text) ?? 1.0;
      double FCACampo = acumuladoactualfbs / librastotalescampo;

      setState(() {
        _FCACampoController.text = FCACampo.toStringAsFixed(2);
      });
    } catch (e) {
      setState(() {
        _FCACampoController.text = "Error";
      });
    }
  }

  void librastotalesconsumo() {
    double lbsactualconsumo =
        double.tryParse(_LBSHaConsumoController.text) ?? 1.0;
    double areahectarea = double.tryParse(_HectareasController.text) ?? 1.0;
    double librastotalesconsumo = lbsactualconsumo * areahectarea;
    setState(() {
      _LibrastotalesconsumoController.text =
          librastotalesconsumo.toStringAsFixed(2);
    });
  }

  void _loadHectareasPiscinas(String finca) async {
    final snapshot = await _TIERRAVIDRef.get();
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

  void _onSelect(String category, String item, bool isSelected) {
    setState(() {
      if (category == "finca") {
        _selectedFinca = isSelected ? item : "TIERRAVID";
        _loadHectareasPiscinas(_selectedFinca);
      } else if (category == "hectareas") {
        List<String> parts = item.split(" - ");
        if (parts.length == 2) {
          _HectareasController.text = parts[0].replaceAll("Hect: ", "").trim();
          _piscinasController.text =
              parts[1].replaceAll(RegExp(r'[^0-9.]'), '');
          _selectedHectPisc = item; // Almacenar selección exacta
        }
      }
    });
  }

  void _showAlert(BuildContext context, String message,
      {bool isError = false}) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError
          ? const Color.fromARGB(255, 69, 69, 69)
          : const Color.fromARGB(255, 69, 69, 69),
      duration: const Duration(seconds: 3),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _saveDataAlimentation(BuildContext context) async {
    try {
      final List<String> requiredFields = [
        _selectedFinca,
        _HectareasController.text,
        _piscinasController.text,
        _fechaSiembraController.text,
        _fechaMuestreoController.text,
        _edadCultivoController.text,
        _pesosiembraController.text,
        _pesoactualgdiaController.text,
        _crecimactualgdiaController.text,
        _pesoproyectadogdiaController.text,
        _crecimientoesperadosemController.text,
        _alimentoactualkgController.text,
        _kg100milController.text,
        _densidadconsumoim2Controller.text,
        _densidadbiologoindm2Controller.text,
        _densidadatarrayaController.text,
        _LunesDia1Controller.text,
        _MartesDia2Controller.text,
        _MiercolesDia3Controller.text,
        _JuevesDia4Controller.text,
        _ViernesDia5Controller.text,
        _SabadoDia6Controller.text,
        _DomingoDia7Controller.text,
        selectedTipoBalanceado ?? '',
        _RecomendationSemanaController.text,
        _AcumuladoSemanalController.text,
        _NumeroAAController.text,
        _HAireadoresMecanicosController.text,
        _AireadoresdieselController.text,
        _CapacidadcargaaireaccionController.text,
        _LBSTOLVASegunConsumoController.text,
        selectedMarcaAA ?? '',
        _RecomendacionLbshaController.text,
        _LBSHaActualCampoController.text,
        _LBSHaConsumoController.text,
      ];

      if (requiredFields.any((field) => field.isEmpty)) {
        _showAlert(context,
            '⚠️ Todos los campos deben estar llenos antes de subir los datos.',
            isError: true);
        return;
      }

      final Map<String, dynamic> data = {
        'Finca': _selectedFinca,
        'Hectareas': _HectareasController.text,
        'Piscinas': _piscinasController.text,
        'Fechadesiembra': _fechaSiembraController.text,
        'Fechademuestreo': _fechaMuestreoController.text,
        'Edaddelcultivo': _edadCultivoController.text,
        'Pesosiembra': _pesosiembraController.text,
        'Pesoactualgdia': _pesoactualgdiaController.text,
        'Crecimientoactualgdia': _crecimactualgdiaController.text,
        'Pesoproyectadogdia': _pesoproyectadogdiaController.text,
        'Crecimientoesperadogsem': _crecimientoesperadosemController.text,
        'Alimentoactualkg': _alimentoactualkgController.text,
        'Kg100mil': _kg100milController.text,
        'Densidadconsumoim2': _densidadconsumoim2Controller.text,
        'Densidadbiologoindm2': _densidadbiologoindm2Controller.text,
        'DensidadporAtarraya': _densidadatarrayaController.text,
        'Lunesdia1': _LunesDia1Controller.text,
        'Martesdia2': _MartesDia2Controller.text,
        'Miercolesdia3': _MiercolesDia3Controller.text,
        'Juevesdia4': _JuevesDia4Controller.text,
        'Viernesdia5': _ViernesDia5Controller.text,
        'Sabadodia6': _SabadoDia6Controller.text,
        'Domingodia7': _DomingoDia7Controller.text,
        'TipoBalanceado': selectedTipoBalanceado,
        'Recomendationsemana': _RecomendationSemanaController.text,
        'Acumuladosemanal': _AcumuladoSemanalController.text,
        'numeroAA': _NumeroAAController.text,
        'Aireadores': _HAireadoresMecanicosController.text,
        'Aireadoresdiesel': _AireadoresdieselController.text,
        'Capacidadcargaaireaccion': _CapacidadcargaaireaccionController.text,
        'LBStolva': _LBSTOLVASegunConsumoController.text,
        'MarcaAA': selectedMarcaAA,
        'Recomendacionlbsha': _RecomendacionLbshaController.text,
        'LBShaactualcampo': _LBSHaActualCampoController.text,
        'LBShaconsumo': _LBSHaConsumoController.text,
        'Librastotalescampo': _LibrastotalescampoController.text,
        'Librastotalesconsumo': _LibrastotalesconsumoController.text,
        'LBStolvaactualcampo': _LBSTOLVAactualCampoController.text,
        'LBStolvasconsumo': _LBSTOLVASegunConsumoController.text,
        'HpHa': _HpHaController.text,
        'FCACampo': _FCACampoController.text,
        'FCAConsumo': _FCAConsumoController.text,
        'RendimientoLbsSaco': _RendimientoLbsSacoController.text,
        'LibrastotalesporAireador': _LibrastotalesporAireadorController.text,
        'AcumuladoactualLBS': _AcumuladoactualLBSController.text,
        'Diferenciacampobiologo': _diferenciacampobiologoController.text,
        'Sacosactuales': _sacosactualesController.text,
        'Pesoanterior': _pesoanteriorController.text,
        'Incrementogr': _incrementogrController.text,
      };

      final DatabaseReference dbRef;
      if (kIsWeb) {
        dbRef = FirebaseDatabase.instance
            .ref('${EnvLoader.get('RESULT_ALIMENTATION')}/$_selectedFinca');
      } else {
        dbRef = FirebaseDatabase.instance
            .ref('${dotenv.env['RESULT_ALIMENTATION']}/$_selectedFinca');
      }

      await dbRef.push().set(data);

      setState(() {
        _showResults = true;
      });

      await Future.delayed(const Duration(
          milliseconds: 300)); // deja tiempo a Flutter para renderizar

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );

      _showAlert(context, '✅ Datos guardados correctamente.');
    } catch (e) {
      _showAlert(context, '⚠️ Error al guardar datos: $e', isError: true);
    }
  }

  void resetCalculate(BuildContext context) async {
    // Limpiar los campos de texto después de guardar los datos
    _HectareasController.clear();
    _piscinasController.clear();
    _fechaSiembraController.clear();
    _fechaMuestreoController.clear();
    _edadCultivoController.clear();
    _pesosiembraController.clear();
    _pesoactualgdiaController.clear();
    _crecimactualgdiaController.clear();
    _pesoproyectadogdiaController.clear();
    _crecimientoesperadosemController.clear();
    _alimentoactualkgController.clear();
    _kg100milController.clear();
    _densidadconsumoim2Controller.clear();
    _densidadbiologoindm2Controller.clear();
    _densidadatarrayaController.clear();
    _LunesDia1Controller.clear();
    _MartesDia2Controller.clear();
    _MiercolesDia3Controller.clear();
    _JuevesDia4Controller.clear();
    _ViernesDia5Controller.clear();
    _SabadoDia6Controller.clear();
    _DomingoDia7Controller.clear();
    _RecomendationSemanaController.clear();
    _AcumuladoSemanalController.clear();
    _NumeroAAController.clear();
    _HAireadoresMecanicosController.clear();
    _AireadoresdieselController.clear();
    _CapacidadcargaaireaccionController.clear();
    _RecomendacionLbshaController.clear();
    _LBSHaActualCampoController.clear();
    _LBSHaConsumoController.clear();
    _LibrastotalescampoController.clear();
    _LibrastotalesconsumoController.clear();
    _HpHaController.clear();
    _FCACampoController.clear();
    _FCAConsumoController.clear();
    _RendimientoLbsSacoController.clear();
    _LibrastotalesporAireadorController.clear();
    _AcumuladoactualLBSController.clear();
    _diferenciacampobiologoController.clear();
    _sacosactualesController.clear();
    _pesoanteriorController.clear();
    _incrementogrController.clear();
    _LBSTOLVASegunConsumoController.clear();

    // Resetear las selecciones
    setState(() {
      _selectedFinca = ''; // Si es una variable seleccionada
      selectedTipoBalanceado = null;
      selectedMarcaAA = null;
    });

    setState(() {
      _showResults = false;
    });

    await Future.delayed(
      const Duration(milliseconds: 300),
    );
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOut,
    );

    _showAlert(context, '✅ Datos Restablecidos Correctamente.');
  }

  @override
  Widget build(BuildContext context) {
    List<String> itemsHesct = TIERRAVIDData.map((data) {
      return 'Hect: ${data['Hectareas']} - Pisc: ${data['Piscinas']}';
    }).toList();

    // Controller for displaying selectedTipoBalanceado as read-only in the table
    final TextEditingController _tipoBalanceadoController =
        TextEditingController(text: selectedTipoBalanceado ?? '');

    final List<Widget> resultadoTablas = [
      const Text(
        "📌 Datos Generales",
        style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 126, 53, 0)),
      ),
      const SizedBox(height: 10),
      Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(3),
        },
        children: [
          _buildEditableRow("Piscina", _piscinasController, Colors.teal,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("Área (Ha)", _HectareasController, Colors.teal),
          _spacerRow(),
          _buildEditableRow(
              "Fecha de siembra", _fechaSiembraController, Colors.teal,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow(
              "Fecha de muestreo", _fechaMuestreoController, Colors.teal),
          _spacerRow(),
          _buildEditableRow("Peso siembra", _pesosiembraController, Colors.teal,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow(
              "Edad del cultivo", _edadCultivoController, Colors.teal),
          _spacerRow(),
          _buildEditableRow("Crecimiento actual (g/día)",
              _crecimactualgdiaController, Colors.teal,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow(
              "Peso anterior", _pesoanteriorController, Colors.teal),
          _spacerRow(),
          _buildEditableRow(
              "Incremento gr", _incrementogrController, Colors.teal,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("Peso actual campo (g)",
              _pesoproyectadogdiaController, Colors.teal),
        ],
      ),
      const SizedBox(height: 20),
      const Text("📊 Crecimiento y Consumo",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 126, 53, 0))),
      const SizedBox(height: 10),
      Table(
        columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
        children: [
          _buildEditableRow(
              "Peso proyectado (g)", _pesoproyectadogdiaController, Colors.blue,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("Crecimiento esperado (g/sem)",
              _crecimientoesperadosemController, Colors.blue),
          _spacerRow(),
          _buildEditableRow("Kg/100 mil", _kg100milController, Colors.blue,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("Alimento actual Campo (kg)",
              _alimentoactualkgController, Colors.blue),
          _spacerRow(),
          _buildEditableRow(
              "Sacos actuales", _sacosactualesController, Colors.blue,
              isHeader: true),
        ],
      ),
      const SizedBox(height: 20),
      const Text("🧮 Densidades y Diferencias",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 126, 53, 0))),
      const SizedBox(height: 10),
      Table(
        columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
        children: [
          _buildEditableRow("Densidad por Consumo (i/m²)",
              _densidadconsumoim2Controller, Colors.purple,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("Densidad Biólogo (ind/m²)",
              _densidadbiologoindm2Controller, Colors.purple),
          _spacerRow(),
          _buildEditableRow("Densidad por Atarraya",
              _densidadatarrayaController, Colors.purple,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("Diferencia campo vs biólogo",
              _diferenciacampobiologoController, Colors.purple),
        ],
      ),
      const SizedBox(height: 20),
      const Text("📅 Planificación Semanal",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 126, 53, 0))),
      const SizedBox(height: 10),
      Table(
        columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
        children: [
          _buildEditableRow("Lunes", _LunesDia1Controller, Colors.orange,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("Martes", _MartesDia2Controller, Colors.orange),
          _spacerRow(),
          _buildEditableRow(
              "Miércoles", _MiercolesDia3Controller, Colors.orange,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("Jueves", _JuevesDia4Controller, Colors.orange),
          _spacerRow(),
          _buildEditableRow("Viernes", _ViernesDia5Controller, Colors.orange,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("Sábado", _SabadoDia6Controller, Colors.orange),
          _spacerRow(),
          _buildEditableRow("Domingo", _DomingoDia7Controller, Colors.orange,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("Promedio Semanal", _RecomendationSemanaController,
              Colors.orange),
          _spacerRow(),
          _buildEditableRow(
              "Acumulado Semanal", _AcumuladoSemanalController, Colors.orange,
              isHeader: true),
        ],
      ),
      const SizedBox(height: 20),
      const Text("🛠️ Alimentación y Aireadores",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 126, 53, 0))),
      const SizedBox(height: 10),
      Table(
        columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
        children: [
          _buildEditableRow("Número AA", _NumeroAAController, Colors.pink,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow(
            "Marca AA",
            TextEditingController(text: selectedMarcaAA ?? ''),
            Colors.pink,
          ),
          _spacerRow(),
          _buildEditableRow("LBS Tolva Actual Campo",
              _LBSTOLVAactualCampoController, Colors.pink,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("LBS Tolva Consumo",
              _LBSTOLVASegunConsumoController, Colors.pink),
          _spacerRow(),
          _buildEditableRow("Libras Totales por Aireador",
              _LibrastotalesporAireadorController, Colors.pink,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("Hp/Ha", _HpHaController, Colors.pink),
          _spacerRow(),
          _buildEditableRow("Recomendación lbs/ha",
              _RecomendacionLbshaController, Colors.pink,
              isHeader: true),
        ],
      ),
      const SizedBox(height: 20),
      const Text("📦 Totales y Recomendaciones",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 126, 53, 0))),
      const SizedBox(height: 10),
      Table(
        columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(3)},
        children: [
          _buildEditableRow(
              "Tipo Balanceado", _tipoBalanceadoController, Colors.indigo,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("Acumulado Actual LBS",
              _AcumuladoactualLBSController, Colors.indigo),
          _spacerRow(),
          _buildEditableRow(
              "LBS/ha Consumo", _LBSHaConsumoController, Colors.indigo,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("LBS/ha Actual Campo", _LBSHaActualCampoController,
              Colors.indigo),
          _spacerRow(),
          _buildEditableRow("FCA Campo", _FCACampoController, Colors.indigo,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow(
              "FCA Consumo", _FCAConsumoController, Colors.indigo),
          _spacerRow(),
          _buildEditableRow("Rendimiento Lbs/Saco",
              _RendimientoLbsSacoController, Colors.indigo,
              isHeader: true),
          _spacerRow(),
          _buildEditableRow("Libras Totales Campo",
              _LibrastotalescampoController, Colors.indigo),
          _spacerRow(),
          _buildEditableRow("Libras Totales Consumo",
              _LibrastotalesconsumoController, Colors.indigo,
              isHeader: true),
        ],
      ),
    ];
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 126, 53, 0),
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Color(0xfff3ece7),
                size: 30,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            title: const Text(
              'Alimentación - TIERRAVID',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xfff3ece7),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      margin: const EdgeInsets.only(top: 2),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          _buildHesctSelect(itemsHesct, selectedHectareas ?? '',
                              "Selecciona la piscina:", "hectareas"),
                        ],
                      ),
                    ),
                  ),
                  FechasWidget(
                    fechaSiembraController: _fechaSiembraController,
                    fechaMuestreoController: _fechaMuestreoController,
                    edadCultivoController: _edadCultivoController,
                    seleccionarFecha: _seleccionarFecha,
                    validarYActualizarFecha: _validarYActualizarFecha,
                    calcularEdadCultivo: _calcularEdadCultivo,
                    pesosiembraController: _pesosiembraController,
                    pesoanteriorController: _pesoanteriorController,
                    pesoactualgdiaController: _pesoactualgdiaController,
                    alimentoactualkgController: _alimentoactualkgController,
                    densidadbiologoindm2Controller:
                        _densidadbiologoindm2Controller,
                    densidadatarrayaController: _densidadatarrayaController,
                    tipoBalanceadoWidget: _buildTipoBalanceadoSelect(
                      itemsTipoBalanceado,
                      selectedTipoBalanceado ?? '',
                      "Tipo Balanceado:",
                    ),
                    numeroAAController: _NumeroAAController,
                    acumuladoActualLBSController: _AcumuladoactualLBSController,
                    itemsMarcaAA: itemsMarcaAA,
                    selectedMarcaAA: selectedMarcaAA ?? '',
                    buildMarcaAASelect: _buildMarcaAASelect,
                    hAireadoresMecanicosController:
                        _HAireadoresMecanicosController,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 176, 74, 11),
                                Color.fromARGB(255, 126, 53, 0),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(-5, 5),
                                color: Color.fromARGB(80, 0, 0, 0),
                                blurRadius: 10,
                              ),
                              BoxShadow(
                                offset: Offset(5, -5),
                                color: Color.fromARGB(150, 255, 255, 255),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            child: ElevatedButton(
                              onPressed: () {
                                _saveDataAlimentation(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                    vertical: 16.0,
                                    horizontal: 24.0), // Tamaño del botón
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Calcular Alimentación',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xfff3ece7),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.calculate,
                                    color: Color(0xfff3ece7),
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 176, 74, 11),
                                Color.fromARGB(255, 126, 53, 0),
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(50),
                            ),
                            boxShadow: [
                              BoxShadow(
                                offset: Offset(-5, 5),
                                color: Color.fromARGB(80, 0, 0, 0),
                                blurRadius: 10,
                              ),
                              BoxShadow(
                                offset: Offset(5, -5),
                                color: Color.fromARGB(150, 255, 255, 255),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                          child: SizedBox(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 16.0,
                                ),
                              ),
                              onPressed: () {
                                resetCalculate(context);
                              },
                              child: const Icon(
                                Icons.restart_alt,
                                color: Color(0xfff3ece7),
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_showResults)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        margin: const EdgeInsets.only(top: 2),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ...resultadoTablas,
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static final NumberFormat numberFormatter = NumberFormat("#,##0.##", "en_US");

  TableRow _buildEditableRow(
      String label, TextEditingController controller, Color color,
      {bool isHeader = false}) {
    String displayValue = controller.text;

    // Intentamos formatear si es numérico
    if (displayValue.isNotEmpty) {
      final parsed = num.tryParse(displayValue.replaceAll(",", ""));
      if (parsed != null) {
        displayValue = numberFormatter.format(parsed);
      }
    }
    return TableRow(
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(12),
          color: isHeader
              ? color.withOpacity(0.1)
              : const Color.fromARGB(255, 155, 155, 155).withOpacity(0.1),
        ),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(5),
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
                  color: isHeader ? color : Colors.black,
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(5),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Text(displayValue),
              ),
            ),
          ),
        ]);
  }

  TableRow _spacerRow() => const TableRow(children: [
        SizedBox(height: 5),
        SizedBox(height: 5),
      ]);

  Widget _buildHesctSelect(List<String> itemsHesct, String selectedItemHesct,
      String titleHesct, String categoryHesct) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleHesct,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
          ),
        ),
        Wrap(
          spacing: 10.0,
          children: itemsHesct.map((itemHesct) {
            final isSelectedHesct = _HectareasController.text.trim() ==
                    itemHesct.split(" - ")[0].replaceAll("Hect: ", "").trim() &&
                _piscinasController.text.trim() ==
                    itemHesct
                        .split(" - ")[1]
                        .replaceAll(RegExp(r'[^0-9.]'), '');
            return FilterChip(
              label: Text(
                itemHesct,
                style: TextStyle(
                  color: isSelectedHesct ? Colors.white : Colors.black,
                ),
              ),
              selected: isSelectedHesct,
              onSelected: (isSelectedHesct) {
                _onSelect(categoryHesct, itemHesct, isSelectedHesct);
              },
              selectedColor: const Color.fromARGB(255, 126, 53, 0),
              backgroundColor: const Color(0xfff4f4f4),
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildTipoBalanceadoSelect(
      List<String> items, String? selectedItem, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          spacing: 10.0,
          children: items.map((item) {
            final isSelected = selectedItem == item;
            return FilterChip(
              label: Text(
                item,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  selectedTipoBalanceado = selected ? item : null;
                });
              },
              selectedColor: const Color.fromARGB(255, 126, 53, 0),
              backgroundColor: const Color(0xfff4f4f4),
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildMarcaAASelect(
      List<String> items, String? selectedItem, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          spacing: 10.0,
          children: items.map((item) {
            final isSelected = selectedItem == item;
            return FilterChip(
              label: Text(
                item,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                ),
              ),
              selected: isSelected,
              onSelected: (bool selected) {
                setState(() {
                  selectedMarcaAA = selected ? item : null;
                });
              },
              selectedColor: const Color.fromARGB(255, 126, 53, 0),
              backgroundColor: const Color(0xfff4f4f4),
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
