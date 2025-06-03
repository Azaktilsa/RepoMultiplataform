import 'package:flutter/material.dart';

class CalculateButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Key buttonKey;

  const CalculateButton({
    super.key,
    required this.onPressed,
    required this.buttonKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
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
            key: buttonKey,
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 24.0,
              ),
            ),
            child: const Text(
              'Calcular',
              style: TextStyle(
                fontSize: 18,
                color: Color(0xfff3ece7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
