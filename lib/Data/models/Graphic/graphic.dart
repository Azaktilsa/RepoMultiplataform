import 'package:flutter/material.dart';

class GraphicsPage extends StatelessWidget {
  const GraphicsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body:
          Padding(padding: EdgeInsets.all(8.0), child: Text("Hello graphics")),
    );
  }
}
