// ignore_for_file: deprecated_member_use, use_build_context_synchronously, camel_case_types

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/Widgets/Edit/resumen_tablas.dart';
import 'package:azaktilza/env_loader.dart';

class Edit_Calculate_TIERRAVID extends StatefulWidget {
  final String id;

  const Edit_Calculate_TIERRAVID({super.key, required this.id});

  @override
  State<Edit_Calculate_TIERRAVID> createState() =>
      _Edit_Calculate_TIERRAVIDState();
}

class _Edit_Calculate_TIERRAVIDState extends State<Edit_Calculate_TIERRAVID> {
  final Map<String, TextEditingController> _controllers = {
    'AcumuladoactualLBS': TextEditingController(),
    'Acumuladosemanal': TextEditingController(),
    'Aireadores': TextEditingController(),
    'pesoactualgdia': TextEditingController(), // Added this line
    'Aireadoresdiesel': TextEditingController(),
    'Alimentoactualkg': TextEditingController(),
    'Capacidadcargaaireaccion': TextEditingController(),
    'Crecimientoactualgdia': TextEditingController(),
    'Crecimientoesperadogsem': TextEditingController(),
    'Densidadbiologoindm2': TextEditingController(),
    'Densidadconsumoim2': TextEditingController(),
    'DensidadporAtarraya': TextEditingController(),
    'Diferenciacampobiologo': TextEditingController(),
    'Domingodia7': TextEditingController(),
    'Edaddelcultivo': TextEditingController(),
    'FCACampo': TextEditingController(),
    'FCAConsumo': TextEditingController(),
    'Fechademuestreo': TextEditingController(),
    'Fechadesiembra': TextEditingController(),
    'Finca': TextEditingController(),
    'Hectareas': TextEditingController(),
    'HpHa': TextEditingController(),
    'Incrementogr': TextEditingController(),
    'Juevesdia4': TextEditingController(),
    'Kg100mil': TextEditingController(),
    'LBShaactualcampo': TextEditingController(),
    'LBShaconsumo': TextEditingController(),
    'LBStolva': TextEditingController(),
    'LBStolvaactualcampo': TextEditingController(),
    'Librastotalescampo': TextEditingController(),
    'Librastotalesconsumo': TextEditingController(),
    'LibrastotalesporAireador': TextEditingController(),
    'Lunesdia1': TextEditingController(),
    'MarcaAA': TextEditingController(),
    'Martesdia2': TextEditingController(),
    'Miercolesdia3': TextEditingController(),
    'Pesoactualgdia': TextEditingController(),
    'Pesoanterior': TextEditingController(),
    'Pesoproyectadogdia': TextEditingController(),
    'Pesosiembra': TextEditingController(),
    'Piscinas': TextEditingController(),
    'Recomendacionlbsha': TextEditingController(),
    'Recomendationsemana': TextEditingController(),
    'RendimientoLbsSaco': TextEditingController(),
    'Sabadodia6': TextEditingController(),
    'Sacosactuales': TextEditingController(),
    'TipoBalanceado': TextEditingController(),
    'Viernesdia5': TextEditingController(),
    'numeroAA': TextEditingController(),
  };

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

  bool _editable = true;
  bool _Show_editable = false;
  late DatabaseReference _ref;
  final String _selectedFinca = 'TIERRAVID';
  String? selectedHectareas;
  String? selectedPiscinas;
  List<Map<String, dynamic>> EXCANCRIGRUData = [];
  List<Map<String, dynamic>> rendimientoData = [];
  List<String> piscinasOptions_EXCANCRIGRU = [];

  Map<double, double> referenciaTabla = {};
  late final DatabaseReference referenciaTabla3;
  late final String basePath;
  late final DatabaseReference dbRef;

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
    print("id: ${widget.id}");
    if (kIsWeb) {
      referenciaTabla3 =
          FirebaseDatabase.instance.ref(EnvLoader.get('PESOS_ALIMENTO')!);
      basePath = EnvLoader.get('RESULT_ALIMENTATION')!;
    } else {
      referenciaTabla3 =
          FirebaseDatabase.instance.ref(dotenv.env['PESOS_ALIMENTO']!);
      basePath = dotenv.env['RESULT_ALIMENTATION']!;
    }
    _ref =
        FirebaseDatabase.instance.ref('$basePath/$_selectedFinca/${widget.id}');

    _loadCamposIniciales();
    _loadData();
    _fetchDataTabla3();

    _agregarListeners();

    // Agrega el listener a todos los controladores
    setState(() {
      generalListener();
      _controllers.forEach((key, controller) {
        controller.addListener(generalListener);
      });
    });
  }

  void generalListener() {
    _calcularDensidadConsumo();
    diferenciacampobiologo();
    _incrementogr();
    _calcularCrecimientoActual();
    _calcularSacosActuales();
    _calcularkg100mil();
    _onDataChange(); // <- Aquí se recalcula todo
    CalcularRendimientoLbsSaco();
    CalcularLibrastotalescampo();
    CalcularLBSTOLVAACTUAL();
    CalcularLBSTOLVAConsumo();
    librastotalesconsumo();
    LibrastotalesporAireador();
    CalcularHPHA();
    FCACampo();
    FCAConsumo();
    _calcularEdadCultivo();
    //_autoSaveChanges(); // <-- Esta función guarda automáticamente los cambios
  }

  Future<void> _loadCamposIniciales() async {
    try {
      final snapshot = await _ref.get();
      if (snapshot.exists) {
        final data = snapshot.value as Map<dynamic, dynamic>;

        // Extrae los valores y asigna a los controladores
        _HectareasController.text = data['Hectareas']?.toString() ?? '';
        _piscinasController.text = data['Piscinas']?.toString() ?? '';
        _fechaSiembraController.text = data['Fechadesiembra']?.toString() ?? '';
      }
    } catch (e) {
      print('Error cargando datos iniciales: $e');
    }
  }

  void _agregarListeners() {
    final controllers = [
      _alimentoactualkgController,
      _pesoanteriorController,
      _densidadbiologoindm2Controller,
      _pesoactualgdiaController,
      _HectareasController,
      _MartesDia2Controller,
      _MiercolesDia3Controller,
      _JuevesDia4Controller,
      _ViernesDia5Controller,
      _SabadoDia6Controller,
      _NumeroAAController,
      _densidadatarrayaController,
      _diferenciacampobiologoController,
      _LibrastotalescampoController,
      _LibrastotalesconsumoController,
      _incrementogrController,
      _HpHaController,
      _LibrastotalesporAireadorController,
      _LBSTOLVAactualCampoController,
      _LBSTOLVASegunConsumoController,
      _AcumuladoactualLBSController,
      _LBSHaConsumoController,
      _LBSHaActualCampoController,
      _FCACampoController,
      _FCAConsumoController,
      _RecomendacionLbshaController,
    ];

    for (var controller in controllers) {
      controller.addListener(generalListener);
    }

    // Listeners especiales
    _densidadconsumoim2Controller.addListener(_calcularkg100mil);
    _kg100milController.addListener(_calcularDensidadConsumo);
    _pesoactualgdiaController.addListener(_calcularCrecimientoActual);
    _HAireadoresMecanicosController.addListener(CalcularLBSHaActualCampo);
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

  // FUNCION DISPARAR AL INICIO
  void _dispararTodosLosCalculos() {
    try {
      print('🔄 Disparando cálculos después de cargar datos...');

      _calcularEdadCultivo();
      _calcularDensidadConsumo();
      diferenciacampobiologo();
      _incrementogr();
      _calcularCrecimientoActual();
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

      print('✅ Cálculos completados.');
    } catch (e) {
      print('⚠️ Error en disparar cálculos: $e');
    }
  }

  //METODO PARA ACTUALIZAR Y GUARDAR LOS CAMBIOS
  Future<void> _loadData() async {
    final snapshot = await _ref.get();

    // Verifica que los datos existan antes de proceder
    if (snapshot.exists) {
      final data = snapshot.value as Map?;

      if (data != null) {
        data.keys.forEach((key) => print("-> $key"));

        // Cargar los valores de Firebase en los controladores
        _fechaMuestreoController.text =
            data['Fechademuestreo']?.toString() ?? '';
        _edadCultivoController.text = data['Edaddelcultivo']?.toString() ?? '';
        _pesosiembraController.text = data['Pesosiembra']?.toString() ?? '';
        _pesoanteriorController.text = data['Pesoanterior']?.toString() ?? '';
        _pesoactualgdiaController.text =
            data['Pesoactualgdia']?.toString() ?? '';
        _alimentoactualkgController.text =
            data['Alimentoactualkg']?.toString() ?? '';
        _densidadbiologoindm2Controller.text =
            data['Densidadbiologoindm2']?.toString() ?? '';
        _densidadatarrayaController.text =
            data['DensidadporAtarraya']?.toString() ?? '';
        _NumeroAAController.text = data['numeroAA']?.toString() ?? '';
        _AcumuladoactualLBSController.text =
            data['AcumuladoactualLBS']?.toString() ?? '';
        _HAireadoresMecanicosController.text =
            data['Aireadores']?.toString() ?? '';

        // Asegúrate de que los controles sean editables según el estado de 'bloqueado'
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _editable = !(data['bloqueado'] ??
                  false); // Desbloquear si no está bloqueado
              for (final entry in _controllers.entries) {
                entry.value.text = data[entry.key]?.toString() ?? '';
              }
            });

            // Llama a los cálculos después de cargar los datos
            if (_fechaSiembraController.text.isNotEmpty &&
                _fechaMuestreoController.text.isNotEmpty) {
              _dispararTodosLosCalculos();
            } else {
              print("⚠️ No se ejecutaron cálculos porque faltan fechas.");
            }
          }
        });
      }
    } else {
      // Maneja el caso cuando no existen datos en Firebase
      print("No se encontraron datos.");
    }
  }

  Future<void> _saveChanges() async {
    final Map<String, dynamic> updates = {
      for (final entry in _controllers.entries) entry.key: entry.value.text,
      'bloqueado': true,
    };

    await _ref.update(updates);

    if (!mounted) return;

    setState(() {
      _editable = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('✅ Datos actualizados, bloqueados y guardados')),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }

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

  final labels = [
    [
      'Piscina',
      'Área (Ha)',
      'Fecha de siembra',
      'Fecha de muestreo',
      'Peso siembra',
      'Edad de cultivo',
      'Crecim actual g/día',
      'Peso Anterior',
      'Incremento gr',
      'Peso actual campo (g)'
    ],
    [
      'Peso proyectado (g)',
      'Crecimiento esperado (g/sem)',
      'Kg/100 mil',
      'Alimento actual Campo (kg)',
      'Sacos actuales',
      'Densidad por consumo (i/m2)',
      'Densidad Biólogo (ind/m2)',
      'Densidad por Atarraya',
      'Diferencia campo vs biólogo',
      ''
    ]
  ];

  final keys = [
    [
      'Piscinas',
      'Hectareas',
      'Fechadesiembra',
      'Fechademuestreo',
      'Pesosiembra',
      'Edaddelcultivo',
      'Crecimientoactualgdia',
      'Pesoanterior',
      'Incrementogr',
      'Pesoactualgdia'
    ],
    [
      'Pesoproyectadogdia',
      'Crecimientoesperadogsem',
      'Kg100mil',
      'Alimentoactualkg',
      'Sacosactuales',
      'Densidadconsumoim2',
      'Densidadbiologoindm2',
      'DensidadporAtarraya',
      'Diferenciacampobiologo',
      ''
    ]
  ];

  final row1 = [
    'Piscina',
    'Área (Ha)',
    'Fecha de siembra',
    'Fecha de muestreo',
    'Peso siembra',
    'Edad de cultivo',
    'Crecim actual g/día',
    'Peso Anterior',
    'Incremento gr',
    'Peso actual campo (g)',
  ];

  final row2 = [
    'Peso proyectado (g)',
    'Crecimiento esperado (g/sem)',
    'Kg/100 mil',
    'Alimento actual Campo (kg)',
    'Sacos Actuales',
    'Densidad por consumo (i/m2)',
    'Densidad Biólogo (ind/m2)',
    'Densidad por Atarraya',
    'Diferencia campo vs biólogo',
    '',
  ];

  final row3 = [
    'Lunesdia 1',
    'Martesdia 2',
    'Miercolesdia 3',
    'Juevesdia 4',
    'Viernesdia 5',
    'Sabadodia 6',
    'Domingodia 7',
    'Recomendación Semana',
  ];

  final row4 = [
    'Acumulado Semanal',
    'Tipo Balanceado',
    'Acumulado ActualLBS',
    'LBS/ha consumo',
    'LBS/ha actualcampo',
    'FCA Campo',
    'FCA Consumo',
    'Rendimiento Lbs/Saco',
  ];

  final row5 = [
    'Número AA',
    'Marca AA',
    'LBS tolva actual campo',
    'LBS tolva',
  ];

  final row5_1 = [
    'Aireadores',
    'Libras totales por Aireador',
    'Hp/Ha',
    'Recomendacion lbs/ha',
  ];

  final row6 = [
    'Libras totales campo',
    'Libras totales consumo',
  ];

  void _downloadPDF() async {
    final pdf = pw.Document();

    pw.Widget buildTableSection(
        String title, List<String> headers, List<String> values, PdfColor color,
        {bool isHeader = false}) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(height: 10),
          pw.Text(
            title,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: const PdfColor.fromInt(0xFF7E3500),
            ),
          ),
          pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey),
            columnWidths: {
              for (int i = 0; i < headers.length; i++)
                i: const pw.FixedColumnWidth(140),
            },
            children: [
              pw.TableRow(
                decoration: pw.BoxDecoration(
                  color: PdfColor.fromInt(color.toInt()),
                ),
                children: headers
                    .map((header) => pw.Padding(
                        padding: const pw.EdgeInsets.all(10),
                        child: pw.Center(
                          child: pw.Text(
                            header,
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: isHeader
                                  ? pw.FontWeight.bold
                                  : pw.FontWeight.normal,
                              color:
                                  isHeader ? PdfColors.white : PdfColors.black,
                            ),
                          ),
                        )))
                    .toList(),
              ),
              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: values
                    .map((value) => pw.Padding(
                          padding: const pw.EdgeInsets.all(10),
                          child: pw.Center(
                            child: pw.Text(
                              value,
                              style: const pw.TextStyle(fontSize: 14),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ],
      );
    }

    final rowData1 = [
      _controllers['Piscinas']?.text ?? '',
      _controllers['Hectareas']?.text ?? '',
      _controllers['Fechadesiembra']?.text ?? '',
      _controllers['Fechademuestreo']?.text ?? '',
      _controllers['Pesosiembra']?.text ?? '',
      _controllers['Edaddelcultivo']?.text ?? '',
      _controllers['Crecimientoactualgdia']?.text ?? '',
      _controllers['Pesoanterior']?.text ?? '',
      _controllers['Incrementogr']?.text ?? '',
      _controllers['Pesoactualgdia']?.text ?? '',
    ];

    final rowData2 = [
      _controllers['Pesoproyectadogdia']?.text ?? '',
      _controllers['Crecimientoesperadogsem']?.text ?? '',
      _controllers['Kg100mil']?.text ?? '',
      _controllers['Alimentoactualkg']?.text ?? '',
      _controllers['Sacosactuales']?.text ?? '',
      _controllers['Densidadconsumoim2']?.text ?? '',
      _controllers['Densidadbiologoindm2']?.text ?? '',
      _controllers['DensidadporAtarraya']?.text ?? '',
      _controllers['Diferenciacampobiologo']?.text ?? '',
      '',
    ];

    final rowData3 = [
      _controllers['Lunesdia1']?.text ?? '',
      _controllers['Martesdia2']?.text ?? '',
      _controllers['Miercolesdia3']?.text ?? '',
      _controllers['Juevesdia4']?.text ?? '',
      _controllers['Viernesdia5']?.text ?? '',
      _controllers['Sabadodia6']?.text ?? '',
      _controllers['Domingodia7']?.text ?? '',
      _controllers['Recomendationsemana']?.text ?? '',
    ];

    final rowData4 = [
      _controllers['Acumuladosemanal']?.text ?? '',
      _controllers['TipoBalanceado']?.text ?? '',
      _controllers['AcumuladoactualLBS']?.text ?? '',
      _controllers['LBShaconsumo']?.text ?? '',
      _controllers['LBShaactualcampo']?.text ?? '',
      _controllers['FCACampo']?.text ?? '',
      _controllers['FCAConsumo']?.text ?? '',
      _controllers['RendimientoLbsSaco']?.text ?? '',
    ];

    final rowData5 = [
      _controllers['numeroAA']?.text ?? '',
      _controllers['MarcaAA']?.text ?? '',
      _controllers['LBStolvaactualcampo']?.text ?? '',
      _controllers['LBStolva']?.text ?? '',
    ];

    final rowData5_1 = [
      _controllers['Aireadores']?.text ?? '',
      _controllers['LibrastotalesporAireador']?.text ?? '',
      _controllers['HpHa']?.text ?? '',
      _controllers['Recomendacionlbsha']?.text ?? '',
    ];

    final rowData6 = [
      _controllers['Librastotalescampo']?.text ?? '',
      _controllers['Librastotalesconsumo']?.text ?? '',
    ];

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) => [
          buildTableSection("Datos Generales", row1, rowData1, PdfColors.teal),
          buildTableSection("", row2, rowData2, PdfColors.teal),
          buildTableSection(
              "Alimentación Semanal", row3, rowData3, PdfColors.orange),
          buildTableSection("", row4, rowData4, PdfColors.orange),
          buildTableSection("Aireadores", row5, rowData5, PdfColors.blue),
          buildTableSection("Aireadores", row5_1, rowData5_1, PdfColors.blue),
          buildTableSection("", row6, rowData6, PdfColors.blue),
        ],
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  void _shareData() {
    final text =
        _controllers.entries.map((e) => '${e.key}: ${e.value.text}').join('\n');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Compartir datos'),
        content: SelectableText(text),
        actions: [
          TextButton(
            child: const Text('Compartir'),
            onPressed: () {
              Navigator.pop(context);
              Share.share(text); // Aquí se lanza la acción de compartir
            },
          ),
          TextButton(
            child: const Text('Cerrar'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _Edit() {
    setState(() {
      _editable = true;
    });
  }

  void _Show_Edit() {
    setState(() {
      if (_Show_editable) {
        _Show_editable = false;
      } else {
        _Show_editable = true;
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
        _fechaMuestreoController.text,
        _pesosiembraController.text,
        _pesoanteriorController.text,
        _pesoactualgdiaController.text,
        _alimentoactualkgController.text,
        _densidadbiologoindm2Controller.text,
        _densidadatarrayaController.text,
        _AcumuladoSemanalController.text,
        _NumeroAAController.text,
        _HAireadoresMecanicosController.text,
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
        'Recomendationsemana': _RecomendationSemanaController.text,
        'Acumuladosemanal': _AcumuladoSemanalController.text,
        'numeroAA': _NumeroAAController.text,
        'Aireadores': _HAireadoresMecanicosController.text,
        'Aireadoresdiesel': _AireadoresdieselController.text,
        'Capacidadcargaaireaccion': _CapacidadcargaaireaccionController.text,
        'LBStolva': _LBSTOLVASegunConsumoController.text,
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

      if (kIsWeb) {
        dbRef = FirebaseDatabase.instance.ref(
            '${EnvLoader.get('RESULT_ALIMENTATION')}/$_selectedFinca/${widget.id}');
      } else {
        dbRef = FirebaseDatabase.instance.ref(
            '${dotenv.env['RESULT_ALIMENTATION']}/$_selectedFinca/${widget.id}');
      }
      await dbRef.push().set(data);

      setState(() {
        _Show_editable = false;
      });

      await Future.delayed(const Duration(
          milliseconds: 300)); // deja tiempo a Flutter para renderizar

      _showAlert(context, '✅ Datos guardados correctamente.');
    } catch (e) {
      _showAlert(context, '⚠️ Error al guardar datos: $e', isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> data = _controllers.map((k, v) => MapEntry(k, v.text));

    TableRow buildEditableRow(List<Widget> widgets, Color color,
        {bool isHeader = false}) {
      return TableRow(
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(12),
          color: isHeader
              ? color.withOpacity(0.1)
              : const Color.fromARGB(255, 155, 155, 155).withOpacity(0.1),
        ),
        children: widgets
            .map((widget) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(child: widget),
                ))
            .toList(),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 126, 53, 0),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(25)),
            boxShadow: [
              BoxShadow(
                  color: Colors.black26, blurRadius: 5, offset: Offset(0, 3))
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back,
                  color: Color(0xfff3ece7), size: 30),
              onPressed: () => Navigator.pop(context),
            ),
            title: const Text(
              'Editar Alimentación',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xfff3ece7),
              ),
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Color(0xfff3ece7)),
                onSelected: (String value) {
                  if (value == 'editar') {
                    _Show_Edit();
                  } else if (value == 'compartir') {
                    _shareData();
                  } else if (value == 'pdf') {
                    _downloadPDF();
                  }
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: 'editar',
                    child: ListTile(
                      leading: !_Show_editable
                          ? const Icon(Icons.edit, color: Colors.green)
                          : const Icon(
                              Icons.visibility,
                              color: Color.fromARGB(255, 126, 53, 0),
                              size: 30,
                            ),
                      title: Text(!_Show_editable ? 'Editar' : 'Mostrar Tabla'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'compartir',
                    child: ListTile(
                      leading: Icon(Icons.share, color: Colors.blue),
                      title: Text('Compartir'),
                    ),
                  ),
                  const PopupMenuItem<String>(
                    value: 'pdf',
                    child: ListTile(
                      leading: Icon(Icons.picture_as_pdf, color: Colors.red),
                      title: Text('Descargar PDF'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_Show_editable) ...[
                  const SizedBox(height: 10),
                  const Text(
                    "✏️ Edición de Datos Clave",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 126, 53, 0),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    constraints: const BoxConstraints(
                        maxHeight:
                            600), // Ajusta esta altura según sea necesario
                    child: SingleChildScrollView(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Table(
                            defaultColumnWidth: const FixedColumnWidth(160),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            children: [
                              buildEditableRow([
                                TextField(
                                  controller: _fechaMuestreoController,
                                  enabled: _editable,
                                  decoration: const InputDecoration(
                                      labelText: 'Fecha Muestreo'),
                                ),
                                TextField(
                                  controller: _pesosiembraController,
                                  enabled: _editable,
                                  decoration: const InputDecoration(
                                      labelText: 'Peso Siembra'),
                                ),
                              ], Colors.transparent, isHeader: true),
                              buildEditableRow([
                                TextField(
                                  controller: _pesoanteriorController,
                                  enabled: _editable,
                                  decoration: const InputDecoration(
                                      labelText: 'Peso Anterior'),
                                ),
                                TextField(
                                    controller: _pesoactualgdiaController,
                                    enabled: _editable,
                                    decoration: const InputDecoration(
                                        labelText: 'Peso Actual g/día')),
                              ], const Color(0xfff3ece7), isHeader: true),
                              buildEditableRow([
                                TextField(
                                  controller: _alimentoactualkgController,
                                  enabled: _editable,
                                  decoration: const InputDecoration(
                                      labelText: 'Alimento Actual (kg)'),
                                ),
                                TextField(
                                    controller: _densidadbiologoindm2Controller,
                                    enabled: _editable,
                                    decoration: const InputDecoration(
                                        labelText: 'Densidad Biólogo')),
                              ], Colors.transparent, isHeader: true),
                              buildEditableRow([
                                TextField(
                                    controller: _densidadatarrayaController,
                                    enabled: _editable,
                                    decoration: const InputDecoration(
                                        labelText: 'Densidad Atarraya')),
                                TextField(
                                    controller: _AcumuladoactualLBSController,
                                    enabled: _editable,
                                    decoration: const InputDecoration(
                                        labelText: 'Acumulado actual (LBS)')),
                              ], const Color(0xfff3ece7), isHeader: true),
                              buildEditableRow([
                                TextField(
                                    controller: _NumeroAAController,
                                    enabled: _editable,
                                    decoration: const InputDecoration(
                                        labelText: 'Número AA')),
                                TextField(
                                    controller: _HAireadoresMecanicosController,
                                    enabled: _editable,
                                    decoration: const InputDecoration(
                                        labelText: '#. Aireadores Mecánicos')),
                              ], Colors.transparent, isHeader: true),
                              buildEditableRow([
                                if (_editable)
                                  ElevatedButton(
                                    onPressed: () =>
                                        _saveDataAlimentation(context),
                                    child: const Text('💾 Actualizar'),
                                  ),
                                Text(
                                  'Edición ${_editable ? 'desbloqueada' : 'bloqueada'}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _editable
                                        ? Colors.green
                                        : const Color.fromARGB(255, 126, 53, 0),
                                  ),
                                ),
                              ], const Color(0xfff3ece7), isHeader: true),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                if (!_Show_editable) ...[
                  SingleChildScrollView(
                    child: ResumenTablas(
                      data: data,
                      typeFinca: _selectedFinca,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                if (_editable)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Center(
                      child: ElevatedButton.icon(
                        onPressed: _saveChanges,
                        icon: const Icon(Icons.save, size: 18),
                        label: const Text(
                          'Guardar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xfff3ece7),
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 126, 53, 0),
                          foregroundColor: const Color(0xfff3ece7),
                        ),
                      ),
                    ),
                  ),
                if (!_editable)
                  const Padding(
                    padding: EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock_outline,
                          color: Color.fromARGB(255, 126, 53, 0),
                          size: 30,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Edición bloqueada',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 126, 53, 0),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
