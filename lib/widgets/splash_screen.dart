// ignore_for_file: library_private_types_in_public_api

import 'package:azaktilza/widgets/AuthenticationWrapper.dart';
import 'package:flutter/material.dart';
import 'OnboardingScreen.dart';

class SplashScreen extends StatefulWidget {
  final bool seenOnboarding;
  const SplashScreen({super.key, required this.seenOnboarding});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2)); // Simula el splash

    if (!mounted)
      return; // Evita que se use context si el widget ya fue desmontado

    if (!widget.seenOnboarding) {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const OnboardingScreen()));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const AuthenticationWrapper()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff3ece7),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), // Bordes redondeados
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(
                        0, 3), // Cambia el desplazamiento de la sombra
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                    20), // Bordes redondeados de la imagen
                child: Image.asset(
                  'assets/images/logoOscuro3.jpeg',
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover, // Cambié esto para un ajuste más adecuado
                ),
              ),
            ),
            const SizedBox(height: 20), // Espaciado entre la imagen y el texto
            const Text(
              'TERRAWA',
              style: TextStyle(
                fontSize: 24,
                color: Color.fromARGB(255, 126, 53, 0), // Color del texto
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
