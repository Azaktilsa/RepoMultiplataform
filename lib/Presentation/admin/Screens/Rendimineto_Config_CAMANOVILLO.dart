// ignore_for_file: library_private_types_in_public_api, unused_local_variable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class RendimientoConfig extends StatefulWidget {
  const RendimientoConfig({super.key});

  @override
  _RendimientoConfigState createState() => _RendimientoConfigState();
}

class _RendimientoConfigState extends State<RendimientoConfig>
    with TickerProviderStateMixin {
  final DatabaseReference _dbRef = FirebaseDatabase.instance
      .ref('Empresas/TerrawaSufalyng/Rendimiento/rows');

  List<Map<String, dynamic>> dataList = [];
  int currentPage = 0;
  final int itemsPerPage = 5;
  late AnimationController _fadeRendimientoController;
  late AnimationController _slideRendimientoController;
  Timer? _timerRendimiento;

  // coach mark
  final GlobalKey Nfilas = GlobalKey();
  final GlobalKey _KeyRendimiento = GlobalKey();
  final GlobalKey _KeyRendimientoGramos = GlobalKey();
  final GlobalKey _KeyAfter = GlobalKey();
  final GlobalKey _KeyBefore = GlobalKey();
  TutorialCoachMark? tutorialCoachMarkRendimiento;

  @override
  void dispose() {
    _fadeRendimientoController.dispose();
    _slideRendimientoController.dispose();
    _timerRendimiento?.cancel();
    // Dispose del TutorialCoachMark
    tutorialCoachMarkRendimiento?.finish();
    super.dispose();
  }

  // Usar una clave específica para cada pantalla
  String get tutorialKey => 'tutorial_mostrado_pantalla_Rendimiento';

  // Verifica si el tutorial ya fue mostrado
  Future<bool> _shouldShowTutorialRendimiento() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(tutorialKey) ?? true;
  }

// Guarda que el tutorial ya se mostró
  Future<void> _setTutorialShownRendimiento() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorialKey, false);
  }

// Restablece el tutorial desde ajustes si el usuario lo quiere repetir
  Future<void> resetTutorialRendimiento() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorialKey, true);
  }

  void showTutorialRendimiento() async {
    if (await _shouldShowTutorialRendimiento()) {
      tutorialCoachMarkRendimiento = TutorialCoachMark(
        targets: _initTargetsRendimiento,
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
          _setTutorialShownRendimiento(); // Guarda que ya se mostró
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

  final List<TargetFocus> _initTargetsRendimiento = [];

  @override
  void initState() {
    super.initState();
    // Inicialización de TutorialCoachMark
    _initTargetsRendimiento.add(
      TargetFocus(
        identify: "Fila",
        keyTarget: Nfilas,
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
                SizedBox(height: 10),
                Text(
                  "Fila",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Esto es el número de fila que hay. ",
                    style: TextStyle(
                      color: Colors.white,
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
    _initTargetsRendimiento.add(
      TargetFocus(
        identify: "Gramos",
        keyTarget: _KeyRendimientoGramos,
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
                SizedBox(height: 10),
                Text(
                  "Gramos",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Aquí puedes ver el peso del camarón en gramos. "
                    "Puedes editar en cualquier momento.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsRendimiento.add(
      TargetFocus(
        identify: "Rendimiento",
        keyTarget: _KeyRendimiento,
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
                SizedBox(height: 10),
                Text(
                  "Rendimiento del camarón",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Aquí puedes ver el rendimiento del camarón en gramos. "
                    "Puedes editar en cualquier momento.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsRendimiento.add(
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
                SizedBox(height: 10),
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
                    "Al dar siguiente puedes ver los demás gramos y Rendimientos. ",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsRendimiento.add(
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
                SizedBox(height: 10),
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
                    "Al dar atrás puedes ver los demás gramos y Rendimientos. ",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // Mostrar el tutorial al iniciar la pantalla
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timerRendimiento = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          showTutorialRendimiento();
        }
      });
    });

    _fetchData();

    // Inicialización de los controladores de animación
    _fadeRendimientoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _fadeRendimientoController.forward();
    _slideRendimientoController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _slideRendimientoController.forward();
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
                'Gramos': value['Gramos'] ?? 0,
                'Rendimiento': value['Rendimiento'] ?? 0,
              };
            }),
          );
        });
      } else if (data is Map) {
        setState(() {
          dataList = data.entries.map((e) {
            return {
              'key': e.key.toString(),
              'Gramos': e.value['Gramos'] ?? 0,
              'Rendimiento': e.value['Rendimiento'] ?? 0,
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

    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

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
                              key: Nfilas,
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
                              key: _KeyRendimientoGramos,
                              'Gramos',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff7e3500),
                              ),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              key: _KeyRendimiento,
                              'Rendimiento',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xff7e3500),
                              ),
                            ),
                          ),
                        ],
                        rows: paginatedData.map((item) {
                          TextEditingController gramosController =
                              TextEditingController(
                                  text: item['Gramos'].toString());
                          TextEditingController rendimientoController =
                              TextEditingController(
                                  text: item['Rendimiento'].toString());

                          return DataRow(cells: [
                            DataCell(Text(item['key'],
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold))),
                            DataCell(TextField(
                                controller: gramosController,
                                keyboardType: TextInputType.number,
                                onSubmitted: (value) =>
                                    _updateData(item['key'], 'Gramos', value),
                                decoration: const InputDecoration.collapsed(
                                    hintText: ''),
                                textAlign: TextAlign.center)),
                            DataCell(TextField(
                                controller: rendimientoController,
                                keyboardType: TextInputType.number,
                                onSubmitted: (value) => _updateData(
                                    item['key'], 'Rendimiento', value),
                                decoration: const InputDecoration.collapsed(
                                    hintText: ''),
                                textAlign: TextAlign.center)),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  SlideTransition(
                    position: _slideRendimientoController.drive(
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
                            key: _KeyAfter,
                            onPressed: currentPage > 0
                                ? () {
                                    setState(() {
                                      currentPage--;
                                      _slideRendimientoController.forward(
                                          from: 0.0);
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
                                style: const TextStyle(fontSize: 16)),
                          ),
                          ElevatedButton(
                            key: _KeyBefore,
                            onPressed: (currentPage + 1) * itemsPerPage <
                                    dataList.length
                                ? () {
                                    setState(() {
                                      currentPage++;
                                      _slideRendimientoController.forward(
                                          from: 0.0);
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
                ],
              ),
      ),
    );
  }
}
