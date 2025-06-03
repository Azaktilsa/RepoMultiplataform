// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:azaktilza/Presentation/admin/admin_screen.dart';
import 'package:azaktilza/Presentation/client/client_screen.dart';
import 'package:azaktilza/Routes/Login.dart';

class RegisterClientScreen extends StatefulWidget {
  const RegisterClientScreen({super.key});

  @override
  _RegisterClientScreenState createState() => _RegisterClientScreenState();
}

class _RegisterClientScreenState extends State<RegisterClientScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('Empresas/Terrawaazaktilzalyng/Control');
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _redirectToRole(String email) async {
    try {
      final snapshot =
          await _database.orderByChild('email').equalTo(email).get();
      if (snapshot.exists) {
        final data = (snapshot.value as Map).values.first as Map;
        final role = data['role'];

        if (role == 'Client') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ClientScreen()),
          );
        } else if (role == 'Admin') {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const AdminScreen()),
          );
        } else {
          _showErrorDialog('Rol desconocido.');
        }
      } else {
        _showErrorDialog('No se encontró información para este usuario.');
      }
    } catch (e) {
      _showErrorDialog('Error al redirigir: ${e.toString()}');
    }
  }

  Future<void> _registerClient() async {
    setState(() {
      _isLoading = true;
    });

    // Validar correo electrónico
    if (!_emailController.text.trim().contains('@')) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('Por favor, ingrese un correo electrónico válido.');
      return;
    }

    // Validar contraseña
    if (_passwordController.text.trim().isEmpty) {
      setState(() {
        _isLoading = false;
      });
      _showErrorDialog('La contraseña no puede estar vacía.');
      return;
    }

    try {
      // Crear el usuario en Firebase Authentication
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Guardar la información del Client en Firebase Realtime Database
      if (userCredential.user != null) {
        await _database.child(userCredential.user!.uid).set({
          'email': _emailController.text.trim(),
          'role': 'Client', // Asignando el rol
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Client registrado exitosamente')),
        );

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ClientScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        // El correo ya está en uso, redirigir basado en el rol
        await _redirectToRole(_emailController.text.trim());
      } else {
        _showErrorDialog('Error: ${e.message}');
      }
    } catch (e) {
      _showErrorDialog('Error: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _obscureText = true;
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      appBar: PreferredSize(
        preferredSize:
            const Size.fromHeight(56.0), // Ajusta la altura según sea necesario
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
              'Registrate',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Color(0xfff4f4f4),
              ),
            ),
            backgroundColor:
                Colors.transparent, // Fondo transparente para usar la sombra
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.transparent,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(
                              0xffe9f0f0), // Aquí se aplica el color al borde
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
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
                                        'Nombre',
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
                                    controller: _nameController,
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(221, 199, 77, 11),
                                        ), // Borde inferior negro
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                221, 199, 77, 11),
                                            width: 2),
                                      ),
                                      prefixIcon: Icon(
                                        Icons.person_3_rounded,
                                        color: Color.fromARGB(221, 199, 77, 11),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
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
                                    controller: _emailController,
                                    decoration: const InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(221, 199, 77, 11),
                                        ), // Borde inferior negro
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                221, 199, 77, 11),
                                            width: 2),
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
                                  StatefulBuilder(builder: (context, setState) {
                                    return TextField(
                                      controller: _passwordController,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _obscureText
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: const Color.fromARGB(
                                                255, 126, 53, 0),
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              _obscureText =
                                                  !_obscureText; // Alterna la visibilidad
                                            });
                                          },
                                        ),
                                        enabledBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                221, 199, 77, 11),
                                          ), // Borde inferior negro
                                        ),
                                        focusedBorder:
                                            const UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Color.fromARGB(
                                                  221, 199, 77, 11),
                                              width: 2),
                                        ),
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color:
                                              Color.fromARGB(221, 199, 77, 11),
                                        ),
                                      ),
                                      obscureText: _obscureText,
                                    );
                                  }),
                                  const SizedBox(height: 24),
                                  ElevatedButton(
                                    onPressed: _registerClient,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromARGB(255, 126, 53, 0),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
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
                                        'Registrarse',
                                        style: TextStyle(
                                          color: Color(0xfff3ece7),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        '¿Ya tienes una cuenta?',
                                        style: TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushReplacement(
                                            PageRouteBuilder(
                                              pageBuilder: (context, animation,
                                                      secondaryAnimation) =>
                                                  const LoginScreen(),
                                              transitionsBuilder: (context,
                                                  animation,
                                                  secondaryAnimation,
                                                  child) {
                                                return SlideTransition(
                                                  position: Tween<Offset>(
                                                    begin:
                                                        const Offset(1.0, 0.0),
                                                    end: Offset.zero,
                                                  ).animate(animation),
                                                  child: child,
                                                );
                                              },
                                            ),
                                          );
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text(
                                            'Iniciar sesión',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromARGB(
                                                  221, 199, 77, 11),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
