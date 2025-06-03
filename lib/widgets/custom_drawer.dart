import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menú'),
          ),
          ListTile(
            title: const Text('CAMANOVILLO'),
            onTap: () {
              Navigator.pushNamed(context, '/camanovillo/data');
            },
          ),
          ListTile(
            title: const Text('EXCANCRIGRU'),
            onTap: () {
              Navigator.pushNamed(context, '/excancrigru/data');
            },
          ),
          ListTile(
            title: const Text('FERTIAGRO'),
            onTap: () {
              Navigator.pushNamed(context, '/fertiagro/data');
            },
          ),
        ],
      ),
    );
  }
}
