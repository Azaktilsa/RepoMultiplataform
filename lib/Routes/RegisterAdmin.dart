// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:azaktilza/Presentation/admin/admin_screen.dart';

class RegisterAdminScreen extends StatefulWidget {
  const RegisterAdminScreen({super.key});

  @override
  _RegisterAdminScreenState createState() => _RegisterAdminScreenState();
}

class _RegisterAdminScreenState extends State<RegisterAdminScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('Empresas/TerrawaSufalyng/Control');
  bool _isLoading = false;

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

  Future<void> _registerAdmin() async {
    setState(() {
      _isLoading = true;
    });

    // Validar correo electrónico
    if (!_emailController.text.trim().contains('@')) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      _showErrorDialog('Por favor, ingrese un correo electrónico válido.');
      return;
    }

    // Validar contraseña
    if (_passwordController.text.trim().isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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

      // Guardar la información del administrador en Firebase Realtime Database
      if (userCredential.user != null) {
        print('User UID: ${userCredential.user!.uid}'); // Para depuración
        await _database.child(userCredential.user!.uid).set({
          'email': _emailController.text.trim(),
          'role': 'admin', // Asignando el rol
        });

        // Mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Administrador registrado exitosamente')),
        );

        // Redirigir a la pantalla AdminScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AdminScreen()),
        );
      }
    } catch (e) {
      print(e.toString());
      if (mounted) {
        _showErrorDialog(
            'Error: No se pudo registrar el administrador. ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      appBar: AppBar(
        title: const Text('Registrar Administrador'),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _registerAdmin,
                  child: const Text('Registrar Administrador'),
                ),
              ],
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
