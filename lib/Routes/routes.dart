import 'package:flutter/material.dart';

// Rutas principales
import 'package:azaktilza/Presentation/admin/admin_screen.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/CAMANOVILLO/CAMANOVILLO_Calculate.dart';
import 'package:azaktilza/Presentation/views/FINCAS/CAMANOVILLO/DatoCAMANOVILLO/Dato_CAMANOVILLO.dart';
import 'package:azaktilza/Presentation/views/FINCAS/CAMANOVILLO/GraficasCAMANOVILLO/GRAFICAS_CAMANOVILLO_Screen.dart';
import 'package:azaktilza/Presentation/views/FINCAS/EXCANCRIGRU/DatoEXCANCRIGRU/DatoEXCANCRIGRU.dart';
import 'package:azaktilza/Presentation/views/FINCAS/FERTIAGRO/Dato_FERTIAGRO/DatoFERTIAGRO.dart';
import 'package:azaktilza/Presentation/views/POBLACION/CAMANOVILLO/CAMANOVILLO_Poblacion.dart';
import 'package:azaktilza/Presentation/views/POBLACION/EXCANCRIGRU/EXCANCRIGRU_Poblacion_Screen.dart';
import 'package:azaktilza/Presentation/views/POBLACION/FERTIAGRO/FERTIAGRO_Poblacion_Screen.dart';
import 'package:azaktilza/Presentation/views/BALANCEO/BALANCEO.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/EXCANCRIGRU/EXCANCRIGRU_Calculate_Screen.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/FERTIAGRO/FERTIAGRO_Calculate_Screen.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/GROVITAL/GROVITAL_Calculate_Screen.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/SUFAAZA/SUFAAZA_Calculate_Screen.dart';
import 'package:azaktilza/Presentation/views/CALCULATE/TIERRAVID/TIERRAVID_Calculate_Screen.dart';
import 'package:azaktilza/Presentation/views/FINCAS/EXCANCRIGRU/GraficasEXCANCRIGRU/GRAFICAS_EXCANCRIGRU_Screen.dart';
import 'package:azaktilza/Presentation/views/FINCAS/FERTIAGRO/GraficasFERTIAGRO/GRAFICAS_FERTIAGRO_Screen.dart';
import 'package:azaktilza/Presentation/views/FINCAS/GROVITAL/Dato_GROVITAL/DatoGROVITAL.dart';
import 'package:azaktilza/Presentation/views/FINCAS/GROVITAL/GraficasGROVITAL/GRAFICAS_GROVITAL_Screen.dart';
import 'package:azaktilza/Presentation/views/FINCAS/SUFAAZA/Dato_SUFAAZA/DatoSUFAAZA.dart';
import 'package:azaktilza/Presentation/views/FINCAS/SUFAAZA/GraficasSUFAAZA/GRAFICAS_SUFAAZA_Screen.dart';
import 'package:azaktilza/Presentation/views/FINCAS/TIERRAVID/Dato_TIERRAVID/DatoTIERRAVID.dart';
import 'package:azaktilza/Presentation/views/FINCAS/TIERRAVID/GraficasTIERRAVID/GRAFICAS_TIERRAVID_Screen.dart';

import 'package:azaktilza/Presentation/views/POBLACION/GROVITAL/GROVITAL_Poblacion_Screen.dart';
import 'package:azaktilza/Presentation/views/POBLACION/SUFAAZA/SUFAAZA_Poblacion_Screen.dart';
import 'package:azaktilza/Presentation/views/POBLACION/TIERRAVID/TIERRAVID_Poblacion_Screen.dart';
import 'package:azaktilza/Routes/Login.dart';

final Map<String, WidgetBuilder> routes = {
  // General Screens
  '/login': (context) => const LoginScreen(),
  '/admin': (context) => const AdminScreen(),

  // CAMANOVILLO Screens
  '/camanovillo/data': (context) => const DatoCAMANOVILLO_Screen(),
  '/camanovillo/poblacion': (context) => const Poblacion_CAMANOVILLO_Screen(),
  '/camanovillo/grafica': (context) => const GRAFICAS_CAMANOVILLO_Screen(),
  '/camanovillo/calculate': (context) => const Calculate_CAMANOVILLO_Screen(),

  // EXCANCRIGRU Screens
  '/excancrigru/data': (context) => const DatoEXCANCRIGRU_Screen(),
  '/excancrigru/poblacion': (context) => const Poblacion_EXCANCRIGRU_Screen(),
  '/excancrigru/grafica': (context) => const GRAFICAS_EXCANCRIGRU_Screen(),
  '/excancrigru/calculate': (context) => const Calculate_EXCANCRIGRU_Screen(),

  // FERTIAGRO Screens
  '/fertiagro/data': (context) => const DatoFERTIAGRO_Screen(),
  '/fertiagro/poblacion': (context) => const Poblacion_FERTIAGRO_Screen(),
  '/fertiagro/grafica': (context) => const GRAFICAS_FERTIAGRO_Screen(),
  '/fertiagro/calculate': (context) => const Calculate_FERTIAGRO_Screen(),

  // GROVITAL Screens
  '/grovital/data': (context) => const DatoGROVITAL_Screen(),
  '/grovital/poblacion': (context) => const Poblacion_GROVITAL_Screen(),
  '/grovital/grafica': (context) => const GRAFICAS_GROVITAL_Screen(),
  '/grovital/calculate': (context) => const Calculate_GROVITAL_Screen(),

  // SUFAAZA Screens
  '/sufaaza/data': (context) => const DatoSUFAAZA_Screen(),
  '/sufaaza/poblacion': (context) => const Poblacion_SUFAAZA_Screen(),
  '/sufaaza/grafica': (context) => const GRAFICAS_SUFAAZA_Screen(),
  '/sufaaza/calculate': (context) => const Calculate_SUFAAZA_Screen(),

  // TIERRAVID Screens
  '/tierravid/data': (context) => const DatoTIERRAVID_Screen(),
  '/tierravid/poblacion': (context) => const Poblacion_TIERRAVID_Screen(),
  '/tierravid/grafica': (context) => const GRAFICAS_TIERRAVID_Screen(),
  '/tierravid/calculate': (context) => const Calculate_TIERRAVID_Screen(),

  // Other Screens
  '/balanceo': (context) => const BALANCEO_Screen(),
  '/calculate': (context) => const Center(child: Text("Calculadora Alimento")),
};
