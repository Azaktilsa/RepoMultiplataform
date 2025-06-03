// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers, use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Gestionar_PesosAlimento extends StatefulWidget {
  const Gestionar_PesosAlimento({super.key});

  @override
  _Gestionar_PesosAlimentoState createState() =>
      _Gestionar_PesosAlimentoState();
}

class _Gestionar_PesosAlimentoState extends State<Gestionar_PesosAlimento>
    with TickerProviderStateMixin {
  Timer? _timerPESOSA;
  final DatabaseReference _dbRef = FirebaseDatabase.instance
      .ref('Empresas/TerrawaSufalyng/PesosAlimento/rows');

  List<Map<String, dynamic>> dataList = [];
  int currentPage = 0;
  final int itemsPerPage = 5;
  late AnimationController _fadeController;
  late AnimationController _slideControllerPesosA;

  // coach mark
  final GlobalKey _KeyNpesos = GlobalKey();
  final GlobalKey _KeyPESOSA = GlobalKey();
  final GlobalKey _KeyBWCosechas = GlobalKey();
  final GlobalKey _KeyAfter = GlobalKey();
  final GlobalKey _KeyBefore = GlobalKey();
  TutorialCoachMark? tutorialCoachMarkPESOSA;

  @override
  void dispose() {
    _fadeController.dispose();
    _slideControllerPesosA.dispose();
    _timerPESOSA?.cancel();
    tutorialCoachMarkPESOSA?.finish();
    super.dispose();
  }

  String get tutorialKeyPesosAlimento => "PesosAlimento";

  // Verifica si el tutorial ya fue mostrado
  Future<bool> _shouldShowTutorialPESOSA() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(tutorialKeyPesosAlimento) ??
        true; // Si no existe, se muestra
  }

  // Guarda que el tutorial ya se mostró
  Future<void> _setTutorialShownPESOSA() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorialKeyPesosAlimento, false);
  }

// Restablece el tutorial desde ajustes si el usuario lo quiere repetir
  Future<void> resetTutorialPESOSA() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorialKeyPesosAlimento, true);
  }

  void showTutorialPESOSA() async {
    if (await _shouldShowTutorialPESOSA()) {
      tutorialCoachMarkPESOSA = TutorialCoachMark(
        targets: _initTargetsPESOSA,
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
          _setTutorialShownPESOSA(); // Guarda que ya se mostró
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

  final List<TargetFocus> _initTargetsPESOSA = [];

  @override
  void initState() {
    super.initState();
    // Inicializa el tutorial
    _initTargetsPESOSA.add(
      TargetFocus(
        identify: "Numero Pesos Alimento",
        keyTarget: _KeyNpesos,
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
                SizedBox(height: 20),
                Text(
                  "Número de pesos del alimento",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Aquí se muestra el número de pesos del alimento. "
                    "Puedes ver cuántos pesos se han registrado hasta ahora.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsPESOSA.add(
      TargetFocus(
        identify: "Pesos Alimento",
        keyTarget: _KeyPESOSA,
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
                SizedBox(height: 20),
                Text(
                  "Pesos proporcionados por el biólogo",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "En esta sección puedes gestionar los pesos del camarón. "
                    "Simplemente ingresa los valores proporcionados por el biólogo.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsPESOSA.add(
      TargetFocus(
        identify: "BWCosechas",
        keyTarget: _KeyBWCosechas,
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
                SizedBox(height: 20),
                Text(
                  "Sección BWCosechas",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Aquí podrás gestionar los pesos de BWCosechas. "
                    "Solo tienes que ingresar los pesos de la Cosecha que se ha proporcionado por el biólogo.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsPESOSA.add(
      TargetFocus(
        identify: "Before",
        keyTarget: _KeyBefore,
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
                SizedBox(height: 20),
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
                    "Puedes retroceder a la página anterior para ver las filas anteriores. "
                    "Recuerda que puedes editar los valores de cada fila.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsPESOSA.add(
      TargetFocus(
        identify: "After",
        keyTarget: _KeyAfter,
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
                SizedBox(height: 20),
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
                    "Puedes avanzar a la siguiente página para ver más filas. "
                    "Recuerda que puedes editar los valores de cada fila.",
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
      _timerPESOSA = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          showTutorialPESOSA();
        }
      });
    });
    _fetchData();

    // Inicialización de los controladores de animación
    _fadeController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeController.forward();
    _slideControllerPesosA = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _slideControllerPesosA.forward();
  }

  void _fetchData() {
    _dbRef.onValue.listen((DatabaseEvent event) {
      final dynamic data = event.snapshot.value;

      if (data is List) {
        setState(() {
          dataList = List<Map<String, dynamic>>.from(
            data.asMap().entries.map((entry) {
              final index = entry.key.toString();
              final value = entry.value as Map<dynamic, dynamic>? ?? {};
              return {
                'key': index,
                'Pesos': value['Pesos'] ?? 0,
                'BWCosechas': value['BWCosechas'] ?? 0,
              };
            }),
          );
        });
      } else if (data is Map) {
        setState(() {
          dataList = data.entries.map((e) {
            return {
              'key': e.key.toString(),
              'Pesos': e.value['Pesos'] ?? 0,
              'BWCosechas': e.value['BWCosechas'] ?? 0,
            };
          }).toList();
        });
      }
    });
  }

  void _updateData(String rowKey, String field, String value) {
    _dbRef.child(rowKey).update({field: value}).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$field en fila $rowKey actualizado')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar $field en fila $rowKey')),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> paginatedData =
        dataList.skip(currentPage * itemsPerPage).take(itemsPerPage).toList();
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: dataList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  const SizedBox(height: 2),
                  Expanded(
                    child: SingleChildScrollView(
                      child: DataTable(
                        columns: [
                          DataColumn(
                            label: Text(
                              key: _KeyNpesos,
                              'Fila',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff7e3500),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              key: _KeyPESOSA,
                              'Pesos',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff7e3500),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              key: _KeyBWCosechas,
                              'BWCosechas',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff7e3500),
                              ),
                            ),
                          ),
                        ],
                        rows: paginatedData.map((item) {
                          String _formatNumber(dynamic value) {
                            if (value == null) return "0.00";
                            String cleanValue = value.toString().replaceAll(
                                RegExp(r'[^0-9.]'),
                                ''); // Elimina caracteres no numéricos excepto "."
                            double? number = double.tryParse(cleanValue);
                            return (number ?? 0.0).toStringAsFixed(2);
                          }

                          TextEditingController PesosController =
                              TextEditingController(
                            text: _formatNumber(item['Pesos']),
                          );
                          TextEditingController BWCosechasController =
                              TextEditingController(
                            text: _formatNumber(item['BWCosechas']),
                          );

                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  item['key'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataCell(
                                TextField(
                                  controller: PesosController,
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    if (value.isNotEmpty) {
                                      _updateData(item['key'], 'Pesos', value);
                                    }
                                  },
                                  decoration: const InputDecoration.collapsed(
                                      hintText: ''),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              DataCell(
                                TextField(
                                    controller: BWCosechasController,
                                    keyboardType: TextInputType.number,
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        _updateData(
                                            item['key'], 'BWCosechas', value);
                                      }
                                    },
                                    decoration: const InputDecoration.collapsed(
                                        hintText: ''),
                                    textAlign: TextAlign.center),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  SlideTransition(
                    position: _slideControllerPesosA.drive(
                      Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).chain(CurveTween(curve: Curves.easeInOut)),
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 500),
                      opacity: 1.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            key: _KeyBefore,
                            onPressed: currentPage > 0
                                ? () {
                                    setState(() {
                                      currentPage--;
                                      _slideControllerPesosA.forward(from: 0.0);
                                    });
                                  }
                                : null,
                            style: ButtonStyle(
                                backgroundColor: currentPage > 0
                                    ? WidgetStateProperty.all<Color>(
                                        const Color.fromARGB(255, 126, 53, 0))
                                    : null),
                            child: const Text(
                              'Atrás',
                              style: TextStyle(
                                color: Color(0xfff3ece7),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text(
                              '${currentPage + 1} de ${((dataList.length + 1) / itemsPerPage).ceil()}',
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            key: _KeyAfter,
                            onPressed: (currentPage + 1) * itemsPerPage <
                                    dataList.length
                                ? () {
                                    setState(() {
                                      currentPage++;
                                      _slideControllerPesosA.forward(from: 0.0);
                                    });
                                  }
                                : null,
                            style: ButtonStyle(
                                backgroundColor: (currentPage + 1) *
                                            itemsPerPage <
                                        dataList.length
                                    ? WidgetStateProperty.all<Color>(
                                        const Color.fromARGB(255, 126, 53, 0))
                                    : null),
                            child: const Text(
                              'Siguiente',
                              style: TextStyle(
                                color: Color(0xfff3ece7),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Aquí podrías agregar un AnimatedContainer si necesitas algún cambio visual de estado.
                ],
              ),
      ),
    );
  }
}
