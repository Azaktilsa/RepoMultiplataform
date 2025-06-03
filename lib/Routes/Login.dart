// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:azaktilza/env_loader.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:azaktilza/Presentation/client/client_screen.dart';
import 'package:azaktilza/Presentation/admin/admin_screen.dart';
//import 'package:azaktilza/views/ROUTER/RegisterAdmin.dart';
import 'package:azaktilza/Routes/RegisterClient.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Timer? _timerLOGIN;
  late final DatabaseReference _dbRef;
  late String _basePath;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String errorMessage = '';

  // coach mark
  final GlobalKey _emailKeyLOGIN = GlobalKey();
  final GlobalKey _passwordKeyLOGIN = GlobalKey();
  final GlobalKey _loginButtonKeyLOGIN = GlobalKey();
  TutorialCoachMark? tutorialCoachMarkLOGIN;

  @override
  void dispose() {
    _timerLOGIN?.cancel(); // Cancela el timer si está activo
    super.dispose();
  }

  // Verifica si el tutorial ya fue mostrado
  Future<bool> _shouldShowTutorialLOGIN() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('tutorial_mostrado') ??
        true; // Si no existe, se muestra
  }

  // Guarda que el tutorial ya se mostró
  Future<void> _setTutorialShownLOGIN() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_mostrado', false);
  }

  // Restablece el tutorial desde ajustes si el usuario lo quiere repetir
  Future<void> resetTutorialLOGIN() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('tutorial_mostrado', true);
  }

  void showTutorialLOGIN() async {
    if (await _shouldShowTutorialLOGIN()) {
      tutorialCoachMarkLOGIN = TutorialCoachMark(
        targets: _initTargetsLOGIN,
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
          _setTutorialShownLOGIN(); // Guarda que ya se mostró
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

  final List<TargetFocus> _initTargetsLOGIN = [];

  @override
  void initState() {
    super.initState();
    _dbRef = FirebaseDatabase.instance.ref();

    // 1. Detectar plataforma
    if (kIsWeb) {
      // 2. Configuración para WEB
      _basePath = EnvLoader.get('CONTROL')!;
    } else {
      // 3. Configuración para MÓVIL
      _basePath = dotenv.env['CONTROL']!;
    }

    _initTargetsLOGIN.add(
      TargetFocus(
        identify: "Email",
        keyTarget: _emailKeyLOGIN,
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
                SizedBox(height: 90),
                Text(
                  "Introduce tu correo electrónico",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Por favor, ingresa tu dirección de correo electrónico para continuar. "
                    "Nos aseguraremos de mantener tu información segura y solo la usaremos para proporcionarte acceso a tu cuenta.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsLOGIN.add(
      TargetFocus(
        identify: "Password",
        keyTarget: _passwordKeyLOGIN,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 90),
                Text(
                  "Aquí introduces tu contraseña.",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Por favor, ingresa tu contraseña para continuar. "
                    "Si no recuerdas tu contraseña, puedes restablecerla presionando el botón de abajo.",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    _initTargetsLOGIN.add(
      TargetFocus(
        identify: "Login Button",
        keyTarget: _loginButtonKeyLOGIN,
        radius: 20,
        shape: ShapeLightFocus.RRect,
        contents: [
          TargetContent(
            align: ContentAlign.top,
            child: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 60),
                Text(
                  "Presiona aquí para iniciar sesión.",
                  style: TextStyle(
                    color: Color(0xfff3ece7),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: Text(
                    "¡Bienvenido de vuelta! Presiona el botón para iniciar sesión en tu cuenta.",
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
      _timerLOGIN = Timer(const Duration(seconds: 1), () {
        if (mounted) {
          showTutorialLOGIN();
        }
      });
    });
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    ); // Validación básica de email
    return emailRegex.hasMatch(email);
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Correo de restablecimiento enviado. Verifica tu bandeja de entrada.',
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error al enviar el correo: $e')));
    }
  }

  Future<void> promptForEmailAndSendReset() async {
    String? email = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        String tempEmail = '';
        return AlertDialog(
          title: const Text('Restablecer Contraseña'),
          content: TextField(
            onChanged: (value) {
              tempEmail = value;
            },
            decoration: const InputDecoration(
              labelText: 'Correo Electrónico',
              hintText: 'Introduce tu correo electrónico',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // Cancelar
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(tempEmail); // Confirmar
              },
              child: const Text('Enviar'),
            ),
          ],
        );
      },
    );

    if (email != null && email.isNotEmpty) {
      await sendPasswordResetEmail(email);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('El correo electrónico no puede estar vacío.'),
        ),
      );
    }
  }

  Future<void> _signIn() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // Validaciones antes de intentar iniciar sesión
    if (email.isEmpty && password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor rellena el campo Email y Contraseña.',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Color(0xfff4f4f4),
        ),
      );
      return;
    } else if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor completa el campo Email.',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Color(0xfff4f4f4),
        ),
      );

      return;
    } else if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor ingresa un correo electrónico válido.',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Color(0xfff4f4f4),
        ),
      );
      return;
    } else if (password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Por favor completa el campo Contraseña.',
            style: TextStyle(color: Colors.red),
          ),
          backgroundColor: Color(0xfff4f4f4),
        ),
      );
      return;
    }

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      User? user = userCredential.user;
      await user?.reload();

      if (user != null) {
        final DatabaseReference role = _dbRef.child(_basePath).child(user.uid);
        print('Rol obtenido: $role');

        role.once().then((DatabaseEvent event) {
          if (event.snapshot.exists) {
            final value = event.snapshot.value;
            if (value != null && value is Map) {
              String? name = value['email']?.toString();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '¡Inicio de sesión exitoso! Bienvenido, ${name}',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xfff3ece7),
                    ),
                  ),
                  duration: const Duration(seconds: 3),
                  backgroundColor: const Color.fromARGB(255, 126, 53, 0),
                ),
              );
              _checkUserRole(user);
            } else {
              setState(() {
                errorMessage =
                    'Los datos del usuario no son válidos o no tienen el formato esperado.';
              });
            }
          }
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        setState(() {
          errorMessage = 'La contraseña es incorrecta.';
        });
      } else if (e.code == 'user-not-found') {
        setState(() {
          errorMessage =
              'No se encontró un usuario con este correo electrónico.';
        });
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Las credenciales han caducado. Intenta nuevamente.';
        await _auth.signOut();
      } else {
        setState(() {
          errorMessage = 'Error al iniciar sesión, contraseña inexistente.';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error al iniciar sesión: $e';
      });
    }
  }

  Future<void> _checkUserRole(User user) async {
    final DatabaseReference userRef = _dbRef.child(_basePath).child(user.uid);

    userRef
        .once()
        .then((DatabaseEvent event) {
          if (event.snapshot.exists) {
            final value = event.snapshot.value;

            if (value != null && value is Map) {
              String? role = value['role']?.toString();

              if (role != null) {
                if (role == 'admin') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AdminScreen(),
                    ),
                  );
                } else if (role == 'Client') {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClientScreen(),
                    ),
                  );
                } else {
                  setState(() {
                    errorMessage = 'Rol desconocido.';
                  });
                }
              } else {
                setState(() {
                  errorMessage = 'Rol no encontrado.';
                });
              }
            } else {
              setState(() {
                errorMessage =
                    'Los datos del usuario no son válidos o no tienen el formato esperado.';
              });
            }
          } else {
            setState(() {
              errorMessage = 'Usuario no encontrado.';
            });
          }
        })
        .catchError((error) {
          setState(() {
            errorMessage = 'Error al obtener los datos del usuario: $error';
          });
        });
  }

  Future<void> _signUp() async {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const RegisterClientScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool obscureText = true;
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(
          56.0,
        ), // Ajusta la altura según sea necesario
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 126, 53, 0),
                Color.fromARGB(255, 126, 53, 0),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                offset: Offset(-10, 10),
                color: Color.fromARGB(80, 0, 0, 0),
                blurRadius: 10,
              ),
              BoxShadow(
                offset: Offset(-10, -10),
                color: Color.fromARGB(150, 255, 255, 255),
                blurRadius: 10,
              ),
            ],
          ),
          child: AppBar(
            title: const Text(
              'Iniciar Sesión',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xfff4f4f4),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            children: [
              Container(
                decoration: const BoxDecoration(color: Colors.transparent),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const SizedBox(height: 20),
                          Container(
                            decoration: const BoxDecoration(
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12.0),
                              child: Image.asset(
                                'assets/images/logoOscuro3.jpeg', // Reemplaza con la ruta de tu imagen
                                height:
                                    100, // Ajusta el tamaño según sea necesario
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Correo electrónico',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                TextField(
                                  key: _emailKeyLOGIN,
                                  controller: _emailController,
                                  decoration: const InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(221, 199, 77, 11),
                                      ), // Borde inferior negro
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromARGB(221, 199, 77, 11),
                                        width: 2,
                                      ),
                                    ),
                                    prefixIcon: Icon(
                                      Icons.email,
                                      color: Color.fromARGB(221, 199, 77, 11),
                                    ),
                                  ),
                                  keyboardType: TextInputType.emailAddress,
                                ),
                                const SizedBox(height: 16),
                                const Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Contraseña',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromARGB(255, 0, 0, 0),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                StatefulBuilder(
                                  builder: (context, setState) {
                                    return TextField(
                                      key: _passwordKeyLOGIN,
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: const Color.fromARGB(
                                              255,
                                              126,
                                              53,
                                              0,
                                            ),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              obscureText =
                                                  !obscureText; // Alterna la visibilidad
                                            });
                                          },
                                        ),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                  221,
                                                  199,
                                                  77,
                                                  11,
                                                ),
                                              ), // Borde inferior negro
                                            ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                color: Color.fromARGB(
                                                  221,
                                                  199,
                                                  77,
                                                  11,
                                                ),
                                                width: 2,
                                              ),
                                            ),
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color: Color.fromARGB(
                                            221,
                                            199,
                                            77,
                                            11,
                                          ),
                                        ),
                                      ),
                                      obscureText: obscureText,
                                    );
                                  },
                                ),
                                const SizedBox(height: 20),
                                ElevatedButton(
                                  key: _loginButtonKeyLOGIN,
                                  onPressed: _signIn,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color.fromARGB(
                                      255,
                                      126,
                                      53,
                                      0,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8.0,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      side: const BorderSide(
                                        color: Color(0xfff3ece7),
                                      ),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      'Iniciar Sesión',
                                      style: TextStyle(
                                        color: Color(0xfff3ece7),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                if (errorMessage.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Text(
                                      errorMessage,
                                      style: const TextStyle(color: Colors.red),
                                    ),
                                  ),
                                const SizedBox(height: 0),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                          '¿No tienes una cuenta?',
                                          style: TextStyle(
                                            color: Colors.black87,
                                          ),
                                        ),
                                        ElevatedButton(
                                          onPressed: _signUp,
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.transparent,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 8.0,
                                            ),
                                            elevation: 0,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8.0),
                                            child: Text(
                                              'Regístrate',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Color.fromARGB(
                                                  221,
                                                  199,
                                                  77,
                                                  11,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TextButton(
                                  onPressed: () async {
                                    // Abrir un cuadro de diálogo para pedir el correo electrónico
                                    String? email = await showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) {
                                        String tempEmail = '';
                                        return AlertDialog(
                                          title: const Text(
                                            'Restablecer Contraseña',
                                          ),
                                          content: StatefulBuilder(
                                            builder: (context, setState) {
                                              return TextField(
                                                onChanged: (value) {
                                                  tempEmail = value;
                                                },
                                                obscureText: obscureText,
                                                decoration: const InputDecoration(
                                                  labelText:
                                                      'Correo Electrónico',
                                                  hintText:
                                                      'Introduce tu correo electrónico',
                                                ),
                                              );
                                            },
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  context,
                                                ).pop(null); // Cancelar
                                              },
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(
                                                  context,
                                                ).pop(tempEmail); // Confirmar
                                              },
                                              child: const Text('Enviar'),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    // Validar el correo e intentar enviar el correo de restablecimiento
                                    if (email != null && email.isNotEmpty) {
                                      try {
                                        await FirebaseAuth.instance
                                            .sendPasswordResetEmail(
                                              email: email,
                                            );
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'Correo de restablecimiento enviado. Verifica tu bandeja de entrada.',
                                            ),
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              'Error al enviar el correo: $e',
                                            ),
                                          ),
                                        );
                                      }
                                    } else {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                            'El correo electrónico no puede estar vacío.',
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        '¿Olvidaste tu contraseña?',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color.fromARGB(
                                            221,
                                            199,
                                            77,
                                            11,
                                          ),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Icon(
                                        Icons.lock_reset,
                                        color: Color.fromARGB(221, 199, 77, 11),
                                        size: 30,
                                      ),
                                    ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
