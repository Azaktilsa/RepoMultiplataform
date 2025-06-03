import 'package:azaktilza/Presentation/admin/admin_screen.dart';
import 'package:azaktilza/Presentation/client/client_screen.dart';
import 'package:azaktilza/Routes/Login.dart';
import 'package:azaktilza/env_loader.dart';
import 'package:azaktilza/widgets/offline_screen.dart';
import 'package:azaktilza/widgets/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  String _getDatabasePath(DatabaseReference _dbRef) {
    if (kIsWeb) {
      // 2. Configuración para WEB
      return EnvLoader.get('CONTROL')!;
    } else {
      // 3. Configuración para MÓVIL
      return dotenv.env['CONTROL']!;
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DatabaseReference tempDbRef = FirebaseDatabase.instance.ref();
      final databasePath = _getDatabasePath(tempDbRef);
      DatabaseReference _dbRef = FirebaseDatabase.instance.ref(databasePath);

      return FutureBuilder<DatabaseEvent>(
        future: _dbRef.child(user.uid).once(),
        builder: (context, roleSnapshot) {
          if (roleSnapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen(seenOnboarding: true);
          }

          if (roleSnapshot.hasError) {
            return const OfflineScreen();
          }

          if (!roleSnapshot.hasData ||
              roleSnapshot.data!.snapshot.value == null) {
            return const LoginScreen();
          }

          var userData =
              roleSnapshot.data!.snapshot.value as Map<dynamic, dynamic>;
          String role = userData['role'] ?? '';

          if (role == 'Client') {
            return const ClientScreen();
          } else if (role == 'admin') {
            return const AdminScreen();
          } else {
            return const Center(
              child: Text(
                'Rol no reconocido.',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            );
          }
        },
      );
    } else {
      return const LoginScreen();
    }
  }
}
