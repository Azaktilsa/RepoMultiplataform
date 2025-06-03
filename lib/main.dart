import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:azaktilza/widgets/connectivity_service.dart';
import 'package:azaktilza/Routes/routes.dart';
import 'package:flutter/services.dart';
import 'package:azaktilza/env_loader.dart';
import 'package:azaktilza/widgets/RefreshWrapper.dart';
import 'package:azaktilza/widgets/RestartWidget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool hasConnection = await checkInternetConnection();

  if (hasConnection) {
    if (kIsWeb) {
      await EnvLoader.loadEnv();
      await Firebase.initializeApp(
        options: FirebaseOptions(
          apiKey: EnvLoader.get('API_KEY')!,
          authDomain: EnvLoader.get('AUTH_DOMAIN')!,
          databaseURL: EnvLoader.get('DATABASE_URL')!,
          projectId: EnvLoader.get('PROJECT_ID')!,
          storageBucket: EnvLoader.get('STORAGE_BUCKET')!,
          messagingSenderId: EnvLoader.get('MESSAGING_SENDER_ID')!,
          appId: EnvLoader.get('APP_ID')!,
          measurementId: EnvLoader.get('MEASUREMENT_ID')!,
        ),
      );
    } else {
      await dotenv.load(fileName: ".env");
      await Firebase.initializeApp();
      FirebaseDatabase.instance.setPersistenceEnabled(true);
    }
  }

  final pref = await SharedPreferences.getInstance();
  final seenOnboarding = pref.getBool('seenOnboarding') ?? false;

  runApp(
    RestartWidget(
      child: MyApp(seenOnboarding: seenOnboarding, isOnline: hasConnection),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;
  final bool isOnline;

  const MyApp({super.key, this.seenOnboarding = false, required this.isOnline});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.black,
          statusBarIconBrightness: Brightness.light,
        ),
      );
    });

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Terrawa',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: Color.fromARGB(255, 0, 0, 0),
          elevation: 0,
        ),
      ),
      home: RefreshWrapper(isOnline: isOnline, seenOnboarding: seenOnboarding),
      routes: routes,
    );
  }
}
