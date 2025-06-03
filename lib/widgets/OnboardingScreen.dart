import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _saveOnboardingSeen();
  }

  Future<void> _saveOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenOnboarding', true);
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _OnboardingPage(
        title: "Bienvenido",
        description:
            "Descubre cómo nuestra app potencia tu negocio de camarones.",
        icon: MdiIcons.fish,
      ),
      _OnboardingPage(
        title: "Gestión de Alimentación",
        description:
            "Calcula la alimentación de tus camarones con predicciones a futuro.",
        icon: Icons.calculate,
      ),
      _OnboardingPage(
        title: "Gráficas",
        description: "Visualiza el rendimiento y evolución de la alimentación.",
        icon: Icons.show_chart,
      ),
      _OnboardingPage(
        title: "Comienza ahora",
        description:
            "Inicia el cálculo y optimización de la alimentación de tus camarones.",
        icon: Icons.arrow_forward,
      ),
    ];

    return Scaffold(
      body: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        color: _currentIndex.isEven
            ? const Color(0xfff3ece7)
            : const Color(0xffdedede),
        child: Stack(
          children: [
            PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              onPageChanged: (index) => setState(() => _currentIndex = index),
              itemBuilder: (_, index) => pages[index],
            ),
            Positioned(
              top: 50,
              right: 20,
              child: _currentIndex < pages.length - 1
                  ? TextButton(
                      onPressed: () =>
                          Navigator.pushReplacementNamed(context, '/login'),
                      child: const Text("Saltar",
                          style:
                              TextStyle(fontSize: 16, color: Colors.black54)),
                    )
                  : const SizedBox(),
            ),
            Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pages.length,
                  (index) => _DotIndicator(isActive: _currentIndex == index),
                ),
              ),
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: _currentIndex == pages.length - 1
                    ? Center(
                        child: ElevatedButton(
                          onPressed: () =>
                              Navigator.pushReplacementNamed(context, '/login'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(221, 199, 77, 11),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 15),
                          ),
                          child: const Text("Comenzar",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title, description;
  final IconData icon;

  const _OnboardingPage(
      {required this.title, required this.description, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 120, color: const Color.fromARGB(221, 199, 77, 11))
            .animate()
            .fadeIn()
            .scale(),
        const SizedBox(height: 20),
        Text(title,
                style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87))
            .animate()
            .fadeIn(duration: const Duration(milliseconds: 800)),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, color: Colors.black54))
              .animate()
              .fadeIn(duration: const Duration(milliseconds: 1000)),
        ),
      ],
    );
  }
}

class _DotIndicator extends StatelessWidget {
  final bool isActive;
  const _DotIndicator({required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 6),
      width: isActive ? 16 : 12,
      height: isActive ? 16 : 12,
      decoration: BoxDecoration(
        color: isActive ? const Color.fromARGB(221, 199, 77, 11) : Colors.grey,
        shape: BoxShape.circle,
      ),
    );
  }
}
