import 'package:flutter/material.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

List<TargetFocus> buildTutorialTargetsDATO({
  required GlobalKey selectPiscinaKey,
  required GlobalKey beforeKey,
  required GlobalKey afterKey,
  required GlobalKey pesoKey,
  required GlobalKey consumoKey,
  required GlobalKey calcularKey,
  required GlobalKey resetTutorialKey,
}) {
  return [
    TargetFocus(
      identify: "SelectPiscina",
      keyTarget: selectPiscinaKey,
      alignSkip: Alignment.bottomRight,
      radius: 20,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text("Configura tu terreno",
                  style: TextStyle(
                      color: Color(0xfff3ece7),
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Selecciona las hectáreas y la cantidad de alimento en gramos para obtener el mejor rendimiento.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    TargetFocus(
      identify: "Before",
      keyTarget: beforeKey,
      alignSkip: Alignment.bottomRight,
      radius: 20,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text("Retroceder Pagina",
                  style: TextStyle(
                      color: Color(0xfff3ece7),
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Da click para retroceder a la página anterior.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    TargetFocus(
      identify: "After",
      keyTarget: afterKey,
      alignSkip: Alignment.bottomRight,
      radius: 20,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text("Avanzar Pagina",
                  style: TextStyle(
                      color: Color(0xfff3ece7),
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Da click para avanzar a la página siguiente.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    TargetFocus(
      identify: "Peso",
      keyTarget: pesoKey,
      alignSkip: Alignment.bottomRight,
      radius: 20,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text("Peso del camarón",
                  style: TextStyle(
                      color: Color(0xfff3ece7),
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Indica el peso promedio del camarón en gramos para afinar los cálculos.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    TargetFocus(
      identify: "Consumo",
      keyTarget: consumoKey,
      alignSkip: Alignment.bottomRight,
      radius: 20,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text("Consumo diario",
                  style: TextStyle(
                      color: Color(0xfff3ece7),
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Ingresa la cantidad de alimento consumido en gramos para realizar un cálculo preciso.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    TargetFocus(
      identify: "Calcular",
      keyTarget: calcularKey,
      alignSkip: Alignment.topCenter,
      radius: 20,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("¡Hora de calcular!",
                  style: TextStyle(
                      color: Color(0xfff3ece7),
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Presiona el botón para obtener los resultados y optimizar tu producción.",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
    TargetFocus(
      identify: "ResetTutorialDATO",
      keyTarget: resetTutorialKey,
      alignSkip: Alignment.topRight,
      radius: 20,
      shape: ShapeLightFocus.RRect,
      contents: [
        TargetContent(
          align: ContentAlign.top,
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30),
              Text("Reinicia el tutorial",
                  style: TextStyle(
                      color: Color(0xfff3ece7),
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: Text(
                  "Si deseas volver a ver el tutorial, presiona este botón.",
                  style: TextStyle(color: Color(0xfff3ece7), fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  ];
}
