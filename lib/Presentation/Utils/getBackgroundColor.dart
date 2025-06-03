import 'package:flutter/material.dart';

Color getBackgroundColor(String typeBackground) {
  switch (typeBackground) {
    case 'CAMANOVILLO':
      return const Color.fromARGB(255, 241, 238, 235);

    case 'EXCANCRIGRU':
      return const Color(0xffe2d7d4);

    case 'FERTIAGRO':
      return const Color.fromARGB(255, 230, 230, 230);

    case 'GROVITAL':
      return const Color.fromARGB(255, 196, 184, 184);

    case 'SUFAAZA':
      return const Color(0xffe2d5d5);

    case 'TIERRAVID':
      return const Color(0xffe2dfd7);

    default:
      return const Color.fromARGB(255, 241, 238, 235);
  }
}
