// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:convert'; // Para codificar y decodificar JSON
import 'package:azaktilza/env_loader.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class IAWebViewScreen extends StatefulWidget {
  const IAWebViewScreen({super.key});

  @override
  State<IAWebViewScreen> createState() => _IAWebViewScreenState();
}

class _IAWebViewScreenState extends State<IAWebViewScreen>
    with SingleTickerProviderStateMixin {
  // Controladores de texto para los campos de entrada
  final TextEditingController _animalesController = TextEditingController();
  final TextEditingController _hectareasController = TextEditingController();
  final TextEditingController _piscinasController = TextEditingController();
  // Animation controller
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  late DatabaseReference _database;

  double _progress = 0.0; // Progreso de carga
  bool _isLoading = false; // Estado de carga

  String _result = '';
  String _selectedFinca = 'CAMANOVILLO';
  late List<String> _fincas = [
    "CAMANOVILLO",
    "EXCANCRIGRU",
    "FERTIAGRO",
    "GROVITAL",
    "SUFAAZA",
    "TIERRAVID",
  ];
  List<String> _hectareasPiscinas = [];

  // coach mark
  final GlobalKey _SelectPiscIA = GlobalKey();
  final GlobalKey _SelectTerreno = GlobalKey();
  final GlobalKey _Naimals = GlobalKey();
  final GlobalKey _calcularbuttonAI = GlobalKey();
  final GlobalKey _BeforeDATO = GlobalKey();
  final GlobalKey _AfterDATO = GlobalKey();
  final GlobalKey _resultAI = GlobalKey();
  Timer? _timer;
  int _currentPage = 0;
  final int _itemsPerPage = 4;

  TutorialCoachMark? tutorialCoachMarkIA;

  final List<TargetFocus> _initTargetsAI = [];

  @override
  void dispose() {
    _timer?.cancel();
    tutorialCoachMarkIA?.finish();
    _controller.dispose();
    super.dispose();
  }

  String get tutorialKeyIA_WEB => "Gestionar_IA_WEB";

  // Verifica si el tutorial ya fue mostrado
  Future<bool> _shouldShowTutorialIA() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(tutorialKeyIA_WEB) ?? true; // Si no existe, se muestra
  }

// Guarda que el tutorial ya se mostró
  Future<void> _setTutorialShownIA() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorialKeyIA_WEB, false);
  }

// Restablece el tutorial desde ajustes si el usuario lo quiere repetir
  Future<void> resetTutorialIA() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorialKeyIA_WEB, true);
  }

  void showTutorialIA() async {
    if (await _shouldShowTutorialIA()) {
      tutorialCoachMarkIA = TutorialCoachMark(
        targets: _initTargetsAI,
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
          _setTutorialShownIA(); // Guarda que ya se mostró
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

  @override
  void initState() {
    super.initState();

    if (kIsWeb) {
      _database = FirebaseDatabase.instance.ref(EnvLoader.get("TERRAIN")!);
    } else {
      _database =
          FirebaseDatabase.instance.ref("Empresas/TerrawaSufalyng/Terrain");
    }

    _initTargetsAI.add(
      TargetFocus(
        identify: "SelectTerreno",
        keyTarget: _SelectTerreno,
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
                  "Selecciona el terreno",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Selecciona el terreno para obtener el mejor resultado.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsAI.add(
      TargetFocus(
        identify: "SelectPiscina",
        keyTarget: _SelectPiscIA,
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
                  "Selecciona la hectárea y piscina",
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
    _initTargetsAI.add(
      TargetFocus(
        identify: "BeforeDATO",
        keyTarget: _BeforeDATO,
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
                  "Atrás",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Regresa a la página anterior.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsAI.add(
      TargetFocus(
        identify: "AfterDATO",
        keyTarget: _AfterDATO,
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
                  "Siguiente",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Avanza a la siguiente página.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsAI.add(
      TargetFocus(
        identify: "Naimals",
        keyTarget: _Naimals,
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
                  "Ingresa el número de animales",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Ingresa el número de animales para obtener el mejor resultado.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsAI.add(
      TargetFocus(
        identify: "calcularbuttonAI",
        keyTarget: _calcularbuttonAI,
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
                  "Realizar Predicción",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Realiza la predicción para obtener el mejor resultado.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsAI.add(
      TargetFocus(
        identify: "resultAI",
        keyTarget: _resultAI,
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
                  "Resultado",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Muestra el resultado de la predicción.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timer = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          showTutorialIA();
        }
      });
    });

    // Inicializa el controlador de animación
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    _loadFincas();
    _loadHectareasPiscinas(_selectedFinca);
  }

  void _loadFincas() async {
    final snapshot = await _database.get();
    if (snapshot.exists) {
      Map<String, dynamic> data =
          Map<String, dynamic>.from(snapshot.value as Map);
      setState(() {
        _fincas = data.keys.toList(); // Nombres de fincas disponibles
      });
    }
  }

  void _loadHectareasPiscinas(String finca) async {
    final snapshot = await _database.child(finca).child("rows").get();
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

  // Función para hacer la solicitud POST
  Future<void> predict() async {
    if (_selectedHectPisc.isEmpty) {
      setState(() {
        _result = 'Por favor, selecciona una hectárea y piscina.';
      });
      return;
    }

    final double animalesM = double.tryParse(_animalesController.text) ?? 0;
    final double hectareas = double.tryParse(_hectareasController.text) ?? 0;
    final double piscinas = double.tryParse(_piscinasController.text) ?? 0;

    if (animalesM <= 0 || hectareas <= 0 || piscinas <= 0) {
      setState(() {
        _result = 'Por favor, ingresa valores válidos';
      });
      return;
    }

    // Mostrar estado de carga
    setState(() {
      _isLoading = true;
      _progress = 0.1; // Iniciar con un pequeño progreso
    });

    final Map<String, dynamic> requestData = {
      'finca': _selectedFinca,
      'HectPisc': _selectedHectPisc, // Enviar la selección exacta
      'AnimalesM': animalesM,
      'Hectareas': hectareas,
      'Piscinas': piscinas,
    };

    try {
      final response = await http.post(
        Uri.parse(
            'https://terrawadocker-59858778016.us-central1.run.app/predict'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      );

      // Simular progreso durante la espera
      for (int i = 1; i <= 10; i++) {
        await Future.delayed(const Duration(milliseconds: 100));
        setState(() {
          _progress = i * 0.1; // Incrementar el progreso
        });
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          _result = '''
          Peso: ${responseData['Gramos']}
          Consumo: ${responseData['Consumo'].toStringAsFixed(2)}
          Gramos: ${responseData['Gramos']}
          KGXHA: ${responseData['KGXHA']}
          LibrasTotal: ${responseData['LibrasTotal']}
          LibrasXHA: ${responseData['LibrasXHA']}
          Error 2%: ${responseData['Error2']}
          AnimalesM: ${responseData['AnimalesM']}
          ''';
        });
      } else {
        setState(() {
          _result = 'Error en la predicción: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _result = 'Error en la predicción: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
        _progress = 1.0; // Completar progreso
      });
    }
  }

  String _selectedHectPisc = '';

  void _onSelect(String category, String item, bool isSelected) {
    setState(() {
      if (category == "finca") {
        _selectedFinca = isSelected ? item : _selectedFinca;
        _loadHectareasPiscinas(_selectedFinca);
      } else if (category == "hectareas") {
        List<String> parts = item.split(" - ");
        if (parts.length == 2) {
          _hectareasController.text = parts[0].replaceAll("Hect: ", "").trim();
          _piscinasController.text =
              parts[1].replaceAll(RegExp(r'[^0-9.]'), '');
          _selectedHectPisc = item; // Almacenar selección exacta
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: 
      Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildMultiSelect(_fincas, _selectedFinca,
                          "Selecciona una finca", "finca"),
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _buildHesctSelect(
                          _hectareasPiscinas,
                          '${_hectareasController.text} - ${_piscinasController.text}',
                          'Seleccione Hectáreas y Piscinas',
                          'hectareas'),
                    ),
                  ),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Ingrese el número de animales',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextField(
                            key: _Naimals,
                            controller: _animalesController,
                            decoration: const InputDecoration(
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
                            keyboardType: TextInputType.number,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
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
                            onPressed: _isLoading
                                ? null
                                : predict, // Deshabilitar botón mientras carga
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0,
                                  horizontal: 24.0), // Tamaño del botón
                            ),
                            child: _isLoading
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        value: _progress,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Color.fromARGB(
                                                    255, 255, 255, 255)),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        'Cargando ${(_progress * 100).toStringAsFixed(0)}%',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          color: Color(0xfff3ece7),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  )
                                : Text(
                                    key: _calcularbuttonAI,
                                    'Realizar Predicción',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Color(0xfff3ece7),
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  if (_result.isNotEmpty) ...[
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildResultField(
                          "Predicción",
                          _result,
                          Icons.check_circle,
                          const Color.fromARGB(255, 11, 91, 74),
                        ),
                      ),
                    ),
                  ] else ...[
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Padding(
                        key: _resultAI,
                        padding: const EdgeInsets.all(16.0),
                        child: _buildResultField(
                          'Sin resultados',
                          'Esperando predicción',
                          Icons.repeat_rounded,
                          Colors.red,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultField(
      String label, String value, IconData icon, Color iconColor) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F4F4),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiSelect(
      List<String> items, String selectedItem, String title, String category) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key: _SelectTerreno,
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
              onSelected: (isSelected) {
                _onSelect(category, item, isSelected);
              },
              selectedColor: const Color.fromARGB(255, 126, 53, 0),
              backgroundColor: const Color(0xfff4f4f4),
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
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

  Widget _buildHesctSelect(
    List<String> itemsHesct,
    String selectedItemHesct,
    String titleHesct,
    String categoryHesct,
  ) {
    int startIndex = _currentPage * _itemsPerPage;
    int endIndex = (_currentPage + 1) * _itemsPerPage;

    // Limita el rango de elementos para mostrar solo 8 por página
    List<T> safeSublist<T>(List<T> list, int start, int end) {
      if (start >= list.length) return [];
      return list.sublist(start, end > list.length ? list.length : end);
    }

    List<String> pagedItems = safeSublist(itemsHesct, startIndex, endIndex);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key: _SelectPiscIA,
          titleHesct,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Wrap(
          spacing: 10.0,
          children: pagedItems.map((itemHesct) {
            final isSelectedHesct = _hectareasController.text.trim() ==
                    itemHesct.split(" - ")[0].replaceAll("Hect: ", "").trim() &&
                _piscinasController.text.trim() ==
                    itemHesct.split(" - ")[1].replaceAll("Pisc: ", "").trim();
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
        const SizedBox(height: 16),
        // Controles de paginación
        SlideTransition(
          position: _controller.drive(
            Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut)),
          ),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 300),
            opacity: 1.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  key: _BeforeDATO,
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
                  key: _AfterDATO,
                  onPressed:
                      (_currentPage + 1) * _itemsPerPage < itemsHesct.length
                          ? _nextPage
                          : null,
                  style: ButtonStyle(
                      backgroundColor:
                          (_currentPage + 1) * _itemsPerPage < itemsHesct.length
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
          ),
        ),
      ],
    );
  }
}
