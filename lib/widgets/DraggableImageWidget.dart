import 'package:flutter/material.dart';

class DraggableImageWidget extends StatefulWidget {
  final bool showImageAndLema;
  final String imagePath;

  const DraggableImageWidget({
    super.key,
    required this.showImageAndLema,
    required this.imagePath,
  });

  @override
  _DraggableImageWidgetState createState() => _DraggableImageWidgetState();
}

class _DraggableImageWidgetState extends State<DraggableImageWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _animation = Tween<Offset>(
      begin: const Offset(0, 0),
      end: const Offset(
          0, -0.1), // Ajusta el offset para mover la imagen más arriba
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.showImageAndLema
        ? Padding(
            padding: const EdgeInsets.all(40.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.height *
                        0.2, // Ajusta este valor para mover la imagen más arriba
                    left: 0,
                    right: 0,
                    child: AnimatedBuilder(
                      animation: _animationController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: _animation.value *
                              MediaQuery.of(context).size.height,
                          child: Container(
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: AssetImage(widget.imagePath),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Card(
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(40.0),
                            bottomRight: Radius.circular(40.0),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xfff9f8ff), Color(0xfff1f2f4)],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                            ),
                            color: const Color(0XFFF4F4F4).withOpacity(
                                0.8), // Color de fondo con opacidad
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(40.0),
                              bottomRight: Radius.circular(40.0),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                offset: Offset(10, 10),
                                color: Color.fromARGB(80, 0, 0, 0),
                                blurRadius: 10,
                              ),
                              BoxShadow(
                                  offset: Offset(-10, -10),
                                  color: Color.fromARGB(150, 255, 255, 255),
                                  blurRadius: 10),
                            ],
                          ),
                          child: const Padding(
                            padding: EdgeInsets.all(20.0),
                            child: Text(
                              "LA EXCELENCIA EN LA CRÍA DE CAMARÓN ES NUESTRA META, COSECHANDO CALIDAD, ENTREGANDO CONFIANZA",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Color.fromARGB(205, 35, 45, 50),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const SizedBox
            .shrink(); // Retorna un widget vacío si no se debe mostrar
  }
}
