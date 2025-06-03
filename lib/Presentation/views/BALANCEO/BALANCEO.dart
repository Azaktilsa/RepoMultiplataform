// ignore_for_file: unused_import

import 'dart:math';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class BALANCEO_Screen extends StatefulWidget {
  const BALANCEO_Screen({Key? key}) : super(key: key);

  @override
  _BALANCEO_ScreenState createState() => _BALANCEO_ScreenState();
}

class _BALANCEO_ScreenState extends State<BALANCEO_Screen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30.0),
        child: SingleChildScrollView(
          child: Column(),
        ),
      ),
    );
  }
}
