import 'package:flutter/material.dart';

List<Color> getGradientColors(String typeFinca) {
  switch (typeFinca) {
    case 'CAMANOVILLO':
      return [
        const Color.fromARGB(255, 241, 238, 235),
        const Color.fromARGB(255, 241, 238, 235)
      ];
    case 'EXCANCRIGRU':
      return [
        const Color(0xffe2d7d4),
        const Color(0xffe2d7d4),
      ];
    case 'FERTIAGRO':
      return [
        const Color.fromARGB(255, 230, 230, 230),
        const Color.fromARGB(255, 230, 230, 230)
      ];
    case 'GROVITAL':
      return [
        const Color.fromARGB(255, 196, 184, 184),
        const Color.fromARGB(255, 196, 184, 184),
      ];
    case 'SUFAAZA':
      return [
        const Color(0xffe2d5d5),
        const Color(0xffe2d5d5),
      ];
    case 'TIERRAVID':
      return [
        const Color(0xffe2dfd7),
        const Color(0xffe2dfd7),
      ];
    default:
      return [
        const Color.fromARGB(255, 241, 238, 235),
        const Color.fromARGB(255, 241, 238, 235)
      ];
  }
}
