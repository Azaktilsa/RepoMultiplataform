// ignore_for_file: unnecessary_cast, library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class Gestionar_Terrenos extends StatefulWidget {
  const Gestionar_Terrenos({super.key});

  @override
  _Gestionar_TerrenosState createState() => _Gestionar_TerrenosState();
}

class _Gestionar_TerrenosState extends State<Gestionar_Terrenos>
    with TickerProviderStateMixin {
  final DatabaseReference _dbRef =
      FirebaseDatabase.instance.ref('Empresas/TerrawaSufalyng/Terrain/');

  final List<String> _fincas = [
    "CAMANOVILLO",
    "EXCANCRIGRU",
    "FERTIAGRO",
    "GROVITAL",
    "SUFAAZA",
    "TIERRAVID",
  ];
  String _selectedFinca = "CAMANOVILLO";
  List<Map<String, dynamic>> _dataList = [];
  int currentPage = 0;
  final int itemsPerPage = 5;

  late AnimationController _fadeController;
  late AnimationController _slideController;

  // coach mark
  Timer? _timerTerrenos;
  final GlobalKey _KeyTerrenos = GlobalKey();
  final GlobalKey _Keyhectareas = GlobalKey();
  final GlobalKey _Keypiscinas = GlobalKey();
  final GlobalKey _KeyNumber = GlobalKey();
  final GlobalKey _KeyAfter = GlobalKey();
  final GlobalKey _KeyBefore = GlobalKey();
  TutorialCoachMark? tutorialCoachMarkTerrenos;

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _timerTerrenos?.cancel();
    tutorialCoachMarkTerrenos?.finish();
    super.dispose();
  }

  String get tutorialKeyTerrenoslimento => "Gestionar_Terrenos";

  // Verifica si el tutorial ya fue mostrado
  Future<bool> _shouldShowTutorialTerrenos() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(tutorialKeyTerrenoslimento) ??
        true; // Si no existe, se muestra
  }

  // Guarda que el tutorial ya se mostró
  Future<void> _setTutorialShownTerrenos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorialKeyTerrenoslimento, false);
  }

// Restablece el tutorial desde ajustes si el usuario lo quiere repetir
  Future<void> resetTutorialTerrenos() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorialKeyTerrenoslimento, true);
  }

  void showTutorialTerrenos() async {
    if (await _shouldShowTutorialTerrenos()) {
      tutorialCoachMarkTerrenos = TutorialCoachMark(
        targets: _initTargetsTerrenos,
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
          _setTutorialShownTerrenos(); // Guarda que ya se mostró
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

  final List<TargetFocus> _initTargetsTerrenos = [];

  @override
  void initState() {
    super.initState();
    _initTargetsTerrenos.add(
      TargetFocus(
        identify: "Terrenos Select",
        keyTarget: _KeyTerrenos,
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
                  "Selecciona una finca",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Selecciona la finca que deseas gestionar. "
                    "Puedes elegir entre varias opciones.",
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
    _initTargetsTerrenos.add(
      TargetFocus(
        identify: "Numberdata",
        keyTarget: _KeyNumber,
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
                  "Número de fila",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Aquí puedes ver el número de fila "
                    "de la finca seleccionada.",
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
    _initTargetsTerrenos.add(
      TargetFocus(
        identify: "Hectareas",
        keyTarget: _Keyhectareas,
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
                  "Hectáreas",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Aquí puedes ver la cantidad de hectáreas "
                  "que tiene la finca seleccionada. "
                  "Puedes editar la cantidad de hectáreas "
                  "si lo deseas.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsTerrenos.add(
      TargetFocus(
        identify: "Piscinas",
        keyTarget: _Keypiscinas,
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
                  "Piscinas",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Aquí puedes ver la cantidad de piscinas "
                  "que tiene la finca seleccionada. "
                  "Puedes editar la cantidad de piscinas "
                  "si lo deseas.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsTerrenos.add(
      TargetFocus(
        identify: "Before",
        keyTarget: _KeyBefore,
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
                    "Aquí puedes ver la cantidad de hectáreas "
                    "que tiene la finca seleccionada.",
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
    _initTargetsTerrenos.add(
      TargetFocus(
        identify: "After",
        keyTarget: _KeyAfter,
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
                    "Aquí puedes ver la cantidad de hectáreas "
                    "que tiene la finca seleccionada.",
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
      _timerTerrenos = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          showTutorialTerrenos();
        }
      });
    });

    _fetchFincaData(_selectedFinca);

    // Initialize the fade and slide animations
    _fadeController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _fadeController.forward();

    _slideController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _slideController.forward();
  }

  void _fetchFincaData(String finca) {
    _dbRef.child(finca).child("rows").onValue.listen((event) {
      final data = event.snapshot.value;

      if (data != null) {
        List<Map<String, dynamic>> tempList = [];

        if (data is Map) {
          (data as Map<dynamic, dynamic>).forEach((key, value) {
            tempList.add({
              "Hectareas": value["Hectareas"]?.toString() ?? "0",
              "Piscinas": value["Piscinas"]?.toString() ?? "0",
            });
          });
        } else if (data is List) {
          for (var item in data) {
            if (item is Map) {
              tempList.add({
                "Hectareas": item["Hectareas"]?.toString() ?? "0",
                "Piscinas": item["Piscinas"]?.toString() ?? "0",
              });
            }
          }
        }

        setState(() {
          _dataList = tempList;
          currentPage = 0;
        });
      }
    });
  }

  void _onSelectFinca(String finca) {
    setState(() {
      _selectedFinca = finca;
    });
    _fetchFincaData(finca);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildMultiSelect(_fincas, _selectedFinca, "Selecciona una finca"),
            const SizedBox(height: 20),
            FadeTransition(
              opacity: _fadeController,
              child: _buildDataTable(),
            ),
            const SizedBox(height: 20),
            SlideTransition(
              position: _slideController.drive(
                Tween<Offset>(
                  begin: const Offset(0, 1),
                  end: Offset.zero,
                ).chain(CurveTween(curve: Curves.easeInOut)),
              ),
              child: _buildPaginationControls(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMultiSelect(
      List<String> items, String selectedItem, String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          key: _KeyTerrenos,
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Wrap(
          spacing: 10.0,
          children: items.map((item) {
            final isSelected = selectedItem == item;
            return FilterChip(
              label: Text(
                item,
                style:
                    TextStyle(color: isSelected ? Colors.white : Colors.black),
              ),
              selected: isSelected,
              onSelected: (isSelected) {
                if (isSelected) _onSelectFinca(item);
              },
              selectedColor: const Color.fromARGB(255, 126, 53, 0),
              backgroundColor: const Color(0xfff4f4f4),
              checkmarkColor: Colors.white,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDataTable() {
    List<Map<String, dynamic>> paginatedData =
        _dataList.skip(currentPage * itemsPerPage).take(itemsPerPage).toList();

    return DataTable(
      rows: paginatedData
          .asMap()
          .map((index, item) => MapEntry(
                index,
                DataRow(cells: [
                  DataCell(Text((index + 1).toString(),
                      style: const TextStyle(fontSize: 16))),
                  DataCell(Text(item["Hectareas"],
                      style: const TextStyle(fontSize: 16))),
                  DataCell(Text(item["Piscinas"],
                      style: const TextStyle(fontSize: 16))),
                ]),
              ))
          .values
          .toList(),
      columns: [
        DataColumn(
          label: Text(
            key: _KeyNumber,
            'No.',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff7e3500)),
          ),
        ),
        DataColumn(
          label: Text(
            key: _Keyhectareas,
            'Hectáreas',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff7e3500)),
          ),
        ),
        DataColumn(
          label: Text(
            key: _Keypiscinas,
            'Piscinas',
            style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xff7e3500)),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationControls() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 300),
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
                    });
                  }
                : null,
            style: ButtonStyle(
              backgroundColor: currentPage > 0
                  ? WidgetStateProperty.all<Color>(
                      const Color.fromARGB(255, 126, 53, 0))
                  : null,
            ),
            child: const Text(
              'Atrás',
              style: TextStyle(color: Color(0xfff3ece7)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${currentPage + 1} de ${((_dataList.length + itemsPerPage - 1) / itemsPerPage).ceil()}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          ElevatedButton(
            key: _KeyAfter,
            onPressed: (currentPage + 1) * itemsPerPage < _dataList.length
                ? () {
                    setState(() {
                      currentPage++;
                    });
                  }
                : null,
            style: ButtonStyle(
              backgroundColor:
                  (currentPage + 1) * itemsPerPage < _dataList.length
                      ? WidgetStateProperty.all<Color>(
                          const Color.fromARGB(255, 126, 53, 0))
                      : null,
            ),
            child: const Text(
              'Siguiente',
              style: TextStyle(color: Color(0xfff3ece7)),
            ),
          ),
        ],
      ),
    );
  }
}
