// ignore_for_file: unused_field, library_private_types_in_public_api

import 'dart:async';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:azaktilza/Presentation/admin/Screens/ChatListAdmin.dart';
import 'package:azaktilza/Presentation/admin/Screens/Gestionar_PesosAlimento.dart';
import 'package:azaktilza/Presentation/admin/Screens/Gestionar_Terrenos.dart';
import 'package:azaktilza/Presentation/admin/Screens/Rendimineto_Config_CAMANOVILLO.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/CAMANOVILLO/CAMANOVILLO_Calculate.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/CAMANOVILLO/Resumen_Calculate_CAMANOVILLO.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/EXCANCRIGRU/EXCANCRIGRU_Calculate_Screen.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/EXCANCRIGRU/Resumen_Calculate_EXCANCRIGRU.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/FERTIAGRO/FERTIAGRO_Calculate_Screen.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/FERTIAGRO/Resumen_Calculate_FERTIAGRO.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/GROVITAL/GROVITAL_Calculate_Screen.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/GROVITAL/Resumen_Calculate_GROVITAL.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/SUFAAZA/Resumen_Calculate_SUFAAZA.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/SUFAAZA/SUFAAZA_Calculate_Screen.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/TIERRAVID/Resumen_Calculate_TIERRAVID.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/TIERRAVID/TIERRAVID_Calculate_Screen.dart';
import 'package:azaktilza/Presentation/views/FINCAS/CAMANOVILLO/DatoCAMANOVILLO/Dato_CAMANOVILLO.dart';
import 'package:azaktilza/Presentation/views/FINCAS/CAMANOVILLO/GraficasCAMANOVILLO/GRAFICAS_CAMANOVILLO_Screen.dart';
import 'package:azaktilza/Presentation/views/FINCAS/EXCANCRIGRU/DatoEXCANCRIGRU/DatoEXCANCRIGRU.dart';
import 'package:azaktilza/Presentation/views/FINCAS/EXCANCRIGRU/GraficasEXCANCRIGRU/GRAFICAS_EXCANCRIGRU_Screen.dart';
import 'package:azaktilza/Presentation/views/FINCAS/FERTIAGRO/Dato_FERTIAGRO/DatoFERTIAGRO.dart';
import 'package:azaktilza/Presentation/views/FINCAS/FERTIAGRO/GraficasFERTIAGRO/GRAFICAS_FERTIAGRO_Screen.dart';
import 'package:azaktilza/Presentation/views/FINCAS/GROVITAL/Dato_GROVITAL/DatoGROVITAL.dart';
import 'package:azaktilza/Presentation/views/FINCAS/GROVITAL/GraficasGROVITAL/GRAFICAS_GROVITAL_Screen.dart';
import 'package:azaktilza/Presentation/views/FINCAS/SUFAAZA/Dato_SUFAAZA/DatoSUFAAZA.dart';
import 'package:azaktilza/Presentation/views/FINCAS/SUFAAZA/GraficasSUFAAZA/GRAFICAS_SUFAAZA_Screen.dart';
import 'package:azaktilza/Presentation/views/FINCAS/TIERRAVID/Dato_TIERRAVID/DatoTIERRAVID.dart';
import 'package:azaktilza/Presentation/views/FINCAS/TIERRAVID/GraficasTIERRAVID/GRAFICAS_TIERRAVID_Screen.dart';
import 'package:azaktilza/Presentation/views/MODEL/IAWebViewScreen.dart';
import 'package:azaktilza/Presentation/views/POBLACION/CAMANOVILLO/CAMANOVILLO_Poblacion.dart';
import 'package:azaktilza/Presentation/views/POBLACION/EXCANCRIGRU/EXCANCRIGRU_Poblacion_Screen.dart';
import 'package:azaktilza/Presentation/views/POBLACION/FERTIAGRO/FERTIAGRO_Poblacion_Screen.dart';
import 'package:azaktilza/Presentation/views/POBLACION/GROVITAL/GROVITAL_Poblacion_Screen.dart';
import 'package:azaktilza/Presentation/views/POBLACION/SUFAAZA/SUFAAZA_Poblacion_Screen.dart';
import 'package:azaktilza/Presentation/views/POBLACION/TIERRAVID/TIERRAVID_Poblacion_Screen.dart';
import 'package:azaktilza/Routes/Login.dart';
import 'package:azaktilza/Widgets/DraggableImageWidget.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  Timer? _timerADMIN;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  late DatabaseReference _databaseRef;
  String email = 'correo@ejemplo.com';

  final List<String> imagePaths = [
    'assets/images/logoOscuro1.jpeg',
    'assets/images/logoOscuro2.jpeg',
    'assets/images/logoOscuro3.jpeg',
    'assets/images/logoBlanco1.jpeg',
    'assets/images/logoBlanco2.jpeg',
    'assets/images/logoBlanco3.jpeg',
    'assets/images/logoSemi1.jpeg',
  ];

  String _selectedScreen = 'Azaktilza S.A';
  String _selectedScreenText = 'Azaktilza S.A';

  Offset position = const Offset(100, 100);
  bool _showImageAndLema = true;
  // coach mark
  final GlobalKey _MenuKeyadmin = GlobalKey();
  TutorialCoachMark? tutorialCoachMarkadmin;

  @override
  void dispose() {
    _timerADMIN?.cancel(); // Cancela el timer si está activo
    tutorialCoachMarkadmin?.finish(); // Libera los recursos del coach mark
    super.dispose();
  }

  // Usar una clave específica para cada pantalla
  String get tutorialKey => 'tutorial_mostrado_pantalla_ADMIN';

  // Verifica si el tutorial ya fue mostrado
  Future<bool> _shouldShowTutorialADMIN() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(tutorialKey) ?? true;
  }

// Guarda que el tutorial ya se mostró
  Future<void> _setTutorialShownADMIN() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorialKey, false);
  }

// Restablece el tutorial desde ajustes si el usuario lo quiere repetir
  Future<void> resetTutorialADMIN() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(tutorialKey, true);
  }

  void showTutorialADMIN() async {
    if (await _shouldShowTutorialADMIN()) {
      tutorialCoachMarkadmin = TutorialCoachMark(
        targets: _initTargetsadmin,
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
          _setTutorialShownADMIN(); // Guarda que ya se mostró
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

  final List<TargetFocus> _initTargetsadmin = [];

  @override
  void initState() {
    super.initState();
    _initTargetsadmin.add(
      TargetFocus(
        identify: "Menu",
        keyTarget: _MenuKeyadmin,
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
                  "Menú de opciones",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Selecciona una opción para ver su contenido. "
                    "Puedes cerrar sesión en el menú.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    // Asegurar que el tutorial se inicie después de que el widget esté construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _timerADMIN = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          showTutorialADMIN();
        }
      });
    });

    _databaseRef = FirebaseDatabase.instance
        .ref('Empresas/TerrawaSufalyng/Control/${_auth.currentUser?.uid}');
    _getUserData(); // Llamada para obtener los datos del usuario
  }

  String _randomImagePath() {
    final Random random = Random();
    return imagePaths[random.nextInt(imagePaths.length)];
  }

  Widget _getScreenContent(String screen) {
    String randomImagePath = _randomImagePath();

    switch (screen) {
      // CAMANOVILLO Screens
      case 'Dato_CAMANOVILLO_Screen':
        return const DatoCAMANOVILLO_Screen();
      case 'Poblacion_CAMANOVILLO_Screen':
        return const Poblacion_CAMANOVILLO_Screen();
      case 'Grafica_CAMANOVILLO_Screen':
        return const GRAFICAS_CAMANOVILLO_Screen();
      case 'Calculate_CAMANOVILLO_Screen':
        return const Calculate_CAMANOVILLO_Screen();
      case 'Resumen_CAMANOVILLO_Screen':
        return const Resumen_Calculate_CAMANOVILLO();

      // EXCANCRIGRU Screens
      case 'Dato_EXCANCRIGRU_Screen':
        return const DatoEXCANCRIGRU_Screen();
      case 'Poblacion_EXCANCRIGRU_Screen':
        return const Poblacion_EXCANCRIGRU_Screen();
      case 'Grafica_EXCANCRIGRU_Screen':
        return const GRAFICAS_EXCANCRIGRU_Screen();
      case 'Calculate_EXCANCRIGRU_Screen':
        return const Calculate_EXCANCRIGRU_Screen();
      case 'Resumen_EXCANCRIGRU_Screen':
        return const Resumen_Calculate_EXCANCRIGRU();

      // FERTIAGRO Screens
      case 'Dato_FERTIAGRO_Screen':
        return const DatoFERTIAGRO_Screen();
      case 'Poblacion_FERTIAGRO_Screen':
        return const Poblacion_FERTIAGRO_Screen();
      case 'Grafica_FERTIAGRO_Screen':
        return const GRAFICAS_FERTIAGRO_Screen();
      case 'Calculate_FERTIAGRO_Screen':
        return const Calculate_FERTIAGRO_Screen();
      case 'Resumen_FERTIAGRO_Screen':
        return const Resumen_Calculate_FERTIAGRO();

      // GROVITAL Screens
      case 'Dato_GROVITAL_Screen':
        return const DatoGROVITAL_Screen();
      case 'Poblacion_GROVITAL_Screen':
        return const Poblacion_GROVITAL_Screen();
      case 'Grafica_GROVITAL_Screen':
        return const GRAFICAS_GROVITAL_Screen();
      case 'Calculate_GROVITAL_Screen':
        return const Calculate_GROVITAL_Screen();
      case 'Resumen_GROVITAL_Screen':
        return const Resumen_Calculate_GROVITAL();

      // SUFAAZA Screens
      case 'Dato_SUFAAZA_Screen':
        return const DatoSUFAAZA_Screen();
      case 'Poblacion_SUFAAZA_Screen':
        return const Poblacion_SUFAAZA_Screen();
      case 'Grafica_SUFAAZA_Screen':
        return const GRAFICAS_SUFAAZA_Screen();
      case 'Calculate_SUFAAZA_Screen':
        return const Calculate_SUFAAZA_Screen();
      case 'Resumen_SUFAAZA_Screen':
        return const Resumen_Calculate_SUFAAZA();

      // TIERRAVID Screens
      case 'Dato_TIERRAVID_Screen':
        return const DatoTIERRAVID_Screen();
      case 'Poblacion_TIERRAVID_Screen':
        return const Poblacion_TIERRAVID_Screen();
      case 'Grafica_TIERRAVID_Screen':
        return const GRAFICAS_TIERRAVID_Screen();
      case 'Calculate_TIERRAVID_Screen':
        return const Calculate_TIERRAVID_Screen();
      case 'Resumen_TIERRAVID_Screen':
        return const Resumen_Calculate_TIERRAVID();

      // Other Screens
      case 'Rendimineto_Config':
        return const RendimientoConfig();
      case 'Chat_List_Admin':
        return const ChatListAdmin();
      case 'Terrawa_AI':
        return const IAWebViewScreen();
      case 'Gestionar_Terrenos':
        return const Gestionar_Terrenos();
      case 'Gestionar_PesosAlimento':
        return const Gestionar_PesosAlimento();
      // Default case
      default:
        return Center(
          child: DraggableImageWidget(
            showImageAndLema: _showImageAndLema,
            imagePath: randomImagePath,
          ),
        );
    }
  }

  void _onMenuTap(String screen, String text) {
    setState(() {
      _selectedScreen = screen;
      _selectedScreenText = text;
      _showImageAndLema =
          false; // Ocultar imagen y lema al seleccionar una opción
    });
    Navigator.of(context).pop(); // Cerrar el drawer
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Redirigir al LoginScreen después de cerrar sesión
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      // Manejo de errores, mostrar un mensaje si hay un problema al cerrar sesión
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: ${e.toString()}')),
      );
    }
  }

  Future<void> _getUserData() async {
    if (user != null) {
      // Obtener el UID del usuario autenticado
      String uid = user!.uid;

      // Referencia a la base de datos
      DatabaseReference userRef = FirebaseDatabase.instance
          .ref()
          .child('Empresas/TerrawaSufalyng/Control/')
          .child(uid);

      try {
        // Obtener los datos del usuario desde la base de datos
        DatabaseEvent event = await userRef.once();

        if (event.snapshot.exists) {
          // Extraer los datos
          final data = event.snapshot.value as Map<dynamic, dynamic>?;

          if (data != null) {
            setState(() {
              email = data['email'] ?? 'correo@ejemplo.com';
            });
          }
        } else {
          print('Usuario no encontrado en la base de datos.');
        }
      } catch (e) {
        print('Error al obtener los datos del usuario: $e');
      }
    }
  }

  // Método para mostrar el menú de opciones
  List<Map<String, String>> opciones = [
    {
      'titulo': 'Por Dato',
      'ruta': 'Dato_CAMANOVILLO_Screen',
      'subtitulo': 'CAMANOVILLO - Datos'
    },
    {
      'titulo': 'Por Población',
      'ruta': 'Poblacion_CAMANOVILLO_Screen',
      'subtitulo': 'CAMANOVILLO - Población'
    },
    {
      'titulo': 'Gráfica',
      'ruta': 'Grafica_CAMANOVILLO_Screen',
      'subtitulo': 'CAMANOVILLO - Gráfica'
    },
    {
      'titulo': 'Alimentación',
      'ruta': 'Resumen_CAMANOVILLO_Screen',
      'subtitulo': 'CAMANOVILLO - Alimentación'
    },
  ];

  List<Widget> buildOpciones() {
    return opciones.map((opcion) {
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xfff3ece7),
            borderRadius: BorderRadius.circular(25),
            border: const Border(
              bottom: BorderSide(
                color: Color.fromARGB(255, 126, 53, 0),
                width: 1.0,
              ),
            ),
          ),
          child: ListTile(
            title: Text(
              opcion['titulo']!,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            onTap: () => _onMenuTap(opcion['ruta']!, opcion['subtitulo']!),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          ),
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    String randomImagePath = _randomImagePath();

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
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  key: _MenuKeyadmin,
                  icon: const Icon(
                    Icons.menu,
                    color: Color(0xfff3ece7),
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                );
              },
            ),
            title: Text(
              _selectedScreenText,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xfff3ece7),
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xfff3ece7),
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                  UserAccountsDrawerHeader(
                    accountName: const Text(
                      "Azaktilza S.A",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFF4F4F4),
                      ),
                    ),
                    accountEmail: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          email,
                          style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFF4F4F4),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(right: 10.0),
                          child: Text(
                            "Admin",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFF4F4F4),
                            ),
                          ),
                        ),
                      ],
                    ),
                    currentAccountPicture: Material(
                      elevation: 5,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.hardEdge,
                      child: CircleAvatar(
                        backgroundImage: AssetImage(randomImagePath),
                        radius: 30,
                      ),
                    ),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 126, 53, 0),
                    ),
                  ),
                  ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 8.0),
                    childrenPadding:
                        const EdgeInsets.symmetric(horizontal: 8.0),
                    iconColor: const Color.fromARGB(255, 176, 74, 11),
                    collapsedIconColor: const Color.fromARGB(255, 126, 53, 0),
                    title: const Padding(
                      padding: EdgeInsets.all(2.0),
                      child: Text(
                        'Fincas',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          iconColor: const Color.fromARGB(255, 176, 74, 11),
                          collapsedIconColor:
                              const Color.fromARGB(255, 126, 53, 0),
                          title: const Text(
                            'CAMANOVILLO',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: buildOpciones(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          iconColor: const Color.fromARGB(255, 176, 74, 11),
                          collapsedIconColor:
                              const Color.fromARGB(255, 126, 53, 0),
                          title: const Text(
                            'EXCANCRIGRU',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: [
                            for (var item in [
                              {
                                'title': 'Por Dato',
                                'screen': 'Dato_EXCANCRIGRU_Screen',
                                'subtitle': 'EXCANCRIGRU - Datos'
                              },
                              {
                                'title': 'Por Población',
                                'screen': 'Poblacion_EXCANCRIGRU_Screen',
                                'subtitle': 'EXCANCRIGRU - Población'
                              },
                              {
                                'title': 'Gráfica',
                                'screen': 'Grafica_EXCANCRIGRU_Screen',
                                'subtitle': 'EXCANCRIGRU - Gráfica'
                              },
                              {
                                'title': 'Alimentación',
                                'screen': 'Resumen_EXCANCRIGRU_Screen',
                                'subtitle': 'EXCANCRIGRU - Alimentación'
                              }
                            ])
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xfff3ece7),
                                    borderRadius: BorderRadius.circular(25),
                                    border: const Border(
                                      bottom: BorderSide(
                                        color:
                                            Color.fromARGB(255, 199, 189, 186),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      item['title']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onTap: () => _onMenuTap(
                                        item['screen']!, item['subtitle']!),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          iconColor: const Color.fromARGB(255, 176, 74, 11),
                          collapsedIconColor:
                              const Color.fromARGB(255, 126, 53, 0),
                          title: const Text(
                            'FERTIAGRO',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: [
                            for (var item in [
                              {
                                'title': 'Por Dato',
                                'route': 'Dato_FERTIAGRO_Screen',
                                'label': 'FERTIAGRO - Datos'
                              },
                              {
                                'title': 'Por Población',
                                'route': 'Poblacion_FERTIAGRO_Screen',
                                'label': 'FERTIAGRO - Población'
                              },
                              {
                                'title': 'Gráfica',
                                'route': 'Grafica_FERTIAGRO_Screen',
                                'label': 'FERTIAGRO - Gráfica'
                              },
                              {
                                'title': 'Alimentación',
                                'route': 'Resumen_FERTIAGRO_Screen',
                                'label': 'FERTIAGRO - Alimentación'
                              },
                            ])
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(
                                        0xfff3ece7), // Color de fondo
                                    borderRadius: BorderRadius.circular(
                                        25), // Borde redondeado
                                    border: const Border(
                                      bottom: BorderSide(
                                        color:
                                            Color.fromARGB(255, 163, 172, 173),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      item['title']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onTap: () => _onMenuTap(
                                        item['route']!, item['label']!),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          iconColor: const Color.fromARGB(255, 176, 74, 11),
                          collapsedIconColor:
                              const Color.fromARGB(255, 126, 53, 0),
                          title: const Text(
                            'GROVITAL',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: [
                            for (var item in [
                              {
                                'title': 'Por Dato',
                                'route': 'Dato_GROVITAL_Screen',
                                'label': 'GROVITAL - Datos'
                              },
                              {
                                'title': 'Por Población',
                                'route': 'Poblacion_GROVITAL_Screen',
                                'label': 'GROVITAL - Población'
                              },
                              {
                                'title': 'Gráfica',
                                'route': 'Grafica_GROVITAL_Screen',
                                'label': 'GROVITAL - Gráfica'
                              },
                              {
                                'title': 'Alimentación',
                                'route': 'Resumen_GROVITAL_Screen',
                                'label': 'GROVITAL - Alimentación'
                              },
                            ])
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xfff3ece7),
                                    borderRadius: BorderRadius.circular(25),
                                    border: const Border(
                                      bottom: BorderSide(
                                        color:
                                            Color.fromARGB(149, 147, 147, 147),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      item['title']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onTap: () => _onMenuTap(
                                        item['route']!, item['label']!),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          iconColor: const Color.fromARGB(255, 176, 74, 11),
                          collapsedIconColor:
                              const Color.fromARGB(255, 126, 53, 0),
                          title: const Text(
                            'SUFAAZA',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: [
                            ...[
                              {
                                'title': 'Por Dato',
                                'screen': 'Dato_SUFAAZA_Screen',
                                'subtitle': 'SUFAAZA - Datos'
                              },
                              {
                                'title': 'Por Población',
                                'screen': 'Poblacion_SUFAAZA_Screen',
                                'subtitle': 'SUFAAZA - Población'
                              },
                              {
                                'title': 'Gráfica',
                                'screen': 'Grafica_SUFAAZA_Screen',
                                'subtitle': 'SUFAAZA - Gráfica'
                              },
                              {
                                'title': 'Alimentación',
                                'screen': 'Resumen_SUFAAZA_Screen',
                                'subtitle': 'SUFAAZA - Alimentación'
                              },
                            ].map((item) => Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xfff3ece7),
                                      borderRadius: BorderRadius.circular(25),
                                      border: const Border(
                                        bottom: BorderSide(
                                          color: Color.fromARGB(
                                              255, 196, 184, 184),
                                          width: 1.0,
                                        ),
                                      ),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        item['title']!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onTap: () => _onMenuTap(
                                          item['screen']!, item['subtitle']!),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16.0),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ExpansionTile(
                          iconColor: const Color.fromARGB(255, 176, 74, 11),
                          collapsedIconColor:
                              const Color.fromARGB(255, 126, 53, 0),
                          title: const Text(
                            'TIERRAVID',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          children: [
                            ...[
                              {
                                'title': 'Por Dato',
                                'route': 'Dato_TIERRAVID_Screen',
                                'subtitle': 'TIERRAVID - Datos'
                              },
                              {
                                'title': 'Por Población',
                                'route': 'Poblacion_TIERRAVID_Screen',
                                'subtitle': 'TIERRAVID - Población'
                              },
                              {
                                'title': 'Gráfica',
                                'route': 'Grafica_TIERRAVID_Screen',
                                'subtitle': 'TIERRAVID - Gráfica'
                              },
                              {
                                'title': 'Alimentación',
                                'route': 'Resumen_TIERRAVID_Screen',
                                'subtitle': 'TIERRAVID - Alimentación'
                              },
                            ].map(
                              (item) => Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xfff3ece7),
                                    borderRadius: BorderRadius.circular(25),
                                    border: const Border(
                                      bottom: BorderSide(
                                        color:
                                            Color.fromARGB(255, 181, 175, 168),
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: ListTile(
                                    title: Text(
                                      item['title']!,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    onTap: () => _onMenuTap(
                                        item['route']!, item['subtitle']!),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(
                    thickness: 1,
                    height: 1,
                    color: Color.fromARGB(38, 0, 0, 0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gestionar Pesos Alimento',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.balance_rounded,
                            color: Color.fromARGB(255, 176, 74, 11),
                          ),
                        ],
                      ),
                      onTap: () => _onMenuTap('Gestionar_PesosAlimento',
                          'Gestionar Pesos Alimento'),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 1,
                    color: Color.fromARGB(38, 0, 0, 0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gestionar Terrenos',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.agriculture_rounded,
                            color: Color.fromARGB(255, 176, 74, 11),
                          ),
                        ],
                      ),
                      onTap: () => _onMenuTap(
                          'Gestionar_Terrenos', 'Gestionar Terrenos'),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 1,
                    color: Color.fromARGB(38, 0, 0, 0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Gestionar Rendimiento',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.assessment_outlined,
                            color: Color.fromARGB(255, 176, 74, 11),
                          ),
                        ],
                      ),
                      onTap: () => _onMenuTap(
                          'Rendimineto_Config', 'Gestionar Rendimiento'),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 1,
                    color: Color.fromARGB(38, 0, 0, 0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Chat',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.message_rounded,
                            color: Color.fromARGB(255, 176, 74, 11),
                          ),
                        ],
                      ),
                      onTap: () =>
                          _onMenuTap('Chat_List_Admin', 'Gestionar Usuario'),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 1,
                    color: Color.fromARGB(38, 0, 0, 0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: ListTile(
                      title: const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Por Animal AI',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Icon(
                            Icons.smart_toy_rounded,
                            color: Color.fromARGB(255, 176, 74, 11),
                          ),
                        ],
                      ),
                      onTap: () => _onMenuTap('Terrawa_AI', 'Por Animal AI'),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                  ),
                  const Divider(
                    thickness: 1,
                    height: 1,
                    color: Color.fromARGB(38, 0, 0, 0),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(40.0),
                        ),
                      ),
                      child: ListTile(
                        title: const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Cerrar Sesión',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              Icons.logout,
                              color: Color.fromARGB(255, 176, 74, 11),
                            ),
                          ],
                        ),
                        onTap: () {
                          _logout(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(child: _getScreenContent(_selectedScreen)),
        ],
      ),
    );
  }
}
