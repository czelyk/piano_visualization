import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/piano_screen.dart';

import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Tam ekran, immersive mod
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF0A0A0F),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // Sadece dikey mod (Mobil için)
  if (!kIsWeb) {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  // Firebase başlat
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyCjRksDcuFtjvRmZlNW429uIBly8MX3g04",
        appId: "1:235582827759:web:manual_setup", // Not: Web App ID farklı olabilir
        messagingSenderId: "235582827759",
        projectId: "pianovisualization06",
        databaseURL: "https://pianovisualization06-default-rtdb.europe-west1.firebasedatabase.app",
        storageBucket: "pianovisualization06.firebasestorage.app",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  runApp(const PianoVisualizationApp());
}

class PianoVisualizationApp extends StatelessWidget {
  const PianoVisualizationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Piano Visualization',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A0F),
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF4D96FF),
          surface: Color(0xFF0A0A0F),
        ),
      ),
      home: const PianoScreen(),
    );
  }
}
