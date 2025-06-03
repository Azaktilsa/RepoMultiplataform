import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;

class EnvLoader {
  static Map<String, String> _env = {};

  static Future<void> loadEnv() async {
    try {
      final content = await rootBundle.loadString('assets/env.txt');
      _env = _parseEnv(content);
    } catch (e) {
      print("⚠️ No se pudo cargar env.txt: $e");
    }
  }

  static String? get(String key) => _env[key];

  static Map<String, String> _parseEnv(String content) {
    final lines = content.split('\n');
    final env = <String, String>{};
    for (var line in lines) {
      line = line.trim();
      if (line.isEmpty || line.startsWith('#')) continue;
      final parts = line.split('=');
      if (parts.length == 2) {
        env[parts[0].trim()] = parts[1].trim();
      }
    }
    return env;
  }
}
